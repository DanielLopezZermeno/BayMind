// calendario_screen.dart
import 'package:flutter/material.dart';
import 'package:baymind/frontend/widgets/registro_card.dart';


class CalendarioScreen extends StatefulWidget {
  @override
  _CalendarioScreenState createState() => _CalendarioScreenState();
}
class _CalendarioScreenState extends State<CalendarioScreen> {
  final List<Map<String, dynamic>> weekDays = [
    {'dayName': 'Mon', 'dayNumber': '10', 'month': 'Jun'},
    {'dayName': 'Tue', 'dayNumber': '11', 'month': 'Jun'},
    {'dayName': 'Wed', 'dayNumber': '12', 'month': 'Jun'},
    {'dayName': 'Thu', 'dayNumber': '13', 'month': 'Jun'},
    {'dayName': 'Fri', 'dayNumber': '14', 'month': 'Jun'},
    {'dayName': 'Sat', 'dayNumber': '15', 'month': 'Jun'},
    {'dayName': 'Sun', 'dayNumber': '16', 'month': 'Jun'},
  ];
 late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Desplazarse al final del ListView al cargar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }
   @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
            padding: const EdgeInsets.only(right: 32.0, top: 32), // Espaciado a la derecha
            child: Icon(Icons.calendar_today_rounded),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 42),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.withOpacity(0.1), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: weekDays.length,
                
                itemBuilder: (context, index) {
                  final day = weekDays[index];
                  return RegistroCard(
                    dayName: day['dayName'],
                    month: day['month'],
                    dayNumber: day['dayNumber'],
                    isToday: index == weekDays.length-1, // Muestra el segundo día como "hoy"
                  );
                },
              ),
            ),
            SizedBox(height: 120),
          ],
        ),
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none, // Permite que el botón sobresalga
        children: [
          BottomNavigationBar(
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
                icon: SizedBox.shrink(), // Espacio reservado para el botón "BayMind"
                label: '',
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
          Positioned(
            bottom: 20, // Ajusta esta posición según lo necesites
            left: MediaQuery.of(context).size.width / 2 - 22, // Centrado horizontal
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    // Acción del botón BayMind
                  },
                  child: Image.asset(
                    'assets/baymind.jpg', // Asegúrate de que esta ruta es correcta
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
