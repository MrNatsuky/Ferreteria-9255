const express = require('express');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

router.get('/garantias', requierePermiso('GARANTIAS'), async (req, res, next) => {
  try {
    const estado = req.query.estado || 'PENDIENTE';
    const reclamos = await basedatos.consultar(
      `SELECT RG.ID_RECLAMO, TO_CHAR(RG.FECHA_RECLAMO, 'DD/MM/YYYY') AS FECHA,
              F.ID_FACTURA, F.SERIE || '-' || F.NUMERO AS FACTURA, C.NOMBRE AS CLIENTE, P.NOMBRE AS PRODUCTO,
              TO_CHAR(D.FECHA_FIN_GARANTIA, 'DD/MM/YYYY') AS GARANTIA_HASTA,
              RG.DESCRIPCION_FALLA, RG.ESTADO, RG.RESOLUCION,
              TO_CHAR(RG.FECHA_RESOLUCION, 'DD/MM/YYYY') AS FECHA_RESOLUCION, RG.CREADO_POR
         FROM RECLAMO_GARANTIA_9255 RG
        INNER JOIN DETALLE_FACTURA_9255 D ON D.ID_DETALLE_FACTURA = RG.ID_DETALLE_FACTURA
        INNER JOIN FACTURA_9255 F ON F.ID_FACTURA = D.ID_FACTURA
        INNER JOIN CLIENTE_9255 C ON C.ID_CLIENTE = F.ID_CLIENTE
        INNER JOIN PRODUCTO_9255 P ON P.ID_PRODUCTO = D.ID_PRODUCTO
        WHERE RG.ESTADO = :estado
        ORDER BY RG.ID_RECLAMO DESC`,
      { estado }
    );

    const productos = await basedatos.consultar(
      `SELECT D.ID_DETALLE_FACTURA, F.SERIE || '-' || F.NUMERO AS FACTURA, C.NOMBRE AS CLIENTE, P.NOMBRE AS PRODUCTO,
              TO_CHAR(D.FECHA_FIN_GARANTIA, 'DD/MM/YYYY') AS GARANTIA_HASTA
         FROM DETALLE_FACTURA_9255 D
        INNER JOIN FACTURA_9255 F ON F.ID_FACTURA = D.ID_FACTURA
        INNER JOIN CLIENTE_9255 C ON C.ID_CLIENTE = F.ID_CLIENTE
        INNER JOIN PRODUCTO_9255 P ON P.ID_PRODUCTO = D.ID_PRODUCTO
        WHERE F.ID_SUCURSAL = :sucursal
          AND F.ESTADO = 'EMITIDA'
          AND D.FECHA_FIN_GARANTIA >= TRUNC(SYSDATE)
          AND NOT EXISTS (SELECT 1 FROM RECLAMO_GARANTIA_9255 RG
                           WHERE RG.ID_DETALLE_FACTURA = D.ID_DETALLE_FACTURA AND RG.ESTADO = 'PENDIENTE')
        ORDER BY F.ID_FACTURA DESC`,
      { sucursal: req.session.usuario.idSucursal }
    );

    let resolver = null;
    if (req.query.resolver) {
      resolver = reclamos.find((r) => r.ID_RECLAMO === Number(req.query.resolver)) || null;
    }

    res.render('garantias', {
      titulo: 'Garantias',
      reclamos,
      productos,
      estado,
      resolver,
      error: req.query.error || null,
    });
  } catch (error) {
    next(error);
  }
});

router.post('/garantias', requierePermiso('GARANTIAS', 'crear'), async (req, res) => {
  try {
    const [linea] = await basedatos.consultar(
      `SELECT CASE WHEN FECHA_FIN_GARANTIA >= TRUNC(SYSDATE) THEN 'S' ELSE 'N' END AS VIGENTE
         FROM DETALLE_FACTURA_9255
        WHERE ID_DETALLE_FACTURA = :linea`,
      { linea: Number(req.body.linea) }
    );
    if (!linea || linea.VIGENTE !== 'S') {
      throw new Error('El producto no tiene garantia vigente.');
    }

    await basedatos.ejecutar(
      `INSERT INTO RECLAMO_GARANTIA_9255 (ID_DETALLE_FACTURA, ID_EMPLEADO, DESCRIPCION_FALLA, CREADO_POR)
       VALUES (:linea, :empleado, :falla, :usuario)`,
      {
        linea: Number(req.body.linea),
        empleado: req.session.usuario.idEmpleado,
        falla: req.body.falla,
        usuario: req.session.usuario.nombreUsuario,
      }
    );
    res.redirect('/garantias');
  } catch (error) {
    res.redirect('/garantias?error=' + encodeURIComponent(error.message.split('\n')[0]));
  }
});

router.post('/garantias/:id/resolver', requierePermiso('GARANTIAS', 'modificar'), async (req, res) => {
  const id = Number(req.params.id);
  const usuario = req.session.usuario;
  try {
    await basedatos.transaccion(async (conexion) => {
      const actualizado = await conexion.execute(
        `UPDATE RECLAMO_GARANTIA_9255
            SET ESTADO = :estado, RESOLUCION = :resolucion, FECHA_RESOLUCION = SYSDATE, MODIFICADO_POR = :usuario
          WHERE ID_RECLAMO = :id AND ESTADO = 'PENDIENTE'`,
        { estado: req.body.estado, resolucion: req.body.resolucion, usuario: usuario.nombreUsuario, id }
      );
      if (actualizado.rowsAffected === 0) {
        throw new Error('El reclamo ya fue resuelto.');
      }

      if (req.body.estado === 'REEMPLAZADO') {
        await conexion.execute(
          `INSERT INTO MOVIMIENTO_INVENTARIO_9255 (ID_TIPO_MOVIMIENTO, ID_SUCURSAL, ID_PRODUCTO, CANTIDAD, COSTO_UNITARIO,
                                                   ID_MOTIVO_BAJA, ID_EMPLEADO, DOCUMENTO_REFERENCIA, OBSERVACIONES, CREADO_POR)
           SELECT T.ID_TIPO_MOVIMIENTO, :sucursal, D.ID_PRODUCTO, 1, P.PRECIO_COSTO,
                  M.ID_MOTIVO_BAJA, :empleado, 'GARANTIA ' || RG.ID_RECLAMO, 'Reemplazo por garantia', :usuario
             FROM RECLAMO_GARANTIA_9255 RG
            INNER JOIN DETALLE_FACTURA_9255 D ON D.ID_DETALLE_FACTURA = RG.ID_DETALLE_FACTURA
            INNER JOIN PRODUCTO_9255 P ON P.ID_PRODUCTO = D.ID_PRODUCTO
            CROSS JOIN TIPO_MOVIMIENTO_9255 T
            CROSS JOIN MOTIVO_BAJA_9255 M
            WHERE RG.ID_RECLAMO = :id
              AND T.CODIGO = 'BAJA'
              AND M.NOMBRE = 'Defecto de fabrica'`,
          { sucursal: usuario.idSucursal, empleado: usuario.idEmpleado, usuario: usuario.nombreUsuario, id }
        );
      }
    });
    res.redirect('/garantias');
  } catch (error) {
    res.redirect('/garantias?resolver=' + id + '&error=' + encodeURIComponent(error.message.split('\n')[0]));
  }
});

module.exports = router;