/* ==============================================================================
   Administration PostgreSQL – Rôles, groupes, CRUD et sécurité
   Schéma : formation_sql_ai
-------------------------------------------------------------------------------
   Objectif pédagogique :
   - créer un rôle de lecture (READ),
   - un rôle lecture + écriture (READ + INSERT/UPDATE/DELETE),
   - un rôle limité à une seule table (READ + INSERT),
   - des groupes de rôles,
   - ajouter un rôle à un groupe,
   - puis révoquer des droits, modifier le mot de passe, et supprimer un rôle.
================================================================================= */



/* ==============================================================================
   Chapitre 1 — Rôle de lecture (READ uniquement)
=================================================================================

   On crée d’abord un rôle **lecture uniquement** sur `customers`.
*/

-- Créer un rôle qui peut se connecter
CREATE ROLE role_lecture LOGIN PASSWORD 'lecture123';

-- Lui donner seulement SELECT
GRANT SELECT ON TABLE formation_sql_ai.customers TO role_lecture;

/* 
   Ce rôle :
   - peut lire des données (READ),
   - ne peut pas INSERT, UPDATE, DELETE.

   C’est un bon **rôle de reporting** ou **rôle de lecture métier**.
*/



/* ==============================================================================
   Chapitre 2 — Rôle lecture + écriture (READ + INSERT/UPDATE/DELETE)
=================================================================================

   On crée un rôle **avec CRUD complet** sur la même table.
*/

-- Créer un rôle avec connexion
CREATE ROLE role_crud LOGIN PASSWORD 'ecriture456';

-- Donner CRUD : SELECT, INSERT, UPDATE, DELETE
GRANT SELECT, INSERT, UPDATE, DELETE
ON TABLE formation_sql_ai.customers TO role_crud;

/* 
   Ce rôle couvre toutes les opérations CRUD :
   - READ        = SELECT,
   - CREATE      = INSERT,
   - UPDATE      = UPDATE,
   - DELETE      = DELETE,

   C’est un bon profil **développeur** ou **admin de données**.
*/



/* ==============================================================================
   Chapitre 3 — Rôle limité à une seule table (granularité)
=================================================================================

   On crée un rôle **spécialisé sur une seule table**, par exemple `table_a`.
*/

-- Rôle de test limité
CREATE ROLE role_test_table_a LOGIN PASSWORD 'test_table_a';

-- Droits très ciblés sur une seule table
GRANT SELECT, INSERT ON TABLE formation_sql_ai.table_a TO role_test_table_a;

/* 
   Ce rôle :
   - peut lire et insérer dans `table_a`,
   - n’a pas de droits sur `customers`, `orders`, etc.

   C’est un **rôle de test** ou **rôle de configuration**.
*/



/* ==============================================================================
   Chapitre 4 — Créer un groupe de rôles
=================================================================================

   On crée des **groupes de rôles** pour regrouper les droits.
*/

-- Groupe de lecture (ne peut pas se connecter)
CREATE ROLE grp_lecture NOLOGIN;
GRANT SELECT ON TABLE formation_sql_ai.customers TO grp_lecture;

-- Groupe de CRUD (écriture complète)
CREATE ROLE grp_crud NOLOGIN;
GRANT SELECT, INSERT, UPDATE, DELETE
ON TABLE formation_sql_ai.customers TO grp_crud;

/* 
   Ces groupes servent de “conteneurs de droits” :
   - NOLOGIN = ils ne sont pas des utilisateurs réels,
   - les rôles membres héritent de leurs privilèges.
*/



/* ==============================================================================
   Chapitre 5 — Ajouter un rôle à un groupe
=================================================================================

   On relie les rôles aux groupes.
*/

-- Créer un analyste et l’ajouter au groupe de lecture
CREATE ROLE analyste_1 LOGIN PASSWORD 'analyste123';
GRANT grp_lecture TO analyste_1;

-- Créer un développeur et l’ajouter au groupe CRUD
CREATE ROLE dev_1 LOGIN PASSWORD 'dev123';
GRANT grp_crud TO dev_1;

/* 
   Résultat :
   - analyste_1 hérite de SELECT sur customers,
   - dev_1 hérite de SELECT, INSERT, UPDATE, DELETE sur customers.

   Les droits sont gérés au niveau du groupe, pas dans chaque rôle.
*/



/* ==============================================================================
   Chapitre 6 — Révoquer des privilèges (REVOKE)
=================================================================================

   On peut maintenant retirer des droits.
*/

-- 1. Retirer UPDATE à dev_1 (garder READ + INSERT/DELETE)
REVOKE UPDATE ON TABLE formation_sql_ai.customers FROM dev_1;

-- 2. Retirer INSERT à role_test_table_a (garder SELECT seulement)
REVOKE INSERT ON TABLE formation_sql_ai.table_a FROM role_test_table_a;

/* 
   Le `REVOKE` est l’inverse de `GRANT` :
   - s’il n’y a pas de droit, REVOKE échoue proprement,
   - il permet de raffiner le niveau de permissions.
*/



/* ==============================================================================
   Chapitre 7 — Modifier le mot de passe (ALTER)
=================================================================================

   On peut changer le mot de passe d’un rôle sans toucher aux droits.
*/

ALTER ROLE role_lecture PASSWORD 'nouveau_lecture678';
ALTER ROLE dev_1 PASSWORD 'nouveau_dev678';

/* 
   Cela est utile pour :
   - appliquer une politique de rotation des mots de passe,
   - corriger un mot de passe compromis.
*/



/* ==============================================================================
   Chapitre 8 — Supprimer un rôle (DROP ROLE)
=================================================================================

   Quand un rôle n’est plus nécessaire, on le supprime.
*/

DROP ROLE IF EXISTS analyste_1;   -- Supprime le rôle utilisateur
DROP ROLE IF EXISTS role_test_table_a;

-- Supprimer un groupe de rôles (si plus utilisé)
DROP ROLE IF EXISTS grp_lecture;

/* 
   Rappel :
   - le rôle ne doit pas posséder d’objets (tables, bases, etc.),
   - après suppression, le compte et ses droits disparaissent.
*/



/* ==============================================================================
   Résumé synthétique : Rôles, CRUD, REVOKE, ALTER, DROP
=================================================================================

   - rôle de lecture : SELECT uniquement,
   - rôle CRUD : SELECT, INSERT, UPDATE, DELETE,
   - rôle limité : droits sur une seule table,
   - groupe de rôles : conteneur NOLOGIN pour regrouper des droits,
   - ajouter un rôle à un groupe : GRANT grp_lecture TO role_x,
   - révoquer un droit : REVOKE privilège ON ... FROM role,
   - modifier le mot de passe : ALTER ROLE role PASSWORD 'nouveau',
   - supprimer un rôle : DROP ROLE role.

   Tout repose sur le schéma `formation_sql_ai` et la logique de droits hiérarchique.
*/
