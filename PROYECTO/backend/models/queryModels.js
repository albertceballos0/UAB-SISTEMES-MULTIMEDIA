const jsonData = require("../sistemes-multimedia-d08f240b9131.json");
const { firestore, admin } = require('../storage/storage');


const getCount = async () => {
  try{
        const docRef = await firestore.collection('counter').doc('counterId').get()
        return docRef.data().count;
  }catch(error){
        console.error('Error al recibir count:', error);
  }
  return null;
};


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


module.exports = {
  getCount,
  incrementCount,
};
