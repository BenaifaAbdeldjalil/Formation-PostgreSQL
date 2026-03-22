/* ============================================================================== 
   Prompts SQL AI pour PostgreSQL (PostgreSQL + ton schéma formation_sql_ai)
------------------------------------------------------------------------------- 
   Ce bloc de prompts utilise directement ton schéma formation_sql_ai et les tables :
     Product, Orders, OrdersArchive, Customers, Employees.
   Les prompts sont conçus pour aider à :
     - écrire des requêtes correctes,
     - améliorer la lisibilité et la performance,
     - déboguer, comprendre et générer des cas tests.
=================================================================================
*/

/* ============================================================================== 
   1. Résoudre une tâche SQL (PostgreSQL, tables formation_sql_ai)
=================================================================================

J’utilise PostgreSQL. Avant de résoudre la tâche SQL demandée, créez l’environnement suivant :

    1. Créer un schéma nommé `formation_sql_ai` dans cette base.
    2. Créer dans le schéma `formation_sql_ai` les tables suivantes. Les tables doivent respecter exactement les spécifications ci‑dessous (mêmes noms de colonnes, types, contraintes NOT NULL, PRIMARY KEY).

---
   - Product (ProductID, ProductName, Category, Price)
   - Orders (OrderID, ProductID, CustomerID, SalesPersonID, OrderDate, ShipDate, Status, ShipAddress, BillAddress, Quantity, Sales, CreationTime)
   - OrdersArchive (même structure que Orders, mais données historiques)
   - Customers (CustomerID, GivenName, LastName, Country, Score)
   - Employees (EmployeeID, GivenName, LastName, Department, BirthDate, Gender, Salary, ManagerID)

3. Insere des données aleatoire dans lesd tables mais qui sont commun pour faire des jointures apres.

Faites ce qui suit :
    - Écrire une requête pour classer les **clients** selon **leurs ventes totales** sur les trois derniers mois de la table Orders.
    - Le résultat doit inclure :
        CustomerID, GivenName, LastName, Country, ventes totales (Sales), score, et un rang (RANK ou ROW_NUMBER).
    - Joindre aussi :
        - Product pour voir Category et Price unitaire,
        - Customers pour avoir le Score du client.
    - Ajouter des **commentaires** dans le code, mais seulement sur les parties non évidentes (ex : WHERE, GROUP BY, fonctions analytiques).
    - Écrire **trois versions différentes** de la requête (ex : une avec CTE, une sans, une avec subquery) pour atteindre le même objectif.
    - Évaluer et expliquer :
        - laquelle est la plus lisible pour un formateur ou un junior,
        - laquelle est la plus performante (en termes d’indexation, de lectures, de plan d’exécution).

Convention de nommage :
    - Utiliser les noms de colonnes renommés (GivenName, Status, ProductName).
    - Toujours préfixer les tables (ex : o.OrderID, c.CustomerID).
*/

/* ============================================================================== 
   2. Améliorer la lisibilité
=================================================================================

La requête PostgreSQL suivante utilise le schéma formation_sql_ai et les tables Product, Orders, Customers.

Elle est longue et difficile à lire. Faites ce qui suit :
    - Reformater la requête pour améliorer la lisibilité.
    - Aligner les alias de colonnes et mettre les JOIN sur plusieurs lignes.
    - Supprimer ou simplifier les redondances (ex : calculs répétés, CTE inutiles).
    - Ajouter des commentaires uniquement sur :
        - les conditions de filtre non évidentes,
        - les calculs business, et
        - les fonctions analytiques (ex : RANK, ROW_NUMBER, SUM(window)).
    - Expliquer brièvement chaque amélioration (ex : “j’ai regroupé les clauses WHERE”, “j’ai supprimé la sous‑requête inutile”).
*/

-- Exemple de requête à améliorer (à remplacer par ta vraie requête lente / sale)
WITH cte_sales_by_customer AS (
    SELECT
        c.CustomerID,
        c.GivenName,
        c.LastName,
        c.Country,
        c.Score,
        SUM(o.Sales) AS TotalSales,
        SUM(o.Quantity) AS TotalQuantity
    FROM formation_sql_ai.Customers c
    JOIN formation_sql_ai.Orders o ON c.CustomerID = o.CustomerID
    WHERE o.OrderDate >= '2025-01-01'::DATE
    GROUP BY c.CustomerID, c.GivenName, c.LastName, c.Country, c.Score
)
SELECT
    cs.CustomerID,
    cs.GivenName,
    cs.LastName,
    cs.Country,
    cs.Score,
    cs.TotalSales,
    cs.TotalQuantity,
    RANK() OVER (ORDER BY cs.TotalSales DESC) AS rank
