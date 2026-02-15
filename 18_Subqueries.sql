/* ==============================================================================
   SOUS-REQUÊTES SQL (SQL Subqueries)
-------------------------------------------------------------------------------
   Ce script présente les différentes manières d’utiliser les sous-requêtes en SQL.
   Les sous-requêtes permettent d’exécuter une requête à l’intérieur d’une autre
   requête afin de produire des résultats dynamiques et réutilisables.

   Elles peuvent retourner :
   - une valeur unique (scalaire),
   - une ligne,
   - ou un ensemble de lignes (table).

   Table des matières :
     1. Types de résultats des sous-requêtes
     2. Sous-requête dans la clause FROM
     3. Sous-requête dans le SELECT
     4. Sous-requête avec opérateurs de comparaison
     5. Sous-requête avec IN
     6. Sous-requête avec ANY
     7. Sous-requête avec EXISTS
===============================================================================
*/

/* ==============================================================================
   SOUS-REQUÊTES | TYPES DE RÉSULTATS
===============================================================================*/

/* Sous-requête scalaire
   ➜ Retourne UNE seule valeur
   Exemple : moyenne des ventes
*/
SELECT
    AVG(Sales)
FROM  Orders;


SELECT
        ProductID,
        Price,
        AVG(Price) OVER () AS AvgPrice
    FROM  Product
    where Price > AvgPrice; ------false
-----------------
 SELECT
        ProductID,
        Price,
        AVG(Price) OVER () AS AvgPrice
    FROM  Product
 ------------------   
    
SELECT
    *
FROM (
    SELECT
        ProductID,
        Price,
        AVG(Price) OVER () AS AvgPrice
    FROM  Product
) AS t
WHERE Price > AvgPrice; 

----------------------
----------------------
/*    Classer les clients selon leur chiffre d’affaires total
   - La sous-requête calcule les ventes totales par client
   - La requête externe applique un classement
*/
SELECT
        CustomerID,
        SUM(Sales) AS TotalSales
    FROM  Orders
    GROUP BY CustomerID
    
    
 SELECT
    *
FROM (
    SELECT
        CustomerID,
        SUM(Sales) AS TotalSales
    FROM  Orders
    GROUP BY CustomerID
) AS t;

/* ==============================================================================
   SOUS-REQUÊTES | CLAUSE SELECT
===============================================================================*/

/* ----------------------
   Afficher les produits avec :
   - leur prix
   - le nombre total de commandes (identique pour chaque ligne)
   ➜ Exemple classique de sous-requête scalaire
*/
SELECT
    ProductID,
    Product,
    Price,
    (SELECT COUNT(*) FROM  Orders) AS TotalOrders
FROM  Product;

/* ==============================================================================
   SOUS-REQUÊTES | OPÉRATEURS DE COMPARAISON
===============================================================================*/

/*---------------------- :
   Trouver les produits dont le prix est supérieur à la moyenne globale
   ➜ Sous-requête utilisée directement dans le WHERE
*/
SELECT
    ProductID,
    Price
FROM  Product
WHERE Price > (
    SELECT AVG(Price)
    FROM  Product
);

/* ==============================================================================
   SOUS-REQUÊTES | OPÉRATEUR IN
===============================================================================*/

/* ---------------------- :
   Afficher les commandes passées par des clients allemands
*/
SELECT
    *
FROM  Orders
WHERE CustomerID IN (
    SELECT CustomerID
    FROM  Customers
    WHERE Country = 'Germany'
);


SELECT
    *
FROM  Orders
WHERE CustomerID IN (
    SELECT *
    FROM  Customers
    WHERE Country = 'Germany'
); ----false
/* ---------------------- :
   Afficher les commandes passées par des clients NON allemands
*/
SELECT
    *
FROM  Orders
WHERE CustomerID IN (
    SELECT CustomerID
    FROM  Customers
    WHERE Country = 'Germany'
);

/* ==============================================================================
   SOUS-REQUÊTES | OPÉRATEUR ANY
===============================================================================*/

/* ----------------------:
   Trouver les employées dont le salaire est supérieur
   au salaire d’au moins un employé masculin
*/
SELECT
    EmployeeID,
    FirstName,
    Salary
FROM  Employees
WHERE Gender = 'F'
  AND Salary > ANY (
      SELECT Salary
      FROM  Employees
      WHERE Gender = 'M'
  );

/* ==============================================================================
   SOUS-REQUÊTES | OPÉRATEUR EXISTS
===============================================================================*/

/* ----------------------:
   Afficher les commandes des clients allemands
   ➜ EXISTS vérifie l’existence d’au moins une ligne correspondante
*/

SELECT *
FROM Orders
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Customers
    WHERE Country = 'Germany'
);


-------Alternative
SELECT
    *
FROM  Orders AS o
WHERE EXISTS (
    SELECT 1
    FROM  Customers AS c
    WHERE c.Country = 'Germany'
      AND c.CustomerID = o.CustomerID
);


SELECT
    *
FROM  Orders AS o
WHERE EXISTS (
    SELECT *
    FROM  Customers AS c
    WHERE c.Country = 'Germany'
      AND c.CustomerID = o.CustomerID
);
/*---------------------- :
   Afficher les commandes des clients NON allemands
*/
SELECT
    *
FROM  Orders AS o
WHERE NOT EXISTS (
    SELECT 1
    FROM  Customers AS c
    WHERE c.Country = 'Germany'
      AND c.CustomerID = o.CustomerID
);
