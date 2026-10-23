const express = require('express');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

function primeraLinea(error) {
  return error.message.split('\n')[0];
}

router.get('/compras', requierePermiso('COMPRAS'), async (req, res, next) => {
  try {
    const compras = await basedatos.consultar(
      `SELECT CO.ID_COMPRA, CO.NUMERO_DOCUMENTO, TO_CHAR(CO.FECHA_EMISION, 'DD/MM/YYYY') AS FECHA,
              PR.NOMBRE AS PROVEEDOR, S.NOMBRE AS SUCURSAL, CO.TIPO_PAGO, CO.TOTAL, CO.ESTADO,
              PA.MONEDA_CODIGO
         FROM COMPRA_9255 CO
        INNER JOIN PROVEEDOR_9255 PR ON PR.ID_PROVEEDOR = CO.ID_PROVEEDOR
        INNER JOIN SUCURSAL_9255 S ON S.ID_SUCURSAL = CO.ID_SUCURSAL
        INNER JOIN REGION_9255 R ON R.ID_REGION = S.ID_REGION
        INNER JOIN PAIS_9255 PA ON PA.ID_PAIS = R.ID_PAIS
        ORDER BY CO.ID_COMPRA DESC
        FETCH FIRST 50 ROWS ONLY`
    );
    res.render('compras', { titulo: 'Compras', compras });
  } catch (error) {
    next(error);
  }
});

router.get('/compras/nueva', requierePermiso('COMPRAS', 'crear'), async (req, res, next) => {
  try {
    const proveedores = await basedatos.consultar(
      `SELECT PR.ID_PROVEEDOR, PR.NIT, PR.NOMBRE
         FROM PROVEEDOR_9255 PR
        INNER JOIN REGION_9255 R ON R.ID_PAIS = PR.ID_PAIS
        INNER JOIN SUCURSAL_9255 S ON S.ID_REGION = R.ID_REGION
        WHERE S.ID_SUCURSAL = :sucursal
          AND PR.FECHA_ELIMINACION IS NULL
        ORDER BY PR.NOMBRE`,
      { sucursal: req.session.usuario.idSucursal }
    );
    res.render('compra_nueva', { titulo: 'Nueva compra', proveedores, error: req.query.error || null });
  } catch (error) {
    next(error);
  }
});

router.post('/compras', requierePermiso('COMPRAS', 'crear'), async (req, res) => {
  const usuario = req.session.usuario;
  try {
    const idCompra = await basedatos.transaccion(async (conexion) => {
      const pais = await conexion.execute(
        `SELECT P.PORCENTAJE_IMPUESTO, P.TIPO_CAMBIO_QUETZAL
           FROM SUCURSAL_9255 S
          INNER JOIN REGION_9255 R ON R.ID_REGION = S.ID_REGION
          INNER JOIN PAIS_9255 P ON P.ID_PAIS = R.ID_PAIS
          WHERE S.ID_SUCURSAL = :sucursal`,
        { sucursal: usuario.idSucursal }
      );
      await conexion.execute(
        `INSERT INTO COMPRA_9255 (ID_PROVEEDOR, ID_SUCURSAL, ID_EMPLEADO, NUMERO_DOCUMENTO, TIPO_PAGO,
                                  PORCENTAJE_IMPUESTO, TIPO_CAMBIO_QUETZAL, CREADO_POR)
         VALUES (:proveedor, :sucursal, :empleado, :documento, :tipo, :porcentaje, :cambio, :usuario)`,
        {
          proveedor: Number(req.body.proveedor),
          sucursal: usuario.idSucursal,
          empleado: usuario.idEmpleado,
          documento: req.body.documento,
          tipo: req.body.tipo,
          porcentaje: pais.rows[0].PORCENTAJE_IMPUESTO,
          cambio: pais.rows[0].TIPO_CAMBIO_QUETZAL,
          usuario: usuario.nombreUsuario,
        }
      );
      const nueva = await conexion.execute(`SELECT SEC_COMPRA_9255.CURRVAL AS ID FROM DUAL`);
      return nueva.rows[0].ID;
    });
    res.redirect('/compras/' + idCompra);
  } catch (error) {
    res.redirect('/compras/nueva?error=' + encodeURIComponent(primeraLinea(error)));
  }
});

