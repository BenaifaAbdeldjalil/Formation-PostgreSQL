-- ============================================================================
-- SURVEILLANCE DES INDEX
-- ============================================================================

-- Liste des index d’une table
SELECT
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE tablename = 'dbcustomers';

-- ============================================================================
-- UTILISATION DES INDEX
-- ============================================================================

-- Statistiques d’utilisation des index
SELECT
    relname AS table_name,
    indexrelname AS index_name,
    idx_scan AS number_of_scans,
    idx_tup_read AS tuples_read,
    idx_tup_fetch AS tuples_fetched
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;

-- ============================================================================
-- INDEX MANQUANTS (équivalent logique)
-- ============================================================================

/*
   PostgreSQL ne fournit PAS de vue système pour les index manquants.
   L’analyse se fait via :
   - EXPLAIN / EXPLAIN ANALYZE
   - Logs slow queries
   - Extensions comme auto_explain
*/

-- Exemple d’analyse de plan
EXPLAIN ANALYZE
SELECT *
FROM formation_sql.customers
WHERE country = 'USA';

-- ============================================================================
-- STATISTIQUES
-- ============================================================================

-- Consultation des statistiques
SELECT
    relname AS table_name,
    n_live_tup AS live_rows,
    n_dead_tup AS dead_rows,
    last_analyze,
    last_autoanalyze
FROM pg_stat_user_tables;

-- Mise à jour manuelle des statistiques
ANALYZE formation_sql.dbcustomers;

-- ============================================================================
-- FRAGMENTATION ET MAINTENANCE
-- ============================================================================

/*
   PostgreSQL ne fragmente pas les index comme SQL Server,
   mais les mises à jour génèrent des tuples morts.
*/

-- Nettoyage léger (suppression des tuples morts)
VACUUM formation_sql.dbcustomers;

-- Nettoyage + recalcul des statistiques
VACUUM ANALYZE formation_sql.dbcustomers;

-- Réécriture complète de la table et des index
-- (équivalent d’un REBUILD)
VACUUM FULL formation_sql.dbcustomers;

-- Regroupement physique selon un index (optionnel)
CLUSTER formation_sql.dbcustomers
USING idx_dbcustomers_country_score;
