const express = require('express');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

function datosDelFormulario(req) {
  return {
    empleado: Number(req.body.empleado),
    licencia: req.body.licencia.toUpperCase(),
    tipo: req.body.tipo.toUpperCase(),
    vencimiento: req.body.vencimiento,
    estado: req.body.estado,
    usuario: req.session.usuario.nombreUsuario,
  };
}

router.get('/pilotos', requierePermiso('PILOTOS'), async (req, res, next) => {
  try {
    const pilotos = await basedatos.consultar(
      `SELECT PI.ID_PILOTO, PI.ID_EMPLEADO, PI.NUMERO_LICENCIA, PI.TIPO_LICENCIA,
              TO_CHAR(PI.FECHA_VENCIMIENTO_LICENCIA, 'YYYY-MM-DD') AS VENCIMIENTO,
              CASE WHEN PI.FECHA_VENCIMIENTO_LICENCIA < TRUNC(SYSDATE) THEN 'S' ELSE 'N' END AS VENCIDA,
              PI.ESTADO, E.NOMBRES || ' ' || E.APELLIDOS AS NOMBRE, S.NOMBRE AS SUCURSAL
         FROM PILOTO_9255 PI
        INNER JOIN EMPLEADO_9255 E ON E.ID_EMPLEADO = PI.ID_EMPLEADO
        INNER JOIN SUCURSAL_9255 S ON S.ID_SUCURSAL = E.ID_SUCURSAL
        WHERE PI.FECHA_ELIMINACION IS NULL
        ORDER BY S.NOMBRE, E.NOMBRES`
    );
    const empleados = await basedatos.consultar(
      `SELECT E.ID_EMPLEADO, E.NOMBRES || ' ' || E.APELLIDOS || ' (' || S.NOMBRE || ')' AS NOMBRE
         FROM EMPLEADO_9255 E
        INNER JOIN SUCURSAL_9255 S ON S.ID_SUCURSAL = E.ID_SUCURSAL
        WHERE E.FECHA_ELIMINACION IS NULL
        ORDER BY E.NOMBRES`
    );

    let editar = null;
    if (req.query.editar) {
      editar = pilotos.find((p) => p.ID_PILOTO === Number(req.query.editar));
    }

    res.render('pilotos', { titulo: 'Pilotos', pilotos, empleados, editar, error: req.query.error || null });
  } catch (error) {
    next(error);
  }
});

router.post('/pilotos', requierePermiso('PILOTOS', 'crear'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `INSERT INTO PILOTO_9255 (ID_EMPLEADO, NUMERO_LICENCIA, TIPO_LICENCIA, FECHA_VENCIMIENTO_LICENCIA, ESTADO, CREADO_POR)
       VALUES (:empleado, :licencia, :tipo, TO_DATE(:vencimiento, 'YYYY-MM-DD'), :estado, :usuario)`,
      datosDelFormulario(req)
    );
    res.redirect('/pilotos');
  } catch (error) {
    res.redirect('/pilotos?error=' + encodeURIComponent(error.message));
  }
});

router.post('/pilotos/:id/editar', requierePermiso('PILOTOS', 'modificar'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `UPDATE PILOTO_9255
          SET ID_EMPLEADO = :empleado, NUMERO_LICENCIA = :licencia, TIPO_LICENCIA = :tipo,
              FECHA_VENCIMIENTO_LICENCIA = TO_DATE(:vencimiento, 'YYYY-MM-DD'), ESTADO = :estado,
              MODIFICADO_POR = :usuario
        WHERE ID_PILOTO = :id`,
      { ...datosDelFormulario(req), id: Number(req.params.id) }
    );
    res.redirect('/pilotos');
  } catch (error) {
    res.redirect('/pilotos?error=' + encodeURIComponent(error.message));
  }
});

router.post('/pilotos/:id/eliminar', requierePermiso('PILOTOS', 'eliminar'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `UPDATE PILOTO_9255 SET FECHA_ELIMINACION = SYSDATE, ELIMINADO_POR = :usuario WHERE ID_PILOTO = :id`,
      { usuario: req.session.usuario.nombreUsuario, id: Number(req.params.id) }
    );
    res.redirect('/pilotos');
  } catch (error) {
    res.redirect('/pilotos?error=' + encodeURIComponent(error.message));
  }
});

module.exports = router;