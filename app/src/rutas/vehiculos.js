const express = require('express');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

function datosDelFormulario(req) {
  return {
    sucursal: Number(req.body.sucursal),
    tipo: Number(req.body.tipo),
    placa: req.body.placa.toUpperCase(),
    marca: req.body.marca,
    modelo: req.body.modelo,
    color: req.body.color,
    capacidad: req.body.capacidad ? Number(req.body.capacidad) : null,
    estado: req.body.estado,
    usuario: req.session.usuario.nombreUsuario,
  };
}

router.get('/vehiculos', requierePermiso('VEHICULOS'), async (req, res, next) => {
  try {
    const vehiculos = await basedatos.consultar(
      `SELECT V.ID_VEHICULO, V.ID_SUCURSAL, V.ID_TIPO_PLACA, V.PLACA, V.MARCA, V.MODELO, V.COLOR,
              V.CAPACIDAD_TONELADAS, V.ESTADO, S.NOMBRE AS SUCURSAL, T.CODIGO AS TIPO_PLACA
         FROM VEHICULO_9255 V
        INNER JOIN SUCURSAL_9255 S ON S.ID_SUCURSAL = V.ID_SUCURSAL
        INNER JOIN TIPO_PLACA_9255 T ON T.ID_TIPO_PLACA = V.ID_TIPO_PLACA
        WHERE V.FECHA_ELIMINACION IS NULL
        ORDER BY S.NOMBRE, V.PLACA`
    );
    const sucursales = await basedatos.consultar(
      `SELECT ID_SUCURSAL, NOMBRE FROM SUCURSAL_9255 WHERE FECHA_ELIMINACION IS NULL ORDER BY ID_SUCURSAL`
    );
    const tipos = await basedatos.consultar(
      `SELECT T.ID_TIPO_PLACA, P.NOMBRE || ' - ' || T.CODIGO || ' ' || T.DESCRIPCION AS NOMBRE
         FROM TIPO_PLACA_9255 T
        INNER JOIN PAIS_9255 P ON P.ID_PAIS = T.ID_PAIS
        WHERE T.FECHA_ELIMINACION IS NULL
        ORDER BY P.NOMBRE, T.CODIGO`
    );

    let editar = null;
    if (req.query.editar) {
      editar = vehiculos.find((v) => v.ID_VEHICULO === Number(req.query.editar));
    }

    res.render('vehiculos', { titulo: 'Vehiculos', vehiculos, sucursales, tipos, editar, error: req.query.error || null });
  } catch (error) {
    next(error);
  }
});

router.post('/vehiculos', requierePermiso('VEHICULOS', 'crear'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `INSERT INTO VEHICULO_9255 (ID_SUCURSAL, ID_TIPO_PLACA, PLACA, MARCA, MODELO, COLOR,
                                  CAPACIDAD_TONELADAS, ESTADO, CREADO_POR)
       VALUES (:sucursal, :tipo, :placa, :marca, :modelo, :color, :capacidad, :estado, :usuario)`,
      datosDelFormulario(req)
    );
    res.redirect('/vehiculos');
  } catch (error) {
    res.redirect('/vehiculos?error=' + encodeURIComponent(error.message));
  }
});

router.post('/vehiculos/:id/editar', requierePermiso('VEHICULOS', 'modificar'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `UPDATE VEHICULO_9255
          SET ID_SUCURSAL = :sucursal, ID_TIPO_PLACA = :tipo, PLACA = :placa, MARCA = :marca,
              MODELO = :modelo, COLOR = :color, CAPACIDAD_TONELADAS = :capacidad, ESTADO = :estado,
              MODIFICADO_POR = :usuario
        WHERE ID_VEHICULO = :id`,
      { ...datosDelFormulario(req), id: Number(req.params.id) }
    );
    res.redirect('/vehiculos');
  } catch (error) {
    res.redirect('/vehiculos?error=' + encodeURIComponent(error.message));
  }
});

router.post('/vehiculos/:id/eliminar', requierePermiso('VEHICULOS', 'eliminar'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `UPDATE VEHICULO_9255 SET FECHA_ELIMINACION = SYSDATE, ELIMINADO_POR = :usuario WHERE ID_VEHICULO = :id`,
      { usuario: req.session.usuario.nombreUsuario, id: Number(req.params.id) }
    );
    res.redirect('/vehiculos');
  } catch (error) {
    res.redirect('/vehiculos?error=' + encodeURIComponent(error.message));
  }
});

module.exports = router;