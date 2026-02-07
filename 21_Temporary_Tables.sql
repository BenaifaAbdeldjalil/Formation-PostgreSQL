/* ==============================================================================
   TABLES TEMPORAIRES SQL (TEMPORARY TABLES)
-------------------------------------------------------------------------------
   Les tables temporaires permettent de :
   - stocker des données intermédiaires
   - nettoyer ou transformer des données sans impacter les tables sources
   - simplifier des traitements complexes
   - améliorer la lisibilité et la maintenance du code

   ⚠️ Une table temporaire n’existe que pendant la session courante.
===============================================================================
*/

/* ==============================================================================
   ÉTAPE 1 : Création d’une table temporaire à partir de Orders
===============================================================================*/

/*
 On crée une table temporaire contenant une copie complète
 de la table  Orders.
 Cette table sera utilisée comme zone de travail (staging).
*/

CREATE TEMP TABLE temp_orders AS
SELECT *
FROM  Orders;

SELECT *
FROM  temp_orders;
/* ==============================================================================
   ÉTAPE 2 : Nettoyage des données dans la table temporaire
===============================================================================*/

/*
 On supprime de la table temporaire les commandes
 dont le statut est 'Delivered'.

 👉 La table source  Orders n’est PAS affectée.
*/

DELETE
FROM temp_orders
WHERE OrderStatus = 'Delivered';

SELECT *
FROM  temp_orders;
/* ==============================================================================
   ÉTAPE 3 : Chargement des données nettoyées dans une table permanente
===============================================================================*/

/*
 On insère les données nettoyées dans une table permanente.
 Cette étape est typique dans un processus ETL
 (Extract – Transform – Load).
*/

CREATE TABLE  Orderspropre AS
SELECT *
FROM temp_orders;



/* ==============================================================================
   TEMP TABLE vs VUE
-------------------------------------------------------------------------------
   TEMP TABLE (table temporaire) :
     - Stocke physiquement les données dans la session en cours
     - Disparaît automatiquement à la fin de la session
     - Permet INSERT, UPDATE, DELETE sur les données
     - Idéale pour le traitement intermédiaire, le nettoyage ou les tests
     - Exemple : filtrer les commandes non livrées avant de les charger dans une table permanente

   VUE (VIEW) :
     - Ne stocke pas les données, représente uniquement une requête SQL
     - Permanente jusqu'à sa suppression
     - Non modifiable directement (sauf vue modifiable)
     - Utilisée pour simplifier l'accès aux données, masquer la complexité, ou contrôler la sécurité
     - Exemple : afficher les détails de commandes par client sans répéter les jointures

   Différence clé :
     - TEMP TABLE = copie réelle des données, modifiable, temporaire
     - VUE = couche logique, dynamique, non stockée
     - TEMP TABLE = performant pour traitements intermédiaires
     - VUE = pratique pour abstraction, lecture et sécurité
=============================================================================== */

