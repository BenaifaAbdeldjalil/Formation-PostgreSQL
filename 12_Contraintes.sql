/* ==============================================================================
   PARTIE CONTRAINTES EN POSTGRESQL
-------------------------------------------------------------------------------
   Ce script couvre :
     1. Théorie des contraintes
     2. Création des tables avec contraintes
     3. Ajout de contraintes sur des tables existantes
     4. Exemples d'insertion valides et invalides
=============================================================================== */

/* ==============================================================================
   1. Théorie des contraintes
===============================================================================

Contraintes courantes dans PostgreSQL :

1. PRIMARY KEY : Identifie de manière unique chaque ligne d'une table.
   - Une table ne peut avoir qu'une seule clé primaire.
   - Les colonnes de la clé primaire sont implicitement NOT NULL.

2. FOREIGN KEY : Assure l'intégrité référentielle entre deux tables.
   - Une colonne ou un groupe de colonnes doit correspondre à une clé primaire ou unique dans une autre table.

3. UNIQUE : Garantit que toutes les valeurs dans une colonne ou un ensemble de colonnes sont uniques.

4. NOT NULL : Empêche l’insertion de valeurs NULL dans une colonne.

5. CHECK : Permet de définir une condition qui doit être vraie pour chaque ligne insérée.

6. DEFAULT : Permet de définir une valeur par défaut si aucune valeur n’est fournie à l’insertion.

==============================================================================*/

/* ==============================================================================
   2. Création des tables avec contraintes
=============================================================================== */

-- DROP TABLE si elle existe
DROP TABLE IF EXISTS formation_sql.customers_1 CASCADE;
DROP TABLE IF EXISTS formation_sql.employees_1 CASCADE;

-- Table customers_1
CREATE TABLE formation_sql.customers_1 (
    customerid INT NOT NULL,                 -- clé primaire
    firstname VARCHAR(20) NOT NULL,          -- NOT NULL
    lastname VARCHAR(20) NOT NULL,
    country VARCHAR(7) DEFAULT 'FR',         -- valeur par défaut
    score INT CHECK (score >= 0 AND score <= 100), -- CHECK constraint
    CONSTRAINT customers_1_pkey PRIMARY KEY (customerid)
);

-- Table employees_1
CREATE TABLE formation_sql.employees_1 (
    employeeid INT NOT NULL,
    firstname VARCHAR(20) NOT NULL,
    lastname VARCHAR(20) NOT NULL,
    department VARCHAR(20) NOT NULL,
    birthdate DATE NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M','F')), -- CHECK constraint
    salary INT CHECK (salary > 0),
    managerid INT,
    old_salary INT,
    CONSTRAINT employees_1_pkey PRIMARY KEY (employeeid),
    CONSTRAINT fk_manager FOREIGN KEY (managerid) REFERENCES formation_sql.employees_1(employeeid)
);

/* ==============================================================================
   3. Ajout de contraintes sur tables existantes
=============================================================================== */

-- Ajouter une clé étrangère pour lier un employé à un customer (exemple)
ALTER TABLE formation_sql.customers_1
ADD COLUMN account_manager_id INT;

ALTER TABLE formation_sql.customers_1
ADD CONSTRAINT fk_account_manager FOREIGN KEY (account_manager_id)
REFERENCES formation_sql.employees_1(employeeid);

-- Ajouter une contrainte UNIQUE sur firstname + lastname
ALTER TABLE formation_sql.customers_1
ADD CONSTRAINT unique_fullname UNIQUE (firstname, lastname);

/* ==============================================================================
   4. Exemples d'insertion valides et invalides
=============================================================================== */

-- ===================== INSERTIONS VALIDES =====================
INSERT INTO formation_sql.employees_1 (employeeid, firstname, lastname, department, birthdate, gender, salary)
VALUES (1, 'Alice', 'Durand', 'IT', '1985-01-01', 'F', 4000);

INSERT INTO formation_sql.employees_1 (employeeid, firstname, lastname, department, birthdate, gender, salary, managerid)
VALUES (2, 'Bob', 'Martin', 'IT', '1980-05-12', 'M', 4500, 1);

INSERT INTO formation_sql.customers_1 (customerid, firstname, lastname, country, score, account_manager_id)
VALUES (101, 'Charlie', 'Dupont', 'FR', 80, 1);

INSERT INTO formation_sql.customers_1 (customerid, firstname, lastname, score)
VALUES (102, 'David', 'Leclerc', 95);

-- ===================== INSERTIONS INVALIDES =====================
-- 1. Violation de PRIMARY KEY
-- INSERT INTO formation_sql.customers_1 (customerid, firstname, lastname) VALUES (101, 'Eve', 'Petit');

-- 2. Violation de NOT NULL
-- INSERT INTO formation_sql.customers_1 (customerid, firstname, lastname) VALUES (103, NULL, 'Moreau');

-- 3. Violation de CHECK
-- INSERT INTO formation_sql.customers_1 (customerid, firstname, lastname, score) VALUES (104, 'Fiona', 'Lemoine', 150);

-- 4. Violation de FOREIGN KEY
-- INSERT INTO formation_sql.customers_1 (customerid, firstname, lastname, account_manager_id) VALUES (105, 'Gilles', 'Renard', 999);

-- 5. Violation de UNIQUE
-- INSERT INTO formation_sql.customers_1 (customerid, firstname, lastname) VALUES (106, 'Charlie', 'Dupont');


