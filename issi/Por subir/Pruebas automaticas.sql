-------------------------------------------Pruebas automaticas
CL SCR;
SET SERVEROUTPUT ON;

-- PAQUETE  ASSERT_EQUALS
CREATE OR REPLACE FUNCTION ASSERT_EQUALS (SALIDA BOOLEAN, SALIDA_ESPERADA BOOLEAN) RETURN VARCHAR2 AS 
BEGIN
  IF (SALIDA = SALIDA_ESPERADA) THEN
    RETURN 'ÉXITO';
  ELSE
    RETURN 'FALLO';
  END IF;
END ASSERT_EQUALS;
/


/*Paquete pruebas empleado*/
CREATE OR REPLACE PACKAGE PRUEBAS_EMPLEADO AS
    PROCEDURE INICIALIZAR;
    PROCEDURE INSERTAR( NOMBRE_PRUEBA VARCHAR2, 
                        W_DNI IN EMPLEADO.DNI%TYPE,
                        W_NICKNAME IN EMPLEADO.NICKNAME%TYPE,
                        W_CONTRASEÑA IN EMPLEADO.CONTRASEÑA%TYPE,
                        W_NOMBRE IN EMPLEADO.NOMBRE%TYPE,
                        W_APELLIDOS IN EMPLEADO.APELLIDOS%TYPE,
                        W_FECHA_NACIMIENTO IN EMPLEADO.FECHA_NACIMIENTO%TYPE,
                        W_TELEFONO IN EMPLEADO.TELEFONO%TYPE,
                        W_CORREO IN EMPLEADO.CORREO%TYPE,
                        SALIDA_ESPERADA BOOLEAN);
                        
    PROCEDURE ACTUALIZAR(   NOMBRE_PRUEBA VARCHAR2, 
                            W_DNI IN EMPLEADO.DNI%TYPE,
                            W_NICKNAME IN EMPLEADO.NICKNAME%TYPE,
                            W_CONTRASEÑA IN EMPLEADO.CONTRASEÑA%TYPE,
                            W_NOMBRE IN EMPLEADO.NOMBRE%TYPE,
                            W_APELLIDOS IN EMPLEADO.APELLIDOS%TYPE,
                            W_FECHA_NACIMIENTO IN EMPLEADO.FECHA_NACIMIENTO%TYPE,
                            W_TELEFONO IN EMPLEADO.TELEFONO%TYPE,
                            W_CORREO IN EMPLEADO.CORREO%TYPE,
                            SALIDA_ESPERADA BOOLEAN);
                            
    PROCEDURE ELIMINAR (NOMBRE_PRUEBA VARCHAR2, 
                        W_DNI IN EMPLEADO.DNI%TYPE, 
                        SALIDA_ESPERADA BOOLEAN);
END PRUEBAS_EMPLEADO;


/

