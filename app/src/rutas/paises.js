const express = require('express');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

function datosDelFormulario(req) {
  return {
    codigo: req.body.codigo.toUpperCase(),
    nombre: req.body.nombre,
    moneda: req.body.moneda.toUpperCase(),
    simbolo: req.body.simbolo,
    impuesto: req.body.impuesto,
    porcentaje: Number(req.body.porcentaje),
    cambio: Number(req.body.cambio),
    usuario: req.session.usuario.nombreUsuario,
  };
}

router.get('/paises', requierePermiso('PAISES'), async (req, res, next) => {
  try {
    const paises = await basedatos.consultar(
      `SELECT ID_PAIS, CODIGO_ISO, NOMBRE, MONEDA_CODIGO, MONEDA_SIMBOLO,
              NOMBRE_IMPUESTO, PORCENTAJE_IMPUESTO, TIPO_CAMBIO_QUETZAL
         FROM PAIS_9255
        WHERE FECHA_ELIMINACION IS NULL
        ORDER BY ID_PAIS`
    );

    let editar = null;
    if (req.query.editar) {
      editar = paises.find((p) => p.ID_PAIS === Number(req.query.editar));
    }

    res.render('paises', { titulo: 'Paises', paises, editar, error: req.query.error || null });
  } catch (error) {
    next(error);
  }
});

router.post('/paises', requierePermiso('PAISES', 'crear'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `INSERT INTO PAIS_9255 (CODIGO_ISO, NOMBRE, MONEDA_CODIGO, MONEDA_SIMBOLO, NOMBRE_IMPUESTO,
                              PORCENTAJE_IMPUESTO, TIPO_CAMBIO_QUETZAL, CREADO_POR)
       VALUES (:codigo, :nombre, :moneda, :simbolo, :impuesto, :porcentaje, :cambio, :usuario)`,
      datosDelFormulario(req)
    );
    res.redirect('/paises');
  } catch (error) {
    res.redirect('/paises?error=' + encodeURIComponent(error.message));
  }
});

router.post('/paises/:id/editar', requierePermiso('PAISES', 'modificar'), async (req, res) => {
  try {
    const datos = datosDelFormulario(req);
    datos.id = Number(req.params.id);
    await basedatos.ejecutar(
      `UPDATE PAIS_9255
          SET CODIGO_ISO = :codigo,
              NOMBRE = :nombre,
              MONEDA_CODIGO = :moneda,
              MONEDA_SIMBOLO = :simbolo,
              NOMBRE_IMPUESTO = :impuesto,
              PORCENTAJE_IMPUESTO = :porcentaje,
              TIPO_CAMBIO_QUETZAL = :cambio,
              MODIFICADO_POR = :usuario
        WHERE ID_PAIS = :id`,
      datos
    );
    res.redirect('/paises');
  } catch (error) {
    res.redirect('/paises?error=' + encodeURIComponent(error.message));
  }
});

router.post('/paises/:id/eliminar', requierePermiso('PAISES', 'eliminar'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `UPDATE PAIS_9255 SET FECHA_ELIMINACION = SYSDATE, ELIMINADO_POR = :usuario WHERE ID_PAIS = :id`,
      { usuario: req.session.usuario.nombreUsuario, id: Number(req.params.id) }
    );
    res.redirect('/paises');
  } catch (error) {
    res.redirect('/paises?error=' + encodeURIComponent(error.message));
  }
});

module.exports = router;