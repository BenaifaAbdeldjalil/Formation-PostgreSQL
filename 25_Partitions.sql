/*
LES PARTITIONS DANS POSTGRESQL

La partition permet de découper une grande table en plusieurs
sous-tables plus petites appelées partitions, tout en conservant
une table parente unique pour les requêtes.

Objectifs principaux :
- Améliorer les performances sur les grosses tables
- Réduire les temps de scan
- Faciliter la maintenance (DELETE, VACUUM, archivage)
- Mieux gérer les données historiques

Fonctionnement :
- Les données sont réparties automatiquement selon une clé de partition
- PostgreSQL ne lit que les partitions concernées (partition pruning)

Types de partitionnement :

1) RANGE
   - Basé sur des intervalles (dates, IDs, montants)
   - Très utilisé pour les données temporelles
   Exemple : logs par mois

2) LIST
   - Basé sur des valeurs précises
   Exemple : pays, statut, catégorie

3) HASH
   - Répartition par hachage
   - Utile pour équilibrer les données

Avantages :
- Requêtes plus rapides sur de très grandes tables
- Suppression massive rapide (DROP PARTITION)
- Index plus petits et plus efficaces

Inconvénients :
- Mise en place plus complexe
- Mauvais choix de clé = peu de gain
- Trop de partitions peut nuire aux performances

Bonnes pratiques :
- Choisir une clé souvent utilisée dans les WHERE
- Éviter trop de partitions
- Indexer les partitions si nécessaire
- Idéal pour tables > plusieurs millions de lignes
*/



-- ============================================================================
-- ÉTAPE 1 : Création de la table parent partitionnée
-- ============================================================================
-- Cette table ne stocke AUCUNE donnée.
-- Elle définit uniquement la structure et la clé de partitionnement.

CREATE TABLE formation_sql.orders_partitioned
(
    orderid   INT,
    orderdate DATE,
    sales     INT
)
PARTITION BY RANGE (orderdate);

-- ============================================================================
-- ÉTAPE 2 : Création des partitions (par année)
-- ============================================================================
-- Chaque partition correspond à une plage de dates.
-- PostgreSQL choisira automatiquement la bonne partition
-- lors des INSERT.

-- Partition pour l’année 2023
CREATE TABLE formation_sql.orders_2023
PARTITION OF formation_sql.orders_partitioned
FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

-- Partition pour l’année 2024
CREATE TABLE formation_sql.orders_2024
PARTITION OF formation_sql.orders_partitioned
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

-- Partition pour l’année 2025
CREATE TABLE formation_sql.orders_2025
PARTITION OF formation_sql.orders_partitioned
FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- Partition pour 2026 et au-delà
CREATE TABLE formation_sql.orders_2026
PARTITION OF formation_sql.orders_partitioned
FOR VALUES FROM ('2026-01-01') TO (MAXVALUE);

-- ============================================================================
-- ÉTAPE 3 : Insertion de données
-- ============================================================================
-- Les données sont automatiquement routées vers la bonne partition
-- en fonction de la valeur de OrderDate.

INSERT INTO formation_sql.orders_partitioned VALUES (1, '2023-05-15', 100);
INSERT INTO formation_sql.orders_partitioned VALUES (2, '2024-07-20', 50);
INSERT INTO formation_sql.orders_partitioned VALUES (3, '2025-12-31', 20);
INSERT INTO formation_sql.orders_partitioned VALUES (4, '2026-01-01', 100);

-- ============================================================================
-- ÉTAPE 4 : Vérification de la répartition des données
-- ============================================================================
-- Cette requête permet de vérifier combien de lignes
-- sont stockées dans chaque partition.

SELECT
    relname AS partition_name,
    n_live_tup AS number_of_rows
FROM pg_stat_user_tables
WHERE relname LIKE 'orders_%'
ORDER BY relname;

-- Vérification plus détaillée via l’héritage
SELECT
    parent.relname AS parent_table,
    child.relname  AS partition_table
FROM pg_inherits
JOIN pg_class parent ON pg_inherits.inhparent = parent.oid
JOIN pg_class child  ON pg_inherits.inhrelid  = child.oid
WHERE parent.relname = 'orders_partitioned';

-- ============================================================================
-- ÉTAPE 5 : Création d’une table NON partitionnée pour comparaison
-- ============================================================================
-- Cette table servira à comparer les plans d’exécution
-- avec la table partitionnée.

CREATE TABLE formation_sql.orders_nopartition AS
SELECT *
FROM formation_sql.orders_partitioned;

-- ============================================================================
-- ÉTAPE 6 : Comparaison des performances (Execution Plans)
-- ============================================================================
-- PostgreSQL effectue automatiquement le "Partition Pruning",
-- c’est-à-dire qu’il ignore les partitions non pertinentes.

-- Requête sur la table partitionnée
EXPLAIN ANALYZE
SELECT *
FROM formation_sql.orders_partitioned
WHERE orderdate IN ('2026-01-01', '2025-12-31');

/*
EXPLICATION DU PLAN EXPLAIN ANALYZE AVEC PARTITIONS

Append
------
Append signifie que PostgreSQL exécute la requête sur plusieurs
partitions puis concatène (assemble) les résultats.

Ici :
- 2 partitions sont lues
- 1 ligne trouvée dans chaque partition
- 2 lignes retournées au total

Partitions scannées
-------------------
- orders_2025
- orders_2026

Seq Scan
--------
Chaque partition est lue avec un Sequential Scan :
- La partition est parcourue entièrement
- Le filtre est appliqué ensuite

Résumé
------
- Append = agrégation des résultats des partitions
- Partition pruning actif
- Seq Scan normal sur petites partitions
- Très bonnes performances globales
*/

-- Requête sur la table non partitionnée
EXPLAIN ANALYZE
SELECT *
FROM formation_sql.orders_nopartition
WHERE orderdate IN ('2026-01-01', '2025-12-31');

/*
EXPLICATION DU PLAN SANS PARTITION

Seq Scan on orders_nopartition
-----------------------------
PostgreSQL effectue un scan séquentiel sur toute la table
orders_nopartition (table non partitionnée).

- La table complète est parcourue
- Le filtre est appliqué ligne par ligne

-------------------------------------------------
DIFFÉRENCE AVEC LA VERSION PARTITIONNÉE
-------------------------------------------------

Table non partitionnée :
- Un seul Seq Scan sur toute la table
- Toutes les lignes sont lues
- Filtre appliqué après lecture

Table partitionnée :
- Append sur plusieurs partitions
- PostgreSQL ne lit que les partitions concernées
- Moins de données à parcourir (partition pruning)

Sur petites tables :
- La version non partitionnée peut être aussi rapide,
  voire légèrement plus rapide à cause du coût de planification

Sur grandes tables :
- Le partitionnement devient beaucoup plus performant
- Suppression massive plus rapide (DROP PARTITION)
- Maintenance et index plus efficaces

Résumé
------
- Seq Scan unique = table complète
- Append + partitions = lecture ciblée
- Le gain du partitionnement apparaît à grande échelle
*/
