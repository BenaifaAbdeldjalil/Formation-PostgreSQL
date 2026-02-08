/* =============================================================================
   TRIGGERS SQL AVEC POSTGRESQL
   -----------------------------------------------------------------------------
   Objectif du script :
   - Créer une table de journalisation (logs)
   - Créer une fonction trigger (obligatoire en PostgreSQL)
   - Créer un trigger AFTER INSERT sur la table  Employees
   - Enregistrer automatiquement les informations des nouveaux employés
     dans la table  EmployeeLogs
   =============================================================================
*/

-- ============================================================================
-- ÉTAPE 1 : Création de la table de logs
-- ============================================================================
-- Cette table sert à stocker l’historique des insertions effectuées
-- sur la table Employees.
-- Chaque ligne représente un événement (un employé ajouté).

CREATE TABLE  EmployeeLogs
(
    -- Identifiant unique du log
    -- SERIAL génère automatiquement une séquence (équivalent IDENTITY)
    LogID      SERIAL PRIMARY KEY,

    -- Identifiant de l’employé nouvellement inséré
    EmployeeID INT,

    -- Message descriptif de l’événement
    LogMessage VARCHAR(255),

    -- Date et heure de l’événement
    -- TIMESTAMP est plus précis que DATE
    LogDate    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- ÉTAPE 2 : Création de la fonction trigger
-- ============================================================================
-- En PostgreSQL, un trigger ne contient PAS directement le code.
-- Il appelle une fonction qui retourne TRIGGER.
--
-- NEW représente la nouvelle ligne insérée.
-- Cette fonction sera exécutée automatiquement après chaque INSERT.

CREATE OR REPLACE FUNCTION fn_log_new_employee()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Insertion d’un enregistrement dans la table de logs
    INSERT INTO  EmployeeLogs (EmployeeID, LogMessage, LogDate)
    VALUES (
        NEW.EmployeeID,
        'Nouvel employé ajouté : ID = ' || NEW.EmployeeID,
        CURRENT_TIMESTAMP
    );

    -- RETURN NEW est obligatoire pour les triggers AFTER INSERT
    RETURN NEW;
END;
$$;

-- ============================================================================
-- ÉTAPE 3 : Création du trigger
-- ============================================================================
-- Ce trigger s’exécute automatiquement APRÈS chaque insertion
-- sur la table  Employees.
-- FOR EACH ROW signifie que le trigger s’exécute ligne par ligne.

CREATE TRIGGER trg_after_insert_employee
AFTER INSERT
ON  Employees
FOR EACH ROW
EXECUTE FUNCTION fn_log_new_employee();

-----verfier sur la table employees


-- ============================================================================
-- ÉTAPE 4 : Insertion d’un nouvel employé
-- ============================================================================
-- Cette insertion déclenche automatiquement le trigger.
-- Aucune action manuelle n’est nécessaire pour écrire dans EmployeeLogs.

INSERT INTO  Employees
VALUES (
    6,
    'Maria',
    'Doe',
    'HR',
    '1988-01-12',
    'F',
    80000,
    3
);

-- ============================================================================
-- ÉTAPE 5 : Vérification des logs
-- ============================================================================
-- Cette requête permet de consulter les événements enregistrés
-- suite aux insertions dans la table Employees.

SELECT *
FROM  formation_sql.employees;

SELECT *
FROM  formation_sql.EmployeeLogs;
