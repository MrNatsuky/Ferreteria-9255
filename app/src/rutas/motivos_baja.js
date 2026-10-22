const express = require('express');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

router.get('/motivos-baja', requierePermiso('MOTIVOS_BAJA'), async (req, res, next) => {
  try {
    const motivos = await basedatos.consultar(
      `SELECT ID_MOTIVO_BAJA, NOMBRE, DESCRIPCION
         FROM MOTIVO_BAJA_9255
        WHERE FECHA_ELIMINACION IS NULL
        ORDER BY NOMBRE`
    );

    let editar = null;
    if (req.query.editar) {
      editar = motivos.find((c) => c.ID_MOTIVO_BAJA === Number(req.query.editar));
    }

    res.render('motivos_baja', {
      titulo: 'Motivos de baja',
      motivos,
      editar,
      error: req.query.error || null,
    });
  } catch (error) {
    next(error);
  }
});

router.post('/motivos-baja', requierePermiso('MOTIVOS_BAJA', 'crear'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `INSERT INTO MOTIVO_BAJA_9255 (NOMBRE, DESCRIPCION, CREADO_POR)
       VALUES (:nombre, :descripcion, :usuario)`,
      {
        nombre: req.body.nombre,
        descripcion: req.body.descripcion,
        usuario: req.session.usuario.nombreUsuario,
      }
    );
    res.redirect('/motivos-baja');
  } catch (error) {
    res.redirect('/motivos-baja?error=' + encodeURIComponent(error.message));
  }
});

router.post('/motivos-baja/:id/editar', requierePermiso('MOTIVOS_BAJA', 'modificar'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `UPDATE MOTIVO_BAJA_9255
          SET NOMBRE = :nombre,
              DESCRIPCION = :descripcion,
              MODIFICADO_POR = :usuario
        WHERE ID_MOTIVO_BAJA = :id`,
      {
        nombre: req.body.nombre,
        descripcion: req.body.descripcion,
        usuario: req.session.usuario.nombreUsuario,
        id: Number(req.params.id),
      }
    );
    res.redirect('/motivos-baja');
  } catch (error) {
    res.redirect('/motivos-baja?error=' + encodeURIComponent(error.message));
  }
});

router.post('/motivos-baja/:id/eliminar', requierePermiso('MOTIVOS_BAJA', 'eliminar'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `UPDATE MOTIVO_BAJA_9255
          SET FECHA_ELIMINACION = SYSDATE,
              ELIMINADO_POR = :usuario
        WHERE ID_MOTIVO_BAJA = :id`,
      {
        usuario: req.session.usuario.nombreUsuario,
        id: Number(req.params.id),
      }
    );
    res.redirect('/motivos-baja');
  } catch (error) {
    res.redirect('/motivos-baja?error=' + encodeURIComponent(error.message));
  }
});

module.exports = router;