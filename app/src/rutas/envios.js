const express = require('express');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

function primeraLinea(error) {
  return error.message.split('\n')[0];
}

router.get('/envios', requierePermiso('ENVIOS'), async (req, res, next) => {
  try {
    const estado = req.query.estado || 'PROGRAMADO';
    const envios = await basedatos.consultar(
      `SELECT EN.ID_ENVIO, F.SERIE || '-' || F.NUMERO AS FACTURA, C.NOMBRE AS CLIENTE, S.NOMBRE AS SUCURSAL,
              TO_CHAR(EN.FECHA_PROGRAMADA, 'DD/MM/YYYY') AS PROGRAMADA,
              T.CODIGO || '-' || V.PLACA AS PLACA, E.NOMBRES || ' ' || E.APELLIDOS AS PILOTO, EN.ESTADO
         FROM ENVIO_9255 EN
        INNER JOIN FACTURA_9255 F ON F.ID_FACTURA = EN.ID_FACTURA
        INNER JOIN CLIENTE_9255 C ON C.ID_CLIENTE = F.ID_CLIENTE
        INNER JOIN SUCURSAL_9255 S ON S.ID_SUCURSAL = EN.ID_SUCURSAL
        INNER JOIN VEHICULO_9255 V ON V.ID_VEHICULO = EN.ID_VEHICULO
        INNER JOIN TIPO_PLACA_9255 T ON T.ID_TIPO_PLACA = V.ID_TIPO_PLACA
        INNER JOIN PILOTO_9255 PI ON PI.ID_PILOTO = EN.ID_PILOTO
        INNER JOIN EMPLEADO_9255 E ON E.ID_EMPLEADO = PI.ID_EMPLEADO
        WHERE EN.ESTADO = :estado
        ORDER BY EN.FECHA_PROGRAMADA DESC, EN.ID_ENVIO DESC`,
      { estado }
    );
    res.render('envios', { titulo: 'Envios', envios, estado });
  } catch (error) {
    next(error);
  }
});

router.get('/envios/nuevo', requierePermiso('ENVIOS', 'crear'), async (req, res, next) => {
  try {
    const sucursal = req.session.usuario.idSucursal;
    const facturas = await basedatos.consultar(
      `SELECT F.ID_FACTURA, F.SERIE || '-' || F.NUMERO AS FACTURA, C.NOMBRE AS CLIENTE, F.DIRECCION_ENTREGA
         FROM FACTURA_9255 F
        INNER JOIN CLIENTE_9255 C ON C.ID_CLIENTE = F.ID_CLIENTE
        WHERE F.ID_SUCURSAL = :sucursal
          AND F.ESTADO = 'EMITIDA'
          AND F.TIPO_ENTREGA = 'EMPRESA'
          AND NOT EXISTS (SELECT 1 FROM ENVIO_9255 EN
                           WHERE EN.ID_FACTURA = F.ID_FACTURA AND EN.ESTADO <> 'CANCELADO')
        ORDER BY F.ID_FACTURA DESC`,
      { sucursal }
    );
    const vehiculos = await basedatos.consultar(
      `SELECT V.ID_VEHICULO, T.CODIGO || '-' || V.PLACA || ' ' || V.MARCA || ' ' || V.MODELO AS NOMBRE
         FROM VEHICULO_9255 V
        INNER JOIN TIPO_PLACA_9255 T ON T.ID_TIPO_PLACA = V.ID_TIPO_PLACA
        WHERE V.ID_SUCURSAL = :sucursal AND V.ESTADO = 'DISPONIBLE' AND V.FECHA_ELIMINACION IS NULL`,
      { sucursal }
    );
    const pilotos = await basedatos.consultar(
      `SELECT PI.ID_PILOTO, E.NOMBRES || ' ' || E.APELLIDOS || ' (licencia ' || PI.TIPO_LICENCIA || ')' AS NOMBRE
         FROM PILOTO_9255 PI
        INNER JOIN EMPLEADO_9255 E ON E.ID_EMPLEADO = PI.ID_EMPLEADO
        WHERE E.ID_SUCURSAL = :sucursal
          AND PI.ESTADO = 'DISPONIBLE'
          AND PI.FECHA_VENCIMIENTO_LICENCIA >= TRUNC(SYSDATE)
          AND PI.FECHA_ELIMINACION IS NULL`,
      { sucursal }
    );
    res.render('envio_nuevo', { titulo: 'Nuevo envio', facturas, vehiculos, pilotos, error: req.query.error || null });
  } catch (error) {
    next(error);
  }
});

