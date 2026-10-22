require('dotenv').config();
const path = require('path');
const express = require('express');
const session = require('express-session');
const basedatos = require('./config/basedatos');
const rutasAutenticacion = require('./rutas/autenticacion');

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

app.get('/', (req, res) => {
  if (!req.session.usuario) {
    return res.redirect('/login');
  }
  const u = req.session.usuario;
  res.send('Bienvenido ' + u.nombreCompleto + ' (' + u.rol + ') - <a href="/logout">Cerrar sesion</a>');
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