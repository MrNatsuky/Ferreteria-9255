const express = require('express');
const bcrypt = require('bcryptjs');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

router.get('/usuarios', requierePermiso('USUARIOS'), async (req, res, next) => {
  try {
    const usuarios = await basedatos.consultar(
      `SELECT U.ID_USUARIO, U.ID_ROL, U.NOMBRE_USUARIO, R.NOMBRE AS ROL,
              E.NOMBRES || ' ' || E.APELLIDOS AS EMPLEADO, S.NOMBRE AS SUCURSAL,
              TO_CHAR(U.ULTIMO_ACCESO, 'DD/MM/YYYY HH24:MI') AS ULTIMO_ACCESO
         FROM USUARIO_9255 U
        INNER JOIN ROL_9255 R ON R.ID_ROL = U.ID_ROL
        INNER JOIN EMPLEADO_9255 E ON E.ID_EMPLEADO = U.ID_EMPLEADO
        INNER JOIN SUCURSAL_9255 S ON S.ID_SUCURSAL = E.ID_SUCURSAL
        WHERE U.FECHA_ELIMINACION IS NULL
        ORDER BY U.NOMBRE_USUARIO`
    );
    const roles = await basedatos.consultar(
      `SELECT ID_ROL, NOMBRE FROM ROL_9255 WHERE FECHA_ELIMINACION IS NULL ORDER BY NOMBRE`
    );
    const empleados = await basedatos.consultar(
      `SELECT E.ID_EMPLEADO, E.NOMBRES || ' ' || E.APELLIDOS || ' (' || E.PUESTO || ')' AS NOMBRE
         FROM EMPLEADO_9255 E
        WHERE E.FECHA_ELIMINACION IS NULL
          AND NOT EXISTS (SELECT 1 FROM USUARIO_9255 U WHERE U.ID_EMPLEADO = E.ID_EMPLEADO)
        ORDER BY E.NOMBRES`
    );

    let editar = null;
    if (req.query.editar) {
      editar = usuarios.find((u) => u.ID_USUARIO === Number(req.query.editar));
    }

    res.render('usuarios', { titulo: 'Usuarios', usuarios, roles, empleados, editar, error: req.query.error || null });
  } catch (error) {
    next(error);
  }
});

router.post('/usuarios', requierePermiso('USUARIOS', 'crear'), async (req, res) => {
  try {
    if (!req.body.contrasena || req.body.contrasena.length < 8) {
      throw new Error('La contrasena debe tener al menos 8 caracteres.');
    }
    const cifrada = await bcrypt.hash(req.body.contrasena, 10);
    await basedatos.ejecutar(
      `INSERT INTO USUARIO_9255 (ID_EMPLEADO, ID_ROL, NOMBRE_USUARIO, CONTRASENA_CIFRADA, CREADO_POR)
       VALUES (:empleado, :rol, :nombre, :cifrada, :usuario)`,
      {
        empleado: Number(req.body.empleado),
        rol: Number(req.body.rol),
        nombre: req.body.nombre.toLowerCase(),
        cifrada,
        usuario: req.session.usuario.nombreUsuario,
      }
    );
    res.redirect('/usuarios');
  } catch (error) {
    res.redirect('/usuarios?error=' + encodeURIComponent(error.message));
  }
});

router.post('/usuarios/:id/editar', requierePermiso('USUARIOS', 'modificar'), async (req, res) => {
  const id = Number(req.params.id);
  try {
    await basedatos.ejecutar(
      `UPDATE USUARIO_9255 SET ID_ROL = :rol, MODIFICADO_POR = :usuario WHERE ID_USUARIO = :id`,
      { rol: Number(req.body.rol), usuario: req.session.usuario.nombreUsuario, id }
    );

    if (req.body.contrasena) {
      if (req.body.contrasena.length < 8) {
        throw new Error('La contrasena debe tener al menos 8 caracteres.');
      }
      const cifrada = await bcrypt.hash(req.body.contrasena, 10);
      await basedatos.ejecutar(
        `UPDATE USUARIO_9255 SET CONTRASENA_CIFRADA = :cifrada, MODIFICADO_POR = :usuario WHERE ID_USUARIO = :id`,
        { cifrada, usuario: req.session.usuario.nombreUsuario, id }
      );
    }
    res.redirect('/usuarios');
  } catch (error) {
    res.redirect('/usuarios?editar=' + id + '&error=' + encodeURIComponent(error.message));
  }
});

router.post('/usuarios/:id/eliminar', requierePermiso('USUARIOS', 'eliminar'), async (req, res) => {
  try {
    const id = Number(req.params.id);
    if (id === req.session.usuario.idUsuario) {
      throw new Error('No puede desactivar su propio usuario.');
    }
    await basedatos.ejecutar(
      `UPDATE USUARIO_9255 SET FECHA_ELIMINACION = SYSDATE, ELIMINADO_POR = :usuario WHERE ID_USUARIO = :id`,
      { usuario: req.session.usuario.nombreUsuario, id }
    );
    res.redirect('/usuarios');
  } catch (error) {
    res.redirect('/usuarios?error=' + encodeURIComponent(error.message));
  }
});

module.exports = router;