-- ================================================================================
-- FERRETERIA MR. NATSUKY'S - FUNCIONES Y PROCEDIMIENTOS
-- Curso: Base de Datos, seccion A - Ing. Kalki Ramirez
-- Alumno: Brandon Emmanuel Paz Alvarez - Carne 3190-24-9255
-- Ejecutar conectado como c##FERRETERIA_9255, despues de 02_tablas.sql
-- ================================================================================


-- --------------------------------------------------------------------------------
-- FN_USUARIO_9255
-- Devuelve el usuario que esta trabajando, para las columnas de auditoria.
-- La aplicacion web se conecta siempre con c##FERRETERIA_9255, pero le indica a
-- Oracle el nombre del usuario que inicio sesion (por ejemplo "vendedor").
-- Oracle lo guarda en SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER').
-- Si no viene (por ejemplo, desde SQL Developer), se usa USER, como en clase.
-- --------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION FN_USUARIO_9255 RETURN VARCHAR2 IS
BEGIN
    RETURN NVL(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'), USER);
END;
/

-- --------------------------------------------------------------------------------
-- FN_EXISTENCIA_9255
-- Devuelve la existencia de un producto en una bodega (0 si no tiene registro).
-- --------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION FN_EXISTENCIA_9255 (P_ID_BODEGA IN NUMBER, P_ID_PRODUCTO IN NUMBER) RETURN NUMBER IS
    V_EXISTENCIA NUMBER(12,2);
BEGIN
    SELECT EXISTENCIA
      INTO V_EXISTENCIA
      FROM INVENTARIO_9255
     WHERE ID_BODEGA = P_ID_BODEGA
       AND ID_PRODUCTO = P_ID_PRODUCTO;
    RETURN V_EXISTENCIA;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/

-- --------------------------------------------------------------------------------
-- FN_SALDO_CLIENTE_9255
-- Devuelve cuanto debe un cliente en total (suma de sus cuentas por cobrar pendientes).
-- --------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION FN_SALDO_CLIENTE_9255 (P_ID_CLIENTE IN NUMBER) RETURN NUMBER IS
    V_SALDO NUMBER(12,2);
BEGIN
    SELECT NVL(SUM(SALDO), 0)
      INTO V_SALDO
      FROM CUENTA_POR_COBRAR_9255
     WHERE ID_CLIENTE = P_ID_CLIENTE
       AND ESTADO = 'PENDIENTE';
    RETURN V_SALDO;
END;
/

-- --------------------------------------------------------------------------------
-- PRC_REGISTRA_MOV_INVENTARIO_9255
-- Registra un movimiento de inventario de un producto (como PRC_REGISTRA_MOV_INVENTARIO
-- de clase). El disparador TRG_AIR_MOVIMIENTO_INVENTARIO_9255 actualiza la existencia.
-- P_CODIGO_TIPO: INVENTARIO_INICIAL, INGRESO_COMPRA, SALIDA_VENTA, BAJA,
--                SALIDA_TRASLADO, INGRESO_TRASLADO, INGRESO_DEVOLUCION,
--                AJUSTE_ENTRADA, AJUSTE_SALIDA
-- --------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE PRC_REGISTRA_MOV_INVENTARIO_9255 (
    P_CODIGO_TIPO IN VARCHAR2,
    P_ID_BODEGA   IN NUMBER,
    P_ID_PRODUCTO IN NUMBER,
    P_CANTIDAD    IN NUMBER,
    P_COSTO       IN NUMBER,
    P_ID_EMPLEADO IN NUMBER,
    P_REFERENCIA  IN VARCHAR2,
    P_FECHA       IN DATE DEFAULT SYSDATE
) IS
    V_ID_TIPO NUMBER;
BEGIN
    BEGIN
        SELECT ID_TIPO_MOVIMIENTO
          INTO V_ID_TIPO
          FROM TIPO_MOVIMIENTO_9255
         WHERE CODIGO = P_CODIGO_TIPO;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20100, 'No existe el tipo de movimiento ' || P_CODIGO_TIPO);
    END;

    INSERT INTO MOVIMIENTO_INVENTARIO_9255
        (ID_TIPO_MOVIMIENTO, ID_BODEGA, ID_PRODUCTO, CANTIDAD, COSTO_UNITARIO, ID_EMPLEADO,
         FECHA_MOVIMIENTO, DOCUMENTO_REFERENCIA)
    VALUES
        (V_ID_TIPO, P_ID_BODEGA, P_ID_PRODUCTO, P_CANTIDAD, P_COSTO, P_ID_EMPLEADO,
         P_FECHA, P_REFERENCIA);
