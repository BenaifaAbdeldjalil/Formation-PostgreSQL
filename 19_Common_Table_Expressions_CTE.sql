/* ==============================================================================
   Expressions de Table Communes (CTE – Common Table Expressions)
-------------------------------------------------------------------------------
   Ce script illustre l’utilisation des CTE en SQL.

   Les CTE permettent de définir des requêtes temporaires nommées,
   utilisables uniquement dans la requête principale qui suit.
   Elles améliorent fortement la lisibilité, la structuration et
   la maintenance des requêtes SQL complexes.

   Ce script présente :
   - des CTE non récursives pour l’agrégation, le classement et la segmentation
   - des CTE récursives pour générer des séquences
   - des CTE récursives pour construire des hiérarchies

   Sommaire :
     1. CTE NON RÉCURSIVES
     2. CTE RÉCURSIVES | GÉNÉRATION DE SÉQUENCE
     3. CTE RÉCURSIVES | CONSTRUCTION D’UNE HIÉRARCHIE
     4. COMPARAISON : CTE vs SOUS-REQUÊTES
===============================================================================
*/

/* ==============================================================================
   CTE NON RÉCURSIVES
===============================================================================*/

/* Étape 1 :
   Calculer le chiffre d’affaires total par client
   (CTE indépendante)
*/
WITH CTE_Total_Sales AS (
    SELECT
        CustomerID,
        SUM(Sales) AS TotalSales
    FROM   Orders
    GROUP BY CustomerID
),

/* Étape 2 :
   Trouver la date de la dernière commande pour chaque client
   (CTE indépendante)
*/
CTE_Last_Order AS (
    SELECT
        CustomerID,
        MAX(OrderDate) AS Last_Order
    FROM   Orders
    GROUP BY CustomerID
),

/* Étape 3 :
   Classer les clients selon leur chiffre d’affaires total
   (CTE imbriquée basée sur une CTE précédente)
*/
CTE_Customer_Rank AS (
    SELECT
        CustomerID,
        TotalSales,
        RANK() OVER (ORDER BY TotalSales DESC) AS CustomerRank
    FROM CTE_Total_Sales
),

/* Étape 4 :
   Segmenter les clients selon leur niveau de ventes
   (logique métier intégrée dans une CTE)
*/
CTE_Customer_Segments AS (
    SELECT
        CustomerID,
        TotalSales,
        CASE
            WHEN TotalSales > 100 THEN 'High'
            WHEN TotalSales > 80  THEN 'Medium'
            ELSE 'Low'
        END AS CustomerSegments
    FROM CTE_Total_Sales
)

-- Requête principale : combinaison de toutes les CTE
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    cts.TotalSales,
    clo.Last_Order,
    ccr.CustomerRank,
    ccs.CustomerSegments
FROM   Customers AS c
LEFT JOIN CTE_Total_Sales AS cts
    ON c.CustomerID = cts.CustomerID
LEFT JOIN CTE_Last_Order AS clo
    ON c.CustomerID = clo.CustomerID
LEFT JOIN CTE_Customer_Rank AS ccr
    ON c.CustomerID = ccr.CustomerID
LEFT JOIN CTE_Customer_Segments AS ccs
    ON c.CustomerID = ccs.CustomerID;

/* ==============================================================================
   CTE RÉCURSIVES | GÉNÉRATION DE SÉQUENCE
===============================================================================*/

/*   ----------- 2 :
   Générer une suite de nombres de 1 à 20
*/
WITH RECURSIVE Series AS (
    -- Requête d’ancrage : point de départ
    SELECT 1 AS MyNumber
    UNION ALL
    -- Requête récursive : incrémentation
    SELECT MyNumber + 1
    FROM Series
    WHERE MyNumber < 20
)
SELECT *
FROM Series;

/*   ----------- 3 :
   Générer une suite de nombres de 1 à 1000
*/
WITH RECURSIVE Series AS (
    SELECT 1 AS MyNumber
    UNION ALL
    SELECT MyNumber + 1
    FROM Series
    WHERE MyNumber < 1000
)
SELECT *
FROM Series;

/* ==============================================================================
   CTE RÉCURSIVES | CONSTRUCTION D’UNE HIÉRARCHIE
===============================================================================*/

/*   ----------- 4 :
   Construire la hiérarchie des employés en indiquant leur niveau
   - Requête d’ancrage : employés sans manager
   - Requête récursive : rattachement des subordonnés
*/
WITH RECURSIVE CTE_Emp_Hierarchy AS (
    -- Niveau supérieur (sans manager)
    SELECT
        EmployeeID,
        FirstName,
        ManagerID,
        1 AS Level
    FROM   Employees
    WHERE ManagerID IS NULL

    UNION ALL

    -- Niveaux inférieurs
    SELECT
        e.EmployeeID,
        e.FirstName,
        e.ManagerID,
        ceh.Level + 1
    FROM   Employees AS e
    INNER JOIN CTE_Emp_Hierarchy AS ceh
        ON e.ManagerID = ceh.EmployeeID
)
SELECT *
FROM CTE_Emp_Hierarchy;

/* ==============================================================================
   COMPARAISON : CTE vs SOUS-REQUÊTES
===============================================================================*/

/*
CTE (WITH)
---------
✔ Améliore fortement la lisibilité
✔ Permet de découper une requête complexe en étapes claires
✔ Supporte la récursivité (hiérarchies, séquences)
✔ Idéal pour les analyses, le reporting et la pédagogie
✘ Non réutilisable en dehors de la requête
✘ Temporaire (non persisté)

Sous-requêtes
-------------
✔ Simples et efficaces pour des calculs ponctuels
✔ Pas besoin de structure supplémentaire
✔ Souvent très performantes pour des cas simples
✘ Peu lisibles lorsqu’elles sont imbriquées
✘ Difficiles à maintenir sur des requêtes complexes
✘ Ne supportent pas la récursivité

Règle pratique :
---------------
- Logique complexe ou multi-étapes → CTE
- Calcul simple et ponctuel        → Sous-requête
*/
