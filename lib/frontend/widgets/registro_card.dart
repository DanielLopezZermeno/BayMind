// registro_card.dart
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
      //height: MediaQuery.of(context).size.height * 0.50, // 50% de la altura de la pantalla
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
            height:MediaQuery.of(context).size.height * 0.25,
            padding:EdgeInsets.only(top: 40),
            child: Column(
              
              children: [
                 Row(
               mainAxisAlignment: MainAxisAlignment.center, // Centra ambos textos en la fila
               children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8), // Espacio entre los dos textos
                  Text(
                    month,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
                Text(
                  dayNumber,
                  style: TextStyle(fontSize: 105, color: Colors.purple, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          
          // Parte del medio - "Sin registro"
          Container(
            width: MediaQuery.of(context).size.height * 0.40,
            height: MediaQuery.of(context).size.height * 0.27, // 27% de la altura total
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
                style: TextStyle(fontSize: 50, color: Colors.grey),
              ),
            ),
          ),
          
          // Parte inferior - Botón
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)), // Bordes redondeados en la parte inferior
            ),
            padding: EdgeInsets.all(8),
            width: 170,
            height:MediaQuery.of(context).size.height * 0.14,
            child: Center( // Centra el contenido dentro del contenedor
              child: Container( // Contenedor que permite definir el ancho
                width: MediaQuery.of(context).size.width, // 45% del ancho de la pantalla
                // Para un cuarto del ancho de la tarjeta, descomentar la siguiente línea y comentar la anterior
                // width: MediaQuery.of(context).size.width * 0.22, // 22% del ancho de la pantalla
                child: ElevatedButton(
                  onPressed: () {
                    // Acción de registro
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
          ),


        ],
      ),
    );
  }
}
