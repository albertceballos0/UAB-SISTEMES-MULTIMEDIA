const jwt = require('jsonwebtoken');
const { authUser } = require('../models/userModel');
require('dotenv').config();

/**
 * Generates a token for the given user.
 *
 * @param {Object} user - The user object.
 * @param {string} user.email - The email of the user.
 * @returns {string} The generated token.
 */
const generateToken = (user) => {
  console.log('Generando token para:', user.email)
  return jwt.sign({ email: user.email }, process.env.JWT_SECRET, { expiresIn: '1h' });
};




/**
 * Verifies the authentication token in the request headers.
 * 
 * @param {Object} req - The request object.
 * @param {Object} res - The response object.
 * @returns {Promise<Object|null>} - A promise that resolves to the decoded token if valid, or null if invalid.
 */
const verifyToken = async (req, res) => {
  const token = req.headers.authentication;
  console.log('Token:', token);
  if (!token) {
    return null;
  }
  try {
    const decoded = await jwt.verify(token, process.env.JWT_SECRET);
    if (!decoded) {
      return null;
    }
    const user = await authUser(decoded.email);
    if (!user) {
      return null;
    }
    return decoded;
  } catch {
    console.log('Error al verificar el token');
    return null;
  }
};

module.exports = { generateToken, verifyToken };
