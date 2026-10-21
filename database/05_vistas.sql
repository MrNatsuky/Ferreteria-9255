-- ================================================================================
-- FERRETERIA MR. NATSUKY'S - VISTAS PARA CONSULTAS Y REPORTES GERENCIALES
-- Curso: Base de Datos, seccion A - Ing. Kalki Ramirez
-- Alumno: Brandon Emmanuel Paz Alvarez - Carne 3190-24-9255
-- Ejecutar conectado como c##FERRETERIA_9255, despues de 04_disparadores.sql
--
-- Una vista es una consulta guardada con nombre: se usa como si fuera una tabla.
-- Los montos _QUETZALES se convierten con el tipo de cambio de cada factura,
-- para poder comparar ventas de los tres paises.
-- ================================================================================


-- --------------------------------------------------------------------------------
-- VW_FACTURAS_9255: facturas emitidas con su pais, region, sucursal, vendedor y cliente
-- --------------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_FACTURAS_9255 AS
SELECT F.ID_FACTURA,
       F.SERIE || '-' || F.NUMERO                AS NUMERO_FACTURA,
       F.FECHA_EMISION,
       F.TIPO_VENTA,
       F.TIPO_ENTREGA,
       P.NOMBRE                                  AS PAIS,
       R.NOMBRE                                  AS REGION,
       S.ID_SUCURSAL,
       S.NOMBRE                                  AS SUCURSAL,
       E.ID_EMPLEADO                             AS ID_VENDEDOR,
       E.NOMBRES || ' ' || E.APELLIDOS           AS VENDEDOR,
       C.ID_CLIENTE,
       C.NIT,
       C.NOMBRE                                  AS CLIENTE,
       F.MONEDA_CODIGO,
       F.SUBTOTAL,
       F.IMPUESTO,
       F.TOTAL,
       NVL((SELECT SUM(N.MONTO) FROM NOTA_CREDITO_9255 N WHERE N.ID_FACTURA = F.ID_FACTURA), 0) AS NOTAS_CREDITO,
       ROUND(F.TOTAL * F.TIPO_CAMBIO_QUETZAL, 2) AS TOTAL_QUETZALES
  FROM FACTURA_9255 F
 INNER JOIN SUCURSAL_9255 S ON S.ID_SUCURSAL = F.ID_SUCURSAL
 INNER JOIN REGION_9255 R   ON R.ID_REGION = S.ID_REGION
 INNER JOIN PAIS_9255 P     ON P.ID_PAIS = R.ID_PAIS
 INNER JOIN EMPLEADO_9255 E ON E.ID_EMPLEADO = F.ID_EMPLEADO
 INNER JOIN CLIENTE_9255 C  ON C.ID_CLIENTE = F.ID_CLIENTE
 WHERE F.ESTADO = 'EMITIDA';

-- --------------------------------------------------------------------------------
-- VW_VENTAS_PRODUCTO_9255: cada producto vendido (una fila por linea de factura)
-- --------------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_VENTAS_PRODUCTO_9255 AS
SELECT F.ID_FACTURA,
       F.NUMERO_FACTURA,
       F.FECHA_EMISION,
       F.PAIS,
       F.REGION,
       F.ID_SUCURSAL,
       F.SUCURSAL,
       PR.ID_PRODUCTO,
       PR.CODIGO,
       PR.NOMBRE                                 AS PRODUCTO,
       CA.NOMBRE                                 AS CATEGORIA,
       D.CANTIDAD,
       D.PRECIO_UNITARIO,
       D.SUBTOTAL,
       ROUND(D.SUBTOTAL * FA.TIPO_CAMBIO_QUETZAL, 2) AS SUBTOTAL_QUETZALES
  FROM DETALLE_FACTURA_9255 D
 INNER JOIN VW_FACTURAS_9255 F  ON F.ID_FACTURA = D.ID_FACTURA
 INNER JOIN FACTURA_9255 FA     ON FA.ID_FACTURA = D.ID_FACTURA
 INNER JOIN PRODUCTO_9255 PR    ON PR.ID_PRODUCTO = D.ID_PRODUCTO
 INNER JOIN CATEGORIA_9255 CA   ON CA.ID_CATEGORIA = PR.ID_CATEGORIA;

