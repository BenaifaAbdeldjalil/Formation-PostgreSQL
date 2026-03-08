/*
RÔLE DES INDEX DANS POSTGRESQL

Les index servent à accélérer l’accès aux données en évitant
le parcours complet des tables (sequential scan).

Sans index :
- PostgreSQL parcourt toute la table → lent sur les grosses tables

Avec index :
- Accès direct aux lignes recherchées → beaucoup plus rapide

Ils améliorent les performances des requêtes utilisant :
- WHERE
- JOIN
- ORDER BY
- GROUP BY
- DISTINCT
- contraintes PRIMARY KEY et UNIQUE

Types d’index courants :
- B-tree (par défaut) : =, <, >, BETWEEN
- Hash : égalité stricte
- GIN : tableaux, JSONB, full-text search
- GiST : données géométriques, recherche floue
- BRIN : très grosses tables avec données ordonnées

Inconvénients :
- Occupent de l’espace disque
- Ralentissent INSERT / UPDATE / DELETE
- Trop d’index peut nuire aux performances

Règle d’or :
Indexer ce qui est souvent lu, pas ce qui est souvent écrit.
*/
-- ============================================================================
-- INDEX B-TREE (équivalent non-clustered par défaut)
-- ============================================================================

-- Création d’une table de travail à partir de formation_sql.Customers
-- Cette table est initialement un HEAP (aucun ordre physique)
CREATE TABLE formation_sql.dbcustomers AS
SELECT *
FROM formation_sql.customers;

-- Requête de test : recherche par clé primaire
-- Sans index, PostgreSQL effectue un Seq Scan (scan séquentiel)
SELECT *
FROM formation_sql.dbcustomers
WHERE customerid = 1;

-- Création d’un index B-tree sur CustomerID
-- C’est le type d’index par défaut dans PostgreSQL
CREATE INDEX idx_dbcustomers_customerid
ON formation_sql.dbcustomers (customerid);

-- PostgreSQL autorise plusieurs index sur une table,
-- mais PAS plusieurs clés primaires
-- (il n’existe pas de notion de "second clustered index")

-- Suppression de l’index
DROP INDEX idx_dbcustomers_customerid;

-- ============================================================================
-- INDEX SUR COLONNE SIMPLE
-- ============================================================================

-- Requête filtrée sur le nom
SELECT *
FROM formation_sql.dbcustomers
WHERE lastname = 'Brown';

-- Création d’un index pour accélérer les recherches par nom
CREATE INDEX idx_dbcustomers_lastname
ON formation_sql.dbcustomers (lastname);

-- Index supplémentaire sur le prénom
CREATE INDEX idx_dbcustomers_firstname
ON formation_sql.dbcustomers (firstname);

-- ============================================================================
-- INDEX COMPOSITE (multi-colonnes)
-- ============================================================================

-- Index composite sur Country + Score
-- L’ordre des colonnes est TRÈS important
CREATE INDEX idx_dbcustomers_country_score
ON formation_sql.dbcustomers (country, score);

-- Cette requête UTILISE l’index composite
-- car elle respecte l’ordre des colonnes
SELECT *
FROM formation_sql.dbcustomers
WHERE country = 'USA'
  AND score > 500;

-- Cette requête peut être moins optimisée
-- car la condition principale n’est pas sur la colonne de gauche
SELECT *
FROM formation_sql.dbcustomers
WHERE score > 500
  AND country = 'USA';





