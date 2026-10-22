const express = require('express');
const bcrypt = require('bcryptjs');
const basedatos = require('../config/basedatos');

const router = express.Router();

router.get('/login', (req, res) => {
  if (req.session.usuario) {
    return res.redirect('/');
  }
  res.render('login', { error: null, usuario: '' });
});

router.post('/login', async (req, res) => {
  const { usuario, contrasena } = req.body;
  try {
    const filas = await basedatos.consultar(
      `SELECT U.ID_USUARIO, U.NOMBRE_USUARIO, U.CONTRASENA_CIFRADA, U.ID_ROL, R.NOMBRE AS ROL,
              E.ID_EMPLEADO, E.ID_SUCURSAL, E.NOMBRES || ' ' || E.APELLIDOS AS NOMBRE_COMPLETO
         FROM USUARIO_9255 U
        INNER JOIN ROL_9255 R ON R.ID_ROL = U.ID_ROL
        INNER JOIN EMPLEADO_9255 E ON E.ID_EMPLEADO = U.ID_EMPLEADO
        WHERE U.NOMBRE_USUARIO = :usuario
          AND U.FECHA_ELIMINACION IS NULL`,
      { usuario }
    );

    if (filas.length === 0) {
      return res.render('login', { error: 'Usuario o contrasena incorrectos.', usuario });
    }

    const encontrado = filas[0];
    const contrasenaValida = await bcrypt.compare(contrasena, encontrado.CONTRASENA_CIFRADA);

    if (!contrasenaValida) {
      return res.render('login', { error: 'Usuario o contrasena incorrectos.', usuario });
    }

    await basedatos.ejecutar(
      `UPDATE USUARIO_9255
          SET ULTIMO_ACCESO = SYSDATE,
              MODIFICADO_POR = :usuario
        WHERE ID_USUARIO = :id`,
      { usuario: encontrado.NOMBRE_USUARIO, id: encontrado.ID_USUARIO }
    );

    await basedatos.ejecutar(
      `BEGIN PRC_REGISTRAR_BITACORA_9255('USUARIO_9255', 'INICIO_SESION', :id, :usuario, NULL); END;`,
      { id: encontrado.ID_USUARIO, usuario: encontrado.NOMBRE_USUARIO }
    );

    req.session.usuario = {
      idUsuario: encontrado.ID_USUARIO,
      nombreUsuario: encontrado.NOMBRE_USUARIO,
      nombreCompleto: encontrado.NOMBRE_COMPLETO,
      idRol: encontrado.ID_ROL,
      rol: encontrado.ROL,
      idEmpleado: encontrado.ID_EMPLEADO,
      idSucursal: encontrado.ID_SUCURSAL,
    };

    res.redirect('/');
  } catch (error) {
    res.render('login', { error: 'Error al conectar con la base de datos: ' + error.message, usuario });
  }
});

router.get('/logout', async (req, res) => {
  if (req.session.usuario) {
    try {
      await basedatos.ejecutar(
        `BEGIN PRC_REGISTRAR_BITACORA_9255('USUARIO_9255', 'CIERRE_SESION', :id, :usuario, NULL); END;`,
        { id: req.session.usuario.idUsuario, usuario: req.session.usuario.nombreUsuario }
      );
    } catch (error) {
      console.error(error.message);
    }
  }
  req.session.destroy(() => {
    res.redirect('/login');
  });
});

module.exports = router;