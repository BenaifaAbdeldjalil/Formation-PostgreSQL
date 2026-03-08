/* ==========================================================
EXEMPLE SIMPLE DE PROCEDURE

- Une procédure est un programme stocké dans la base.
- Elle s’exécute seulement quand on l’appelle avec CALL.
- Elle peut contenir plusieurs instructions SQL.

========================================================== */

/* ==========================================================
EXEMPLE SIMPLE : PROCEDURE POUR AFFICHER LES CLIENTS
========================================================== */

CREATE OR REPLACE PROCEDURE afficher_clients()
LANGUAGE plpgsql
AS $$
DECLARE
    v_id INT;
    v_nom TEXT;
    v_country TEXT;
BEGIN
    -- Boucle sur chaque client
    FOR v_id, v_nom, v_country IN
        SELECT customerid, firstname,country
        FROM  customers
    LOOP
        RAISE NOTICE 'ID: %, Nom: %, Pays: %', v_id, v_nom, v_country;
    END LOOP;
END;
$$;

-- Exécution de la procédure
CALL afficher_clients();
