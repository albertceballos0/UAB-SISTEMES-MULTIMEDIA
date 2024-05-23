const admin = require('firebase-admin');
const jsonData = require("../sistemes-multimedia-d08f240b9131.json");
const { firestore } = require('../storage/storage');



/**
 * Creates a new user with the provided email and name.
 * 
 * @param {string} email - The email of the user.
 * @param {string} name - The name of the user.
 * @returns {Promise<boolean>} - A promise that resolves to true if the user is successfully created, otherwise false.
 */
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


/**
 * Authenticates a user based on their email.
 *
 * @param {string} email - The email of the user to authenticate.
 * @returns {Promise<boolean>} - A promise that resolves to a boolean indicating whether the user is authenticated or not.
 */
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
