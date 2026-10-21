SET SERVEROUTPUT ON;
SET DEFINE OFF;

@@02_tablas.sql
@@03_funciones_procedimientos.sql
@@04_paquetes.sql
@@05_disparadores.sql
@@06_vistas.sql
@@07_datos_prueba.sql

SELECT OBJECT_TYPE, OBJECT_NAME FROM USER_OBJECTS WHERE STATUS = 'INVALID';