CREATE OR REPLACE PACKAGE BODY PRUEBAS_EMPLEADO AS
    
    /* INICIALIZACIÓN */
    PROCEDURE INICIALIZAR AS
    BEGIN
    /* BORRAR CONTENIDO DE LA TABLA */
        DELETE FROM EMPLEADO ;
    END INICIALIZAR;

    PROCEDURE INSERTAR (NOMBRE_PRUEBA VARCHAR2, 
                        W_DNI IN EMPLEADO.DNI%TYPE,
                        W_NICKNAME IN EMPLEADO.NICKNAME%TYPE,
                        W_CONTRASEÑA IN EMPLEADO.CONTRASEÑA%TYPE,
                        W_NOMBRE IN EMPLEADO.NOMBRE%TYPE,
                        W_APELLIDOS IN EMPLEADO.APELLIDOS%TYPE,
                        W_FECHA_NACIMIENTO IN EMPLEADO.FECHA_NACIMIENTO%TYPE,
                        W_TELEFONO IN EMPLEADO.TELEFONO%TYPE,
                        W_CORREO IN EMPLEADO.CORREO%TYPE,
                        SALIDA_ESPERADA BOOLEAN) 
    AS
        SALIDA BOOLEAN := TRUE;
        TIPO_EMPLEADO EMPLEADO%ROWTYPE;
        W_OID_EMPLEADO NUMBER(7);
        
    BEGIN
        INSERT INTO EMPLEADO (DNI, NICKNAME, CONTRASEÑA,  NOMBRE, APELLIDOS, FECHA_NACIMIENTO, TELEFONO, CORREO) 
            VALUES (W_DNI, W_NICKNAME, W_CONTRASEÑA, W_NOMBRE, W_APELLIDOS, W_FECHA_NACIMIENTO, W_TELEFONO, W_CORREO);

        W_OID_EMPLEADO := INCRE_OID_EMPLEADO.CURRVAL;
        SELECT * INTO TIPO_EMPLEADO FROM EMPLEADO WHERE OID_EMPLEADO = W_OID_EMPLEADO;
        IF (TIPO_EMPLEADO.OID_EMPLEADO <> W_OID_EMPLEADO) THEN
            SALIDA := FALSE;
        END IF;
        COMMIT WORK;

         DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, SALIDA_ESPERADA));

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(FALSE, SALIDA_ESPERADA));
            ROLLBACK;
    END INSERTAR;
    
    PROCEDURE ACTUALIZAR (  NOMBRE_PRUEBA VARCHAR2, 
                        W_DNI IN EMPLEADO.DNI%TYPE,
                        W_NICKNAME IN EMPLEADO.NICKNAME%TYPE,
                        W_CONTRASEÑA IN EMPLEADO.CONTRASEÑA%TYPE,
                        W_NOMBRE IN EMPLEADO.NOMBRE%TYPE,
                        W_APELLIDOS IN EMPLEADO.APELLIDOS%TYPE,
                        W_FECHA_NACIMIENTO IN EMPLEADO.FECHA_NACIMIENTO%TYPE,
                        W_TELEFONO IN EMPLEADO.TELEFONO%TYPE,
                        W_CORREO IN EMPLEADO.CORREO%TYPE,
                            SALIDA_ESPERADA BOOLEAN) 
    AS
        SALIDA BOOLEAN := TRUE;
        TIPO_EMPLEADO EMPLEADO%ROWTYPE;
        
    BEGIN

        UPDATE EMPLEADO
            SET NICKNAME = W_NICKNAME,
                CONTRASEÑA = W_CONTRASEÑA, 
                NOMBRE = W_NOMBRE,
                APELLIDOS = W_APELLIDOS,
                FECHA_NACIMIENTO = W_FECHA_NACIMIENTO,
                TELEFONO = W_TELEFONO,
                CORREO = W_CORREO
            WHERE DNI = W_DNI;
            
        SELECT * INTO TIPO_EMPLEADO FROM EMPLEADO WHERE DNI = W_DNI;
    
        IF (TIPO_EMPLEADO.NICKNAME <> W_NICKNAME
            OR TIPO_EMPLEADO.CONTRASEÑA <> W_CONTRASEÑA
            OR TIPO_EMPLEADO.NOMBRE <> W_NOMBRE
            OR TIPO_EMPLEADO.APELLIDOS <> W_APELLIDOS 
            OR TIPO_EMPLEADO.FECHA_NACIMIENTO <> W_FECHA_NACIMIENTO
            OR TIPO_EMPLEADO.TELEFONO <> W_TELEFONO
            OR TIPO_EMPLEADO.CORREO <> W_CORREO ) THEN
            
            SALIDA := FALSE;
        END IF;
        COMMIT WORK;

        DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, SALIDA_ESPERADA));

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(FALSE, SALIDA_ESPERADA));
            ROLLBACK;
    END ACTUALIZAR;
    
     PROCEDURE ELIMINAR (   NOMBRE_PRUEBA VARCHAR2, 
                            W_DNI IN EMPLEADO.DNI%TYPE, 
                            SALIDA_ESPERADA BOOLEAN) 
    AS
        SALIDA BOOLEAN := TRUE;
        N_EMPLEADO INTEGER;
        
    BEGIN
        DELETE FROM EMPLEADO WHERE DNI = W_DNI;
        
        SELECT COUNT(*) INTO N_EMPLEADO FROM EMPLEADO WHERE DNI = W_DNI;
        IF (N_EMPLEADO <> 0) THEN
            SALIDA := FALSE;
        END IF;
        COMMIT WORK;

        DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, SALIDA_ESPERADA));

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(FALSE, SALIDA_ESPERADA));
            ROLLBACK;
    END ELIMINAR;
    
