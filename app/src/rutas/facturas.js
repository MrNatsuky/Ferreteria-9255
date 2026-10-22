const express = require('express');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

router.get('/facturas', requierePermiso('FACTURAS'), async (req, res, next) => {
  try {
    const facturas = await basedatos.consultar(
      `SELECT F.ID_FACTURA, F.SERIE || '-' || F.NUMERO AS NUMERO_FACTURA,
              TO_CHAR(F.FECHA_EMISION, 'DD/MM/YYYY HH24:MI') AS FECHA,
              S.NOMBRE AS SUCURSAL, C.NOMBRE AS CLIENTE, F.TIPO_VENTA,
              F.MONEDA_CODIGO, F.TOTAL, F.ESTADO
         FROM FACTURA_9255 F
        INNER JOIN SUCURSAL_9255 S ON S.ID_SUCURSAL = F.ID_SUCURSAL
        INNER JOIN CLIENTE_9255 C ON C.ID_CLIENTE = F.ID_CLIENTE
        ORDER BY F.ID_FACTURA DESC
        FETCH FIRST 50 ROWS ONLY`
    );
    res.render('facturas', { titulo: 'Facturacion', facturas });
  } catch (error) {
    next(error);
  }
});

router.get('/facturas/nueva', requierePermiso('FACTURAS', 'crear'), async (req, res, next) => {
  try {
    const clientes = await basedatos.consultar(
      `SELECT C.ID_CLIENTE, C.NIT, C.NOMBRE
         FROM CLIENTE_9255 C
        INNER JOIN REGION_9255 RC ON RC.ID_REGION = C.ID_REGION
        INNER JOIN REGION_9255 RS ON RS.ID_PAIS = RC.ID_PAIS
        INNER JOIN SUCURSAL_9255 S ON S.ID_REGION = RS.ID_REGION
        WHERE S.ID_SUCURSAL = :sucursal
          AND C.FECHA_ELIMINACION IS NULL
        ORDER BY C.NOMBRE`,
      { sucursal: req.session.usuario.idSucursal }
    );
    res.render('factura_nueva', { titulo: 'Nueva factura', clientes, error: req.query.error || null });
  } catch (error) {
    next(error);
  }
});

router.post('/facturas', requierePermiso('FACTURAS', 'crear'), async (req, res) => {
  const usuario = req.session.usuario;
  try {
    if (req.body.entrega === 'EMPRESA' && !req.body.direccion) {
      throw new Error('Indique la direccion de entrega.');
    }

    const [cliente] = await basedatos.consultar(
      `SELECT LIMITE_CREDITO FROM CLIENTE_9255 WHERE ID_CLIENTE = :cliente`,
      { cliente: Number(req.body.cliente) }
    );
    if (req.body.venta === 'CREDITO' && cliente.LIMITE_CREDITO === 0) {
      throw new Error('El cliente no tiene credito autorizado. Solo puede comprar al contado.');
    }

    const idFactura = await basedatos.transaccion(async (conexion) => {
      const sucursal = await conexion.execute(
        `SELECT S.SERIE_FACTURA, P.PORCENTAJE_IMPUESTO, P.MONEDA_CODIGO, P.TIPO_CAMBIO_QUETZAL
           FROM SUCURSAL_9255 S
          INNER JOIN REGION_9255 R ON R.ID_REGION = S.ID_REGION
          INNER JOIN PAIS_9255 P ON P.ID_PAIS = R.ID_PAIS
          WHERE S.ID_SUCURSAL = :sucursal`,
        { sucursal: usuario.idSucursal }
      );
      const datos = sucursal.rows[0];

      await conexion.execute(
        `UPDATE SUCURSAL_9255
            SET CORRELATIVO_FACTURA = CORRELATIVO_FACTURA + 1,
                MODIFICADO_POR = :usuario
          WHERE ID_SUCURSAL = :sucursal`,
        { usuario: usuario.nombreUsuario, sucursal: usuario.idSucursal }
      );
      const correlativo = await conexion.execute(
        `SELECT CORRELATIVO_FACTURA FROM SUCURSAL_9255 WHERE ID_SUCURSAL = :sucursal`,
        { sucursal: usuario.idSucursal }
      );

      await conexion.execute(
        `INSERT INTO FACTURA_9255 (ID_SUCURSAL, ID_CLIENTE, ID_EMPLEADO, SERIE, NUMERO, TIPO_VENTA,
                                   TIPO_ENTREGA, DIRECCION_ENTREGA, PORCENTAJE_IMPUESTO, MONEDA_CODIGO,
                                   TIPO_CAMBIO_QUETZAL, OBSERVACIONES, CREADO_POR)
         VALUES (:sucursal, :cliente, :empleado, :serie, :numero, :venta,
                 :entrega, :direccion, :porcentaje, :moneda, :cambio, :observaciones, :usuario)`,
        {
          sucursal: usuario.idSucursal,
          cliente: Number(req.body.cliente),
          empleado: usuario.idEmpleado,
          serie: datos.SERIE_FACTURA,
          numero: correlativo.rows[0].CORRELATIVO_FACTURA,
          venta: req.body.venta,
          entrega: req.body.entrega,
          direccion: req.body.entrega === 'EMPRESA' ? req.body.direccion : null,
          porcentaje: datos.PORCENTAJE_IMPUESTO,
          moneda: datos.MONEDA_CODIGO,
          cambio: datos.TIPO_CAMBIO_QUETZAL,
          observaciones: req.body.observaciones,
          usuario: usuario.nombreUsuario,
        }
      );

      const nueva = await conexion.execute(`SELECT SEC_FACTURA_9255.CURRVAL AS ID FROM DUAL`);
      return nueva.rows[0].ID;
    });

    res.redirect('/facturas/' + idFactura);
  } catch (error) {
    res.redirect('/facturas/nueva?error=' + encodeURIComponent(error.message));
  }
});