router.get('/compras/:id', requierePermiso('COMPRAS'), async (req, res, next) => {
  try {
    const id = Number(req.params.id);
    const [compra] = await basedatos.consultar(
      `SELECT CO.ID_COMPRA, CO.NUMERO_DOCUMENTO, TO_CHAR(CO.FECHA_EMISION, 'DD/MM/YYYY') AS FECHA,
              TO_CHAR(CO.FECHA_RECEPCION, 'DD/MM/YYYY') AS RECEPCION, CO.TIPO_PAGO, CO.ESTADO,
              CO.SUBTOTAL, CO.PORCENTAJE_IMPUESTO, CO.IMPUESTO, CO.TOTAL, CO.TIPO_CAMBIO_QUETZAL,
              PR.NIT, PR.NOMBRE AS PROVEEDOR, S.NOMBRE AS SUCURSAL, PA.MONEDA_CODIGO,
              E.NOMBRES || ' ' || E.APELLIDOS AS EMPLEADO
         FROM COMPRA_9255 CO
        INNER JOIN PROVEEDOR_9255 PR ON PR.ID_PROVEEDOR = CO.ID_PROVEEDOR
        INNER JOIN SUCURSAL_9255 S ON S.ID_SUCURSAL = CO.ID_SUCURSAL
        INNER JOIN REGION_9255 R ON R.ID_REGION = S.ID_REGION
        INNER JOIN PAIS_9255 PA ON PA.ID_PAIS = R.ID_PAIS
        INNER JOIN EMPLEADO_9255 E ON E.ID_EMPLEADO = CO.ID_EMPLEADO
        WHERE CO.ID_COMPRA = :id`,
      { id }
    );

    if (!compra) {
      return res.status(404).render('mensaje', { titulo: 'Compra', mensaje: 'La compra no existe.' });
    }

    const detalle = await basedatos.consultar(
      `SELECT P.CODIGO, P.NOMBRE, D.CANTIDAD, D.COSTO_UNITARIO, D.SUBTOTAL
         FROM DETALLE_COMPRA_9255 D
        INNER JOIN PRODUCTO_9255 P ON P.ID_PRODUCTO = D.ID_PRODUCTO
        WHERE D.ID_COMPRA = :id
        ORDER BY D.ID_DETALLE_COMPRA`,
      { id }
    );

    let productos = [];
    if (compra.ESTADO === 'PENDIENTE') {
      productos = await basedatos.consultar(
        `SELECT ID_PRODUCTO, CODIGO, NOMBRE, ROUND(PRECIO_COSTO / :cambio, 2) AS COSTO
           FROM PRODUCTO_9255
          WHERE FECHA_ELIMINACION IS NULL
          ORDER BY NOMBRE`,
        { cambio: compra.TIPO_CAMBIO_QUETZAL }
      );
    }

    res.render('compra_detalle', {
      titulo: 'Compra ' + compra.ID_COMPRA,
      compra,
      detalle,
      productos,
      error: req.query.error || null,
    });
  } catch (error) {
    next(error);
  }
});

router.post('/compras/:id/productos', requierePermiso('COMPRAS', 'crear'), async (req, res) => {
  const id = Number(req.params.id);
  const usuario = req.session.usuario.nombreUsuario;
  try {
    await basedatos.transaccion(async (conexion) => {
      const compra = await conexion.execute(`SELECT ESTADO FROM COMPRA_9255 WHERE ID_COMPRA = :id`, { id });
      if (compra.rows[0].ESTADO !== 'PENDIENTE') {
        throw new Error('Solo se pueden agregar productos a una compra pendiente.');
      }

      const cantidad = Number(req.body.cantidad);
      const costo = Number(req.body.costo);
      await conexion.execute(
        `INSERT INTO DETALLE_COMPRA_9255 (ID_COMPRA, ID_PRODUCTO, CANTIDAD, COSTO_UNITARIO, SUBTOTAL, CREADO_POR)
         VALUES (:id, :producto, :cantidad, :costo, :subtotal, :usuario)`,
        {
          id,
          producto: Number(req.body.producto),
          cantidad,
          costo,
          subtotal: Math.round(cantidad * costo * 100) / 100,
          usuario,
        }
      );

      await conexion.execute(
        `UPDATE COMPRA_9255 CO
            SET SUBTOTAL = (SELECT SUM(SUBTOTAL) FROM DETALLE_COMPRA_9255 WHERE ID_COMPRA = CO.ID_COMPRA),
                IMPUESTO = ROUND((SELECT SUM(SUBTOTAL) FROM DETALLE_COMPRA_9255 WHERE ID_COMPRA = CO.ID_COMPRA) * PORCENTAJE_IMPUESTO / 100, 2),
                TOTAL = ROUND((SELECT SUM(SUBTOTAL) FROM DETALLE_COMPRA_9255 WHERE ID_COMPRA = CO.ID_COMPRA) * (1 + PORCENTAJE_IMPUESTO / 100), 2),
                MODIFICADO_POR = :usuario
          WHERE ID_COMPRA = :id`,
        { usuario, id }
      );
    });
    res.redirect('/compras/' + id);
  } catch (error) {
    res.redirect('/compras/' + id + '?error=' + encodeURIComponent(primeraLinea(error)));
  }
});

