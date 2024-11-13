const mongoose = require('../api/node_modules/mongoose');
const dotenv = require('../api/node_modules/dotenv');

dotenv.config();

const connectDB = async () => {
    try {
        const conn = await mongoose.connect(process.env.MONGODB_URI, {
        
        });

        console.log(`MongoDB Conectado: ${conn.connection.host}`);
        
        // Eventos de la conexión
        mongoose.connection.on('error', err => {
            console.error('Error de MongoDB:', err);
        });

        mongoose.connection.on('disconnected', () => {
            console.warn('MongoDB desconectado. Intentando reconectar...');
        });

        mongoose.connection.on('reconnected', () => {
            console.log('MongoDB reconectado');
        });

    } catch (error) {
        console.error('Error conectando a MongoDB:', error);
        process.exit(1);
    }
};

const closeConnection = async () => {
    try {
        await mongoose.connection.close();
        console.log('Conexión a MongoDB cerrada');
    } catch (error) {
        console.error('Error al cerrar la conexión:', error);
    }
};

module.exports = {
    connectDB,
    closeConnection
};
