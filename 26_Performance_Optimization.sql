/* ==============================================================================
   20 conseils de performance SQL
=============================================================================== 
*/

-- ###############################################################
-- #                 1. RÉCUPÉRATION DE DONNÉES                #
-- ###############################################################

-- =========================================================
-- 1. Sélectionner uniquement les colonnes nécessaires
-- =========================================================

-- Mauvaise pratique : récupère tout, surcharge inutilement le réseau et le serveur
SELECT * FROM formation_sql.Customers;

-- Bonne pratique : récupère seulement ce dont on a besoin
SELECT CustomerID, FirstName, LastName 
FROM formation_sql.Customers;

-- ============================================
-- 2. Éviter DISTINCT et ORDER BY inutiles
-- ============================================

-- Mauvaise pratique : DISTINCT + ORDER BY coûte cher si non nécessaire
SELECT DISTINCT FirstName 
FROM formation_sql.Customers 
ORDER BY FirstName;

-- Bonne pratique : simple sélection, moins de travail pour le moteur
SELECT FirstName 
FROM formation_sql.Customers;

-- ============================================
-- 3. Limiter le nombre de lignes pour exploration
-- ============================================

-- Mauvaise pratique : récupère toutes les lignes inutilement
SELECT OrderID, Sales 
FROM formation_sql.Orders;

-- Bonne pratique : limite les lignes pour explorer les données
SELECT OrderID, Sales 
FROM formation_sql.Orders
limit 10 ;


-- ###############################################################
-- #                        2. FILTRAGE                        #
-- ###############################################################

-- ============================================
-- 4. Créer un index sur les colonnes utilisées dans WHERE
-- ============================================

SELECT * 
FROM formation_sql.Orders
WHERE OrderStatus = 'Delivered';

-- Index améliore la recherche sur la colonne
CREATE NONCLUSTERED INDEX Idx_Orders_OrderStatus 
ON formation_sql.Orders(OrderStatus);

-- ============================================
-- 5. Ne pas appliquer de fonctions sur les colonnes dans WHERE
-- ============================================

-- Mauvaise pratique : empêche l'utilisation d'index
SELECT * FROM formation_sql.Orders 
WHERE LOWER(OrderStatus) = 'delivered';

-- Bonne pratique : utilise directement la colonne indexée
SELECT * FROM formation_sql.Orders 
WHERE OrderStatus = 'Delivered';

-- Mauvaise pratique : SUBSTRING empêche l'index
SELECT * FROM formation_sql.Customers
WHERE SUBSTRING(FirstName, 1, 1) = 'A';

-- Bonne pratique : LIKE permet l'index
SELECT * FROM formation_sql.Customers
WHERE FirstName LIKE 'A%';

-- Mauvaise pratique : YEAR(OrderDate) empêche l'index
SELECT * FROM formation_sql.Orders 
WHERE YEAR(OrderDate) = 2025;

-- Bonne pratique : BETWEEN permet l'utilisation d'index
SELECT * FROM formation_sql.Orders 
WHERE OrderDate BETWEEN '2025-01-01' AND '2025-12-31';

-- ============================================
-- 6. Éviter les jokers au début (LIKE '%abc')
-- ============================================

-- Mauvaise pratique : ne peut pas utiliser l'index
SELECT * FROM formation_sql.Customers 
WHERE LastName LIKE '%Gold%';

-- Bonne pratique : index utilisé
SELECT * FROM formation_sql.Customers 
WHERE LastName LIKE 'Gold%';

-- ============================================
-- 7. Utiliser IN au lieu de plusieurs OR
-- ============================================

-- Mauvaise pratique
SELECT * FROM formation_sql.Orders
WHERE CustomerID = 1 OR CustomerID = 2 OR CustomerID = 3;

-- Bonne pratique
SELECT * FROM formation_sql.Orders
WHERE CustomerID IN (1,2,3);


-- ###############################################################
-- #                        3. JOINTURES                        #
-- ###############################################################

-- ============================================
-- 8. Comprendre la vitesse des jointures
-- ============================================

-- INNER JOIN plus rapide, plus simple pour optimiser
SELECT c.FirstName, o.OrderID 
FROM formation_sql.Customers c
INNER JOIN formation_sql.Orders o ON c.CustomerID = o.CustomerID;

-- RIGHT ou LEFT JOIN : légèrement plus lent
SELECT c.FirstName, o.OrderID 
FROM formation_sql.Customers c
RIGHT JOIN formation_sql.Orders o ON c.CustomerID = o.CustomerID;

SELECT c.FirstName, o.OrderID 
FROM formation_sql.Customers c
LEFT JOIN formation_sql.Orders o ON c.CustomerID = o.CustomerID;

