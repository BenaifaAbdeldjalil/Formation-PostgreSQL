/* ============================================================================
   SURVEILLANCE DES TABLES ET COLONNES
   ============================================================================
   Ce script permet de :
   1) Lister toutes les tables d’un schéma
   2) Lister toutes les colonnes par table
   3) Afficher quelques statistiques d’utilisation et de taille
=========================================================================== */

-- ============================================================================ 
-- 1) LISTE DES TABLES D’UN SCHEMA
-- ============================================================================

SELECT 
    table_schema,
    table_name,
    table_type
FROM information_schema.tables
WHERE table_schema = 'formation_sql'
ORDER BY table_name;

-- ============================================================================ 
-- 2) LISTE DES COLONNES PAR TABLE
-- ============================================================================

SELECT
    table_schema,
    table_name,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'formation_sql'
ORDER BY table_name, ordinal_position;

-- ============================================================================ 
-- 3) STATISTIQUES D’UTILISATION DES TABLES
-- ============================================================================

SELECT
    relname AS table_name,
    n_live_tup AS live_rows,
    n_dead_tup AS dead_rows,
    pg_size_pretty(pg_total_relation_size(relid)) AS total_size,
    last_analyze,
    last_autoanalyze
FROM pg_stat_user_tables
WHERE schemaname = 'formation_sql'
ORDER BY n_live_tup DESC;

-- ============================================================================ 
-- 4) TAILLE DES TABLES (détail par table et index)
-- ============================================================================

SELECT
    schemaname,
    relname AS table_name,
    pg_size_pretty(pg_relation_size(relid)) AS table_size,
    pg_size_pretty(pg_total_relation_size(relid)) AS total_size_including_indexes
FROM pg_stat_user_tables
WHERE schemaname = 'formation_sql'
ORDER BY pg_total_relation_size(relid) DESC;

-- ============================================================================ 
-- 5) MAINTENANCE SIMPLIFIEE DES TABLES
-- ============================================================================

-- Nettoyage léger
VACUUM formation_sql.dbcustomers;

-- Nettoyage + recalcul des statistiques
VACUUM ANALYZE formation_sql.dbcustomers;

-- Réécriture complète de la table (équivalent d’un REBUILD)
VACUUM FULL formation_sql.dbcustomers;

-- Regroupement physique selon un index (optionnel)
-- CLUSTER formation_sql.dbcustomers USING idx_dbcustomers_country_score;
