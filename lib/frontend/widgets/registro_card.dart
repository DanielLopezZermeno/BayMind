import 'package:baymind/frontend/pantallas/estado_screen.dart';
import 'package:flutter/material.dart';
import 'package:baymind/frontend/widgets/colors.dart';
import 'package:baymind/servicios/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistroCard extends StatelessWidget {
  final String dayName;
  final String month;
  final String dayNumber;
  final bool isToday;

  const RegistroCard({
    super.key,
    required this.dayName,
    required this.month,
    required this.dayNumber,
    this.isToday = false,
  });

  Future<String> obtenerDatos() async {
    // Aquí llamas a tu API o servicio para obtener la frase
    try {
  // Mapa que asocia el nombre del mes con su número
  Map<String, String> months = {
    "Ene": "1",
    "Feb": "2",
    "Mar": "3",
    "Abr": "4",
    "May": "5",
    "Jun": "6",
    "Jul": "7",
    "Ago": "8",
    "Sep": "9",
    "Oct": "10",
    "Nov": "11",
    "Dic": "12",
  };

  // Convertir el nombre del mes en número
  String monthNumber = months[month] ?? "0"; // Si no se encuentra, devuelve 0

  if (monthNumber == "0") {
    throw Exception("Mes inválido");
  }

  // Supongamos que tienes una función en api_service.dart que obtiene la frase
  String estadoanimo = await ApiService.obtenerDatosTarjeta(dayNumber, monthNumber);
  return estadoanimo;
} catch (error) {
  String estadoanimo = "Sin registro";
  return estadoanimo;
}

  }

  List<Color> _getGradientColors(String estado) {
    switch (estado) {
      case "Tormenta":
        return [
          const Color.fromARGB(255, 122, 105, 127),
          const Color.fromRGBO(137, 111, 145, 1),
          Colors.white
        ];
      case "Día nublado":
        return [
          const Color.fromRGBO(202, 163, 214, 1),
          const Color.fromRGBO(180, 145, 191, 1),
          Colors.white
        ];
      case "Olas calmadas":
        return [
          const Color.fromRGBO(50, 151, 245, 1),
          const Color.fromRGBO(134, 162, 224, 1),
          Colors.white
        ];
      case "Arcoíris":
        return [
          const Color.fromRGBO(190, 237, 179, 0.4),
          const Color.fromRGBO(134, 224, 217, 1),
          Colors.white
        ];
      case "Día soleado":
        return [
          const Color.fromRGBO(255, 254, 177, 0.73),
          const Color.fromRGBO(162, 231, 198, 0.7),
          const Color.fromRGBO(134, 224, 217, 1),
          Colors.white
        ];
      default:
        return [
          const Color.fromARGB(100, 202, 163, 214),
          const Color.fromARGB(100, 50, 151, 245)
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width *
          0.9, // 90% del ancho de la pantalla
      margin: const EdgeInsets.symmetric(horizontal: 10),
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
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                        12)), // Bordes redondeados en la parte superior
              ),
              width: double.infinity,
              padding: const EdgeInsets.only(
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
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 20, // Ajustar tamaño de fuente
                          color: AppColors.morado,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8), // Espacio entre los dos textos
                      Text(
                        month,
                        style: const TextStyle(
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
              child: FutureBuilder<String>(
                future:
                    obtenerDatos(), // Llamada a tu función que devuelve Future<String>
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Indicador de carga mientras se obtienen los datos
                    return Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(100, 202, 163, 214),
                            Color.fromARGB(100, 50, 151, 245)
                          ], // Placeholder mientras carga
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    // Si hay un error, muestra un color de error
                    return Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.red, Colors.black],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          'Error al cargar datos',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: MediaQuery.of(context).size.height * 0.05,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    // Obtener los colores basados en el dato
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _getGradientColors(
                              snapshot.data!), // Aquí pasas el dato
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          snapshot.data ?? 'Sin datos',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: MediaQuery.of(context).size.height * 0.05,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  } else {
                    // En caso de no haber datos
                    return Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.white, Colors.blueGrey],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          'Sin datos',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: MediaQuery.of(context).size.height * 0.05,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),

            // Parte inferior - Botón
            Container(
              decoration: const BoxDecoration(
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
                      MaterialPageRoute(
                          builder: (context) =>
                              EstadoScreen(dayNumber: dayNumber, month: month)),
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
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
