/* ==============================================================================
   POSTGRESQL — CAST & CONVERSIONS DE TYPES
   Objectif :
   Convertir entre texte, date, timestamp et interval
============================================================================== */


/* ==============================================================================
   1. CAST TEXTE → DATE
============================================================================== */

SELECT
    CAST('2025-08-20' AS DATE) AS texte_vers_date,
    '2025-08-20'::DATE        AS texte_vers_date_court;


/* ==============================================================================
   2. CAST TIMESTAMP → DATE
   (suppression de l’heure)
============================================================================== */

SELECT
    creationtime,
    CAST(creationtime AS DATE) AS date_sans_heure,
    creationtime::DATE         AS date_sans_heure_court
FROM orders;


/* ==============================================================================
   3. CAST DATE → TEXTE (avec format)
============================================================================== */

SELECT
    creationtime,
    TO_CHAR(creationtime::DATE, 'DD/MM/YYYY') AS date_affichee
FROM orders;


/* ==============================================================================
   4. CAST AVEC CALCULS
============================================================================== */

SELECT
    orderdate,
    (orderdate + INTERVAL '7 days')::DATE AS date_plus_7
FROM orders;


/* ==============================================================================
   5. BONNES PRATIQUES CAST & DATES
============================================================================== */

-- ✔️ BON : filtrage par intervalle
-- Utilise les index
-- Performant

-- WHERE orderdate >= '2025-01-01'
--   AND orderdate <  '2026-01-01'

-- ❌ À éviter : EXTRACT dans les filtres
-- Empêche l’utilisation des index

-- WHERE EXTRACT(YEAR FROM orderdate) = 2025
