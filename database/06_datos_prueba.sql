-- ================================================================================
-- FERRETERIA MR. NATSUKY'S - DATOS DE PRUEBA
-- Curso: Base de Datos, seccion A - Ing. Kalki Ramirez
-- Alumno: Brandon Emmanuel Paz Alvarez - Carne 3190-24-9255
-- Ejecutar conectado como c##FERRETERIA_9255, despues de 05_vistas.sql
-- Todos los datos son ficticios.
--
-- Como las tablas se acaban de crear, los IDs (IDENTITY) empiezan en 1 y siguen el
-- orden de los INSERT. Por eso mas abajo se usan numeros de ID directamente.
--
-- Usuarios de la aplicacion (contrasena de todos: Ferre9255*):
--   admin, gerente, compras, vendedor, cajero, bodega, transporte, vendedor.sv, vendedor.hn
-- ================================================================================

SET SERVEROUTPUT ON;
SET DEFINE OFF;

-- --------------------------------------------------------------------------------
-- PAISES (1 Guatemala, 2 El Salvador, 3 Honduras)
-- --------------------------------------------------------------------------------
INSERT INTO PAIS_9255 (CODIGO_ISO, NOMBRE, MONEDA_CODIGO, MONEDA_SIMBOLO, NOMBRE_IMPUESTO, PORCENTAJE_IMPUESTO, TIPO_CAMBIO_QUETZAL) VALUES ('GT', 'Guatemala', 'GTQ', 'Q', 'IVA', 12, 1);
INSERT INTO PAIS_9255 (CODIGO_ISO, NOMBRE, MONEDA_CODIGO, MONEDA_SIMBOLO, NOMBRE_IMPUESTO, PORCENTAJE_IMPUESTO, TIPO_CAMBIO_QUETZAL) VALUES ('SV', 'El Salvador', 'USD', '$', 'IVA', 13, 7.7);
INSERT INTO PAIS_9255 (CODIGO_ISO, NOMBRE, MONEDA_CODIGO, MONEDA_SIMBOLO, NOMBRE_IMPUESTO, PORCENTAJE_IMPUESTO, TIPO_CAMBIO_QUETZAL) VALUES ('HN', 'Honduras', 'HNL', 'L', 'ISV', 15, 0.3);

-- --------------------------------------------------------------------------------
-- REGIONES (1-4 Guatemala, 5-8 El Salvador, 9-12 Honduras)
-- --------------------------------------------------------------------------------
INSERT INTO REGION_9255 (ID_PAIS, NOMBRE) VALUES (1, 'NORTE');  -- region 1
INSERT INTO REGION_9255 (ID_PAIS, NOMBRE) VALUES (1, 'SUR');  -- region 2
INSERT INTO REGION_9255 (ID_PAIS, NOMBRE) VALUES (1, 'ORIENTE');  -- region 3
INSERT INTO REGION_9255 (ID_PAIS, NOMBRE) VALUES (1, 'OCCIDENTE');  -- region 4
INSERT INTO REGION_9255 (ID_PAIS, NOMBRE) VALUES (2, 'NORTE');  -- region 5
INSERT INTO REGION_9255 (ID_PAIS, NOMBRE) VALUES (2, 'SUR');  -- region 6
INSERT INTO REGION_9255 (ID_PAIS, NOMBRE) VALUES (2, 'ORIENTE');  -- region 7
INSERT INTO REGION_9255 (ID_PAIS, NOMBRE) VALUES (2, 'OCCIDENTE');  -- region 8
INSERT INTO REGION_9255 (ID_PAIS, NOMBRE) VALUES (3, 'NORTE');  -- region 9
INSERT INTO REGION_9255 (ID_PAIS, NOMBRE) VALUES (3, 'SUR');  -- region 10
INSERT INTO REGION_9255 (ID_PAIS, NOMBRE) VALUES (3, 'ORIENTE');  -- region 11
INSERT INTO REGION_9255 (ID_PAIS, NOMBRE) VALUES (3, 'OCCIDENTE');  -- region 12

-- --------------------------------------------------------------------------------
-- SUCURSALES (una por region, mismo numero que la region) Y BODEGAS (una por sucursal)
-- --------------------------------------------------------------------------------
INSERT INTO SUCURSAL_9255 (ID_REGION, CODIGO, NOMBRE, DIRECCION, TELEFONO, CORREO, FECHA_INICIO, SERIE_FACTURA) VALUES (1, 'GT-NOR', 'Mr. Natsuky''s Coban', '1a. Calle 4-35 Zona 1, Coban, Alta Verapaz', '7951-2040', 'gtnor@ferreterianatsuky.com', DATE '2016-02-15', 'GNO');  -- sucursal 1
INSERT INTO SUCURSAL_9255 (ID_REGION, CODIGO, NOMBRE, DIRECCION, TELEFONO, CORREO, FECHA_INICIO, SERIE_FACTURA) VALUES (2, 'GT-SUR', 'Mr. Natsuky''s Escuintla', '4a. Avenida 6-12 Zona 1, Escuintla', '7888-1520', 'gtsur@ferreterianatsuky.com', DATE '2015-06-01', 'GSU');  -- sucursal 2
INSERT INTO SUCURSAL_9255 (ID_REGION, CODIGO, NOMBRE, DIRECCION, TELEFONO, CORREO, FECHA_INICIO, SERIE_FACTURA) VALUES (3, 'GT-ORI', 'Mr. Natsuky''s Zacapa', '3a. Calle 10-45 Zona 2, Zacapa', '7941-3355', 'gtori@ferreterianatsuky.com', DATE '2017-09-10', 'GOR');  -- sucursal 3
INSERT INTO SUCURSAL_9255 (ID_REGION, CODIGO, NOMBRE, DIRECCION, TELEFONO, CORREO, FECHA_INICIO, SERIE_FACTURA) VALUES (4, 'GT-OCC', 'Mr. Natsuky''s Quetzaltenango', '14 Avenida 3-28 Zona 3, Quetzaltenango', '7763-8820', 'gtocc@ferreterianatsuky.com', DATE '2014-11-20', 'GOC');  -- sucursal 4
INSERT INTO SUCURSAL_9255 (ID_REGION, CODIGO, NOMBRE, DIRECCION, TELEFONO, CORREO, FECHA_INICIO, SERIE_FACTURA) VALUES (5, 'SV-NOR', 'Mr. Natsuky''s Chalatenango', 'Barrio El Centro, 2a. Calle Poniente, Chalatenango', '2301-4410', 'svnor@ferreterianatsuky.com', DATE '2019-03-01', 'SNO');  -- sucursal 5
INSERT INTO SUCURSAL_9255 (ID_REGION, CODIGO, NOMBRE, DIRECCION, TELEFONO, CORREO, FECHA_INICIO, SERIE_FACTURA) VALUES (6, 'SV-SUR', 'Mr. Natsuky''s Zacatecoluca', 'Avenida Narciso Monterrey 15, Zacatecoluca', '2334-1290', 'svsur@ferreterianatsuky.com', DATE '2020-01-20', 'SSU');  -- sucursal 6
INSERT INTO SUCURSAL_9255 (ID_REGION, CODIGO, NOMBRE, DIRECCION, TELEFONO, CORREO, FECHA_INICIO, SERIE_FACTURA) VALUES (7, 'SV-ORI', 'Mr. Natsuky''s San Miguel', 'Avenida Roosevelt Sur 210, San Miguel', '2661-7730', 'svori@ferreterianatsuky.com', DATE '2018-05-05', 'SOR');  -- sucursal 7
INSERT INTO SUCURSAL_9255 (ID_REGION, CODIGO, NOMBRE, DIRECCION, TELEFONO, CORREO, FECHA_INICIO, SERIE_FACTURA) VALUES (8, 'SV-OCC', 'Mr. Natsuky''s Santa Ana', 'Calle Libertad Oriente 8, Santa Ana', '2447-6620', 'svocc@ferreterianatsuky.com', DATE '2018-08-18', 'SOC');  -- sucursal 8
INSERT INTO SUCURSAL_9255 (ID_REGION, CODIGO, NOMBRE, DIRECCION, TELEFONO, CORREO, FECHA_INICIO, SERIE_FACTURA) VALUES (9, 'HN-NOR', 'Mr. Natsuky''s San Pedro Sula', 'Barrio Guamilito, 6 Avenida NO, San Pedro Sula', '2552-9010', 'hnnor@ferreterianatsuky.com', DATE '2017-04-04', 'HNO');  -- sucursal 9
INSERT INTO SUCURSAL_9255 (ID_REGION, CODIGO, NOMBRE, DIRECCION, TELEFONO, CORREO, FECHA_INICIO, SERIE_FACTURA) VALUES (10, 'HN-SUR', 'Mr. Natsuky''s Choluteca', 'Barrio El Centro, Calle Real, Choluteca', '2782-3145', 'hnsur@ferreterianatsuky.com', DATE '2021-02-11', 'HSU');  -- sucursal 10
INSERT INTO SUCURSAL_9255 (ID_REGION, CODIGO, NOMBRE, DIRECCION, TELEFONO, CORREO, FECHA_INICIO, SERIE_FACTURA) VALUES (11, 'HN-ORI', 'Mr. Natsuky''s Juticalpa', 'Barrio El Centro, Juticalpa, Olancho', '2785-4470', 'hnori@ferreterianatsuky.com', DATE '2021-07-07', 'HOR');  -- sucursal 11
INSERT INTO SUCURSAL_9255 (ID_REGION, CODIGO, NOMBRE, DIRECCION, TELEFONO, CORREO, FECHA_INICIO, SERIE_FACTURA) VALUES (12, 'HN-OCC', 'Mr. Natsuky''s Santa Rosa de Copan', 'Barrio Mercedes, Santa Rosa de Copan', '2662-0815', 'hnocc@ferreterianatsuky.com', DATE '2019-10-30', 'HOC');  -- sucursal 12

INSERT INTO BODEGA_9255 (ID_SUCURSAL, NOMBRE, DESCRIPCION) VALUES (1, 'Bodega principal', 'Bodega de Mr. Natsuky''s Coban');  -- bodega 1
INSERT INTO BODEGA_9255 (ID_SUCURSAL, NOMBRE, DESCRIPCION) VALUES (2, 'Bodega principal', 'Bodega de Mr. Natsuky''s Escuintla');  -- bodega 2
INSERT INTO BODEGA_9255 (ID_SUCURSAL, NOMBRE, DESCRIPCION) VALUES (3, 'Bodega principal', 'Bodega de Mr. Natsuky''s Zacapa');  -- bodega 3
INSERT INTO BODEGA_9255 (ID_SUCURSAL, NOMBRE, DESCRIPCION) VALUES (4, 'Bodega principal', 'Bodega de Mr. Natsuky''s Quetzaltenango');  -- bodega 4
INSERT INTO BODEGA_9255 (ID_SUCURSAL, NOMBRE, DESCRIPCION) VALUES (5, 'Bodega principal', 'Bodega de Mr. Natsuky''s Chalatenango');  -- bodega 5
INSERT INTO BODEGA_9255 (ID_SUCURSAL, NOMBRE, DESCRIPCION) VALUES (6, 'Bodega principal', 'Bodega de Mr. Natsuky''s Zacatecoluca');  -- bodega 6
INSERT INTO BODEGA_9255 (ID_SUCURSAL, NOMBRE, DESCRIPCION) VALUES (7, 'Bodega principal', 'Bodega de Mr. Natsuky''s San Miguel');  -- bodega 7
INSERT INTO BODEGA_9255 (ID_SUCURSAL, NOMBRE, DESCRIPCION) VALUES (8, 'Bodega principal', 'Bodega de Mr. Natsuky''s Santa Ana');  -- bodega 8
INSERT INTO BODEGA_9255 (ID_SUCURSAL, NOMBRE, DESCRIPCION) VALUES (9, 'Bodega principal', 'Bodega de Mr. Natsuky''s San Pedro Sula');  -- bodega 9
INSERT INTO BODEGA_9255 (ID_SUCURSAL, NOMBRE, DESCRIPCION) VALUES (10, 'Bodega principal', 'Bodega de Mr. Natsuky''s Choluteca');  -- bodega 10
INSERT INTO BODEGA_9255 (ID_SUCURSAL, NOMBRE, DESCRIPCION) VALUES (11, 'Bodega principal', 'Bodega de Mr. Natsuky''s Juticalpa');  -- bodega 11
INSERT INTO BODEGA_9255 (ID_SUCURSAL, NOMBRE, DESCRIPCION) VALUES (12, 'Bodega principal', 'Bodega de Mr. Natsuky''s Santa Rosa de Copan');  -- bodega 12

-- --------------------------------------------------------------------------------
-- PUESTOS
-- --------------------------------------------------------------------------------
INSERT INTO PUESTO_9255 (NOMBRE, DESCRIPCION) VALUES ('Administrador de sistemas', 'Administra usuarios, permisos y catalogos del sistema.');  -- puesto 1
INSERT INTO PUESTO_9255 (NOMBRE, DESCRIPCION) VALUES ('Gerente general', 'Dirige la operacion de toda la cadena.');  -- puesto 2
INSERT INTO PUESTO_9255 (NOMBRE, DESCRIPCION) VALUES ('Gerente de sucursal', 'Dirige una sucursal y autoriza bajas y notas de credito.');  -- puesto 3
INSERT INTO PUESTO_9255 (NOMBRE, DESCRIPCION) VALUES ('Vendedor', 'Atiende clientes y emite facturas.');  -- puesto 4
INSERT INTO PUESTO_9255 (NOMBRE, DESCRIPCION) VALUES ('Cajero', 'Recibe pagos y da seguimiento a creditos.');  -- puesto 5
INSERT INTO PUESTO_9255 (NOMBRE, DESCRIPCION) VALUES ('Bodeguero', 'Controla ingresos, salidas y existencias de bodega.');  -- puesto 6
INSERT INTO PUESTO_9255 (NOMBRE, DESCRIPCION) VALUES ('Encargado de compras', 'Gestiona proveedores y ordenes de compra.');  -- puesto 7
INSERT INTO PUESTO_9255 (NOMBRE, DESCRIPCION) VALUES ('Encargado de transporte', 'Programa y supervisa los envios de la sucursal.');  -- puesto 8
INSERT INTO PUESTO_9255 (NOMBRE, DESCRIPCION) VALUES ('Piloto', 'Conduce los vehiculos de reparto.');  -- puesto 9

