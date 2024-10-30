import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cuéntame un poco de ti...',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              SizedBox(height: 20),
              // Nombre
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: '¿Cuál es tu nombre?',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Edad
              Text('¿Cuál es tu edad?'),
              DropdownButton<String>(
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
              ),
              SizedBox(height: 20),
              // Estudias
              Text('¿Estudias?'),
              Row(
                children: [
                  Radio(
                    value: true,
                    groupValue: isStudent,
                    onChanged: (value) {
                      setState(() {
                        isStudent = value as bool;
                      });
                    },
                  ),
                  Text('Sí'),
                  Radio(
                    value: false,
                    groupValue: isStudent,
                    onChanged: (value) {
                      setState(() {
                        isStudent = value as bool;
                      });
                    },
                  ),
                  Text('No'),
                ],
              ),
              SizedBox(height: 20),
              // Trabajas
              Text('¿Trabajas?'),
              Row(
                children: [
                  Radio(
                    value: true,
                    groupValue: isWorking,
                    onChanged: (value) {
                      setState(() {
                        isWorking = value as bool;
                      });
                    },
                  ),
                  Text('Sí'),
                  Radio(
                    value: false,
                    groupValue: isWorking,
                    onChanged: (value) {
                      setState(() {
                        isWorking = value as bool;
                      });
                    },
                  ),
                  Text('No'),
                ],
              ),
              SizedBox(height: 20),
              // Motivo para usar la app
              TextField(
                controller: reasonController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: '¿Por qué te gustaría usar BayMind?',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Terapia psicológica
              Text('¿Has tomado terapia psicológica?'),
              Row(
                children: [
                  Radio(
                    value: true,
                    groupValue: hasTherapy,
                    onChanged: (value) {
                      setState(() {
                        hasTherapy = value as bool;
                      });
                    },
                  ),
                  Text('Sí'),
                  Radio(
                    value: false,
                    groupValue: hasTherapy,
                    onChanged: (value) {
                      setState(() {
                        hasTherapy = value as bool;
                      });
                    },
                  ),
                  Text('No'),
                ],
              ),
              SizedBox(height: 20),
              // Botón de Continuar con gradiente
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Acción para continuar
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
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
