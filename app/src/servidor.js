require('dotenv').config();
const path = require('path');
const express = require('express');
const session = require('express-session');
const basedatos = require('./config/basedatos');
const rutasAutenticacion = require('./rutas/autenticacion');
const rutasInicio = require('./rutas/inicio');
const rutasCategorias = require('./rutas/categorias');
const rutasMotivosBaja = require('./rutas/motivos_baja');
const rutasMarcas = require('./rutas/marcas');
const rutasFormasPago = require('./rutas/formas_pago');
const rutasPaises = require('./rutas/paises');
const rutasRegiones = require('./rutas/regiones');
const rutasSucursales = require('./rutas/sucursales');
const rutasProveedores = require('./rutas/proveedores');
const rutasClientes = require('./rutas/clientes');
const rutasProductos = require('./rutas/productos');
const rutasFacturas = require('./rutas/facturas');
const rutasInventario = require('./rutas/inventario');
const rutasCuentasCobrar = require('./rutas/cuentas_cobrar');
const rutasCompras = require('./rutas/compras');
const { requiereSesion, cargarMenu } = require('./middlewares/seguridad');

const app = express();
const PUERTO = process.env.PUERTO || 3000;

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, '..', 'views'));

app.use(express.static(path.join(__dirname, '..', 'public')));
app.use(express.urlencoded({ extended: true }));
app.use(session({
  secret: process.env.SESION_SECRETO,
  resave: false,
  saveUninitialized: false,
  cookie: { maxAge: 1000 * 60 * 60 * 2 },
}));

app.use(rutasAutenticacion);
app.use(requiereSesion, cargarMenu);

app.use(rutasInicio);
app.use(rutasCategorias);
app.use(rutasMotivosBaja);
app.use(rutasMarcas);
app.use(rutasFormasPago);
app.use(rutasPaises);
app.use(rutasRegiones);
app.use(rutasSucursales);
app.use(rutasProveedores);
app.use(rutasClientes);
app.use(rutasProductos);
app.use(rutasFacturas);
app.use(rutasInventario);
app.use(rutasCuentasCobrar);
app.use(rutasCompras);

app.use((req, res) => {
  res.status(404).render('mensaje', {
    titulo: 'En construcción',
    mensaje: 'Esta opción todavía está en desarrollo.',
  });
});

app.use((error, req, res, next) => {
  console.error(error);
  res.status(500).render('mensaje', {
    titulo: 'Error',
    mensaje: 'Ocurrió un error: ' + error.message,
  });
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