END PRUEBAS_EMPLEADO;
/ 

/*PAQUETE PRUEBAS CLIENTE*/
CREATE OR REPLACE PACKAGE PRUEBAS_CLIENTE AS
    PROCEDURE INICIALIZAR;
    PROCEDURE INSERTAR( NOMBRE_PRUEBA VARCHAR2, 
                        W_DNI IN CLIENTE.DNI%TYPE,
                        W_NICKNAME IN CLIENTE.NICKNAME%TYPE,
                        W_CONTRASEÑA IN CLIENTE.CONTRASEÑA%TYPE,
                        W_NOMBRE IN CLIENTE.NOMBRE%TYPE,
                        W_APELLIDOS IN CLIENTE.APELLIDOS%TYPE,
                        W_FECHA_NACIMIENTO IN CLIENTE.FECHA_NACIMIENTO%TYPE,
                        W_TELEFONO IN CLIENTE.TELEFONO%TYPE,
                        W_CORREO IN CLIENTE.CORREO%TYPE,
                        SALIDA_ESPERADA BOOLEAN);
                        
    PROCEDURE ACTUALIZAR(   NOMBRE_PRUEBA VARCHAR2, 
                            W_DNI IN CLIENTE.DNI%TYPE,
                            W_NICKNAME IN CLIENTE.NICKNAME%TYPE,
                            W_CONTRASEÑA IN CLIENTE.CONTRASEÑA%TYPE,
                            W_NOMBRE IN CLIENTE.NOMBRE%TYPE,
                            W_APELLIDOS IN CLIENTE.APELLIDOS%TYPE,
                            W_FECHA_NACIMIENTO IN CLIENTE.FECHA_NACIMIENTO%TYPE,
                            W_TELEFONO IN CLIENTE.TELEFONO%TYPE,
                            W_CORREO IN CLIENTE.CORREO%TYPE,
                            SALIDA_ESPERADA BOOLEAN);
                            
    PROCEDURE ELIMINAR (NOMBRE_PRUEBA VARCHAR2, 
                        W_DNI IN CLIENTE.DNI%TYPE, 
                        SALIDA_ESPERADA BOOLEAN);
END PRUEBAS_CLIENTE;


/

