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

   Objectif métier : identifier les clients les plus performants

   - Quels sont les clients les plus performants sur les trois derniers mois ?
   - Quels sont les produits les plus vendus par catégorie ?
   - Quels clients ont généré le plus de ventes par pays ?

   Tables utilisées : Orders, Customers, Product
*/


/* =============================================================================
   Chapitre 3 — Manipulation des données (INSERT / UPDATE / DELETE)
=============================================================================

   Objectif métier : gestion du catalogue et des commandes

   - Ajouter un nouveau client avec toutes les informations nécessaires
   - Modifier le score d’un client existant
   - Mettre à jour le statut d’une commande de “Pending” à “Shipped”
   - Supprimer un client inactif depuis plus de 2 ans
   - Archiver les commandes anciennes dans OrdersArchive
*/


/* =============================================================================
   Chapitre 4 — Fonctions SQL (texte, numérique, date)
=============================================================================

   Objectif métier : transformer et analyser les données

   - Mettre les noms de clients en majuscules ou concaténer prénom et nom
   - Calculer le total des ventes et la moyenne des ventes par commande
   - Calculer la différence entre OrderDate et ShipDate
   - Regrouper les commandes par mois et par année
   - Identifier les clients avec un score supérieur à la moyenne
*/


/* =============================================================================
   Chapitre 5 — Jointures (JOIN)
=============================================================================

   Objectif métier : combiner les informations de plusieurs tables

   - Quels clients ont passé des commandes et quels produits ont-ils achetés ?
   - Quels employés sont responsables de quelles ventes ?
   - Identifier les commandes sans correspondance dans Product ou Customers
   - Lister toutes les commandes avec le nom du client et la catégorie du produit
*/


/* =============================================================================
   Chapitre 6 — Sous-requêtes
=============================================================================

   Objectif métier : logique avancée et filtrage conditionnel

   - Quels clients ont passé des commandes supérieures à 500 € ?
   - Quels produits n’ont jamais été commandés ?
   - Quels clients ont un score supérieur à la moyenne globale ?
   - Identifier les commandes avec un chiffre d’affaires supérieur à la moyenne
*/


/* =============================================================================
   Chapitre 7 — Fonctions analytiques
=============================================================================

   Objectif métier : analyse avancée des ventes

   - Classement des clients par chiffre d’affaires
   - Identifier la meilleure vente par client
   - Comparer les ventes actuelles avec celles du mois précédent
   - Calculer un rang de performance pour chaque client
*/


/* =============================================================================
   Chapitre 8 — Performance et optimisation
=============================================================================

   Objectif métier : améliorer la rapidité des requêtes

   - Identifier les colonnes les plus utilisées dans les filtres
   - Proposer des index pour accélérer les recherches
   - Optimiser les requêtes sur Orders et Customers
   - Vérifier l’impact des index sur le plan d’exécution
*/


/* =============================================================================
   Chapitre 9 — Vues et simplification
=============================================================================

   Objectif métier : simplifier l’accès aux données

   - Créer une vue des ventes par client
   - Créer une vue des commandes par produit
   - Lister les clients avec leurs ventes totales via une vue
*/

