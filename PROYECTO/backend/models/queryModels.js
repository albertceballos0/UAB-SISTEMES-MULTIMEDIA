const { firestore, admin } = require('../storage/storage');


/**
 * Retrieves the count from the 'counter' collection in Firestore.
 * @returns {Promise<number|null>} The count value if successful, otherwise null.
 */
const getCount = async () => {
  try{
        const docRef = await firestore.collection('counter').doc('counterId').get()
        return docRef.data().count;
  }catch(error){
        console.error('Error al recibir count:', error);
  }
  return null;
};

const getCountByEmail = async (email) => {

  const userQuery = await firestore.collection('users').where('email', '==', email).get();
  if (userQuery.empty) {
    console.log('No se encontró el usuario:', email);
    return null;
  }
  try{
    const userDoc = userQuery.docs[0].data();
    return userDoc['count'];
  }catch(error){
    console.error('Error al obtener el count:', error);
    return null;
  }
}

/**
 * Increments the count value in the 'counter' collection by 1.
 * 
 * @returns {Promise<number>} The updated count value.
 */
const incrementCount = async () => {
    const docRef = firestore.collection('counter').doc('counterId');
    const increment = admin.firestore.FieldValue.increment(1);
      
    const doc = await docRef.get();
    if (!doc.exists) {
      console.log('No se encontró el documento.');
      return;
    }
    try {
      await docRef.update({ count: increment });
      console.log('Valor de count incrementado exitosamente.', doc.data().count);
      return doc.data().count;
    } catch (error) {
      console.error('Error incrementando el valor de count:', error);
      return;
    }
    
};

/**
 * Sets a query in the Firestore database and updates the user's document with the query reference.
 * @param {string} email - The email of the user.
 * @param {string} fileName - The name of the file.
 * @param {any} data - The data associated with the query.
 * @returns {Promise<boolean>} - A promise that resolves to true if the query is successfully set and the user's document is updated, or false otherwise.
 */
/**
 * Saves a query document to Firestore and updates the user's document with the query reference.
 * @param {string} email - The email of the user.
 * @param {string} fileName - The name of the file.
 * @param {object} data - The data associated with the query.
 * @returns {Promise<boolean>} - A promise that resolves to true if the query is successfully saved and the user's document is updated, false otherwise.
 */
const setQuery = async (email , fileName, date, name) => {

  const queryDocRef = await firestore.collection('queries').add({
    fileName: fileName,
    date: date,
    name: name
  });

  const userQuery = await firestore.collection('users').where('email', '==', email).get();
  if (userQuery.empty) {
    console.log('No se encontró el usuario:', email);
    return false;
  }
  try{
    const userDocRef = userQuery.docs[0].ref;
    await userDocRef.update({
      queries: admin.firestore.FieldValue.arrayUnion(queryDocRef),
      count : admin.firestore.FieldValue.increment(1),
    });
    return true;
  }catch(error){
    console.error('Error al guardar la información de la imagen:', error);
    return false;
  }
};

const getQueries = async (email) => {
  try {
    // Suponiendo que ya tienes `userQuery`
    const userQuery = await firestore.collection('users').where('email', '==', email).get();

    if (userQuery.empty) {
      return null;
    }


    const userDoc = userQuery.docs[0].data();

    const queryRefs = userDoc['queries'];

    if(!queryRefs){
      return [];
    }

    // Obtener los documentos de las queries usando sus referencias
    const queryDocs = await Promise.all(queryRefs.map(ref => ref.get()));
    const queryData = queryDocs.map(doc => doc.data());

    return queryData;
  } catch (error) {
    console.error('Error obteniendo el campo del documento:', error);
    return null;
  }
};

module.exports = {
  getCount,
  incrementCount,
  setQuery,
  getQueries,
  getCountByEmail
};
