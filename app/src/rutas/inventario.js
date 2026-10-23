const express = require('express');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

function primeraLinea(error) {
  return error.message.split('\n')[0];
}

async function productosDeSucursal(idSucursal) {
  return basedatos.consultar(
    `SELECT P.ID_PRODUCTO, P.CODIGO, P.NOMBRE, I.EXISTENCIA
       FROM PRODUCTO_9255 P
      INNER JOIN INVENTARIO_9255 I ON I.ID_PRODUCTO = P.ID_PRODUCTO
      WHERE I.ID_SUCURSAL = :sucursal
        AND I.EXISTENCIA > 0
        AND P.FECHA_ELIMINACION IS NULL
      ORDER BY P.NOMBRE`,
    { sucursal: idSucursal }
  );
}

router.get('/inventario', requierePermiso('INVENTARIO'), async (req, res, next) => {
  try {
    const idSucursal = Number(req.query.sucursal) || req.session.usuario.idSucursal;
    const sucursales = await basedatos.consultar(
      `SELECT ID_SUCURSAL, NOMBRE FROM SUCURSAL_9255 WHERE FECHA_ELIMINACION IS NULL ORDER BY ID_SUCURSAL`
    );
    const existencias = await basedatos.consultar(
          `SELECT P.CODIGO, P.NOMBRE, C.NOMBRE AS CATEGORIA, I.EXISTENCIA, P.EXISTENCIA_MINIMA,
              TO_CHAR(I.FECHA_ULTIMO_MOVIMIENTO, 'DD/MM/YYYY') AS ULTIMO
         FROM INVENTARIO_9255 I
        INNER JOIN PRODUCTO_9255 P ON P.ID_PRODUCTO = I.ID_PRODUCTO
        INNER JOIN CATEGORIA_9255 C ON C.ID_CATEGORIA = P.ID_CATEGORIA
        WHERE I.ID_SUCURSAL = :sucursal
        ORDER BY P.NOMBRE`,
      { sucursal: idSucursal }
    );
    res.render('inventario', { titulo: 'Existencias', sucursales, idSucursal, existencias });
  } catch (error) {
    next(error);
  }
});

router.get('/movimientos', requierePermiso('MOVIMIENTOS'), async (req, res, next) => {
  try {
    const idSucursal = req.session.usuario.idSucursal;
    const productos = await productosDeSucursal(idSucursal);
    const sucursales = await basedatos.consultar(
      `SELECT ID_SUCURSAL, NOMBRE FROM SUCURSAL_9255
        WHERE ID_SUCURSAL <> :sucursal AND FECHA_ELIMINACION IS NULL
        ORDER BY ID_SUCURSAL`,
      { sucursal: idSucursal }
    );
    const movimientos = await basedatos.consultar(
      `SELECT TO_CHAR(M.FECHA_MOVIMIENTO, 'DD/MM/YYYY HH24:MI') AS FECHA, T.NOMBRE AS TIPO, T.OPERACION,
              P.NOMBRE AS PRODUCTO, M.CANTIDAD, M.DOCUMENTO_REFERENCIA, M.CREADO_POR
         FROM MOVIMIENTO_INVENTARIO_9255 M
        INNER JOIN TIPO_MOVIMIENTO_9255 T ON T.ID_TIPO_MOVIMIENTO = M.ID_TIPO_MOVIMIENTO
        INNER JOIN PRODUCTO_9255 P ON P.ID_PRODUCTO = M.ID_PRODUCTO
        WHERE M.ID_SUCURSAL = :sucursal
        ORDER BY M.ID_MOVIMIENTO DESC
        FETCH FIRST 30 ROWS ONLY`,
      { sucursal: idSucursal }
    );
    res.render('movimientos', {
      titulo: 'Ingresos y traslados',
      productos,
      sucursales,
      movimientos,
      error: req.query.error || null,
      exito: req.query.exito || null,
    });
  } catch (error) {
    next(error);
  }
});

router.post('/movimientos/traslado', requierePermiso('MOVIMIENTOS', 'crear'), async (req, res) => {
  const usuario = req.session.usuario;
  try {
    await basedatos.ejecutar(
      `BEGIN
         PAQ_INVENTARIO_9255.PRC_TRASLADAR_PRODUCTO_9255(:origen, :destino, :producto, :cantidad, :empleado, SYSDATE, :usuario);
       END;`,
      {
        origen: usuario.idSucursal,
        destino: Number(req.body.destino),
        producto: Number(req.body.producto),
        cantidad: Number(req.body.cantidad),
        empleado: usuario.idEmpleado,
        usuario: usuario.nombreUsuario,
      }
    );
    res.redirect('/movimientos?exito=' + encodeURIComponent('Traslado registrado.'));
  } catch (error) {
    res.redirect('/movimientos?error=' + encodeURIComponent(primeraLinea(error)));
  }
});

