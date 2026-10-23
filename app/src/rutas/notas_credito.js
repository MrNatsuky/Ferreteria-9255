const express = require('express');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

router.get('/notas-credito', requierePermiso('NOTAS_CREDITO'), async (req, res, next) => {
  try {
    const notas = await basedatos.consultar(
      `SELECT N.SERIE || '-' || N.NUMERO AS NOTA, TO_CHAR(N.FECHA_EMISION, 'DD/MM/YYYY') AS FECHA,
              F.ID_FACTURA, F.SERIE || '-' || F.NUMERO AS FACTURA, C.NOMBRE AS CLIENTE,
              N.TIPO, N.MOTIVO, F.MONEDA_CODIGO, N.MONTO,
              EA.NOMBRES || ' ' || EA.APELLIDOS AS AUTORIZA, N.CREADO_POR
         FROM NOTA_CREDITO_9255 N
        INNER JOIN FACTURA_9255 F ON F.ID_FACTURA = N.ID_FACTURA
        INNER JOIN CLIENTE_9255 C ON C.ID_CLIENTE = F.ID_CLIENTE
        INNER JOIN EMPLEADO_9255 EA ON EA.ID_EMPLEADO = N.ID_EMPLEADO_AUTORIZA
        ORDER BY N.ID_NOTA_CREDITO DESC
        FETCH FIRST 50 ROWS ONLY`
    );
    res.render('notas_credito', { titulo: 'Notas de credito y devoluciones', notas });
  } catch (error) {
    next(error);
  }
});

router.get('/notas-credito/nueva', requierePermiso('NOTAS_CREDITO', 'crear'), async (req, res, next) => {
  try {
    const facturas = await basedatos.consultar(
      `SELECT F.ID_FACTURA, F.SERIE || '-' || F.NUMERO AS FACTURA, C.NOMBRE AS CLIENTE, F.MONEDA_CODIGO, F.TOTAL,
              F.TOTAL - NVL((SELECT SUM(N.MONTO) FROM NOTA_CREDITO_9255 N WHERE N.ID_FACTURA = F.ID_FACTURA), 0) AS DISPONIBLE
         FROM FACTURA_9255 F
        INNER JOIN CLIENTE_9255 C ON C.ID_CLIENTE = F.ID_CLIENTE
        WHERE F.ID_SUCURSAL = :sucursal AND F.ESTADO = 'EMITIDA'
        ORDER BY F.ID_FACTURA DESC
        FETCH FIRST 50 ROWS ONLY`,
      { sucursal: req.session.usuario.idSucursal }
    );

    const factura = facturas.find((f) => f.ID_FACTURA === Number(req.query.factura)) || null;
    let lineas = [];
    let gerentes = [];
    if (factura) {
      lineas = await basedatos.consultar(
        `SELECT D.ID_DETALLE_FACTURA, P.CODIGO, P.NOMBRE, D.CANTIDAD, D.PRECIO_UNITARIO,
                D.CANTIDAD - NVL((SELECT SUM(DN.CANTIDAD) FROM DETALLE_NOTA_CREDITO_9255 DN
                                   WHERE DN.ID_DETALLE_FACTURA = D.ID_DETALLE_FACTURA), 0) AS DISPONIBLE
           FROM DETALLE_FACTURA_9255 D
          INNER JOIN PRODUCTO_9255 P ON P.ID_PRODUCTO = D.ID_PRODUCTO
          WHERE D.ID_FACTURA = :factura
          ORDER BY D.ID_DETALLE_FACTURA`,
        { factura: factura.ID_FACTURA }
      );
      gerentes = await basedatos.consultar(
        `SELECT ID_EMPLEADO, NOMBRES || ' ' || APELLIDOS || ' (' || PUESTO || ')' AS NOMBRE
           FROM EMPLEADO_9255
          WHERE PUESTO LIKE 'Gerente%' AND FECHA_ELIMINACION IS NULL
          ORDER BY NOMBRES`
      );
    }

    res.render('nota_credito_nueva', {
      titulo: 'Nueva nota de credito',
      facturas,
      factura,
      lineas,
      gerentes,
      error: req.query.error || null,
    });
  } catch (error) {
    next(error);
  }
});

