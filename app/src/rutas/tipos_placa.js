const express = require('express');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

function datosDelFormulario(req) {
  return {
    pais: Number(req.body.pais),
    codigo: req.body.codigo.toUpperCase(),
    descripcion: req.body.descripcion,
    usuario: req.session.usuario.nombreUsuario,
  };
}

router.get('/tipos-placa', requierePermiso('TIPOS_PLACA'), async (req, res, next) => {
  try {
    const tipos = await basedatos.consultar(
      `SELECT T.ID_TIPO_PLACA, T.ID_PAIS, T.CODIGO, T.DESCRIPCION, P.NOMBRE AS PAIS
         FROM TIPO_PLACA_9255 T
        INNER JOIN PAIS_9255 P ON P.ID_PAIS = T.ID_PAIS
        WHERE T.FECHA_ELIMINACION IS NULL
        ORDER BY P.NOMBRE, T.CODIGO`
    );
    const paises = await basedatos.consultar(
      `SELECT ID_PAIS, NOMBRE FROM PAIS_9255 WHERE FECHA_ELIMINACION IS NULL ORDER BY NOMBRE`
    );

    let editar = null;
    if (req.query.editar) {
      editar = tipos.find((t) => t.ID_TIPO_PLACA === Number(req.query.editar));
    }

    res.render('tipos_placa', { titulo: 'Tipos de placa', tipos, paises, editar, error: req.query.error || null });
  } catch (error) {
    next(error);
  }
});

router.post('/tipos-placa', requierePermiso('TIPOS_PLACA', 'crear'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `INSERT INTO TIPO_PLACA_9255 (ID_PAIS, CODIGO, DESCRIPCION, CREADO_POR)
       VALUES (:pais, :codigo, :descripcion, :usuario)`,
      datosDelFormulario(req)
    );
    res.redirect('/tipos-placa');
  } catch (error) {
    res.redirect('/tipos-placa?error=' + encodeURIComponent(error.message));
  }
});

router.post('/tipos-placa/:id/editar', requierePermiso('TIPOS_PLACA', 'modificar'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `UPDATE TIPO_PLACA_9255
          SET ID_PAIS = :pais, CODIGO = :codigo, DESCRIPCION = :descripcion, MODIFICADO_POR = :usuario
        WHERE ID_TIPO_PLACA = :id`,
      { ...datosDelFormulario(req), id: Number(req.params.id) }
    );
    res.redirect('/tipos-placa');
  } catch (error) {
    res.redirect('/tipos-placa?error=' + encodeURIComponent(error.message));
  }
});

router.post('/tipos-placa/:id/eliminar', requierePermiso('TIPOS_PLACA', 'eliminar'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `UPDATE TIPO_PLACA_9255 SET FECHA_ELIMINACION = SYSDATE, ELIMINADO_POR = :usuario WHERE ID_TIPO_PLACA = :id`,
      { usuario: req.session.usuario.nombreUsuario, id: Number(req.params.id) }
    );
    res.redirect('/tipos-placa');
  } catch (error) {
    res.redirect('/tipos-placa?error=' + encodeURIComponent(error.message));
  }
});

module.exports = router;