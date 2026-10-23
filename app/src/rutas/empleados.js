const express = require('express');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

function datosDelFormulario(req) {
  return {
    sucursal: Number(req.body.sucursal),
    puesto: req.body.puesto,
    codigo: req.body.codigo.toUpperCase(),
    nombres: req.body.nombres,
    apellidos: req.body.apellidos,
    documento: req.body.documento,
    telefono: req.body.telefono,
    correo: req.body.correo,
    inicio: req.body.inicio,
    fin: req.body.fin || null,
    usuario: req.session.usuario.nombreUsuario,
  };
}

router.get('/empleados', requierePermiso('EMPLEADOS'), async (req, res, next) => {
  try {
    const empleados = await basedatos.consultar(
      `SELECT E.ID_EMPLEADO, E.ID_SUCURSAL, E.PUESTO, E.CODIGO, E.NOMBRES, E.APELLIDOS,
              E.DOCUMENTO_IDENTIDAD, E.TELEFONO, E.CORREO,
              TO_CHAR(E.FECHA_INICIO, 'YYYY-MM-DD') AS FECHA_INICIO,
              TO_CHAR(E.FECHA_FIN, 'YYYY-MM-DD') AS FECHA_FIN, S.NOMBRE AS SUCURSAL
         FROM EMPLEADO_9255 E
        INNER JOIN SUCURSAL_9255 S ON S.ID_SUCURSAL = E.ID_SUCURSAL
        WHERE E.FECHA_ELIMINACION IS NULL
        ORDER BY E.ID_SUCURSAL, E.CODIGO`
    );
    const sucursales = await basedatos.consultar(
      `SELECT ID_SUCURSAL, NOMBRE FROM SUCURSAL_9255 WHERE FECHA_ELIMINACION IS NULL ORDER BY ID_SUCURSAL`
    );

    let editar = null;
    if (req.query.editar) {
      editar = empleados.find((e) => e.ID_EMPLEADO === Number(req.query.editar));
    }

    res.render('empleados', { titulo: 'Empleados', empleados, sucursales, editar, error: req.query.error || null });
  } catch (error) {
    next(error);
  }
});

router.post('/empleados', requierePermiso('EMPLEADOS', 'crear'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `INSERT INTO EMPLEADO_9255 (ID_SUCURSAL, PUESTO, CODIGO, NOMBRES, APELLIDOS, DOCUMENTO_IDENTIDAD,
                                  TELEFONO, CORREO, FECHA_INICIO, FECHA_FIN, CREADO_POR)
       VALUES (:sucursal, :puesto, :codigo, :nombres, :apellidos, :documento, :telefono, :correo,
               TO_DATE(:inicio, 'YYYY-MM-DD'), TO_DATE(:fin, 'YYYY-MM-DD'), :usuario)`,
      datosDelFormulario(req)
    );
    res.redirect('/empleados');
  } catch (error) {
    res.redirect('/empleados?error=' + encodeURIComponent(error.message));
  }
});

router.post('/empleados/:id/editar', requierePermiso('EMPLEADOS', 'modificar'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `UPDATE EMPLEADO_9255
          SET ID_SUCURSAL = :sucursal, PUESTO = :puesto, CODIGO = :codigo, NOMBRES = :nombres,
              APELLIDOS = :apellidos, DOCUMENTO_IDENTIDAD = :documento, TELEFONO = :telefono, CORREO = :correo,
              FECHA_INICIO = TO_DATE(:inicio, 'YYYY-MM-DD'), FECHA_FIN = TO_DATE(:fin, 'YYYY-MM-DD'),
              MODIFICADO_POR = :usuario
        WHERE ID_EMPLEADO = :id`,
      { ...datosDelFormulario(req), id: Number(req.params.id) }
    );
    res.redirect('/empleados');
  } catch (error) {
    res.redirect('/empleados?error=' + encodeURIComponent(error.message));
  }
});

router.post('/empleados/:id/eliminar', requierePermiso('EMPLEADOS', 'eliminar'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `UPDATE EMPLEADO_9255 SET FECHA_ELIMINACION = SYSDATE, ELIMINADO_POR = :usuario WHERE ID_EMPLEADO = :id`,
      { usuario: req.session.usuario.nombreUsuario, id: Number(req.params.id) }
    );
    res.redirect('/empleados');
  } catch (error) {
    res.redirect('/empleados?error=' + encodeURIComponent(error.message));
  }
});

module.exports = router;