-- --------------------------------------------------------------------------------
-- EMPLEADOS
-- 1 a 3: personal central (administrador, gerente general, compras) en la sucursal 1.
-- Luego 7 por sucursal, en este orden: gerente, vendedor, vendedor, cajero,
-- bodeguero, encargado de transporte y piloto.
-- Para la sucursal S el primer empleado es el ID 4 + (S - 1) * 7.
-- --------------------------------------------------------------------------------
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (1, 1, 'EMP-0001', 'Lucia', 'Hernandez Estrada', '1000007654321', '50004973', 'lucia.hernandez1@ferreterianatsuky.com', DATE '2019-02-13');  -- empleado 1
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (1, 2, 'EMP-0002', 'Ricardo', 'Rodriguez Garcia', '1000015308642', '50009946', 'ricardo.rodriguez2@ferreterianatsuky.com', DATE '2019-03-22');  -- empleado 2
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (1, 7, 'EMP-0003', 'Silvia', 'Ramirez Flores', '1000022962963', '50014919', 'silvia.ramirez3@ferreterianatsuky.com', DATE '2019-04-28');  -- empleado 3
-- sucursal 1
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (1, 3, 'EMP-0004', 'Julio', 'Reyes Mejia', '1000030617284', '50019892', 'julio.reyes4@ferreterianatsuky.com', DATE '2019-06-04');  -- empleado 4
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (1, 4, 'EMP-0005', 'Sofia', 'Ortiz Alvarado', '1000038271605', '50024865', 'sofia.ortiz5@ferreterianatsuky.com', DATE '2019-07-11');  -- empleado 5
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (1, 4, 'EMP-0006', 'Fernando', 'Estrada Molina', '1000045925926', '50029838', 'fernando.estrada6@ferreterianatsuky.com', DATE '2019-08-17');  -- empleado 6
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (1, 5, 'EMP-0007', 'Alejandra', 'Aguilar Rodriguez', '1000053580247', '50034811', 'alejandra.aguilar7@ferreterianatsuky.com', DATE '2019-09-23');  -- empleado 7
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (1, 6, 'EMP-0008', 'Raul', 'Orellana Barrios', '1000061234568', '50039784', 'raul.orellana8@ferreterianatsuky.com', DATE '2019-10-30');  -- empleado 8
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (1, 8, 'EMP-0009', 'Ana', 'Mejia Martinez', '1000068888889', '50044757', 'ana.mejia9@ferreterianatsuky.com', DATE '2019-12-06');  -- empleado 9
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (1, 9, 'EMP-0010', 'Pedro', 'Lopez Ortiz', '1000076543210', '50049730', 'pedro.lopez10@ferreterianatsuky.com', DATE '2020-01-12');  -- empleado 10
-- sucursal 2
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (2, 3, 'EMP-0011', 'Karla', 'Hernandez Fuentes', '1000084197531', '50054703', 'karla.hernandez11@ferreterianatsuky.com', DATE '2020-02-18');  -- empleado 11
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (2, 4, 'EMP-0012', 'Hugo', 'Rodriguez Mendez', '1000091851852', '50059676', 'hugo.rodriguez12@ferreterianatsuky.com', DATE '2020-03-26');  -- empleado 12
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (2, 4, 'EMP-0013', 'Maria', 'Ramirez Orellana', '1000099506173', '50064649', 'maria.ramirez13@ferreterianatsuky.com', DATE '2020-05-02');  -- empleado 13
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (2, 5, 'EMP-0014', 'Miguel', 'Reyes Morales', '1000107160494', '50069622', 'miguel.reyes14@ferreterianatsuky.com', DATE '2020-06-08');  -- empleado 14
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (2, 6, 'EMP-0015', 'Paola', 'Ortiz Rivera', '1000114814815', '50074595', 'paola.ortiz15@ferreterianatsuky.com', DATE '2020-07-15');  -- empleado 15
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (2, 8, 'EMP-0016', 'Edgar', 'Estrada Hernandez', '1000122469136', '50079568', 'edgar.estrada16@ferreterianatsuky.com', DATE '2020-08-21');  -- empleado 16
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (2, 9, 'EMP-0017', 'Rosa', 'Aguilar Juarez', '1000130123457', '50084541', 'rosa.aguilar17@ferreterianatsuky.com', DATE '2020-09-27');  -- empleado 17
-- sucursal 3
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (3, 3, 'EMP-0018', 'Jorge', 'Orellana Sandoval', '1000137777778', '50089514', 'jorge.orellana18@ferreterianatsuky.com', DATE '2020-11-03');  -- empleado 18
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (3, 4, 'EMP-0019', 'Daniela', 'Mejia Reyes', '1000145432099', '50094487', 'daniela.mejia19@ferreterianatsuky.com', DATE '2020-12-10');  -- empleado 19
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (3, 4, 'EMP-0020', 'Roberto', 'Lopez Portillo', '1000153086420', '50099460', 'roberto.lopez20@ferreterianatsuky.com', DATE '2021-01-16');  -- empleado 20
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (3, 5, 'EMP-0021', 'Patricia', 'Hernandez Castillo', '1000160740741', '50104433', 'patricia.hernandez21@ferreterianatsuky.com', DATE '2021-02-22');  -- empleado 21
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (3, 6, 'EMP-0022', 'Luis', 'Rodriguez Aguilar', '1000168395062', '50109406', 'luis.rodriguez22@ferreterianatsuky.com', DATE '2021-03-31');  -- empleado 22
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (3, 8, 'EMP-0023', 'Gabriela', 'Ramirez Perez', '1000176049383', '50114379', 'gabriela.ramirez23@ferreterianatsuky.com', DATE '2021-05-07');  -- empleado 23
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (3, 9, 'EMP-0024', 'Oscar', 'Reyes Velasquez', '1000183703704', '50119352', 'oscar.reyes24@ferreterianatsuky.com', DATE '2021-06-13');  -- empleado 24
-- sucursal 4
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (4, 3, 'EMP-0025', 'Marta', 'Ortiz Lopez', '1000191358025', '50124325', 'marta.ortiz25@ferreterianatsuky.com', DATE '2021-07-20');  -- empleado 25
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (4, 4, 'EMP-0026', 'Jose', 'Estrada Cruz', '1000199012346', '50129298', 'jose.estrada26@ferreterianatsuky.com', DATE '2021-08-26');  -- empleado 26
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (4, 4, 'EMP-0027', 'Andrea', 'Aguilar Zelaya', '1000206666667', '50134271', 'andrea.aguilar27@ferreterianatsuky.com', DATE '2021-10-02');  -- empleado 27
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (4, 5, 'EMP-0028', 'Mario', 'Orellana Ramirez', '1000214320988', '50139244', 'mario.orellana28@ferreterianatsuky.com', DATE '2021-11-08');  -- empleado 28
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (4, 6, 'EMP-0029', 'Claudia', 'Mejia Chavez', '1000221975309', '50144217', 'claudia.mejia29@ferreterianatsuky.com', DATE '2021-12-15');  -- empleado 29
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (4, 8, 'EMP-0030', 'Carlos', 'Lopez Gonzalez', '1000229629630', '50149190', 'carlos.lopez30@ferreterianatsuky.com', DATE '2022-01-21');  -- empleado 30
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (4, 9, 'EMP-0031', 'Lucia', 'Hernandez Estrada', '1000237283951', '50154163', 'lucia.hernandez31@ferreterianatsuky.com', DATE '2022-02-27');  -- empleado 31
-- sucursal 5
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (5, 3, 'EMP-0032', 'Ricardo', 'Rodriguez Garcia', '39506144-2', '70159136', 'ricardo.rodriguez32@ferreterianatsuky.com', DATE '2022-04-05');  -- empleado 32
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (5, 4, 'EMP-0033', 'Silvia', 'Ramirez Flores', '40740711-3', '70164109', 'silvia.ramirez33@ferreterianatsuky.com', DATE '2022-05-12');  -- empleado 33
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (5, 4, 'EMP-0034', 'Julio', 'Reyes Mejia', '41975278-4', '70169082', 'julio.reyes34@ferreterianatsuky.com', DATE '2022-06-18');  -- empleado 34
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (5, 5, 'EMP-0035', 'Sofia', 'Ortiz Alvarado', '43209845-5', '70174055', 'sofia.ortiz35@ferreterianatsuky.com', DATE '2022-07-25');  -- empleado 35
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (5, 6, 'EMP-0036', 'Fernando', 'Estrada Molina', '44444412-6', '70179028', 'fernando.estrada36@ferreterianatsuky.com', DATE '2022-08-31');  -- empleado 36
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (5, 8, 'EMP-0037', 'Alejandra', 'Aguilar Rodriguez', '45678979-7', '70184001', 'alejandra.aguilar37@ferreterianatsuky.com', DATE '2022-10-07');  -- empleado 37
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (5, 9, 'EMP-0038', 'Raul', 'Orellana Barrios', '46913546-8', '70188974', 'raul.orellana38@ferreterianatsuky.com', DATE '2022-11-13');  -- empleado 38
-- sucursal 6
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (6, 3, 'EMP-0039', 'Ana', 'Mejia Martinez', '48148113-9', '70193947', 'ana.mejia39@ferreterianatsuky.com', DATE '2022-12-20');  -- empleado 39
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (6, 4, 'EMP-0040', 'Pedro', 'Lopez Ortiz', '49382680-0', '70198920', 'pedro.lopez40@ferreterianatsuky.com', DATE '2023-01-26');  -- empleado 40
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (6, 4, 'EMP-0041', 'Karla', 'Hernandez Fuentes', '50617247-1', '70203893', 'karla.hernandez41@ferreterianatsuky.com', DATE '2023-03-04');  -- empleado 41
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (6, 5, 'EMP-0042', 'Hugo', 'Rodriguez Mendez', '51851814-2', '70208866', 'hugo.rodriguez42@ferreterianatsuky.com', DATE '2023-04-10');  -- empleado 42
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (6, 6, 'EMP-0043', 'Maria', 'Ramirez Orellana', '53086381-3', '70213839', 'maria.ramirez43@ferreterianatsuky.com', DATE '2023-05-17');  -- empleado 43
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (6, 8, 'EMP-0044', 'Miguel', 'Reyes Morales', '54320948-4', '70218812', 'miguel.reyes44@ferreterianatsuky.com', DATE '2023-06-23');  -- empleado 44
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (6, 9, 'EMP-0045', 'Paola', 'Ortiz Rivera', '55555515-5', '70223785', 'paola.ortiz45@ferreterianatsuky.com', DATE '2023-07-30');  -- empleado 45
-- sucursal 7
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (7, 3, 'EMP-0046', 'Edgar', 'Estrada Hernandez', '56790082-6', '70228758', 'edgar.estrada46@ferreterianatsuky.com', DATE '2023-09-05');  -- empleado 46
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (7, 4, 'EMP-0047', 'Rosa', 'Aguilar Juarez', '58024649-7', '70233731', 'rosa.aguilar47@ferreterianatsuky.com', DATE '2023-10-12');  -- empleado 47
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (7, 4, 'EMP-0048', 'Jorge', 'Orellana Sandoval', '59259216-8', '70238704', 'jorge.orellana48@ferreterianatsuky.com', DATE '2023-11-18');  -- empleado 48
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (7, 5, 'EMP-0049', 'Daniela', 'Mejia Reyes', '60493783-9', '70243677', 'daniela.mejia49@ferreterianatsuky.com', DATE '2019-01-20');  -- empleado 49
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (7, 6, 'EMP-0050', 'Roberto', 'Lopez Portillo', '61728350-0', '70248650', 'roberto.lopez50@ferreterianatsuky.com', DATE '2019-02-26');  -- empleado 50
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (7, 8, 'EMP-0051', 'Patricia', 'Hernandez Castillo', '62962917-1', '70253623', 'patricia.hernandez51@ferreterianatsuky.com', DATE '2019-04-04');  -- empleado 51
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (7, 9, 'EMP-0052', 'Luis', 'Rodriguez Aguilar', '64197484-2', '70258596', 'luis.rodriguez52@ferreterianatsuky.com', DATE '2019-05-11');  -- empleado 52
-- sucursal 8
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (8, 3, 'EMP-0053', 'Gabriela', 'Ramirez Perez', '65432051-3', '70263569', 'gabriela.ramirez53@ferreterianatsuky.com', DATE '2019-06-17');  -- empleado 53
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (8, 4, 'EMP-0054', 'Oscar', 'Reyes Velasquez', '66666618-4', '70268542', 'oscar.reyes54@ferreterianatsuky.com', DATE '2019-07-24');  -- empleado 54
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (8, 4, 'EMP-0055', 'Marta', 'Ortiz Lopez', '67901185-5', '70273515', 'marta.ortiz55@ferreterianatsuky.com', DATE '2019-08-30');  -- empleado 55
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (8, 5, 'EMP-0056', 'Jose', 'Estrada Cruz', '69135752-6', '70278488', 'jose.estrada56@ferreterianatsuky.com', DATE '2019-10-06');  -- empleado 56
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (8, 6, 'EMP-0057', 'Andrea', 'Aguilar Zelaya', '70370319-7', '70283461', 'andrea.aguilar57@ferreterianatsuky.com', DATE '2019-11-12');  -- empleado 57
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (8, 8, 'EMP-0058', 'Mario', 'Orellana Ramirez', '71604886-8', '70288434', 'mario.orellana58@ferreterianatsuky.com', DATE '2019-12-19');  -- empleado 58
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (8, 9, 'EMP-0059', 'Claudia', 'Mejia Chavez', '72839453-9', '70293407', 'claudia.mejia59@ferreterianatsuky.com', DATE '2020-01-25');  -- empleado 59
-- sucursal 9
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (9, 3, 'EMP-0060', 'Carlos', 'Lopez Gonzalez', '1000459259260', '70298380', 'carlos.lopez60@ferreterianatsuky.com', DATE '2020-03-02');  -- empleado 60
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (9, 4, 'EMP-0061', 'Lucia', 'Hernandez Estrada', '1000466913581', '70303353', 'lucia.hernandez61@ferreterianatsuky.com', DATE '2020-04-08');  -- empleado 61
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (9, 4, 'EMP-0062', 'Ricardo', 'Rodriguez Garcia', '1000474567902', '70308326', 'ricardo.rodriguez62@ferreterianatsuky.com', DATE '2020-05-15');  -- empleado 62
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (9, 5, 'EMP-0063', 'Silvia', 'Ramirez Flores', '1000482222223', '70313299', 'silvia.ramirez63@ferreterianatsuky.com', DATE '2020-06-21');  -- empleado 63
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (9, 6, 'EMP-0064', 'Julio', 'Reyes Mejia', '1000489876544', '70318272', 'julio.reyes64@ferreterianatsuky.com', DATE '2020-07-28');  -- empleado 64
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (9, 8, 'EMP-0065', 'Sofia', 'Ortiz Alvarado', '1000497530865', '70323245', 'sofia.ortiz65@ferreterianatsuky.com', DATE '2020-09-03');  -- empleado 65
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (9, 9, 'EMP-0066', 'Fernando', 'Estrada Molina', '1000505185186', '70328218', 'fernando.estrada66@ferreterianatsuky.com', DATE '2020-10-10');  -- empleado 66
-- sucursal 10
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (10, 3, 'EMP-0067', 'Alejandra', 'Aguilar Rodriguez', '1000512839507', '70333191', 'alejandra.aguilar67@ferreterianatsuky.com', DATE '2020-11-16');  -- empleado 67
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (10, 4, 'EMP-0068', 'Raul', 'Orellana Barrios', '1000520493828', '70338164', 'raul.orellana68@ferreterianatsuky.com', DATE '2020-12-23');  -- empleado 68
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (10, 4, 'EMP-0069', 'Ana', 'Mejia Martinez', '1000528148149', '70343137', 'ana.mejia69@ferreterianatsuky.com', DATE '2021-01-29');  -- empleado 69
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (10, 5, 'EMP-0070', 'Pedro', 'Lopez Ortiz', '1000535802470', '70348110', 'pedro.lopez70@ferreterianatsuky.com', DATE '2021-03-07');  -- empleado 70
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (10, 6, 'EMP-0071', 'Karla', 'Hernandez Fuentes', '1000543456791', '70353083', 'karla.hernandez71@ferreterianatsuky.com', DATE '2021-04-13');  -- empleado 71
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (10, 8, 'EMP-0072', 'Hugo', 'Rodriguez Mendez', '1000551111112', '70358056', 'hugo.rodriguez72@ferreterianatsuky.com', DATE '2021-05-20');  -- empleado 72
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (10, 9, 'EMP-0073', 'Maria', 'Ramirez Orellana', '1000558765433', '70363029', 'maria.ramirez73@ferreterianatsuky.com', DATE '2021-06-26');  -- empleado 73
-- sucursal 11
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (11, 3, 'EMP-0074', 'Miguel', 'Reyes Morales', '1000566419754', '70368002', 'miguel.reyes74@ferreterianatsuky.com', DATE '2021-08-02');  -- empleado 74
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (11, 4, 'EMP-0075', 'Paola', 'Ortiz Rivera', '1000574074075', '70372975', 'paola.ortiz75@ferreterianatsuky.com', DATE '2021-09-08');  -- empleado 75
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (11, 4, 'EMP-0076', 'Edgar', 'Estrada Hernandez', '1000581728396', '70377948', 'edgar.estrada76@ferreterianatsuky.com', DATE '2021-10-15');  -- empleado 76
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (11, 5, 'EMP-0077', 'Rosa', 'Aguilar Juarez', '1000589382717', '70382921', 'rosa.aguilar77@ferreterianatsuky.com', DATE '2021-11-21');  -- empleado 77
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (11, 6, 'EMP-0078', 'Jorge', 'Orellana Sandoval', '1000597037038', '70387894', 'jorge.orellana78@ferreterianatsuky.com', DATE '2021-12-28');  -- empleado 78
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (11, 8, 'EMP-0079', 'Daniela', 'Mejia Reyes', '1000604691359', '70392867', 'daniela.mejia79@ferreterianatsuky.com', DATE '2022-02-03');  -- empleado 79
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (11, 9, 'EMP-0080', 'Roberto', 'Lopez Portillo', '1000612345680', '70397840', 'roberto.lopez80@ferreterianatsuky.com', DATE '2022-03-12');  -- empleado 80
-- sucursal 12
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (12, 3, 'EMP-0081', 'Patricia', 'Hernandez Castillo', '1000620000001', '70402813', 'patricia.hernandez81@ferreterianatsuky.com', DATE '2022-04-18');  -- empleado 81
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (12, 4, 'EMP-0082', 'Luis', 'Rodriguez Aguilar', '1000627654322', '70407786', 'luis.rodriguez82@ferreterianatsuky.com', DATE '2022-05-25');  -- empleado 82
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (12, 4, 'EMP-0083', 'Gabriela', 'Ramirez Perez', '1000635308643', '70412759', 'gabriela.ramirez83@ferreterianatsuky.com', DATE '2022-07-01');  -- empleado 83
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (12, 5, 'EMP-0084', 'Oscar', 'Reyes Velasquez', '1000642962964', '70417732', 'oscar.reyes84@ferreterianatsuky.com', DATE '2022-08-07');  -- empleado 84
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (12, 6, 'EMP-0085', 'Marta', 'Ortiz Lopez', '1000650617285', '70422705', 'marta.ortiz85@ferreterianatsuky.com', DATE '2022-09-13');  -- empleado 85
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (12, 8, 'EMP-0086', 'Jose', 'Estrada Cruz', '1000658271606', '70427678', 'jose.estrada86@ferreterianatsuky.com', DATE '2022-10-20');  -- empleado 86
INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, ID_PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD, TELEFONO, CORREO, FECHA_INICIO) VALUES (12, 9, 'EMP-0087', 'Andrea', 'Aguilar Zelaya', '1000665925927', '70432651', 'andrea.aguilar87@ferreterianatsuky.com', DATE '2022-11-26');  -- empleado 87

