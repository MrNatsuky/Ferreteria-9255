-- ================================================================================
-- FERRETERIA MR. NATSUKY'S - INSTALACION COMPLETA
-- Curso: Base de Datos, seccion A - Ing. Kalki Ramirez
-- Alumno: Brandon Emmanuel Paz Alvarez - Carne 3190-24-9255
--
-- PASOS:
--   1. Con la conexion de SYSTEM: ejecutar 01_crear_usuario.sql
--   2. Crear una conexion con el usuario c##FERRETERIA_9255 (contrasena Ferre9255)
--   3. Con esa conexion, abrir ESTE archivo y ejecutarlo con F5 (Ejecutar script).
--      Ejecuta en orden los archivos 02 al 06 de esta misma carpeta.
--   4. Con la conexion de SYSTEM: ejecutar 07_roles_seguridad.sql
-- ================================================================================

SET SERVEROUTPUT ON;
SET DEFINE OFF;

PROMPT ===== 02 Tablas =====
@@02_tablas.sql
PROMPT ===== 03 Funciones y procedimientos =====
@@03_funciones_procedimientos.sql
PROMPT ===== 04 Disparadores =====
@@04_disparadores.sql
PROMPT ===== 05 Vistas =====
@@05_vistas.sql
PROMPT ===== 06 Datos de prueba =====
@@06_datos_prueba.sql

PROMPT ===== Objetos con errores (debe salir vacio) =====
SELECT OBJECT_TYPE, OBJECT_NAME FROM USER_OBJECTS WHERE STATUS = 'INVALID';

PROMPT ===== Cantidad de registros =====
SELECT 'FACTURAS' AS TABLA, COUNT(*) AS REGISTROS FROM FACTURA_9255
UNION ALL SELECT 'PRODUCTOS VENDIDOS', COUNT(*) FROM DETALLE_FACTURA_9255
UNION ALL SELECT 'CLIENTES', COUNT(*) FROM CLIENTE_9255
UNION ALL SELECT 'MOVIMIENTOS DE INVENTARIO', COUNT(*) FROM MOVIMIENTO_INVENTARIO_9255
UNION ALL SELECT 'ENVIOS', COUNT(*) FROM ENVIO_9255
UNION ALL SELECT 'NOTAS DE CREDITO', COUNT(*) FROM NOTA_CREDITO_9255;
