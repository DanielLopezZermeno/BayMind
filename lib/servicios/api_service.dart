import 'dart:convert';
import 'package:baymind/frontend/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrlFrases = 'http://localhost:3000/api/frases/aleatoria';
  static const String _baseUrlBarChart = 'http://localhost:3000/api/datos/barChart'; // Nueva URL para obtener los datos de las barras
  static const String _baseUrlLineChartDias = 'http://localhost:3000/api/datos/lineChart';
  static const String _baseUrlLineChartSemanas = 'http://localhost:3000/api/datos/lineChart';
  static const String _baseUrlLineChartMeses = 'http://localhost:3000/api/datos/lineChart';
  static const String nuevoRegistro = 'https://baymind-backend.onrender.com/api/auth';
  // ignore: constant_identifier_names
  static const String Datostarjeta = 'http://localhost:3000/api/datos/lineChart';
  // Método para obtener una frase motivacional aleatoria
  static Future<String> obtenerFraseAleatoria() async {
    try {
      final response = await http.get(Uri.parse(_baseUrlFrases));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success']) {
          return data['frase'];
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
 static Future<List<BarChartGroupData>> obtenerDatosBarChart() async {
    try {
      final response = await http.get(Uri.parse(_baseUrlBarChart));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Aquí debes convertir los datos de la API a BarChartGroupData
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
        // Si la respuesta es diferente a 200, retorna valores predeterminados (0)
        return List.generate(7, (index) => BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: 0, // Valor 0 en caso de error
              gradient: _barsGradient,
            ),
          ],
        ));
      }
    } catch (error) {
      // Si ocurre un error en la llamada a la API, también retornamos valores 0
      return List.generate(7, (index) => BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: 0, // Valor 0 en caso de error
            gradient: _barsGradient,
          ),
        ],
      ));
    }
  }

  static Future<List<LineChartBarData>> obtenerDatosLineChart(String type) async {
  try {
    final http.Response response;
    
    if(type=='days'){
        response = await http.get(Uri.parse(_baseUrlLineChartDias));
    }else{
      if(type=='weeks'){
        response = await http.get(Uri.parse(_baseUrlLineChartSemanas));
    }else{
        response = await http.get(Uri.parse(_baseUrlLineChartMeses));
    }
    }

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      // Convertimos los datos de la API en una lista de FlSpot
      List<FlSpot> spots = [];
      for (int i = 0; i < data.length; i++) {
        spots.add(
          FlSpot(i.toDouble(), data[i].toDouble()), // Convertimos el índice y el valor de la API
        );
      }

      // Creamos un LineChartBarData con los puntos generados
      return [
        LineChartBarData(
          spots: spots, // Asignamos los puntos generados
          isCurved: true, // Puedes ajustar si la línea debe ser curva o recta
          color: const Color.fromARGB(255, 255, 255, 255), // Color de la línea
          dotData: const FlDotData(show: false), // Ocultar los puntos en la línea
          belowBarData: BarAreaData(show: false), // Ocultar el área debajo de la línea
        ),
      ];
    } else {
      // Si la respuesta no es 200, retornamos valores predeterminados (0)
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
  } catch (error) {
    // Si hay un error, retornamos valores predeterminados (0)
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
}
  
  static Future<void> enviarDatos(
    String dayNumber, String month, String moodText, String userId) async {
  final url = Uri.parse("$nuevoRegistro/mood"); // Reemplaza con tu URL de API


   // Recuperar el token desde SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('authToken'); // Usar la misma clave

  try {
      if (token == null) {
        throw Exception('No se encontró el token JWT');
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'userId': userId,
          'dia': dayNumber,
          'mes': month,
          'estadoAnimo': moodText,
          'fecha': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error al enviar los datos: ${response.statusCode}');
      }
    } catch (e) {
      // Aquí puedes manejar los errores según tus necesidades
      print('Error en enviarDatos: $e');
      rethrow;
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
        final  data = jsonDecode(response.body);
        return data[2];   
      } else {
        const data="Sin registro";
        return data;
      }
    } catch (error) {
      const data="Sin registro";
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
