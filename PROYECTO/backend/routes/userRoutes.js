const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

// Rutas CRUD para usuarios

router.post('/auth', userController.authUser);         // Obtener todos los usuarios

module.exports = router;


