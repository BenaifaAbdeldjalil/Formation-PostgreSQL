/* ==============================================================================
   SQL NULL Functions
   1. is null/is not null
===============================================================================
*/
select * FROM formation_sql.customers;

------ les nulls
SELECT
    FirstName,
    LastName
FROM formation_sql.customers
where LastName = 'null';

/*
SELECT
    FirstName,
    LastName
FROM formation_sql.customers
where FirstName is null;*/

------ les non nulls
SELECT
    FirstName,
    LastName
FROM formation_sql.customers
where LastName <> 'null';

/*
SELECT
    FirstName,
    LastName
FROM formation_sql.customers
where FirstName is not null;*/


/* ==============================================================================
  2. COALESCE() -
===============================================================================*/

/* Fonction la plus utilisée*/

-- Syntaxe
COALESCE(valeur1, valeur2, valeur3, ..., valeurN)

-- Exemples
/*
COALESCE(NULL, NULL, 'Troisième', 'Quatrième'),-- → 'Troisième'
COALESCE(NULL, 'Deuxième', 'Troisième'),-- → 'Deuxième'
COALESCE('Premier', NULL, 'Troisième'),-- → 'Premier'*/


-- Donner une valeur par défaut si NULL
SELECT COALESCE(managerid, 0) FROM employees;
---0
-- Choisir entre plusieurs colonnes
SELECT COALESCE(lastname,firstname,country, 'aucun@email.com') FROM formation_sql.customers;
--Algeria
--Mary

-- Priorité de sources
SELECT COALESCE("name",address) FROM formation_sql.client;

---EXEMPLE--
SELECT
    FirstName,
    LastName,
    FirstName || ' ' || COALESCE(LastName, '') AS FullName,
    Score,
    COALESCE(Score, 0) + 10 AS ScoreWithBonus
FROM formation_sql.customers;

/* ==============================================================================
   3. NULLIF - DIVISION BY ZERO
===============================================================================*/

-- Syntaxe
NULLIF(valeur1, valeur2)

-- Exemples
NULLIF(10, 10) → NULL
NULLIF(10, 20) → 10
NULLIF('A', 'A') → NULL
NULLIF('A', 'B') → 'A'


---Cas d'utilisation :
-- Éviter la division par zéro
SELECT salary / NULLIF(managerid, 0) FROM employees;

-- Ignorer les valeurs par défaut
SELECT NULLIF(orderstatus, 'N/A') FROM orders;

-- Traiter les doublons spéciaux
SELECT NULLIF(orderstatus, 'UNKNOWN') FROM formation_sql.orders;

/* ==============================================================================
---IS DISTINCT FROM et IS NOT DISTINCT FROM
===============================================================================*/

-- Comparaisons avec NULL
SELECT * FROM table WHERE col1 IS DISTINCT FROM col2;
-- Compare NULL = NULL → FALSE
-- Compare NULL = valeur → TRUE
-- Compare valeur = valeur → FALSE si différentes

-----Exemples :
-- Trouver les lignes où col1 et col2 sont différentes (NULL inclus)
SELECT * FROM employees 
WHERE salary <> old_salary;

----
SELECT * FROM employees 
WHERE salary IS DISTINCT FROM old_salary;

/* ==============================================================================
 --- Fonctions d'agrégation avec NULL
===============================================================================*/

-- SUM, AVG, COUNT, etc. ignorent les NULL
SELECT 
    AVG(old_salary) as moyenne_salaire,          -- NULL ignorés
    COUNT(old_salary) as nb_bonus,                 -- Compte seulement non-NULL
    COUNT(*) as total_lignes,                 -- Compte toutes les lignes
    COUNT(DISTINCT lastname) as nb_employees,
    COUNT(COALESCE(lastname, 'UNKNOWN')) as nb_employees_ -- NULL distinct compté comme une valeur
FROM formation_sql.employees;

/* ==============================================================================
   NULLs vs EMPTY STRING vs BLANK SPACES
===============================================================================*/

   Demonstrate differences between NULL, empty strings, and blank spaces 
*/
WITH Orders AS (
    SELECT 1 AS Id, 'A' AS Category UNION
    SELECT 2, NULL UNION
    SELECT 3, '' UNION
    SELECT 4, '  '
)
SELECT 
    *,
    LENGTH(Category) AS LenCategory,
    TRIM(Category) AS Policy1,
    NULLIF(TRIM(Category), '') AS Policy2,
    COALESCE(NULLIF(TRIM(Category), ''), 'unknown') AS Policy3
FROM Orders;


/* ==============================================================================
   FILTER (PostgreSQL 9.4+)
===============================================================================*/
-- Agréger seulement certaines lignes
SELECT 
    department,
    AVG(salary) FILTER (WHERE old_salary IS NOT NULL) as moyenne_avec_bonus,
    AVG(salary) FILTER (WHERE old_salary IS NULL) as moyenne_sans_bonus
FROM employees
GROUP BY department;