router.get('/bajas', requierePermiso('BAJAS'), async (req, res, next) => {
  try {
    const idSucursal = req.session.usuario.idSucursal;
    const productos = await productosDeSucursal(idSucursal);
    const motivos = await basedatos.consultar(
      `SELECT ID_MOTIVO_BAJA, NOMBRE FROM MOTIVO_BAJA_9255 WHERE FECHA_ELIMINACION IS NULL ORDER BY NOMBRE`
    );
    const empleados = await basedatos.consultar(
      `SELECT ID_EMPLEADO, NOMBRES || ' ' || APELLIDOS || ' (' || PUESTO || ')' AS NOMBRE
         FROM EMPLEADO_9255
        WHERE ID_SUCURSAL = :sucursal AND FECHA_ELIMINACION IS NULL
        ORDER BY NOMBRES`,
      { sucursal: idSucursal }
    );
    const bajas = await basedatos.consultar(
      `SELECT TO_CHAR(M.FECHA_MOVIMIENTO, 'DD/MM/YYYY HH24:MI') AS FECHA, P.NOMBRE AS PRODUCTO, M.CANTIDAD,
              MB.NOMBRE AS MOTIVO, E.NOMBRES || ' ' || E.APELLIDOS AS AUTORIZA, M.OBSERVACIONES, M.CREADO_POR
         FROM MOVIMIENTO_INVENTARIO_9255 M
        INNER JOIN TIPO_MOVIMIENTO_9255 T ON T.ID_TIPO_MOVIMIENTO = M.ID_TIPO_MOVIMIENTO
        INNER JOIN PRODUCTO_9255 P ON P.ID_PRODUCTO = M.ID_PRODUCTO
        INNER JOIN MOTIVO_BAJA_9255 MB ON MB.ID_MOTIVO_BAJA = M.ID_MOTIVO_BAJA
         LEFT JOIN EMPLEADO_9255 E ON E.ID_EMPLEADO = M.ID_EMPLEADO_AUTORIZA
        WHERE T.CODIGO = 'BAJA' AND M.ID_SUCURSAL = :sucursal
        ORDER BY M.ID_MOVIMIENTO DESC`,
      { sucursal: idSucursal }
    );
    res.render('bajas', {
      titulo: 'Bajas de inventario',
      productos,
      motivos,
      empleados,
      bajas,
      error: req.query.error || null,
      exito: req.query.exito || null,
    });
  } catch (error) {
    next(error);
  }
});

router.post('/bajas', requierePermiso('BAJAS', 'crear'), async (req, res) => {
  const usuario = req.session.usuario;
  try {
    if (!req.body.motivo) {
      throw new Error('Toda baja debe tener un motivo.');
    }
    await basedatos.ejecutar(
      `INSERT INTO MOVIMIENTO_INVENTARIO_9255 (ID_TIPO_MOVIMIENTO, ID_SUCURSAL, ID_PRODUCTO, CANTIDAD, COSTO_UNITARIO,
                                               ID_MOTIVO_BAJA, ID_EMPLEADO, ID_EMPLEADO_AUTORIZA, DOCUMENTO_REFERENCIA,
                                               OBSERVACIONES, CREADO_POR)
       SELECT T.ID_TIPO_MOVIMIENTO, :sucursal, P.ID_PRODUCTO, :cantidad, P.PRECIO_COSTO,
              :motivo, :empleado, :autoriza, 'BAJA', :observaciones, :usuario
         FROM TIPO_MOVIMIENTO_9255 T, PRODUCTO_9255 P
        WHERE T.CODIGO = 'BAJA' AND P.ID_PRODUCTO = :producto`,
      {
        sucursal: usuario.idSucursal,
        cantidad: Number(req.body.cantidad),
        motivo: Number(req.body.motivo),
        empleado: usuario.idEmpleado,
        autoriza: req.body.autoriza ? Number(req.body.autoriza) : null,
        observaciones: req.body.observaciones,
        usuario: usuario.nombreUsuario,
        producto: Number(req.body.producto),
      }
    );
    res.redirect('/bajas?exito=' + encodeURIComponent('Baja registrada.'));
  } catch (error) {
    res.redirect('/bajas?error=' + encodeURIComponent(primeraLinea(error)));
  }
});

module.exports = router;