router.get('/facturas/:id', requierePermiso('FACTURAS'), async (req, res, next) => {
  try {
    const id = Number(req.params.id);

    const [factura] = await basedatos.consultar(
      `SELECT F.ID_FACTURA, F.ID_SUCURSAL, F.SERIE || '-' || F.NUMERO AS NUMERO_FACTURA,
              TO_CHAR(F.FECHA_EMISION, 'DD/MM/YYYY HH24:MI') AS FECHA, F.TIPO_VENTA, F.TIPO_ENTREGA,
              F.DIRECCION_ENTREGA, F.SUBTOTAL, F.PORCENTAJE_IMPUESTO, F.IMPUESTO, F.TOTAL,
              F.MONEDA_CODIGO, F.ESTADO, F.OBSERVACIONES,
              S.NOMBRE AS SUCURSAL, C.NIT, C.NOMBRE AS CLIENTE,
              E.NOMBRES || ' ' || E.APELLIDOS AS VENDEDOR
         FROM FACTURA_9255 F
        INNER JOIN SUCURSAL_9255 S ON S.ID_SUCURSAL = F.ID_SUCURSAL
        INNER JOIN CLIENTE_9255 C ON C.ID_CLIENTE = F.ID_CLIENTE
        INNER JOIN EMPLEADO_9255 E ON E.ID_EMPLEADO = F.ID_EMPLEADO
        WHERE F.ID_FACTURA = :id`,
      { id }
    );

    if (!factura) {
      return res.status(404).render('mensaje', { titulo: 'Factura', mensaje: 'La factura no existe.' });
    }

    const detalle = await basedatos.consultar(
      `SELECT P.CODIGO, P.NOMBRE, D.CANTIDAD, D.PRECIO_UNITARIO, D.SUBTOTAL,
              TO_CHAR(D.FECHA_FIN_GARANTIA, 'DD/MM/YYYY') AS GARANTIA
         FROM DETALLE_FACTURA_9255 D
        INNER JOIN PRODUCTO_9255 P ON P.ID_PRODUCTO = D.ID_PRODUCTO
        WHERE D.ID_FACTURA = :id
        ORDER BY D.ID_DETALLE_FACTURA`,
      { id }
    );

    const pagos = await basedatos.consultar(
      `SELECT FP.NOMBRE AS FORMA, PF.MONTO, PF.NUMERO_REFERENCIA, PF.BANCO
         FROM PAGO_FACTURA_9255 PF
        INNER JOIN FORMA_PAGO_9255 FP ON FP.ID_FORMA_PAGO = PF.ID_FORMA_PAGO
        WHERE PF.ID_FACTURA = :id`,
      { id }
    );

    let productos = [];
    let formasPago = [];
    if (factura.ESTADO === 'EN_PROCESO') {
      productos = await basedatos.consultar(
        `SELECT P.ID_PRODUCTO, P.CODIGO, P.NOMBRE, I.EXISTENCIA
           FROM PRODUCTO_9255 P
          INNER JOIN INVENTARIO_9255 I ON I.ID_PRODUCTO = P.ID_PRODUCTO
          WHERE I.ID_SUCURSAL = :sucursal
            AND I.EXISTENCIA > 0
            AND P.FECHA_ELIMINACION IS NULL
          ORDER BY P.NOMBRE`,
        { sucursal: factura.ID_SUCURSAL }
      );
      formasPago = await basedatos.consultar(
        `SELECT ID_FORMA_PAGO, NOMBRE FROM FORMA_PAGO_9255 WHERE FECHA_ELIMINACION IS NULL ORDER BY ID_FORMA_PAGO`
      );
    }

    res.render('factura_detalle', {
      titulo: 'Factura ' + factura.NUMERO_FACTURA,
      factura,
      detalle,
      pagos,
      productos,
      formasPago,
      error: req.query.error || null,
    });
  } catch (error) {
    next(error);
  }
});

