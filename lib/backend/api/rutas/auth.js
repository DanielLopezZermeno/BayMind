const express = require('express');
const router = express.Router();
const { login, register, getProfile } = require('../controllers/auth');
const { authenticateToken } = require('../middleware/auth');
const { obtenerFrase } = require('../controllers/frases');

// Rutas de autenticación
router.post('/register', register);
router.post('/login', login);
//router.get('/profile', authenticateToken, getProfile);
router.get('/frase', obtenerFrase);
module.exports = router;