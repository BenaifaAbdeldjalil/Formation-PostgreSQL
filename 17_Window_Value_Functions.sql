/* ==============================================================================
   FONCTIONS DE VALEUR FENÊTRE SQL (SQL Window Value Functions)
-------------------------------------------------------------------------------
   Ces fonctions permettent de référencer et comparer les valeurs d’autres lignes
   dans un jeu de résultats, sans utiliser de jointures ou sous-requêtes complexes.
   Elles sont idéales pour l’analyse temporelle et les comparaisons entre lignes
   ordonnées.

   Table des matières :
     1. LEAD
     2. LAG
     3. FIRST_VALUE
     4. LAST_VALUE
=================================================================================
*/

/* ============================================================
   FONCTIONS VALEUR FENÊTRE | LEAD, LAG
============================================================ */

/* TÂCHE 1 :
   Analyse Mois par Mois (Month-over-Month)
   Calculer l’évolution des ventes entre le mois courant et le mois précédent
   - LAG permet de récupérer les ventes du mois précédent
   - On calcule ensuite la variation absolue et le pourcentage d’évolution
*/

    SELECT
        DATE_TRUNC('month', orderdate) AS order_month,
        SUM(sales) AS current_month_sales,
        LAG(SUM(sales)) OVER (
            ORDER BY DATE_TRUNC('month', orderdate)
        ) AS previous_month_sales
    FROM  Orders
    GROUP BY DATE_TRUNC('month', orderdate)


/* ============================================================
   CAS PRATIQUE | ANALYSE DE FIDÉLITÉ CLIENT
============================================================ */

/*   Analyse de la fidélité client
   Classer les clients selon le nombre moyen de jours entre leurs commandes
   - LEAD récupère la date de la commande suivante
   - La différence de dates donne le délai entre deux commandes
   - Plus le délai est court, plus le client est fidèle
*/
SELECT
        OrderID,
        CustomerID,
        OrderDate AS current_order_date,
        LEAD(OrderDate) OVER (
            PARTITION BY CustomerID
            ORDER BY OrderDate
        ) AS next_order_date
    FROM  Orders


/* ============================================================
   FONCTIONS VALEUR FENÊTRE | FIRST_VALUE & LAST_VALUE
============================================================ */

/*    Trouver la vente minimale et maximale pour chaque produit
   et calculer l’écart entre la vente courante et la vente minimale

   - FIRST_VALUE : première valeur dans la fenêtre (vente la plus basse)
   - LAST_VALUE : dernière valeur dans la fenêtre (vente la plus élevée)
   ⚠️ LAST_VALUE nécessite une clause FRAME explicite en PostgreSQL
*/

SELECT
    OrderID,
    ProductID,
    Sales,
    FIRST_VALUE(Sales) OVER (
        PARTITION BY ProductID
        ORDER BY Sales
    ) AS lowest_sales,
    LAST_VALUE(Sales) OVER (
        PARTITION BY ProductID
        ORDER BY Sales
        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
    ) AS highest_sales,
    Sales - FIRST_VALUE(Sales) OVER (
        PARTITION BY ProductID
        ORDER BY Sales
    ) AS sales_difference_from_min
FROM  Orders;