FROM cte_sales_by_customer cs
WHERE cs.TotalSales > 0
ORDER BY cs.TotalSales DESC;

/* =========================================================================== 
   3. Optimiser la performance de la requête (PostgreSQL)
============================================================================== 

La requête PostgreSQL suivante est lente sur les tables formation_sql_ai.Orders et formation_sql_ai.Customers.

Faites ce qui suit :
    - Proposer des optimisations pour améliorer la performance :
        - index appropriés (sur ProductID, CustomerID, OrderDate, etc.),
        - reformulation de la requête si nécessaire,
        - éventuelles partitions ou materialized views si le volume le justifie.
    - Fournir la requête SQL améliorée avec les commentaires SQL.
    - Expliquer chaque amélioration (ex : “j’ai ajouté un index sur (CustomerID, OrderDate) car la requête filtre sur ces deux colonnes”).
*/

/* =========================================================================== 
   4. Optimiser le plan d’exécution
============================================================================== 

L’image (ou le texte) est le plan d’exécution de la requête PostgreSQL sur formation_sql_ai.Orders.

Faites ce qui suit :
    - Décrire le plan d’exécution étape par étape (Scan, Join, Sort, Aggregate, etc.).
    - Identifier les goulots d’étranglement (ex : Full Scan, Nested Loop, manque d’index).
    - Suggérer des solutions concrètes :
        - index à ajouter / modifier,
        - optimisation de la requête,
        - réglages PostgreSQL simples (ex : work_mem, enable_mergejoin, etc.).
*/

/* =========================================================================== 
   5. Débogage
============================================================================== 

La requête PostgreSQL suivante sur formation_sql_ai.Orders et formation_sql_ai.Customers génère une erreur (ex : "column must appear in the GROUP BY clause" ou autre).

Faites ce qui suit :
    - Expliquer le message d’erreur en français simple.
    - Identifier la cause racine (ex : colonne dans SELECT non dans GROUP BY, mauvaise agrégation, fonction analytique mal placée).
    - Proposer une version corrigée de la requête avec explication.
*/

/* =========================================================================== 
   6. Expliquer le résultat
============================================================================== 

Je ne comprends pas le résultat de la requête PostgreSQL suivante sur formation_sql_ai.Orders et formation_sql_ai.Customers.

Faites ce qui suit :
    - Décomposer la requête étape par étape (FROM, JOIN, WHERE, GROUP BY, HAVING, SELECT, ORDER BY).
    - Expliquer comment chaque étape influence le résultat (ex : filtrage des lignes, agrégration, fenêtrage).
    - Illustrer avec un petit exemple de données (2–3 lignes) pour montrer comment la requête travaille.
*/

/* =========================================================================== 
   7. Style & Formatage
============================================================================== 

La requête PostgreSQL suivante utilise le schéma formation_sql_ai et est difficile à lire.

Faites ce qui suit :
    - Reformater le code pour améliorer la lisibilité.
    - Aligner les alias de colonnes (ex : TotalSales, TotalQuantity).
    - Utiliser le préfixe de schéma uniquement si nécessaire.
    - Rester compact sans ajouter de lignes inutiles.
    - Respecter les bonnes pratiques de PostgreSQL (ex : majuscules pour les mots‑clés, minuscules pour les noms de tables/colonnes).
*/

/* =========================================================================== 
   8. Documentation & Commentaires
============================================================================== 

La requête PostgreSQL suivante sur formation_sql_ai.OrderStats manque de documentation.

Faites ce qui suit :
    - Ajouter un commentaire en début de requête expliquant l’objectif global (ex : “rapport mensuel des ventes par client”).
    - Commenter uniquement les parties nécessitant clarification (ex : filtres métier, calculs complexes).
    - Proposer un document séparé (en français) expliquant les règles métier implémentées dans la requête.
    - Proposer un autre document décrivant le fonctionnement technique (ex : jointures, agrégations, performance).
*/

/* =========================================================================== 
   9. Améliorer le DDL de la base de données (PostgreSQL)
============================================================================== 

Le DDL PostgreSQL suivant définit les tables Product, Orders, OrdersArchive, Customers, Employees dans le schéma formation_sql_ai.

Faites ce qui suit :
    - Vérifier la cohérence des noms (ex : GivenName, Status, ProductName).
    - Vérifier que les types de données sont appropriés (ex : INTEGER, DATE, VARCHAR, NOT NULL / NULL).
    - Vérifier l’intégrité (PRIMARY KEY, FOREIGN KEY, éventuelles contraintes).
    - Vérifier les index (ex : index sur ProductID, CustomerID, OrderDate) et supprimer les doublons.
    - Vérifier la normalisation (ex : éviter la redondance entre Orders et OrdersArchive).
    - Proposer une version améliorée du DDL avec commentaires.
*/

