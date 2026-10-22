const express = require('express');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

function datosDelFormulario(req) {
  return {
    categoria: Number(req.body.categoria),
    marca: Number(req.body.marca),
    unidad: req.body.unidad,
    codigo: req.body.codigo.toUpperCase(),
    nombre: req.body.nombre,
    descripcion: req.body.descripcion,
    costo: Number(req.body.costo),
    venta: Number(req.body.venta),
    minima: Number(req.body.minima),
    garantia: Number(req.body.garantia),
    usuario: req.session.usuario.nombreUsuario,
  };
}

router.get('/productos', requierePermiso('PRODUCTOS'), async (req, res, next) => {
  try {
    const productos = await basedatos.consultar(
      `SELECT P.ID_PRODUCTO, P.ID_CATEGORIA, P.ID_MARCA, P.UNIDAD_MEDIDA, P.CODIGO, P.NOMBRE,
              P.DESCRIPCION, P.PRECIO_COSTO, P.PRECIO_VENTA, P.EXISTENCIA_MINIMA, P.MESES_GARANTIA,
              C.NOMBRE AS CATEGORIA, M.NOMBRE AS MARCA
         FROM PRODUCTO_9255 P
        INNER JOIN CATEGORIA_9255 C ON C.ID_CATEGORIA = P.ID_CATEGORIA
        INNER JOIN MARCA_9255 M ON M.ID_MARCA = P.ID_MARCA
        WHERE P.FECHA_ELIMINACION IS NULL
        ORDER BY P.CODIGO`
    );

    const categorias = await basedatos.consultar(
      `SELECT ID_CATEGORIA, NOMBRE FROM CATEGORIA_9255 WHERE FECHA_ELIMINACION IS NULL ORDER BY NOMBRE`
    );

    const marcas = await basedatos.consultar(
      `SELECT ID_MARCA, NOMBRE FROM MARCA_9255 WHERE FECHA_ELIMINACION IS NULL ORDER BY NOMBRE`
    );

    let editar = null;
    if (req.query.editar) {
      editar = productos.find((p) => p.ID_PRODUCTO === Number(req.query.editar));
    }

    res.render('productos', {
      titulo: 'Productos',
      productos,
      categorias,
      marcas,
      editar,
      error: req.query.error || null,
    });
  } catch (error) {
    next(error);
  }
});

router.post('/productos', requierePermiso('PRODUCTOS', 'crear'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `INSERT INTO PRODUCTO_9255 (ID_CATEGORIA, ID_MARCA, UNIDAD_MEDIDA, CODIGO, NOMBRE, DESCRIPCION,
                                  PRECIO_COSTO, PRECIO_VENTA, EXISTENCIA_MINIMA, MESES_GARANTIA, CREADO_POR)
       VALUES (:categoria, :marca, :unidad, :codigo, :nombre, :descripcion,
               :costo, :venta, :minima, :garantia, :usuario)`,
      datosDelFormulario(req)
    );
    res.redirect('/productos');
  } catch (error) {
    res.redirect('/productos?error=' + encodeURIComponent(error.message));
  }
});

router.post('/productos/:id/editar', requierePermiso('PRODUCTOS', 'modificar'), async (req, res) => {
  try {
    const datos = datosDelFormulario(req);
    datos.id = Number(req.params.id);
    await basedatos.ejecutar(
      `UPDATE PRODUCTO_9255
          SET ID_CATEGORIA = :categoria,
              ID_MARCA = :marca,
              UNIDAD_MEDIDA = :unidad,
              CODIGO = :codigo,
              NOMBRE = :nombre,
              DESCRIPCION = :descripcion,
              PRECIO_COSTO = :costo,
              PRECIO_VENTA = :venta,
              EXISTENCIA_MINIMA = :minima,
              MESES_GARANTIA = :garantia,
              MODIFICADO_POR = :usuario
        WHERE ID_PRODUCTO = :id`,
      datos
    );
    res.redirect('/productos');
  } catch (error) {
    res.redirect('/productos?error=' + encodeURIComponent(error.message));
  }
});

router.post('/productos/:id/eliminar', requierePermiso('PRODUCTOS', 'eliminar'), async (req, res) => {
  try {
    await basedatos.ejecutar(
      `UPDATE PRODUCTO_9255 SET FECHA_ELIMINACION = SYSDATE, ELIMINADO_POR = :usuario WHERE ID_PRODUCTO = :id`,
      { usuario: req.session.usuario.nombreUsuario, id: Number(req.params.id) }
    );
    res.redirect('/productos');
  } catch (error) {
    res.redirect('/productos?error=' + encodeURIComponent(error.message));
  }
});

module.exports = router;