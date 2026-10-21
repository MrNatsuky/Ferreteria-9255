-- ================================================================================
-- FERRETERIA MR. NATSUKY'S - CREACION DEL USUARIO DE LA BASE DE DATOS
-- Curso: Base de Datos, seccion A - Ing. Kalki Ramirez
-- Alumno: Brandon Emmanuel Paz Alvarez - Carne 3190-24-9255
-- Ejecutar conectado como SYSTEM.
-- ================================================================================

-- Si el usuario ya existe y se quiere crear todo desde cero, quitar el comentario
-- de la siguiente linea y ejecutarla primero (borra el usuario con todas sus tablas):
-- DROP USER c##FERRETERIA_9255 CASCADE;

CREATE USER c##FERRETERIA_9255 IDENTIFIED BY Ferre9255;

GRANT CONNECT TO c##FERRETERIA_9255;
GRANT RESOURCE TO c##FERRETERIA_9255;
GRANT CREATE VIEW TO c##FERRETERIA_9255;
GRANT UNLIMITED TABLESPACE TO c##FERRETERIA_9255;

-- Despues de ejecutar este script, crear en SQL Developer una conexion nueva:
--   Usuario: c##FERRETERIA_9255   Contrasena: Ferre9255
-- y con esa conexion ejecutar 00_instalar_todo.sql