END;
/

-- --------------------------------------------------------------------------------
-- PRC_TRASLADAR_PRODUCTO_9255
-- Traslada producto de una bodega a otra: una salida en el origen y un ingreso en
-- el destino. Si no hay existencia, el disparador rechaza la salida y no se hace nada.
-- --------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE PRC_TRASLADAR_PRODUCTO_9255 (
    P_ID_BODEGA_ORIGEN  IN NUMBER,
    P_ID_BODEGA_DESTINO IN NUMBER,
    P_ID_PRODUCTO       IN NUMBER,
    P_CANTIDAD          IN NUMBER,
    P_ID_EMPLEADO       IN NUMBER,
    P_FECHA             IN DATE DEFAULT SYSDATE
) IS
    V_COSTO NUMBER(12,2);
BEGIN
    IF P_ID_BODEGA_ORIGEN = P_ID_BODEGA_DESTINO THEN
        RAISE_APPLICATION_ERROR(-20101, 'La bodega de origen y la de destino deben ser distintas.');
    END IF;

    SELECT PRECIO_COSTO INTO V_COSTO FROM PRODUCTO_9255 WHERE ID_PRODUCTO = P_ID_PRODUCTO;

    PRC_REGISTRA_MOV_INVENTARIO_9255('SALIDA_TRASLADO', P_ID_BODEGA_ORIGEN, P_ID_PRODUCTO, P_CANTIDAD,
                                     V_COSTO, P_ID_EMPLEADO, 'TRASLADO A BODEGA ' || P_ID_BODEGA_DESTINO, P_FECHA);
    PRC_REGISTRA_MOV_INVENTARIO_9255('INGRESO_TRASLADO', P_ID_BODEGA_DESTINO, P_ID_PRODUCTO, P_CANTIDAD,
                                     V_COSTO, P_ID_EMPLEADO, 'TRASLADO DE BODEGA ' || P_ID_BODEGA_ORIGEN, P_FECHA);
END;
/

-- --------------------------------------------------------------------------------
-- PRC_CERRAR_FACTURA_9255
-- Se llama despues de insertar el encabezado, los productos y (si es al contado)
-- los pagos. Revisa las reglas y deja la factura EMITIDA:
--   - Contado: la suma de los pagos debe ser igual al total.
--   - Credito: el cliente debe tener credito y no pasarse de su limite;
--              se crea la cuenta por cobrar.
-- Una vez EMITIDA, la factura ya no se puede modificar ni anular.
-- --------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE PRC_CERRAR_FACTURA_9255 (P_ID_FACTURA IN NUMBER) IS
    V_ESTADO       VARCHAR2(15);
    V_TIPO_VENTA   VARCHAR2(10);
    V_TOTAL        NUMBER(12,2);
    V_ID_CLIENTE   NUMBER;
    V_FECHA        DATE;
    V_PRODUCTOS    NUMBER;
    V_PAGADO       NUMBER(12,2);
    V_LIMITE       NUMBER(12,2);
    V_DIAS         NUMBER;
