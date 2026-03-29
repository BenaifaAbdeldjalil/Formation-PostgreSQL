/* ==============================================================================
   Administration PostgreSQL – Rôles, groupes, CRUD et sécurité
   Schéma : formation_sql
================================================================================= */



/* ==============================================================================
   Chapitre 1 — Rôle de lecture (READ sur toutes les tables)
================================================================================= */

CREATE ROLE role_lecture LOGIN PASSWORD 'lecture123';

-- Accès au schéma (OBLIGATOIRE)
GRANT USAGE ON SCHEMA formation_sql TO role_lecture;

-- Lecture sur toutes les tables existantes
GRANT SELECT ON ALL TABLES IN SCHEMA formation_sql TO role_lecture;

-- Lecture automatique sur les futures tables
ALTER DEFAULT PRIVILEGES IN SCHEMA formation_sql
GRANT SELECT ON TABLES TO role_lecture;



/* ==============================================================================
   Chapitre 2 — Rôle lecture + écriture (CRUD)
================================================================================= */

CREATE ROLE role_crud LOGIN PASSWORD 'ecriture456';

GRANT USAGE ON SCHEMA formation_sql TO role_crud;

GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA formation_sql TO role_crud;

ALTER DEFAULT PRIVILEGES IN SCHEMA formation_sql
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO role_crud;



/* ==============================================================================
   Chapitre 3 — Rôle lecture sur UNE table (customers uniquement)
================================================================================= */

CREATE ROLE role_read_customers LOGIN PASSWORD 'readcust123';

-- Accès au schéma
GRANT USAGE ON SCHEMA formation_sql TO role_read_customers;

-- Lecture uniquement sur customers
GRANT SELECT ON TABLE formation_sql.customers TO role_read_customers;



/* ==============================================================================
   Chapitre 4 — Groupes de rôles
================================================================================= */

CREATE ROLE grp_lecture NOLOGIN;
GRANT USAGE ON SCHEMA formation_sql TO grp_lecture;
GRANT SELECT ON ALL TABLES IN SCHEMA formation_sql TO grp_lecture;

CREATE ROLE grp_crud NOLOGIN;
GRANT USAGE ON SCHEMA formation_sql TO grp_crud;
GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA formation_sql TO grp_crud;



/* ==============================================================================
   Chapitre 5 — Attribution des rôles
================================================================================= */

CREATE ROLE analyste_1 LOGIN PASSWORD 'analyste123';
GRANT grp_lecture TO analyste_1;

CREATE ROLE dev_1 LOGIN PASSWORD 'dev123';
GRANT grp_crud TO dev_1;



/* ==============================================================================
   Chapitre 6 — REVOKE
================================================================================= */

REVOKE UPDATE ON ALL TABLES IN SCHEMA formation_sql FROM dev_1;

REVOKE SELECT ON TABLE formation_sql.customers FROM role_read_customers;



/* ==============================================================================
   Chapitre 7 — ALTER
================================================================================= */

ALTER ROLE role_lecture PASSWORD 'nouveau_lecture678';



/* ==============================================================================
   Chapitre 8 — Nettoyage
================================================================================= */

REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA formation_sql FROM role_lecture;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA formation_sql FROM role_crud;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA formation_sql FROM role_read_customers;

REVOKE ALL PRIVILEGES ON SCHEMA formation_sql FROM role_lecture;
REVOKE ALL PRIVILEGES ON SCHEMA formation_sql FROM role_crud;
REVOKE ALL PRIVILEGES ON SCHEMA formation_sql FROM role_read_customers;

REVOKE grp_lecture FROM analyste_1;
REVOKE grp_crud FROM dev_1;

REASSIGN OWNED BY role_lecture TO postgres;
REASSIGN OWNED BY role_crud TO postgres;
REASSIGN OWNED BY role_read_customers TO postgres;

DROP OWNED BY role_lecture;
DROP OWNED BY role_crud;
DROP OWNED BY role_read_customers;



/* ==============================================================================
   Chapitre 9 — DROP
================================================================================= */

DROP ROLE IF EXISTS analyste_1;
DROP ROLE IF EXISTS dev_1;

DROP ROLE IF EXISTS role_read_customers;
DROP ROLE IF EXISTS role_lecture;
DROP ROLE IF EXISTS role_crud;

DROP ROLE IF EXISTS grp_lecture;
DROP ROLE IF EXISTS grp_crud;
