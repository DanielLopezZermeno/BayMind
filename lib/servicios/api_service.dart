import 'dart:convert';
import 'package:baymind/frontend/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrlFrases =
      'https://baymind-backend-yyfm.onrender.com/api/auth/frase';
  static const String _baseUrlBarChart =
      'https://baymind-backend-yyfm.onrender.com/api/auth/obtenersemana'; // Nueva URL para obtener los datos de las barras
  static const String _baseUrlLineChartDias =
      'https://baymind-backend-yyfm.onrender.com/api/auth/obtenerultimosestados';
  static const String _baseUrlLineChartSemanas =
      'https://baymind-backend-yyfm.onrender.com/api/auth/obtenersemanas';
  static const String _baseUrlLineChartMeses =
      'https://baymind-backend-yyfm.onrender.com/api/auth/obtenermeses';
  static const String nuevoRegistro =
      'https://baymind-backend-yyfm.onrender.com/api/auth/mood';
  // ignore: constant_identifier_names
  static const String Datostarjeta =
      'https://baymind-backend-yyfm.onrender.com/api/auth/estadodia';
  static const String Mensaje =
      'https://baymind-backend-yyfm.onrender.com/api/auth/actualizarchat';
  static const String Chat =
      'https://baymind-backend-yyfm.onrender.com/api/auth/chat'; 

  // Método para obtener una frase motivacional aleatoria
  static Future<String> obtenerFraseAleatoria() async {
    try {
      final response = await http.get(Uri.parse(_baseUrlFrases));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['data'] != null &&
            responseData['data']['text'] != null) {
          return responseData['data']['text'];
        } else {
          return 'Hoy no hay frase, pero ánimo';
        }
      } else {
        return 'Error al obtener la frase: ${response.statusCode}';
      }
    } catch (error) {
      return 'Hoy no hay frase, pero ánimo';
    }
  }

  // Nuevo método para obtener los datos del gráfico de barras desde la API
  static Future<List<BarChartGroupData>> obtenerDatosBarChart(
      int dia, int mes) async {
    try {
      String? yourToken = await getToken();
      if (yourToken == null) {
        print("Usuario no encontrado.");
      } else {
        print("Usuario obtenido: $yourToken");
      }
      Map<String, dynamic> body = {'email': yourToken, 'dia': dia, 'mes': mes};
      // Realizar la solicitud HTTP GET con la URL construida
      var response = await http.post(Uri.parse(_baseUrlBarChart),
          headers: {
            'Content-Type': 'application/json', // Encabezado necesario
          },
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> estados = responseData['estados'];

        // Convertir los datos obtenidos a BarChartGroupData
        List<BarChartGroupData> barGroups = [];
        for (int i = 0; i < estados.length; i++) {
          final estado = estados[i];
          final double moodValue = estado['mood'] == ""
              ? 0.0 // Asignar 0 si no hay estado
              : _convertMoodToValue(estado['mood']); // Conversión personalizada

          barGroups.add(
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: moodValue,
                  gradient: _barsGradient,
                ),
              ],
            ),
          );
        }
        return barGroups; // Devuelve los datos procesados para el gráfico
      } else {
        // En caso de error en la respuesta, retornar valores predeterminados
        return List.generate(
          7,
          (index) => BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: 0, // Valor 0 en caso de error
                gradient: _barsGradient,
              ),
            ],
          ),
        );
      }
    } catch (error) {
      // En caso de excepción, retornar valores predeterminados
      return List.generate(
        7,
        (index) => BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: 0, // Valor 0 en caso de error
              gradient: _barsGradient,
            ),
          ],
        ),
      );
    }
  }

  static Future<List<LineChartBarData>> obtenerDatosLineChart(
    String type, {
    int? primerDia,
    int? primerMes,
    int? ultimoDia,
    int? ultimoMes,
    int? dia,
    int? mes,
  }) async {
    try {
      String? yourToken = await getToken();
      if (yourToken == null) {
        print("Usuario no encontrado.");
      } else {
        print("Usuario obtenido: $yourToken");
      }
      // Construcción dinámica de la URL según el tipo
      http.Response response;
      if (type == 'days') {
        // Verifica que los parámetros necesarios estén presentes
        if (primerDia == null ||
            primerMes == null ||
            ultimoDia == null ||
            ultimoMes == null) {
          throw ArgumentError('Faltan parámetros para el tipo "days".');
        }
        Map<String, dynamic> body = {
          'email': yourToken,
          'primerdia': primerDia,
          'primermes': primerMes,
          'ultimodia': ultimoDia,
          'ultimomes': ultimoMes
        };
        print(body);
        // Realizar la solicitud HTTP GET con la URL construida
        response = await http.post(Uri.parse(_baseUrlLineChartDias),
            headers: {
              'Content-Type': 'application/json', // Encabezado necesario
            },
            body: jsonEncode(body));
      } else if (type == 'weeks') {
        // Verifica que los parámetros necesarios estén presentes
        if (dia == null || mes == null) {
          throw ArgumentError('Faltan parámetros para el tipo "weeks".');
        }
        Map<String, dynamic> body = {
          'email': yourToken,
          'dia': dia,
          'mes': mes
        };
        print(body);
        // Realizar la solicitud HTTP GET con la URL construida
        response = await http.post(Uri.parse(_baseUrlLineChartSemanas),
            headers: {
              'Content-Type': 'application/json', // Encabezado necesario
            },
            body: jsonEncode(body));
      } else {
        // Para otros tipos, usa los parámetros estándar
        if (dia == null || mes == null) {
          throw ArgumentError('Faltan parámetros para el tipo predeterminado.');
        }
        Map<String, dynamic> body = {
          'email': yourToken,
          'dia': dia,
          'mes': mes
        };
        print(body);
        // Realizar la solicitud HTTP GET con la URL construida
        response = await http.post(Uri.parse(_baseUrlLineChartMeses),
            headers: {
              'Content-Type': 'application/json', // Encabezado necesario
            },
            body: jsonEncode(body));
      }

      final List<FlSpot> spots = [];
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final List<dynamic> estados = data['estados'];
        // Ordenar por fecha (de más lejana a más reciente)
        estados.sort((a, b) {
          final dateA = DateTime.parse(a['date']);
          final dateB = DateTime.parse(b['date']);
          return dateA.compareTo(dateB); // Orden ascendente
        });
        for (int i = 0; i < estados.length; i++) {
          final estado = estados[i];
          final double moodValue = estado['mood'] == ""
              ? 0.0 // Asignar 0 si no hay estado
              : _convertMoodToValue(estado['mood']); // Conversión personalizada

          // Agregar FlSpot al listado
          spots.add(
            FlSpot(
              i.toDouble(), // Índice como coordenada X
              moodValue, // Valor convertido como coordenada Y
            ),
          );
        }

        // Creamos un LineChartBarData con los puntos generados
        return [
          LineChartBarData(
            spots: spots, // Asignamos los puntos generados
            isCurved: true, // Puedes ajustar si la línea debe ser curva o recta
            color:
                const Color.fromARGB(255, 255, 255, 255), // Color de la línea
            dotData:
                const FlDotData(show: false), // Ocultar los puntos en la línea
            belowBarData:
                BarAreaData(show: false), // Ocultar el área debajo de la línea
          ),
        ];
      } else {
        // Si la respuesta no es 200, retornamos valores predeterminados (0)
        return _valoresPredeterminados();
      }
    } catch (error) {
      // Si hay un error, retornamos valores predeterminados (0)
      return _valoresPredeterminados();
    }
  }

