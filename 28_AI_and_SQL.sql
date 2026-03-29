/* ==============================================================================
   Histoire SQL AI pour PostgreSQL – Formation complète
   Schéma principal : formation_sql_ai
-------------------------------------------------------------------------------
   Cette histoire commence par la création d’un environnement stable,
   puis elle avance de façon cumulative :
   les exercices 2 à 10 s’appuient TOUJOURS sur les tables créées au début.
================================================================================= */




/* ==============================================================================
   Chapitre 1 — Construire le terrain de jeu (base de tout)
=================================================================================

   Tu es un formateur PostgreSQL qui prépare une série d’exercices progressifs
   sur le schéma formation_sql_ai.

   Avant de commencer les exercices suivants, tu dois :
   1. créer le schéma `formation_sql_ai` dans la base,
   2. créer dans ce schéma les tables suivantes, avec exactement les spécifications :
      - Product (ProductID, ProductName, Category, Price)
      - Orders (OrderID, ProductID, CustomerID, SalesPersonID, OrderDate,
                ShipDate, Status, ShipAddress, BillAddress, Quantity,
                Sales, CreationTime)
      - OrdersArchive (même structure que Orders, mais pour l’historique)
      - Customers (CustomerID, GivenName, LastName, Country, Score)
      - Employees (EmployeeID, GivenName, LastName, Department, Birthdate,
                    Gender, Salary, ManagerID)
   3. insérer des données de test cohérentes et réalistes dans ces tables,
      en respectant les liens clé primaire / clé étrangère :
        - au moins 5 produits,
        - 10–15 commandes dans Orders,
        - 5–10 clients,
        - 5–7 employés,
      afin que tous les exercices suivants puissent utiliser
      les mêmes tables et les mêmes relations.

   Conventions :
   - utiliser les noms de colonnes comme GivenName, Status, ProductName,
   - préfixer les tables avec leurs alias (o.OrderID, c.CustomerID, etc.).

   Cette base est le **point de départ de toute l’histoire** :
   tous les chapitres suivants doivent être capables de fonctionner sur
   l’exact même schéma et les mêmes données.
*/




/* ==============================================================================
   Chapitre 2 — Raconter les ventes des clients (exercice 1)
=================================================================================

   Maintenant que le schéma existe et que les données sont prêtes,
   tu dois écrire une première requête métier centrale :
   “Quels sont les clients les plus performants sur les trois derniers mois ?”

   Tu dois :
   1. écrire une requête qui classe les clients selon leurs ventes totales
      sur les trois derniers mois à partir de la table Orders,
   2. retourner :
        - CustomerID, GivenName, LastName, Country, ventes totales (Sales),
        - Score, et un rang (RANK ou ROW_NUMBER),
   3. joindre aussi :
        - Product pour afficher Category et Price unitaire,
        - Customers pour récupérer le Score du client,
   4. utiliser les alias de table de façon cohérente,
   5. ajouter des commentaires seulement là où c’est utile :
        - filtres temporels dans WHERE,
        - regroupement dans GROUP BY,
        - fonctions analytiques (ex : RANK).
   6. fournir **trois versions** de cette même requête :
        - une avec CTE,
        - une sans CTE,
        - une avec sous‑requête.

   Ensuite, tu dois :
   - expliquer, en français :
        - laquelle est la plus lisible pour un formateur ou un junior,
        - laquelle est la plus performante,
        - pourquoi, en parlant d’indexation, de lectures et de plan d’exécution,
   en rappelant que ces trois versions travaillent sur **les mêmes tables créées au Chapitre 1**.
*/




