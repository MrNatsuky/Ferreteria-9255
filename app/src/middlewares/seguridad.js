const basedatos = require('../config/basedatos');

function requiereSesion(req, res, next) {
  if (!req.session.usuario) {
    return res.redirect('/login');
  }
  next();
}

async function cargarMenu(req, res, next) {
  try {
    if (!req.session.permisos) {
      req.session.permisos = await basedatos.consultar(
        `SELECT O.CODIGO, O.NOMBRE, O.MODULO, O.RUTA,
                RO.PUEDE_CREAR, RO.PUEDE_MODIFICAR, RO.PUEDE_ELIMINAR
           FROM ROL_OPCION_9255 RO
          INNER JOIN OPCION_9255 O ON O.ID_OPCION = RO.ID_OPCION
          WHERE RO.ID_ROL = :idRol
            AND RO.FECHA_ELIMINACION IS NULL
            AND O.FECHA_ELIMINACION IS NULL
          ORDER BY O.ORDEN`,
        { idRol: req.session.usuario.idRol }
      );
    }

    const menu = [];
    for (const opcion of req.session.permisos) {
      let grupo = menu.find((g) => g.modulo === opcion.MODULO);
      if (!grupo) {
        grupo = { modulo: opcion.MODULO, opciones: [] };
        menu.push(grupo);
      }
      grupo.opciones.push(opcion);
    }

    res.locals.usuario = req.session.usuario;
    res.locals.menu = menu;
    res.locals.rutaActual = req.path;
    next();
  } catch (error) {
    next(error);
  }
}

function requierePermiso(codigo, accion) {
  return (req, res, next) => {
    const permiso = req.session.permisos.find((p) => p.CODIGO === codigo);

    if (!permiso) {
      return res.status(403).send('No tiene acceso a esta opcion.');
    }
    if (accion === 'crear' && permiso.PUEDE_CREAR !== 'S') {
      return res.status(403).send('No tiene permiso para crear registros en esta opcion.');
    }
    if (accion === 'modificar' && permiso.PUEDE_MODIFICAR !== 'S') {
      return res.status(403).send('No tiene permiso para modificar registros en esta opcion.');
    }
    if (accion === 'eliminar' && permiso.PUEDE_ELIMINAR !== 'S') {
      return res.status(403).send('No tiene permiso para eliminar registros en esta opcion.');
    }

    res.locals.permiso = permiso;
    next();
  };
}

module.exports = { requiereSesion, cargarMenu, requierePermiso };