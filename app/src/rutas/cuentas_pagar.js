const express = require('express');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

router.get('/cuentas-pagar', requierePermiso('CUENTAS_PAGAR'), async (req, res, next) => {
  try {
    const estado = req.query.estado || 'PENDIENTE';
    const cuentas = await basedatos.consultar(
      `SELECT CP.ID_CUENTA_PAGAR, CO.ID_COMPRA, CO.NUMERO_DOCUMENTO, PR.NOMBRE AS PROVEEDOR,
              PA.MONEDA_CODIGO, CP.MONTO_TOTAL, CP.SALDO,
              TO_CHAR(CP.FECHA_EMISION, 'DD/MM/YYYY') AS EMISION,
              TO_CHAR(CP.FECHA_VENCIMIENTO, 'DD/MM/YYYY') AS VENCIMIENTO,
              CASE WHEN CP.ESTADO = 'PENDIENTE' AND CP.FECHA_VENCIMIENTO < TRUNC(SYSDATE) THEN 'S' ELSE 'N' END AS VENCIDA,
              CP.ESTADO
         FROM CUENTA_POR_PAGAR_9255 CP
        INNER JOIN COMPRA_9255 CO ON CO.ID_COMPRA = CP.ID_COMPRA
        INNER JOIN PROVEEDOR_9255 PR ON PR.ID_PROVEEDOR = CO.ID_PROVEEDOR
        INNER JOIN SUCURSAL_9255 S ON S.ID_SUCURSAL = CO.ID_SUCURSAL
        INNER JOIN REGION_9255 R ON R.ID_REGION = S.ID_REGION
        INNER JOIN PAIS_9255 PA ON PA.ID_PAIS = R.ID_PAIS
        WHERE CP.ESTADO = :estado
        ORDER BY CP.FECHA_VENCIMIENTO`,
      { estado }
    );
    res.render('cuentas_pagar', { titulo: 'Cuentas por pagar', cuentas, estado });
  } catch (error) {
    next(error);
  }
});

router.get('/cuentas-pagar/:id', requierePermiso('CUENTAS_PAGAR'), async (req, res, next) => {
  try {
    const id = Number(req.params.id);
    const [cuenta] = await basedatos.consultar(
      `SELECT CP.ID_CUENTA_PAGAR, CO.ID_COMPRA, CO.NUMERO_DOCUMENTO, PR.NIT, PR.NOMBRE AS PROVEEDOR,
              PA.MONEDA_CODIGO, CP.MONTO_TOTAL, CP.SALDO, CP.ESTADO,
              TO_CHAR(CP.FECHA_EMISION, 'DD/MM/YYYY') AS EMISION,
              TO_CHAR(CP.FECHA_VENCIMIENTO, 'DD/MM/YYYY') AS VENCIMIENTO
         FROM CUENTA_POR_PAGAR_9255 CP
        INNER JOIN COMPRA_9255 CO ON CO.ID_COMPRA = CP.ID_COMPRA
        INNER JOIN PROVEEDOR_9255 PR ON PR.ID_PROVEEDOR = CO.ID_PROVEEDOR
        INNER JOIN SUCURSAL_9255 S ON S.ID_SUCURSAL = CO.ID_SUCURSAL
        INNER JOIN REGION_9255 R ON R.ID_REGION = S.ID_REGION
        INNER JOIN PAIS_9255 PA ON PA.ID_PAIS = R.ID_PAIS
        WHERE CP.ID_CUENTA_PAGAR = :id`,
      { id }
    );

    if (!cuenta) {
      return res.status(404).render('mensaje', { titulo: 'Cuenta por pagar', mensaje: 'La cuenta no existe.' });
    }

    const pagos = await basedatos.consultar(
      `SELECT TO_CHAR(PP.FECHA_PAGO, 'DD/MM/YYYY') AS FECHA, FP.NOMBRE AS FORMA, PP.MONTO,
              PP.NUMERO_REFERENCIA, PP.BANCO, PP.CREADO_POR
         FROM PAGO_PROVEEDOR_9255 PP
        INNER JOIN FORMA_PAGO_9255 FP ON FP.ID_FORMA_PAGO = PP.ID_FORMA_PAGO
        WHERE PP.ID_CUENTA_PAGAR = :id
        ORDER BY PP.ID_PAGO_PROVEEDOR`,
      { id }
    );

    const formasPago = await basedatos.consultar(
      `SELECT ID_FORMA_PAGO, NOMBRE FROM FORMA_PAGO_9255 WHERE FECHA_ELIMINACION IS NULL ORDER BY ID_FORMA_PAGO`
    );

    res.render('cuenta_pagar_detalle', {
      titulo: 'Cuenta de la compra ' + cuenta.ID_COMPRA,
      cuenta,
      pagos,
      formasPago,
      error: req.query.error || null,
    });
  } catch (error) {
    next(error);
  }
});

router.post('/cuentas-pagar/:id/pagos', requierePermiso('CUENTAS_PAGAR', 'crear'), async (req, res) => {
  const id = Number(req.params.id);
  const usuario = req.session.usuario.nombreUsuario;
  const monto = Number(req.body.monto);
  try {
    await basedatos.transaccion(async (conexion) => {
      const resultado = await conexion.execute(
        `SELECT SALDO, ESTADO FROM CUENTA_POR_PAGAR_9255 WHERE ID_CUENTA_PAGAR = :id`,
        { id }
      );
      const cuenta = resultado.rows[0];
      if (cuenta.ESTADO !== 'PENDIENTE') {
        throw new Error('La cuenta ya esta pagada.');
      }
      if (monto > cuenta.SALDO) {
        throw new Error('El pago es mayor que el saldo pendiente (' + cuenta.SALDO.toFixed(2) + ').');
      }

      const forma = await conexion.execute(
        `SELECT REQUIERE_REFERENCIA FROM FORMA_PAGO_9255 WHERE ID_FORMA_PAGO = :forma`,
        { forma: Number(req.body.forma) }
      );
      if (forma.rows[0].REQUIERE_REFERENCIA === 'S' && !req.body.referencia) {
        throw new Error('Esta forma de pago requiere numero de referencia.');
      }

      await conexion.execute(
        `INSERT INTO PAGO_PROVEEDOR_9255 (ID_CUENTA_PAGAR, ID_FORMA_PAGO, MONTO, NUMERO_REFERENCIA, BANCO, CREADO_POR)
         VALUES (:id, :forma, :monto, :referencia, :banco, :usuario)`,
        {
          id,
          forma: Number(req.body.forma),
          monto,
          referencia: req.body.referencia,
          banco: req.body.banco,
          usuario,
        }
      );

      await conexion.execute(
        `UPDATE CUENTA_POR_PAGAR_9255
            SET SALDO = SALDO - :monto,
                ESTADO = CASE WHEN SALDO - :monto = 0 THEN 'PAGADA' ELSE 'PENDIENTE' END,
                MODIFICADO_POR = :usuario
          WHERE ID_CUENTA_PAGAR = :id`,
        { monto, usuario, id }
      );
    });
    res.redirect('/cuentas-pagar/' + id);
  } catch (error) {
    res.redirect('/cuentas-pagar/' + id + '?error=' + encodeURIComponent(error.message.split('\n')[0]));
  }
});

module.exports = router;