/* ==============================================================================
   FONCTIONS FENÊTRE SQL (SQL WINDOW FUNCTIONS)
-------------------------------------------------------------------------------
   Table des matières :
     1. Bases des fonctions fenêtre
     2. Clause OVER
     3. Clause PARTITION
     4. Clause ORDER
     5. Clause FRAME
     6. Règles importantes
     7. Utilisation avec GROUP BY
=================================================================================
*/

/* ==============================================================================
   FONCTIONS FENÊTRE SQL | BASES
===============================================================================*/

/*Calculer le chiffre d'affaires total de toutes les commandes 
   (sans distinction de produit ni de statut)
*/

select * FROM  Orders;

SELECT
    SUM(Sales) AS Total_Sales
FROM  Orders;

/* Calculer le chiffre d'affaires total par produit
   (agrégation classique avec GROUP BY)
*/
SELECT 
    ProductID,
    SUM(Sales) AS Total_Sales
FROM  Orders
GROUP BY ProductID;

/* ==============================================================================
   FONCTIONS FENÊTRE SQL | CLAUSE OVER
===============================================================================*/

/* Trouver le chiffre d'affaires total de toutes les commandes,
   tout en affichant les détails de chaque commande (OrderID, OrderDate, ProductID, Sales)
   La clause OVER() applique la fonction SUM sur l'ensemble des lignes sans partition
*/

SELECT
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    SUM(Sales) OVER () AS Total_Sales
FROM  Orders
 group by OrderID,
    OrderDate,
    ProductID,
    Sales 
order by OrderID asc;

SELECT
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    SUM(Sales) OVER () AS Total_Sales
FROM  Orders;

/* ==============================================================================
   FONCTIONS FENÊTRE SQL | CLAUSE PARTITION
===============================================================================*/

/* TÂCHE 4 : 
   Calculer le chiffre d'affaires total global et par produit
   La clause PARTITION BY ProductID divise les données par produit
   et applique SUM séparément pour chaque produit
*/
SELECT
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    SUM(Sales) OVER () AS Total_Sales,
    SUM(Sales) OVER (PARTITION BY ProductID) AS Sales_By_Product
FROM  Orders;

/* TÂCHE 5 : 
   Calculer le chiffre d'affaires global, par produit et par combinaison produit/statut
   (OrderStatus)
   Cela montre comment partitionner sur plusieurs colonnes pour obtenir des sous-totaux
*/
SELECT
    OrderID,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(Sales) OVER () AS Total_Sales,
    SUM(Sales) OVER (PARTITION BY ProductID) AS Sales_By_Product,
    SUM(Sales) OVER (PARTITION BY ProductID, OrderStatus) AS Sales_By_Product_Status
FROM  Orders;

/* ==============================================================================
   FONCTIONS FENÊTRE SQL | CLAUSE ORDER
===============================================================================*/

/* TÂCHE 6 : 
   Classer chaque commande selon le chiffre d'affaires (du plus élevé au plus bas)
   La fonction RANK() avec ORDER BY permet de donner un rang à chaque ligne
*/
SELECT
    OrderID,
    OrderDate,
    Sales,
    RANK() OVER (ORDER BY Sales DESC) AS Rank_Sales
FROM  Orders;

/* ==============================================================================
   FONCTIONS FENÊTRE SQL | CLAUSE FRAME
===============================================================================*/

/* TÂCHE 7 : 
   Calculer le chiffre d'affaires total par statut de commande
   pour la commande courante et les deux commandes suivantes
   La clause ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING définit la fenêtre
*/
SELECT
    OrderID,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(Sales) OVER (
        PARTITION BY OrderStatus 
        ORDER BY OrderDate 
        ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
    ) AS Total_Sales
FROM  Orders;

/* TÂCHE 8 : 
   Calculer le chiffre d'affaires total par statut pour la commande courante
   et les deux commandes précédentes
*/
SELECT
    OrderID,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(Sales) OVER (
        PARTITION BY OrderStatus 
        ORDER BY OrderDate 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS Total_Sales
FROM  Orders;

/* TÂCHE 9 : 
   Calculer le chiffre d'affaires total par statut en ne considérant que
   les deux commandes précédentes
*/
SELECT
    OrderID,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(Sales) OVER (
        PARTITION BY OrderStatus 
        ORDER BY OrderDate 
        ROWS 2 PRECEDING
    ) AS Total_Sales
FROM  Orders;

/* TÂCHE 10 : 
   Calculer le chiffre d'affaires cumulatif par statut de commande jusqu'à
   la commande courante
*/
SELECT
    OrderID,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(Sales) OVER (
        PARTITION BY OrderStatus 
        ORDER BY OrderDate 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS Total_Sales
FROM  Orders;

/* TÂCHE 11 : 
   Variante simplifiée : chiffre d'affaires cumulatif par statut depuis
   le début jusqu'à la ligne courante
*/
SELECT
    OrderID,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(Sales) OVER (
        PARTITION BY OrderStatus 
        ORDER BY OrderDate 
        ROWS UNBOUNDED PRECEDING
    ) AS Total_Sales
FROM  Orders;

/* ==============================================================================
   FONCTIONS FENÊTRE SQL | RÈGLES
===============================================================================*/

/* RÈGLE 1 : 
   Les fonctions fenêtre ne peuvent être utilisées que dans SELECT ou ORDER BY
   Elles **ne peuvent pas** être utilisées dans WHERE ou HAVING
*/
SELECT
    OrderID,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(Sales) OVER (PARTITION BY OrderStatus) AS Total_Sales
FROM  Orders
WHERE SUM(Sales) OVER (PARTITION BY OrderStatus) > 100;  -- ❌ Invalide

/* RÈGLE 2 : 
   Les fonctions fenêtre ne peuvent pas être imbriquées
   (on ne peut pas appliquer une fonction fenêtre sur le résultat d’une autre fonction fenêtre)
*/
SELECT
    OrderID,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(SUM(Sales) OVER (PARTITION BY OrderStatus)) OVER (PARTITION BY OrderStatus) AS Total_Sales  -- ❌ Invalide
FROM  Orders;

/* ==============================================================================
   FONCTIONS FENÊTRE SQL | UTILISATION AVEC GROUP BY
===============================================================================*/

/* TÂCHE 12 : 
   Classer les clients selon leur chiffre d'affaires total
   GROUP BY calcule le total par client, puis RANK() classe les clients
*/
SELECT
    CustomerID,
    SUM(Sales) AS Total_Sales,
    RANK() OVER (ORDER BY SUM(Sales) DESC) AS Rank_Customers
FROM  Orders
GROUP BY CustomerID;
