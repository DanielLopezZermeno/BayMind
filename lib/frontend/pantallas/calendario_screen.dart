// calendario_screen.dart
import 'package:flutter/material.dart';
import 'package:baymind/frontend/widgets/registro_card.dart';

class CalendarioScreen extends StatelessWidget {
  final List<Map<String, dynamic>> weekDays = [
    {'dayName': 'Mon', 'dayNumber': '10', 'month': 'Jun'},
    {'dayName': 'Tue', 'dayNumber': '11', 'month': 'Jun'},
    {'dayName': 'Wed', 'dayNumber': '12', 'month': 'Jun'},
    {'dayName': 'Thu', 'dayNumber': '13', 'month': 'Jun'},
    {'dayName': 'Fri', 'dayNumber': '14', 'month': 'Jun'},
    {'dayName': 'Sat', 'dayNumber': '15', 'month': 'Jun'},
    {'dayName': 'Sun', 'dayNumber': '16', 'month': 'Jun'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.withOpacity(0.1),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.purple),
        actions: [
          // Aquí agregamos el ícono en el lado derecho
          Padding(
            padding: const EdgeInsets.only(right: 16.0), // Espaciado a la derecha
            child: Icon(Icons.calendar_today_rounded),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.withOpacity(0.1), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 18),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: weekDays.length,
                itemBuilder: (context, index) {
                  final day = weekDays[index];
                  return RegistroCard(
                    dayName: day['dayName'],
                    month: day['month'],
                    dayNumber: day['dayNumber'],
                    isToday: index == 1, // Muestra el segundo día como "hoy"
                  );
                },
              ),
            ),
            SizedBox(height: 90),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), 
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today), 
            label: 'Registros',
          ),
          BottomNavigationBarItem(
            icon: ClipRRect( // Usar ClipRRect para redondear bordes
              borderRadius: BorderRadius.circular(20), // Ajusta el radio según sea necesario
              child: Container(
                width: 40, // Ajusta el ancho del logo según sea necesario
                height: 40, // Ajusta la altura del logo según sea necesario
                child: Image(
                  image: AssetImage('assets/baymind.jpg'), // Reemplaza 'baymind.jpg' con tu imagen correcta
                  fit: BoxFit.cover, // Ajusta el modo de ajuste de la imagen
                ),
              ),
            ),
            label: 'BayMind',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb), 
            label: 'Avance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), 
            label: 'Perfil',
          ),
        ],

        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
