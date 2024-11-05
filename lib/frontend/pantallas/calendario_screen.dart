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
      
    );
  }
}
