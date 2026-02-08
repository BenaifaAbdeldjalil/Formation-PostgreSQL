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
    CURRENT_TIMESTAMP AS current_timestamp, -- Équivalent standard SQL de NOW()
    LOCALTIMESTAMP  AS LOCALTIMESTAMP -- Équivalent standard SQL de NOW()
;

/* Précision sur l’heure (nombre de chiffres après la virgule) */
select
	CURRENT_TIME AS time_precision,  -- Heure
    CURRENT_TIME(3) AS time_precision_3,         -- Heure avec 1 décimales
    CURRENT_TIME(0) AS time_precision_0,         -- Heure avec 3 décimales
    CURRENT_TIMESTAMP(3) AS timestamp_precision, -- Timestamp avec 3 décimales
    CURRENT_TIMESTAMP(1) AS timestamp_precision1,
    CURRENT_TIMESTAMP(2) AS timestamp_precision2 -- Timestamp avec 1 décimales
;

/* Fonctions locales (sans timezone) */
SELECT
    LOCALTIME AS local_time,               -- Heure locale sans timezone
    LOCALTIMESTAMP AS local_timestamp,     -- Timestamp local sans timezone
    LOCALTIME(1) AS local_time_precision,  -- Heure locale avec précision
    LOCALTIMESTAMP(1) AS local_timestamp_precision1,  --2026-01-30 22:56:26.600
    LOCALTIMESTAMP(2) AS local_timestamp_precision2,  --2026-01-30 22:56:26.660
    LOCALTIMESTAMP(3) AS local_timestamp_precision3  --2026-01-30 22:56:26.664
;

/* ==============================================================================
   2. EXTRACTION DES PARTIES D’UNE DATE
=============================================================================== */
---text

SELECT
    orderid,
    orderdate
FROM orders;


SELECT
    orderid,
    orderdate,
    TO_CHAR(orderdate, 'Day') AS nom_jour,
    -- Nom du jour en toutes lettres
    TO_CHAR(orderdate, 'Month') AS nom_mois
FROM orders;
----

SELECT
    orderid,
    orderdate,
    now() as day_date,
    TO_CHAR(now(), 'Day') AS nom_jour,
    -- Nom du jour en toutes lettres
    TO_CHAR(orderdate, 'Month') AS nom_mois
FROM orders;

----numeric
SELECT
    orderid,
    orderdate,
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

----assemblage
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

 DATE_TRUNC('month', NOW())
        + INTERVAL '1 month'
        - INTERVAL '1 day' AS fin_du_mois,
 DATE_TRUNC('month', NOW())
        + INTERVAL '1 month' AS un_mois_plus,
 DATE_TRUNC('month', NOW())
        - INTERVAL '1 day' AS un_jours_moins,
 DATE_TRUNC('month', NOW())
        + INTERVAL '1 year' AS une_annee_plus,
DATE_TRUNC('month', NOW())::date AS date



SELECT
    orderid,
    orderdate,
    DATE_TRUNC( 'day', orderdate ) AS nom_jour

    from orders;
----------
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
    EXTRACT(YEAR FROM orderdate) AS order_year
    -- Récupère l’année de la date de commande
FROM  orders;

SELECT EXTRACT(MONTH FROM orderdate),*
FROM  orders
WHERE EXTRACT(MONTH FROM orderdate) = 2;
-- Filtre uniquement les commandes du mois de février

/* ==============================================================================
   6. TO_CHAR() – FORMATAGE DES DATES
=============================================================================== */

SELECT
    orderid,
    orderdate,
    TO_CHAR(orderdate, 'YYYY-MM-DD') AS format_iso,
    -- Format ISO standard
    TO_CHAR(orderdate, 'DD-MM-YYYY') AS format_eu,
    -- Format européen
    TO_CHAR(orderdate, 'HH24:MI:SS') AS heure,
    -- Affichage de l’heure
    TO_CHAR(orderdate, 'FMDay FMMonth') AS date_lisible
    -- Affichage lisible sans espaces (FM = Fill Mode)
FROM  orders;


----date non text
SELECT
    orderid,
    creationtime,
    TO_CHAR(orderdate, 'YYYY-MM-DD') AS format_iso
FROM  orders;

SELECT
    orderid,
    creationtime
FROM  orders;


/* ==============================================================================
   7. CAST() – CONVERSION DE TYPES
=============================================================================== */

SELECT
    CAST('2025-08-20' AS DATE) AS texte_vers_date,
    -- Convertit un texte en date
    TO_CHAR( CAST(creationtime AS DATE), 'YYYY-MM-DD')  AS timestamp_vers_date
    -- Supprime l’heure d’un timestamp
FROM  orders;

----- alternative
SELECT
    '2025-08-20' :: DATE as texte_vers_date,
    -- Convertit un texte en date
    creationtime:: DATE AS timestamp_vers_date
    -- Supprime l’heure d’un timestamp
FROM  orders;

/* ==============================================================================
   8. AJOUT / SOUSTRACTION DE DATES
=============================================================================== */

SELECT
    orderdate,
    orderdate + INTERVAL '10 days' AS nouvelle_date
    -- Ajoute 10 jours à la date
FROM  orders;

SELECT
    orderdate,
    orderdate + INTERVAL '3 months' AS apres_3_mois,
    orderdate + INTERVAL '1 year' AS apres_1_an
    -- Ajoute des mois et des années
FROM  orders;

/* ==============================================================================
   9. CALCUL DES DIFFÉRENCES DE DATES
=============================================================================== */
select
	orderid,
    orderdate,
    shipdate
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
select

JUSTIFY_DAYS(INTERVAL '40 days') AS interval_normalise, --40 days  ----> 1 mon 10 days
    -- Convertit 30 jours en 1 mois + reste en jours,
JUSTIFY_DAYS(INTERVAL '90 days') AS interval_normalise  --90 days  ---> 3 mons
-- Convertit 30 jours en 1 mois + reste en jours;
