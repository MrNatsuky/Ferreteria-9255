const express = require('express');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

function datosDelFormulario(req) {
  return {
    region: Number(req.body.region),
    codigo: req.body.codigo.toUpperCase(),
    nombre: req.body.nombre,
    direccion: req.body.direccion,
    telefono: req.body.telefono,
    correo: req.body.correo,
    fecha: req.body.fecha,
    serie: req.body.serie.toUpperCase(),
    usuario: req.session.usuario.nombreUsuario,
  };
}

router.get('/sucursales', requierePermiso('SUCURSALES'), async (req, res, next) => {
  try {
    const sucursales = await basedatos.consultar(
      `SELECT S.ID_SUCURSAL, S.ID_REGION, S.CODIGO, S.NOMBRE, S.DIRECCION, S.TELEFONO, S.CORREO,
              TO_CHAR(S.FECHA_INICIO, 'YYYY-MM-DD') AS FECHA_INICIO, S.SERIE_FACTURA,
              P.NOMBRE || ' - ' || R.NOMBRE AS REGION
         FROM SUCURSAL_9255 S
        INNER JOIN REGION_9255 R ON R.ID_REGION = S.ID_REGION
        INNER JOIN PAIS_9255 P ON P.ID_PAIS = R.ID_PAIS
        WHERE S.FECHA_ELIMINACION IS NULL
        ORDER BY S.ID_SUCURSAL`
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
      editar = sucursales.find((s) => s.ID_SUCURSAL === Number(req.query.editar));
    }

    res.render('sucursales', { titulo: 'Sucursales', sucursales, regiones, editar, error: req.query.error || null });
  } catch (error) {
    next(error);
  }
});

router.post('/sucursales', requierePermiso('SUCURSALES', 'crear'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `INSERT INTO SUCURSAL_9255 (ID_REGION, CODIGO, NOMBRE, DIRECCION, TELEFONO, CORREO,
                                  FECHA_INICIO, SERIE_FACTURA, CREADO_POR)
       VALUES (:region, :codigo, :nombre, :direccion, :telefono, :correo,
               TO_DATE(:fecha, 'YYYY-MM-DD'), :serie, :usuario)`,
      datosDelFormulario(req)
    );
    res.redirect('/sucursales');
  } catch (error) {
    res.redirect('/sucursales?error=' + encodeURIComponent(error.message));
  }
});

router.post('/sucursales/:id/editar', requierePermiso('SUCURSALES', 'modificar'), async (req, res) => {
  try {
    const datos = datosDelFormulario(req);
    datos.id = Number(req.params.id);
    await basedatos.ejecutar(
      `UPDATE SUCURSAL_9255
          SET ID_REGION = :region,
              CODIGO = :codigo,
              NOMBRE = :nombre,
              DIRECCION = :direccion,
              TELEFONO = :telefono,
              CORREO = :correo,
              FECHA_INICIO = TO_DATE(:fecha, 'YYYY-MM-DD'),
              SERIE_FACTURA = :serie,
              MODIFICADO_POR = :usuario
        WHERE ID_SUCURSAL = :id`,
      datos
    );
    res.redirect('/sucursales');
  } catch (error) {
    res.redirect('/sucursales?error=' + encodeURIComponent(error.message));
  }
});

router.post('/sucursales/:id/eliminar', requierePermiso('SUCURSALES', 'eliminar'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `UPDATE SUCURSAL_9255 SET FECHA_ELIMINACION = SYSDATE, ELIMINADO_POR = :usuario WHERE ID_SUCURSAL = :id`,
      { usuario: req.session.usuario.nombreUsuario, id: Number(req.params.id) }
    );
    res.redirect('/sucursales');
  } catch (error) {
    res.redirect('/sucursales?error=' + encodeURIComponent(error.message));
  }
});

module.exports = router;