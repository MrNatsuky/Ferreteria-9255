const express = require('express');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

router.get('/categorias', requierePermiso('CATEGORIAS'), async (req, res, next) => {
  try {
    const categorias = await basedatos.consultar(
      `SELECT ID_CATEGORIA, NOMBRE, DESCRIPCION
         FROM CATEGORIA_9255
        WHERE FECHA_ELIMINACION IS NULL
        ORDER BY NOMBRE`
    );

    let editar = null;
    if (req.query.editar) {
      editar = categorias.find((c) => c.ID_CATEGORIA === Number(req.query.editar));
    }

    res.render('categorias', {
      titulo: 'Categorias',
      categorias,
      editar,
      error: req.query.error || null,
    });
  } catch (error) {
    next(error);
  }
});

router.post('/categorias', requierePermiso('CATEGORIAS', 'crear'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `INSERT INTO CATEGORIA_9255 (NOMBRE, DESCRIPCION, CREADO_POR)
       VALUES (:nombre, :descripcion, :usuario)`,
      {
        nombre: req.body.nombre,
        descripcion: req.body.descripcion,
        usuario: req.session.usuario.nombreUsuario,
      }
    );
    res.redirect('/categorias');
  } catch (error) {
    res.redirect('/categorias?error=' + encodeURIComponent(error.message));
  }
});

router.post('/categorias/:id/editar', requierePermiso('CATEGORIAS', 'modificar'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `UPDATE CATEGORIA_9255
          SET NOMBRE = :nombre,
              DESCRIPCION = :descripcion,
              MODIFICADO_POR = :usuario
        WHERE ID_CATEGORIA = :id`,
      {
        nombre: req.body.nombre,
        descripcion: req.body.descripcion,
        usuario: req.session.usuario.nombreUsuario,
        id: Number(req.params.id),
      }
    );
    res.redirect('/categorias');
  } catch (error) {
    res.redirect('/categorias?error=' + encodeURIComponent(error.message));
  }
});

router.post('/categorias/:id/eliminar', requierePermiso('CATEGORIAS', 'eliminar'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `UPDATE CATEGORIA_9255
          SET FECHA_ELIMINACION = SYSDATE,
              ELIMINADO_POR = :usuario
        WHERE ID_CATEGORIA = :id`,
      {
        usuario: req.session.usuario.nombreUsuario,
        id: Number(req.params.id),
      }
    );
    res.redirect('/categorias');
  } catch (error) {
    res.redirect('/categorias?error=' + encodeURIComponent(error.message));
  }
});

module.exports = router;