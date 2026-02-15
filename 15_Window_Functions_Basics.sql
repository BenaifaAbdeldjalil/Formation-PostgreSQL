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

--------------
SELECT 
    ProductID,
    SUM(Sales) over() AS Total_Sales 
FROM  Orders ;

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
    SUM(Sales)
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

/* Calculer le chiffre d'affaires total global et par produit
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
---101


/* Calculer le chiffre d'affaires global, par produit et par combinaison produit/statut
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
---104

/* ==============================================================================
   FONCTIONS FENÊTRE SQL | CLAUSE FRAME
===============================================================================*/

/* Calculer le chiffre d'affaires total par statut de commande
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
        ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING
    ) AS Total_Sales
FROM  Orders;

/* Calculer le chiffre d'affaires total par statut pour la commande courante
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
        ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
    ) AS Total_Sales
FROM  Orders;



/*    Calculer le chiffre d'affaires cumulatif par statut de commande jusqu'à
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

/* Variante simplifiée : chiffre d'affaires cumulatif par statut depuis
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