-- OUTER JOIN : plus lent, plus de lignes générées
SELECT c.FirstName, o.OrderID 
FROM formation_sql.Customers c
FULL OUTER JOIN formation_sql.Orders o ON c.CustomerID = o.CustomerID;

-- ============================================
-- 9. Utiliser les jointures explicites (ANSI)
-- ============================================

-- Mauvaise pratique : jointure implicite (ancienne syntaxe)
SELECT o.OrderID, c.FirstName
FROM formation_sql.Customers c, formation_sql.Orders o
WHERE c.CustomerID = o.CustomerID;

-- Bonne pratique : jointure ANSI claire, plus facile à optimiser
SELECT o.OrderID, c.FirstName
FROM formation_sql.Customers AS c
INNER JOIN formation_sql.Orders AS o
    ON c.CustomerID = o.CustomerID;

-- ============================================
-- 10. Indexer les colonnes utilisées dans ON
-- ============================================

SELECT c.FirstName, o.OrderID
FROM formation_sql.Orders AS o
INNER JOIN formation_sql.Customers AS c
    ON c.CustomerID = o.CustomerID;

-- Index pour accélérer la jointure
CREATE NONCLUSTERED INDEX IX_Orders_CustomerID ON formation_sql.Orders(CustomerID);

-- ============================================
-- 11. Filtrer avant de joindre (grandes tables)
-- ============================================

-- Petite table : filtrer après la jointure
SELECT c.FirstName, o.OrderID
FROM formation_sql.Customers AS c
INNER JOIN formation_sql.Orders AS o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderStatus = 'Delivered';

-- Filtrer pendant la jointure (meilleure pratique)
SELECT c.FirstName, o.OrderID
FROM formation_sql.Customers AS c
INNER JOIN formation_sql.Orders AS o
    ON c.CustomerID = o.CustomerID
   AND o.OrderStatus = 'Delivered';

-- Grandes tables : filtrer dans une sous-requête
SELECT c.FirstName, o.OrderID
FROM formation_sql.Customers AS c
INNER JOIN (
    SELECT OrderID, CustomerID
    FROM formation_sql.Orders
    WHERE OrderStatus = 'Delivered'
) AS o
    ON c.CustomerID = o.CustomerID;

-- ============================================
-- 12. Agréger avant de joindre (grandes tables)
-- ============================================

-- Petite table : agrégation après jointure
SELECT c.CustomerID, c.FirstName, COUNT(o.OrderID) AS OrderCount
FROM formation_sql.Customers AS c
INNER JOIN formation_sql.Orders AS o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName;

-- Grande table : agrégation avant jointure (sous-requête)
SELECT c.CustomerID, c.FirstName, o.OrderCount
FROM formation_sql.Customers AS c
INNER JOIN (
    SELECT CustomerID, COUNT(OrderID) AS OrderCount
    FROM formation_sql.Orders
    GROUP BY CustomerID
) AS o
    ON c.CustomerID = o.CustomerID;

-- Mauvaise pratique : sous-requête corrélée coûteuse
SELECT c.CustomerID, c.FirstName,
       (SELECT COUNT(o.OrderID)
        FROM formation_sql.Orders AS o
        WHERE o.CustomerID = c.CustomerID) AS OrderCount
FROM formation_sql.Customers AS c;

-- ============================================
-- 13. Utiliser UNION au lieu de OR dans les jointures
-- ============================================

-- Mauvaise pratique : OR complexe
SELECT o.OrderID, c.FirstName
FROM formation_sql.Customers AS c
INNER JOIN formation_sql.Orders AS o
    ON c.CustomerID = o.CustomerID
    OR c.CustomerID = o.SalesPersonID;

-- Bonne pratique : UNION clair et performant
SELECT o.OrderID, c.FirstName
FROM formation_sql.Customers AS c
INNER JOIN formation_sql.Orders AS o
    ON c.CustomerID = o.CustomerID
UNION
SELECT o.OrderID, c.FirstName
FROM formation_sql.Customers AS c
INNER JOIN formation_sql.Orders AS o
    ON c.CustomerID = o.SalesPersonID;

-- ###############################################################
-- #                        4. UNION                             #
-- ###############################################################

-- ============================================
-- 14. Utiliser UNION ALL si les doublons sont acceptables
-- ============================================

-- Mauvaise pratique : UNION élimine les doublons, plus coûteux
SELECT CustomerID FROM formation_sql.Orders
UNION
SELECT CustomerID FROM formation_sql.OrdersArchive;

-- Bonne pratique : UNION ALL plus rapide
SELECT CustomerID FROM formation_sql.Orders
UNION ALL
SELECT CustomerID FROM formation_sql.OrdersArchive;

