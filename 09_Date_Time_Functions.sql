/* ==============================================================================
   POSTGRESQL — FONCTIONS DATE & HEURE
   Objectif :
   Comprendre comment récupérer, manipuler, analyser et afficher
   les dates et heures dans PostgreSQL.
============================================================================== */


/* ==============================================================================
   1. DATE & HEURE ACTUELLES
============================================================================== */

SELECT
    NOW()                AS now_timestamp,      -- Date + heure actuelles (avec timezone)
    CURRENT_DATE         AS current_date,       -- Date du jour
    CURRENT_TIME         AS current_time,       -- Heure actuelle
    CURRENT_TIMESTAMP    AS current_timestamp,  -- Équivalent SQL standard de NOW()
    LOCALTIMESTAMP       AS local_timestamp;    -- Date + heure sans timezone


/* ==============================================================================
   2. PRÉCISION DES TIMESTAMPS
   (nombre de chiffres après la virgule pour les secondes)
============================================================================== */

SELECT
    CURRENT_TIME(0)        AS heure_sans_ms,
    CURRENT_TIME(3)        AS heure_avec_ms,
    CURRENT_TIMESTAMP(3)   AS timestamp_ms,
    CURRENT_TIMESTAMP(1)   AS timestamp_precision_1;


/* ==============================================================================
   3. EXTRACTION DES INFORMATIONS D’UNE DATE (EXTRACT)
   → Retourne des VALEURS NUMÉRIQUES
============================================================================== */

SELECT
    orderid,
    orderdate,
    EXTRACT(YEAR    FROM orderdate) AS annee,
    EXTRACT(MONTH   FROM orderdate) AS mois,
    EXTRACT(DAY     FROM orderdate) AS jour,
    EXTRACT(QUARTER FROM orderdate) AS trimestre,
    EXTRACT(WEEK    FROM orderdate) AS semaine
FROM orders;


/* ==============================================================================
   4. FORMATAGE DES DATES (TO_CHAR)
   → Transformation en TEXTE pour affichage
============================================================================== */

SELECT
    orderid,
    orderdate,
    TO_CHAR(orderdate, 'YYYY-MM-DD') AS format_iso,
    TO_CHAR(orderdate, 'DD/MM/YYYY') AS format_fr,
    TO_CHAR(orderdate, 'FMDay FMMonth YYYY') AS date_lisible
FROM orders;


/* ==============================================================================
   5. AGRÉGATION TEMPORELLE (DATE_TRUNC)
   → Regrouper les données par période
============================================================================== */

SELECT
    DATE_TRUNC('month', orderdate) AS mois,
    COUNT(*) AS nb_commandes
FROM orders
GROUP BY mois
ORDER BY mois;


/* ==============================================================================
   6. CALCULS AVEC INTERVAL
============================================================================== */

SELECT
    orderdate,
    orderdate + INTERVAL '10 days'  AS plus_10_jours,
    orderdate + INTERVAL '3 months' AS plus_3_mois,
    orderdate + INTERVAL '1 year'   AS plus_1_an
FROM orders;


/* ==============================================================================
   7. FIN DU MOIS (équivalent EOMONTH)
============================================================================== */

SELECT
    DATE_TRUNC('month', orderdate)
        + INTERVAL '1 month' AS fin_du_mois
FROM orders;

--------
SELECT
    DATE_TRUNC('month', orderdate)
        + INTERVAL '1 month'
        - INTERVAL '1 day' AS fin_du_mois
FROM orders;

/* ==============================================================================
   8. DIFFÉRENCE ENTRE DEUX DATES
============================================================================== */

SELECT
    orderid,
    orderdate,
    shipdate,
    shipdate - orderdate AS duree_livraison
FROM ordersarchive;


/* ==============================================================================
   9. AGE() & JUSTIFY_DAYS()
============================================================================== */

SELECT
    employeeid,
    birthdate,
    AGE(NOW(), birthdate) AS age_exact
FROM employees;
-------------------
SELECT
    employeeid,
    birthdate,
    AGE(birthdate , NOW()) AS age_exact
FROM employees;

---------exemeple
SELECT
    orderid,
    orderdate,
    shipdate,
    AGE(shipdate , orderdate) AS duree_livraison_age,
    shipdate - orderdate AS duree_livraison
FROM ordersarchive;
---------------
SELECT
    JUSTIFY_DAYS(INTERVAL '40 days') AS interval_normalise;



/*
| Besoin         | EXTRACT  | TO_CHAR  | DATE_TRUNC |
| -------------- | -------  | -------- | ---------- |
| Calculs        | ✅       | ❌       | ⚠️         |
| Affichage      | ❌       | ✅       | ⚠️         |
| GROUP BY temps | ⚠️       | ❌       | ✅         |
| Retourne       | Nombre   | Texte   | Date       |
| Performance    | ⭐⭐⭐      | ⭐      | ⭐⭐⭐        |
*/
-------------------------------------------------------


--🧠 BONNES PRATIQUES (à retenir)
--✔️ Pour filtrer
-- Bon
WHERE date_commande >= '2024-01-01'
  AND date_commande <  '2025-01-01'

---❌ À éviter

WHERE EXTRACT(YEAR FROM date_commande) = 2024
   
----✔️ Pour regrouper par période
DATE_TRUNC('month', date_commande)

---✔️ Pour afficher
TO_CHAR(date_commande, 'DD/MM/YYYY')

/*En résumé ultra-court
EXTRACT = chiffres
TO_CHAR = affichage
DATE_TRUNC = regroupement temporel
*/