-- --------------------------------------------------------------------------------
-- ROLES (1 ADMINISTRADOR ... 7 TRANSPORTE)
-- --------------------------------------------------------------------------------
INSERT INTO ROL_9255 (NOMBRE, DESCRIPCION) VALUES ('ADMINISTRADOR', 'Acceso total al sistema.');  -- rol 1
INSERT INTO ROL_9255 (NOMBRE, DESCRIPCION) VALUES ('GERENTE', 'Consulta toda la informacion y los reportes gerenciales; autoriza bajas y notas de credito.');  -- rol 2
INSERT INTO ROL_9255 (NOMBRE, DESCRIPCION) VALUES ('VENDEDOR', 'Clientes, facturacion, devoluciones, garantias y solicitudes de envio.');  -- rol 3
INSERT INTO ROL_9255 (NOMBRE, DESCRIPCION) VALUES ('CAJERO', 'Pagos, abonos de clientes y pagos a proveedores.');  -- rol 4
INSERT INTO ROL_9255 (NOMBRE, DESCRIPCION) VALUES ('BODEGUERO', 'Ingresos, salidas, traslados y bajas de inventario.');  -- rol 5
INSERT INTO ROL_9255 (NOMBRE, DESCRIPCION) VALUES ('COMPRAS', 'Proveedores, productos y ordenes de compra.');  -- rol 6
INSERT INTO ROL_9255 (NOMBRE, DESCRIPCION) VALUES ('TRANSPORTE', 'Vehiculos, pilotos y envios.');  -- rol 7

-- --------------------------------------------------------------------------------
-- OPCIONES DEL MENU DE LA APLICACION
-- --------------------------------------------------------------------------------
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('TABLERO', 'Tablero', 'Inicio', '/', 10);  -- opcion 1
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('USUARIOS', 'Usuarios', 'Seguridad', '/usuarios', 20);  -- opcion 2
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('ROLES', 'Roles y permisos', 'Seguridad', '/roles', 30);  -- opcion 3
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('BITACORA', 'Bitacora', 'Seguridad', '/bitacora', 40);  -- opcion 4
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('PAISES', 'Paises', 'Estructura', '/paises', 50);  -- opcion 5
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('REGIONES', 'Regiones', 'Estructura', '/regiones', 60);  -- opcion 6
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('SUCURSALES', 'Sucursales', 'Estructura', '/sucursales', 70);  -- opcion 7
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('BODEGAS', 'Bodegas', 'Estructura', '/bodegas', 80);  -- opcion 8
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('PUESTOS', 'Puestos', 'Estructura', '/puestos', 90);  -- opcion 9
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('EMPLEADOS', 'Empleados', 'Estructura', '/empleados', 100);  -- opcion 10
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('CATEGORIAS', 'Categorias', 'Productos', '/categorias', 110);  -- opcion 11
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('MARCAS', 'Marcas', 'Productos', '/marcas', 120);  -- opcion 12
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('UNIDADES', 'Unidades de medida', 'Productos', '/unidades', 130);  -- opcion 13
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('PRODUCTOS', 'Productos', 'Productos', '/productos', 140);  -- opcion 14
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('INVENTARIO', 'Existencias', 'Inventario', '/inventario', 150);  -- opcion 15
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('MOVIMIENTOS', 'Ingresos y traslados', 'Inventario', '/movimientos', 160);  -- opcion 16
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('BAJAS', 'Bajas de inventario', 'Inventario', '/bajas', 170);  -- opcion 17
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('MOTIVOS_BAJA', 'Motivos de baja', 'Inventario', '/motivos-baja', 180);  -- opcion 18
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('PROVEEDORES', 'Proveedores', 'Compras', '/proveedores', 190);  -- opcion 19
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('COMPRAS', 'Compras', 'Compras', '/compras', 200);  -- opcion 20
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('CUENTAS_PAGAR', 'Cuentas por pagar', 'Compras', '/cuentas-pagar', 210);  -- opcion 21
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('CLIENTES', 'Clientes', 'Ventas', '/clientes', 220);  -- opcion 22
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('FACTURAS', 'Facturacion', 'Ventas', '/facturas', 230);  -- opcion 23
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('CUENTAS_COBRAR', 'Cuentas por cobrar', 'Ventas', '/cuentas-cobrar', 240);  -- opcion 24
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('FORMAS_PAGO', 'Formas de pago', 'Ventas', '/formas-pago', 250);  -- opcion 25
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('NOTAS_CREDITO', 'Notas de credito', 'Postventa', '/notas-credito', 260);  -- opcion 26
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('DEVOLUCIONES', 'Devoluciones', 'Postventa', '/devoluciones', 270);  -- opcion 27
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('GARANTIAS', 'Garantias', 'Postventa', '/garantias', 280);  -- opcion 28
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('VEHICULOS', 'Vehiculos', 'Transporte', '/vehiculos', 290);  -- opcion 29
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('TIPOS_PLACA', 'Tipos de placa', 'Transporte', '/tipos-placa', 300);  -- opcion 30
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('PILOTOS', 'Pilotos', 'Transporte', '/pilotos', 310);  -- opcion 31
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('ENVIOS', 'Envios', 'Transporte', '/envios', 320);  -- opcion 32
INSERT INTO OPCION_9255 (CODIGO, NOMBRE, MODULO, RUTA, ORDEN) VALUES ('REPORTES', 'Reportes gerenciales', 'Reportes', '/reportes', 330);  -- opcion 33

