/* ============================================================================== 
   Administration PostgreSQL : Gestion des rôles, groupes et extensions
-------------------------------------------------------------------------------
   Ce script présente les principales commandes pour :
   - Créer et supprimer des rôles
   - Créer des groupes de rôles
   - Attribuer des privilèges
   - Gérer les mots de passe et les connexions
   - Installer et gérer les extensions
=================================================================================
*/

/* ------------------------------------------------------------------------------ 
   1. Création d'un rôle simple
------------------------------------------------------------------------------- */
-- Création d'un rôle avec mot de passe et droit de connexion
CREATE ROLE utilisateur_sql LOGIN PASSWORD 'MotDePasse123';

-- Vérification du rôle
\du utilisateur_sql

/* ------------------------------------------------------------------------------ 
   2. Création d'un rôle sans droit de connexion (pour rôle de groupe)
------------------------------------------------------------------------------- */
CREATE ROLE grp_finance NOLOGIN;

-- Vérification
\du grp_finance

/* ------------------------------------------------------------------------------ 
   3. Attribution d'un rôle à un autre rôle (groupes de rôles)
------------------------------------------------------------------------------- */
-- Faire de "utilisateur_sql" un membre du groupe "grp_finance"
GRANT grp_finance TO utilisateur_sql;

-- Vérification
\du utilisateur_sql

/* ------------------------------------------------------------------------------ 
   4. Attribution de privilèges
------------------------------------------------------------------------------- */
-- Donner tous les droits sur une base de données à un rôle
GRANT ALL PRIVILEGES ON DATABASE formation_sql TO utilisateur_sql;

-- Donner tous les droits sur une table spécifique
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE formation_sql.customers TO utilisateur_sql;

-- Révoquer un privilège
REVOKE DELETE ON TABLE formation_sql.customers FROM utilisateur_sql;

/* ------------------------------------------------------------------------------ 
   5. Gestion des mots de passe et options de connexion
------------------------------------------------------------------------------- */
-- Changer le mot de passe
ALTER ROLE utilisateur_sql PASSWORD 'NouveauMotDePasse456';

-- Interdire la connexion
ALTER ROLE utilisateur_sql NOLOGIN;

-- Autoriser la connexion
ALTER ROLE utilisateur_sql LOGIN;

/* ------------------------------------------------------------------------------ 
   6. Suppression d'un rôle
------------------------------------------------------------------------------- */
-- Attention : le rôle ne doit posséder aucune propriété ni table
DROP ROLE IF EXISTS utilisateur_sql;

-- Suppression d'un groupe de rôle
DROP ROLE IF EXISTS grp_finance;

/* ------------------------------------------------------------------------------ 
   7. Gestion des extensions
------------------------------------------------------------------------------- */
-- Voir les extensions installées
\dx

-- Installer une extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Supprimer une extension
DROP EXTENSION IF EXISTS "uuid-ossp";

/* ------------------------------------------------------------------------------ 
   8. Vérification des rôles et groupes
------------------------------------------------------------------------------- */
-- Lister tous les rôles
SELECT rolname, rolsuper, rolcreaterole, rolcreatedb, rolcanlogin
FROM pg_roles
ORDER BY rolname;

-- Vérifier les membres d’un rôle/groupe
SELECT r.rolname AS role,
       m.rolname AS member
FROM pg_auth_members am
JOIN pg_roles r ON r.oid = am.roleid
JOIN pg_roles m ON m.oid = am.member;