router.post('/notas-credito', requierePermiso('NOTAS_CREDITO', 'crear'), async (req, res) => {
  const usuario = req.session.usuario;
  const idFactura = Number(req.body.factura);
  const tipo = req.body.tipo;
  try {
    await basedatos.transaccion(async (conexion) => {
      const resultado = await conexion.execute(
        `SELECT F.ID_SUCURSAL, F.TOTAL, F.PORCENTAJE_IMPUESTO, F.ESTADO,
                NVL((SELECT SUM(N.MONTO) FROM NOTA_CREDITO_9255 N WHERE N.ID_FACTURA = F.ID_FACTURA), 0) AS ACREDITADO
           FROM FACTURA_9255 F
          WHERE F.ID_FACTURA = :factura`,
        { factura: idFactura }
      );
      const factura = resultado.rows[0];
      if (factura.ESTADO !== 'EMITIDA') {
        throw new Error('Solo se hacen notas de credito a facturas emitidas.');
      }

      let monto;
      let linea = null;
      const cantidad = Number(req.body.cantidad);

      if (tipo === 'DEVOLUCION') {
        const consultaLinea = await conexion.execute(
          `SELECT D.ID_PRODUCTO, D.PRECIO_UNITARIO, P.PRECIO_COSTO,
                  D.CANTIDAD - NVL((SELECT SUM(DN.CANTIDAD) FROM DETALLE_NOTA_CREDITO_9255 DN
                                     WHERE DN.ID_DETALLE_FACTURA = D.ID_DETALLE_FACTURA), 0) AS DISPONIBLE
             FROM DETALLE_FACTURA_9255 D
            INNER JOIN PRODUCTO_9255 P ON P.ID_PRODUCTO = D.ID_PRODUCTO
            WHERE D.ID_DETALLE_FACTURA = :linea AND D.ID_FACTURA = :factura`,
          { linea: Number(req.body.linea), factura: idFactura }
        );
        linea = consultaLinea.rows[0];
        if (!linea) {
          throw new Error('Seleccione un producto de la factura.');
        }
        if (!(cantidad > 0) || cantidad > linea.DISPONIBLE) {
          throw new Error('La cantidad a devolver debe ser mayor que 0 y no mayor que ' + linea.DISPONIBLE + '.');
        }
        monto = Math.round(cantidad * linea.PRECIO_UNITARIO * (1 + factura.PORCENTAJE_IMPUESTO / 100) * 100) / 100;
      } else {
        monto = Number(req.body.monto);
      }

      if (!(monto > 0)) {
        throw new Error('El monto de la nota debe ser mayor que 0.');
      }
      if (factura.ACREDITADO + monto > factura.TOTAL) {
        throw new Error('La nota supera lo que queda por acreditar de la factura: ' + (factura.TOTAL - factura.ACREDITADO).toFixed(2));
      }

      await conexion.execute(
        `UPDATE SUCURSAL_9255
            SET CORRELATIVO_NOTA_CREDITO = CORRELATIVO_NOTA_CREDITO + 1, MODIFICADO_POR = :usuario
          WHERE ID_SUCURSAL = :sucursal`,
        { usuario: usuario.nombreUsuario, sucursal: factura.ID_SUCURSAL }
      );
      const correlativo = await conexion.execute(
        `SELECT 'NC' || SERIE_FACTURA AS SERIE, CORRELATIVO_NOTA_CREDITO AS NUMERO
           FROM SUCURSAL_9255 WHERE ID_SUCURSAL = :sucursal`,
        { sucursal: factura.ID_SUCURSAL }
      );
      const { SERIE, NUMERO } = correlativo.rows[0];

      await conexion.execute(
        `INSERT INTO NOTA_CREDITO_9255 (ID_FACTURA, ID_EMPLEADO, ID_EMPLEADO_AUTORIZA, SERIE, NUMERO,
                                        TIPO, MOTIVO, MONTO, ESTADO, CREADO_POR)
         VALUES (:factura, :empleado, :autoriza, :serie, :numero, :tipo, :motivo, :monto, 'EMITIDA', :usuario)`,
        {
          factura: idFactura,
          empleado: usuario.idEmpleado,
          autoriza: Number(req.body.autoriza),
          serie: SERIE,
          numero: NUMERO,
          tipo,
          motivo: req.body.motivo,
          monto,
          usuario: usuario.nombreUsuario,
        }
      );

      if (tipo === 'DEVOLUCION') {
        await conexion.execute(
          `INSERT INTO DETALLE_NOTA_CREDITO_9255 (ID_NOTA_CREDITO, ID_DETALLE_FACTURA, CANTIDAD, ESTADO_PRODUCTO, MONTO, CREADO_POR)
           VALUES (SEC_NOTA_CREDITO_9255.CURRVAL, :linea, :cantidad, :estado, :monto, :usuario)`,
          {
            linea: Number(req.body.linea),
            cantidad,
            estado: req.body.estado,
            monto,
            usuario: usuario.nombreUsuario,
          }
        );

        if (req.body.estado === 'BUENO') {
          await conexion.execute(
            `BEGIN
               PAQ_INVENTARIO_9255.PRC_REGISTRA_MOV_INVENTARIO_9255('INGRESO_DEVOLUCION', :sucursal, :producto, :cantidad,
                                                                   :costo, :empleado, :referencia, SYSDATE, :usuario);
             END;`,
            {
              sucursal: factura.ID_SUCURSAL,
              producto: linea.ID_PRODUCTO,
              cantidad,
              costo: linea.PRECIO_COSTO,
              empleado: usuario.idEmpleado,
              referencia: 'NOTA DE CREDITO ' + SERIE + '-' + NUMERO,
              usuario: usuario.nombreUsuario,
            }
          );
        }
      }

      await conexion.execute(
        `UPDATE CUENTA_POR_COBRAR_9255
            SET SALDO = GREATEST(SALDO - :monto, 0),
                ESTADO = CASE WHEN SALDO - :monto <= 0 THEN 'PAGADA' ELSE 'PENDIENTE' END,
                MODIFICADO_POR = :usuario
          WHERE ID_FACTURA = :factura AND ESTADO = 'PENDIENTE'`,
        { monto, usuario: usuario.nombreUsuario, factura: idFactura }
      );
    });
    res.redirect('/notas-credito');
  } catch (error) {
    res.redirect('/notas-credito/nueva?factura=' + idFactura + '&error=' + encodeURIComponent(error.message.split('\n')[0]));
  }
});

module.exports = router;