CREATE OR REPLACE PACKAGE BODY PRUEBAS_CLIENTE AS
    
    /* INICIALIZACIÓN */
    PROCEDURE INICIALIZAR AS
    BEGIN
    /* BORRAR CONTENIDO DE LA TABLA */
        DELETE FROM CLIENTE ;
    END INICIALIZAR;

    PROCEDURE INSERTAR (NOMBRE_PRUEBA VARCHAR2, 
                        W_DNI IN CLIENTE.DNI%TYPE,
                        W_NICKNAME IN CLIENTE.NICKNAME%TYPE,
                        W_CONTRASEÑA IN CLIENTE.CONTRASEÑA%TYPE,
                        W_NOMBRE IN CLIENTE.NOMBRE%TYPE,
                        W_APELLIDOS IN CLIENTE.APELLIDOS%TYPE,
                        W_FECHA_NACIMIENTO IN CLIENTE.FECHA_NACIMIENTO%TYPE,
                        W_TELEFONO IN CLIENTE.TELEFONO%TYPE,
                        W_CORREO IN CLIENTE.CORREO%TYPE,
                        SALIDA_ESPERADA BOOLEAN) 
    AS
        SALIDA BOOLEAN := TRUE;
        TIPO_CLIENTE CLIENTE%ROWTYPE;
        W_OID_CLIENTE NUMBER(7);
        
    BEGIN
        INSERT INTO CLIENTE (DNI, NICKNAME, CONTRASEÑA,  NOMBRE, APELLIDOS, FECHA_NACIMIENTO, TELEFONO, CORREO) 
            VALUES (W_DNI, W_NICKNAME, W_CONTRASEÑA, W_NOMBRE, W_APELLIDOS, W_FECHA_NACIMIENTO, W_TELEFONO, W_CORREO);

        W_OID_CLIENTE := INCRE_OID_CLIENTE.CURRVAL;
        SELECT * INTO TIPO_CLIENTE FROM CLIENTE WHERE OID_CLIENTE = W_OID_CLIENTE;
        IF (TIPO_CLIENTE.OID_CLIENTE <> W_OID_CLIENTE) THEN
            SALIDA := FALSE;
        END IF;
        COMMIT WORK;

         DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, SALIDA_ESPERADA));

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(FALSE, SALIDA_ESPERADA));
            ROLLBACK;
    END INSERTAR;
    
    PROCEDURE ACTUALIZAR (  NOMBRE_PRUEBA VARCHAR2, 
                        W_DNI IN CLIENTE.DNI%TYPE,
                        W_NICKNAME IN CLIENTE.NICKNAME%TYPE,
                        W_CONTRASEÑA IN CLIENTE.CONTRASEÑA%TYPE,
                        W_NOMBRE IN CLIENTE.NOMBRE%TYPE,
                        W_APELLIDOS IN CLIENTE.APELLIDOS%TYPE,
                        W_FECHA_NACIMIENTO IN CLIENTE.FECHA_NACIMIENTO%TYPE,
                        W_TELEFONO IN CLIENTE.TELEFONO%TYPE,
                        W_CORREO IN CLIENTE.CORREO%TYPE,
                            SALIDA_ESPERADA BOOLEAN) 
    AS
        SALIDA BOOLEAN := TRUE;
        TIPO_CLIENTE CLIENTE%ROWTYPE;
        
    BEGIN

        UPDATE CLIENTE
            SET NICKNAME = W_NICKNAME,
                CONTRASEÑA = W_CONTRASEÑA, 
                NOMBRE = W_NOMBRE,
                APELLIDOS = W_APELLIDOS,
                FECHA_NACIMIENTO = W_FECHA_NACIMIENTO,
                TELEFONO = W_TELEFONO,
                CORREO = W_CORREO
            WHERE DNI = W_DNI;
            
        SELECT * INTO TIPO_CLIENTE FROM CLIENTE WHERE DNI = W_DNI;
    
        IF (TIPO_CLIENTE.NICKNAME <> W_NICKNAME
            OR TIPO_CLIENTE.CONTRASEÑA <> W_CONTRASEÑA
            OR TIPO_CLIENTE.NOMBRE <> W_NOMBRE
            OR TIPO_CLIENTE.APELLIDOS <> W_APELLIDOS 
            OR TIPO_CLIENTE.FECHA_NACIMIENTO <> W_FECHA_NACIMIENTO
            OR TIPO_CLIENTE.TELEFONO <> W_TELEFONO
            OR TIPO_CLIENTE.CORREO <> W_CORREO ) THEN
            
            SALIDA := FALSE;
        END IF;
        COMMIT WORK;

        DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, SALIDA_ESPERADA));

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(FALSE, SALIDA_ESPERADA));
            ROLLBACK;
    END ACTUALIZAR;
    
     PROCEDURE ELIMINAR (   NOMBRE_PRUEBA VARCHAR2, 
                            W_DNI IN CLIENTE.DNI%TYPE, 
                            SALIDA_ESPERADA BOOLEAN) 
    AS
        SALIDA BOOLEAN := TRUE;
        N_CLIENTE INTEGER;
        
    BEGIN
        DELETE FROM CLIENTE WHERE DNI = W_DNI;
        
        SELECT COUNT(*) INTO N_CLIENTE FROM CLIENTE WHERE DNI = W_DNI;
        IF (N_CLIENTE <> 0) THEN
            SALIDA := FALSE;
        END IF;
        COMMIT WORK;

        DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, SALIDA_ESPERADA));

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(FALSE, SALIDA_ESPERADA));
            ROLLBACK;
    END ELIMINAR;
    
END PRUEBAS_CLIENTE;
/ 

