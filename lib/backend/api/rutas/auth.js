const express = require('express');
const router = express.Router();
const { login, register, getProfile } = require('../controllers/auth');
const { authenticateToken } = require('../middleware/auth');

// Rutas de autenticación
router.post('/register', register);
router.post('/login', login);
//router.get('/profile', authenticateToken, getProfile);

module.exports = router;