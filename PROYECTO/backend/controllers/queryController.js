const {bucket} = require('../storage/storage');
const { getCount, incrementCount } = require('../models/queryModels');
const { verifyToken } = require('../hooks/auth');




const uploadImage = async (req, res) => {
  if (!req.file) {
    return res.status(400).send('No file uploaded.');
  }

  const verify = await verifyToken(req, res);
  if (!verify) {
    return res.send({ status: 'INVALID_TOKEN', message: 'Error al verificar el token'});
  }

  const count = await incrementCount();

  if (!count) {
        res.send({status: 'ERROR', message:'Error al incrementar el contador'});
  }
  const ext = req.file.originalname.split('.')[1];

  const blob = bucket.file(`imagen${count}.${ext}`);
  const blobStream = blob.createWriteStream({
    resumable: false,
  });
  
  blobStream.on('error', (err) => {
        res.send({status: 'ERROR', message:'Error al subir la imagenº'});
  });

  blobStream.on('finish', () => {

    console.log('Imagen subida correctamente');
    res.send({status:'OK', message: 'Imagen subida correctamente' });

  });

  blobStream.end(req.file.buffer);
};

module.exports = {
  uploadImage,
};