/*PAQUETE PRUEBAS PROYECTO*/
CREATE OR REPLACE PACKAGE PRUEBAS_PROYECTO AS
    PROCEDURE INICIALIZAR;
    PROCEDURE INSERTAR( NOMBRE_PRUEBA VARCHAR2, 
                        W_NOMBRE IN PROYECTO.NOMBRE%TYPE,
                        W_DESCRIPCION IN PROYECTO.DESCRIPCION%TYPE,
                        W_FECHA_INICIO IN PROYECTO.FECHA_INICIO%TYPE,
                        W_FECHA_FINAL IN PROYECTO.FECHA_FINAL%TYPE,
                        W_VALORACION IN PROYECTO.VALORACION%TYPE,
                        W_DURACION IN PROYECTO.DURACION%TYPE,
                        W_NUMPLAZOS IN PROYECTO.NUMPLAZOS%TYPE,
                        W_ESTADO IN PROYECTO.ESTADO%TYPE,
                        W_PERMISO IN PROYECTO.PERMISO%TYPE,
                        W_OID_CLIENTE IN PROYECTO.OID_CLIENTE%TYPE,
                        W_OID_EMPLEADO IN PROYECTO.OID_EMPLEADO%TYPE,
                        SALIDA_ESPERADA BOOLEAN);
                        
    PROCEDURE ACTUALIZAR( NOMBRE_PRUEBA VARCHAR2, 
                          W_OID_PROYECTO IN PROYECTO.OID_PROYECTO%TYPE,
                          W_NOMBRE IN PROYECTO.NOMBRE%TYPE,
                          W_DESCRIPCION IN PROYECTO.DESCRIPCION%TYPE,
                          W_FECHA_INICIO IN PROYECTO.FECHA_INICIO%TYPE,
                          W_FECHA_FINAL IN PROYECTO.FECHA_FINAL%TYPE,
                          W_VALORACION IN PROYECTO.VALORACION%TYPE,
                          W_DURACION IN PROYECTO.DURACION%TYPE,
                          W_NUMPLAZOS IN PROYECTO.NUMPLAZOS%TYPE,
                          W_ESTADO IN PROYECTO.ESTADO%TYPE,
                          W_PERMISO IN PROYECTO.PERMISO%TYPE,
                          W_OID_CLIENTE IN PROYECTO.OID_CLIENTE%TYPE,
                          W_OID_EMPLEADO IN PROYECTO.OID_EMPLEADO%TYPE,
                          SALIDA_ESPERADA BOOLEAN);
                            
    PROCEDURE ELIMINAR (NOMBRE_PRUEBA VARCHAR2, 
                        W_OID_PROYECTO IN PROYECTO.OID_PROYECTO%TYPE, 
                        SALIDA_ESPERADA BOOLEAN);
END PRUEBAS_PROYECTO;


/

