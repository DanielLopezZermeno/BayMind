import 'dart:convert';
import 'package:baymind/frontend/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrlFrases =
      'https://baymind-backend.onrender.com/api/auth/frase';
  static const String _baseUrlBarChart =
      'https://baymind-backend.onrender.com/api/auth/obtenersemana'; // Nueva URL para obtener los datos de las barras
  static const String _baseUrlLineChartDias =
      'https://baymind-backend.onrender.com/api/auth/obtenerultimosresultados';
  static const String _baseUrlLineChartSemanas =
      'https://baymind-backend.onrender.com/api/auth/obtenersemanas';
  static const String _baseUrlLineChartMeses =
      'https://baymind-backend.onrender.com/api/auth/obtenermeses';
  static const String nuevoRegistro =
      'https://baymind-backend.onrender.com/api/auth/registraestado';
  // ignore: constant_identifier_names
  static const String Datostarjeta =
      'https://baymind-backend.onrender.com/api/auth/tarjeta';
  // Método para obtener una frase motivacional aleatoria
  static Future<String> obtenerFraseAleatoria() async {
  try {
    final response = await http.get(Uri.parse(_baseUrlFrases));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['data'] != null && responseData['data']['text'] != null) {
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
      String usuario, int dia, int mes) async {
    try {
      // Construir la URL con los parámetros enviados
      final Uri url =
          Uri.parse('$_baseUrlBarChart?usuario=$usuario&dia=$dia&mes=$mes');

      // Realizar la solicitud HTTP GET con la URL construida
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Convertir los datos obtenidos de la API a BarChartGroupData
        List<BarChartGroupData> barGroups = [];
        for (int i = 0; i < data.length; i++) {
          barGroups.add(
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: data[i].toDouble(), // Asigna el valor obtenido de la API
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
    required String usuario,
    int? primerDia,
    int? primerMes,
    int? ultimoDia,
    int? ultimoMes,
    int? dia,
    int? mes,
  }) async {
    try {
      // Construcción dinámica de la URL según el tipo
      late Uri url;

      if (type == 'days') {
        // Verifica que los parámetros necesarios estén presentes
        if (primerDia == null ||
            primerMes == null ||
            ultimoDia == null ||
            ultimoMes == null) {
          throw ArgumentError('Faltan parámetros para el tipo "days".');
        }
        url = Uri.parse(
            '$_baseUrlLineChartDias?usuario=$usuario&primerDia=$primerDia&primerMes=$primerMes&ultimoDia=$ultimoDia&ultimoMes=$ultimoMes');
      } else if (type == 'weeks') {
        // Verifica que los parámetros necesarios estén presentes
        if (dia == null || mes == null) {
          throw ArgumentError('Faltan parámetros para el tipo "weeks".');
        }
        url = Uri.parse(
            '$_baseUrlLineChartSemanas?usuario=$usuario&dia=$dia&mes=$mes');
      } else {
        // Para otros tipos, usa los parámetros estándar
        if (dia == null || mes == null) {
          throw ArgumentError('Faltan parámetros para el tipo predeterminado.');
        }
        url = Uri.parse(
            '$_baseUrlLineChartMeses?usuario=$usuario&dia=$dia&mes=$mes');
      }

      // Realiza la solicitud HTTP
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Convertimos los datos de la API en una lista de FlSpot
        List<FlSpot> spots = [];
        for (int i = 0; i < data.length; i++) {
          spots.add(
            FlSpot(
                i.toDouble(),
                data[i]
                    .toDouble()), // Convertimos el índice y el valor de la API
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

  static Future<void> enviarDatos(
      String dayNumber, String month, String moodText, String userId) async {
    final url = Uri.parse(nuevoRegistro); // Reemplaza con tu URL
    final headers = {"Content-Type": "application/json"};

    // Construimos el cuerpo de la solicitud incluyendo el `userId`
    final body = jsonEncode({
      "userId": userId,
      "dayNumber": dayNumber,
      "month": month,
      "moodText": moodText,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error al enviar los datos: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print(
          "Excepción al enviar datos: $e $dayNumber, $month, $moodText, $userId");
    }
  }


  static Future<void> guardarUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  static Future<String> obtenerUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') ?? '';
  }

  static Future<String> obtenerDatosTarjeta(String dia, String mes) async {
    try {
      final response = await http.get(Uri.parse(Datostarjeta));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data[2];
      } else {
        const data = "Sin registro";
        return data;
      }
    } catch (error) {
      const data = "Sin registro";
      return data;
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
}