-- --------------------------------------------------------------------------------
-- PERMISOS DE CADA ROL (S/N: puede crear, modificar, eliminar; NNN = solo consulta)
-- --------------------------------------------------------------------------------
-- ADMINISTRADOR
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 1, 'S', 'S', 'S');  -- TABLERO
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 2, 'S', 'S', 'S');  -- USUARIOS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 3, 'S', 'S', 'S');  -- ROLES
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 4, 'S', 'S', 'S');  -- BITACORA
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 5, 'S', 'S', 'S');  -- PAISES
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 6, 'S', 'S', 'S');  -- REGIONES
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 7, 'S', 'S', 'S');  -- SUCURSALES
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 8, 'S', 'S', 'S');  -- BODEGAS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 9, 'S', 'S', 'S');  -- PUESTOS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 10, 'S', 'S', 'S');  -- EMPLEADOS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 11, 'S', 'S', 'S');  -- CATEGORIAS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 12, 'S', 'S', 'S');  -- MARCAS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 13, 'S', 'S', 'S');  -- UNIDADES
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 14, 'S', 'S', 'S');  -- PRODUCTOS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 15, 'S', 'S', 'S');  -- INVENTARIO
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 16, 'S', 'S', 'S');  -- MOVIMIENTOS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 17, 'S', 'S', 'S');  -- BAJAS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 18, 'S', 'S', 'S');  -- MOTIVOS_BAJA
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 19, 'S', 'S', 'S');  -- PROVEEDORES
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 20, 'S', 'S', 'S');  -- COMPRAS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 21, 'S', 'S', 'S');  -- CUENTAS_PAGAR
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 22, 'S', 'S', 'S');  -- CLIENTES
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 23, 'S', 'S', 'S');  -- FACTURAS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 24, 'S', 'S', 'S');  -- CUENTAS_COBRAR
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 25, 'S', 'S', 'S');  -- FORMAS_PAGO
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 26, 'S', 'S', 'S');  -- NOTAS_CREDITO
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 27, 'S', 'S', 'S');  -- DEVOLUCIONES
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 28, 'S', 'S', 'S');  -- GARANTIAS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 29, 'S', 'S', 'S');  -- VEHICULOS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 30, 'S', 'S', 'S');  -- TIPOS_PLACA
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 31, 'S', 'S', 'S');  -- PILOTOS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 32, 'S', 'S', 'S');  -- ENVIOS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (1, 33, 'S', 'S', 'S');  -- REPORTES
-- GERENTE
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 1, 'N', 'N', 'N');  -- TABLERO
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 5, 'N', 'N', 'N');  -- PAISES
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 6, 'N', 'N', 'N');  -- REGIONES
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 7, 'N', 'N', 'N');  -- SUCURSALES
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 8, 'N', 'N', 'N');  -- BODEGAS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 9, 'N', 'N', 'N');  -- PUESTOS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 10, 'N', 'N', 'N');  -- EMPLEADOS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 11, 'N', 'N', 'N');  -- CATEGORIAS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 12, 'N', 'N', 'N');  -- MARCAS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 13, 'N', 'N', 'N');  -- UNIDADES
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 14, 'N', 'N', 'N');  -- PRODUCTOS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 15, 'N', 'N', 'N');  -- INVENTARIO
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 16, 'N', 'N', 'N');  -- MOVIMIENTOS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 17, 'S', 'N', 'N');  -- BAJAS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 18, 'N', 'N', 'N');  -- MOTIVOS_BAJA
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 19, 'N', 'N', 'N');  -- PROVEEDORES
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 20, 'N', 'N', 'N');  -- COMPRAS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 21, 'N', 'N', 'N');  -- CUENTAS_PAGAR
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 22, 'N', 'N', 'N');  -- CLIENTES
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 23, 'N', 'N', 'N');  -- FACTURAS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 24, 'N', 'N', 'N');  -- CUENTAS_COBRAR
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 25, 'N', 'N', 'N');  -- FORMAS_PAGO
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 26, 'S', 'N', 'N');  -- NOTAS_CREDITO
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 27, 'S', 'N', 'N');  -- DEVOLUCIONES
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 28, 'N', 'N', 'N');  -- GARANTIAS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 29, 'N', 'N', 'N');  -- VEHICULOS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 30, 'N', 'N', 'N');  -- TIPOS_PLACA
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 31, 'N', 'N', 'N');  -- PILOTOS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 32, 'N', 'N', 'N');  -- ENVIOS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (2, 33, 'N', 'N', 'N');  -- REPORTES
-- VENDEDOR
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (3, 1, 'N', 'N', 'N');  -- TABLERO
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (3, 14, 'N', 'N', 'N');  -- PRODUCTOS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (3, 15, 'N', 'N', 'N');  -- INVENTARIO
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (3, 22, 'S', 'S', 'N');  -- CLIENTES
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (3, 23, 'S', 'N', 'N');  -- FACTURAS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (3, 24, 'N', 'N', 'N');  -- CUENTAS_COBRAR
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (3, 27, 'S', 'N', 'N');  -- DEVOLUCIONES
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (3, 28, 'S', 'S', 'N');  -- GARANTIAS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (3, 32, 'S', 'N', 'N');  -- ENVIOS
-- CAJERO
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (4, 1, 'N', 'N', 'N');  -- TABLERO
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (4, 14, 'N', 'N', 'N');  -- PRODUCTOS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (4, 22, 'N', 'N', 'N');  -- CLIENTES
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (4, 23, 'N', 'N', 'N');  -- FACTURAS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (4, 24, 'S', 'S', 'N');  -- CUENTAS_COBRAR
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (4, 21, 'S', 'S', 'N');  -- CUENTAS_PAGAR
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (4, 26, 'N', 'N', 'N');  -- NOTAS_CREDITO
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (4, 25, 'N', 'N', 'N');  -- FORMAS_PAGO
-- BODEGUERO
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (5, 1, 'N', 'N', 'N');  -- TABLERO
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (5, 14, 'N', 'N', 'N');  -- PRODUCTOS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (5, 15, 'N', 'N', 'N');  -- INVENTARIO
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (5, 16, 'S', 'N', 'N');  -- MOVIMIENTOS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (5, 17, 'S', 'N', 'N');  -- BAJAS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (5, 20, 'N', 'S', 'N');  -- COMPRAS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (5, 27, 'N', 'N', 'N');  -- DEVOLUCIONES
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (5, 28, 'N', 'N', 'N');  -- GARANTIAS
-- COMPRAS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (6, 1, 'N', 'N', 'N');  -- TABLERO
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (6, 11, 'S', 'S', 'S');  -- CATEGORIAS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (6, 12, 'S', 'S', 'S');  -- MARCAS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (6, 13, 'S', 'S', 'S');  -- UNIDADES
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (6, 14, 'S', 'S', 'S');  -- PRODUCTOS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (6, 15, 'N', 'N', 'N');  -- INVENTARIO
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (6, 16, 'N', 'N', 'N');  -- MOVIMIENTOS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (6, 19, 'S', 'S', 'S');  -- PROVEEDORES
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (6, 20, 'S', 'S', 'N');  -- COMPRAS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (6, 21, 'N', 'N', 'N');  -- CUENTAS_PAGAR
-- TRANSPORTE
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (7, 1, 'N', 'N', 'N');  -- TABLERO
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (7, 22, 'N', 'N', 'N');  -- CLIENTES
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (7, 23, 'N', 'N', 'N');  -- FACTURAS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (7, 29, 'S', 'S', 'S');  -- VEHICULOS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (7, 30, 'S', 'S', 'S');  -- TIPOS_PLACA
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (7, 31, 'S', 'S', 'S');  -- PILOTOS
INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR) VALUES (7, 32, 'S', 'S', 'N');  -- ENVIOS

-- --------------------------------------------------------------------------------
-- USUARIOS DE LA APLICACION (contrasena Ferre9255* cifrada con bcrypt)
-- --------------------------------------------------------------------------------
INSERT INTO USUARIO_9255 (ID_EMPLEADO, ID_ROL, NOMBRE_USUARIO, CONTRASENA_CIFRADA) VALUES (1, 1, 'admin', '$2a$10$4gFdXVzXl8kLKKVmDdDwBeNr/rUU9VQ/i8XSAYpYm.8/Tdndb16CG');
INSERT INTO USUARIO_9255 (ID_EMPLEADO, ID_ROL, NOMBRE_USUARIO, CONTRASENA_CIFRADA) VALUES (2, 2, 'gerente', '$2a$10$4gFdXVzXl8kLKKVmDdDwBeNr/rUU9VQ/i8XSAYpYm.8/Tdndb16CG');
INSERT INTO USUARIO_9255 (ID_EMPLEADO, ID_ROL, NOMBRE_USUARIO, CONTRASENA_CIFRADA) VALUES (3, 6, 'compras', '$2a$10$4gFdXVzXl8kLKKVmDdDwBeNr/rUU9VQ/i8XSAYpYm.8/Tdndb16CG');
INSERT INTO USUARIO_9255 (ID_EMPLEADO, ID_ROL, NOMBRE_USUARIO, CONTRASENA_CIFRADA) VALUES (5, 3, 'vendedor', '$2a$10$4gFdXVzXl8kLKKVmDdDwBeNr/rUU9VQ/i8XSAYpYm.8/Tdndb16CG');
INSERT INTO USUARIO_9255 (ID_EMPLEADO, ID_ROL, NOMBRE_USUARIO, CONTRASENA_CIFRADA) VALUES (7, 4, 'cajero', '$2a$10$4gFdXVzXl8kLKKVmDdDwBeNr/rUU9VQ/i8XSAYpYm.8/Tdndb16CG');
INSERT INTO USUARIO_9255 (ID_EMPLEADO, ID_ROL, NOMBRE_USUARIO, CONTRASENA_CIFRADA) VALUES (8, 5, 'bodega', '$2a$10$4gFdXVzXl8kLKKVmDdDwBeNr/rUU9VQ/i8XSAYpYm.8/Tdndb16CG');
INSERT INTO USUARIO_9255 (ID_EMPLEADO, ID_ROL, NOMBRE_USUARIO, CONTRASENA_CIFRADA) VALUES (9, 7, 'transporte', '$2a$10$4gFdXVzXl8kLKKVmDdDwBeNr/rUU9VQ/i8XSAYpYm.8/Tdndb16CG');
INSERT INTO USUARIO_9255 (ID_EMPLEADO, ID_ROL, NOMBRE_USUARIO, CONTRASENA_CIFRADA) VALUES (54, 3, 'vendedor.sv', '$2a$10$4gFdXVzXl8kLKKVmDdDwBeNr/rUU9VQ/i8XSAYpYm.8/Tdndb16CG');
INSERT INTO USUARIO_9255 (ID_EMPLEADO, ID_ROL, NOMBRE_USUARIO, CONTRASENA_CIFRADA) VALUES (61, 3, 'vendedor.hn', '$2a$10$4gFdXVzXl8kLKKVmDdDwBeNr/rUU9VQ/i8XSAYpYm.8/Tdndb16CG');

-- --------------------------------------------------------------------------------
-- CATEGORIAS, MARCAS Y UNIDADES DE MEDIDA
-- --------------------------------------------------------------------------------
INSERT INTO CATEGORIA_9255 (NOMBRE, DESCRIPCION) VALUES ('Herramientas manuales', 'Martillos, llaves, desarmadores y similares.');  -- categoria 1
INSERT INTO CATEGORIA_9255 (NOMBRE, DESCRIPCION) VALUES ('Herramientas electricas', 'Taladros, sierras, esmeriladoras y similares.');  -- categoria 2
INSERT INTO CATEGORIA_9255 (NOMBRE, DESCRIPCION) VALUES ('Construccion', 'Cemento, hierro, block y agregados.');  -- categoria 3
INSERT INTO CATEGORIA_9255 (NOMBRE, DESCRIPCION) VALUES ('Electricidad', 'Cable, tomacorrientes, iluminacion y protecciones.');  -- categoria 4
INSERT INTO CATEGORIA_9255 (NOMBRE, DESCRIPCION) VALUES ('Plomeria', 'Tuberia, accesorios y griferia.');  -- categoria 5
INSERT INTO CATEGORIA_9255 (NOMBRE, DESCRIPCION) VALUES ('Pinturas', 'Pinturas, solventes y accesorios para pintar.');  -- categoria 6
INSERT INTO CATEGORIA_9255 (NOMBRE, DESCRIPCION) VALUES ('Tornilleria y fijacion', 'Clavos, tornillos, tarugos y anclajes.');  -- categoria 7
INSERT INTO CATEGORIA_9255 (NOMBRE, DESCRIPCION) VALUES ('Jardineria', 'Herramientas y accesorios de jardin.');  -- categoria 8
INSERT INTO CATEGORIA_9255 (NOMBRE, DESCRIPCION) VALUES ('Seguridad industrial', 'Equipo de proteccion personal.');  -- categoria 9
INSERT INTO MARCA_9255 (NOMBRE) VALUES ('Truper');  -- marca 1
INSERT INTO MARCA_9255 (NOMBRE) VALUES ('Stanley');  -- marca 2
INSERT INTO MARCA_9255 (NOMBRE) VALUES ('Pretul');  -- marca 3
INSERT INTO MARCA_9255 (NOMBRE) VALUES ('DeWalt');  -- marca 4
INSERT INTO MARCA_9255 (NOMBRE) VALUES ('Makita');  -- marca 5
INSERT INTO MARCA_9255 (NOMBRE) VALUES ('Bosch');  -- marca 6
INSERT INTO MARCA_9255 (NOMBRE) VALUES ('Black and Decker');  -- marca 7
INSERT INTO MARCA_9255 (NOMBRE) VALUES ('Cementos Progreso');  -- marca 8
INSERT INTO MARCA_9255 (NOMBRE) VALUES ('Generica');  -- marca 9
INSERT INTO MARCA_9255 (NOMBRE) VALUES ('Condumex');  -- marca 10
INSERT INTO MARCA_9255 (NOMBRE) VALUES ('Leviton');  -- marca 11
INSERT INTO MARCA_9255 (NOMBRE) VALUES ('Philips');  -- marca 12
INSERT INTO MARCA_9255 (NOMBRE) VALUES ('Square D');  -- marca 13
INSERT INTO MARCA_9255 (NOMBRE) VALUES ('Amanco');  -- marca 14
INSERT INTO MARCA_9255 (NOMBRE) VALUES ('Coflex');  -- marca 15
INSERT INTO MARCA_9255 (NOMBRE) VALUES ('Sherwin-Williams');  -- marca 16
INSERT INTO MARCA_9255 (NOMBRE) VALUES ('Fischer');  -- marca 17
INSERT INTO MARCA_9255 (NOMBRE) VALUES ('Bellota');  -- marca 18
INSERT INTO MARCA_9255 (NOMBRE) VALUES ('3M');  -- marca 19
INSERT INTO UNIDAD_MEDIDA_9255 (NOMBRE, ABREVIATURA) VALUES ('Unidad', 'UND');  -- unidad 1
INSERT INTO UNIDAD_MEDIDA_9255 (NOMBRE, ABREVIATURA) VALUES ('Metro', 'M');  -- unidad 2
INSERT INTO UNIDAD_MEDIDA_9255 (NOMBRE, ABREVIATURA) VALUES ('Metro cubico', 'M3');  -- unidad 3
INSERT INTO UNIDAD_MEDIDA_9255 (NOMBRE, ABREVIATURA) VALUES ('Galon', 'GAL');  -- unidad 4
INSERT INTO UNIDAD_MEDIDA_9255 (NOMBRE, ABREVIATURA) VALUES ('Saco', 'SACO');  -- unidad 5
INSERT INTO UNIDAD_MEDIDA_9255 (NOMBRE, ABREVIATURA) VALUES ('Caja', 'CAJA');  -- unidad 6
INSERT INTO UNIDAD_MEDIDA_9255 (NOMBRE, ABREVIATURA) VALUES ('Libra', 'LB');  -- unidad 7