CREATE OR REPLACE PACKAGE BODY PRUEBAS_PROYECTO AS
    
    /* INICIALIZACIÓN */
    PROCEDURE INICIALIZAR AS
    BEGIN
    /* BORRAR CONTENIDO DE LA TABLA */
        DELETE FROM PROYECTO ;
    END INICIALIZAR;

    PROCEDURE INSERTAR (NOMBRE_PRUEBA VARCHAR2, 
                        W_NOMBRE IN PROYECTO.NOMBRE%TYPE,
                        W_DESCRIPCION IN PROYECTO.DESCRIPCION%TYPE,
                        W_FECHA_INICIO IN PROYECTO.FECHA_INICIO%TYPE,
                        W_FECHA_FINAL IN PROYECTO.FECHA_FINAL%TYPE,
                        W_VALORACION IN PROYECTO.VALORACION%TYPE,
                        W_DURACION IN PROYECTO.DURACION%TYPE,
                        W_NUMPLAZOS IN PROYECTO.NUMPLAZOS%TYPE,
                        W_ESTADO IN PROYECTO.ESTADO%TYPE,
                        W_PERMISO IN PROYECTO.PERMISO%TYPE,
                        W_OID_CLIENTE IN PROYECTO.OID_CLIENTE%TYPE,
                        W_OID_EMPLEADO IN PROYECTO.OID_EMPLEADO%TYPE,
                        SALIDA_ESPERADA BOOLEAN) 
    AS
        SALIDA BOOLEAN := TRUE;
        TIPO_PROYECTO PROYECTO%ROWTYPE;
        W_OID_PROYECTO PROYECTO.OID_PROYECTO%TYPE;
        
    BEGIN
        INSERT INTO PROYECTO (NOMBRE, DESCRIPCION, FECHA_INICIO, FECHA_FINAL, VALORACION, DURACION, NUMPLAZOS, ESTADO, PERMISO, OID_CLIENTE, OID_EMPLEADO) 
            VALUES (W_NOMBRE, W_DESCRIPCION, W_FECHA_INICIO, W_FECHA_FINAL, W_VALORACION, W_DURACION, W_NUMPLAZOS, W_ESTADO, W_PERMISO, W_OID_CLIENTE, W_OID_EMPLEADO);

        W_OID_PROYECTO := INCRE_OID_PROYECTO.CURRVAL;
        SELECT * INTO TIPO_PROYECTO FROM PROYECTO WHERE OID_PROYECTO = W_OID_PROYECTO;
        IF (TIPO_PROYECTO.OID_PROYECTO <> W_OID_PROYECTO) THEN
            SALIDA := FALSE;
        END IF;
        COMMIT WORK;

         DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, SALIDA_ESPERADA));

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(FALSE, SALIDA_ESPERADA));
            ROLLBACK;
    END INSERTAR;
    
    PROCEDURE ACTUALIZAR (  NOMBRE_PRUEBA VARCHAR2,
                        W_OID_PROYECTO IN PROYECTO.OID_PROYECTO%TYPE,
                        W_NOMBRE IN PROYECTO.NOMBRE%TYPE,
                        W_DESCRIPCION IN PROYECTO.DESCRIPCION%TYPE,
                        W_FECHA_INICIO IN PROYECTO.FECHA_INICIO%TYPE,
                        W_FECHA_FINAL IN PROYECTO.FECHA_FINAL%TYPE,
                        W_VALORACION IN PROYECTO.VALORACION%TYPE,
                        W_DURACION IN PROYECTO.DURACION%TYPE,
                        W_NUMPLAZOS IN PROYECTO.NUMPLAZOS%TYPE,
                        W_ESTADO IN PROYECTO.ESTADO%TYPE,
                        W_PERMISO IN PROYECTO.PERMISO%TYPE,
                        W_OID_CLIENTE IN PROYECTO.OID_CLIENTE%TYPE,
                        W_OID_EMPLEADO IN PROYECTO.OID_EMPLEADO%TYPE,
                            SALIDA_ESPERADA BOOLEAN) 
    AS
        SALIDA BOOLEAN := TRUE;
        TIPO_PROYECTO PROYECTO%ROWTYPE;
        
    BEGIN

        UPDATE PROYECTO
            SET NOMBRE = W_NOMBRE,
                DESCRIPCION = W_DESCRIPCION, 
                FECHA_INICIO = W_FECHA_INICIO,
                FECHA_FINAL = W_FECHA_FINAL,
                VALORACION = W_VALORACION,
                DURACION = W_DURACION,
                NUMPLAZOS = W_NUMPLAZOS,
                ESTADO = W_ESTADO,
                PERMISO = W_PERMISO,
                OID_CLIENTE = W_OID_CLIENTE,
                OID_EMPLEADO = W_OID_EMPLEADO
            WHERE OID_PROYECTO = W_OID_PROYECTO;
            
        SELECT * INTO TIPO_PROYECTO FROM PROYECTO WHERE OID_PROYECTO = W_OID_PROYECTO;
    
        IF (TIPO_PROYECTO.NOMBRE <> W_NOMBRE
            OR TIPO_PROYECTO.DESCRIPCION <> W_DESCRIPCION
            OR TIPO_PROYECTO.FECHA_INICIO <> W_FECHA_INICIO
            OR TIPO_PROYECTO.FECHA_FINAL <> W_FECHA_FINAL
            OR TIPO_PROYECTO.VALORACION <> W_VALORACION
            OR TIPO_PROYECTO.DURACION <> W_DURACION 
            OR TIPO_PROYECTO.NUMPLAZOS <> W_NUMPLAZOS
            OR TIPO_PROYECTO.OID_CLIENTE <> W_OID_CLIENTE
            OR TIPO_PROYECTO.OID_EMPLEADO <> W_OID_EMPLEADO) THEN
            
            SALIDA := FALSE;
        END IF;
        COMMIT WORK;

        DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, SALIDA_ESPERADA));

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(FALSE, SALIDA_ESPERADA));
            ROLLBACK;
    END ACTUALIZAR;
    
     PROCEDURE ELIMINAR (   NOMBRE_PRUEBA VARCHAR2, 
                            W_OID_PROYECTO IN PROYECTO.OID_PROYECTO%TYPE, 
                            SALIDA_ESPERADA BOOLEAN) 
    AS
        SALIDA BOOLEAN := TRUE;
        N_PROYECTO INTEGER;
        
    BEGIN
        DELETE FROM PROYECTO WHERE OID_PROYECTO = W_OID_PROYECTO;
        
        SELECT COUNT(*) INTO N_PROYECTO FROM PROYECTO WHERE OID_PROYECTO = W_OID_PROYECTO;
        IF (N_PROYECTO <> 0) THEN
            SALIDA := FALSE;
        END IF;
        COMMIT WORK;

        DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, SALIDA_ESPERADA));

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(FALSE, SALIDA_ESPERADA));
            ROLLBACK;
    END ELIMINAR;
    
