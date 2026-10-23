const express = require('express');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

router.get('/bitacora', requierePermiso('BITACORA'), async (req, res, next) => {
  try {
    const filtros = {
      tabla: req.query.tabla || '',
      accion: req.query.accion || '',
      usuario: req.query.usuario || '',
      desde: req.query.desde || '',
      hasta: req.query.hasta || '',
    };

    let sql = `SELECT ID_BITACORA, TO_CHAR(FECHA_EVENTO, 'DD/MM/YYYY HH24:MI:SS') AS FECHA,
                      TABLA_AFECTADA, ACCION, ID_REGISTRO, USUARIO, DETALLE
                 FROM BITACORA_9255
                WHERE 1 = 1`;
    const parametros = {};

    if (filtros.tabla) {
      sql += ' AND TABLA_AFECTADA = :tabla';
      parametros.tabla = filtros.tabla;
    }
    if (filtros.accion) {
      sql += ' AND ACCION = :accion';
      parametros.accion = filtros.accion;
    }
    if (filtros.usuario) {
      sql += ' AND LOWER(USUARIO) = LOWER(:usuario)';
      parametros.usuario = filtros.usuario;
    }
    if (filtros.desde) {
      sql += " AND FECHA_EVENTO >= TO_DATE(:desde, 'YYYY-MM-DD')";
      parametros.desde = filtros.desde;
    }
    if (filtros.hasta) {
      sql += " AND FECHA_EVENTO < TO_DATE(:hasta, 'YYYY-MM-DD') + 1";
      parametros.hasta = filtros.hasta;
    }
    sql += ' ORDER BY ID_BITACORA DESC FETCH FIRST 200 ROWS ONLY';

    const registros = await basedatos.consultar(sql, parametros);
    const tablas = await basedatos.consultar(
      `SELECT DISTINCT TABLA_AFECTADA FROM BITACORA_9255 ORDER BY TABLA_AFECTADA`
    );

    res.render('bitacora', { titulo: 'Bitacora', registros, tablas, filtros });
  } catch (error) {
    next(error);
  }
});

module.exports = router;