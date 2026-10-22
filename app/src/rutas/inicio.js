const express = require('express');
const basedatos = require('../config/basedatos');

const router = express.Router();

router.get('/', async (req, res, next) => {
  try {
    const [ventas] = await basedatos.consultar(
      `SELECT NVL(SUM(ROUND(TOTAL * TIPO_CAMBIO_QUETZAL, 2)), 0) AS TOTAL, COUNT(*) AS CANTIDAD
         FROM FACTURA_9255
        WHERE ESTADO = 'EMITIDA'
          AND TRUNC(FECHA_EMISION, 'MM') = TRUNC(SYSDATE, 'MM')`
    );
    const [clientes] = await basedatos.consultar(
      `SELECT COUNT(*) AS CANTIDAD FROM CLIENTE_9255 WHERE FECHA_ELIMINACION IS NULL`
    );
    const [bajoMinimo] = await basedatos.consultar(
      `SELECT COUNT(*) AS CANTIDAD
         FROM INVENTARIO_9255 I
        INNER JOIN PRODUCTO_9255 P ON P.ID_PRODUCTO = I.ID_PRODUCTO
        WHERE I.EXISTENCIA < P.EXISTENCIA_MINIMA`
    );
    const [envios] = await basedatos.consultar(
      `SELECT COUNT(*) AS CANTIDAD FROM ENVIO_9255 WHERE ESTADO IN ('PROGRAMADO', 'EN_RUTA')`
    );

    res.render('inicio', {
      titulo: 'Inicio',
      indicadores: {
        ventasMes: ventas.TOTAL.toLocaleString('es-GT', { minimumFractionDigits: 2 }),
        facturasMes: ventas.CANTIDAD,
        clientes: clientes.CANTIDAD,
        bajoMinimo: bajoMinimo.CANTIDAD,
        enviosPendientes: envios.CANTIDAD,
      },
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;