-- --------------------------------------------------------------------------------
-- PRODUCTOS (precios en quetzales)
-- --------------------------------------------------------------------------------
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (1, 1, 1, 'HM-001', 'Martillo de carpintero 16 oz', 45, 75, 10, 6);  -- producto 1
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (1, 2, 1, 'HM-002', 'Juego de desarmadores 6 piezas', 60, 99, 8, 6);  -- producto 2
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (1, 1, 1, 'HM-003', 'Llave ajustable 10 pulgadas', 55, 89, 8, 6);  -- producto 3
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (1, 3, 1, 'HM-004', 'Alicate universal 8 pulgadas', 30, 52, 10, 3);  -- producto 4
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (1, 2, 1, 'HM-005', 'Cinta metrica 8 metros', 40, 69, 12, 3);  -- producto 5
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (1, 1, 1, 'HM-006', 'Nivel de aluminio 24 pulgadas', 65, 110, 5, 6);  -- producto 6
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (1, 3, 1, 'HM-007', 'Serrucho 20 pulgadas', 50, 85, 5, 3);  -- producto 7
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (2, 4, 1, 'HE-001', 'Taladro percutor 1/2 pulgada 650W', 520, 799, 3, 12);  -- producto 8
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (2, 5, 1, 'HE-002', 'Esmeriladora angular 4 1/2 pulgadas', 480, 735, 3, 12);  -- producto 9
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (2, 6, 1, 'HE-003', 'Sierra circular 7 1/4 pulgadas', 780, 1150, 2, 12);  -- producto 10
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (2, 6, 1, 'HE-004', 'Rotomartillo SDS Plus 800W', 1100, 1650, 2, 12);  -- producto 11
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (2, 7, 1, 'HE-005', 'Atornillador inalambrico 12V', 390, 599, 3, 12);  -- producto 12
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (3, 8, 5, 'CO-001', 'Cemento gris 42.5 kg', 70, 89, 50, 0);  -- producto 13
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (3, 9, 1, 'CO-002', 'Varilla de hierro 3/8 pulgada x 6 m', 32, 45, 100, 0);  -- producto 14
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (3, 9, 1, 'CO-003', 'Block de concreto 15x20x40 cm', 4.25, 6.5, 300, 0);  -- producto 15
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (3, 9, 3, 'CO-004', 'Arena de rio', 150, 225, 10, 0);  -- producto 16
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (3, 9, 5, 'CO-005', 'Cal hidratada 25 kg', 28, 42, 30, 0);  -- producto 17
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (3, 9, 7, 'CO-006', 'Alambre de amarre', 7, 11, 50, 0);  -- producto 18
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (4, 10, 2, 'EL-001', 'Cable THHN calibre 12', 3.5, 6, 200, 0);  -- producto 19
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (4, 11, 1, 'EL-002', 'Tomacorriente doble polarizado', 9, 17, 30, 6);  -- producto 20
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (4, 11, 1, 'EL-003', 'Interruptor sencillo', 8, 15, 30, 6);  -- producto 21
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (4, 12, 1, 'EL-004', 'Foco LED 9W luz blanca', 12, 22, 50, 12);  -- producto 22
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (4, 13, 1, 'EL-005', 'Centro de carga 4 circuitos', 180, 279, 5, 12);  -- producto 23
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (5, 14, 1, 'PL-001', 'Tubo PVC 1/2 pulgada x 6 m', 22, 35, 40, 0);  -- producto 24
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (5, 14, 1, 'PL-002', 'Codo PVC 1/2 pulgada 90 grados', 1.5, 3, 100, 0);  -- producto 25
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (5, 14, 1, 'PL-003', 'Pegamento para PVC 1/4 galon', 45, 72, 10, 0);  -- producto 26
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (5, 15, 1, 'PL-004', 'Llave de paso 1/2 pulgada', 38, 62, 15, 6);  -- producto 27
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (5, 15, 1, 'PL-005', 'Mezcladora para lavamanos', 210, 335, 4, 12);  -- producto 28
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (6, 16, 4, 'PI-001', 'Pintura latex blanco', 110, 165, 15, 0);  -- producto 29
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (6, 16, 4, 'PI-002', 'Pintura de aceite negro', 140, 210, 8, 0);  -- producto 30
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (6, 1, 1, 'PI-003', 'Brocha de 3 pulgadas', 12, 22, 20, 0);  -- producto 31
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (6, 1, 1, 'PI-004', 'Rodillo de felpa 9 pulgadas', 25, 42, 15, 0);  -- producto 32
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (6, 9, 4, 'PI-005', 'Thinner', 48, 75, 10, 0);  -- producto 33
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (7, 9, 7, 'TF-001', 'Clavo de 3 pulgadas', 6, 10, 80, 0);  -- producto 34
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (7, 9, 6, 'TF-002', 'Tornillo para tablayeso 1 pulgada (100)', 18, 30, 25, 0);  -- producto 35
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (7, 17, 6, 'TF-003', 'Tarugo plastico 1/4 pulgada (100)', 15, 26, 25, 0);  -- producto 36
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (8, 1, 1, 'JA-001', 'Manguera de jardin 15 metros', 85, 135, 8, 3);  -- producto 37
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (8, 1, 1, 'JA-002', 'Pala cuadrada con mango', 70, 115, 8, 3);  -- producto 38
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (8, 18, 1, 'JA-003', 'Machete de 22 pulgadas', 40, 68, 10, 3);  -- producto 39
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (9, 19, 1, 'SI-001', 'Casco de seguridad', 35, 60, 10, 0);  -- producto 40
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (9, 1, 1, 'SI-002', 'Guantes de cuero (par)', 22, 38, 20, 0);  -- producto 41
INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, ID_UNIDAD_MEDIDA, CODIGO, NOMBRE, PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA) VALUES (9, 19, 1, 'SI-003', 'Lentes de proteccion', 18, 32, 15, 0);  -- producto 42

-- --------------------------------------------------------------------------------
-- FORMAS DE PAGO (1 Efectivo, 2 Tarjeta, 3 Transferencia, 4 Cheque)
-- --------------------------------------------------------------------------------
INSERT INTO FORMA_PAGO_9255 (NOMBRE, REQUIERE_REFERENCIA) VALUES ('Efectivo', 'N');
INSERT INTO FORMA_PAGO_9255 (NOMBRE, REQUIERE_REFERENCIA) VALUES ('Tarjeta', 'S');
INSERT INTO FORMA_PAGO_9255 (NOMBRE, REQUIERE_REFERENCIA) VALUES ('Transferencia', 'S');
INSERT INTO FORMA_PAGO_9255 (NOMBRE, REQUIERE_REFERENCIA) VALUES ('Cheque', 'S');

-- --------------------------------------------------------------------------------
-- TIPOS DE MOVIMIENTO DE INVENTARIO (+ suma, - resta)
-- --------------------------------------------------------------------------------
INSERT INTO TIPO_MOVIMIENTO_9255 (CODIGO, NOMBRE, OPERACION) VALUES ('INVENTARIO_INICIAL', 'Inventario inicial', '+');  -- tipo 1
INSERT INTO TIPO_MOVIMIENTO_9255 (CODIGO, NOMBRE, OPERACION) VALUES ('INGRESO_COMPRA', 'Ingreso por compra', '+');  -- tipo 2
INSERT INTO TIPO_MOVIMIENTO_9255 (CODIGO, NOMBRE, OPERACION) VALUES ('SALIDA_VENTA', 'Salida por venta', '-');  -- tipo 3
INSERT INTO TIPO_MOVIMIENTO_9255 (CODIGO, NOMBRE, OPERACION) VALUES ('BAJA', 'Baja de inventario', '-');  -- tipo 4
INSERT INTO TIPO_MOVIMIENTO_9255 (CODIGO, NOMBRE, OPERACION) VALUES ('SALIDA_TRASLADO', 'Salida por traslado', '-');  -- tipo 5
INSERT INTO TIPO_MOVIMIENTO_9255 (CODIGO, NOMBRE, OPERACION) VALUES ('INGRESO_TRASLADO', 'Ingreso por traslado', '+');  -- tipo 6
INSERT INTO TIPO_MOVIMIENTO_9255 (CODIGO, NOMBRE, OPERACION) VALUES ('INGRESO_DEVOLUCION', 'Ingreso por devolucion', '+');  -- tipo 7
INSERT INTO TIPO_MOVIMIENTO_9255 (CODIGO, NOMBRE, OPERACION) VALUES ('AJUSTE_ENTRADA', 'Ajuste de entrada', '+');  -- tipo 8
INSERT INTO TIPO_MOVIMIENTO_9255 (CODIGO, NOMBRE, OPERACION) VALUES ('AJUSTE_SALIDA', 'Ajuste de salida', '-');  -- tipo 9

-- --------------------------------------------------------------------------------
-- MOTIVOS DE BAJA
-- --------------------------------------------------------------------------------
INSERT INTO MOTIVO_BAJA_9255 (NOMBRE, DESCRIPCION) VALUES ('Dano', 'Producto danado en bodega o en manipulacion.');  -- motivo 1
INSERT INTO MOTIVO_BAJA_9255 (NOMBRE, DESCRIPCION) VALUES ('Vencimiento', 'Producto con fecha de vencimiento cumplida.');  -- motivo 2
INSERT INTO MOTIVO_BAJA_9255 (NOMBRE, DESCRIPCION) VALUES ('Robo', 'Faltante por robo comprobado.');  -- motivo 3
INSERT INTO MOTIVO_BAJA_9255 (NOMBRE, DESCRIPCION) VALUES ('Perdida', 'Faltante detectado en inventario fisico.');  -- motivo 4
INSERT INTO MOTIVO_BAJA_9255 (NOMBRE, DESCRIPCION) VALUES ('Defecto de fabrica', 'Producto defectuoso que no puede venderse.');  -- motivo 5

-- --------------------------------------------------------------------------------
-- TIPOS DE PLACA
-- --------------------------------------------------------------------------------
INSERT INTO TIPO_PLACA_9255 (ID_PAIS, CODIGO, DESCRIPCION) VALUES (1, 'P', 'Particular');  -- tipo de placa 1
INSERT INTO TIPO_PLACA_9255 (ID_PAIS, CODIGO, DESCRIPCION) VALUES (1, 'C', 'Comercial');  -- tipo de placa 2
INSERT INTO TIPO_PLACA_9255 (ID_PAIS, CODIGO, DESCRIPCION) VALUES (1, 'TC', 'Transporte de carga');  -- tipo de placa 3
INSERT INTO TIPO_PLACA_9255 (ID_PAIS, CODIGO, DESCRIPCION) VALUES (2, 'P', 'Particular');  -- tipo de placa 4
INSERT INTO TIPO_PLACA_9255 (ID_PAIS, CODIGO, DESCRIPCION) VALUES (2, 'C', 'Carga');  -- tipo de placa 5
INSERT INTO TIPO_PLACA_9255 (ID_PAIS, CODIGO, DESCRIPCION) VALUES (3, 'P', 'Particular');  -- tipo de placa 6
INSERT INTO TIPO_PLACA_9255 (ID_PAIS, CODIGO, DESCRIPCION) VALUES (3, 'C', 'Comercial');  -- tipo de placa 7

-- --------------------------------------------------------------------------------
-- VEHICULOS Y PILOTOS (uno por sucursal; vehiculo S y piloto S son de la sucursal S)
-- --------------------------------------------------------------------------------
INSERT INTO VEHICULO_9255 (ID_SUCURSAL, ID_TIPO_PLACA, PLACA, MARCA, MODELO, COLOR, CAPACIDAD_TONELADAS) VALUES (1, 3, '137BKL', 'Hino', 'Dutro 2022', 'Rojo', 3.5);  -- vehiculo 1
INSERT INTO VEHICULO_9255 (ID_SUCURSAL, ID_TIPO_PLACA, PLACA, MARCA, MODELO, COLOR, CAPACIDAD_TONELADAS) VALUES (2, 3, '174BKL', 'Toyota', 'Hilux 2023', 'Gris', 1);  -- vehiculo 2
INSERT INTO VEHICULO_9255 (ID_SUCURSAL, ID_TIPO_PLACA, PLACA, MARCA, MODELO, COLOR, CAPACIDAD_TONELADAS) VALUES (3, 3, '211BKL', 'Mitsubishi', 'Canter 2020', 'Blanco', 3.5);  -- vehiculo 3
INSERT INTO VEHICULO_9255 (ID_SUCURSAL, ID_TIPO_PLACA, PLACA, MARCA, MODELO, COLOR, CAPACIDAD_TONELADAS) VALUES (4, 3, '248BKL', 'Isuzu', 'NPR 2021', 'Rojo', 3.5);  -- vehiculo 4
INSERT INTO VEHICULO_9255 (ID_SUCURSAL, ID_TIPO_PLACA, PLACA, MARCA, MODELO, COLOR, CAPACIDAD_TONELADAS) VALUES (5, 5, '44565', 'Hino', 'Dutro 2022', 'Gris', 3.5);  -- vehiculo 5
INSERT INTO VEHICULO_9255 (ID_SUCURSAL, ID_TIPO_PLACA, PLACA, MARCA, MODELO, COLOR, CAPACIDAD_TONELADAS) VALUES (6, 5, '45478', 'Toyota', 'Hilux 2023', 'Blanco', 1);  -- vehiculo 6
INSERT INTO VEHICULO_9255 (ID_SUCURSAL, ID_TIPO_PLACA, PLACA, MARCA, MODELO, COLOR, CAPACIDAD_TONELADAS) VALUES (7, 5, '46391', 'Mitsubishi', 'Canter 2020', 'Rojo', 3.5);  -- vehiculo 7
INSERT INTO VEHICULO_9255 (ID_SUCURSAL, ID_TIPO_PLACA, PLACA, MARCA, MODELO, COLOR, CAPACIDAD_TONELADAS) VALUES (8, 5, '47304', 'Isuzu', 'NPR 2021', 'Gris', 3.5);  -- vehiculo 8
INSERT INTO VEHICULO_9255 (ID_SUCURSAL, ID_TIPO_PLACA, PLACA, MARCA, MODELO, COLOR, CAPACIDAD_TONELADAS) VALUES (9, 7, 'HAB 3439', 'Hino', 'Dutro 2022', 'Blanco', 3.5);  -- vehiculo 9
INSERT INTO VEHICULO_9255 (ID_SUCURSAL, ID_TIPO_PLACA, PLACA, MARCA, MODELO, COLOR, CAPACIDAD_TONELADAS) VALUES (10, 7, 'HAB 3710', 'Toyota', 'Hilux 2023', 'Rojo', 1);  -- vehiculo 10
INSERT INTO VEHICULO_9255 (ID_SUCURSAL, ID_TIPO_PLACA, PLACA, MARCA, MODELO, COLOR, CAPACIDAD_TONELADAS) VALUES (11, 7, 'HAB 3981', 'Mitsubishi', 'Canter 2020', 'Gris', 3.5);  -- vehiculo 11
INSERT INTO VEHICULO_9255 (ID_SUCURSAL, ID_TIPO_PLACA, PLACA, MARCA, MODELO, COLOR, CAPACIDAD_TONELADAS) VALUES (12, 7, 'HAB 4252', 'Isuzu', 'NPR 2021', 'Blanco', 3.5);  -- vehiculo 12
INSERT INTO PILOTO_9255 (ID_EMPLEADO, NUMERO_LICENCIA, TIPO_LICENCIA, FECHA_VENCIMIENTO_LICENCIA) VALUES (10, 'GT-LIC-0001310', 'B', DATE '2028-02-28');  -- piloto 1
INSERT INTO PILOTO_9255 (ID_EMPLEADO, NUMERO_LICENCIA, TIPO_LICENCIA, FECHA_VENCIMIENTO_LICENCIA) VALUES (17, 'GT-LIC-0002227', 'B', DATE '2028-03-28');  -- piloto 2
INSERT INTO PILOTO_9255 (ID_EMPLEADO, NUMERO_LICENCIA, TIPO_LICENCIA, FECHA_VENCIMIENTO_LICENCIA) VALUES (24, 'GT-LIC-0003144', 'B', DATE '2028-04-28');  -- piloto 3
INSERT INTO PILOTO_9255 (ID_EMPLEADO, NUMERO_LICENCIA, TIPO_LICENCIA, FECHA_VENCIMIENTO_LICENCIA) VALUES (31, 'GT-LIC-0004061', 'B', DATE '2028-05-28');  -- piloto 4
INSERT INTO PILOTO_9255 (ID_EMPLEADO, NUMERO_LICENCIA, TIPO_LICENCIA, FECHA_VENCIMIENTO_LICENCIA) VALUES (38, 'SV-LIC-0004978', 'B', DATE '2028-06-28');  -- piloto 5
INSERT INTO PILOTO_9255 (ID_EMPLEADO, NUMERO_LICENCIA, TIPO_LICENCIA, FECHA_VENCIMIENTO_LICENCIA) VALUES (45, 'SV-LIC-0005895', 'B', DATE '2028-07-28');  -- piloto 6
INSERT INTO PILOTO_9255 (ID_EMPLEADO, NUMERO_LICENCIA, TIPO_LICENCIA, FECHA_VENCIMIENTO_LICENCIA) VALUES (52, 'SV-LIC-0006812', 'B', DATE '2028-08-28');  -- piloto 7
INSERT INTO PILOTO_9255 (ID_EMPLEADO, NUMERO_LICENCIA, TIPO_LICENCIA, FECHA_VENCIMIENTO_LICENCIA) VALUES (59, 'SV-LIC-0007729', 'B', DATE '2028-09-28');  -- piloto 8
INSERT INTO PILOTO_9255 (ID_EMPLEADO, NUMERO_LICENCIA, TIPO_LICENCIA, FECHA_VENCIMIENTO_LICENCIA) VALUES (66, 'HN-LIC-0008646', 'B', DATE '2028-10-28');  -- piloto 9
INSERT INTO PILOTO_9255 (ID_EMPLEADO, NUMERO_LICENCIA, TIPO_LICENCIA, FECHA_VENCIMIENTO_LICENCIA) VALUES (73, 'HN-LIC-0009563', 'B', DATE '2028-11-28');  -- piloto 10
INSERT INTO PILOTO_9255 (ID_EMPLEADO, NUMERO_LICENCIA, TIPO_LICENCIA, FECHA_VENCIMIENTO_LICENCIA) VALUES (80, 'HN-LIC-0010480', 'B', DATE '2028-12-28');  -- piloto 11
INSERT INTO PILOTO_9255 (ID_EMPLEADO, NUMERO_LICENCIA, TIPO_LICENCIA, FECHA_VENCIMIENTO_LICENCIA) VALUES (87, 'HN-LIC-0011397', 'B', DATE '2028-01-28');  -- piloto 12

