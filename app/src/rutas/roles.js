const express = require('express');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

router.get('/roles', requierePermiso('ROLES'), async (req, res, next) => {
  try {
    const roles = await basedatos.consultar(
      `SELECT R.ID_ROL, R.NOMBRE, R.DESCRIPCION,
              (SELECT COUNT(*) FROM USUARIO_9255 U WHERE U.ID_ROL = R.ID_ROL AND U.FECHA_ELIMINACION IS NULL) AS USUARIOS
         FROM ROL_9255 R
        WHERE R.FECHA_ELIMINACION IS NULL
        ORDER BY R.ID_ROL`
    );

    const rol = roles.find((r) => r.ID_ROL === Number(req.query.rol)) || null;
    let opciones = [];
    if (rol) {
      opciones = await basedatos.consultar(
        `SELECT O.ID_OPCION, O.MODULO, O.NOMBRE,
                CASE WHEN RO.ID_ROL_OPCION IS NOT NULL THEN 'S' ELSE 'N' END AS ACCESO,
                NVL(RO.PUEDE_CREAR, 'N') AS PUEDE_CREAR,
                NVL(RO.PUEDE_MODIFICAR, 'N') AS PUEDE_MODIFICAR,
                NVL(RO.PUEDE_ELIMINAR, 'N') AS PUEDE_ELIMINAR
           FROM OPCION_9255 O
           LEFT JOIN ROL_OPCION_9255 RO ON RO.ID_OPCION = O.ID_OPCION
                                       AND RO.ID_ROL = :rol
                                       AND RO.FECHA_ELIMINACION IS NULL
          WHERE O.FECHA_ELIMINACION IS NULL
          ORDER BY O.ORDEN`,
        { rol: rol.ID_ROL }
      );
    }

    res.render('roles', {
      titulo: 'Roles y permisos',
      roles,
      rol,
      opciones,
      error: req.query.error || null,
      exito: req.query.exito || null,
    });
  } catch (error) {
    next(error);
  }
});

router.post('/roles', requierePermiso('ROLES', 'crear'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `INSERT INTO ROL_9255 (NOMBRE, DESCRIPCION, CREADO_POR) VALUES (:nombre, :descripcion, :usuario)`,
      { nombre: req.body.nombre.toUpperCase(), descripcion: req.body.descripcion, usuario: req.session.usuario.nombreUsuario }
    );
    res.redirect('/roles');
  } catch (error) {
    res.redirect('/roles?error=' + encodeURIComponent(error.message));
  }
});

router.post('/roles/:id/permisos', requierePermiso('ROLES', 'modificar'), async (req, res) => {
  const idRol = Number(req.params.id);
  const usuario = req.session.usuario.nombreUsuario;
  const marcado = (nombre) => (req.body[nombre] ? 'S' : 'N');
  try {
    await basedatos.transaccion(async (conexion) => {
      const opciones = await conexion.execute(
        `SELECT O.ID_OPCION, RO.ID_ROL_OPCION
           FROM OPCION_9255 O
           LEFT JOIN ROL_OPCION_9255 RO ON RO.ID_OPCION = O.ID_OPCION AND RO.ID_ROL = :rol
          WHERE O.FECHA_ELIMINACION IS NULL`,
        { rol: idRol }
      );

      for (const o of opciones.rows) {
        const id = o.ID_OPCION;
        const datos = {
          crear: marcado('crear_' + id),
          modificar: marcado('modificar_' + id),
          eliminar: marcado('eliminar_' + id),
          usuario,
        };

        if (req.body['acceso_' + id]) {
          if (o.ID_ROL_OPCION) {
            await conexion.execute(
              `UPDATE ROL_OPCION_9255
                  SET PUEDE_CREAR = :crear, PUEDE_MODIFICAR = :modificar, PUEDE_ELIMINAR = :eliminar,
                      FECHA_ELIMINACION = NULL, ELIMINADO_POR = NULL, MODIFICADO_POR = :usuario
                WHERE ID_ROL_OPCION = :fila`,
              { ...datos, fila: o.ID_ROL_OPCION }
            );
          } else {
            await conexion.execute(
              `INSERT INTO ROL_OPCION_9255 (ID_ROL, ID_OPCION, PUEDE_CREAR, PUEDE_MODIFICAR, PUEDE_ELIMINAR, CREADO_POR)
               VALUES (:rol, :opcion, :crear, :modificar, :eliminar, :usuario)`,
              { ...datos, rol: idRol, opcion: id }
            );
          }
        } else if (o.ID_ROL_OPCION) {
          await conexion.execute(
            `UPDATE ROL_OPCION_9255
                SET FECHA_ELIMINACION = SYSDATE, ELIMINADO_POR = :usuario
              WHERE ID_ROL_OPCION = :fila AND FECHA_ELIMINACION IS NULL`,
            { usuario, fila: o.ID_ROL_OPCION }
          );
        }
      }
    });
    res.redirect('/roles?rol=' + idRol + '&exito=' + encodeURIComponent('Permisos guardados. Los usuarios del rol los veran al volver a iniciar sesion.'));
  } catch (error) {
    res.redirect('/roles?rol=' + idRol + '&error=' + encodeURIComponent(error.message.split('\n')[0]));
  }
});

module.exports = router;