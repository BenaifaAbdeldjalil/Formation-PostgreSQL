/* ============================================================================== 
   Prompts SQL AI pour SQL
------------------------------------------------------------------------------- 
   Ce script contient une série de prompts conçus pour aider à la fois les développeurs SQL 
   et toute personne souhaitant apprendre SQL à améliorer leurs compétences pour écrire, 
   optimiser et comprendre les requêtes SQL. Les prompts couvrent divers sujets, 
   y compris la résolution de tâches SQL, l'amélioration de la lisibilité des requêtes, 
   l'optimisation des performances, le débogage et la préparation aux entretiens ou examens. 
   Chaque section fournit des instructions claires et des exemples de code pour faciliter 
   l’auto-apprentissage et l’application pratique dans des scénarios réels.

   Table des matières :
     1. Résoudre une tâche SQL
     2. Améliorer la lisibilité
     3. Optimiser la performance de la requête
     4. Optimiser le plan d’exécution
     5. Débogage
     6. Expliquer le résultat
     7. Style & Formatage
     8. Documentation & Commentaires
     9. Améliorer le DDL de la base de données
    10. Générer un jeu de données test
    11. Créer un cours SQL
    12. Comprendre un concept SQL
    13. Comparer des concepts SQL
    14. Questions SQL avec options
    15. Préparer un entretien SQL
    16. Préparer un examen SQL
=================================================================================
*/

/* ============================================================================== 
   1. Résoudre une tâche SQL
=================================================================================

Dans ma base de données SQL Server, nous avons deux tables : 
La première table est `orders` avec les colonnes suivantes : order_id, sales, customer_id, product_id. 
La deuxième table est `customers` avec les colonnes suivantes : customer_id, first_name, last_name, country. 
Faites ce qui suit : 
    - Écrire une requête pour classer les clients selon leurs ventes.
    - Le résultat doit inclure : customer_id, nom complet, pays, ventes totales et rang.
    - Ajouter des commentaires mais éviter de commenter les parties évidentes.
    - Écrire trois versions différentes de la requête pour atteindre cet objectif.
    - Évaluer et expliquer quelle version est la meilleure en termes de lisibilité et de performance.
*/

/* ============================================================================== 
   2. Améliorer la lisibilité
=================================================================================

La requête SQL Server suivante est longue et difficile à comprendre. 
Faites ce qui suit : 
    - Améliorer la lisibilité.
    - Supprimer toute redondance et consolider la requête.
    - Ajouter des commentaires uniquement lorsque nécessaire.
    - Expliquer chaque amélioration pour comprendre la logique derrière.
*/

-- Requête mal formatée
WITH CTE_Total_Sales_By_Customer AS (
    SELECT 
        c.CustomerID, 
        c.FirstName + ' ' + c.LastName AS FullName,  
        SUM(o.Sales) AS TotalSales
    FROM Sales.Customers c
    INNER JOIN Sales.Orders o ON c.CustomerID = o.CustomerID 
    GROUP BY c.CustomerID, c.FirstName, c.LastName
),
CTE_Highest_Order_Product AS (
    SELECT 
        o.CustomerID, 
        p.Product, 
        ROW_NUMBER() OVER (PARTITION BY o.CustomerID ORDER BY o.Sales DESC) AS rn
    FROM Sales.Orders o
    INNER JOIN Sales.Products p ON o.ProductID = p.ProductID
),
CTE_Highest_Category AS (
    SELECT 
        o.CustomerID,  
        p.Category, 
        ROW_NUMBER() OVER (PARTITION BY o.CustomerID ORDER BY SUM(o.Sales) DESC) AS rn
    FROM Sales.Orders o
    INNER JOIN Sales.Products p ON o.ProductID = p.ProductID 
    GROUP BY o.CustomerID, p.Category
),
CTE_Last_Order_Date AS (
    SELECT 
        CustomerID, 
        MAX(OrderDate) AS LastOrderDate
    FROM Sales.Orders
    GROUP BY CustomerID
),
CTE_Total_Discounts_By_Customer AS (
    SELECT 
        o.CustomerID,  
        SUM(o.Quantity * p.Price * 0.1) AS TotalDiscounts
    FROM Sales.Orders o 
    INNER JOIN Sales.Products p ON o.ProductID = p.ProductID
    GROUP BY o.CustomerID
)
SELECT 
    ts.CustomerID, 
    ts.FullName,
    ts.TotalSales,
    hop.Product AS HighestOrderProduct,
    hc.Category AS HighestCategory,
    lod.LastOrderDate,
    td.TotalDiscounts
FROM CTE_Total_Sales_By_Customer ts
LEFT JOIN (SELECT CustomerID, Product FROM CTE_Highest_Order_Product WHERE rn = 1) hop 
    ON ts.CustomerID = hop.CustomerID
LEFT JOIN (SELECT CustomerID, Category FROM CTE_Highest_Category WHERE rn = 1) hc 
    ON ts.CustomerID = hc.CustomerID
LEFT JOIN CTE_Last_Order_Date lod 
    ON ts.CustomerID = lod.CustomerID
LEFT JOIN CTE_Total_Discounts_By_Customer td 
    ON ts.CustomerID = td.CustomerID
WHERE ts.TotalSales > 0
ORDER BY ts.TotalSales DESC;

/* =========================================================================== 
   3. Optimiser la performance de la requête
============================================================================== 

La requête SQL Server suivante est lente. 
Faites ce qui suit : 
    - Proposer des optimisations pour améliorer la performance.
    - Fournir la requête SQL améliorée.
    - Expliquer chaque amélioration pour comprendre la logique derrière.
*/

