/* ============================================================================== 
-- 1. Création de la base de données FORMATION
=============================================================================== */
CREATE DATABASE formation
    WITH
    OWNER = postgres       -- Propriétaire de la base
    ENCODING = 'UTF8';     -- Encodage UTF-8

/* ============================================================================== 
-- 2. Création du schéma FORMATION_SQL
=============================================================================== */
CREATE SCHEMA formation_sql AUTHORIZATION postgres;

-- Définit le schéma par défaut pour la session
SET search_path TO formation_sql;


/* ============================================================================== 
   3. TABLE TEST : démonstration complète des commandes DDL
=============================================================================== */

-- 1️⃣ Création de la table test
CREATE TABLE IF NOT EXISTS TestTable (
    ID   INTEGER NOT NULL PRIMARY KEY,
    Name VARCHAR(20) NOT NULL
);

-- 2️⃣ Ajouter une nouvelle colonne
ALTER TABLE TestTable ADD Description VARCHAR(50);

-- 3️⃣ Insérer des valeurs
INSERT INTO TestTable(ID, Name, Description) VALUES
(1, 'Apple',  'Fruit'),
(2, 'Carrot', 'Vegetable'),
(3, 'Milk',   'Dairy');

-- 4️⃣ Ajouter un commentaire sur la table (si le SGBD supporte les commentaires, ici exemple PostgreSQL)
COMMENT ON TABLE TestTable IS 'Table de test pour démontrer CREATE, ALTER, INSERT, RENAME, TRUNCATE et DROP';

-- 5️⃣ Renommer la table
ALTER TABLE TestTable RENAME TO TestTableRenamed;

-- 6️⃣ Vider complètement la table (TRUNCATE)
TRUNCATE TABLE TestTableRenamed;

-- 7️⃣ Supprimer la table
DROP TABLE TestTableRenamed;


/* ============================================================================== 
   TABLE Product
=============================================================================== */
DROP TABLE IF EXISTS Product;

-- Création partielle
CREATE TABLE IF NOT EXISTS Product(
   ProductID INTEGER NOT NULL PRIMARY KEY,
   Product   VARCHAR(6) NOT NULL,
   Category  VARCHAR(11) NOT NULL
);

-- Ajouter colonne Price
ALTER TABLE Product ADD Price INTEGER NOT NULL;

-- Insertion des données
INSERT INTO Product(ProductID, Product, Category, Price) VALUES 
(101, 'Bottle', 'Accessories', 10),
(102, 'Tire',   'Accessories', 15),
(103, 'Socks',  'Clothing',    20),
(104, 'Caps',   'Clothing',    25),
(105, 'Gloves', 'Clothing',    30),
(106, 'Gloveszz', 'zzz',       30); -- Ligne test

-- Supprimer la ligne test
DELETE FROM Product WHERE ProductID = 106;

-- Renommer colonne Product en ProductName
ALTER TABLE Product RENAME COLUMN Product TO ProductName;


/* ============================================================================== 
   TABLE OrdersArchive
=============================================================================== */
DROP TABLE IF EXISTS OrdersArchive;

-- Création partielle
CREATE TABLE IF NOT EXISTS OrdersArchive(
   OrderID       INTEGER NOT NULL PRIMARY KEY,
   ProductID     INTEGER NOT NULL,
   CustomerID    INTEGER NOT NULL,
   SalesPersonID INTEGER NOT NULL
);

-- Ajouter colonnes manquantes
ALTER TABLE OrdersArchive ADD OrderDate DATE NOT NULL;
ALTER TABLE OrdersArchive ADD ShipDate DATE NOT NULL;
ALTER TABLE OrdersArchive ADD OrderStatus VARCHAR(9) NOT NULL;
ALTER TABLE OrdersArchive ADD ShipAddress VARCHAR(16) NOT NULL;
ALTER TABLE OrdersArchive ADD BillAddress VARCHAR(14);
ALTER TABLE OrdersArchive ADD Quantity INTEGER NOT NULL;
ALTER TABLE OrdersArchive ADD Sales INTEGER NOT NULL;
ALTER TABLE OrdersArchive ADD CreationTime VARCHAR(27) NOT NULL;