BEGIN
    SELECT ESTADO, TIPO_VENTA, TOTAL, ID_CLIENTE, FECHA_EMISION
      INTO V_ESTADO, V_TIPO_VENTA, V_TOTAL, V_ID_CLIENTE, V_FECHA
      FROM FACTURA_9255
     WHERE ID_FACTURA = P_ID_FACTURA;

    IF V_ESTADO <> 'EN_PROCESO' THEN
        RAISE_APPLICATION_ERROR(-20110, 'La factura ya fue emitida.');
    END IF;

    SELECT COUNT(*) INTO V_PRODUCTOS FROM DETALLE_FACTURA_9255 WHERE ID_FACTURA = P_ID_FACTURA;
    IF V_PRODUCTOS = 0 THEN
        RAISE_APPLICATION_ERROR(-20111, 'La factura no tiene productos.');
    END IF;

    IF V_TIPO_VENTA = 'CONTADO' THEN
        SELECT NVL(SUM(MONTO), 0) INTO V_PAGADO FROM PAGO_FACTURA_9255 WHERE ID_FACTURA = P_ID_FACTURA;
        IF V_PAGADO <> V_TOTAL THEN
            RAISE_APPLICATION_ERROR(-20112, 'Los pagos (' || V_PAGADO || ') no cuadran con el total de la factura (' || V_TOTAL || ').');
        END IF;
    ELSE
        SELECT LIMITE_CREDITO, DIAS_CREDITO INTO V_LIMITE, V_DIAS FROM CLIENTE_9255 WHERE ID_CLIENTE = V_ID_CLIENTE;
        IF V_LIMITE = 0 THEN
            RAISE_APPLICATION_ERROR(-20113, 'El cliente no tiene credito autorizado.');
        END IF;
        IF FN_SALDO_CLIENTE_9255(V_ID_CLIENTE) + V_TOTAL > V_LIMITE THEN
            RAISE_APPLICATION_ERROR(-20114, 'La venta supera el limite de credito del cliente. Disponible: '
                                    || (V_LIMITE - FN_SALDO_CLIENTE_9255(V_ID_CLIENTE)));
        END IF;
        INSERT INTO CUENTA_POR_COBRAR_9255
            (ID_FACTURA, ID_CLIENTE, MONTO_TOTAL, SALDO, FECHA_EMISION, FECHA_VENCIMIENTO)
        VALUES
            (P_ID_FACTURA, V_ID_CLIENTE, V_TOTAL, V_TOTAL, TRUNC(V_FECHA), TRUNC(V_FECHA) + V_DIAS);
    END IF;

    UPDATE FACTURA_9255 SET ESTADO = 'EMITIDA' WHERE ID_FACTURA = P_ID_FACTURA;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20115, 'No existe la factura ' || P_ID_FACTURA);
END;
/

-- --------------------------------------------------------------------------------
-- PRC_RECIBIR_COMPRA_9255
-- Cuando llega la mercaderia: ingresa a bodega cada producto de la compra y,
-- si la compra es al credito, crea la cuenta por pagar.
-- --------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE PRC_RECIBIR_COMPRA_9255 (
    P_ID_COMPRA   IN NUMBER,
    P_ID_EMPLEADO IN NUMBER,
    P_FECHA       IN DATE DEFAULT SYSDATE
) IS
    V_ESTADO      VARCHAR2(15);
    V_BODEGA      NUMBER;
    V_TIPO_PAGO   VARCHAR2(10);
    V_TOTAL       NUMBER(12,2);
    V_TIPO_CAMBIO NUMBER(10,4);
    V_DIAS        NUMBER;
