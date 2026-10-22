const express = require('express');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

function datosDelFormulario(req) {
  return {
    region: Number(req.body.region),
    tipo: req.body.tipo,
    nit: req.body.nit.toUpperCase(),
    nombre: req.body.nombre,
    telefono: req.body.telefono,
    correo: req.body.correo,
    direccion: req.body.direccion,
    limite: Number(req.body.limite),
    dias: Number(req.body.dias),
    usuario: req.session.usuario.nombreUsuario,
  };
}

router.get('/clientes', requierePermiso('CLIENTES'), async (req, res, next) => {
  try {
    const clientes = await basedatos.consultar(
      `SELECT C.ID_CLIENTE, C.ID_REGION, C.TIPO_CLIENTE, C.NIT, C.NOMBRE, C.TELEFONO, C.CORREO,
              C.DIRECCION, C.LIMITE_CREDITO, C.DIAS_CREDITO, P.NOMBRE || ' - ' || R.NOMBRE AS REGION
         FROM CLIENTE_9255 C
        INNER JOIN REGION_9255 R ON R.ID_REGION = C.ID_REGION
        INNER JOIN PAIS_9255 P ON P.ID_PAIS = R.ID_PAIS
        WHERE C.FECHA_ELIMINACION IS NULL
        ORDER BY C.NOMBRE`
    );

    const regiones = await basedatos.consultar(
      `SELECT R.ID_REGION, P.NOMBRE || ' - ' || R.NOMBRE AS NOMBRE
         FROM REGION_9255 R
        INNER JOIN PAIS_9255 P ON P.ID_PAIS = R.ID_PAIS
        WHERE R.FECHA_ELIMINACION IS NULL
        ORDER BY P.NOMBRE, R.NOMBRE`
    );

    let editar = null;
    if (req.query.editar) {
      editar = clientes.find((c) => c.ID_CLIENTE === Number(req.query.editar));
    }

    res.render('clientes', { titulo: 'Clientes', clientes, regiones, editar, error: req.query.error || null });
  } catch (error) {
    next(error);
  }
});

router.post('/clientes', requierePermiso('CLIENTES', 'crear'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `INSERT INTO CLIENTE_9255 (ID_REGION, TIPO_CLIENTE, NIT, NOMBRE, TELEFONO, CORREO, DIRECCION,
                                 LIMITE_CREDITO, DIAS_CREDITO, CREADO_POR)
       VALUES (:region, :tipo, :nit, :nombre, :telefono, :correo, :direccion, :limite, :dias, :usuario)`,
      datosDelFormulario(req)
    );
    res.redirect('/clientes');
  } catch (error) {
    res.redirect('/clientes?error=' + encodeURIComponent(error.message));
  }
});

router.post('/clientes/:id/editar', requierePermiso('CLIENTES', 'modificar'), async (req, res) => {
  try {
    const datos = datosDelFormulario(req);
    datos.id = Number(req.params.id);
    await basedatos.ejecutar(
      `UPDATE CLIENTE_9255
          SET ID_REGION = :region,
              TIPO_CLIENTE = :tipo,
              NIT = :nit,
              NOMBRE = :nombre,
              TELEFONO = :telefono,
              CORREO = :correo,
              DIRECCION = :direccion,
              LIMITE_CREDITO = :limite,
              DIAS_CREDITO = :dias,
              MODIFICADO_POR = :usuario
        WHERE ID_CLIENTE = :id`,
      datos
    );
    res.redirect('/clientes');
  } catch (error) {
    res.redirect('/clientes?error=' + encodeURIComponent(error.message));
  }
});

router.post('/clientes/:id/eliminar', requierePermiso('CLIENTES', 'eliminar'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `UPDATE CLIENTE_9255 SET FECHA_ELIMINACION = SYSDATE, ELIMINADO_POR = :usuario WHERE ID_CLIENTE = :id`,
      { usuario: req.session.usuario.nombreUsuario, id: Number(req.params.id) }
    );
    res.redirect('/clientes');
  } catch (error) {
    res.redirect('/clientes?error=' + encodeURIComponent(error.message));
  }
});

module.exports = router;