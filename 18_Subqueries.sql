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
     4. Sous-requête dans la clause JOIN
     5. Sous-requête avec opérateurs de comparaison
     6. Sous-requête avec IN
     7. Sous-requête avec ANY
     8. Sous-requête corrélée
     9. Sous-requête avec EXISTS
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

/* Sous-requête ligne
   ➜ Retourne une ou plusieurs lignes avec une seule colonne
*/
SELECT
    CustomerID
FROM  Orders;

/* Sous-requête table
   ➜ Retourne plusieurs lignes et colonnes
*/
SELECT
    OrderID,
    OrderDate
FROM  Orders;

/* ==============================================================================
   SOUS-REQUÊTES | CLAUSE FROM
===============================================================================*/

/* TÂCHE 1 :
   Trouver les produits dont le prix est supérieur au prix moyen
   - La sous-requête calcule le prix moyen
   - La requête principale filtre les produits au-dessus de cette moyenne
*/

SELECT
        ProductID,
        Price,
        AVG(Price) OVER () AS AvgPrice
    FROM  Product
    where Price >AvgPrice; ------false
/*
SELECT
    *
FROM (
    SELECT
        ProductID,
        Price,
        AVG(Price) OVER () AS AvgPrice
    FROM  Product
) AS t
WHERE Price > AvgPrice; */

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
    *,
    RANK() OVER (ORDER BY TotalSales DESC) AS CustomerRank
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
   SOUS-REQUÊTES | CLAUSE JOIN
===============================================================================*/

/* ----------------------:
   Afficher les clients avec leur chiffre d’affaires total
   - La sous-requête agrège les ventes
   - Le JOIN permet d’associer les résultats aux clients
*/
SELECT
    c.*,
    t.TotalSales
FROM  Customers AS c
LEFT JOIN (
    SELECT
        CustomerID,
        SUM(Sales) AS TotalSales
    FROM  Orders
    GROUP BY CustomerID
) AS t
ON c.CustomerID = t.CustomerID;

/* ----------------------:
   Afficher les clients avec le nombre total de commandes
*/
SELECT
    c.*,
    o.TotalOrders
FROM  Customers AS c
LEFT JOIN (
    SELECT
        CustomerID,
        COUNT(*) AS TotalOrders
    FROM  Orders
    GROUP BY CustomerID
) AS o
ON c.CustomerID = o.CustomerID;

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
WHERE CustomerID NOT IN (
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
   SOUS-REQUÊTES CORRÉLÉES
===============================================================================*/

/* ----------------------:
   Afficher les clients avec leur nombre total de commandes
   - La sous-requête dépend de la ligne courante (CustomerID)
   - Elle est réévaluée pour chaque client
*/
SELECT
    *,
    (
        SELECT COUNT(*)
        FROM  Orders o
        WHERE o.CustomerID = c.CustomerID
    ) AS TotalOrders
FROM  Customers AS c;

/* ==============================================================================
   SOUS-REQUÊTES | OPÉRATEUR EXISTS
===============================================================================*/

/* ----------------------:
   Afficher les commandes des clients allemands
   ➜ EXISTS vérifie l’existence d’au moins une ligne correspondante
*/
SELECT
    *
FROM  Orders AS o
WHERE EXISTS (
    SELECT 1
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
