/* ==============================================================================
   Administration PostgreSQL : Rôles et groupes (histoire pédagogique)
   Objectif : expliquer clairement :
   - rôle lecture,
   - rôle lecture + écriture,
   - rôle limité à une table,
   - groupe de rôles
   - ajouter un rôle dans un groupe.
-------------------------------------------------------------------------------
   Tout est basé sur le schéma formation_sql_ai créé précédemment.
================================================================================= */



/* ==============================================================================
   Chapitre 1 — Rôle de lecture (seulement SELECT)
=================================================================================

   On commence par un rôle très simple : **lecture uniquement**.

   Ce rôle sert, par exemple, à un analyste métier ou à un utilisateur de reporting :
   - il peut lire les données,
   - mais il ne peut ni insérer, ni modifier, ni supprimer.

*/

-- 1. Créer un rôle de lecture
CREATE ROLE role_lecture LOGIN PASSWORD 'lecture123';

-- 2. Lui donner uniquement le droit de lire une table
GRANT SELECT ON TABLE formation_sql_ai.customers TO role_lecture;

/* 
   Ce rôle est un **rôle de lecture** :
   - il peut exécuter des requêtes SELECT sur la table formation_sql_ai.customers,
   - il ne peut pas faire :
        INSERT, UPDATE, DELETE,
   - il ne peut pas non plus modifier les autres tables.

   C’est un rôle sécurisé, adapté à un utilisateur qui doit seulement consulter les données.
*/



/* ==============================================================================
   Chapitre 2 — Rôle de lecture + écriture (SELECT + INSERT/UPDATE/DELETE)
=================================================================================

   Maintenant, on crée un rôle plus puissant : **lecture + écriture**.

   Ce rôle est adapté à un développeur ou à un administrateur qui doit :
   - lire les données,
   - insérer, modifier ou supprimer des lignes.

*/

-- 1. Créer un rôle avec droit de connexion
CREATE ROLE role_ecriture LOGIN PASSWORD 'ecriture456';

-- 2. Lui donner lecture + écriture sur une même table
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE formation_sql_ai.customers TO role_ecriture;

/* 
   Ce rôle est un **rôle lecture + écriture** :
   - SELECT  → il peut lire les données,
   - INSERT  → il peut ajouter des lignes,
   - UPDATE  → il peut modifier des lignes,
   - DELETE  → il peut supprimer des lignes.

   Par rapport au rôle de lecture, il a simplement **plus de privilèges**,
   mais il reste limité à la même table ou schéma (ici formation_sql_ai.customers).
*/



/* ==============================================================================
   Chapitre 3 — Rôle limité à une seule table (table a seul)
=================================================================================

   Maintenant, on crée un rôle **spécialisé sur une seule table**,
   par exemple une table de test ou une table de configuration.

*/

-- 1. Créer un rôle “testeur” limité à une table
CREATE ROLE role_test_table_a LOGIN PASSWORD 'test_table_a';

-- 2. Lui donner accès uniquement à une table spécifique
GRANT SELECT, INSERT ON TABLE formation_sql_ai.table_a TO role_test_table_a;

/* 
   Ce rôle est **spécialisé sur une seule table** :
   - il peut lire (SELECT) et insérer (INSERT) dans table_a,
   - mais il n’a pas de droits sur les autres tables (ex. customers, orders, product, etc.),
   - c’est un bon exemple de **rôle de test** ou de **rôle de configuration**.

   Ici, la différence avec les rôles précédents est la **granularité** :
   - rôle de lecture : lecture sur une table,
   - rôle lecture + écriture : lecture + écriture sur une table,
   - rôle sur une seule table : seulement SELECT et INSERT sur une table précise.
*/



/* ==============================================================================
   Chapitre 4 — Créer un groupe de rôles
=================================================================================

   Maintenant, on passe aux **groupes de rôles**. L’idée : regrouper les droits,
   et les appliquer à plusieurs utilisateurs via un groupe.

   Exemple : un groupe “grp_lecture” pour tous les utilisateurs qui doivent seulement lire.

*/

-- 1. Créer un groupe de rôles (sans droit de connexion)
CREATE ROLE grp_lecture NOLOGIN;

-- 2. Attribuer des privilèges au groupe (lecture sur une table)
GRANT SELECT ON TABLE formation_sql_ai.customers TO grp_lecture;

/* 
   Ce rôle est un **groupe de rôles** :
   - il ne peut pas se connecter (NOLOGIN),
   - il ne définit pas un utilisateur, mais un “ensemble de droits”,
   - tous les rôles qui y appartiendront hériteront automatiquement de ces droits.

   Le **groupe de rôles** est un conteneur de privilèges :
   - tu donnes les droits une fois au groupe,
   - tu ajoutes plusieurs rôles dans ce groupe,
   - tout le monde suit.
*/



/* ==============================================================================
   Chapitre 5 — Mettre un rôle dans un groupe de rôles
=================================================================================

   Maintenant, on relie un rôle existant à un groupe de rôles.
   C’est ici que tout se connecte : tu ne répètes pas les droits, tu hérites.

*/

-- 1. Créer un rôle utilisateur (ex. un analyste)
CREATE ROLE analyste_1 LOGIN PASSWORD 'analyste123';

-- 2. L’ajouter au groupe grp_lecture
GRANT grp_lecture TO analyste_1;

/* 
   Ce que cela signifie :
   - “analyse_1” devient **membre** du groupe grp_lecture,
   - donc il hérite automatiquement de :
        SELECT ON TABLE formation_sql_ai.customers
   - sans que tu aies besoin de réécrire la commande GRANT SELECT.

   Tu peux imaginer d’autres groupes :
   - grp_ecriture : pour tous les rôles qui ont SELECT, INSERT, UPDATE, DELETE,
   - grp_test : pour les rôles qui ont des droits sur les tables de test.

   Exemple :

-- Groupe pour la lecture
CREATE ROLE grp_lecture NOLOGIN;
GRANT SELECT ON TABLE formation_sql_ai.customers TO grp_lecture;

-- Groupe pour l’écriture
CREATE ROLE grp_ecriture NOLOGIN;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE formation_sql_ai.customers TO grp_ecriture;

-- Ajouter des rôles dans les groupes
GRANT grp_lecture TO role_lecture;
GRANT grp_lecture TO analyste_1;
GRANT grp_ecriture TO role_ecriture;
GRANT grp_ecriture TO developpeur_1;

*/

/* 
   En résumé :
   - **rôle de lecture** : SELECT uniquement sur une table,
   - **rôle lecture + écriture** : SELECT + INSERT/UPDATE/DELETE sur une table,
   - **rôle limité à une table** : droits très ciblés sur une seule table,
   - **groupe de rôles** : conteneur de droits sans connexion,
   - **mettre un rôle dans un groupe** : fait hériter le rôle de tous les droits du groupe,
     sans avoir à répéter les GRANT pour chaque utilisateur.

   Tout cela reste basé sur le schéma formation_sql_ai que tu as créé au début,
   et les mêmes règles de sécurité s’appliquent à tous les exercices suivants.
*/