router.post('/compras/:id/recibir', requierePermiso('COMPRAS', 'modificar'), async (req, res) => {
  const id = Number(req.params.id);
  const usuario = req.session.usuario;
  try {
    await basedatos.transaccion(async (conexion) => {
      const resultado = await conexion.execute(
        `SELECT CO.ID_SUCURSAL, CO.TIPO_PAGO, CO.ESTADO, CO.TOTAL, CO.TIPO_CAMBIO_QUETZAL, PR.DIAS_CREDITO
           FROM COMPRA_9255 CO
          INNER JOIN PROVEEDOR_9255 PR ON PR.ID_PROVEEDOR = CO.ID_PROVEEDOR
          WHERE CO.ID_COMPRA = :id`,
        { id }
      );
      const compra = resultado.rows[0];

      if (compra.ESTADO !== 'PENDIENTE') {
        throw new Error('La compra ya fue recibida o cancelada.');
      }
      if (compra.TOTAL <= 0) {
        throw new Error('La compra no tiene productos.');
      }

      const detalle = await conexion.execute(
        `SELECT ID_PRODUCTO, CANTIDAD, COSTO_UNITARIO FROM DETALLE_COMPRA_9255 WHERE ID_COMPRA = :id`,
        { id }
      );

      for (const d of detalle.rows) {
        await conexion.execute(
          `BEGIN
             PAQ_INVENTARIO_9255.PRC_REGISTRA_MOV_INVENTARIO_9255('INGRESO_COMPRA', :sucursal, :producto, :cantidad,
                                                                 :costo, :empleado, :referencia, SYSDATE, :usuario);
           END;`,
          {
            sucursal: compra.ID_SUCURSAL,
            producto: d.ID_PRODUCTO,
            cantidad: d.CANTIDAD,
            costo: Math.round(d.COSTO_UNITARIO * compra.TIPO_CAMBIO_QUETZAL * 100) / 100,
            empleado: usuario.idEmpleado,
            referencia: 'COMPRA ' + id,
            usuario: usuario.nombreUsuario,
          }
        );
      }

      if (compra.TIPO_PAGO === 'CREDITO') {
        await conexion.execute(
          `INSERT INTO CUENTA_POR_PAGAR_9255 (ID_COMPRA, MONTO_TOTAL, SALDO, FECHA_EMISION, FECHA_VENCIMIENTO, CREADO_POR)
           VALUES (:id, :total, :total, TRUNC(SYSDATE), TRUNC(SYSDATE) + :dias, :usuario)`,
          { id, total: compra.TOTAL, dias: compra.DIAS_CREDITO, usuario: usuario.nombreUsuario }
        );
      }

      await conexion.execute(
        `UPDATE COMPRA_9255
            SET ESTADO = 'RECIBIDA', FECHA_RECEPCION = SYSDATE, MODIFICADO_POR = :usuario
          WHERE ID_COMPRA = :id`,
        { usuario: usuario.nombreUsuario, id }
      );
    });
    res.redirect('/compras/' + id);
  } catch (error) {
    res.redirect('/compras/' + id + '?error=' + encodeURIComponent(primeraLinea(error)));
  }
});

router.post('/compras/:id/cancelar', requierePermiso('COMPRAS', 'modificar'), async (req, res) => {
  const id = Number(req.params.id);
  try {
    await basedatos.ejecutar(
      `UPDATE COMPRA_9255
          SET ESTADO = 'CANCELADA', MODIFICADO_POR = :usuario
        WHERE ID_COMPRA = :id AND ESTADO = 'PENDIENTE'`,
      { usuario: req.session.usuario.nombreUsuario, id }
    );
    res.redirect('/compras/' + id);
  } catch (error) {
    res.redirect('/compras/' + id + '?error=' + encodeURIComponent(primeraLinea(error)));
  }
});

module.exports = router;