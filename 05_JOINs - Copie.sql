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
     2. Jointures avancées
        - LEFT ANTI JOIN
        - RIGHT ANTI JOIN
        - INNER JOIN alternatif
        - FULL ANTI JOIN
        - CROSS JOIN
     3. Jointures multiples (4 tables)
=================================================================================
*/

/* ==============================================================================
   JOINTURES DE BASE
=============================================================================== */

-- Aucune jointure
-- Afficher séparément les tables customers et orders
SELECT * FROM customers;
SELECT * FROM orders;

/* ------------------------------------------------------------------------------ 
   INNER JOIN
------------------------------------------------------------------------------- */

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
---
SELECT
    customer_id,
    first_name,
    order_id,
    sales
FROM customers_test 
INNER JOIN orders_test
ON customer_id = customer_id;


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
---
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

/* Alternative au RIGHT JOIN (plus lisible) */
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM orders AS o
LEFT JOIN customers AS c
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

/* ==============================================================================
   JOINTURES AVANCÉES
=============================================================================== */

-- LEFT ANTI JOIN
-- Clients qui n’ont passé AUCUNE commande
SELECT *
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL;

-- RIGHT ANTI JOIN
-- Commandes sans client associé
SELECT *
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id
WHERE c.id IS NULL;

/* Alternative avec LEFT JOIN */
SELECT *
FROM orders AS o
LEFT JOIN customers AS c
ON c.id = o.customer_id
WHERE c.id IS NULL;

-- INNER JOIN (version alternative)
-- Clients ayant passé une commande
SELECT *
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NOT NULL;

-- FULL ANTI JOIN
-- Clients sans commande ET commandes sans client
SELECT
    c.id,
    c.first_name,
    o.order_id,
    o.customer_id,
    o.sales
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL
   OR c.id IS NULL;

-- CROSS JOIN
-- Toutes les combinaisons possibles entre clients et commandes
SELECT *
FROM customers
CROSS JOIN orders;

/* ==============================================================================
   JOINTURES MULTIPLES (4 TABLES)
=============================================================================== */

/* Objectif :
   Afficher toutes les commandes avec :
   - informations client
   - informations produit
   - informations vendeur */

USE SalesDB;

SELECT
    o.OrderID,
    o.Sales,
    c.FirstName AS CustomerFirstName,
    c.LastName AS CustomerLastName,
    p.Product AS ProductName,
    p.Price,
    e.FirstName AS EmployeeFirstName,
    e.LastName AS EmployeeLastName
FROM Sales.Orders AS o
LEFT JOIN Sales.Customers AS c
    ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products AS p
    ON o.ProductID = p.ProductID
LEFT JOIN Sales.Employees AS e
    ON o.SalesPersonID = e.EmployeeID;
