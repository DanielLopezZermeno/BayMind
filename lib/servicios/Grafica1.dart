import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<int>> fetchMoodData() async {
  final response = await http.get(Uri.parse('http://localhost:3000/api/mood-data'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);

    // Inicializa la lista con valores por defecto (sin registro)
    List<int> moodValues = List<int>.filled(7, 0);

    for (var mood in data) {
      DateTime date = DateTime.parse(mood['date']);

      // Convertimos el día de la semana a un índice de 0 a 6
      int index = date.weekday - 1; // Lunes es 0, Domingo es 6

      // Manejo de valores nulos con el operador ?? (predeterminado a 0 si es nulo)
      moodValues[index] = (mood['moodValue'] as int?) ?? 3;
    }

    return moodValues;
  } else {
    // Valores predeterminados si no se reciben datos del servidor
    List<int> defaultMoodValues = [1, 2, 3, 4, 5, 3, 2];
    // Devuelve un ejemplo de valores para cada día de la semana:
    // Lunes: Tormenta (1)
    // Martes: Día nublado (2)
    // Miércoles: Olas calmadas (3)
    // Jueves: Arcoíris (4)
    // Viernes: Sol radiante (5)
    // Sábado: Olas calmadas (3)
    // Domingo: Día nublado (2)
    
    return defaultMoodValues;
  }
}
