const jwt = require('jsonwebtoken');
const User = require('../../../modelos/usuarios');
const { connectDB } = require('../../basedatos/db');

// Asegurar la conexión a la base de datos
connectDB();

const register = async (req, res) => {
    try {
        const { email, password, name } = req.body;

        // Verificar si el usuario existe
        const existingUser = await User.findByEmail(email);
        if (existingUser) {
            return res.status(400).json({
                success: false,
                message: 'El email ya está registrado'
            });
        }

        // Crear nuevo usuario
        const user = new User({
            email,
            password, // Se hasheará automáticamente por el middleware del modelo
            name
        });

        await user.save();

        // Generar token
        const token = jwt.sign(
            { userId: user._id, email: user.email },
            process.env.JWT_SECRET,
            { expiresIn: '24h' }
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
        res.status(500).json({
            success: false,
            message: 'Error al registrar usuario',
            error: error.message
        });
    }
};

const login = async (req, res) => {
    try {
        const { email, password } = req.body;

        // Buscar usuario incluyendo el campo password
        const user = await User.findOne({ email }).select('+password');
        if (!user) {
            return res.status(404).json({
                success: false,
                message: 'Usuario no encontrado'
            });
        }

        // Verificar contraseña usando el método del modelo
        const isValidPassword = await user.comparePassword(password);
        if (!isValidPassword) {
            return res.status(401).json({
                success: false,
                message: 'Credenciales inválidas'
            });
        }

        // Actualizar último login
        await user.updateLastLogin();

        // Generar token
        const token = jwt.sign(
            { userId: user._id, email: user.email },
            process.env.JWT_SECRET || 'tu_clave_secreta',
            { expiresIn: '24h' }
        );

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
        res.status(500).json({
            success: false,
            message: 'Error al iniciar sesión',
            error: error.message
        });
    }
};


module.exports = {
    register,
    login,
};
