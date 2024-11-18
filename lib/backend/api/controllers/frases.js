const { obtenerFraseAleatoria } = require('../../../modelos/Frase');

const obtenerFrase = async (req, res) => {
    try {
        const frase = await obtenerFraseAleatoria();
        res.status(200).json({ success: true, frase });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

module.exports = {
    obtenerFrase,
};
