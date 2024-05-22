const admin = require('firebase-admin');
const jsonData = require("../sistemes-multimedia-d08f240b9131.json");
const { firestore } = require('../storage/storage');



const createUser = async (email, name) => {
  console.log('Registrando usuario:', email, name)
  try{
        await firestore.collection('users').add({email, name});
        return true;
  }catch(error){
        console.error('Error al registrar usuario:', error);
        res.status(500).send('Error interno del servidor');
  }
  return false;
};


const authUser = async (email) => {
  console.log('Autentificando usuario:', email)
  const userQuery = await firestore.collection('users').where('email', '==', email).get();
  if (userQuery.empty) {
    return false;
  }
  return true;
};

module.exports = {
  createUser,
  authUser,
};
