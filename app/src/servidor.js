require('dotenv').config();
const express = require('express');
const basedatos = require('./config/basedatos');

const app = express();
const PUERTO = process.env.PUERTO || 3000;

app.get('/prueba', async (req, res) => {
  try {
    const paises = await basedatos.consultar(
      'SELECT ID_PAIS, NOMBRE, MONEDA_CODIGO, PORCENTAJE_IMPUESTO FROM PAIS_9255 ORDER BY ID_PAIS'
    );
    res.json({ conexion: 'correcta', paises });
  } catch (error) {
    res.status(500).json({ conexion: 'fallida', error: error.message });
  }
});

async function arrancar() {
  try {
    await basedatos.iniciar();
    console.log('Conectado a Oracle como ' + process.env.DB_USUARIO);
  } catch (error) {
    console.error('No se pudo conectar a Oracle: ' + error.message);
    process.exit(1);
  }
  app.listen(PUERTO, () => {
    console.log('Servidor en http://localhost:' + PUERTO);
  });
}

process.on('SIGINT', async () => {
  await basedatos.cerrar();
  process.exit(0);
});

arrancar();