/* =========================================================================== 
   4. Optimiser le plan d’exécution
============================================================================== 

L’image est le plan d’exécution de la requête SQL Server.
Faites ce qui suit : 
    - Décrire le plan d’exécution étape par étape.
    - Identifier les goulots d’étranglement et problèmes de performance.
    - Suggérer des solutions pour améliorer le plan et optimiser la performance.
*/

/* =========================================================================== 
   5. Débogage
============================================================================== 

La requête SQL Server suivante génère l’erreur : "Msg 8120, Level 16, State 1, Line 5"
Faites ce qui suit : 
    - Expliquer le message d’erreur.
    - Identifier la cause racine.
    - Proposer une solution pour corriger l’erreur.
*/

/* =========================================================================== 
   6. Expliquer le résultat
============================================================================== 

Je ne comprends pas le résultat de la requête SQL Server suivante.
Faites ce qui suit : 
    - Décomposer la requête étape par étape.
    - Expliquer chaque étape et comment le résultat est formé.
*/

/* =========================================================================== 
   7. Style & Formatage
============================================================================== 

La requête SQL Server suivante est difficile à lire. 
Faites ce qui suit : 
    - Reformater le code pour améliorer la lisibilité.
    - Aligner les alias de colonnes.
    - Rester compact sans ajouter de lignes inutiles.
    - Respecter les bonnes pratiques de formatage.
*/

/* =========================================================================== 
   8. Documentation & Commentaires
============================================================================== 

La requête SQL Server suivante manque de documentation et de commentaires.
Faites ce qui suit : 
    - Ajouter un commentaire en début de requête expliquant l’objectif global.
    - Commenter uniquement les parties nécessitant clarification.
    - Créer un document séparé expliquant les règles métier implémentées.
    - Créer un autre document décrivant le fonctionnement de la requête.
*/

/* =========================================================================== 
   9. Améliorer le DDL de la base de données
============================================================================== 

La requête SQL Server DDL suivante doit être optimisée.
Faites ce qui suit : 
    - Nommage : vérifier la cohérence des noms de tables/colonnes, préfixes et standards.
    - Types de données : s’assurer qu’ils sont appropriés et optimisés.
    - Intégrité : vérifier les clés primaires et étrangères.
    - Index : vérifier qu’ils sont suffisants et éviter les doublons.
    - Normalisation : respecter la normalisation et éviter les redondances.
*/

/* =========================================================================== 
   10. Générer un jeu de données test
============================================================================== 

Besoin de jeu de données pour tester le DDL SQL Server suivant.
Faites ce qui suit : 
    - Générer les inserts pour un jeu de données test.
    - Les données doivent être réalistes et compactes.
    - Maintenir les relations clés primaires/étrangères.
    - Ne pas introduire de valeurs NULL.
*/

/* =========================================================================== 
   11. Créer un cours SQL
============================================================================== 

Créer un cours SQL complet avec roadmap et agenda détaillé.
Faites ce qui suit : 
    - Commencer par les fondamentaux SQL puis avancer vers des sujets complexes.
    - Rendre le cours accessible aux débutants.
    - Inclure des sujets pertinents pour l’analyse de données.
    - Illustrer avec des cas pratiques réels d’analyse de données.
*/

/* =========================================================================== 
   12. Comprendre un concept SQL
============================================================================== 

Je veux une explication détaillée des fonctions de fenêtrage (Window Functions).
Faites ce qui suit : 
    - Expliquer ce que sont les Window Functions.
    - Fournir une analogie.
    - Expliquer pourquoi et quand les utiliser.
    - Décrire la syntaxe.
    - Donner des exemples simples.
    - Lister les 3 principaux cas d’utilisation.
*/

/* =========================================================================== 
   13. Comparer des concepts SQL
============================================================================== 

Je veux comprendre la différence entre Window Functions et GROUP BY.
Faites ce qui suit : 
    - Expliquer les différences clés entre ces concepts.
    - Indiquer quand utiliser chaque concept, avec exemples.
    - Donner les avantages et inconvénients.
    - Résumer la comparaison dans un tableau clair côte à côte.
*/

/* =========================================================================== 
   14. Questions SQL avec options
============================================================================== 

Agir en tant que formateur SQL pour pratiquer les Window Functions.
Faites ce qui suit : 
    - Rendre l’exercice interactif : proposer la tâche, fournir la solution.
    - Fournir un jeu de données exemple.
    - Proposer des tâches SQL de difficulté progressive.
    - Simuler SQL Server et montrer les résultats.
    - Revoir les requêtes, donner feedback et suggestions d’amélioration.
*/

/* =========================================================================== 
   15. Préparer un entretien SQL
============================================================================== 

Agir en tant qu’intervieweur pour préparer un entretien SQL.
Faites ce qui suit : 
    - Poser des questions SQL courantes.
    - Rendre l’exercice interactif : proposer la question et fournir la réponse.
    - Progresser graduellement vers des sujets avancés.
    - Évaluer les réponses et donner un retour.
*/

/* =========================================================================== 
   16. Préparer un examen SQL
============================================================================== 

Préparer un examen SQL.
Faites ce qui suit : 
    - Poser des questions SQL courantes.
    - Rendre l’exercice interactif : proposer la question et fournir la réponse.
    - Progresser graduellement vers des sujets avancés.
    - Évaluer les réponses et donner un retour.
*/
