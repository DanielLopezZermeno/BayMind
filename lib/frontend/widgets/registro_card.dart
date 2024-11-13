import 'package:baymind/frontend/pantallas/estado_screen.dart';
import 'package:flutter/material.dart';
import 'package:baymind/frontend/widgets/colors.dart';

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
      width: MediaQuery.of(context).size.width *
          0.9, // 90% del ancho de la pantalla
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: isToday
              ? [AppColors.morado, AppColors.azul] // Degradado si es hoy
              : [AppColors.morado, AppColors.morado], // Degradado si no es hoy
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(2), // Margen para ver el borde degradado
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              28), // Debe ser un poco menor para que se vea el borde
          color: Colors.white, // Fondo del contenido interno
        ),
        padding: const EdgeInsets.all(16), // Padding interno para el contenido
        child: Column(
          children: [
            // Parte superior - Fecha
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                        12)), // Bordes redondeados en la parte superior
              ),
              width: double.infinity,
              padding: EdgeInsets.only(
                  top: 20), // Espacio superior para centrar el contenido
              child: Column(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Centra el contenido verticalmente
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Centra ambos textos en la fila
                    children: [
                      Text(
                        dayName,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 20, // Ajustar tamaño de fuente
                          color: AppColors.morado,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8), // Espacio entre los dos textos
                      Text(
                        month,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 20, // Ajustar tamaño de fuente
                          color: AppColors.morado,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    dayNumber,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: MediaQuery.of(context).size.height *
                          0.1, // Ajustar tamaño dinámicamente
                      color: AppColors.morado,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            // Parte del medio - "Sin registro"
            Flexible(
              child: Container(
                width:
                    MediaQuery.of(context).size.width * 0.8, // Ajusta el ancho
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(100, 202, 163, 214),
                      const Color.fromARGB(100, 50, 151, 245)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30), // Bordes redondeados
                ),
                child: Center(
                  child: Text(
                    'Sin registro',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                        fontSize: MediaQuery.of(context).size.height * 0.05,
                        color: Colors.white), // Tamaño dinámico
                  ),
                ),
              ),
            ),

            // Parte inferior - Botón
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ), // Bordes redondeados en la parte inferior
              ),
              padding: const EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height *
                  0.15, // Altura del contenedor
              width: 170,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EstadoScreen()),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.morado,
                          AppColors.azul,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Registrar',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
