/* ==============================================================================
   SQL – OPÉRATIONS ENSEMBLE (SET OPERATIONS)
-------------------------------------------------------------------------------
   Les opérations ensemblistes permettent de combiner les résultats
   de plusieurs requêtes SELECT en un seul résultat.

   Opérations disponibles :
     - UNION        → fusion sans doublons
     - UNION ALL    → fusion avec doublons
     - EXCEPT       → différence
     - INTERSECT    → intersection

   Sommaire :
     1. Règles des opérations ensemblistes
     2. UNION
     3. UNION ALL
     4. EXCEPT
     5. INTERSECT
=================================================================================
*/

/* ==============================================================================
   SQL — OPÉRATIONS ENSEMBLISTES (RÉVISION EXPRESS)
============================================================================= */

/* RÈGLE 1 — Nombre de colonnes
   Chaque SELECT doit retourner le MÊME NOMBRE de colonnes
*/
-- ❌ 3 colonnes ≠ 2 colonnes
SELECT FirstName, LastName, Country
FROM Customers
UNION
SELECT FirstName, LastName
FROM Employees;


/* RÈGLE 2 — Type de données
   Les colonnes comparées doivent avoir des TYPES COMPATIBLES
*/
-- ❌ INT ≠ VARCHAR
SELECT CustomerID,FirstName,LastName
FROM Customers
UNION
SELECT FirstName,LastName
FROM Employees;


/* RÈGLE 3 — Ordre des colonnes
   Les colonnes sont comparées par POSITION
*/
-- ❌ Ordre différent
SELECT LastName, CustomerID
FROM Customers
UNION
SELECT EmployeeID, LastName
FROM Employees;


/* RÈGLE 4 — Alias de colonnes
   Les noms finaux viennent du PREMIER SELECT
*/
SELECT CustomerID AS ID, LastName AS Last_Name
FROM Customers
UNION
SELECT EmployeeID, LastName
FROM Employees;


/* RÈGLE 5 — Cohérence des données
   Les colonnes doivent représenter la MÊME information
*/
-- ❌ Prénom ≠ Nom
SELECT FirstName, LastName
FROM Customers
UNION
SELECT LastName, FirstName
FROM Employees;


/* ==============================================================================
   OPÉRATIONS ENSEMBLISTES
============================================================================= */

/* UNION — fusion sans doublons */
SELECT FirstName, LastName FROM Customers
UNION
SELECT FirstName, LastName FROM Employees;

/* UNION ALL — fusion avec doublons */
SELECT FirstName, LastName FROM Customers
UNION ALL
SELECT FirstName, LastName FROM Employees;

/* EXCEPT — présent dans le 1er, absent du 2e */
SELECT FirstName, LastName FROM Sales.Employees
EXCEPT
SELECT FirstName, LastName FROM Sales.Customers;

/* INTERSECT — présent dans les deux */
SELECT FirstName, LastName FROM Sales.Employees
INTERSECT
SELECT FirstName, LastName FROM Sales.Customers;


/* ==============================================================================
   CAS PRATIQUE — FUSION D’HISTORIQUE
============================================================================= */

SELECT 'Orders' AS SourceTable, OrderID, ProductID, CustomerID,
       SalesPersonID, OrderDate, ShipDate, OrderStatus,
       ShipAddress, BillAddress, Quantity, Sales, CreationTime
FROM Orders

UNION

SELECT 'OrdersArchive', OrderID, ProductID, CustomerID,
       SalesPersonID, OrderDate, ShipDate, OrderStatus,
       ShipAddress, BillAddress, Quantity, Sales, CreationTime
FROM OrdersArchive

ORDER BY OrderID;
