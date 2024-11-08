const jwt = require('jsonwebtoken');

const authenticateToken = (req, res, next) => {
    try {
        // Verificar si el token viene en los headers
        const authHeader = req.headers['authorization'];
        
        // Verificar si el token viene en las cookies como alternativa
        const cookieToken = req.cookies?.token;
        
        // Obtener el token de header o cookie
        const token = authHeader ? authHeader.split(' ')[1] : cookieToken;

        if (!token) {
            return res.status(401).json({
                success: false,
                message: 'No se proporcionó token de acceso'
            });
        }

        // Verificar el token con manejo de promesas
        jwt.verify(token, process.env.JWT_SECRET, {
            algorithms: ['HS256'] // Especificar algoritmo permitido
        }, (err, decoded) => {
            if (err) {
                if (err.name === 'TokenExpiredError') {
                    return res.status(401).json({
                        success: false,
                        message: 'Token expirado'
                    });
                }
                if (err.name === 'JsonWebTokenError') {
                    return res.status(403).json({
                        success: false,
                        message: 'Token inválido'
                    });
                }
                return res.status(403).json({
                    success: false,
                    message: 'Error en la verificación del token'
                });
            }

            // Agregar información del usuario al request
            req.user = decoded;
            next();
        });
    } catch (error) {
        console.error('Error en middleware de autenticación:', error);
        res.status(500).json({
            success: false,
            message: 'Error en la autenticación'
        });
    }
};

// Middleware para verificar roles
const authorizeRoles = (...roles) => {
    return (req, res, next) => {
        if (!req.user) {
            return res.status(401).json({
                success: false,
                message: 'Autenticación requerida'
            });
        }

        if (!roles.includes(req.user.role)) {
            return res.status(403).json({
                success: false,
                message: 'No tiene permisos para realizar esta acción'
            });
        }

        next();
    };
};

module.exports = {
    authenticateToken,
    authorizeRoles
};