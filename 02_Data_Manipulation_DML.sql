/* ==============================================================================
   SQL – MANIPULATION DES DONNÉES (DML : Data Manipulation Language)
-------------------------------------------------------------------------------
   Ce guide présente les commandes DML essentielles permettant de :
   - insérer des données
   - modifier des données existantes
   - supprimer des données dans les tables

   Sommaire :
     1. INSERT  → Ajouter des données
     2. UPDATE  → Modifier des données
     3. DELETE  → Supprimer des données
=================================================================================*/
/* ==============================================================================
   INSERT (AJOUTER DES DONNÉES)
=============================================================================== */
/* Méthode 1 : INSERT manuel avec VALUES */

-- Insérer un client avec toutes les colonnes correctement renseignées
INSERT INTO  formation_sql.customers (id, firstname,lastname , country, score)
VALUES (8, 'Max','DJO', 'USA', 368);

INSERT INTO  customers (id, firstname,lastname , country, score)
VALUES (88, 'test2','DJO', 'dza', 400);

-- Insérer sans préciser les colonnes (déconseillé)
INSERT INTO formation_sql.customers 
VALUES
    (9, 'Andrs', 'Germany', 'a',NULL);

-- Insérer seulement certaines colonnes
-- Les autres prendront la valeur NULL ou la valeur par défaut
INSERT INTO formation_sql.customers  (id, firstname)
VALUES
    (10, 'Sahra');

-- Exemple d’erreur : type de données incorrect
INSERT INTO formation_sql.customers  (id, firstname, country, score)
VALUES
    ('Max', 9, 'Max', NULL);

-- Insertion des données 
-- LIGNE PAR LIGNE
INSERT INTO formation_sql.OrdersArchive(OrderID, ProductID, CustomerID, SalesPersonID, OrderDate, ShipDate, OrderStatus, ShipAddress, BillAddress, Quantity, Sales, CreationTime) VALUES
(1, 101, 2, 3, '2024-04-01', '2024-04-05', 'Shipped',   '123 Main St', '456 Billing St', 1, 10, '2024-04-01 12:34:56.0000000');

INSERT INTO formation_sql.OrdersArchive(OrderID, ProductID, CustomerID, SalesPersonID, OrderDate, ShipDate, OrderStatus, ShipAddress, BillAddress, Quantity, Sales, CreationTime) VALUES
(2, 102, 3, 3, '2024-04-05', '2024-04-10', 'Shipped',   '456 Elm St',  '789 Billing St', 1, 15, '2024-04-05 23:22:04.0000000');

-- INSERER PLUSIEURS LIGNES
INSERT INTO formation_sql.OrdersArchive(OrderID, ProductID, CustomerID, SalesPersonID, OrderDate, ShipDate, OrderStatus, ShipAddress, BillAddress, Quantity, Sales, CreationTime) VALUES
(3, 101, 1, 4, '2024-04-10', '2024-04-25', 'Shipped',   '789 Maple St','789 Maple St',   2, 20, '2024-04-10 18:24:08.0000000'),
(4, 105, 1, 3, '2024-04-20', '2024-04-25', 'Shipped',   '987 Victory Lane', NULL, 2, 60, '2024-04-20 05:50:33.0000000'),
(5, 104, 2, 5, '2024-05-01', '2024-05-05', 'Shipped',   '345 Oak St',  '678 Pine St',   1, 25, '2024-05-01 14:02:41.0000000'),
(6, 104, 3, 5, '2024-05-05', '2024-05-10', 'Delivered', '543 Belmont Rd.', NULL, 2, 50, '2024-05-06 15:34:57.0000000'),
(7, 102, 3, 5, '2024-06-15', '2024-06-20', 'Shipped',   '111 Main St',  '222 Billing St', 0, 60, '2024-06-16 23:25:15.0000000'),
(8, 999, 999, 999, '2024-06-20', '2024-06-22', 'Error',    'Test', 'Test', 1, 0, '2024-06-20'); -- Ligne test

-- Insérer données
INSERT INTO formation_sql.Orders(OrderID, ProductID, CustomerID, SalesPersonID, OrderDate, ShipDate, OrderStatus, ShipAddress, BillAddress, Quantity, Sales, CreationTime) VALUES
(1, 101, 2, 3, '2025-01-01', '2025-01-05', 'Delivered', '9833 Mt. Dias', '1226 Shoe St.', 1, 10, '2025-01-01 12:34:56.0000000'),
(2, 102, 3, 3, '2025-01-05', '2025-01-10', 'Shipped',   '250 Race Court', NULL, 1, 15, '2025-01-05 23:22:04.0000000'),
(3, 101, 1, 5, '2025-01-10', '2025-01-25', 'Delivered', '8157 W. Book',   '8157 W. Book', 2, 20, '2025-01-10 18:24:08.0000000'),
(4, 105, 1, 3, '2025-01-20', '2025-01-25', 'Shipped',   '5724 Victory', NULL, 2, 60, '2025-01-20 05:50:33.0000000'),
(5, 104, 2, 5, '2025-02-01', '2025-02-05', 'Delivered', NULL, NULL, 1, 25, '2025-02-01 14:02:41.0000000'),
(6, 104, 3, 5, '2025-02-05', '2025-02-10', 'Delivered', '1792 Belmont', NULL, 2, 50, '2025-02-06 15:34:57.0000000'),
(9, 999, 999, 999, '2025-02-10', '2025-02-12', 'Error', NULL, NULL, 1, 0, '2025-02-10'); -- Ligne test

