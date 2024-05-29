const { incrementCount, setQuery, getQueries, getCountByEmail } = require('../models/queryModels');
const { verifyToken } = require('../hooks/auth');
require('dotenv').config();
const { bucket } = require('../storage/storage');

async function generateSignedUrl(fileName, expirationTime = 3600) {
  const options = {
    version: 'v4',
    action: 'read',
    expires: Date.now() + expirationTime * 1000, // Tiempo en milisegundos
  };

  const file = bucket.file(fileName);
  const [url] = await file.getSignedUrl(options);

  return url;
}


const getQueriesController = async (req, res) => {
  try {
    const verify = await verifyToken(req, res);
    if (!verify) {
      return res.status(200).send({ status: 'INVALID_TOKEN', message: 'Error al verificar el token' });
    }

    const queries = await getQueries(verify.email);
    if (!queries) {
      return res.status(500).send({ status: 'ERROR', message: 'Error al obtener las consultas' });
    }

    const updatedFiles = await Promise.all(queries.map(async (file) => {
      if (file.fileName) {
        file.fileName = await generateSignedUrl(file.fileName);
      }
      return file;
    }));

    return res.status(200).send({ status: 'OK', message: 'Consultas obtenidas correctamente', data: updatedFiles });
  } catch (error) {
    console.error('Error en getQueriesController:', error);
    return res.status(500).send({ status: 'ERROR', message: 'Error interno del servidor' });
  }
};

const getQueriesCount = async (req, res) => {

  try{
    const verify = await verifyToken(req, res);
    if (!verify) {
      return res.status(200).send({ status: 'INVALID_TOKEN', message: 'Error al verificar el token' });
    }
    const count = await getCountByEmail(verify.email);
    console.log('Count:', count);
    if (count === null) {
      return res.status(500).send({ status: 'ERROR', message: 'Error al obtener el count' });
    }

    if (count >= 1000) {
      return res.status(200).send({ status: 'ERROR', message: 'No quedan consultas' });
    }
    return res.status(200).send({ status: 'OK', data: 1000 - count });

  } catch (error) {
    console.error('Error en getCount:', error);
    return res.status(500).send({ status: 'ERROR', message: 'Error consultando count' });
  }

}


const setQueryController = async (req, res) => {

  if (!req.body.name) {
    return res.status(403).send({ status: 'ERROR', message: 'Falta el nombre de la planta' });
  }

  const { name } = req.body;
  try {
    const verify = await verifyToken(req, res);
    if (!verify) {
      return res.status(200).send({ status: 'INVALID_TOKEN', message: 'Error al verificar el token' });
    }

    const count = await incrementCount();
    if (!count) {
      return res.status(500).send({ status: 'ERROR', message: 'Error al incrementar el contador' });
    }

    const fileName = `imagen${count}.jpg`;

    const date = new Date().toDateString();

    const result = await setQuery(verify.email, fileName, date , name);
    
    if (!result) {
        return res.status(500).send({ status: 'ERROR', message: 'Error al guardar la información de la imagen' });
    }
    return res.status(200).send({ status: 'OK', message: 'Consulta guardada correctamente', data: { fileName, count, date } });

  }catch(error){
    console.error('Error en setQueryController:', error);
    return res.status(500).send({ status: 'ERROR', message: 'Error interno del servidor' });
  }
};
 
module.exports = {
  setQueryController,
  getQueriesController,
  getQueriesCount,
};
