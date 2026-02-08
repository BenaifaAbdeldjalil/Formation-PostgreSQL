/* ============================================================================== 
   Script PostgreSQL : Monitoring des tables
-------------------------------------------------------------------------------
   Ce script permet d'obtenir des informations sur les tables, 
   leur taille, nombre de lignes, index, et statistiques.
=================================================================================
*/

/* 1. Liste des tables et schémas */
SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_schema = 'formation_sql'
ORDER BY table_name;

/* 2. Nombre de lignes approximatif (rapide) */
SELECT relname AS table_name,
       reltuples::BIGINT AS approximate_row_count
FROM pg_class
WHERE relname IN ('customers','employees');

/* 3. Taille des tables et index */
SELECT
    relname AS table_name,
    pg_size_pretty(pg_total_relation_size(relid)) AS total_size,
    pg_size_pretty(pg_relation_size(relid)) AS table_size,
    pg_size_pretty(pg_indexes_size(relid)) AS indexes_size
FROM pg_catalog.pg_statio_user_tables
WHERE relname IN ('customers','employees');

/* 4. Index existants sur les tables */
SELECT
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'formation_sql'
AND tablename IN ('customers','employees');

/* 5. Statistiques d'analyse (à mettre à jour avec ANALYZE si besoin) */
ANALYZE formation_sql.customers;
ANALYZE formation_sql.employees;

-- Exemple de vérification du dernier scan séquentiel ou index
SELECT relname AS table_name,
       seq_scan,
       seq_tup_read,
       idx_scan,
       idx_tup_fetch
FROM pg_stat_user_tables
WHERE relname IN ('customers','employees');

/* 6. Consulter les contraintes existantes */
SELECT conname AS constraint_name,
       contype AS constraint_type,
       conrelid::regclass AS table_name,
       confrelid::regclass AS foreign_table
FROM pg_constraint
WHERE conrelid::regclass::text IN ('formation_sql.customers', 'formation_sql.employees');