-- Insertion des données
INSERT INTO formation_sql.Employees(EmployeeID, FirstName, LastName, Department, BirthDate, Gender, Salary, ManagerID) VALUES
(1, 'Frank',   'Lee',    'Marketing', '1988-12-05', 'M', 55000, NULL),
(2, 'Kevin',   'Brown',  'Marketing', '1972-11-25', 'M', 65000, 1),
(3, 'Mary',    NULL,     'Sales',     '1986-01-05', 'F', 75000, 1),
(4, 'Michael', 'Ray',    'Sales',     '1977-02-10', 'M', 90000, 2),
(5, 'Carol',   'Baker',  'Sales',     '1982-02-11', 'F', 55000, 3),
(6, 'Test',    'X',      'TestDept',  '2000-01-01', 'M', 0, NULL); -- Ligne test

-- Insérer données
INSERT INTO formation_sql.Customers(ID, FirstName, LastName, Country, Score) VALUES
(1, 'Jossef', 'Goldberg', 'Germany', 350),
(2, 'Kevin',  'Brown',    'USA',     900),
(3, 'Mary',   NULL,       'USA',     750),
(4, 'Mark',   'Schwarz',  'Germany', 500),
(5, 'Anna',   'Adams',    'USA',     NULL),
(6, 'Test',   'X',        'ZZZ',     55); -- Ligne test


/* Méthode 2 : INSERT avec SELECT
   Permet de copier des données d’une table vers une autre */

CREATE TABLE formation_sql.persons (
	id int4 NOT NULL,
	person_name varchar(20) ,
	person_lastname varchar(20) 
);


-- Copier les données de customers vers la table persons
INSERT INTO formation_sql.persons (id, person_name, person_lastname)
SELECT
    id,
    firstname,
    lastname
FROM formation_sql.customers;



/* ==============================================================================
   UPDATE (MODIFIER DES DONNÉES)
=============================================================================== */

-- Modifier le score du client ayant l’ID 6
UPDATE formation_sql.customers
SET score = 0
WHERE id = 6;

-- Modifier plusieurs colonnes pour un client
UPDATE formation_sql.customers
SET score = 0,
    country = 'UK'
WHERE id = 10;

-- Mettre le score à 0 pour tous les clients dont le score est NULL
UPDATE formation_sql.customers
SET score = 0
WHERE score IS NULL;

-- Vérifier les lignes concernées
SELECT *
FROM formation_sql.customers
WHERE score IS NULL;

/* ==============================================================================
   DELETE (SUPPRIMER DES DONNÉES)
=============================================================================== */
-- Supprimer la ligne test
DELETE FROM formation_sql.OrdersArchive WHERE OrderID = 8;

-- Supprimer la ligne test
DELETE FROM formation_sql.Orders WHERE OrderID = 9;

-- Supprimer la ligne test
DELETE FROM formation_sql.Employees WHERE EmployeeID = 6;


-- Supprimer ligne test
DELETE FROM formation_sql.Customers WHERE ID = 6;

-- Vérifier les clients avant suppression
SELECT *
FROM formation_sql.customers
WHERE id > 5;

-- Supprimer les clients ayant un ID supérieur à 5
DELETE FROM customers
WHERE id > 5;

-- Supprimer toutes les lignes de la table persons
DELETE FROM persons;

-- Supprimer toutes les lignes plus rapidement (irréversible)
TRUNCATE TABLE persons;


/*
================================================================================
TRUNCATE vs DELETE - PostgreSQL

1️ DELETE
   - Supprime des lignes **une par une** selon une condition.
   - Plus lent sur de grandes tables car chaque suppression est journalisée (WAL).
   - Exemple :
       -- Supprime tous les clients
       DELETE FROM clients;
       -- Supprime les clients dont le pays est 'France'
       DELETE FROM clients WHERE pays = 'France';

2️ TRUNCATE
   - Supprime **toutes les lignes d’une table très rapidement**.
   - Plus rapide que DELETE pour vider une table entière.
   - Exemple :
       -- Vide complètement la table clients
       TRUNCATE TABLE clients;
       -- Vide la table clients et toutes les tables qui en dépendent
       TRUNCATE TABLE clients CASCADE;
/* ==============================================================================
=============================================================================== */