router.post('/envios', requierePermiso('ENVIOS', 'crear'), async (req, res) => {
  const usuario = req.session.usuario;
  try {
    const idEnvio = await basedatos.transaccion(async (conexion) => {
      await conexion.execute(
        `INSERT INTO ENVIO_9255 (ID_FACTURA, ID_SUCURSAL, ID_VEHICULO, ID_PILOTO, ID_EMPLEADO_RESPONSABLE,
                                 FECHA_PROGRAMADA, DIRECCION_ENTREGA, OBSERVACIONES, CREADO_POR)
         SELECT F.ID_FACTURA, F.ID_SUCURSAL, :vehiculo, :piloto, :responsable,
                TO_DATE(:fecha, 'YYYY-MM-DD'), F.DIRECCION_ENTREGA, :observaciones, :usuario
           FROM FACTURA_9255 F
          WHERE F.ID_FACTURA = :factura`,
        {
          vehiculo: Number(req.body.vehiculo),
          piloto: Number(req.body.piloto),
          responsable: usuario.idEmpleado,
          fecha: req.body.fecha,
          observaciones: req.body.observaciones,
          usuario: usuario.nombreUsuario,
          factura: Number(req.body.factura),
        }
      );
      const nuevo = await conexion.execute(`SELECT SEC_ENVIO_9255.CURRVAL AS ID FROM DUAL`);
      const id = nuevo.rows[0].ID;

      await conexion.execute(
        `INSERT INTO DETALLE_ENVIO_9255 (ID_ENVIO, ID_DETALLE_FACTURA, CANTIDAD, CREADO_POR)
         SELECT :id, ID_DETALLE_FACTURA, CANTIDAD, :usuario
           FROM DETALLE_FACTURA_9255
          WHERE ID_FACTURA = :factura`,
        { id, usuario: usuario.nombreUsuario, factura: Number(req.body.factura) }
      );
      return id;
    });
    res.redirect('/envios/' + idEnvio);
  } catch (error) {
    res.redirect('/envios/nuevo?error=' + encodeURIComponent(primeraLinea(error)));
  }
});

router.get('/envios/:id', requierePermiso('ENVIOS'), async (req, res, next) => {
  try {
    const id = Number(req.params.id);
    const [envio] = await basedatos.consultar(
      `SELECT EN.ID_ENVIO, EN.ID_FACTURA, F.SERIE || '-' || F.NUMERO AS FACTURA, C.NOMBRE AS CLIENTE,
              S.NOMBRE AS SUCURSAL, EN.DIRECCION_ENTREGA, EN.ESTADO, EN.OBSERVACIONES,
              TO_CHAR(EN.FECHA_PROGRAMADA, 'DD/MM/YYYY') AS PROGRAMADA,
              TO_CHAR(EN.FECHA_SALIDA, 'DD/MM/YYYY HH24:MI') AS SALIDA,
              TO_CHAR(EN.FECHA_ENTREGA, 'DD/MM/YYYY HH24:MI') AS ENTREGA,
              T.CODIGO AS TIPO_PLACA, T.DESCRIPCION AS DESCRIPCION_PLACA, V.PLACA, V.MARCA, V.MODELO,
              EP.NOMBRES || ' ' || EP.APELLIDOS AS PILOTO, PI.NUMERO_LICENCIA,
              ER.NOMBRES || ' ' || ER.APELLIDOS AS RESPONSABLE
         FROM ENVIO_9255 EN
        INNER JOIN FACTURA_9255 F ON F.ID_FACTURA = EN.ID_FACTURA
        INNER JOIN CLIENTE_9255 C ON C.ID_CLIENTE = F.ID_CLIENTE
        INNER JOIN SUCURSAL_9255 S ON S.ID_SUCURSAL = EN.ID_SUCURSAL
        INNER JOIN VEHICULO_9255 V ON V.ID_VEHICULO = EN.ID_VEHICULO
        INNER JOIN TIPO_PLACA_9255 T ON T.ID_TIPO_PLACA = V.ID_TIPO_PLACA
        INNER JOIN PILOTO_9255 PI ON PI.ID_PILOTO = EN.ID_PILOTO
        INNER JOIN EMPLEADO_9255 EP ON EP.ID_EMPLEADO = PI.ID_EMPLEADO
        INNER JOIN EMPLEADO_9255 ER ON ER.ID_EMPLEADO = EN.ID_EMPLEADO_RESPONSABLE
        WHERE EN.ID_ENVIO = :id`,
      { id }
    );

    if (!envio) {
      return res.status(404).render('mensaje', { titulo: 'Envio', mensaje: 'El envio no existe.' });
    }

    const detalle = await basedatos.consultar(
      `SELECT P.CODIGO, P.NOMBRE, DE.CANTIDAD, P.UNIDAD_MEDIDA
         FROM DETALLE_ENVIO_9255 DE
        INNER JOIN DETALLE_FACTURA_9255 DF ON DF.ID_DETALLE_FACTURA = DE.ID_DETALLE_FACTURA
        INNER JOIN PRODUCTO_9255 P ON P.ID_PRODUCTO = DF.ID_PRODUCTO
        WHERE DE.ID_ENVIO = :id
        ORDER BY DE.ID_DETALLE_ENVIO`,
      { id }
    );

    res.render('envio_detalle', { titulo: 'Envio ' + envio.ID_ENVIO, envio, detalle, error: req.query.error || null });
  } catch (error) {
    next(error);
  }
});