// Función auxiliar para valores predeterminados
  static List<LineChartBarData> _valoresPredeterminados() {
    return [
      LineChartBarData(
        spots: [
          const FlSpot(0, 0), // Punto de valor 0 en el eje Y
          const FlSpot(1, 0),
          const FlSpot(2, 0),
          const FlSpot(3, 0),
          const FlSpot(4, 0),
          const FlSpot(5, 0),
          const FlSpot(6, 0),
        ],
        isCurved: true,
        color: const Color.fromARGB(255, 255, 255, 255),
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
      ),
    ];
  }

  static Future<void> enviarDatos(String dia, String mes, String estado) async {
    String? yourToken = await getToken();
    if (yourToken == null) {
      print("Usuario no encontrado.");
    } else {
      print("Usuario obtenido: $yourToken");
    }

    final url = Uri.parse(nuevoRegistro); // Reemplaza con tu URL
    // Construimos el cuerpo de la solicitud incluyendo el `userId`
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
    String monthNumber = months[mes] ?? DateTime.now().month.toString(); // Si no se encuentra, devuelve 0

    if (monthNumber == "0") {
      throw Exception("Mes inválido");
    }
    final body = jsonEncode(
        {"email": yourToken, "dia": dia, "mes": monthNumber, "estado": estado});
    print(body);
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json', // Encabezado necesario
          },
          body: body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error al enviar los datos: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print("Excepción al enviar datos: $e");
    }
  }

  static Future<String> obtenerDatosTarjeta(String dia, String mes) async {
    try {
      String? yourToken = await getToken();
      if (yourToken == null) {
        print("Usuario no encontrado.");
      } else {
        print("Usuario obtenido: $yourToken");
      }
      final body = jsonEncode({"email": yourToken, "dia": dia, "mes": mes});
      print(body);
      final response = await http.post(Uri.parse(Datostarjeta),
          headers: {
            'Content-Type': 'application/json', // Encabezado necesario
          },
          body: body);
      print(response);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        // Acceder al "mood" dentro de "estados"
        final mood = data['estados']['mood'] ??
            "Sin registro"; // Asigna "Sin registro" si mood es nulo
        return mood;
      } else {
        return "Sin registro";
      }
    } catch (error) {
      return "Sin registro";
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs
        .getString('email'); // Recupera el token con la clave 'authToken'
  }

  static Future<void> guardarMensaje(String fecha, String nombre, String mensaje) async {
    String? yourToken = await getToken();
    if (yourToken == null) {
      print("Usuario no encontrado.");
    } else {
      print("Usuario obtenido: $yourToken");
    }
  // Cuerpo de la solicitud
  final Map<String, dynamic> requestBody = {
    'email': yourToken,
    'fecha': fecha,
    'nombre': nombre,
    'mensaje': mensaje,
  };

  try {
    // Realizar la solicitud POST
    final response = await http.post(
      Uri.parse(Mensaje),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody), // Convertir el cuerpo a JSON
    );

    // Verificar el código de estado de la respuesta
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Mensaje guardado exitosamente');
    } else {
      print('Error al guardar el mensaje: ${response.statusCode}');
    }
  } catch (e) {
    // Si ocurre un error, mostrarlo en la consola
    print('Excepción al guardar el mensaje: $e');
  }
}

  static Future<List<Map<String, dynamic>>> obtenerMensajes() async {
 String? yourToken = await getToken();
    if (yourToken == null) {
      print("Usuario no encontrado.");
    } else {
      print("Usuario obtenido: $yourToken");
    }
  try {
    // Realizar la solicitud GET para obtener los mensajes
    final response = await http.post(
      Uri.parse(Chat),
      headers: {'Content-Type': 'application/json'}, // Enviar el email en los encabezados
      body: jsonEncode({'email':yourToken})
    );

    // Verificar el código de estado de la respuesta
    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, decodificar la respuesta JSON
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Si el servidor devuelve un campo 'chat' que contiene los mensajes
      final List<dynamic> mensajes = data['chat'] ?? [];

      // Convertir la lista de mensajes a una lista de Map<String, dynamic>
      return mensajes.map((msg) => {
        'date': msg['date'],
        'from': msg['from'],
        'message': msg['message'],
      }).toList();
    } else {
      throw Exception('Error al obtener los mensajes: ${response.statusCode}');
    }
  } catch (e) {
    // Si ocurre un error, mostrarlo en la consola
    print('Excepción al obtener los mensajes: $e');
    return [];
  }
}
  // Aquí defines el gradiente para las barras
  static LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          AppColors.azul,
          AppColors.morado,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );
  // Función de conversión personalizada
  static double _convertMoodToValue(String mood) {
    switch (mood) {
      case "Tormenta":
        return 1;
      case "Día nublado":
        return 2;
      case "Olas calmadas":
        return 3;
      case "Arcoíris":
        return 4;
      case "Sol radiante":
        return 5;
      default:
        return 0.0;
    }
  }
}