-- --------------------------------------------------------------------------------
-- CLIENTES
-- 4 por region: los dos primeros son empresas con credito, los otros dos personas.
-- Los clientes de la region R son los ID (R - 1) * 4 + 1 a R * 4.
-- 49, 50 y 51: consumidor final (CF) de Guatemala, El Salvador y Honduras.
-- --------------------------------------------------------------------------------
-- region 1
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (1, 'EMPRESA', '4007919-1', 'Inversiones El Roble, S.A.', '20007907', 'compras1@empresa1.com', 'Zona 1, Alta Verapaz', 35000, 30);  -- cliente 1
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (1, 'EMPRESA', '4015838-2', 'Proyectos Las Palmas, S.A.', '20015814', 'compras2@empresa2.com', 'Zona 2, Alta Verapaz', 20000, 15);  -- cliente 2
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (1, 'INDIVIDUAL', '1018021-0', 'Maria Ramirez Velasquez', '50018021', 'maria3@correo.com', 'Colonia Santa Fe, Alta Verapaz', 0, 0);  -- cliente 3
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (1, 'INDIVIDUAL', '1024028-3', 'Miguel Reyes Castillo', '50024028', 'miguel4@correo.com', 'Colonia Volta, Alta Verapaz', 0, 0);  -- cliente 4
-- region 2
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (2, 'EMPRESA', '4039595-5', 'Acabados Altamira, S.A.', '20039535', 'compras5@empresa3.com', 'Zona 5, Escuintla', 35000, 30);  -- cliente 5
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (2, 'EMPRESA', '4047514-6', 'Ingenieria Santa Fe, S.A.', '20047442', 'compras6@empresa4.com', 'Zona 6, Escuintla', 20000, 15);  -- cliente 6
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (2, 'INDIVIDUAL', '1042049-3', 'Andrea Garcia Garcia', '50042049', 'andrea7@correo.com', 'Colonia Horizonte, Escuintla', 0, 0);  -- cliente 7
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (2, 'INDIVIDUAL', '1048056-6', 'Mario Perez Reyes', '50048056', 'mario8@correo.com', 'Colonia Monte Verde, Escuintla', 0, 0);  -- cliente 8
-- region 3
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (3, 'EMPRESA', '4071271-0', 'Desarrollos Volta, S.A.', '20071163', 'compras9@empresa5.com', 'Zona 9, Zacapa', 35000, 30);  -- cliente 9
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (3, 'EMPRESA', '4079190-1', 'Constructora Rivera, S.A.', '20079070', 'compras10@empresa6.com', 'Zona 10, Zacapa', 20000, 15);  -- cliente 10
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (3, 'INDIVIDUAL', '1066077-6', 'Karla Cruz Gonzalez', '50066077', 'karla11@correo.com', 'Colonia Atlas, Zacapa', 0, 0);  -- cliente 11
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (3, 'INDIVIDUAL', '1072084-0', 'Luis Juarez Juarez', '50072084', 'luis12@correo.com', 'Colonia San Jose, Zacapa', 0, 0);  -- cliente 12
-- region 4
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (4, 'EMPRESA', '4102947-4', 'Inversiones del Valle, S.A.', '20102791', 'compras13@empresa7.com', 'Zona 1, Quetzaltenango', 35000, 30);  -- cliente 13
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (4, 'EMPRESA', '4110866-5', 'Proyectos Horizonte, S.A.', '20110698', 'compras14@empresa8.com', 'Zona 2, Quetzaltenango', 20000, 15);  -- cliente 14
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (4, 'INDIVIDUAL', '1090105-0', 'Sofia Gonzalez Ramirez', '50090105', 'sofia15@correo.com', 'Colonia del Norte, Quetzaltenango', 0, 0);  -- cliente 15
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (4, 'INDIVIDUAL', '1096112-3', 'Fernando Castillo Lopez', '50096112', 'fernando16@correo.com', 'Colonia Maya, Quetzaltenango', 0, 0);  -- cliente 16
-- region 5
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (5, 'EMPRESA', '4134623-8', 'Acabados Monte Verde, S.A.', '20134419', 'compras17@empresa9.com', 'Zona 5, Chalatenango', 4500, 30);  -- cliente 17
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (5, 'EMPRESA', '4142542-0', 'Ingenieria Casa Bella, S.A.', '20142326', 'compras18@empresa10.com', 'Zona 6, Chalatenango', 2600, 15);  -- cliente 18
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (5, 'INDIVIDUAL', '1114133-3', 'Daniela Velasquez Cruz', '50114133', 'daniela19@correo.com', 'Colonia Copan, Chalatenango', 0, 0);  -- cliente 19
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (5, 'INDIVIDUAL', '1120140-6', 'Carlos Lopez Perez', '50120140', 'carlos20@correo.com', 'Colonia Las Flores, Chalatenango', 0, 0);  -- cliente 20
-- region 6
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (6, 'EMPRESA', '4166299-3', 'Desarrollos Los Cedros, S.A.', '20166047', 'compras21@empresa11.com', 'Zona 9, Zacatecoluca', 4500, 30);  -- cliente 21
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (6, 'EMPRESA', '4174218-4', 'Constructora Atlas, S.A.', '20173954', 'compras22@empresa12.com', 'Zona 10, Zacatecoluca', 2600, 15);  -- cliente 22
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (6, 'INDIVIDUAL', '1138161-6', 'Maria Ramirez Velasquez', '50138161', 'maria23@correo.com', 'Colonia Cumbres, Zacatecoluca', 0, 0);  -- cliente 23
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (6, 'INDIVIDUAL', '1144168-0', 'Miguel Reyes Castillo', '50144168', 'miguel24@correo.com', 'Colonia El Roble, Zacatecoluca', 0, 0);  -- cliente 24
-- region 7
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (7, 'EMPRESA', '4197975-7', 'Inversiones San Jose, S.A.', '20197675', 'compras25@empresa13.com', 'Zona 1, San Miguel', 4500, 30);  -- cliente 25
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (7, 'EMPRESA', '4205894-8', 'Proyectos La Ceiba, S.A.', '20205582', 'compras26@empresa14.com', 'Zona 2, San Miguel', 2600, 15);  -- cliente 26
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (7, 'INDIVIDUAL', '1162189-0', 'Andrea Garcia Garcia', '50162189', 'andrea27@correo.com', 'Colonia Santa Fe, San Miguel', 0, 0);  -- cliente 27
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (7, 'INDIVIDUAL', '1168196-3', 'Mario Perez Reyes', '50168196', 'mario28@correo.com', 'Colonia Volta, San Miguel', 0, 0);  -- cliente 28
-- region 8
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (8, 'EMPRESA', '4229651-2', 'Acabados del Pacifico, S.A.', '20229303', 'compras29@empresa15.com', 'Zona 5, Santa Ana', 4500, 30);  -- cliente 29
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (8, 'EMPRESA', '4237570-3', 'Ingenieria del Norte, S.A.', '20237210', 'compras30@empresa16.com', 'Zona 6, Santa Ana', 2600, 15);  -- cliente 30
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (8, 'INDIVIDUAL', '1186217-3', 'Karla Cruz Gonzalez', '50186217', 'karla31@correo.com', 'Colonia Horizonte, Santa Ana', 0, 0);  -- cliente 31
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (8, 'INDIVIDUAL', '1192224-6', 'Luis Juarez Juarez', '50192224', 'luis32@correo.com', 'Colonia Monte Verde, Santa Ana', 0, 0);  -- cliente 32
-- region 9
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (9, 'EMPRESA', '4261327-6', 'Desarrollos Maya, S.A.', '20260931', 'compras33@empresa17.com', 'Zona 9, San Pedro Sula', 116700, 30);  -- cliente 33
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (9, 'EMPRESA', '4269246-7', 'Constructora Lempa, S.A.', '20268838', 'compras34@empresa18.com', 'Zona 10, San Pedro Sula', 66700, 15);  -- cliente 34
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (9, 'INDIVIDUAL', '1210245-6', 'Sofia Gonzalez Ramirez', '50210245', 'sofia35@correo.com', 'Colonia Atlas, San Pedro Sula', 0, 0);  -- cliente 35
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (9, 'INDIVIDUAL', '1216252-0', 'Fernando Castillo Lopez', '50216252', 'fernando36@correo.com', 'Colonia San Jose, San Pedro Sula', 0, 0);  -- cliente 36
-- region 10
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (10, 'EMPRESA', '4293003-1', 'Inversiones Cuscatlan, S.A.', '20292559', 'compras37@empresa19.com', 'Zona 1, Choluteca', 116700, 30);  -- cliente 37
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (10, 'EMPRESA', '4300922-2', 'Proyectos Copan, S.A.', '20300466', 'compras38@empresa20.com', 'Zona 2, Choluteca', 66700, 15);  -- cliente 38
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (10, 'INDIVIDUAL', '1234273-0', 'Daniela Velasquez Cruz', '50234273', 'daniela39@correo.com', 'Colonia del Norte, Choluteca', 0, 0);  -- cliente 39
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (10, 'INDIVIDUAL', '1240280-3', 'Carlos Lopez Perez', '50240280', 'carlos40@correo.com', 'Colonia Maya, Choluteca', 0, 0);  -- cliente 40
-- region 11
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (11, 'EMPRESA', '4324679-5', 'Acabados Las Flores, S.A.', '20324187', 'compras41@empresa21.com', 'Zona 5, Olancho', 116700, 30);  -- cliente 41
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (11, 'EMPRESA', '4332598-6', 'Ingenieria El Progreso, S.A.', '20332094', 'compras42@empresa22.com', 'Zona 6, Olancho', 66700, 15);  -- cliente 42
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (11, 'INDIVIDUAL', '1258301-3', 'Maria Ramirez Velasquez', '50258301', 'maria43@correo.com', 'Colonia Copan, Olancho', 0, 0);  -- cliente 43
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (11, 'INDIVIDUAL', '1264308-6', 'Miguel Reyes Castillo', '50264308', 'miguel44@correo.com', 'Colonia Las Flores, Olancho', 0, 0);  -- cliente 44
-- region 12
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (12, 'EMPRESA', '4356355-0', 'Desarrollos Sol y Mar, S.A.', '20355815', 'compras45@empresa23.com', 'Zona 9, Santa Rosa de Copan', 116700, 30);  -- cliente 45
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (12, 'EMPRESA', '4364274-1', 'Constructora Cumbres, S.A.', '20363722', 'compras46@empresa24.com', 'Zona 10, Santa Rosa de Copan', 66700, 15);  -- cliente 46
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (12, 'INDIVIDUAL', '1282329-6', 'Andrea Garcia Garcia', '50282329', 'andrea47@correo.com', 'Colonia Cumbres, Santa Rosa de Copan', 0, 0);  -- cliente 47
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION, LIMITE_CREDITO, DIAS_CREDITO) VALUES (12, 'INDIVIDUAL', '1288336-0', 'Mario Perez Reyes', '50288336', 'mario48@correo.com', 'Colonia El Roble, Santa Rosa de Copan', 0, 0);  -- cliente 48
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, LIMITE_CREDITO, DIAS_CREDITO) VALUES (1, 'INDIVIDUAL', 'CF', 'Consumidor final Guatemala', 0, 0);  -- cliente 49
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, LIMITE_CREDITO, DIAS_CREDITO) VALUES (5, 'INDIVIDUAL', 'CF', 'Consumidor final El Salvador', 0, 0);  -- cliente 50
INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, LIMITE_CREDITO, DIAS_CREDITO) VALUES (9, 'INDIVIDUAL', 'CF', 'Consumidor final Honduras', 0, 0);  -- cliente 51

