/* 
DIFFERENCE ENTRE TABLE, VUE, VUE MATERIALISEE ET TABLE TEMPORAIRE

TABLE              -> données permanentes
VIEW               -> requête virtuelle
MATERIALIZED VIEW  -> résultat stocké d'une requête
TEMP TABLE         -> données temporaires pour un traitement

1) TABLE
- Stocke physiquement les données dans la base.
- Les données sont permanentes.
- On peut faire INSERT, UPDATE, DELETE.

Syntaxe :
CREATE TABLE nom_table (
    colonne1 TYPE,
    colonne2 TYPE
);

------------------------------------------------------------

2) VIEW (VUE)
- Ne stocke pas les données.
- Contient seulement une requête SELECT.
- Les données sont calculées à chaque appel.

Syntaxe :
CREATE VIEW nom_vue AS
SELECT colonnes
FROM table
WHERE condition;

------------------------------------------------------------

3) MATERIALIZED VIEW (VUE MATERIALISEE)
- Stocke le résultat de la requête comme une table.
- Améliore les performances pour les requêtes lourdes.
- Doit être rafraîchie pour mettre à jour les données.

Syntaxe :
CREATE MATERIALIZED VIEW nom_vue_mat AS
SELECT colonnes
FROM table;

Actualisation :
REFRESH MATERIALIZED VIEW nom_vue_mat;

------------------------------------------------------------

4) TABLE TEMPORAIRE
- Table utilisée seulement pendant la session.
- Les données sont supprimées automatiquement à la fin.

Syntaxe :
CREATE TEMP TABLE nom_table_temp (
    colonne1 TYPE,
    colonne2 TYPE
);

*/
/* ==============================================================================
   VUES SQL (SQL VIEWS)
-------------------------------------------------------------------------------
   Ce script illustre les principaux cas d’usage des vues en SQL (PostgreSQL).

   Une vue est une requête enregistrée qui permet :
   - de simplifier l’écriture des requêtes
   - de masquer la complexité (jointures, agrégations)
   - de renforcer la sécurité en limitant l’accès à certaines données

   Ce script couvre :
     1. Création, suppression et modification d’une vue
     2. Cas d’usage : masquer la complexité
     3. Cas d’usage : sécurité des données
     4. Vues matérialisées
     5. Différences entre vue et vue matérialisée
===============================================================================
*/

/* ==============================================================================
   1. CRÉER, SUPPRIMER ET MODIFIER UNE VUE
===============================================================================*/

/*
 Objectif :
 Créer une vue qui résume les ventes mensuelles avec :
   - le mois de commande
   - le total des ventes
   - le nombre de commandes
   - la quantité totale vendue
*/

-- Création de la vue
CREATE VIEW V_Monthly_Summary AS
SELECT 
    DATE_TRUNC('month', OrderDate) AS OrderMonth,
    SUM(Sales) AS TotalSales,
    COUNT(OrderID) AS TotalOrders,
    SUM(Quantity) AS TotalQuantities
FROM Orders
GROUP BY DATE_TRUNC('month', OrderDate);

-- Interroger la vue comme une table
SELECT * 
FROM V_Monthly_Summary;

-- Suppression de la vue si elle existe
DROP VIEW IF EXISTS V_Monthly_Summary;

-- Recréation de la vue avec une logique modifiée
CREATE VIEW V_Monthly_Summary AS
SELECT 
    DATE_TRUNC('month', OrderDate) AS OrderMonth,
    SUM(Sales) AS TotalSales,
    COUNT(OrderID) AS TotalOrders
FROM Orders
GROUP BY DATE_TRUNC('month', OrderDate);

DROP VIEW IF EXISTS V_Monthly_Summary;


/* ==============================================================================
   2. CAS D’USAGE | MASQUER LA COMPLEXITÉ
===============================================================================*/

/*
 Objectif :
 Créer une vue qui combine plusieurs tables (Orders, Products, Customers, Employees)
 afin d’éviter de réécrire des jointures complexes dans chaque requête.
*/

CREATE VIEW V_Order_Details AS
SELECT 
    o.OrderID,
    o.OrderDate,
    p.Product,
    p.Category,
    COALESCE(c.FirstName, '') || ' ' || COALESCE(c.LastName, '') AS CustomerName,
    c.Country AS CustomerCountry,
    COALESCE(e.FirstName, '') || ' ' || COALESCE(e.LastName, '') AS SalesName,
    e.Department,
    o.Sales,
    o.Quantity
FROM Orders AS o
LEFT JOIN Product   AS p ON p.ProductID = o.ProductID
LEFT JOIN Customers AS c ON c.CustomerID = o.CustomerID
LEFT JOIN Employees AS e ON e.EmployeeID = o.SalesPersonID;

DROP VIEW IF EXISTS V_Order_Details;


/* ==============================================================================
   3. CAS D’USAGE | SÉCURITÉ DES DONNÉES
===============================================================================*/

/*
 Objectif :
 Créer une vue destinée à l’équipe commerciale européenne
 en excluant les clients basés aux États-Unis.
*/

CREATE VIEW V_Order_Details_EU AS
SELECT 
    o.OrderID,
    o.OrderDate,
    p.Product,
    p.Category,
    COALESCE(c.FirstName, '') || ' ' || COALESCE(c.LastName, '') AS CustomerName,
    c.Country AS CustomerCountry,
    COALESCE(e.FirstName, '') || ' ' || COALESCE(e.LastName, '') AS SalesName,
    e.Department,
    o.Sales,
    o.Quantity
FROM Orders AS o
LEFT JOIN Product   AS p ON p.ProductID = o.ProductID
LEFT JOIN Customers AS c ON c.CustomerID = o.CustomerID
LEFT JOIN Employees AS e ON e.EmployeeID = o.SalesPersonID
WHERE c.Country <> 'USA';

DROP VIEW IF EXISTS V_Order_Details_EU;


/* ==============================================================================
   4. VUES MATÉRIALISÉES (MATERIALIZED VIEWS)
===============================================================================*/

/*
 Une vue matérialisée stocke physiquement les résultats de la requête.
 Elle est utile pour :
   - améliorer les performances
   - éviter de recalculer des agrégations lourdes
*/

-- Création d’une vue matérialisée
CREATE MATERIALIZED VIEW MV_Monthly_Summary AS
SELECT
    DATE_TRUNC('month', OrderDate) AS OrderMonth,
    SUM(Sales) AS TotalSales,
    COUNT(OrderID) AS TotalOrders,
    SUM(Quantity) AS TotalQuantities
FROM Orders
GROUP BY DATE_TRUNC('month', OrderDate);

-- Interrogation
SELECT * 
FROM MV_Monthly_Summary;

-- Rafraîchissement manuel des données
REFRESH MATERIALIZED VIEW MV_Monthly_Summary;

-- Suppression
DROP MATERIALIZED VIEW IF EXISTS MV_Monthly_Summary;


/* ==============================================================================
   5. COMPARAISON : VUE vs VUE MATÉRIALISÉE
===============================================================================*/

/*
 VUE (VIEW)
 - Ne stocke pas les données
 - La requête est recalculée à chaque appel
 - Toujours à jour
 - Plus simple à maintenir
 - Moins performante sur de gros volumes

 VUE MATÉRIALISÉE (MATERIALIZED VIEW)
 - Stocke physiquement les résultats
 - Données figées jusqu’au REFRESH
 - Excellentes performances en lecture
 - Idéale pour le reporting et la BI
 - Nécessite une stratégie de rafraîchissement

 En résumé :
 - Vue → données temps réel, simplicité
 - Vue matérialisée → performance, reporting
*/

