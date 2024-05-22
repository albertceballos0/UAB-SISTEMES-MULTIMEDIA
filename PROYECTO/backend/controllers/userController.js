const User = require('../models/userModel.js');
const {generateToken} = require('../hooks/auth'); 
require('dotenv').config();


exports.authUser = async (req, res) => {
  try {
    const { email, name } = req.body;
    try{

        const user = await User.authUser(email);

        if (!user) {
            try{
               const result = await User.createUser(email, name);

               if(result){
                    console.log('Usuario registrado correctamente');
                    const token = generateToken({ email });
                    res.json({status: 'OK', message: 'Usuario autenticado correctamente', token: token});
                }
               else{
                res.status(500);
               }

            }catch(error){
                res.status(500);
            }
        }
        const token = generateToken({ email });
        res.json({status: 'OK', message: 'Usuario autenticado correctamente', token: token});
        
    }
    catch(error){
        res.status(500);
    }


  } catch (error) {
    res.status(500);
  }
  return;
};
