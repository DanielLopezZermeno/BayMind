const mongoose = require('../backend/api/node_modules/mongoose');
const bcrypt = require("../backend/api/node_modules/bcrypt");

const mongoose= require('mongoose');
const fraseSchema = new mongoose.Schema({
    id:{
        type: Int16Array,
        requerid: true,
    },
    frase:{
        type: String,
        required: true,
    },
});

const Frase = mongoose.model('FraseMotivacional', fraseSchema);

module.exports = Frase;

const obtenerFraseAleatoria = async()=>{
    try{
        const count = await Frase.countDocuments();

        if(count===0) return 'Hoy no hay frase, pero ánimo.';
        
        const randomIndex = Math.floor(Math.random() * count);

        const fraseAleatoria = await Frase.findOne().skip(randomIndex);
        return fraseAleatoria
            ? `"${fraseAleatoria.frase}"` 
            : 'Hoy no hay frase, pero ánimo.';
        } catch (error) {
            console.error('Error al obtener una frase aleatoria:', error);
            throw new Error('Hoy no hay frase, pero ánimo.');
        }
};

module.exports = {
    obtenerFraseAleatoria,
};