-- --------------------------------------------------------------------------------
-- PROVEEDORES (1-3 Guatemala, 4-5 El Salvador, 6 Honduras)
-- --------------------------------------------------------------------------------
INSERT INTO PROVEEDOR_9255 (ID_PAIS, NIT, NOMBRE, NOMBRE_CONTACTO, TELEFONO, CORREO, DIRECCION, DIAS_CREDITO) VALUES (1, '7854123-5', 'Distribuidora Centroamericana de Herramientas, S.A.', 'Rodrigo Paz', '2410-5500', 'ventas@dicaher.com', 'Calzada Roosevelt 22-43 Zona 11, Guatemala', 30);  -- proveedor 1
INSERT INTO PROVEEDOR_9255 (ID_PAIS, NIT, NOMBRE, NOMBRE_CONTACTO, TELEFONO, CORREO, DIRECCION, DIAS_CREDITO) VALUES (1, '1253698-7', 'Materiales de Construccion El Cimiento, S.A.', 'Laura Mejia', '2385-1200', 'pedidos@elcimiento.com', 'Km 17.5 Carretera al Pacifico, Villa Nueva', 15);  -- proveedor 2
INSERT INTO PROVEEDOR_9255 (ID_PAIS, NIT, NOMBRE, NOMBRE_CONTACTO, TELEFONO, CORREO, DIRECCION, DIAS_CREDITO) VALUES (1, '6634521-0', 'Electro Suministros del Norte, S.A.', 'Marco Tulio Diaz', '2299-8740', 'info@electronorte.com', '5a. Avenida 12-60 Zona 9, Guatemala', 30);  -- proveedor 3
INSERT INTO PROVEEDOR_9255 (ID_PAIS, NIT, NOMBRE, NOMBRE_CONTACTO, TELEFONO, CORREO, DIRECCION, DIAS_CREDITO) VALUES (2, '0614-150390-101-3', 'Ferreteros Unidos de El Salvador, S.A. de C.V.', 'Ernesto Quintanilla', '2260-4400', 'compras@ferreunidos.com', 'Boulevard del Ejercito Km 5, Soyapango', 30);  -- proveedor 4
INSERT INTO PROVEEDOR_9255 (ID_PAIS, NIT, NOMBRE, NOMBRE_CONTACTO, TELEFONO, CORREO, DIRECCION, DIAS_CREDITO) VALUES (2, '0614-220788-102-6', 'Pinturas y Plomeria Cuscatlan, S.A. de C.V.', 'Diana Rosales', '2273-9100', 'ventas@pinturascuscatlan.com', 'Calle a Santa Tecla 45, Antiguo Cuscatlan', 15);  -- proveedor 5
INSERT INTO PROVEEDOR_9255 (ID_PAIS, NIT, NOMBRE, NOMBRE_CONTACTO, TELEFONO, CORREO, DIRECCION, DIAS_CREDITO) VALUES (3, '08019005123456', 'Comercial Ferretera Hondurena, S. de R.L.', 'Kevin Zelaya', '2556-7700', 'pedidos@cofehsa.com', 'Bulevar del Norte, San Pedro Sula', 30);  -- proveedor 6

COMMIT;


-- ================================================================================
-- OPERACIONES DE PRUEBA
-- Se generan con los mismos INSERT y procedimientos que usara la aplicacion,
-- asi que tambien sirven para probar los disparadores y las reglas del negocio.
-- Empleados de la sucursal S:  gerente = 4 + (S-1)*7,  vendedores = +1 y +2,
-- cajero = +3, bodeguero = +4, encargado de transporte = +5, piloto = +6
-- ================================================================================

-- --------------------------------------------------------------------------------
-- 1. INVENTARIO INICIAL: todos los productos en las 12 bodegas (2 de enero de 2026)
-- --------------------------------------------------------------------------------
DECLARE
    V_CANTIDAD  NUMBER;
    V_COSTO     NUMBER(12,2);
    V_BODEGUERO NUMBER;
BEGIN
    DBMS_RANDOM.SEED(9255);
    FOR B IN 1..12 LOOP
        V_BODEGUERO := 4 + (B - 1) * 7 + 4;
        FOR P IN 1..42 LOOP
            SELECT EXISTENCIA_MINIMA * 4 + 25 + TRUNC(DBMS_RANDOM.VALUE(0, 40)), PRECIO_COSTO
              INTO V_CANTIDAD, V_COSTO
              FROM PRODUCTO_9255
             WHERE ID_PRODUCTO = P;
            PRC_REGISTRA_MOV_INVENTARIO_9255('INVENTARIO_INICIAL', B, P, V_CANTIDAD, V_COSTO, V_BODEGUERO,
                                             'INVENTARIO INICIAL 2026', TO_DATE('2026-01-02 08:00', 'YYYY-MM-DD HH24:MI'));
        END LOOP;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Inventario inicial cargado.');
END;
/

-- --------------------------------------------------------------------------------
-- 2. COMPRAS: una por sucursal en marzo, la mitad al credito; se reciben 2 dias despues
-- --------------------------------------------------------------------------------
DECLARE
    V_ID_COMPRA  NUMBER;
    V_PROVEEDOR  NUMBER;
    V_TIPO_PAGO  VARCHAR2(10);
    V_FECHA      DATE;
    V_COSTO      NUMBER(12,2);
    V_TC         NUMBER(10,4);
    V_MINIMA     NUMBER;
BEGIN
    FOR S IN 1..12 LOOP
        -- Proveedor del mismo pais: GT 1-3, SV 4-5, HN 6
        IF S <= 4 THEN
            V_PROVEEDOR := MOD(S, 3) + 1;
            V_TC := 1;
        ELSIF S <= 8 THEN
            V_PROVEEDOR := MOD(S, 2) + 4;
            V_TC := 7.7;
        ELSE
            V_PROVEEDOR := 6;
            V_TC := 0.3;
        END IF;

        IF MOD(S, 2) = 0 THEN
            V_TIPO_PAGO := 'CREDITO';
        ELSE
            V_TIPO_PAGO := 'CONTADO';
        END IF;
        V_FECHA := TO_DATE('2026-03-09 10:00', 'YYYY-MM-DD HH24:MI') + S;

        INSERT INTO COMPRA_9255 (ID_PROVEEDOR, ID_BODEGA_DESTINO, ID_EMPLEADO, NUMERO_DOCUMENTO, FECHA_EMISION, TIPO_PAGO)
        VALUES (V_PROVEEDOR, S, 3, 'FAC-' || (1000 + S), V_FECHA, V_TIPO_PAGO)
        RETURNING ID_COMPRA INTO V_ID_COMPRA;

        -- 14 productos por compra (uno de cada tres del catalogo)
        FOR P IN 1..42 LOOP
            IF MOD(P + S, 3) = 0 THEN
                SELECT PRECIO_COSTO, EXISTENCIA_MINIMA INTO V_COSTO, V_MINIMA FROM PRODUCTO_9255 WHERE ID_PRODUCTO = P;
                INSERT INTO DETALLE_COMPRA_9255 (ID_COMPRA, ID_PRODUCTO, CANTIDAD, COSTO_UNITARIO)
                VALUES (V_ID_COMPRA, P, V_MINIMA * 2 + 10, ROUND(V_COSTO / V_TC, 2));
            END IF;
        END LOOP;

        PRC_RECIBIR_COMPRA_9255(V_ID_COMPRA, 4 + (S - 1) * 7 + 4, V_FECHA + 2);
    END LOOP;

    -- Se paga por transferencia todo lo que vencia antes de octubre
    FOR C IN (SELECT ID_CUENTA_PAGAR, SALDO, FECHA_VENCIMIENTO FROM CUENTA_POR_PAGAR_9255) LOOP
        IF C.FECHA_VENCIMIENTO < DATE '2026-10-01' THEN
            INSERT INTO PAGO_PROVEEDOR_9255 (ID_CUENTA_PAGAR, ID_FORMA_PAGO, FECHA_PAGO, MONTO, NUMERO_REFERENCIA, BANCO)
            VALUES (C.ID_CUENTA_PAGAR, 3, C.FECHA_VENCIMIENTO, C.SALDO, 'TRF-' || C.ID_CUENTA_PAGAR, 'Banco Industrial');
        END IF;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Compras registradas y recibidas.');
END;
/

-- --------------------------------------------------------------------------------
-- 3. VENTAS: dos facturas por dia, de lunes a sabado, del 5 de enero al 19 de octubre
--    Cada factura se arma igual que en la aplicacion:
--    INSERT del encabezado -> INSERT de cada producto -> pago -> PRC_CERRAR_FACTURA
-- --------------------------------------------------------------------------------
DECLARE
    V_DIA        DATE := DATE '2026-01-05';
    V_FECHA      DATE;
    V_SUCURSAL   NUMBER;
    V_PAIS       NUMBER;
    V_REGION     NUMBER;
    V_CLIENTE    NUMBER;
    V_VENDEDOR   NUMBER;
    V_TIPO_VENTA VARCHAR2(10);
    V_ENTREGA    VARCHAR2(10);
    V_ID_FACTURA NUMBER;
    V_LINEAS     NUMBER;
    V_PRODUCTO   NUMBER;
    V_MINIMA     NUMBER;
    V_CANTIDAD   NUMBER;
    V_TOTAL      NUMBER(12,2);
    V_LIMITE     NUMBER(12,2);
    V_FORMA      NUMBER;
    V_REFERENCIA VARCHAR2(40);
    V_FACTURAS   NUMBER := 0;
BEGIN
    WHILE V_DIA <= DATE '2026-10-19' LOOP
        -- Los domingos no se abre
        IF TO_CHAR(V_DIA, 'DY', 'NLS_DATE_LANGUAGE=SPANISH') <> 'DOM' THEN
            FOR K IN 1..2 LOOP
                -- Sucursal al azar y su pais (sucursales 1-4 GT, 5-8 SV, 9-12 HN)
                V_SUCURSAL := TRUNC(DBMS_RANDOM.VALUE(1, 13));
                V_PAIS     := CEIL(V_SUCURSAL / 4);
                V_VENDEDOR := 4 + (V_SUCURSAL - 1) * 7 + TRUNC(DBMS_RANDOM.VALUE(1, 3));

                -- Cliente: 15% consumidor final; si no, un cliente de la region (70%) o del pais
                IF DBMS_RANDOM.VALUE < 0.15 THEN
                    V_CLIENTE := 48 + V_PAIS;
                ELSE
                    IF DBMS_RANDOM.VALUE < 0.7 THEN
                        V_REGION := V_SUCURSAL;
                    ELSE
                        V_REGION := (V_PAIS - 1) * 4 + TRUNC(DBMS_RANDOM.VALUE(1, 5));
                    END IF;
                    V_CLIENTE := (V_REGION - 1) * 4 + TRUNC(DBMS_RANDOM.VALUE(1, 5));
                END IF;

                SELECT LIMITE_CREDITO INTO V_LIMITE FROM CLIENTE_9255 WHERE ID_CLIENTE = V_CLIENTE;
                IF V_LIMITE > 0 AND DBMS_RANDOM.VALUE < 0.45 THEN
                    V_TIPO_VENTA := 'CREDITO';
                ELSE
                    V_TIPO_VENTA := 'CONTADO';
                END IF;
                -- El consumidor final no tiene direccion registrada: se lleva su mercaderia
                IF DBMS_RANDOM.VALUE < 0.3 AND V_CLIENTE <= 48 THEN
                    V_ENTREGA := 'EMPRESA';
                ELSE
                    V_ENTREGA := 'CLIENTE';
                END IF;

                V_FECHA := V_DIA + TRUNC(DBMS_RANDOM.VALUE(8, 18)) / 24 + TRUNC(DBMS_RANDOM.VALUE(0, 60)) / 1440;

                -- Encabezado (la serie, el numero y el impuesto los pone TRG_BIR_FACTURA_9255)
                INSERT INTO FACTURA_9255 (ID_SUCURSAL, ID_BODEGA, ID_CLIENTE, ID_EMPLEADO, FECHA_EMISION, TIPO_VENTA, TIPO_ENTREGA)
                VALUES (V_SUCURSAL, V_SUCURSAL, V_CLIENTE, V_VENDEDOR, V_FECHA, V_TIPO_VENTA, V_ENTREGA)
                RETURNING ID_FACTURA INTO V_ID_FACTURA;

                -- De 1 a 4 productos. Los primeros del catalogo se venden mas.
                V_LINEAS := TRUNC(DBMS_RANDOM.VALUE(1, 5));
                FOR L IN 1..V_LINEAS LOOP
                    V_PRODUCTO := TRUNC(42 * POWER(DBMS_RANDOM.VALUE, 1.7)) + 1;
                    SELECT EXISTENCIA_MINIMA INTO V_MINIMA FROM PRODUCTO_9255 WHERE ID_PRODUCTO = V_PRODUCTO;
                    IF V_MINIMA >= 100 THEN
                        V_CANTIDAD := 10 * TRUNC(DBMS_RANDOM.VALUE(1, 9));
                    ELSIF V_MINIMA >= 30 THEN
                        V_CANTIDAD := TRUNC(DBMS_RANDOM.VALUE(2, 13));
                    ELSE
                        V_CANTIDAD := TRUNC(DBMS_RANDOM.VALUE(1, 4));
                    END IF;
                    -- Solo se agrega si hay existencia (si no, el disparador la rechazaria)
                    IF FN_EXISTENCIA_9255(V_SUCURSAL, V_PRODUCTO) >= V_CANTIDAD THEN
                        INSERT INTO DETALLE_FACTURA_9255 (ID_FACTURA, ID_PRODUCTO, CANTIDAD)
                        VALUES (V_ID_FACTURA, V_PRODUCTO, V_CANTIDAD);
                    END IF;
                END LOOP;

                -- Si ningun producto tenia existencia, se agrega una unidad de uno que si tenga
                SELECT COUNT(*) INTO V_LINEAS FROM DETALLE_FACTURA_9255 WHERE ID_FACTURA = V_ID_FACTURA;
                IF V_LINEAS = 0 THEN
                    FOR P IN 1..42 LOOP
                        IF V_LINEAS = 0 AND FN_EXISTENCIA_9255(V_SUCURSAL, P) >= 1 THEN
                            INSERT INTO DETALLE_FACTURA_9255 (ID_FACTURA, ID_PRODUCTO, CANTIDAD)
                            VALUES (V_ID_FACTURA, P, 1);
                            V_LINEAS := 1;
                        END IF;
                    END LOOP;
                END IF;

                SELECT TOTAL INTO V_TOTAL FROM FACTURA_9255 WHERE ID_FACTURA = V_ID_FACTURA;

                -- Si al credito se pasaria del limite, se cobra al contado
                IF V_TIPO_VENTA = 'CREDITO' AND FN_SALDO_CLIENTE_9255(V_CLIENTE) + V_TOTAL > V_LIMITE THEN
                    V_TIPO_VENTA := 'CONTADO';
                    UPDATE FACTURA_9255 SET TIPO_VENTA = 'CONTADO' WHERE ID_FACTURA = V_ID_FACTURA;
                END IF;

                IF V_TIPO_VENTA = 'CONTADO' THEN
                    IF DBMS_RANDOM.VALUE < 0.55 THEN
                        V_FORMA := 1;
                        V_REFERENCIA := NULL;
                    ELSE
                        V_FORMA := TRUNC(DBMS_RANDOM.VALUE(2, 5));
                        V_REFERENCIA := TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(10000000, 99999999)));
                    END IF;
                    INSERT INTO PAGO_FACTURA_9255 (ID_FACTURA, ID_FORMA_PAGO, FECHA_PAGO, MONTO, NUMERO_REFERENCIA)
                    VALUES (V_ID_FACTURA, V_FORMA, V_FECHA, V_TOTAL, V_REFERENCIA);
                END IF;

                PRC_CERRAR_FACTURA_9255(V_ID_FACTURA);
                V_FACTURAS := V_FACTURAS + 1;
            END LOOP;
        END IF;
        V_DIA := V_DIA + 1;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Facturas emitidas: ' || V_FACTURAS);