END PRUEBAS_PROYECTO;
/ 

/*PAQUETE PRUEBAS MUEBLE*/
CREATE OR REPLACE PACKAGE PRUEBAS_MUEBLE AS
    PROCEDURE INICIALIZAR;
    PROCEDURE INSERTAR( NOMBRE_PRUEBA VARCHAR2, 
                        W_NOMBREMUEBLE IN MUEBLE.NOMBREMUEBLE%TYPE,
                        W_DESCRIPCION IN MUEBLE.DESCRIPCION%TYPE,
                        W_PRECIO IN MUEBLE.PRECIO%TYPE,
                        W_IMAGEN IN MUEBLE.IMAGEN%TYPE,
                        W_STOCK IN MUEBLE.STOCK%TYPE,
                        SALIDA_ESPERADA BOOLEAN);
                        
    PROCEDURE ACTUALIZAR( NOMBRE_PRUEBA VARCHAR2, 
                          W_OID_MUEBLE IN MUEBLE.OID_MUEBLE%TYPE,
                          W_NOMBREMUEBLE IN MUEBLE.NOMBREMUEBLE%TYPE,
                          W_DESCRIPCION IN MUEBLE.DESCRIPCION%TYPE,
                          W_PRECIO IN MUEBLE.PRECIO%TYPE,
                          W_IMAGEN IN MUEBLE.IMAGEN%TYPE,
                          W_STOCK IN MUEBLE.STOCK%TYPE,
                          SALIDA_ESPERADA BOOLEAN);
                            
    PROCEDURE ELIMINAR (NOMBRE_PRUEBA VARCHAR2, 
                        W_OID_MUEBLE IN MUEBLE.OID_MUEBLE%TYPE, 
                        SALIDA_ESPERADA BOOLEAN);
END PRUEBAS_MUEBLE;


/