BEGIN
    SELECT C.ESTADO, C.ID_BODEGA_DESTINO, C.TIPO_PAGO, C.TOTAL, C.TIPO_CAMBIO_QUETZAL, P.DIAS_CREDITO
      INTO V_ESTADO, V_BODEGA, V_TIPO_PAGO, V_TOTAL, V_TIPO_CAMBIO, V_DIAS
      FROM COMPRA_9255 C
      JOIN PROVEEDOR_9255 P ON P.ID_PROVEEDOR = C.ID_PROVEEDOR
     WHERE C.ID_COMPRA = P_ID_COMPRA;

    IF V_ESTADO <> 'PENDIENTE' THEN
        RAISE_APPLICATION_ERROR(-20120, 'Solo se pueden recibir compras en estado PENDIENTE.');
    END IF;

    -- Ingreso a bodega de cada producto (el costo se guarda en quetzales)
    FOR D IN (SELECT ID_PRODUCTO, CANTIDAD, COSTO_UNITARIO
                FROM DETALLE_COMPRA_9255
               WHERE ID_COMPRA = P_ID_COMPRA) LOOP
        PRC_REGISTRA_MOV_INVENTARIO_9255('INGRESO_COMPRA', V_BODEGA, D.ID_PRODUCTO, D.CANTIDAD,
                                         ROUND(D.COSTO_UNITARIO * V_TIPO_CAMBIO, 2), P_ID_EMPLEADO,
                                         'COMPRA ' || P_ID_COMPRA, P_FECHA);
    END LOOP;

    UPDATE COMPRA_9255
       SET ESTADO = 'RECIBIDA',
           FECHA_RECEPCION = P_FECHA
     WHERE ID_COMPRA = P_ID_COMPRA;

    IF V_TIPO_PAGO = 'CREDITO' THEN
        INSERT INTO CUENTA_POR_PAGAR_9255 (ID_COMPRA, MONTO_TOTAL, SALDO, FECHA_EMISION, FECHA_VENCIMIENTO)
        VALUES (P_ID_COMPRA, V_TOTAL, V_TOTAL, TRUNC(P_FECHA), TRUNC(P_FECHA) + V_DIAS);
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20121, 'No existe la compra ' || P_ID_COMPRA);
END;
/

-- --------------------------------------------------------------------------------
-- PRC_APROBAR_DEVOLUCION_9255
-- Aprueba una devolucion: emite la nota de credito por el monto devuelto.
-- (El reingreso a bodega de los productos en buen estado ya lo hizo el disparador
--  al registrar cada producto devuelto.)
-- --------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE PRC_APROBAR_DEVOLUCION_9255 (
    P_ID_DEVOLUCION        IN NUMBER,
    P_ID_EMPLEADO_AUTORIZA IN NUMBER,
    P_FECHA                IN DATE DEFAULT SYSDATE
) IS
    V_ESTADO      VARCHAR2(15);
    V_ID_FACTURA  NUMBER;
    V_ID_EMPLEADO NUMBER;
    V_MOTIVO      VARCHAR2(300);
    V_MONTO       NUMBER(12,2);
    V_ID_NOTA     NUMBER;
BEGIN
    SELECT ESTADO, ID_FACTURA, ID_EMPLEADO, MOTIVO, MONTO
      INTO V_ESTADO, V_ID_FACTURA, V_ID_EMPLEADO, V_MOTIVO, V_MONTO
      FROM DEVOLUCION_9255
     WHERE ID_DEVOLUCION = P_ID_DEVOLUCION;

    IF V_ESTADO <> 'PENDIENTE' THEN
        RAISE_APPLICATION_ERROR(-20130, 'La devolucion ya fue aprobada.');
    END IF;
    IF V_MONTO <= 0 THEN
        RAISE_APPLICATION_ERROR(-20131, 'La devolucion no tiene productos.');
    END IF;

    -- La serie y el numero de la nota los asigna el disparador TRG_BIR_NOTA_CREDITO_9255
    INSERT INTO NOTA_CREDITO_9255
        (ID_FACTURA, ID_EMPLEADO, ID_EMPLEADO_AUTORIZA, FECHA_EMISION, TIPO, MOTIVO, MONTO)
    VALUES
        (V_ID_FACTURA, V_ID_EMPLEADO, P_ID_EMPLEADO_AUTORIZA, P_FECHA, 'DEVOLUCION', V_MOTIVO, V_MONTO)
    RETURNING ID_NOTA_CREDITO INTO V_ID_NOTA;

    UPDATE DEVOLUCION_9255
       SET ESTADO = 'APROBADA',
           ID_NOTA_CREDITO = V_ID_NOTA
     WHERE ID_DEVOLUCION = P_ID_DEVOLUCION;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20132, 'No existe la devolucion ' || P_ID_DEVOLUCION);
END;
/