END;
/

-- --------------------------------------------------------------------------------
-- 4. ABONOS: la mitad de las cuentas se paga completa y una cuarta parte a medias
-- --------------------------------------------------------------------------------
DECLARE
    V_FECHA DATE;
    V_AZAR  NUMBER;
BEGIN
    FOR C IN (SELECT ID_CUENTA_COBRAR, SALDO, FECHA_EMISION FROM CUENTA_POR_COBRAR_9255 ORDER BY ID_CUENTA_COBRAR) LOOP
        V_FECHA := C.FECHA_EMISION + TRUNC(DBMS_RANDOM.VALUE(3, 26)) + 10 / 24;
        V_AZAR  := DBMS_RANDOM.VALUE;
        IF V_FECHA < DATE '2026-10-20' THEN
            IF V_AZAR < 0.5 THEN
                INSERT INTO ABONO_CLIENTE_9255 (ID_CUENTA_COBRAR, ID_FORMA_PAGO, FECHA_ABONO, MONTO, NUMERO_REFERENCIA, BANCO)
                VALUES (C.ID_CUENTA_COBRAR, 3, V_FECHA, C.SALDO, 'TRF-' || C.ID_CUENTA_COBRAR, 'Banco Industrial');
            ELSIF V_AZAR < 0.75 THEN
                INSERT INTO ABONO_CLIENTE_9255 (ID_CUENTA_COBRAR, ID_FORMA_PAGO, FECHA_ABONO, MONTO)
                VALUES (C.ID_CUENTA_COBRAR, 1, V_FECHA, ROUND(C.SALDO / 2, 2));
            END IF;
        END IF;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Abonos registrados.');
END;
/

-- --------------------------------------------------------------------------------
-- 5. ENVIOS: cada factura con entrega a cargo de la empresa se envia al dia siguiente
--    con el vehiculo y el piloto de su sucursal. Los de antes del 17 de octubre ya
--    se entregaron; los demas quedan programados.
-- --------------------------------------------------------------------------------
DECLARE
    V_ID_ENVIO NUMBER;
BEGIN
    FOR F IN (SELECT ID_FACTURA, ID_SUCURSAL, FECHA_EMISION
                FROM FACTURA_9255
               WHERE TIPO_ENTREGA = 'EMPRESA'
               ORDER BY FECHA_EMISION) LOOP
        INSERT INTO ENVIO_9255 (ID_FACTURA, ID_VEHICULO, ID_PILOTO, ID_EMPLEADO_RESPONSABLE, FECHA_PROGRAMADA)
        VALUES (F.ID_FACTURA, F.ID_SUCURSAL, F.ID_SUCURSAL,
                CASE WHEN MOD(F.ID_FACTURA, 4) = 0 THEN 4 + (F.ID_SUCURSAL - 1) * 7
                     ELSE 4 + (F.ID_SUCURSAL - 1) * 7 + 5 END,
                TRUNC(F.FECHA_EMISION) + 1)
        RETURNING ID_ENVIO INTO V_ID_ENVIO;

        IF F.FECHA_EMISION < DATE '2026-10-17' THEN
            UPDATE ENVIO_9255 SET ESTADO = 'EN_RUTA',   FECHA_SALIDA  = TRUNC(F.FECHA_EMISION) + 1 + 8 / 24  WHERE ID_ENVIO = V_ID_ENVIO;
            UPDATE ENVIO_9255 SET ESTADO = 'ENTREGADO', FECHA_ENTREGA = TRUNC(F.FECHA_EMISION) + 1 + 13 / 24 WHERE ID_ENVIO = V_ID_ENVIO;
        END IF;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Envios registrados.');
END;
/

-- --------------------------------------------------------------------------------
-- 6. NOTAS DE CREDITO por descuento (5% de la factura), autorizadas por el gerente
-- --------------------------------------------------------------------------------
BEGIN
    FOR F IN (SELECT ID_FACTURA, ID_SUCURSAL, ID_EMPLEADO, TOTAL, FECHA_EMISION
                FROM FACTURA_9255
               WHERE MOD(ID_FACTURA, 61) = 7 AND FECHA_EMISION < DATE '2026-10-15') LOOP
        INSERT INTO NOTA_CREDITO_9255 (ID_FACTURA, ID_EMPLEADO, ID_EMPLEADO_AUTORIZA, FECHA_EMISION, TIPO, MOTIVO, MONTO)
        VALUES (F.ID_FACTURA, F.ID_EMPLEADO, 4 + (F.ID_SUCURSAL - 1) * 7, F.FECHA_EMISION + 2,
                'DESCUENTO', 'Descuento por volumen autorizado despues de la venta', ROUND(F.TOTAL * 0.05, 2));
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Notas de credito por descuento registradas.');
END;
/

-- --------------------------------------------------------------------------------
-- 7. DEVOLUCIONES: se devuelve 1 unidad del primer producto de algunas facturas
-- --------------------------------------------------------------------------------
DECLARE
    V_ID_DEVOLUCION NUMBER;
    V_ESTADO        VARCHAR2(10);
BEGIN
    FOR F IN (SELECT F.ID_FACTURA, F.ID_SUCURSAL, F.ID_EMPLEADO, F.FECHA_EMISION, MIN(D.ID_DETALLE_FACTURA) AS ID_DETALLE
                FROM FACTURA_9255 F
               INNER JOIN DETALLE_FACTURA_9255 D ON D.ID_FACTURA = F.ID_FACTURA
               WHERE MOD(F.ID_FACTURA, 53) = 11 AND F.FECHA_EMISION < DATE '2026-10-15'
               GROUP BY F.ID_FACTURA, F.ID_SUCURSAL, F.ID_EMPLEADO, F.FECHA_EMISION) LOOP
        IF MOD(F.ID_FACTURA, 3) = 1 THEN
            V_ESTADO := 'DANADO';
        ELSE
            V_ESTADO := 'BUENO';
        END IF;

        INSERT INTO DEVOLUCION_9255 (ID_FACTURA, ID_EMPLEADO, FECHA_DEVOLUCION, MOTIVO)
        VALUES (F.ID_FACTURA, F.ID_EMPLEADO, F.FECHA_EMISION + 3,
                CASE V_ESTADO WHEN 'DANADO' THEN 'Producto con defecto de fabrica' ELSE 'El cliente compro una medida equivocada' END)
        RETURNING ID_DEVOLUCION INTO V_ID_DEVOLUCION;

        INSERT INTO DETALLE_DEVOLUCION_9255 (ID_DEVOLUCION, ID_DETALLE_FACTURA, CANTIDAD, ESTADO_PRODUCTO)
        VALUES (V_ID_DEVOLUCION, F.ID_DETALLE, 1, V_ESTADO);

        PRC_APROBAR_DEVOLUCION_9255(V_ID_DEVOLUCION, 4 + (F.ID_SUCURSAL - 1) * 7, F.FECHA_EMISION + 3);
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Devoluciones registradas.');
END;
/

-- --------------------------------------------------------------------------------
-- 8. RECLAMOS DE GARANTIA a los 30 dias de la compra; la mitad ya resueltos
-- --------------------------------------------------------------------------------
DECLARE
    V_ID_RECLAMO NUMBER;
BEGIN
    FOR D IN (SELECT D.ID_DETALLE_FACTURA, F.ID_EMPLEADO, F.FECHA_EMISION
                FROM DETALLE_FACTURA_9255 D
               INNER JOIN FACTURA_9255 F ON F.ID_FACTURA = D.ID_FACTURA
               WHERE D.FECHA_FIN_GARANTIA IS NOT NULL
                 AND MOD(D.ID_DETALLE_FACTURA, 47) = 5
                 AND F.FECHA_EMISION < DATE '2026-09-15') LOOP
        INSERT INTO RECLAMO_GARANTIA_9255 (ID_DETALLE_FACTURA, ID_EMPLEADO, FECHA_RECLAMO, DESCRIPCION_FALLA)
        VALUES (D.ID_DETALLE_FACTURA, D.ID_EMPLEADO, D.FECHA_EMISION + 30, 'El producto dejo de funcionar con poco uso')
        RETURNING ID_RECLAMO INTO V_ID_RECLAMO;

        IF MOD(D.ID_DETALLE_FACTURA, 2) = 0 THEN
            UPDATE RECLAMO_GARANTIA_9255
               SET ESTADO = 'REPARADO', FECHA_RESOLUCION = D.FECHA_EMISION + 40,
                   RESOLUCION = 'Revisado y reparado por el taller del proveedor'
             WHERE ID_RECLAMO = V_ID_RECLAMO;
        END IF;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Reclamos de garantia registrados.');
END;
/

-- --------------------------------------------------------------------------------
-- 9. BAJAS DE INVENTARIO (tipo 4 = BAJA), autorizadas por el gerente de la sucursal
-- --------------------------------------------------------------------------------
INSERT INTO MOVIMIENTO_INVENTARIO_9255 (ID_TIPO_MOVIMIENTO, ID_BODEGA, ID_PRODUCTO, CANTIDAD, COSTO_UNITARIO, ID_MOTIVO_BAJA, ID_EMPLEADO, ID_EMPLEADO_AUTORIZA, FECHA_MOVIMIENTO, DOCUMENTO_REFERENCIA)
VALUES (4, 1, 22, 2, 12, 1, 8, 4, DATE '2026-02-20', 'ACTA DE BAJA 001');
INSERT INTO MOVIMIENTO_INVENTARIO_9255 (ID_TIPO_MOVIMIENTO, ID_BODEGA, ID_PRODUCTO, CANTIDAD, COSTO_UNITARIO, ID_MOTIVO_BAJA, ID_EMPLEADO, ID_EMPLEADO_AUTORIZA, FECHA_MOVIMIENTO, DOCUMENTO_REFERENCIA)
VALUES (4, 2, 29, 1, 110, 1, 15, 11, DATE '2026-03-14', 'ACTA DE BAJA 002');
INSERT INTO MOVIMIENTO_INVENTARIO_9255 (ID_TIPO_MOVIMIENTO, ID_BODEGA, ID_PRODUCTO, CANTIDAD, COSTO_UNITARIO, ID_MOTIVO_BAJA, ID_EMPLEADO, ID_EMPLEADO_AUTORIZA, FECHA_MOVIMIENTO, DOCUMENTO_REFERENCIA)
VALUES (4, 5, 8, 1, 520, 3, 36, 32, DATE '2026-04-08', 'ACTA DE BAJA 003');
INSERT INTO MOVIMIENTO_INVENTARIO_9255 (ID_TIPO_MOVIMIENTO, ID_BODEGA, ID_PRODUCTO, CANTIDAD, COSTO_UNITARIO, ID_MOTIVO_BAJA, ID_EMPLEADO, ID_EMPLEADO_AUTORIZA, FECHA_MOVIMIENTO, DOCUMENTO_REFERENCIA)
VALUES (4, 7, 13, 3, 70, 2, 50, 46, DATE '2026-05-22', 'ACTA DE BAJA 004');
INSERT INTO MOVIMIENTO_INVENTARIO_9255 (ID_TIPO_MOVIMIENTO, ID_BODEGA, ID_PRODUCTO, CANTIDAD, COSTO_UNITARIO, ID_MOTIVO_BAJA, ID_EMPLEADO, ID_EMPLEADO_AUTORIZA, FECHA_MOVIMIENTO, DOCUMENTO_REFERENCIA)
VALUES (4, 9, 37, 1, 85, 4, 64, 60, DATE '2026-06-30', 'ACTA DE BAJA 005');
INSERT INTO MOVIMIENTO_INVENTARIO_9255 (ID_TIPO_MOVIMIENTO, ID_BODEGA, ID_PRODUCTO, CANTIDAD, COSTO_UNITARIO, ID_MOTIVO_BAJA, ID_EMPLEADO, ID_EMPLEADO_AUTORIZA, FECHA_MOVIMIENTO, DOCUMENTO_REFERENCIA)
VALUES (4, 12, 12, 1, 390, 5, 85, 81, DATE '2026-08-17', 'ACTA DE BAJA 006');
COMMIT;

-- --------------------------------------------------------------------------------
-- 10. TRASLADOS entre sucursales del mismo pais
-- --------------------------------------------------------------------------------
BEGIN
    PRC_TRASLADAR_PRODUCTO_9255(1, 2, 13, 20, 8,  DATE '2026-04-10');
    PRC_TRASLADAR_PRODUCTO_9255(3, 4, 15, 100, 22, DATE '2026-05-12');
    PRC_TRASLADAR_PRODUCTO_9255(5, 6, 1, 5, 36,  DATE '2026-06-15');
    PRC_TRASLADAR_PRODUCTO_9255(7, 8, 24, 10, 50, DATE '2026-07-20');
    PRC_TRASLADAR_PRODUCTO_9255(9, 10, 19, 50, 64, DATE '2026-08-05');
    PRC_TRASLADAR_PRODUCTO_9255(11, 12, 29, 4, 78, DATE '2026-09-09');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Traslados registrados. Carga de datos terminada.');
END;
/
