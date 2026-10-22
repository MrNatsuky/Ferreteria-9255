const express = require('express');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

function datosDelFormulario(req) {
  return {
    pais: Number(req.body.pais),
    nit: req.body.nit,
    nombre: req.body.nombre,
    contacto: req.body.contacto,
    telefono: req.body.telefono,
    correo: req.body.correo,
    direccion: req.body.direccion,
    dias: Number(req.body.dias),
    usuario: req.session.usuario.nombreUsuario,
  };
}

router.get('/proveedores', requierePermiso('PROVEEDORES'), async (req, res, next) => {
  try {
    const proveedores = await basedatos.consultar(
      `SELECT PR.ID_PROVEEDOR, PR.ID_PAIS, PR.NIT, PR.NOMBRE, PR.NOMBRE_CONTACTO, PR.TELEFONO,
              PR.CORREO, PR.DIRECCION, PR.DIAS_CREDITO, P.NOMBRE AS PAIS
         FROM PROVEEDOR_9255 PR
        INNER JOIN PAIS_9255 P ON P.ID_PAIS = PR.ID_PAIS
        WHERE PR.FECHA_ELIMINACION IS NULL
        ORDER BY PR.NOMBRE`
    );

    const paises = await basedatos.consultar(
      `SELECT ID_PAIS, NOMBRE FROM PAIS_9255 WHERE FECHA_ELIMINACION IS NULL ORDER BY NOMBRE`
    );

    let editar = null;
    if (req.query.editar) {
      editar = proveedores.find((p) => p.ID_PROVEEDOR === Number(req.query.editar));
    }

    res.render('proveedores', { titulo: 'Proveedores', proveedores, paises, editar, error: req.query.error || null });
  } catch (error) {
    next(error);
  }
});

router.post('/proveedores', requierePermiso('PROVEEDORES', 'crear'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `INSERT INTO PROVEEDOR_9255 (ID_PAIS, NIT, NOMBRE, NOMBRE_CONTACTO, TELEFONO, CORREO,
                                   DIRECCION, DIAS_CREDITO, CREADO_POR)
       VALUES (:pais, :nit, :nombre, :contacto, :telefono, :correo, :direccion, :dias, :usuario)`,
      datosDelFormulario(req)
    );
    res.redirect('/proveedores');
  } catch (error) {
    res.redirect('/proveedores?error=' + encodeURIComponent(error.message));
  }
});

router.post('/proveedores/:id/editar', requierePermiso('PROVEEDORES', 'modificar'), async (req, res) => {
  try {
    const datos = datosDelFormulario(req);
    datos.id = Number(req.params.id);
    await basedatos.ejecutar(
      `UPDATE PROVEEDOR_9255
          SET ID_PAIS = :pais,
              NIT = :nit,
              NOMBRE = :nombre,
              NOMBRE_CONTACTO = :contacto,
              TELEFONO = :telefono,
              CORREO = :correo,
              DIRECCION = :direccion,
              DIAS_CREDITO = :dias,
              MODIFICADO_POR = :usuario
        WHERE ID_PROVEEDOR = :id`,
      datos
    );
    res.redirect('/proveedores');
  } catch (error) {
    res.redirect('/proveedores?error=' + encodeURIComponent(error.message));
  }
});

router.post('/proveedores/:id/eliminar', requierePermiso('PROVEEDORES', 'eliminar'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `UPDATE PROVEEDOR_9255 SET FECHA_ELIMINACION = SYSDATE, ELIMINADO_POR = :usuario WHERE ID_PROVEEDOR = :id`,
      { usuario: req.session.usuario.nombreUsuario, id: Number(req.params.id) }
    );
    res.redirect('/proveedores');
  } catch (error) {
    res.redirect('/proveedores?error=' + encodeURIComponent(error.message));
  }
});

module.exports = router;