CREATE OR REPLACE PACKAGE BODY PRUEBAS_MUEBLE AS
    
    /* INICIALIZACIÓN */
    PROCEDURE INICIALIZAR AS
    BEGIN
    /* BORRAR CONTENIDO DE LA TABLA */
        DELETE FROM MUEBLE ;
    END INICIALIZAR;

    PROCEDURE INSERTAR (NOMBRE_PRUEBA VARCHAR2, 
                        W_NOMBREMUEBLE IN MUEBLE.NOMBREMUEBLE%TYPE,
                        W_DESCRIPCION IN MUEBLE.DESCRIPCION%TYPE,
                        W_PRECIO IN MUEBLE.PRECIO%TYPE,
                        W_IMAGEN IN MUEBLE.IMAGEN%TYPE,
                        W_STOCK IN MUEBLE.STOCK%TYPE,
                        SALIDA_ESPERADA BOOLEAN) 
    AS
        SALIDA BOOLEAN := TRUE;
        TIPO_MUEBLE MUEBLE%ROWTYPE;
        W_OID_MUEBLE MUEBLE.OID_MUEBLE%TYPE;
        
    BEGIN
        INSERT INTO MUEBLE (NOMBREMUEBLE, DESCRIPCION, PRECIO, IMAGEN, STOCK) 
            VALUES (W_NOMBREMUEBLE, W_DESCRIPCION, W_PRECIO, W_IMAGEN, W_STOCK);

        W_OID_MUEBLE := INCRE_OID_MUEBLE.CURRVAL;
        SELECT * INTO TIPO_MUEBLE FROM MUEBLE WHERE OID_MUEBLE = W_OID_MUEBLE;
        IF (TIPO_MUEBLE.OID_MUEBLE <> W_OID_MUEBLE) THEN
            SALIDA := FALSE;
        END IF;
        COMMIT WORK;

         DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, SALIDA_ESPERADA));

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(FALSE, SALIDA_ESPERADA));
            ROLLBACK;
    END INSERTAR;
    
    PROCEDURE ACTUALIZAR (  NOMBRE_PRUEBA VARCHAR2,
                            W_OID_MUEBLE IN MUEBLE.OID_MUEBLE%TYPE,
                            W_NOMBREMUEBLE IN MUEBLE.NOMBREMUEBLE%TYPE,
                            W_DESCRIPCION IN MUEBLE.DESCRIPCION%TYPE,
                            W_PRECIO IN MUEBLE.PRECIO%TYPE,
                            W_IMAGEN IN MUEBLE.IMAGEN%TYPE,
                            W_STOCK IN MUEBLE.STOCK%TYPE,
                            SALIDA_ESPERADA BOOLEAN) 
    AS
        SALIDA BOOLEAN := TRUE;
        TIPO_MUEBLE MUEBLE%ROWTYPE;
        
    BEGIN

        UPDATE MUEBLE
            SET NOMBREMUEBLE = W_NOMBREMUEBLE,
                DESCRIPCION = W_DESCRIPCION,
                PRECIO = W_PRECIO,
                IMAGEN = W_IMAGEN,
                STOCK = W_STOCK                
            WHERE OID_MUEBLE = W_OID_MUEBLE;
            
        SELECT * INTO TIPO_MUEBLE FROM MUEBLE WHERE OID_MUEBLE = W_OID_MUEBLE;
    
        IF (TIPO_MUEBLE.NOMBREMUEBLE <> W_NOMBREMUEBLE
            OR TIPO_MUEBLE.DESCRIPCION <> W_DESCRIPCION
            OR TIPO_MUEBLE.PRECIO <> W_PRECIO
            OR TIPO_MUEBLE.IMAGEN <> W_IMAGEN
            OR TIPO_MUEBLE.STOCK <> W_STOCK ) THEN
            
            SALIDA := FALSE;
        END IF;
        COMMIT WORK;

        DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, SALIDA_ESPERADA));

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(FALSE, SALIDA_ESPERADA));
            ROLLBACK;
    END ACTUALIZAR;
    
     PROCEDURE ELIMINAR (   NOMBRE_PRUEBA VARCHAR2, 
                            W_OID_MUEBLE IN MUEBLE.OID_MUEBLE%TYPE, 
                            SALIDA_ESPERADA BOOLEAN) 
    AS
        SALIDA BOOLEAN := TRUE;
        N_MUEBLE INTEGER;
        
    BEGIN
        DELETE FROM MUEBLE WHERE OID_MUEBLE = W_OID_MUEBLE;
        
        SELECT COUNT(*) INTO N_MUEBLE FROM MUEBLE WHERE OID_MUEBLE = W_OID_MUEBLE;
        IF (N_MUEBLE <> 0) THEN
            SALIDA := FALSE;
        END IF;
        COMMIT WORK;

        DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(SALIDA, SALIDA_ESPERADA));

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(NOMBRE_PRUEBA || ': ' || ASSERT_EQUALS(FALSE, SALIDA_ESPERADA));
            ROLLBACK;
    END ELIMINAR;
    
END PRUEBAS_MUEBLE;
/ 