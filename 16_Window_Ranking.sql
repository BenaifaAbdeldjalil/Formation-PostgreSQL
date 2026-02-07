/* ==============================================================================
   FONCTIONS DE CLASSEMENT FENÊTRE SQL (SQL Window Ranking Functions)
-------------------------------------------------------------------------------
   Table des matières :
     1. ROW_NUMBER
     2. RANK
     3. DENSE_RANK
     4. NTILE
     5. CUME_DIST
=================================================================================
*/

/* ============================================================
   CLASSEMENT FENÊTRE SQL | ROW_NUMBER, RANK, DENSE_RANK
============================================================ */

/*    Classer les commandes en fonction des ventes (du plus élevé au plus faible)
   - ROW_NUMBER : attribue un numéro unique à chaque ligne (même ventes = différents numéros)
   - RANK : même rang pour les valeurs identiques, saute les positions suivantes
   - DENSE_RANK : même rang pour les valeurs identiques, pas de saut de positions
*/
SELECT
    OrderID,
    ProductID,
    Sales,
    ROW_NUMBER() OVER (ORDER BY Sales DESC) AS ROW_NUMBER_Row,
    RANK() OVER (ORDER BY Sales DESC) AS Rank_Row, ----3
    DENSE_RANK() OVER (ORDER BY Sales DESC) AS DENSE_RANK_Row
FROM  Orders;

/*    Analyse Top-N | Trouver la vente la plus élevée pour chaque produit
*/

SELECT
        OrderID,
        ProductID,
        Sales,
        ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY Sales DESC) AS RankByProduct
    FROM  Orders
order by RankByProduct;

/* 
   Analyse Bottom-N | Trouver les 2 clients ayant le plus faible chiffre d'affaires
*/

    SELECT
        CustomerID,
        SUM(Sales) AS TotalSales,
        ROW_NUMBER() OVER (ORDER BY SUM(Sales)) AS RankCustomers
    FROM  Orders
    GROUP BY CustomerID
    order by RankCustomers asc
    --limit 2
;

/* 
   Attribution d’identifiants uniques aux lignes de la table 'OrdersArchive'
*/
SELECT
    ROW_NUMBER() OVER (ORDER BY OrderID, OrderDate) AS UniqueID,
    *
FROM  OrdersArchive;

/*    Identifier et supprimer les doublons dans 'OrdersArchive'
   - On garde uniquement la dernière version en fonction de CreationTime
*/

SELECT
        ROW_NUMBER() OVER (PARTITION BY OrderID ORDER BY CreationTime DESC) AS rn,
        *
FROM  OrdersArchive;

/* ============================================================
   CLASSEMENT FENÊTRE SQL | NTILE
============================================================ */

/*    Diviser les commandes en "buckets" (tranches) selon les ventes
   - NTILE(n) : divise les données en n groupes approximativement égaux
*/
SELECT 
    OrderID,
    Sales,
    NTILE(1) OVER (ORDER BY Sales) AS OneBucket,         -- 1 seul groupe = tout
    NTILE(2) OVER (ORDER BY Sales) AS TwoBuckets,        -- 2 groupes
    NTILE(3) OVER (ORDER BY Sales) AS ThreeBuckets,      -- 3 groupes
    NTILE(4) OVER (ORDER BY Sales) AS FourBuckets,       -- 4 groupes
    NTILE(2) OVER (PARTITION BY ProductID ORDER BY Sales) AS TwoBucketByProducts -- par produit
FROM  Orders;


/* ============================================================
   CLASSEMENT FENÊTRE SQL | CUME_DIST
============================================================ */

/*    Trouver les produits dont le prix se situe dans les 40% les plus élevés
   - CUME_DIST() : renvoie la proportion de lignes dont la valeur est inférieure
     ou égale à la ligne courante (distribution cumulative)
*/
    SELECT
        Product,
        Price,
        CUME_DIST() OVER (ORDER BY Price DESC) AS DistRank
    FROM  formation_sql.product
;
