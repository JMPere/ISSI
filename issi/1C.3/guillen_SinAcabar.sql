/*procedures */

/*stock*/
CREATE OR REPLACE PROCEDURE PR_Sum_Stock (nombreMueble IN Muebles%TYPE)
IS
BEGIN
        UPDATE  Mueble
            SET WHERE nombreMueble= nomMueble cantidad  = nuevaCant
        COMMIT;
END;

/*precio carrito*/
CREATE OR REPLACE PROCEDURE ACT_PRECIO*CANTIDAD (NOMBRE_MUEBLE (varchar(20),CANTIDAD int, PRECIO NUMBER (3,2)) RETURN PRECIO;
BEGIN
    UPDATE CARRITO SET PRECIO*CANTIDAD WHERE NOMBREMUEBLE=NOMBRE_MUEBLE;
end;
        
     




