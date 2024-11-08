const jwt = require('jsonwebtoken');
const User = require('../../../modelos/usuarios');
const { connectDB } = require('../../basedatos/db');

// Asegurar la conexión a la base de datos
connectDB();

const register = async (req, res) => {
    try {
        const { email, password, name } = req.body;usar

        // Validaciones básicas
        if (!email || !password || !name) {
            return res.status(400).json({
                success: false,
                message: 'Todos los campos son requeridos'
            });
        }

        // Validar formato de email
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            return res.status(400).json({
                success: false,
                message: 'Formato de email inválido'
            });
        }

        // Verificar si el usuario existe - 
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(400).json({
                success: false,
                message: 'El email ya está registrado'
            });
        }

        // Crear nuevo usuario
        const user = new User({
            email,
            password,
            name
        });

        await user.save();

        // Generar token con información mínima
        const token = jwt.sign(
            { userId: user._id },
            process.env.JWT_SECRET,
            { 
                expiresIn: '24h',
                algorithm: 'HS256'
            }
        );

        res.status(201).json({
            success: true,
            message: 'Usuario registrado exitosamente',
            data: {
                token,
                user: {
                    id: user._id,
                    email: user.email,
                    name: user.name
                }
            }
        });

    } catch (error) {
        console.error('Error en registro:', error);
        res.status(500).json({
            success: false,
            message: 'Error al registrar usuario'
        });
    }
};

const login = async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({
                success: false,
                message: 'Email y contraseña son requeridos'
            });
        }

        // Buscar usuario
        const user = await User.findOne({ email }).select('+password');
        if (!user) {
            return res.status(401).json({
                success: false,
                message: 'Credenciales inválidas'
            });
        }

        const isValidPassword = await user.comparePassword(password);
        if (!isValidPassword) {
            return res.status(401).json({
                success: false,
                message: 'Credenciales inválidas'
            });
        }

        await user.updateLastLogin();

        // Generar token con información mínima
        const token = jwt.sign(
            { userId: user._id },
            process.env.JWT_SECRET,
            { 
                expiresIn: '24h',
                algorithm: 'HS256'
            }
        );

        // Configurar cookie segura
        res.cookie('token', token, {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production',
            sameSite: 'strict',
            maxAge: 24 * 60 * 60 * 1000 // 24 horas
        });

        res.json({
            success: true,
            message: 'Login exitoso',
            data: {
                token,
                user: {
                    id: user._id,
                    email: user.email,
                    name: user.name,
                    role: user.role
                }
            }
        });

    } catch (error) {
        console.error('Error en login:', error);
        res.status(500).json({
            success: false,
            message: 'Error al iniciar sesión'
        });
    }
};

const saveAnswers = async (req, res) => {
    try {
        // Usar el userId del token en lugar del body
        const userId = req.user.userId;
        const { answers } = req.body;

        if (!answers || !Array.isArray(answers)) {
            return res.status(400).json({
                success: false,
                message: 'Formato de respuestas inválido'
            });
        }

        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({
                success: false,
                message: 'Usuario no encontrado'
            });
        }

        user.answers = answers;
        await user.save();

        res.status(200).json({
            success: true,
            message: 'Respuestas guardadas exitosamente'
        });

    } catch (error) {
        console.error('Error al guardar respuestas:', error);
        res.status(500).json({
            success: false,
            message: 'Error al guardar respuestas'
        });
    }
};

const getAnswers = async (req, res) => {
    try {
        // Usar el userId del token para verificar acceso
        const requestingUserId = req.user.userId;
        const { userId } = req.params;

        // Verificar que el usuario solo acceda a sus propias respuestas
        if (requestingUserId !== userId && req.user.role !== 'admin') {
            return res.status(403).json({
                success: false,
                message: 'No autorizado para acceder a estas respuestas'
            });
        }

        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({
                success: false,
                message: 'Usuario no encontrado'
            });
        }

        res.status(200).json({
            success: true,
            message: 'Respuestas recuperadas exitosamente',
            data: user.answers
        });

    } catch (error) {
        console.error('Error al recuperar respuestas:', error);
        res.status(500).json({
            success: false,
            message: 'Error al recuperar respuestas'
        });
    }
};

const saveMood = async (req, res) => {
    try {
        // Usar el userId del token
        const userId = req.user.userId;
        const { mood } = req.body;

        if (!mood) {
            return res.status(400).json({
                success: false,
                message: 'El estado de ánimo es requerido'
            });
        }

        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({
                success: false,
                message: 'Usuario no encontrado'
            });
        }

        user.mood = mood;
        await user.save();

        res.status(200).json({
            success: true,
            message: 'Estado de ánimo guardado exitosamente'
        });

    } catch (error) {
        console.error('Error al guardar el estado de ánimo:', error);
        res.status(500).json({
            success: false,
            message: 'Error al guardar el estado de ánimo'
        });
    }
};

const getMood = async (req, res) => {
    try {
        // Usar el userId del token para verificar acceso
        const requestingUserId = req.user.userId;
        const { userId } = req.params;

        // Verificar que el usuario solo acceda a su propio estado de ánimo
        if (requestingUserId !== userId && req.user.role !== 'admin') {
            return res.status(403).json({
                success: false,
                message: 'No autorizado para acceder a este estado de ánimo'
            });
        }

        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({
                success: false,
                message: 'Usuario no encontrado'
            });
        }

        res.status(200).json({
            success: true,
            message: 'Estado de ánimo recuperado exitosamente',
            data: user.mood
        });

    } catch (error) {
        console.error('Error al recuperar el estado de ánimo:', error);
        res.status(500).json({
            success: false,
            message: 'Error al recuperar el estado de ánimo'
        });
    }
};

const logout = async (req, res) => {
    try {
        // Limpiar la cookie si existe
        res.cookie('token', '', {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production',
            sameSite: 'strict',
            expires: new Date(0) // Fecha en el pasado para expirar la cookie inmediatamente
        });

        // Actualizar el lastLogout en el usuario si lo deseas
        if (req.user && req.user.userId) {
            await User.findByIdAndUpdate(req.user.userId, {
                lastLogout: new Date()
            });
        }

        res.status(200).json({
            success: true,
            message: 'Sesión cerrada exitosamente'
        });
    } catch (error) {
        console.error('Error en logout:', error);
        res.status(500).json({
            success: false,
            message: 'Error al cerrar sesión'
        });
    }
};
module.exports = {
    register,
    login,
    saveAnswers,
    getAnswers,
    saveMood,
    getMood,
    logout
};