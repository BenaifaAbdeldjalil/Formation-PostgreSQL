/* ==============================================================================
   REQUÊTES SQL – INSTRUCTIONS SELECT
   Objectif : apprendre à interroger et analyser des données avec SQL
=============================================================================== */


/* ==============================================================================
   1. SÉLECTION DES DONNÉES (SELECT)
=============================================================================== */

-- Sélectionner des colonnes spécifiques de la table customers
SELECT id, firstname, lastname, country, score
FROM formation_sql.customers;

-- Sélectionner TOUTES les colonnes de la table customers
SELECT *
FROM customers;

-- Sélectionner TOUTES les colonnes de la table orders
SELECT *
FROM orders;


/* ==============================================================================
   2. SÉLECTION DE QUELQUES COLONNES
=============================================================================== */

-- Afficher le prénom, le pays et le score de chaque client
SELECT
    first_name,
    country,
    score
FROM customers;


/* ==============================================================================
   3. FILTRER LES DONNÉES AVEC WHERE
=============================================================================== */

-- Afficher uniquement les clients dont le score est différent de 0
SELECT *
FROM customers
WHERE score != 0;

-- Alternative équivalente
SELECT *
FROM customers
WHERE score <> 0;

-- Afficher les clients provenant d'Allemagne
SELECT *
FROM customers
WHERE country = 'Germany';

-- Afficher le prénom et le pays des clients allemands
SELECT
    first_name,
    country
FROM customers
WHERE country = 'Germany';

-- Clients provenant de plusieurs pays
SELECT *
FROM customers
WHERE country = 'Germany'
   OR country = 'USA';


-- Alternative (moins lisible, à éviter)
SELECT *
FROM customers
WHERE country IN ('Germany', 'USA');


-- Clients avec un score compris entre 300 et 600
SELECT *
FROM customers
WHERE score >= 300
  AND score <= 600;

-- Alternative plus explicite
SELECT *
FROM customers
WHERE score BETWEEN 300 AND 600;

/* ==============================================================================
   4. TRIER LES RÉSULTATS AVEC ORDER BY
=============================================================================== */

-- Trier les clients par score (du plus élevé au plus faible)
SELECT *
FROM customers
ORDER BY score DESC;

-- Trier les clients par la première colonne (équivalent ici à id)
SELECT *
FROM customers
ORDER BY 1 DESC;

-- Trier les clients par score croissant
SELECT *
FROM customers
ORDER BY score ASC;

---
SELECT *
FROM  formation_sql.customers_test
ORDER BY score ASC;

-- Trier les clients par pays (ordre alphabétique)
SELECT *
FROM customers
ORDER BY country ASC;

-- Trier par pays puis par score décroissant
SELECT *
FROM customers
ORDER BY country ASC, score DESC;

-- Clients avec score différent de 0, triés par score décroissant
SELECT
    first_name,
    country,
    score
FROM customers
WHERE score <> 0
ORDER BY score DESC;


/* ==============================================================================
   5. REGROUPER LES DONNÉES AVEC GROUP BY
=============================================================================== */

-- Calculer le score total de tous les clients -- Alternative avec alias
SELECT
    SUM(score)
FROM customers;


-- Calculer le score total de tous les clients -- Alternative avec alias
SELECT
    SUM(score) AS total_score
FROM customers;

-- Calculer le score total par pays
SELECT
    country,
    SUM(score) AS total_score
FROM customers
GROUP BY country;

-- Utilisation de la position de colonne dans le GROUP BY
SELECT
    country,
    SUM(score) AS total_score
FROM customers
GROUP BY 1;

/*
ATTENTION :
Cette requête est invalide car first_name n’est
ni dans le GROUP BY, ni dans une fonction d’agrégation
*/
SELECT
    country,
    first_name,
    SUM(score) AS total_score
FROM customers
GROUP BY country;

-- Calculer le score total ET le nombre de clients par pays
SELECT
    country,
    SUM(score) AS total_score,
    COUNT(id) AS total_customers
FROM customers
GROUP BY country;

-- Calculer la moyenne des scores par pays
SELECT
    country,
    AVG(score) AS avg_score
FROM customers
GROUP BY country;


/* ==============================================================================
   6. FILTRER APRÈS AGRÉGATION AVEC HAVING
=============================================================================== */

-- ❌ ERREUR : WHERE ne peut pas filtrer une fonction d’agrégation
SELECT
    country,
    AVG(score) AS avg_score
FROM customers
GROUP BY country
WHERE AVG(score) > 430;

-- ✅ Bonne pratique : utiliser HAVING
SELECT
    country,
    AVG(score) AS avg_score
FROM customers
GROUP BY country
HAVING AVG(score) > 430;

-- Exclure les scores à 0 avant le calcul de la moyenne
SELECT
    country,
    AVG(score) AS avg_score
FROM customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430;


/* ==============================================================================
   7. VALEURS UNIQUES AVEC DISTINCT
=============================================================================== */

-- Afficher la liste des pays sans doublons
SELECT DISTINCT country
FROM customers;


/* ==============================================================================
   8. LIMITER LE NOMBRE DE RÉSULTATS (LIMIT)
=============================================================================== */

-- Afficher seulement 2 clients
SELECT *
FROM customers
LIMIT 2;

-- Afficher les 2 clients avec les meilleurs scores
SELECT *
FROM customers
ORDER BY score DESC
LIMIT 2;

-- Afficher les 2 clients avec les scores les plus faibles
SELECT *
FROM customers
ORDER BY score ASC
LIMIT 2;

-- Afficher les 2 commandes les plus récentes
SELECT *
FROM orders
ORDER BY order_date DESC
LIMIT 2;


/* ==============================================================================
   9. COMBINAISON DE PLUSIEURS CLAUSES
=============================================================================== */

-- Moyenne des scores par pays
-- Exclure les scores à 0
-- Garder uniquement les moyennes > 430
-- Trier par moyenne décroissante
SELECT
    country,
    AVG(score) AS avg_score
FROM customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430
ORDER BY avg_score DESC;


/* ==============================================================================
   10. BONUS – FONCTIONNALITÉS UTILES
=============================================================================== */

-- Exécuter plusieurs requêtes dans un même script
SELECT * FROM customers;
SELECT * FROM orders;

-- Sélectionner une valeur statique (sans table)
SELECT 123 AS static_number;

SELECT 'Bonjour' AS static_string;

-- Ajouter une valeur constante à chaque ligne
SELECT
    id,
    first_name,
    'Nouveau client' AS customer_type
FROM customers;


/* ==============================================================================
   EXERCICE
=============================================================================== */
/*
Objectif :
Écrire UNE requête SQL permettant de :
- Afficher le pays
- Calculer la moyenne des scores par pays
- Exclure les clients ayant un score égal à 0
- Afficher uniquement les pays avec une moyenne > 400
- Trier les résultats par moyenne décroissante
*/


/* ==============================================================================
   CORRECTION
=============================================================================== */

SELECT
    country,
    AVG(score) AS avg_score
FROM customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 400
ORDER BY avg_score DESC;


/* ==============================================================================
   QUESTION BONUS 1
   Ajouter le nombre de clients par pays
=============================================================================== */

SELECT
    country,
    AVG(score) AS avg_score,
    COUNT(id) AS total_customers
FROM customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 400
ORDER BY avg_score DESC;


/* ==============================================================================
   QUESTION BONUS 2
   Afficher uniquement les 3 pays avec la meilleure moyenne
=============================================================================== */

SELECT
    country,
    AVG(score) AS avg_score
FROM customers
WHERE score != 0
GROUP BY country
ORDER BY avg_score DESC
LIMIT 3;