-- Insertion des données
INSERT INTO OrdersArchive(OrderID, ProductID, CustomerID, SalesPersonID, OrderDate, ShipDate, OrderStatus, ShipAddress, BillAddress, Quantity, Sales, CreationTime) VALUES
(1, 101, 2, 3, '2024-04-01', '2024-04-05', 'Shipped',   '123 Main St', '456 Billing St', 1, 10, '2024-04-01 12:34:56.0000000'),
(2, 102, 3, 3, '2024-04-05', '2024-04-10', 'Shipped',   '456 Elm St',  '789 Billing St', 1, 15, '2024-04-05 23:22:04.0000000'),
(3, 101, 1, 4, '2024-04-10', '2024-04-25', 'Shipped',   '789 Maple St','789 Maple St',   2, 20, '2024-04-10 18:24:08.0000000'),
(4, 105, 1, 3, '2024-04-20', '2024-04-25', 'Shipped',   '987 Victory Lane', NULL, 2, 60, '2024-04-20 05:50:33.0000000'),
(5, 104, 2, 5, '2024-05-01', '2024-05-05', 'Shipped',   '345 Oak St',  '678 Pine St',   1, 25, '2024-05-01 14:02:41.0000000'),
(6, 104, 3, 5, '2024-05-05', '2024-05-10', 'Delivered', '543 Belmont Rd.', NULL, 2, 50, '2024-05-06 15:34:57.0000000'),
(7, 102, 3, 5, '2024-06-15', '2024-06-20', 'Shipped',   '111 Main St',  '222 Billing St', 0, 60, '2024-06-16 23:25:15.0000000'),
(8, 999, 999, 999, '2024-06-20', '2024-06-22', 'Error',    'Test', 'Test', 1, 0, '2024-06-20'); -- Ligne test

-- Supprimer la ligne test
DELETE FROM OrdersArchive WHERE OrderID = 8;

-- Renommer colonne OrderStatus en Status
ALTER TABLE OrdersArchive RENAME COLUMN OrderStatus TO Status;


/* ============================================================================== 
   TABLE Orders
=============================================================================== */
DROP TABLE IF EXISTS Orders;

-- Création partielle
CREATE TABLE IF NOT EXISTS Orders(
   OrderID       INTEGER NOT NULL PRIMARY KEY,
   ProductID     INTEGER NOT NULL,
   CustomerID    INTEGER NOT NULL,
   SalesPersonID INTEGER NOT NULL
);

-- Ajouter colonnes manquantes
ALTER TABLE Orders ADD OrderDate DATE NOT NULL;
ALTER TABLE Orders ADD ShipDate DATE NOT NULL;
ALTER TABLE Orders ADD OrderStatus VARCHAR(9) NOT NULL;
ALTER TABLE Orders ADD ShipAddress VARCHAR(16);
ALTER TABLE Orders ADD BillAddress VARCHAR(14);
ALTER TABLE Orders ADD Quantity INTEGER NOT NULL;
ALTER TABLE Orders ADD Sales INTEGER NOT NULL;
ALTER TABLE Orders ADD CreationTime VARCHAR(27) NOT NULL;

-- Insérer données
INSERT INTO Orders(OrderID, ProductID, CustomerID, SalesPersonID, OrderDate, ShipDate, OrderStatus, ShipAddress, BillAddress, Quantity, Sales, CreationTime) VALUES
(1, 101, 2, 3, '2025-01-01', '2025-01-05', 'Delivered', '9833 Mt. Dias Blv.', '1226 Shoe St.', 1, 10, '2025-01-01 12:34:56.0000000'),
(2, 102, 3, 3, '2025-01-05', '2025-01-10', 'Shipped',   '250 Race Court', NULL, 1, 15, '2025-01-05 23:22:04.0000000'),
(3, 101, 1, 5, '2025-01-10', '2025-01-25', 'Delivered', '8157 W. Book',   '8157 W. Book', 2, 20, '2025-01-10 18:24:08.0000000'),
(4, 105, 1, 3, '2025-01-20', '2025-01-25', 'Shipped',   '5724 Victory Lane', NULL, 2, 60, '2025-01-20 05:50:33.0000000'),
(5, 104, 2, 5, '2025-02-01', '2025-02-05', 'Delivered', NULL, NULL, 1, 25, '2025-02-01 14:02:41.0000000'),
(6, 104, 3, 5, '2025-02-05', '2025-02-10', 'Delivered', '1792 Belmont Rd.', NULL, 2, 50, '2025-02-06 15:34:57.0000000'),
(9, 999, 999, 999, '2025-02-10', '2025-02-12', 'Error', NULL, NULL, 1, 0, '2025-02-10'); -- Ligne test