/* =========================================================================== 
   10. Générer un jeu de données test
============================================================================== 

Besoin d’un jeu de données de test pour les tables Product, Orders, OrdersArchive, Customers, Employees dans le schéma formation_sql_ai.

Faites ce qui suit :
    - Générer des INSERT INTO concis et réalistes (noms, dates, pays, ventes cohérentes).
    - Maintenir les relations clés primaires/étrangères (ex : CustomerID dans Orders existe dans Customers).
    - Ne pas introduire de valeurs NULL inutiles.
    - Produire au moins :
        - 5 produits,
        - 10–15 commandes (Orders),
        - 5–10 clients,
        - 5–7 employés.
*/

/* =========================================================================== 
   11. Créer un cours SQL PostgreSQL centré sur formation_sql_ai
============================================================================== 

À partir des tables formation_sql_ai.Product, Orders, OrdersArchive, Customers, Employees, écrivez un plan de cours SQL PostgreSQL pour débutants‑intermédiaires (ex : niveau formation_postgresql).

Le cours doit couvrir :
    - SELECT, WHERE, JOIN, GROUP BY, ORDER BY, DISTINCT.
    - Agrégations (COUNT, SUM, AVG, MIN, MAX), fonctions date (ex : DATE_TRUNC, INTERVAL).
    - Sous‑requêtes, CTE, fonctions analytiques (RANK, ROW_NUMBER, LAG, LEAD).
    - Index basiques (création, types B‑tree, Unique, Partial) adaptés à tes tables.
    - Exemples concrets (ex : “rapport de ventes par client”, “meilleurs clients par mois”).
    - Petits exercices pratiques (QCM, énoncé de problème SQL).
*/

/* =========================================================================== 
   12. Comprendre un concept SQL (PostgreSQL)
============================================================================== 

Expliquez clairement en français le concept de CTE (Common Table Expression) dans PostgreSQL.

Faites ce qui suit :
    - Donner une définition simple et un exemple avec formation_sql_ai.Orders et formation_sql_ai.Customers.
    - Montrer quand utiliser une CTE plutôt qu’une sous‑requête.
    - Expliquer les bonnes pratiques (ex : lisibilité, portée, limites de performance).

Même logique pour les concepts :
    - INNER JOIN / LEFT JOIN,
    - GROUP BY avec agrégations,
    - Fonctions analytiques (RANK, ROW_NUMBER, LAG, LEAD),
    - Index (B‑tree, Unique, Partial, BRIN).
*/

/* =========================================================================== 
   13. Comparer des concepts SQL
============================================================================== 

Comparez en français :
    - CTE vs. sous‑requête,
    - INNER JOIN vs. LEFT JOIN,
    - SUM vs. COUNT.

Pour chaque comparaison :
    - Expliquer la différence,
    - Donner un exemple concret avec les tables formation_sql_ai (ex : Orders, Customers),
    - Indiquer dans quelles situations utiliser l’un plutôt que l’autre.
*/

/* =========================================================================== 
   14. Questions SQL avec options (exercices PostgreSQL)
============================================================================== 

À partir des tables formation_sql_ai.Product, Orders, Customers, Employees, générez des questions SQL interactives.

Faites ce qui suit :
    - Produire 5–10 questions avec options (A/B/C/D) type QCM.
    - Exemple : “Quelle requête permet de trouver les clients dont le total de ventes dépasse 100 ?”
    - Donner la bonne réponse et une explication courte.
*/

/* =========================================================================== 
   15. Préparer un entretien SQL (PostgreSQL)
============================================================================== 

Créez un mini‑programme de préparation entretien SQL centré sur formation_sql_ai.

Faites ce qui suit :
    - Lister les thèmes clés : JOIN, GROUP BY, fonctions analytiques, index, optimisation.
    - Proposer 5–10 questions d’entretien avec :
        - énoncé,
        - solution SQL,
        - explication de la logique.
    - Ajouter des astuces de performance (ex : comment répondre à “Comment optimiser une requête lente ?”).
*/

/* =========================================================================== 
   16. Préparer un examen SQL (PostgreSQL)
============================================================================== 

À partir de formation_sql_ai.Product, Orders, OrdersArchive, Customers, Employees, concevez un mini‑examen SQL.

Faites ce qui suit :
    - 5 questions de difficulté croissante (syntaxe, jointure, agrégation, fenêtrage).
    - Corrigé complet avec explications.
    - Indiquer le barème possible (ex : 2–4 points par question).
*/
