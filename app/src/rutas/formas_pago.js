const express = require('express');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

router.get('/formas-pago', requierePermiso('FORMAS_PAGO'), async (req, res, next) => {
  try {
    const formas = await basedatos.consultar(
      `SELECT ID_FORMA_PAGO, NOMBRE, REQUIERE_REFERENCIA
         FROM FORMA_PAGO_9255
        WHERE FECHA_ELIMINACION IS NULL
        ORDER BY ID_FORMA_PAGO`
    );

    let editar = null;
    if (req.query.editar) {
      editar = formas.find((f) => f.ID_FORMA_PAGO === Number(req.query.editar));
    }

    res.render('formas_pago', { titulo: 'Formas de pago', formas, editar, error: req.query.error || null });
  } catch (error) {
    next(error);
  }
});

router.post('/formas-pago', requierePermiso('FORMAS_PAGO', 'crear'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `INSERT INTO FORMA_PAGO_9255 (NOMBRE, REQUIERE_REFERENCIA, CREADO_POR)
       VALUES (:nombre, :requiere, :usuario)`,
      { nombre: req.body.nombre, requiere: req.body.requiere, usuario: req.session.usuario.nombreUsuario }
    );
    res.redirect('/formas-pago');
  } catch (error) {
    res.redirect('/formas-pago?error=' + encodeURIComponent(error.message));
  }
});

router.post('/formas-pago/:id/editar', requierePermiso('FORMAS_PAGO', 'modificar'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `UPDATE FORMA_PAGO_9255
          SET NOMBRE = :nombre,
              REQUIERE_REFERENCIA = :requiere,
              MODIFICADO_POR = :usuario
        WHERE ID_FORMA_PAGO = :id`,
      {
        nombre: req.body.nombre,
        requiere: req.body.requiere,
        usuario: req.session.usuario.nombreUsuario,
        id: Number(req.params.id),
      }
    );
    res.redirect('/formas-pago');
  } catch (error) {
    res.redirect('/formas-pago?error=' + encodeURIComponent(error.message));
  }
});

router.post('/formas-pago/:id/eliminar', requierePermiso('FORMAS_PAGO', 'eliminar'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `UPDATE FORMA_PAGO_9255 SET FECHA_ELIMINACION = SYSDATE, ELIMINADO_POR = :usuario WHERE ID_FORMA_PAGO = :id`,
      { usuario: req.session.usuario.nombreUsuario, id: Number(req.params.id) }
    );
    res.redirect('/formas-pago');
  } catch (error) {
    res.redirect('/formas-pago?error=' + encodeURIComponent(error.message));
  }
});

module.exports = router;