const express = require('express');
const router = express.Router();
const { authenticateToken, authorizeRoles } = require('../middleware/auth');
const { login, register, getAnswers, saveMood, saveAnswers, getMood, logout } = require('../controllers/auth');

// Rutas de autenticación
router.post('/register', register);
router.post('/login', login);

//Rutas de cuestionario 
router.post('/answers', authenticateToken, saveAnswers);
router.get('/answers/:userId', authenticateToken, getAnswers);

//Rutas de estado de animo
router.post('/mood', authenticateToken, saveMood);
router.get('/mood/:userId', authenticateToken, getMood);

//logout
router.post('/logout', authenticateToken, logout);

module.exports = router;