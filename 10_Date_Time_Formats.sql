/* ==============================================================================
   POSTGRESQL – FORMATS DATE, HEURE & NOMBRES
-------------------------------------------------------------------------------
   Ce script présente :
   - les formats numériques disponibles avec TO_CHAR
   - les formats de date et d’heure
   - les différentes parties d’une date
   - l’impact des locales (formats culturels)

   PostgreSQL utilise principalement :
     - TO_CHAR() pour le formatage
     - EXTRACT() pour les valeurs numériques
     - DATE_TRUNC() pour l’agrégation temporelle

   Sommaire :
     1. Formats de date & heure
     2. Comparaison EXTRACT / TO_CHAR / DATE_TRUNC
     3. Formats culturels (Locales)
===============================================================================
*/



/* ==============================================================================
   1. FORMATS DE DATE & HEURE (TO_CHAR)
=============================================================================== */
/* =========================================================
   SCRIPT DE DÉMONSTRATION : TO_CHAR() EN POSTGRESQL
   Dates, heures, nombres et paramètres régionaux
   ========================================================= */


/* =========================
   1. TO_CHAR() AVEC LES DATES
   ========================= */

/* --- Formattage des JOURS --- */

-- Nom complet du jour (avec remplissage d'espaces)
SELECT TO_CHAR(CURRENT_DATE, 'Day') AS jour_complet;      -- ex: "Monday    "
SELECT TO_CHAR(CURRENT_DATE, 'day') AS jour_minuscule;    -- ex: "monday    "
SELECT TO_CHAR(CURRENT_DATE, 'DAY') AS jour_majuscule;    -- ex: "MONDAY    "

-- Nom abrégé du jour
SELECT TO_CHAR(CURRENT_DATE, 'Dy')  AS jour_abrege;       -- "Mon"
SELECT TO_CHAR(CURRENT_DATE, 'dy')  AS jour_abrege_min;   -- "mon"
SELECT TO_CHAR(CURRENT_DATE, 'DY')  AS jour_abrege_maj;   -- "MON"

-- Numéro du jour
SELECT TO_CHAR(CURRENT_DATE, 'D')  AS jour_semaine;       -- 1-7 (Dimanche = 1)
SELECT TO_CHAR(CURRENT_DATE, 'ID') AS jour_iso;           -- 1-7 (Lundi = 1, ISO)


/* --- Formattage des MOIS --- */

-- Nom complet du mois
SELECT TO_CHAR(CURRENT_DATE, 'Month') AS mois_complet;    -- "January   "
SELECT TO_CHAR(CURRENT_DATE, 'month') AS mois_minuscule;  -- "january   "
SELECT TO_CHAR(CURRENT_DATE, 'MONTH') AS mois_majuscule;  -- "JANUARY   "

-- Nom abrégé du mois
SELECT TO_CHAR(CURRENT_DATE, 'Mon') AS mois_abrege;       -- "Jan"
SELECT TO_CHAR(CURRENT_DATE, 'mon') AS mois_abrege_min;   -- "jan"
SELECT TO_CHAR(CURRENT_DATE, 'MON') AS mois_abrege_maj;   -- "JAN"

-- Numéro du mois
SELECT TO_CHAR(CURRENT_DATE, 'MM') AS mois_numero;        -- "01" à "12"
SELECT TO_CHAR(CURRENT_DATE, 'RM') AS mois_romain;        -- "I" à "XII"


/* --- Années --- */

SELECT TO_CHAR(CURRENT_DATE, 'YYYY')  AS annee_4;         -- "2024"
SELECT TO_CHAR(CURRENT_DATE, 'YYY')   AS annee_3;         -- "024"
SELECT TO_CHAR(CURRENT_DATE, 'YY')    AS annee_2;         -- "24"
SELECT TO_CHAR(CURRENT_DATE, 'Y')     AS annee_1;         -- "4"
SELECT TO_CHAR(CURRENT_DATE, 'Y,YYY') AS annee_sep;       -- "2,024"
SELECT TO_CHAR(CURRENT_DATE, 'IYYY')  AS annee_iso;       -- "2024"


/* --- Dates complètes --- */

-- Formats français
SELECT TO_CHAR(NOW(), 'DD/MM/YYYY') AS date_fr;            -- "25/12/2024"
SELECT TO_CHAR(NOW(), 'DD-MM-YYYY') AS date_fr_tiret;     -- "25-12-2024"

-- Format international
SELECT TO_CHAR(NOW(), 'YYYY-MM-DD') AS date_iso;          -- "2024-12-25"

-- Date avec jour et mois en texte
SELECT TO_CHAR(NOW(), 'Day DD Month YYYY') AS date_lisible;


/* =========================
   2. TO_CHAR() AVEC LES HEURES
   ========================= */

/* --- Heures --- */

-- Format 24h
SELECT TO_CHAR(NOW(), 'HH24:MI:SS') AS heure_24h;          -- "14:30:45"
SELECT TO_CHAR(NOW(), 'HH24')       AS heure_24;

-- Format 12h
SELECT TO_CHAR(NOW(), 'HH:MI:SS AM') AS heure_12h;         -- "02:30:45 PM"
SELECT TO_CHAR(NOW(), 'HH12')        AS heure_12;


/* --- Minutes et secondes --- */

SELECT TO_CHAR(NOW(), 'MI') AS minutes;                   -- "30"
SELECT TO_CHAR(NOW(), 'SS') AS secondes;                  -- "45"
SELECT TO_CHAR(NOW(), 'MS') AS millisecondes;             -- "123"
SELECT TO_CHAR(NOW(), 'US') AS microsecondes;             -- "123456"


/* =========================
   3. TO_CHAR() AVEC LES NOMBRES
   ========================= */

/* --- Formatage numérique --- */

-- Chiffres simples
SELECT TO_CHAR(1234, '9999')   AS nombre_simple;
SELECT TO_CHAR(1234, '0000')   AS nombre_zero;
SELECT TO_CHAR(12.34, '99.99') AS decimal_simple;

-- Séparateurs de milliers
SELECT TO_CHAR(1234567, '9,999,999') AS milliers_virgule;
SELECT TO_CHAR(1234567, '9G999G999') AS milliers_locale;

-- Devises
SELECT TO_CHAR(1234.56, 'L9999.99') AS devise_locale;
SELECT TO_CHAR(1234, 'FML9999')     AS devise_sans_espace;

-- Signes
SELECT TO_CHAR(-1234, 'S9999') AS negatif;
SELECT TO_CHAR(1234, 'S9999')  AS positif;

-- Pourcentages
SELECT TO_CHAR(0.25, '99.99%') AS pourcentage;


/* =========================
   4. MODIFICATEURS SPÉCIAUX
   ========================= */

-- Remplissage avec espaces (par défaut)
SELECT TO_CHAR(CURRENT_DATE, 'Month') AS mois_avec_espaces;

-- FM = supprime les espaces
SELECT TO_CHAR(CURRENT_DATE, 'FMMonth') AS mois_sans_espaces;


/* =========================
   5. COMBINAISONS COURANTES
   ========================= */

-- Date et heure complète
SELECT TO_CHAR(NOW(), 'DD/MM/YYYY HH24:MI:SS') AS datetime_complete;

-- Format lisible
SELECT TO_CHAR(
    NOW(),
    'FMDay, DD FMMonth YYYY "à" HH24"h"MI'
) AS datetime_lisible;

-- Format pour rapports
SELECT
    TO_CHAR(NOW(), 'YYYY-MM-DD') AS date,
    TO_CHAR(NOW(), 'Day')        AS jour_semaine,
    TO_CHAR(NOW(), 'HH24:MI')    AS heure;


/* =========================
   6. PARAMÈTRES RÉGIONAUX
   ========================= */

-- Passage en français
SET lc_time = 'fr_FR';
SELECT TO_CHAR(NOW(), 'Day') AS jour_fr;   -- "lundi     "

-- Passage en anglais
SET lc_time = 'en_US';
SELECT TO_CHAR(NOW(), 'Day') AS jour_en;   -- "Monday    "



/* ==============================================================================
   2. COMPARAISON EXTRACT / TO_CHAR / DATE_TRUNC
=============================================================================== */
----1. EXTRACT
-----EXTRACT(champ FROM timestamp)

SELECT EXTRACT(YEAR FROM NOW());    -- 2024
SELECT EXTRACT(MONTH FROM NOW());   -- 12
SELECT EXTRACT(DAY FROM NOW());     -- 25
SELECT EXTRACT(DOW FROM NOW());     -- 0 (dimanche)
SELECT EXTRACT(ISODOW FROM NOW());  -- 1-7 (ISO)

----Cas d’usage typiques

-- Filtrer sur une année
WHERE EXTRACT(YEAR FROM date_commande) = 2024

-- Regrouper par mois
GROUP BY EXTRACT(MONTH FROM date_commande)

SELECT
    EXTRACT(YEAR FROM orderdate)  AS annee,
    EXTRACT(MONTH FROM orderdate) AS mois,
    COUNT(*)                      AS nb_commandes,
    SUM(sales)                    AS total_ventes
FROM formation_sql.orders
GROUP BY
    EXTRACT(YEAR FROM orderdate),
    EXTRACT(MONTH FROM orderdate)
ORDER BY annee, mois;


/*Points faibles
Retourne un nombre, pas une date
Pas adapté à l’affichage
*/
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
----2. TO_CHAR
----TO_CHAR
SELECT TO_CHAR(NOW(), 'DD/MM/YYYY');     -- "25/12/2024"
SELECT TO_CHAR(NOW(), 'Day DD Month');  -- "Monday 25 December"
SELECT TO_CHAR(NOW(), 'HH24:MI');       -- "14:30"


-- Colonnes lisibles dans un rapport
SELECT
  TO_CHAR(orderdate, 'YYYY-MM') AS mois,
  COUNT(*)
FROM formation_sql.orders
GROUP BY TO_CHAR(orderdate, 'YYYY-MM');
----------

SELECT
    TO_CHAR(orderdate, 'YYYY-MM') AS mois,
    COUNT(*)                      AS nb_commandes,
    SUM(sales)                    AS total_ventes
FROM formation_sql.orders
GROUP BY
    TO_CHAR(orderdate, 'YYYY-MM')
ORDER BY mois;

/*⚠️ Points faibles : 
Retourne du texte
Mauvais pour les calculs
Peut poser problème avec le tri (ordre alphabétique)

*/
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-----3.DATE_TRUNC
----- DATE_TRUNC('precision', timestamp)

SELECT DATE_TRUNC('day', NOW());    -- 2024-12-25 00:00:00
SELECT DATE_TRUNC('month', NOW());  -- 2024-12-01 00:00:00
SELECT DATE_TRUNC('year', NOW());   -- 2024-01-01 00:00:00


-- Regrouper par mois
SELECT
  DATE_TRUNC('month', orderdate) AS mois,
  COUNT(*)
FROM formation_sql.orders
GROUP BY mois
ORDER BY mois;
----

SELECT
    DATE_TRUNC('month', orderdate) AS mois,
    COUNT(*)                       AS nb_commandes,
    SUM(sales)                     AS total_ventes
FROM formation_sql.orders
GROUP BY mois
ORDER BY mois;

/* Avantages
Retourne une date
Très performant
Parfait pour séries temporelles
*/
----------------------------------------------------
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

---BONUS — DATE_TRUNC + TO_CHAR
---Calcul avec date, affichage lisible
/*S
 * ELECT
    TO_CHAR(DATE_TRUNC('month', orderdate), 'YYYY-MM') AS mois,
    COUNT(*)                                           AS nb_commandes,
    SUM(sales)                                         AS total_ventes
FROM formation_sql.orders
GROUP BY DATE_TRUNC('month', orderdate)
ORDER BY mois;
*/
