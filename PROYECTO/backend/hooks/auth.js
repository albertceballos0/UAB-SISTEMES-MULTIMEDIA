const jwt = require('jsonwebtoken');
const { authUser } = require('../models/userModel');
require('dotenv').config();

const generateToken = (user) => {
  return jwt.sign({ email: user.email }, process.env.JWT_SECRET, { expiresIn: '1h' });
};

const verifyToken = async (req, res) => {
  const token = req.headers.authentication;
  console.log('Token:', token);
  if (!token) {
    return false;
  }
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    if (!decoded) {
      return false;
    }

    const user = await authUser(decoded.email);
    if (!user) {
      return false;
    }
    return true;

  } catch {
    return false;
  }
};


module.exports = { generateToken, verifyToken };
