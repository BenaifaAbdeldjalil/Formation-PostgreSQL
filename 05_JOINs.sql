/* ==============================================================================
   SQL – LES JOINTURES (JOINS)
-------------------------------------------------------------------------------
   Ce document explique les jointures SQL, qui permettent de combiner
   des données provenant de plusieurs tables liées entre elles.

   Sommaire :
     1. Jointures de base
        - INNER JOIN
        - LEFT JOIN
        - RIGHT JOIN
        - FULL JOIN
=================================================================================
*/

/* ==============================================================================
   JOINTURES DE BASE
=============================================================================== */                            
-- Afficher séparément les tables customers et orders
SELECT * FROM customers;
SELECT * FROM orders;

/* ------------------------------------------------------------------------------ 
   INNER JOIN / JOIN
------------------------------------------------------------------------------- */
-- Afficher les clients AVEC leurs commandes
-- Seuls les clients ayant passé au moins une commande apparaissent

---Bonne pratique
SELECT
    customer_id,
    first_name,
    order_id,
    sales
FROM customers_test 
INNER JOIN orders_test ON customer_id = customer_id;


--alias
SELECT
    c.customer_id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers_test  c
INNER JOIN orders_test   o
ON c.customer_id = o.customer_id;

-- Afficher les clients AVEC leurs commandes
-- Seuls les clients ayant passé au moins une commande apparaissent
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers AS c
INNER JOIN orders AS o
ON c.id = o.customer_id;

* ------------------------------------------------------------------------------ 
   INNER JOIN / JOIN
------------------------------------------------------------------------------- */

-- Afficher les clients AVEC leurs commandes
-- Seuls les clients ayant passé au moins une commande apparaissent
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers AS c
JOIN orders AS o
ON c.id = o.customer_id;

* ------------------------------------------------------------------------------ 
   JOIN
------------------------------------------------------------------------------- */

SELECT
    customer_id,
    first_name,
    order_id,
    sales
FROM customers_test 
JOIN orders_test
ON customer_id = customer_id;

/* ------------------------------------------------------------------------------ 
   LEFT JOIN
------------------------------------------------------------------------------- */

-- Afficher TOUS les clients
-- Même ceux qui n’ont PAS passé de commande
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id;

/* ------------------------------------------------------------------------------ 
   RIGHT JOIN
------------------------------------------------------------------------------- */

-- Afficher TOUTES les commandes
-- Même celles sans client correspondant

SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.customer_id,
    o.sales
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id;

/* ------------------------------------------------------------------------------ 
   FULL JOIN
------------------------------------------------------------------------------- */

-- Afficher tous les clients et toutes les commandes
-- Même s’il n’y a pas de correspondance
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.customer_id,
    o.sales
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id;

/* ------------------------------------------------------------------------------ 
   CROSS JOIN
------------------------------------------------------------------------------- */

-- CROSS JOIN
-- Toutes les combinaisons possibles entre clients et commandes
SELECT *
FROM customers
CROSS JOIN orders;