/* ==============================================================================
   Chapitre 3 — Rendre la requête lisible (exercice 2, lié au 2)
=================================================================================

   À partir de la première requête produite au Chapitre 2 (ou de l’exemple ci‑dessous),
   tu dois l’améliorer pour qu’elle soit plus lisible et pédagogique,
   sans changer la logique métier.

   Tu dois :
   1. reformater la requête pour :
        - aligner les colonnes et les alias (TotalSales, TotalQuantity),
        - mettre chaque JOIN sur une nouvelle ligne,
        - rendre le code plus propre et régulier,
   2. supprimer ou simplifier les redondances :
        - calculs répétés,
        - CTE inutiles,
        - sous‑requêtes qui ne servent à rien,
   3. commenter uniquement les parties qui nécessitent une explication claire :
        - filtres métier (ex : o.OrderDate >= ...),
        - calculs business,
        - fonctions analytiques (RANK, ROW_NUMBER, SUM(...) OVER (...)).

   4. expliquer brièvement, en français, chaque amélioration :
        - pourquoi tu as regroupé certaines clauses,
        - pourquoi tu as supprimé une partie,
        - pourquoi cette version est plus adaptée pour un formateur ou un junior.

   Important : tu travailles toujours sur les mêmes tables du schéma `formation_sql_ai`
   que tu as créées au Chapitre 1, et tu réponds à la même question métier que le Chapitre 2.
*/




/* ==============================================================================
   Chapitre 4 — Optimiser la performance (exercice 3, lié au 2 et 3)
=================================================================================

   La requête est maintenant lisible, mais tu dois maintenant la rendre plus rapide.
   Tu dois optimiser la performance sur les tables Orders et Customers.

   Tu dois :
   1. proposer des optimisations concrètes :
        - index adaptés (ex : sur CustomerID, OrderDate, ProductID),
        - relecture ou reformulation de la requête si nécessaire,
        - éventuelle utilisation de partitions ou de vues matérialisées
          si le volume de données le justifie,
   2. fournir la version SQL améliorée avec commentaires,
   3. expliquer chaque amélioration en français :
        - pourquoi tel index,
        - pourquoi telle réécriture,
        - quel effet attendu sur le plan d’exécution.

   Tu dois indiquer clairement que ces optimisations s’appuient sur :
   - le même schéma `formation_sql_ai`,
   - les mêmes tables créées au Chapitre 1,
   - les mêmes données de test,
   et sur la logique métier définie au Chapitre 2.
*/




/* ==============================================================================
   Chapitre 5 — Lire le plan d’exécution (exercice 4, lié au 4)
=================================================================================

   À partir du plan d’exécution générée par PostgreSQL pour la requête
   du Chapitre 4 sur `formation_sql_ai.Orders`, tu dois :
   1. décrire le plan étape par étape :
        - Scan, Join, Sort, Aggregate, etc.,
   2. identifier les goulots d’étranglement :
        - Full Scan coûteux,
        - Nested Loop inefficaces,
        - manque d’index ou mauvais index,
   3. proposer des solutions concrètes :
        - index à ajouter ou modifier,
        - petite réécriture de la requête,
        - réglages simples de PostgreSQL (ex : work_mem, enable_mergejoin, etc.).

   Tu dois rappeler que ce plan vient de la même requête, exécutée sur
   les mêmes tables `Orders` et `Customers` du schéma `formation_sql_ai`.
*/




/* ==============================================================================
   Chapitre 6 — Déboguer l’erreur (exercice 5, lié au 2/3/4)
=================================================================================

   Parfois, une requête sur les mêmes tables produit une erreur SQL.
   Par exemple, un message du type :
   “column must appear in the GROUP BY clause” ou autre erreur métier.

   Tu dois :
   1. expliquer le message d’erreur en français simple,
   2. identifier la cause exacte :
        - colonne dans SELECT non dans GROUP BY,
        - agrégation mal placée,
        - mauvais usage de fonction analytique, etc.,
   3. proposer une version corrigée de la requête,
   4. expliquer pourquoi la correction fonctionne.

   Tu dois préciser que cette requête altérée ou corrigée est toujours basée
   sur les tables du schéma `formation_sql_ai` créées au Chapitre 1.
*/




