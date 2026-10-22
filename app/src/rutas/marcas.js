const express = require('express');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

router.get('/marcas', requierePermiso('MARCAS'), async (req, res, next) => {
  try {
    const marcas = await basedatos.consultar(
      `SELECT ID_MARCA, NOMBRE
         FROM MARCA_9255
        WHERE FECHA_ELIMINACION IS NULL
        ORDER BY NOMBRE`
    );

    let editar = null;
    if (req.query.editar) {
      editar = marcas.find((m) => m.ID_MARCA === Number(req.query.editar));
    }

    res.render('marcas', { titulo: 'Marcas', marcas, editar, error: req.query.error || null });
  } catch (error) {
    next(error);
  }
});

router.post('/marcas', requierePermiso('MARCAS', 'crear'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `INSERT INTO MARCA_9255 (NOMBRE, CREADO_POR) VALUES (:nombre, :usuario)`,
      { nombre: req.body.nombre, usuario: req.session.usuario.nombreUsuario }
    );
    res.redirect('/marcas');
  } catch (error) {
    res.redirect('/marcas?error=' + encodeURIComponent(error.message));
  }
});

router.post('/marcas/:id/editar', requierePermiso('MARCAS', 'modificar'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `UPDATE MARCA_9255 SET NOMBRE = :nombre, MODIFICADO_POR = :usuario WHERE ID_MARCA = :id`,
      { nombre: req.body.nombre, usuario: req.session.usuario.nombreUsuario, id: Number(req.params.id) }
    );
    res.redirect('/marcas');
  } catch (error) {
    res.redirect('/marcas?error=' + encodeURIComponent(error.message));
  }
});

router.post('/marcas/:id/eliminar', requierePermiso('MARCAS', 'eliminar'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `UPDATE MARCA_9255 SET FECHA_ELIMINACION = SYSDATE, ELIMINADO_POR = :usuario WHERE ID_MARCA = :id`,
      { usuario: req.session.usuario.nombreUsuario, id: Number(req.params.id) }
    );
    res.redirect('/marcas');
  } catch (error) {
    res.redirect('/marcas?error=' + encodeURIComponent(error.message));
  }
});

module.exports = router;