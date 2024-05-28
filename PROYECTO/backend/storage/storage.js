const admin = require('firebase-admin');
require('dotenv').config();
const jsonData = require("../sistemes-multimedia-942b05bfad04.json");

// Inicializa la aplicación Firebase
admin.initializeApp({

    credential: admin.credential.cert(jsonData),
    storageBucket: 'imatges-sistemes-multimedia',
  });


// Inicializa la aplicación Firebase
const firestore = admin.firestore();
const bucket = admin.storage().bucket();

module.exports = {
    firestore,
    bucket,
    admin
}