-- --------------------------------------------------------------------------------
-- REPORTE 1: clientes que mas compran por region
-- Uso: SELECT * FROM VW_CLIENTES_POR_REGION_9255 ORDER BY PAIS, REGION, TOTAL_QUETZALES DESC;
-- --------------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_CLIENTES_POR_REGION_9255 AS
SELECT PAIS,
       REGION,
       ID_CLIENTE,
       CLIENTE,
       COUNT(*)              AS CANTIDAD_FACTURAS,
       SUM(TOTAL_QUETZALES)  AS TOTAL_QUETZALES
  FROM VW_FACTURAS_9255
 GROUP BY PAIS, REGION, ID_CLIENTE, CLIENTE;

-- --------------------------------------------------------------------------------
-- REPORTE 2: vendedores que mas venden por area geografica
-- Uso: SELECT * FROM VW_VENDEDORES_POR_REGION_9255 ORDER BY PAIS, REGION, TOTAL_QUETZALES DESC;
-- --------------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_VENDEDORES_POR_REGION_9255 AS
SELECT PAIS,
       REGION,
       SUCURSAL,
       ID_VENDEDOR,
       VENDEDOR,
       COUNT(*)              AS CANTIDAD_FACTURAS,
       SUM(TOTAL_QUETZALES)  AS TOTAL_QUETZALES
  FROM VW_FACTURAS_9255
 GROUP BY PAIS, REGION, SUCURSAL, ID_VENDEDOR, VENDEDOR;

-- --------------------------------------------------------------------------------
-- REPORTE 3: productos mas y menos vendidos (incluye los que no se han vendido)
-- Mas vendidos:  SELECT * FROM VW_PRODUCTOS_VENDIDOS_9255 ORDER BY UNIDADES_VENDIDAS DESC;
-- Menos vendidos: SELECT * FROM VW_PRODUCTOS_VENDIDOS_9255 ORDER BY UNIDADES_VENDIDAS ASC;
-- --------------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_PRODUCTOS_VENDIDOS_9255 AS
SELECT P.ID_PRODUCTO,
       P.CODIGO,
       P.NOMBRE                             AS PRODUCTO,
       C.NOMBRE                             AS CATEGORIA,
       NVL(SUM(V.CANTIDAD), 0)              AS UNIDADES_VENDIDAS,
       NVL(SUM(V.SUBTOTAL_QUETZALES), 0)    AS TOTAL_QUETZALES
  FROM PRODUCTO_9255 P
 INNER JOIN CATEGORIA_9255 C ON C.ID_CATEGORIA = P.ID_CATEGORIA
  LEFT JOIN VW_VENTAS_PRODUCTO_9255 V ON V.ID_PRODUCTO = P.ID_PRODUCTO
 GROUP BY P.ID_PRODUCTO, P.CODIGO, P.NOMBRE, C.NOMBRE;

