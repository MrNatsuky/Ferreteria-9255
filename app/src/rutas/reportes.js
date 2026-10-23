const express = require('express');
const ExcelJS = require('exceljs');
const PDFDocument = require('pdfkit');
const basedatos = require('../config/basedatos');
const { requierePermiso } = require('../middlewares/seguridad');

const router = express.Router();

const reportes = {
  clientes: {
    titulo: 'Clientes que mas compran por region',
    vista: 'VW_CLIENTES_POR_REGION_9255',
    filtraPais: true,
    orden: 'PAIS, REGION, TOTAL_QUETZALES',
    columnas: [
      { campo: 'PAIS', titulo: 'Pais' },
      { campo: 'REGION', titulo: 'Region' },
      { campo: 'CLIENTE', titulo: 'Cliente' },
      { campo: 'CANTIDAD_FACTURAS', titulo: 'Facturas' },
      { campo: 'TOTAL_QUETZALES', titulo: 'Total (Q)', dinero: true },
    ],
  },
  vendedores: {
    titulo: 'Vendedores que mas venden por area',
    vista: 'VW_VENDEDORES_POR_REGION_9255',
    filtraPais: true,
    orden: 'PAIS, REGION, TOTAL_QUETZALES',
    columnas: [
      { campo: 'PAIS', titulo: 'Pais' },
      { campo: 'REGION', titulo: 'Region' },
      { campo: 'SUCURSAL', titulo: 'Sucursal' },
      { campo: 'VENDEDOR', titulo: 'Vendedor' },
      { campo: 'CANTIDAD_FACTURAS', titulo: 'Facturas' },
      { campo: 'TOTAL_QUETZALES', titulo: 'Total (Q)', dinero: true },
    ],
  },
  productos: {
    titulo: 'Productos mas y menos vendidos',
    vista: 'VW_PRODUCTOS_VENDIDOS_9255',
    filtraPais: false,
    orden: 'UNIDADES_VENDIDAS',
    columnas: [
      { campo: 'CODIGO', titulo: 'Codigo' },
      { campo: 'PRODUCTO', titulo: 'Producto' },
      { campo: 'CATEGORIA', titulo: 'Categoria' },
      { campo: 'UNIDADES_VENDIDAS', titulo: 'Unidades vendidas' },
      { campo: 'TOTAL_QUETZALES', titulo: 'Total (Q)', dinero: true },
    ],
  },
  envios: {
    titulo: 'Tiendas con mas envios y sus responsables',
    vista: 'VW_ENVIOS_POR_SUCURSAL_9255',
    filtraPais: true,
    orden: 'TOTAL_ENVIOS',
    columnas: [
      { campo: 'PAIS', titulo: 'Pais' },
      { campo: 'SUCURSAL', titulo: 'Sucursal' },
      { campo: 'RESPONSABLE', titulo: 'Responsable' },
      { campo: 'TOTAL_ENVIOS', titulo: 'Envios' },
      { campo: 'ENTREGADOS', titulo: 'Entregados' },
      { campo: 'PENDIENTES', titulo: 'Pendientes' },
    ],
  },
};

async function obtenerReporte(query) {
  const tipo = reportes[query.tipo] ? query.tipo : 'clientes';
  const reporte = reportes[tipo];
  const orden = query.orden === 'ASC' ? 'ASC' : 'DESC';
  const pais = reporte.filtraPais && query.pais ? query.pais : '';

  const campos = reporte.columnas.map((c) => c.campo).join(', ');
  let sql = `SELECT ${campos} FROM ${reporte.vista}`;
  const parametros = {};
  if (pais) {
    sql += ' WHERE PAIS = :pais';
    parametros.pais = pais;
  }
  sql += ` ORDER BY ${reporte.orden} ${orden}`;

  const filas = await basedatos.consultar(sql, parametros);
  return { tipo, reporte, orden, pais, filas };
}

function valorTexto(fila, columna) {
  const valor = fila[columna.campo];
  if (valor === null || valor === undefined) {
    return '';
  }
  return columna.dinero ? valor.toFixed(2) : String(valor);
}

router.get('/reportes', requierePermiso('REPORTES'), async (req, res, next) => {
  try {
    const datos = await obtenerReporte(req.query);
    const paises = await basedatos.consultar(
      `SELECT NOMBRE FROM PAIS_9255 WHERE FECHA_ELIMINACION IS NULL ORDER BY NOMBRE`
    );
    const consulta = new URLSearchParams({ tipo: datos.tipo, pais: datos.pais, orden: datos.orden }).toString();
    res.render('reportes', { titulo: 'Reportes gerenciales', reportes, paises, consulta, valorTexto, ...datos });
  } catch (error) {
    next(error);
  }
});