/* ==============================================================================
   Chapitre 7 — Comprendre le résultat (exercice 6, lié au 2)
=================================================================================

   Tu dois maintenant expliquer, pas seulement corriger.

   À partir d’une requête PostgreSQL sur `Orders` et `Customers`
   (celle du Chapitre 2 ou une variante), tu dois :
   1. décomposer la requête étape par étape :
        - FROM,
        - JOIN,
        - WHERE,
        - GROUP BY,
        - HAVING,
        - SELECT,
        - ORDER BY,
   2. expliquer comment chaque étape transforme le résultat :
        - filtrage des lignes,
        - jointure,
        - agrégation,
        - calcul analytique,
   3. illustrer avec un petit exemple de données (2–3 lignes) montrant
        comment la requête passe d’un état à un autre.

   Tu dois rappeler que ces lignes proviennent des tables du schéma `formation_sql_ai`
   que tu as créées au Chapitre 1, pour garder la cohérence entre les exercices.
*/




/* ==============================================================================
   Chapitre 8 — Nettoyer le style (exercice 7, lié au 3)
=================================================================================

   La requête est déjà correcte, mais le style peut être amélioré.

   Tu dois :
   1. reformater le code pour qu’il soit compact mais lisible :
        - aligner les alias (TotalSales, TotalQuantity),
        - utiliser le préfixe de schéma seulement quand nécessaire,
        - respecter les bonnes pratiques PostgreSQL :
            - mots‑clés en majuscules,
            - noms de tables/colonnes en minuscules,
   2. rester concis : pas de lignes inutiles, mais une structure propre.

   Tu dois rappeler que ce style est appliqué à une requête qui fonctionne
   sur les mêmes tables `Orders`, `Customers`, `Product` créées au Chapitre 1.
*/




/* ==============================================================================
   Chapitre 9 — Documenter le métier et la technique (exercice 8, lié à tous)
=================================================================================

   Pour que tous les chapitres tiennent ensemble, tu dois documenter
   ce que tu as construit.

   Tu dois :
   1. ajouter un commentaire en début de requête expliquant l’objectif global,
      par exemple : “Rapport des ventes par client sur les trois derniers mois”,
   2. commenter uniquement les parties qui nécessitent détailler :
        - filtres métier,
        - calculs complexes,
        - fenêtrage analytique,
   3. proposer un document séparé en français expliquant :
        - les règles métier (ex : période des 3 derniers mois, critère de score),
   4. proposer un autre document expliquant :
        - le fonctionnement technique : jointures, agrégations, index, performance.

   Tu dois préciser que ces documents se réfèrent aux mêmes tables
   du schéma `formation_sql_ai` créées au Chapitre 1.
*/




/* ==============================================================================
   Chapitre 10 — Générer un jeu de données test cohérent (exercice 9, base de tout)
=================================================================================

   Pour que tous les exercices (2 à 9) puissent fonctionner sur le même support,
   tu dois générer un petit corpus de données réaliste.

   Tu dois :
   1. produire des INSERT INTO compacts pour :
        - Product,
        - Orders,
        - OrdersArchive,
        - Customers,
        - Employees,
   2. respecter les contraintes :
        - relations clés primaires / étrangères bien formées,
        - pas de NULL inutiles,
   3. fournir au minimum :
        - 5 produits,
        - 10–15 commandes dans Orders,
        - 5–10 clients,
        - 5–7 employés,
   4. rendre les données crédibles :
        - noms, dates, pays, ventes cohérentes,
        - pour que tous les exercices suivants (2 à 9) puissent marcher sur ce même jeu.

   Tu dois rappeler que ce jeu de données est destiné à être utilisé
   sur les mêmes tables du schéma `formation_sql_ai` créées au Chapitre 1.
*/




/* ==============================================================================
   Lien entre tous les chapitres
---------------------------------------------------------------------------------

   Cette histoire est construite de façon **progressive et cumulative** :
   - le Chapitre 1 crée le schéma et les tables de base ;
   - le Chapitre 10 enrichit ce schéma avec des données cohérentes ;
   - le Chapitre 2 construit une requête métier sur ces tables ;
   - les Chapitres 3 à 9 travaillent toujours sur :
        - le même schéma formation_sql_ai,
        - les mêmes tables Product, Orders, OrdersArchive, Customers, Employees,
        - les mêmes données insérées au Chapitre 10,
   en apportant à chaque étape :
        lisibilité, performance, débogage, compréhension, style, documentation.

   En aucun cas la structure du schéma ne doit changer :
   chaque exercice doit être enchaîné logiquement sur le précédent.
*/
