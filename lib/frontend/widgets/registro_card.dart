import 'package:baymind/frontend/pantallas/estado_screen.dart';
import 'package:flutter/material.dart';

class RegistroCard extends StatelessWidget {
  final String dayName;
  final String month;
  final String dayNumber;
  final bool isToday;

  const RegistroCard({
    Key? key,
    required this.dayName,
    required this.month,
    required this.dayNumber,
    this.isToday = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9, // 90% del ancho de la pantalla
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30), // Bordes redondeados para toda la tarjeta
        border: Border.all(color: isToday ? Colors.purple : Colors.blue, width: 2),
        color: Colors.white, 
      ),
      child: Column(
        children: [
          // Parte superior - Fecha
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)), // Bordes redondeados en la parte superior
            ),
            width: double.infinity,
            padding: EdgeInsets.only(top: 20), // Espacio superior para centrar el contenido
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centra el contenido verticalmente
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Centra ambos textos en la fila
                  children: [
                    Text(
                      dayName,
                      style: TextStyle(
                        fontSize: 20, // Ajustar tamaño de fuente
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8), // Espacio entre los dos textos
                    Text(
                      month,
                      style: TextStyle(
                        fontSize: 20, // Ajustar tamaño de fuente
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                Text(
                  dayNumber,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.1, // Ajustar tamaño dinámicamente
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Parte del medio - "Sin registro"
          Flexible(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8, // Ajusta el ancho
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.withOpacity(0.5), Colors.blueAccent.withOpacity(0.5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30), // Bordes redondeados
              ),
              child: Center(
                child: Text(
                  'Sin registro',
                  style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.05, color: Colors.grey), // Tamaño dinámico
                ),
              ),
            ),
          ),

          // Parte inferior - Botón
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)), // Bordes redondeados en la parte inferior
            ),
            padding: EdgeInsets.all(8),
            height: MediaQuery.of(context).size.height * 0.15, // Aumentar la altura del contenedor del botón
            width: 170,
            child: Center( // Centra el contenido dentro del contenedor
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EstadoScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 60),
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Registrar', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
