const { bucket } = require('../storage/storage');
const { getCount, incrementCount, setQuery, getQueries } = require('../models/queryModels');
const { verifyToken } = require('../hooks/auth');
const axios = require('axios');
const { Storage } = require('@google-cloud/storage');
const FormData = require('form-data');
const fs = require('fs');

const PROJECT = 'weurope'; // try 'weurope' or 'canada'
const API_URL = 'https://my-api.plantnet.org/v2/identify/' + PROJECT + '?api-key=';
const API_PRIVATE_KEY = '2b10IUcTnREtBKpBDq0Xi3iecu'; // secret

const storage = new Storage();


/**
 * Retrieves queries from the database for a specific user.
 * 
 * @param {Object} req - The request object.
 * @param {Object} res - The response object.
 * @returns {Object} The response object containing the status, message, and data.
 */

const getQueriesController = async (req,res) => {
  const verify = await verifyToken(req, res);
  if (!verify) {
    return res.send({ status: 'INVALID_TOKEN', message: 'Error al verificar el token' });
  }

  const queries = await getQueries(verify.email);

  if (!queries) {
    return res.send({ status: 'ERROR', message: 'Error al obtener las consultas' });
  }
  return res.send({ status: 'OK', message: 'Consultas obtenidas correctamente', data: queries });

}



/**
 * Handles the set query request.
 *
 * @param {Object} req - The request object.
 * @param {Object} res - The response object.
 * @returns {Promise<void>} - A Promise that resolves when the set query request is handled.
 */

const setQueryController = async (req, res) => {
  if (!req.file) {
    return res.status(400).send('No file uploaded.');
  }

  const verify = await verifyToken(req, res);
  if (!verify) {
    return res.send({ status: 'INVALID_TOKEN', message: 'Error al verificar el token' });
  }

  const count = await incrementCount();

  if (!count) {
    return res.send({ status: 'ERROR', message: 'Error al incrementar el contador' });
  }


  const ext = req.file.originalname.split('.').pop();
  const fileName = `imagen${count}.${ext}`;
  const blob = bucket.file(fileName);
  const blobStream = blob.createWriteStream({
    resumable: false,
  });

  blobStream.on('error', (err) => {
    return res.send({ status: 'ERROR', message: 'Error al subir la imagen' });
  });


  blobStream.on('finish', async () => {
    console.log('Imagen subida correctamente');

    const result = await setQuery(verify.email, fileName, new Date());

    if (!result) {
      return res.send({ status: 'ERROR', message: 'Error al guardar la información de la imagen' });
    };

    // Generar la URL firmada
    let url;
    try {
      const options = {
        version: 'v4',
        action: 'read',
        expires: Date.now() + 15 * 60 * 1000, // 15 minutos
      };

      [url] = await blob.getSignedUrl(options);
      console.log(`La URL firmada es: ${url}`);
    } catch (error) {
      console.error('Error al generar la URL firmada:', error);
      return res.send({ status: 'ERROR', message: 'Error al generar la URL firmada para enviar a plantNetAPI' });
    }

    // Enviar la imagen a PlantNet
    try {
      const response = await axios.get(url, {
        responseType: 'arraybuffer'
      });

      const form = new FormData();
      form.append('images', response.data, {
        filename: fileName,
        contentType: `image/${ext}`
      });

      const { status, data } = await axios.post(
        API_URL + API_PRIVATE_KEY,
        form,
        { headers: form.getHeaders() }
      );

      
      console.log('status', status); // should be: 200
      console.log('data', require('util').inspect(data, false, null, true));

      return res.send({ status: 'OK', message: 'Imagen subida y procesada correctamente', data: data });
    } catch (error) {
      console.error('Error al enviar la imagen a PlantNet:', error);
      return res.send({ status: 'ERROR', message: 'Error al enviar la imagen a PlantNet', error: error.message });
    }
  });

  blobStream.end(req.file.buffer);
};

module.exports = {
  setQueryController,
  getQueriesController,
};