-- ============================================
-- 15. UNION ALL + DISTINCT si les doublons ne sont pas acceptables
-- ============================================

-- Mauvaise pratique : UNION coûteux
SELECT CustomerID FROM formation_sql.Orders
UNION
SELECT CustomerID FROM formation_sql.OrdersArchive;

-- Bonne pratique : UNION ALL + DISTINCT performant
SELECT DISTINCT CustomerID
FROM (
    SELECT CustomerID FROM formation_sql.Orders
    UNION ALL
    SELECT CustomerID FROM formation_sql.OrdersArchive
) AS CombinedData;


-- ###############################################################
-- #                      5. AGRÉGATIONS                        #
-- ###############################################################

-- ============================================
-- 16. Utiliser Columnstore Index pour les agrégations sur grandes tables
-- ============================================

SELECT CustomerID, COUNT(OrderID) AS OrderCount
FROM formation_sql.Orders 
GROUP BY CustomerID;

CREATE CLUSTERED COLUMNSTORE INDEX Idx_Orders_Columnstore 
ON formation_sql.Orders;


-- ###############################################################
-- #                  6. SOUS-REQUÊTES / CTE                     #
-- ###############################################################

-- ============================================
-- 17. JOIN vs EXISTS vs IN (éviter IN)
-- ============================================

-- JOIN (bonne pratique si performances équivalentes)
SELECT o.OrderID, o.Sales
FROM formation_sql.Orders AS o
INNER JOIN formation_sql.Customers AS c
    ON o.CustomerID = c.CustomerID
WHERE c.Country = 'USA';

-- EXISTS (bonne pratique pour grandes tables)
SELECT o.OrderID, o.Sales
FROM formation_sql.Orders AS o
WHERE EXISTS (
    SELECT 1
    FROM formation_sql.Customers AS c
    WHERE c.CustomerID = o.CustomerID
      AND c.Country = 'USA'
);

-- IN (mauvaise pratique)
SELECT o.OrderID, o.Sales
FROM formation_sql.Orders AS o
WHERE o.CustomerID IN (
    SELECT CustomerID
    FROM formation_sql.Customers
    WHERE Country = 'USA'
);

-- ============================================
-- 18. Éviter la logique redondante
-- ============================================

-- Mauvaise pratique : double sous-requête
SELECT EmployeeID, FirstName, 'Above Average' AS Status
FROM formation_sql.Employees
WHERE Salary > (SELECT AVG(Salary) FROM formation_sql.Employees)
UNION ALL
SELECT EmployeeID, FirstName, 'Below Average' AS Status
FROM formation_sql.Employees
WHERE Salary < (SELECT AVG(Salary) FROM formation_sql.Employees);

-- Bonne pratique : CASE + AVG() OVER () simplifie et accélère
SELECT EmployeeID, FirstName, 
       CASE 
           WHEN Salary > AVG(Salary) OVER () THEN 'Above Average'
           WHEN Salary < AVG(Salary) OVER () THEN 'Below Average'
           ELSE 'Average'
       END AS Status
FROM formation_sql.Employees;


-- ###############################################################
-- #                           7. DDL                             #
-- ###############################################################

-- ============================================
-- 19. Types et clés
-- ============================================

-- Mauvaise pratique : types trop grands et TEXT
CREATE TABLE CustomersInfo (
    CustomerID INT,
    FirstName VARCHAR(MAX),
    LastName TEXT,
    Country VARCHAR(255),
    TotalPurchases FLOAT, 
    Score VARCHAR(255),
    BirthDate VARCHAR(255),
    EmployeeID INT,
    CONSTRAINT FK_Bad_Customers_EmployeeID FOREIGN KEY (EmployeeID)
        REFERENCES formation_sql.Employees(EmployeeID)
);

-- Bonne pratique : types corrects, NOT NULL, clé primaire
CREATE TABLE CustomersInfo (
    CustomerID INT PRIMARY KEY CLUSTERED,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    TotalPurchases FLOAT,
    Score INT,
    BirthDate DATE,
    EmployeeID INT,
    CONSTRAINT FK_CustomersInfo_EmployeeID FOREIGN KEY (EmployeeID)
        REFERENCES formation_sql.Employees(EmployeeID)
);

CREATE NONCLUSTERED INDEX IX_CustomersInfo_EmployeeID
ON CustomersInfo(EmployeeID);


-- ###############################################################
-- #                         8. INDEXATION                        #
-- ###############################################################

-- ============================================
-- 20. Index et maintenance
-- ============================================

-- Éviter trop d'index : ralentit insert/update/delete
-- Supprimer les index inutilisés régulièrement
-- Mettre à jour les statistiques chaque semaine
-- Réorganiser et reconstruire les index fragmentés
-- Pour grandes tables : partition + columnstore index