-- --------------------------------------------------------------------------------
-- VW_ENVIOS_9255: envios con vehiculo, piloto y responsable
-- --------------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_ENVIOS_9255 AS
SELECT EN.ID_ENVIO,
       EN.FECHA_PROGRAMADA,
       EN.FECHA_SALIDA,
       EN.FECHA_ENTREGA,
       EN.ESTADO,
       EN.DIRECCION_ENTREGA,
       P.NOMBRE                              AS PAIS,
       R.NOMBRE                              AS REGION,
       S.ID_SUCURSAL,
       S.NOMBRE                              AS SUCURSAL,
       F.SERIE || '-' || F.NUMERO            AS NUMERO_FACTURA,
       C.NOMBRE                              AS CLIENTE,
       V.PLACA,
       TP.CODIGO                             AS TIPO_PLACA,
       V.MARCA || ' ' || V.MODELO            AS VEHICULO,
       EP.NOMBRES || ' ' || EP.APELLIDOS     AS PILOTO,
       ER.NOMBRES || ' ' || ER.APELLIDOS     AS RESPONSABLE
  FROM ENVIO_9255 EN
 INNER JOIN SUCURSAL_9255 S    ON S.ID_SUCURSAL = EN.ID_SUCURSAL
 INNER JOIN REGION_9255 R      ON R.ID_REGION = S.ID_REGION
 INNER JOIN PAIS_9255 P        ON P.ID_PAIS = R.ID_PAIS
 INNER JOIN FACTURA_9255 F     ON F.ID_FACTURA = EN.ID_FACTURA
 INNER JOIN CLIENTE_9255 C     ON C.ID_CLIENTE = F.ID_CLIENTE
 INNER JOIN VEHICULO_9255 V    ON V.ID_VEHICULO = EN.ID_VEHICULO
 INNER JOIN TIPO_PLACA_9255 TP ON TP.ID_TIPO_PLACA = V.ID_TIPO_PLACA
 INNER JOIN PILOTO_9255 PI     ON PI.ID_PILOTO = EN.ID_PILOTO
 INNER JOIN EMPLEADO_9255 EP   ON EP.ID_EMPLEADO = PI.ID_EMPLEADO
 INNER JOIN EMPLEADO_9255 ER   ON ER.ID_EMPLEADO = EN.ID_EMPLEADO_RESPONSABLE;

-- --------------------------------------------------------------------------------
-- REPORTE 4: tiendas que mas envios realizan y sus responsables
-- Uso: SELECT * FROM VW_ENVIOS_POR_SUCURSAL_9255 ORDER BY TOTAL_ENVIOS DESC;
-- --------------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_ENVIOS_POR_SUCURSAL_9255 AS
SELECT PAIS,
       REGION,
       SUCURSAL,
       RESPONSABLE,
       COUNT(*)                                                AS TOTAL_ENVIOS,
       SUM(CASE WHEN ESTADO = 'ENTREGADO' THEN 1 ELSE 0 END)   AS ENTREGADOS,
       SUM(CASE WHEN ESTADO = 'PROGRAMADO' OR ESTADO = 'EN_RUTA' THEN 1 ELSE 0 END) AS PENDIENTES
  FROM VW_ENVIOS_9255
 WHERE ESTADO <> 'CANCELADO'
 GROUP BY PAIS, REGION, SUCURSAL, RESPONSABLE;

-- --------------------------------------------------------------------------------
-- REPORTE 5: ventas por mes, pais y region
-- --------------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_VENTAS_POR_MES_9255 AS
SELECT TO_CHAR(FECHA_EMISION, 'YYYY-MM')  AS MES,
       PAIS,
       REGION,
       COUNT(*)                           AS CANTIDAD_FACTURAS,
       SUM(TOTAL_QUETZALES)               AS TOTAL_QUETZALES
  FROM VW_FACTURAS_9255
 GROUP BY TO_CHAR(FECHA_EMISION, 'YYYY-MM'), PAIS, REGION;

-- --------------------------------------------------------------------------------
-- REPORTE 6: cuentas por cobrar y cuantos dias tienen de vencidas
-- --------------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_CUENTAS_POR_COBRAR_9255 AS
SELECT CC.ID_CUENTA_COBRAR,
       F.NUMERO_FACTURA,
       F.PAIS,
       F.SUCURSAL,
       F.CLIENTE,
       F.MONEDA_CODIGO,
       CC.MONTO_TOTAL,
       CC.SALDO,
       CC.FECHA_EMISION,
       CC.FECHA_VENCIMIENTO,
       CC.ESTADO,
       CASE WHEN CC.ESTADO = 'PENDIENTE' AND TRUNC(SYSDATE) > CC.FECHA_VENCIMIENTO
            THEN TRUNC(SYSDATE) - CC.FECHA_VENCIMIENTO ELSE 0 END AS DIAS_VENCIDA,
       CASE
           WHEN CC.ESTADO = 'PAGADA'                             THEN 'PAGADA'
           WHEN TRUNC(SYSDATE) <= CC.FECHA_VENCIMIENTO           THEN 'AL DIA'
           WHEN TRUNC(SYSDATE) - CC.FECHA_VENCIMIENTO <= 30      THEN '1 A 30 DIAS'
           WHEN TRUNC(SYSDATE) - CC.FECHA_VENCIMIENTO <= 60      THEN '31 A 60 DIAS'
           ELSE 'MAS DE 60 DIAS'
       END AS ANTIGUEDAD
  FROM CUENTA_POR_COBRAR_9255 CC
 INNER JOIN VW_FACTURAS_9255 F ON F.ID_FACTURA = CC.ID_FACTURA;

