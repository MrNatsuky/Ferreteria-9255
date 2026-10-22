const express = require('express');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

router.get('/regiones', requierePermiso('REGIONES'), async (req, res, next) => {
  try {
    const regiones = await basedatos.consultar(
      `SELECT R.ID_REGION, R.ID_PAIS, R.NOMBRE, P.NOMBRE AS PAIS
         FROM REGION_9255 R
        INNER JOIN PAIS_9255 P ON P.ID_PAIS = R.ID_PAIS
        WHERE R.FECHA_ELIMINACION IS NULL
        ORDER BY P.NOMBRE, R.NOMBRE`
    );

    const paises = await basedatos.consultar(
      `SELECT ID_PAIS, NOMBRE FROM PAIS_9255 WHERE FECHA_ELIMINACION IS NULL ORDER BY NOMBRE`
    );

    let editar = null;
    if (req.query.editar) {
      editar = regiones.find((r) => r.ID_REGION === Number(req.query.editar));
    }

    res.render('regiones', { titulo: 'Regiones', regiones, paises, editar, error: req.query.error || null });
  } catch (error) {
    next(error);
  }
});

router.post('/regiones', requierePermiso('REGIONES', 'crear'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `INSERT INTO REGION_9255 (ID_PAIS, NOMBRE, CREADO_POR) VALUES (:pais, :nombre, :usuario)`,
      { pais: Number(req.body.pais), nombre: req.body.nombre, usuario: req.session.usuario.nombreUsuario }
    );
    res.redirect('/regiones');
  } catch (error) {
    res.redirect('/regiones?error=' + encodeURIComponent(error.message));
  }
});

router.post('/regiones/:id/editar', requierePermiso('REGIONES', 'modificar'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `UPDATE REGION_9255
          SET ID_PAIS = :pais,
              NOMBRE = :nombre,
              MODIFICADO_POR = :usuario
        WHERE ID_REGION = :id`,
      {
        pais: Number(req.body.pais),
        nombre: req.body.nombre,
        usuario: req.session.usuario.nombreUsuario,
        id: Number(req.params.id),
      }
    );
    res.redirect('/regiones');
  } catch (error) {
    res.redirect('/regiones?error=' + encodeURIComponent(error.message));
  }
});

router.post('/regiones/:id/eliminar', requierePermiso('REGIONES', 'eliminar'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `UPDATE REGION_9255 SET FECHA_ELIMINACION = SYSDATE, ELIMINADO_POR = :usuario WHERE ID_REGION = :id`,
      { usuario: req.session.usuario.nombreUsuario, id: Number(req.params.id) }
    );
    res.redirect('/regiones');
  } catch (error) {
    res.redirect('/regiones?error=' + encodeURIComponent(error.message));
  }
});

module.exports = router;