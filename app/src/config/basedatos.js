const oracledb = require('oracledb');

oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;

let pool;

async function iniciar() {
  pool = await oracledb.createPool({
    user: process.env.DB_USUARIO,
    password: process.env.DB_CONTRASENA,
    connectString: process.env.DB_CADENA,
    poolMin: 1,
    poolMax: 5,
  });
}

async function consultar(sql, parametros = {}) {
  const conexion = await pool.getConnection();
  try {
    const resultado = await conexion.execute(sql, parametros);
    return resultado.rows;
  } finally {
    await conexion.close();
  }
}

async function ejecutar(sql, parametros = {}) {
  const conexion = await pool.getConnection();
  try {
    return await conexion.execute(sql, parametros, { autoCommit: true });
  } finally {
    await conexion.close();
  }
}

async function transaccion(trabajo) {
  const conexion = await pool.getConnection();
  try {
    const resultado = await trabajo(conexion);
    await conexion.commit();
    return resultado;
  } catch (error) {
    await conexion.rollback();
    throw error;
  } finally {
    await conexion.close();
  }
}

async function cerrar() {
  if (pool) {
    await pool.close(5);
  }
}

module.exports = { iniciar, consultar, ejecutar, transaccion, cerrar };