import 'package:baymind/frontend/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:baymind/frontend/widgets/registro_card.dart';
import 'package:intl/intl.dart';

class CalendarioScreen extends StatefulWidget {
  const CalendarioScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalendarioScreenState createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  List<Map<String, dynamic>> weekDays = [];
  late final ScrollController _scrollController;

  // Listas de días y meses en español
  final Map<String, String> diasSemana = {
    'Mon': 'Lun',
    'Tue': 'Mar',
    'Wed': 'Mié',
    'Thu': 'Jue',
    'Fri': 'Vie',
    'Sat': 'Sáb',
    'Sun': 'Dom',
  };

  final Map<String, String> mesesAno = {
    'Jan': 'Ene',
    'Feb': 'Feb',
    'Mar': 'Mar',
    'Apr': 'Abr',
    'May': 'May',
    'Jun': 'Jun',
    'Jul': 'Jul',
    'Aug': 'Ago',
    'Sep': 'Sep',
    'Oct': 'Oct',
    'Nov': 'Nov',
    'Dec': 'Dic',
  };

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _generateCurrentWeek(); // Generar los días de la semana actual
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Generar los días de la semana a partir de una fecha dada (el día seleccionado y los 6 días anteriores)
  void _generateWeek(DateTime selectedDate) {
    setState(() {
      weekDays = [];
      // Calcular el inicio de la semana (6 días antes del día seleccionado)
      DateTime startOfWeek = selectedDate.subtract(const Duration(days: 6));

      for (int i = 0; i < 7; i++) {
        DateTime day = startOfWeek.add(Duration(days: i));
        String dayName = DateFormat('EEE').format(day); // Nombre del día en inglés
        String monthName = DateFormat('MMM').format(day); // Nombre del mes en inglés

        // Convertir a español usando los mapas
        String dayNameSpanish = diasSemana[dayName] ?? dayName;
        String monthNameSpanish = mesesAno[monthName] ?? monthName;

        weekDays.add({
          'dayName': dayNameSpanish,
          'dayNumber': DateFormat('d').format(day), // Número del día
          'month': monthNameSpanish, // Mes en español
        });
      }
    });
  }

  /// Generar los días de la semana actual
  void _generateCurrentWeek() {
    _generateWeek(DateTime.now());
  }

  /// Mostrar el selector de fecha para elegir la semana
  Future<void> _selectWeek(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: DateTime(2000),
      lastDate: today,
    );

    if (picked != null) {
      _generateWeek(picked); // Generar la semana con el día seleccionado y los 6 días anteriores
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 42),
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [AppColors.morado, Color.fromRGBO(180, 145, 191, 1), Colors.white],
            radius: 1.1,
            center: Alignment.center,
          ),
        ),
        child: Column(
          children: [
            // Ícono con gradiente para seleccionar la semana
            Padding(
              padding: const EdgeInsets.only(right: 25, bottom: 15),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => _selectWeek(context),
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppColors.morado, Colors.blue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: const Icon(
                      Icons.calendar_today_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // Lista de días de la semana
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
                    isToday: _isToday(day),
                  );
                },
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  /// Verificar si el día es hoy
  bool _isToday(Map<String, dynamic> day) {
    final DateTime now = DateTime.now();
    final String todayNumber = DateFormat('d').format(now);
    final String todayMonth = DateFormat('MMM').format(now);
    return day['dayNumber'] == todayNumber && day['month'] == (mesesAno[todayMonth] ?? todayMonth);
  }
}
