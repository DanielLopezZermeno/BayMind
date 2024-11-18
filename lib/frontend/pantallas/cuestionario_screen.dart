import 'package:baymind/main.dart';
import 'package:flutter/material.dart';
import 'package:baymind/frontend/widgets/colors.dart';

class CuestionarioScreen extends StatefulWidget {
  const CuestionarioScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
                    return const LinearGradient(
                      colors: [
                        AppColors.morado,
                        AppColors.azul
                      ], // Gradiente desde morado hasta azul
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: const Text(
                    'Cuéntame un poco de ti...',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Se usa blanco para que el gradiente se vea correctamente
                      fontFamily: 'Manrope',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Nombre
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
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
                const SizedBox(height: 20),
                // Edad
                const Text('¿Cuál es tu edad?', style: TextStyle(fontFamily: 'Manrope')),
                DropdownButtonFormField<String>(
                  value: selectedAge,
                  items: List.generate(83, (index) => (index + 18).toString())
                      .map((age) => DropdownMenuItem(
                            // ignore: sort_child_properties_last
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
                const SizedBox(height: 20),
                // Estudias
                const Text('¿Estudias?', style: TextStyle(fontFamily: 'Manrope')),
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
                    const Text('Sí', style: TextStyle(fontFamily: 'Manrope')),
                    Radio<bool>(
                      value: false,
                      groupValue: isStudent,
                      onChanged: (value) {
                        setState(() {
                          isStudent = value!;
                        });
                      },
                    ),
                    const Text('No', style: TextStyle(fontFamily: 'Manrope')),
                  ],
                ),
                const SizedBox(height: 20),
                // Trabajas
                const Text('¿Trabajas?', style: TextStyle(fontFamily: 'Manrope')),
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
                    const Text('Sí', style: TextStyle(fontFamily: 'Manrope')),
                    Radio<bool>(
                      value: false,
                      groupValue: isWorking,
                      onChanged: (value) {
                        setState(() {
                          isWorking = value!;
                        });
                      },
                    ),
                    const Text('No', style: TextStyle(fontFamily: 'Manrope')),
                  ],
                ),
                const SizedBox(height: 20),
                // Motivo para usar la app
                TextFormField(
                  controller: reasonController,
                  maxLines: 4,
                  decoration: const InputDecoration(
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
                const SizedBox(height: 20),
                // Terapia psicológica
                const Text('¿Has tomado terapia psicológica?', style: TextStyle(fontFamily: 'Manrope')),
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
                    const Text('Sí', style: TextStyle(fontFamily: 'Manrope')),
                    Radio<bool>(
                      value: false,
                      groupValue: hasTherapy,
                      onChanged: (value) {
                        setState(() {
                          hasTherapy = value!;
                        });
                      },
                    ),
                    const Text('No', style: TextStyle(fontFamily: 'Manrope')),
                  ],
                ),
                const SizedBox(height: 20),
                // Botón de Continuar con gradiente
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
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
                          MaterialPageRoute(builder: (context) => const MainScreen()), // Cambiar a MainScreen
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
                    child: const Text(
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
