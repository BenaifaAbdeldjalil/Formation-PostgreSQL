/* ==============================================================================
   SQL – FILTRER LES DONNÉES
-------------------------------------------------------------------------------
 

   Sommaire :
     1. Opérateurs de comparaison : =, <>, >, >=, <, <=
     2. Opérateurs logiques :       AND, OR, NOT
     3. Filtrage par intervalle :   BETWEEN
     4. Filtrage par liste :        IN
     5. Recherche par motif :       LIKE, ILIKE
=================================================================================
*/

/* ==============================================================================
   OPÉRATEURS DE COMPARAISON
=============================================================================== */

-- Afficher tous les clients venant d'Allemagne
SELECT *
FROM formation_sql.customers
WHERE country = 'Germany';

SELECT *
FROM formation_sql.customers
WHERE country = 'germany';

SELECT *
FROM formation_sql.customers
WHERE country = 'ITALY';

-- Afficher tous les clients qui ne viennent PAS d'Allemagne
SELECT *
FROM formation_sql.customers
WHERE country <> 'Germany';

-- Afficher les clients ayant un score strictement supérieur à 500
SELECT *
FROM formation_sql.customers
WHERE score > 500;

-- Afficher les clients ayant un score supérieur ou égal à 500
SELECT *
FROM formation_sql.customers
WHERE score >= 500;

-- Afficher les clients ayant un score inférieur à 500
SELECT *
FROM formation_sql.customers
WHERE score < 500;

-- Afficher les clients ayant un score inférieur ou égal à 500
SELECT *
FROM formation_sql.customers
WHERE score <= 500;

/* ==============================================================================
   OPÉRATEURS LOGIQUES
=============================================================================== */

-- Combiner plusieurs conditions avec AND, OR et NOT
---AND → toutes les conditions doivent être vraies
-- Clients venant des USA ET ayant un score supérieur à 500
SELECT *
FROM formation_sql.customers
WHERE country = 'USA' AND score > 500;

---OR → au moins une condition vraie
-- Clients venant des USA OU ayant un score supérieur à 500
SELECT *
FROM formation_sql.customers
WHERE country = 'USA' OR score > 500;

---NOT → inverse une condition
-- Clients dont le score n’est PAS inférieur à 500
SELECT *
FROM formation_sql.customers
WHERE NOT score < 500; --WHERE score >= 500;

/* ==============================================================================
   FILTRAGE PAR INTERVALLE - BETWEEN
=============================================================================== */

-- Clients dont le score est compris entre 100 et 500 (bornes incluses)
SELECT *
FROM formation_sql.customers
WHERE score BETWEEN 100 AND 500;

--À savoir BETWEEN inclut toujours les bornes (>= et <=).
-- Méthode équivalente sans BETWEEN
SELECT *
FROM formation_sql.customers
WHERE score >= 100 AND score <= 500;

/* ==============================================================================
   FILTRAGE PAR LISTE - IN
=============================================================================== */

-- Clients venant soit d'Allemagne soit des USA


SELECT *
FROM formation_sql.customers
WHERE country = 'Germany'
  AND country = 'USA';
-- IMPOSSIBLE : un pays ne peut pas être Germany ET USA
--Alternative avec OR

SELECT *
FROM formation_sql.customers
WHERE country = 'Germany'
   OR country = 'USA';
---- Clients venant d'Allemagne OU des USA
SELECT *
FROM formation_sql.customers
WHERE country IN ('Germany', 'USA');



SELECT *
FROM formation_sql.customers
WHERE country <> 'Germany'
  AND country <> 'USA';

SELECT *
FROM formation_sql.customers
WHERE country NOT IN ('Germany', 'USA');



/* ==============================================================================
   RECHERCHE PAR MOTIF - LIKE
=============================================================================== */

-- Clients dont le prénom commence par la lettre 'M'
SELECT *
FROM formation_sql.customers
WHERE first_name LIKE 'M%';

SELECT *
FROM formation_sql.customers
WHERE first_name LIKE 'm%';

-- Clients dont le prénom se termine par la lettre 'n'
SELECT *
FROM formation_sql.customers
WHERE first_name LIKE '%n';

-- Clients dont le prénom contient la lettre 'r'
SELECT *
FROM formation_sql.customers
WHERE first_name LIKE '%r%';

-- Clients dont la 3ᵉ lettre du prénom est 'r'
SELECT *
FROM formation_sql.customers
WHERE first_name LIKE '__r%';


--📌 LIKE → sensible à la casse
--📌 ILIKE → PAS sensible à la casse

SELECT *
FROM formation_sql.customers
WHERE first_name ILIKE 'M%';

SELECT *
FROM formation_sql.customers
WHERE first_name ILIKE 'm%';
