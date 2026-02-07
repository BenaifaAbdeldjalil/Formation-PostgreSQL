/* ==============================================================================
   SQL – FONCTIONS NUMÉRIQUES
-------------------------------------------------------------------------------
   Les fonctions numériques permettent d’effectuer des calculs mathématiques
   et de formater les nombres dans les requêtes SQL.

   Sommaire :
     1. Fonctions d’arrondi
        - ROUND
     2. Valeur absolue
        - ABS
=================================================================================
*/

/* ==============================================================================
   ROUND() – ARRONDIR DES NOMBRES
=============================================================================== */

-- Exemple d’arrondi d’un nombre avec différents niveaux de précision
SELECT
    3.516 AS nombre_original,
    ROUND(3.516, 2) AS arrondi_2_decimales,
    ROUND(3.516, 1) AS arrondi_1_decimale,
    ROUND(3.516, 0) AS arrondi_entier;

/* ==============================================================================
   ABS() – VALEUR ABSOLUE
=============================================================================== */

-- Exemple de la fonction valeur absolue
SELECT
    -10 AS nombre_original,
    ABS(-10) AS valeur_absolue_nombre_negatif,
    ABS(10) AS valeur_absolue_nombre_positif;
