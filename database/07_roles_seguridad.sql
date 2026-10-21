-- ================================================================================
-- FERRETERIA MR. NATSUKY'S - ROLES Y USUARIOS DE BASE DE DATOS
-- Curso: Base de Datos, seccion A - Ing. Kalki Ramirez
-- Alumno: Brandon Emmanuel Paz Alvarez - Carne 3190-24-9255
-- Ejecutar conectado como SYSTEM, despues de instalar todo lo demas.
--
-- Igual que en clase (Algebra.sql): se crean roles, se les dan permisos sobre las
-- tablas y se asignan a usuarios. Ademas de esto, la aplicacion web maneja sus
-- propios roles (tablas ROL_9255, OPCION_9255 y ROL_OPCION_9255).
-- ================================================================================

-- --------------------------------------------------------------------------------
-- 1. ROLES
-- --------------------------------------------------------------------------------
CREATE ROLE c##ROL_CONSULTA_FERRE_9255;   -- solo puede consultar (SELECT)
CREATE ROLE c##ROL_OPERADOR_FERRE_9255;   -- consulta, agrega y modifica (sin DELETE)

-- --------------------------------------------------------------------------------
-- 2. PERMISOS: se recorren todas las tablas y vistas del usuario c##FERRETERIA_9255
--    (en lugar de escribir un GRANT por cada una de las 40 tablas)
-- --------------------------------------------------------------------------------
BEGIN
    FOR T IN (SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER = 'C##FERRETERIA_9255') LOOP
        EXECUTE IMMEDIATE 'GRANT SELECT ON c##FERRETERIA_9255.' || T.TABLE_NAME || ' TO c##ROL_CONSULTA_FERRE_9255';
        EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE ON c##FERRETERIA_9255.' || T.TABLE_NAME || ' TO c##ROL_OPERADOR_FERRE_9255';
    END LOOP;
    FOR V IN (SELECT VIEW_NAME FROM ALL_VIEWS WHERE OWNER = 'C##FERRETERIA_9255') LOOP
        EXECUTE IMMEDIATE 'GRANT SELECT ON c##FERRETERIA_9255.' || V.VIEW_NAME || ' TO c##ROL_CONSULTA_FERRE_9255';
        EXECUTE IMMEDIATE 'GRANT SELECT ON c##FERRETERIA_9255.' || V.VIEW_NAME || ' TO c##ROL_OPERADOR_FERRE_9255';
    END LOOP;
END;
/

-- --------------------------------------------------------------------------------
-- 3. USUARIOS DE EJEMPLO
-- --------------------------------------------------------------------------------
CREATE USER c##GERENCIA_FERRE_9255 IDENTIFIED BY Gerencia9255;
GRANT CREATE SESSION TO c##GERENCIA_FERRE_9255;
GRANT c##ROL_CONSULTA_FERRE_9255 TO c##GERENCIA_FERRE_9255;

CREATE USER c##OPERADOR_FERRE_9255 IDENTIFIED BY Operador9255;
GRANT CREATE SESSION TO c##OPERADOR_FERRE_9255;
GRANT c##ROL_OPERADOR_FERRE_9255 TO c##OPERADOR_FERRE_9255;

-- Verificacion: roles asignados
SELECT GRANTEE, GRANTED_ROLE FROM DBA_ROLE_PRIVS WHERE GRANTED_ROLE LIKE 'C##ROL_%FERRE_9255';

-- Prueba: conectado como c##GERENCIA_FERRE_9255 se puede consultar...
--   SELECT * FROM c##FERRETERIA_9255.VW_FACTURAS_9255;
-- ...pero no modificar (da error de privilegios insuficientes):
--   UPDATE c##FERRETERIA_9255.PRODUCTO_9255 SET PRECIO_VENTA = 1 WHERE ID_PRODUCTO = 1;
