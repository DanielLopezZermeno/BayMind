import 'package:baymind/frontend/pantallas/home_screen.dart';
import 'package:baymind/main.dart';
import 'package:flutter/material.dart';
import 'package:baymind/frontend/widgets/colors.dart';

class CuestionarioScreen extends StatefulWidget {
  @override
  _CuestionarioScreenState createState() => _CuestionarioScreenState();
}

class _CuestionarioScreenState extends State<CuestionarioScreen> {
  String? selectedAge = "18";
  bool isStudent = false;
  bool isWorking = false;
  bool hasTherapy = false;
  final nameController = TextEditingController();
  final reasonController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [
                        AppColors.morado,
                        AppColors.azul
                      ], // Gradiente desde morado hasta azul
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: Text(
                    'Cuéntame un poco de ti...',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Se usa blanco para que el gradiente se vea correctamente
                      fontFamily: 'Manrope',
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Nombre
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: '¿Cuál es tu nombre?',
                    labelStyle: TextStyle(fontFamily: 'Manrope'),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu nombre.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Edad
                Text('¿Cuál es tu edad?', style: TextStyle(fontFamily: 'Manrope')),
                DropdownButtonFormField<String>(
                  value: selectedAge,
                  items: List.generate(83, (index) => (index + 18).toString())
                      .map((age) => DropdownMenuItem(
                            child: Text(age),
                            value: age,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedAge = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecciona tu edad.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Estudias
                Text('¿Estudias?', style: TextStyle(fontFamily: 'Manrope')),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: isStudent,
                      onChanged: (value) {
                        setState(() {
                          isStudent = value!;
                        });
                      },
                    ),
                    Text('Sí', style: TextStyle(fontFamily: 'Manrope')),
                    Radio<bool>(
                      value: false,
                      groupValue: isStudent,
                      onChanged: (value) {
                        setState(() {
                          isStudent = value!;
                        });
                      },
                    ),
                    Text('No', style: TextStyle(fontFamily: 'Manrope')),
                  ],
                ),
                SizedBox(height: 20),
                // Trabajas
                Text('¿Trabajas?', style: TextStyle(fontFamily: 'Manrope')),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: isWorking,
                      onChanged: (value) {
                        setState(() {
                          isWorking = value!;
                        });
                      },
                    ),
                    Text('Sí', style: TextStyle(fontFamily: 'Manrope')),
                    Radio<bool>(
                      value: false,
                      groupValue: isWorking,
                      onChanged: (value) {
                        setState(() {
                          isWorking = value!;
                        });
                      },
                    ),
                    Text('No', style: TextStyle(fontFamily: 'Manrope')),
                  ],
                ),
                SizedBox(height: 20),
                // Motivo para usar la app
                TextFormField(
                  controller: reasonController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: '¿Por qué te gustaría usar BayMind?',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(fontFamily: 'Manrope'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa un motivo para usar la app.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Terapia psicológica
                Text('¿Has tomado terapia psicológica?', style: TextStyle(fontFamily: 'Manrope')),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: hasTherapy,
                      onChanged: (value) {
                        setState(() {
                          hasTherapy = value!;
                        });
                      },
                    ),
                    Text('Sí', style: TextStyle(fontFamily: 'Manrope')),
                    Radio<bool>(
                      value: false,
                      groupValue: hasTherapy,
                      onChanged: (value) {
                        setState(() {
                          hasTherapy = value!;
                        });
                      },
                    ),
                    Text('No', style: TextStyle(fontFamily: 'Manrope')),
                  ],
                ),
                SizedBox(height: 20),
                // Botón de Continuar con gradiente
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.morado, AppColors.azul],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Redirigir a la pantalla principal al registrarse
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainScreen()), // Cambiar a MainScreen
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Fondo transparente
                      shadowColor: Colors.transparent, // Sin sombra
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Continuar',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'Manrope'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
