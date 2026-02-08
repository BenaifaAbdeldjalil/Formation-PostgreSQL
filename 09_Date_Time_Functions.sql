/* ==============================================================================
   POSTGRESQL – FONCTIONS DATE & HEURE (AVEC EXPLICATIONS)
   
   NOW() AS now_timestamp,             -- Renvoie la date et l’heure actuelles (avec timezone)
   CURRENT_DATE AS current_date,        -- Renvoie uniquement la date du jour
   CURRENT_TIME AS current_time,        -- Renvoie uniquement l’heure actuelle
   CURRENT_TIMESTAMP AS current_timestamp -- Équivalent standard SQL de NOW()
=============================================================================== */

/* ==============================================================================
   1. DATE & HEURE ACTUELLES
=============================================================================== */

SELECT
    NOW() AS now_timestamp,             -- Renvoie la date et l’heure actuelles (avec timezone)
    CURRENT_DATE AS current_date,        -- Renvoie uniquement la date du jour
    CURRENT_TIME AS current_time,        -- Renvoie uniquement l’heure actuelle
    CURRENT_TIMESTAMP AS current_timestamp -- Équivalent standard SQL de NOW()
;

/* Précision sur l’heure (nombre de chiffres après la virgule) */
SELECT
    CURRENT_TIME(2) AS time_precision,         -- Heure avec 2 décimales
    CURRENT_TIMESTAMP(3) AS timestamp_precision -- Timestamp avec 3 décimales
;

/* Fonctions locales (sans timezone) */
SELECT
    LOCALTIME AS local_time,               -- Heure locale sans timezone
    LOCALTIMESTAMP AS local_timestamp,     -- Timestamp local sans timezone
    LOCALTIME(1) AS local_time_precision,  -- Heure locale avec précision
    LOCALTIMESTAMP(1) AS local_timestamp_precision,  --2026-01-30 22:56:26.600
    LOCALTIMESTAMP(2) AS local_timestamp_precision,  --2026-01-30 22:56:26.660
    LOCALTIMESTAMP(3) AS local_timestamp_precision  --2026-01-30 22:56:26.664
;

/* ==============================================================================
   2. EXTRACTION DES PARTIES D’UNE DATE
=============================================================================== */

SELECT
    orderid,
    orderdate,
    TO_CHAR(orderdate, 'Day') AS nom_jour,
    -- Nom du jour en toutes lettres
    TO_CHAR(orderdate, 'Month') AS nom_mois,
    -- Nom du mois en toutes lettres
    EXTRACT(YEAR FROM orderdate) AS annee,
    -- Extrait l’année sous forme numérique
    EXTRACT(MONTH FROM orderdate) AS mois,
    -- Extrait le mois (1–12)
    EXTRACT(DAY FROM orderdate) AS jour,
    -- Extrait le jour du mois
    EXTRACT(QUARTER FROM orderdate) AS trimestre,
    -- Extrait le trimestre (1–4)
    EXTRACT(WEEK FROM orderdate) AS semaine
    -- Numéro de la semaine
FROM orders;

/* ==============================================================================
   3. DATE_TRUNC() – AGRÉGATION PAR PÉRIODE
=============================================================================== */

SELECT
    EXTRACT(YEAR FROM orderdate) AS annee,
    -- Extrait l’année sous forme numérique

    COUNT(*) AS nombre_commandes
    -- Compte le nombre de commandes par année
FROM orders
GROUP BY EXTRACT(YEAR FROM orderdate);

/* ==============================================================================
   4. FIN DU MOIS (équivalent EOMONTH)
=============================================================================== */

SELECT
    orderid,
    orderdate,
    DATE_TRUNC('month', orderdate)
        + INTERVAL '1 month'
        - INTERVAL '1 day' AS fin_du_mois,
 DATE_TRUNC('month', orderdate)
        + INTERVAL '1 month' AS un_mois_plus,
 DATE_TRUNC('month', orderdate)
        - INTERVAL '1 day' AS un_jours_moins,
 DATE_TRUNC('month', orderdate)
        + INTERVAL '1 year' AS une_annee_plus,
 
DATE_TRUNC('month', orderdate)::date AS date

FROM orders;


/* ==============================================================================
   5. EXTRACT (YEAR / MONTH / DAY) – CAS PRATIQUES
=============================================================================== */

SELECT
    EXTRACT(YEAR FROM order_date) AS order_year
    -- Récupère l’année de la date de commande
FROM  orders;

SELECT *
FROM  orders
WHERE EXTRACT(MONTH FROM order_date) = 2;
-- Filtre uniquement les commandes du mois de février

/* ==============================================================================
   6. TO_CHAR() – FORMATAGE DES DATES
=============================================================================== */

SELECT
    order_id,
    creation_time,

    TO_CHAR(creation_time, 'YYYY-MM-DD') AS format_iso,
    -- Format ISO standard

    TO_CHAR(creation_time, 'DD-MM-YYYY') AS format_eu,
    -- Format européen

    TO_CHAR(creation_time, 'HH24:MI:SS') AS heure,
    -- Affichage de l’heure

    TO_CHAR(creation_time, 'FMDay FMMonth') AS date_lisible
    -- Affichage lisible sans espaces (FM = Fill Mode)
FROM  orders;

/* ==============================================================================
   7. CAST() – CONVERSION DE TYPES
=============================================================================== */

SELECT
    CAST('2025-08-20' AS DATE) AS texte_vers_date,
    -- Convertit un texte en date

    CAST(NOW() AS DATE) AS timestamp_vers_date
    -- Supprime l’heure d’un timestamp
;

/* ==============================================================================
   8. AJOUT / SOUSTRACTION DE DATES
=============================================================================== */

SELECT
    order_date,
    order_date + INTERVAL '10 days' AS nouvelle_date
    -- Ajoute 10 jours à la date
FROM  orders;

SELECT
    order_date,
    order_date + INTERVAL '3 months' AS apres_3_mois,
    order_date + INTERVAL '1 year' AS apres_1_an
    -- Ajoute des mois et des années
FROM  orders;

/* ==============================================================================
   9. CALCUL DES DIFFÉRENCES DE DATES
=============================================================================== */

select
	orderid,
    orderdate,
    shipdate,
    AGE(shipdate,orderdate ) AS duree_livraison
    -- Calcule la différence sous forme d’intervalle lisible
FROM formation_sql.ordersarchive;

----------------
select
	orderid,
    orderdate,
    shipdate,
    shipdate-orderdate AS duree_livraison
    -- Calcule la différence sous forme d’intervalle lisible
FROM formation_sql.ordersarchive;

/* ==============================================================================
   10. AGE() & JUSTIFY_DAYS()
=============================================================================== */
--AGE(date_recente, date_ancienne)
SELECT
    employeeid,
    birthdate,
    AGE(NOW(), birthdate) AS age_complet,
    -- Calcule l’âge exact (années, mois, jours)
    AGE(birthdate, NOW()) AS age_complet_inverse
    -- Calcule l’âge exact (années, mois, jours)
FROM employees;
-------
SELECT
    JUSTIFY_DAYS(INTERVAL '40 days') AS interval_normalise,
    -- Convertit 30 jours en 1 mois + reste en jours,
JUSTIFY_DAYS(INTERVAL '90 days') AS interval_normalise
-- Convertit 30 jours en 1 mois + reste en jours;
