/* =============================================================================
   SQL AI pour PostgreSQL – Formation complète
   Schéma principal : formation_sql_ai
============================================================================= */


/* =============================================================================
   Chapitre 1 — Construire le terrain de jeu
=============================================================================

   Crée une structure complète pour une formation PostgreSQL basée sur
   le schéma `formation_sql_ai`.

   Générer :

   1. Le schéma `formation_sql_ai`.
   2. Les tables suivantes avec leurs spécifications exactes :
      - Product (ProductID, ProductName, Category, Price)
      - Orders (OrderID, ProductID, CustomerID, SalesPersonID, OrderDate,
                ShipDate, Status, ShipAddress, BillAddress, Quantity,
                Sales, CreationTime)
      - OrdersArchive (même structure que Orders)
      - Customers (CustomerID, GivenName, LastName, Country, Score)
      - Employees (EmployeeID, GivenName, LastName, Department, Birthdate,
                   Gender, Salary, ManagerID)

   3. Un jeu de données réaliste et cohérent :
      - au moins 5 produits
      - 10–15 commandes
      - 5–10 clients
      - 5–7 employés

   Contraintes :
   - respect des relations clés primaires / étrangères
   - cohérence des données
   - noms de colonnes standards (GivenName, Status, ProductName)
   - utilisation d’alias cohérents (o, c, p…)

   Cette structure sert de base à tous les chapitres suivants.
*/


/* =============================================================================
   Chapitre 2 — Analyse des ventes clients
=============================================================================

   Générer une requête SQL répondant à la question :

   “Quels sont les clients les plus performants sur les trois derniers mois ?”

   Contraintes :

   - calcul du total des ventes par client
   - retour des colonnes :
        CustomerID, GivenName, LastName, Country
        Total des ventes (Sales)
        Score
        Rang (RANK ou ROW_NUMBER)

   - utilisation des tables :
        Orders, Customers, Product
   - jointures correctes
   - filtre sur les 3 derniers mois

   Fournir 3 versions :
   - avec CTE
   - sans CTE
   - avec sous-requête

   Ajouter une explication :
   - lisibilité
   - performance
   - impact des index et du plan d’exécution

   Toutes les requêtes utilisent les tables du Chapitre 1.
*/


/* =============================================================================
   Chapitre 3 — Amélioration de la lisibilité
=============================================================================

   Améliorer la lisibilité de la requête du Chapitre 2 :

   - alignement des colonnes et alias
   - chaque JOIN sur une nouvelle ligne
   - structure claire et homogène

   Simplifier :
   - suppression des redondances
   - suppression des CTE inutiles
   - simplification des sous-requêtes

   Ajouter des commentaires uniquement pour :
   - filtres métier
   - calculs importants
   - fonctions analytiques

   Fournir une explication des améliorations.
*/


/* =============================================================================
   Chapitre 4 — Optimisation des performances
=============================================================================

   Optimiser la requête précédente :

   - proposer des index :
        CustomerID, OrderDate, ProductID
   - proposer une réécriture si nécessaire
   - suggérer :
        partitionnement ou vues matérialisées (si pertinent)

   Fournir :
   - requête optimisée
   - commentaires techniques

   Expliquer :
   - impact sur le plan d’exécution
   - gains de performance attendus

   Basé sur les mêmes tables du schéma formation_sql_ai.
*/


/* =============================================================================
   Chapitre 5 — Analyse du plan d’exécution
=============================================================================

   Analyser un plan d’exécution PostgreSQL :

   - décrire les étapes :
        Scan, Join, Sort, Aggregate
   - identifier les problèmes :
        Full Scan
        Nested Loop inefficace
        manque d’index

   Proposer :
   - améliorations
   - index adaptés
   - ajustements PostgreSQL (work_mem, etc.)

   Basé sur les tables Orders et Customers.
*/


/* =============================================================================
   Chapitre 6 — Débogage SQL
=============================================================================

   Analyser une erreur SQL (ex : GROUP BY) :

   - expliquer le message
   - identifier la cause :
        colonne manquante dans GROUP BY
        agrégation incorrecte
        erreur analytique

   Fournir :
   - requête corrigée
   - explication de la correction

   Basé sur les tables du schéma formation_sql_ai.
*/


/* =============================================================================
   Chapitre 7 — Compréhension d’une requête
=============================================================================

   Expliquer une requête étape par étape :

   - FROM
   - JOIN
   - WHERE
   - GROUP BY
   - HAVING
   - SELECT
   - ORDER BY

   Décrire :
   - transformation des données à chaque étape

   Illustrer avec un exemple simple (2–3 lignes).
*/






