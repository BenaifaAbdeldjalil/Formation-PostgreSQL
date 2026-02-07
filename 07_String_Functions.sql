/* ==============================================================================
   SQL – FONCTIONS SUR LES CHAÎNES DE CARACTÈRES (STRING FUNCTIONS)
-------------------------------------------------------------------------------
   Les fonctions texte permettent de :
   - modifier l’affichage du texte
   - nettoyer les données
   - extraire des parties d’une chaîne de caractères

   Sommaire :
     1. Manipulations
        - CONCAT
        - LOWER
        - UPPER
        - TRIM
        - REPLACE
     2. Calcul
        - LEN
     3. Extraction de sous-chaînes
        - LEFT
        - RIGHT
        - SUBSTRING
=================================================================================
*/

/* ==============================================================================
   CONCAT() – CONCATÉNATION DE CHAÎNES
=============================================================================== */

-- Fusionner le prénom et le pays dans une seule colonne
SELECT
    CONCAT(first_name, ' - ', country) AS full_info
FROM customers;

/* ==============================================================================
   LOWER() & UPPER() – CHANGER LA CASSE
=============================================================================== */

-- Convertir le prénom en minuscules
SELECT
    LOWER(first_name) AS prenom_minuscule
FROM customers;

-- Convertir le prénom en majuscules
SELECT
    UPPER(first_name) AS prenom_majuscule
FROM customers;

/* ==============================================================================
   TRIM() – SUPPRIMER LES ESPACES INUTILES
=============================================================================== */

-- Identifier les prénoms contenant des espaces au début ou à la fin
SELECT
    first_name,
    LEN(first_name) AS longueur_originale,
    LEN(TRIM(first_name)) AS longueur_nettoyee,
    LEN(first_name) - LEN(TRIM(first_name)) AS nombre_espaces
FROM customers
WHERE LEN(first_name) != LEN(TRIM(first_name));
-- Alternative :
-- WHERE first_name != TRIM(first_name)

/* ==============================================================================
   REPLACE() – REMPLACER OU SUPPRIMER DU TEXTE
=============================================================================== */

-- Remplacer les tirets dans un numéro de téléphone
SELECT
    '123-456-7890' AS telephone_original,
    REPLACE('123-456-7890', '-', '/') AS telephone_modifie;

-- Changer l’extension d’un fichier de .txt vers .csv
SELECT
    'report.txt' AS ancien_nom,
    REPLACE('report.txt', '.txt', '.csv') AS nouveau_nom;

/* ==============================================================================
   LEN() – LONGUEUR D’UNE CHAÎNE
=============================================================================== */

-- Calculer la longueur du prénom de chaque client
SELECT
    first_name,
    LEN(first_name) AS longueur_prenom
FROM customers;

/* ==============================================================================
   LEFT() & RIGHT() – EXTRACTION DE CARACTÈRES
=============================================================================== */

-- Récupérer les 2 premières lettres du prénom
SELECT
    first_name,
    LEFT(TRIM(first_name), 2) AS deux_premieres_lettres
FROM customers;

-- Récupérer les 2 dernières lettres du prénom
SELECT
    first_name,
    RIGHT(first_name, 2) AS deux_dernieres_lettres
FROM customers;

/* ==============================================================================
   SUBSTRING() – EXTRAIRE UNE PARTIE D’UNE CHAÎNE
=============================================================================== */

-- Supprimer la première lettre du prénom
SELECT
    first_name,
    SUBSTRING(TRIM(first_name), 2, LEN(first_name)) AS prenom_sans_premiere_lettre
FROM customers;

/* ==============================================================================
   IMBRICATION DE FONCTIONS (NESTING)
=============================================================================== */

-- Combiner plusieurs fonctions dans une même expression
SELECT
    first_name,
    UPPER(LOWER(first_name)) AS prenom_formate
FROM customers;