router.post('/facturas/:id/productos', requierePermiso('FACTURAS', 'crear'), async (req, res) => {
  const id = Number(req.params.id);
  try {
    await basedatos.ejecutar(
      `INSERT INTO DETALLE_FACTURA_9255 (ID_FACTURA, ID_PRODUCTO, CANTIDAD, CREADO_POR)
       VALUES (:factura, :producto, :cantidad, :usuario)`,
      {
        factura: id,
        producto: Number(req.body.producto),
        cantidad: Number(req.body.cantidad),
        usuario: req.session.usuario.nombreUsuario,
      }
    );
    res.redirect('/facturas/' + id);
  } catch (error) {
    res.redirect('/facturas/' + id + '?error=' + encodeURIComponent(error.message));
  }
});

router.post('/facturas/:id/emitir', requierePermiso('FACTURAS', 'crear'), async (req, res) => {
  const id = Number(req.params.id);
  const usuario = req.session.usuario.nombreUsuario;
  try {
    await basedatos.transaccion(async (conexion) => {
      const resultado = await conexion.execute(
        `SELECT ID_CLIENTE, TIPO_VENTA, TOTAL, ESTADO FROM FACTURA_9255 WHERE ID_FACTURA = :id`,
        { id }
      );
      const factura = resultado.rows[0];

      if (factura.ESTADO !== 'EN_PROCESO') {
        throw new Error('La factura ya fue emitida.');
      }
      if (factura.TOTAL <= 0) {
        throw new Error('La factura no tiene productos.');
      }

      if (factura.TIPO_VENTA === 'CONTADO') {
        const forma = await conexion.execute(
          `SELECT REQUIERE_REFERENCIA FROM FORMA_PAGO_9255 WHERE ID_FORMA_PAGO = :forma`,
          { forma: Number(req.body.forma) }
        );
        if (forma.rows[0].REQUIERE_REFERENCIA === 'S' && !req.body.referencia) {
          throw new Error('Esta forma de pago requiere numero de referencia.');
        }
        await conexion.execute(
          `INSERT INTO PAGO_FACTURA_9255 (ID_FACTURA, ID_FORMA_PAGO, MONTO, NUMERO_REFERENCIA, BANCO, CREADO_POR)
           VALUES (:id, :forma, :monto, :referencia, :banco, :usuario)`,
          {
            id,
            forma: Number(req.body.forma),
            monto: factura.TOTAL,
            referencia: req.body.referencia,
            banco: req.body.banco,
            usuario,
          }
        );
      } else {
        const cliente = await conexion.execute(
          `SELECT LIMITE_CREDITO, DIAS_CREDITO, FN_SALDO_CLIENTE_9255(ID_CLIENTE) AS SALDO
             FROM CLIENTE_9255
            WHERE ID_CLIENTE = :cliente`,
          { cliente: factura.ID_CLIENTE }
        );
        const c = cliente.rows[0];
        if (c.SALDO + factura.TOTAL > c.LIMITE_CREDITO) {
          throw new Error('La venta supera el limite de credito del cliente. Disponible: ' + (c.LIMITE_CREDITO - c.SALDO).toFixed(2));
        }
        await conexion.execute(
          `INSERT INTO CUENTA_POR_COBRAR_9255 (ID_FACTURA, ID_CLIENTE, MONTO_TOTAL, SALDO, FECHA_EMISION,
                                               FECHA_VENCIMIENTO, CREADO_POR)
           VALUES (:id, :cliente, :total, :total, TRUNC(SYSDATE), TRUNC(SYSDATE) + :dias, :usuario)`,
          { id, cliente: factura.ID_CLIENTE, total: factura.TOTAL, dias: c.DIAS_CREDITO, usuario }
        );
      }

      await conexion.execute(
        `UPDATE FACTURA_9255 SET ESTADO = 'EMITIDA', MODIFICADO_POR = :usuario WHERE ID_FACTURA = :id`,
        { usuario, id }
      );
    });
    res.redirect('/facturas/' + id);
  } catch (error) {
    res.redirect('/facturas/' + id + '?error=' + encodeURIComponent(error.message));
  }
});

module.exports = router;