-- Supprimer la ligne test
DELETE FROM Orders WHERE OrderID = 9;

-- Renommer colonne OrderStatus en Status
ALTER TABLE Orders RENAME COLUMN OrderStatus TO Status;


/* ============================================================================== 
   TABLE Employees
=============================================================================== */
DROP TABLE IF EXISTS Employees;

-- Création partielle
CREATE TABLE IF NOT EXISTS Employees(
   EmployeeID INTEGER NOT NULL PRIMARY KEY,
   FirstName  VARCHAR(7) NOT NULL,
   LastName   VARCHAR(5),
   Department VARCHAR(9) NOT NULL
);

-- Ajouter colonnes manquantes
ALTER TABLE Employees ADD BirthDate DATE NOT NULL;
ALTER TABLE Employees ADD Gender VARCHAR(1) NOT NULL;
ALTER TABLE Employees ADD Salary INTEGER NOT NULL;
ALTER TABLE Employees ADD ManagerID INTEGER;

-- Insertion des données
INSERT INTO Employees(EmployeeID, FirstName, LastName, Department, BirthDate, Gender, Salary, ManagerID) VALUES
(1, 'Frank',   'Lee',    'Marketing', '1988-12-05', 'M', 55000, NULL),
(2, 'Kevin',   'Brown',  'Marketing', '1972-11-25', 'M', 65000, 1),
(3, 'Mary',    NULL,     'Sales',     '1986-01-05', 'F', 75000, 1),
(4, 'Michael', 'Ray',    'Sales',     '1977-02-10', 'M', 90000, 2),
(5, 'Carol',   'Baker',  'Sales',     '1982-02-11', 'F', 55000, 3),
(6, 'Test',    'X',      'TestDept',  '2000-01-01', 'M', 0, NULL); -- Ligne test

-- Supprimer la ligne test
DELETE FROM Employees WHERE EmployeeID = 6;

-- Renommer colonne FirstName en GivenName
ALTER TABLE Employees RENAME COLUMN FirstName TO GivenName;


/* ============================================================================== 
   TABLE Customers
=============================================================================== */
DROP TABLE IF EXISTS Customers;

-- Création partielle
CREATE TABLE IF NOT EXISTS Customers(
   CustomerID INTEGER NOT NULL PRIMARY KEY,
   FirstName  VARCHAR(6) NOT NULL,
   LastName   VARCHAR(8)
);

-- Ajouter colonnes manquantes
ALTER TABLE Customers ADD Country VARCHAR(7) NOT NULL;
ALTER TABLE Customers ADD Score INTEGER;

-- Insérer données
INSERT INTO Customers(CustomerID, FirstName, LastName, Country, Score) VALUES
(1, 'Jossef', 'Goldberg', 'Germany', 350),
(2, 'Kevin',  'Brown',    'USA',     900),
(3, 'Mary',   NULL,       'USA',     750),
(4, 'Mark',   'Schwarz',  'Germany', 500),
(5, 'Anna',   'Adams',    'USA',     NULL),
(6, 'Test',   'X',        'ZZZ',     0); -- Ligne test

-- Supprimer ligne test
DELETE FROM Customers WHERE CustomerID = 6;

-- Renommer colonne FirstName en GivenName
ALTER TABLE Customers RENAME COLUMN FirstName TO GivenName;