router.get('/reportes/excel', requierePermiso('REPORTES'), async (req, res, next) => {
  try {
    const { tipo, reporte, pais, filas } = await obtenerReporte(req.query);

    const libro = new ExcelJS.Workbook();
    const hoja = libro.addWorksheet('Reporte');
    hoja.addRow(["Ferreteria Mr. Natsuky's"]).font = { bold: true, size: 14 };
    hoja.addRow([reporte.titulo + (pais ? ' - ' + pais : '')]).font = { bold: true };
    hoja.addRow(['Generado por ' + req.session.usuario.nombreUsuario + ' el ' + new Date().toLocaleString('es-GT')]);
    hoja.addRow([]);
    hoja.addRow(reporte.columnas.map((c) => c.titulo)).font = { bold: true };
    filas.forEach((f) => hoja.addRow(reporte.columnas.map((c) => f[c.campo])));
    hoja.columns.forEach((columna) => {
      columna.width = 25;
    });

    res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    res.setHeader('Content-Disposition', 'attachment; filename=reporte_' + tipo + '.xlsx');
    await libro.xlsx.write(res);
    res.end();
  } catch (error) {
    next(error);
  }
});

router.get('/reportes/pdf', requierePermiso('REPORTES'), async (req, res, next) => {
  try {
    const { tipo, reporte, pais, filas } = await obtenerReporte(req.query);

    const doc = new PDFDocument({ size: 'A4', layout: 'landscape', margin: 40 });
    res.setHeader('Content-Type', 'application/pdf');
    res.setHeader('Content-Disposition', 'attachment; filename=reporte_' + tipo + '.pdf');
    doc.pipe(res);

    doc.font('Helvetica-Bold').fontSize(16).text("Ferreteria Mr. Natsuky's");
    doc.fontSize(12).text(reporte.titulo + (pais ? ' - ' + pais : ''));
    doc.font('Helvetica').fontSize(9)
      .text('Generado por ' + req.session.usuario.nombreUsuario + ' el ' + new Date().toLocaleString('es-GT'));
    doc.moveDown();

    const ancho = (doc.page.width - 80) / reporte.columnas.length;

    function escribirFila(valores, negrita) {
      doc.font(negrita ? 'Helvetica-Bold' : 'Helvetica').fontSize(9);
      const alto = Math.max(...valores.map((v) => doc.heightOfString(v, { width: ancho - 6 })));
      if (doc.y + alto > doc.page.height - 50) {
        doc.addPage();
      }
      const y = doc.y;
      valores.forEach((v, i) => {
        doc.text(v, 40 + i * ancho, y, { width: ancho - 6 });
      });
      doc.y = y + alto + 6;
    }

    escribirFila(reporte.columnas.map((c) => c.titulo), true);
    filas.forEach((f) => escribirFila(reporte.columnas.map((c) => valorTexto(f, c)), false));

    doc.end();
  } catch (error) {
    next(error);
  }
});
router.get('/graficas', requierePermiso('GRAFICAS'), async (req, res, next) => {
  try {
    const ventasMes = await basedatos.consultar(
      `SELECT TO_CHAR(TRUNC(FECHA_EMISION, 'MM'), 'MM/YYYY') AS MES,
              SUM(ROUND(TOTAL * TIPO_CAMBIO_QUETZAL, 2)) AS TOTAL
         FROM FACTURA_9255
        WHERE ESTADO = 'EMITIDA'
          AND FECHA_EMISION >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -11)
        GROUP BY TRUNC(FECHA_EMISION, 'MM')
        ORDER BY TRUNC(FECHA_EMISION, 'MM')`
    );
    const ventasPais = await basedatos.consultar(
      `SELECT PAIS, SUM(TOTAL_QUETZALES) AS TOTAL
         FROM VW_VENDEDORES_POR_REGION_9255
        GROUP BY PAIS
        ORDER BY PAIS`
    );
    const topProductos = await basedatos.consultar(
      `SELECT PRODUCTO, UNIDADES_VENDIDAS
         FROM VW_PRODUCTOS_VENDIDOS_9255
        ORDER BY UNIDADES_VENDIDAS DESC
        FETCH FIRST 5 ROWS ONLY`
    );

    res.render('graficas', {
      titulo: 'Graficas estadisticas',
      ventasMes: {
        etiquetas: ventasMes.map((f) => f.MES),
        valores: ventasMes.map((f) => f.TOTAL),
      },
      ventasPais: {
        etiquetas: ventasPais.map((f) => f.PAIS),
        valores: ventasPais.map((f) => f.TOTAL),
      },
      topProductos: {
        etiquetas: topProductos.map((f) => f.PRODUCTO),
        valores: topProductos.map((f) => f.UNIDADES_VENDIDAS),
      },
    });
  } catch (error) {
    next(error);
  }
});
module.exports = router;