-- --------------------------------------------------------------------------------
-- REPORTE 7: existencias por bodega y productos por debajo del minimo
-- Bajo minimo: SELECT * FROM VW_INVENTARIO_9255 WHERE BAJO_MINIMO = 'SI';
-- --------------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_INVENTARIO_9255 AS
SELECT PA.NOMBRE                         AS PAIS,
       S.ID_SUCURSAL,
       S.NOMBRE                          AS SUCURSAL,
       B.ID_BODEGA,
       B.NOMBRE                          AS BODEGA,
       P.ID_PRODUCTO,
       P.CODIGO,
       P.NOMBRE                          AS PRODUCTO,
       I.EXISTENCIA,
       P.EXISTENCIA_MINIMA,
       CASE WHEN I.EXISTENCIA < P.EXISTENCIA_MINIMA THEN 'SI' ELSE 'NO' END AS BAJO_MINIMO,
       I.FECHA_ULTIMO_MOVIMIENTO
  FROM INVENTARIO_9255 I
 INNER JOIN BODEGA_9255 B    ON B.ID_BODEGA = I.ID_BODEGA
 INNER JOIN SUCURSAL_9255 S  ON S.ID_SUCURSAL = B.ID_SUCURSAL
 INNER JOIN REGION_9255 R    ON R.ID_REGION = S.ID_REGION
 INNER JOIN PAIS_9255 PA     ON PA.ID_PAIS = R.ID_PAIS
 INNER JOIN PRODUCTO_9255 P  ON P.ID_PRODUCTO = I.ID_PRODUCTO;

-- --------------------------------------------------------------------------------
-- VW_KARDEX_9255: historial de movimientos de inventario
-- --------------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_KARDEX_9255 AS
SELECT M.ID_MOVIMIENTO,
       M.FECHA_MOVIMIENTO,
       T.NOMBRE                          AS TIPO_MOVIMIENTO,
       T.OPERACION,
       S.NOMBRE                          AS SUCURSAL,
       B.NOMBRE                          AS BODEGA,
       P.CODIGO,
       P.NOMBRE                          AS PRODUCTO,
       M.CANTIDAD,
       MB.NOMBRE                         AS MOTIVO_BAJA,
       E.NOMBRES || ' ' || E.APELLIDOS   AS REGISTRADO_POR,
       M.DOCUMENTO_REFERENCIA
  FROM MOVIMIENTO_INVENTARIO_9255 M
 INNER JOIN TIPO_MOVIMIENTO_9255 T ON T.ID_TIPO_MOVIMIENTO = M.ID_TIPO_MOVIMIENTO
 INNER JOIN BODEGA_9255 B          ON B.ID_BODEGA = M.ID_BODEGA
 INNER JOIN SUCURSAL_9255 S        ON S.ID_SUCURSAL = B.ID_SUCURSAL
 INNER JOIN PRODUCTO_9255 P        ON P.ID_PRODUCTO = M.ID_PRODUCTO
 INNER JOIN EMPLEADO_9255 E        ON E.ID_EMPLEADO = M.ID_EMPLEADO
  LEFT JOIN MOTIVO_BAJA_9255 MB    ON MB.ID_MOTIVO_BAJA = M.ID_MOTIVO_BAJA;