async function cambiarEstado(req, res, estadoActual, estadoNuevo, campoFecha, estadoUnidad) {
  const id = Number(req.params.id);
  const usuario = req.session.usuario.nombreUsuario;
  try {
    await basedatos.transaccion(async (conexion) => {
      const resultado = await conexion.execute(
        `SELECT ESTADO, ID_VEHICULO, ID_PILOTO FROM ENVIO_9255 WHERE ID_ENVIO = :id`,
        { id }
      );
      const envio = resultado.rows[0];
      if (envio.ESTADO !== estadoActual) {
        throw new Error('El envio debe estar ' + estadoActual + ' para pasar a ' + estadoNuevo + '.');
      }

      const fecha = campoFecha ? ', ' + campoFecha + ' = SYSDATE' : '';
      await conexion.execute(
        `UPDATE ENVIO_9255 SET ESTADO = :estado, MODIFICADO_POR = :usuario ${fecha} WHERE ID_ENVIO = :id`,
        { estado: estadoNuevo, usuario, id }
      );

      if (estadoUnidad) {
        await conexion.execute(
          `UPDATE VEHICULO_9255 SET ESTADO = :estado, MODIFICADO_POR = :usuario WHERE ID_VEHICULO = :vehiculo`,
          { estado: estadoUnidad, usuario, vehiculo: envio.ID_VEHICULO }
        );
        await conexion.execute(
          `UPDATE PILOTO_9255 SET ESTADO = :estado, MODIFICADO_POR = :usuario WHERE ID_PILOTO = :piloto`,
          { estado: estadoUnidad, usuario, piloto: envio.ID_PILOTO }
        );
      }
    });
    res.redirect('/envios/' + id);
  } catch (error) {
    res.redirect('/envios/' + id + '?error=' + encodeURIComponent(primeraLinea(error)));
  }
}

router.post('/envios/:id/salida', requierePermiso('ENVIOS', 'modificar'), (req, res) =>
  cambiarEstado(req, res, 'PROGRAMADO', 'EN_RUTA', 'FECHA_SALIDA', 'EN_RUTA')
);

router.post('/envios/:id/entrega', requierePermiso('ENVIOS', 'modificar'), (req, res) =>
  cambiarEstado(req, res, 'EN_RUTA', 'ENTREGADO', 'FECHA_ENTREGA', 'DISPONIBLE')
);

router.post('/envios/:id/cancelar', requierePermiso('ENVIOS', 'modificar'), (req, res) =>
  cambiarEstado(req, res, 'PROGRAMADO', 'CANCELADO', null, null)
);

module.exports = router;