const express = require('express');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

router.get('/cuentas-cobrar', requierePermiso('CUENTAS_COBRAR'), async (req, res, next) => {
  try {
    const estado = req.query.estado || 'PENDIENTE';
    const cuentas = await basedatos.consultar(
      `SELECT CC.ID_CUENTA_COBRAR, F.SERIE || '-' || F.NUMERO AS FACTURA, C.NIT, C.NOMBRE AS CLIENTE,
              F.MONEDA_CODIGO, CC.MONTO_TOTAL, CC.SALDO,
              TO_CHAR(CC.FECHA_EMISION, 'DD/MM/YYYY') AS EMISION,
              TO_CHAR(CC.FECHA_VENCIMIENTO, 'DD/MM/YYYY') AS VENCIMIENTO,
              CASE WHEN CC.ESTADO = 'PENDIENTE' AND CC.FECHA_VENCIMIENTO < TRUNC(SYSDATE) THEN 'S' ELSE 'N' END AS VENCIDA,
              CC.ESTADO
         FROM CUENTA_POR_COBRAR_9255 CC
        INNER JOIN FACTURA_9255 F ON F.ID_FACTURA = CC.ID_FACTURA
        INNER JOIN CLIENTE_9255 C ON C.ID_CLIENTE = CC.ID_CLIENTE
        WHERE CC.ESTADO = :estado
        ORDER BY CC.FECHA_VENCIMIENTO`,
      { estado }
    );
    res.render('cuentas_cobrar', { titulo: 'Cuentas por cobrar', cuentas, estado });
  } catch (error) {
    next(error);
  }
});

router.get('/cuentas-cobrar/:id', requierePermiso('CUENTAS_COBRAR'), async (req, res, next) => {
  try {
    const id = Number(req.params.id);
    const [cuenta] = await basedatos.consultar(
      `SELECT CC.ID_CUENTA_COBRAR, CC.ID_FACTURA, F.SERIE || '-' || F.NUMERO AS FACTURA,
              C.NIT, C.NOMBRE AS CLIENTE, F.MONEDA_CODIGO, CC.MONTO_TOTAL, CC.SALDO, CC.ESTADO,
              TO_CHAR(CC.FECHA_EMISION, 'DD/MM/YYYY') AS EMISION,
              TO_CHAR(CC.FECHA_VENCIMIENTO, 'DD/MM/YYYY') AS VENCIMIENTO,
              FN_SALDO_CLIENTE_9255(CC.ID_CLIENTE) AS SALDO_CLIENTE
         FROM CUENTA_POR_COBRAR_9255 CC
        INNER JOIN FACTURA_9255 F ON F.ID_FACTURA = CC.ID_FACTURA
        INNER JOIN CLIENTE_9255 C ON C.ID_CLIENTE = CC.ID_CLIENTE
        WHERE CC.ID_CUENTA_COBRAR = :id`,
      { id }
    );

    if (!cuenta) {
      return res.status(404).render('mensaje', { titulo: 'Cuenta por cobrar', mensaje: 'La cuenta no existe.' });
    }

    const abonos = await basedatos.consultar(
      `SELECT TO_CHAR(A.FECHA_ABONO, 'DD/MM/YYYY') AS FECHA, FP.NOMBRE AS FORMA, A.MONTO,
              A.NUMERO_REFERENCIA, A.BANCO, A.CREADO_POR
         FROM ABONO_CLIENTE_9255 A
        INNER JOIN FORMA_PAGO_9255 FP ON FP.ID_FORMA_PAGO = A.ID_FORMA_PAGO
        WHERE A.ID_CUENTA_COBRAR = :id
        ORDER BY A.ID_ABONO`,
      { id }
    );

    const formasPago = await basedatos.consultar(
      `SELECT ID_FORMA_PAGO, NOMBRE FROM FORMA_PAGO_9255 WHERE FECHA_ELIMINACION IS NULL ORDER BY ID_FORMA_PAGO`
    );

    res.render('cuenta_cobrar_detalle', {
      titulo: 'Cuenta de la factura ' + cuenta.FACTURA,
      cuenta,
      abonos,
      formasPago,
      error: req.query.error || null,
    });
  } catch (error) {
    next(error);
  }
});

router.post('/cuentas-cobrar/:id/abonos', requierePermiso('CUENTAS_COBRAR', 'crear'), async (req, res) => {
  const id = Number(req.params.id);
  try {
    const [forma] = await basedatos.consultar(
      `SELECT REQUIERE_REFERENCIA FROM FORMA_PAGO_9255 WHERE ID_FORMA_PAGO = :forma`,
      { forma: Number(req.body.forma) }
    );
    if (forma.REQUIERE_REFERENCIA === 'S' && !req.body.referencia) {
      throw new Error('Esta forma de pago requiere numero de referencia.');
    }

    await basedatos.ejecutar(
      `BEGIN
         PRC_REGISTRAR_ABONO_9255(:cuenta, :forma, :monto, :referencia, :banco, SYSDATE, :usuario);
       END;`,
      {
        cuenta: id,
        forma: Number(req.body.forma),
        monto: Number(req.body.monto),
        referencia: req.body.referencia,
        banco: req.body.banco,
        usuario: req.session.usuario.nombreUsuario,
      }
    );
    res.redirect('/cuentas-cobrar/' + id);
  } catch (error) {
    res.redirect('/cuentas-cobrar/' + id + '?error=' + encodeURIComponent(error.message.split('\n')[0]));
  }
});

module.exports = router;