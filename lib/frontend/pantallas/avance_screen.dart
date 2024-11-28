import 'package:baymind/frontend/widgets/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:baymind/servicios/api_service.dart';
import 'package:intl/intl.dart';

class MoodLineChart extends StatefulWidget {
  final String
      chartType; // Agregamos este parámetro para decidir el tipo de gráfico
  final int? primerDia; // Primer día (solo para "days")
  final int? primerMes; // Primer mes (solo para "days")
  final int? ultimoDia; // Último día (solo para "days")
  final int? ultimoMes; // Último mes (solo para "days")
  final int? dia; // Día (para "weeks" y otros tipos)
  final int? mes; // Mes (para "weeks" y otros tipos)

  const MoodLineChart({
    super.key,
    required this.chartType,
    this.primerDia,
    this.primerMes,
    this.ultimoDia,
    this.ultimoMes,
    this.dia,
    this.mes,
  });
  // Modificamos el constructor para aceptar el tipo de gráfico
  //const MoodLineChart({super.key, required this.chartType});

  @override
  // ignore: library_private_types_in_public_api
  _MoodLineChartState createState() => _MoodLineChartState();
}

class _MoodLineChartState extends State<MoodLineChart> {

  @override
  Widget build(BuildContext context) {
          return FutureBuilder<List<LineChartBarData>>(
            future: ApiService.obtenerDatosLineChart(
              widget.chartType,
              primerDia: widget.primerDia,
              primerMes: widget.primerMes,
              ultimoDia: widget.ultimoDia,
              ultimoMes: widget.ultimoMes,
              dia: widget.dia,
              mes: widget.mes,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Error al cargar los datos"));
              } else if (snapshot.hasData) {
                final lineData = snapshot.data!;

                return LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: getTitlesData(widget
                        .chartType), // Usamos el tipo de gráfico proporcionado
                    lineBarsData: lineData,
                    lineTouchData: lineTouchData,
                    minY: 0,
                    maxY: 5,
                  ),
                );
              } else {
                return const Center(child: Text("No hay datos disponibles"));
              }
            },
          );

  }

  // Datos de interacción al tocar las líneas
  LineTouchData get lineTouchData => LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipPadding: const EdgeInsets.all(8),
          tooltipMargin: 8,
          getTooltipItems: (List<LineBarSpot> spots) {
            return spots.map((spot) {
              String tooltipText;
              switch (spot.y.toInt()) {
                case 0:
                  tooltipText = 'Sin registro';
                  break;
                case 1:
                  tooltipText = 'Tormenta';
                  break;
                case 2:
                  tooltipText = 'Día nublado';
                  break;
                case 3:
                  tooltipText = 'Olas calmadas';
                  break;
                case 4:
                  tooltipText = 'Arcoíris';
                  break;
                case 5:
                  tooltipText = 'Día soleado';
                  break;
                default:
                  tooltipText = 'Valor desconocido';
                  break;
              }
              return LineTooltipItem(
                tooltipText,
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      );

  // Generamos los títulos para el gráfico según el tipo
  Widget getTitles(double value, TitleMeta meta, String type) {
    DateTime today = DateTime.now();
    DateFormat dateFormat;
    String title = "";

    if (type == 'days') {
      // Últimos 7 días desde el día de hoy hacia atrás
      DateTime date = today.subtract(Duration(days: 6 - value.toInt()));
      title = "${date.day}/${date.month}";
    } else if (type == 'weeks') {
      // Últimas 3 semanas desde el día de hoy hacia atrás
      DateTime startOfWeek =
          today.subtract(Duration(days: (7 * (7 - value.toInt()))));
      dateFormat = DateFormat('dd/MM');
      title = dateFormat.format(startOfWeek);
    } else if (type == 'months') {
      // Últimos 5 meses desde el mes actual hacia atrás
      DateTime month =
          DateTime(today.year, today.month - 2 - (4 - value.toInt()), 1);
      dateFormat = DateFormat('MMM ');
      title = dateFormat.format(month);
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(title,
          style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.bold)),
    );
  }

  // Método para generar los datos de títulos en el gráfico
  FlTitlesData getTitlesData(String type) {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (value, meta) => getTitles(value, meta, type),
        ),
      ),
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }
}

class AvanceScreen extends StatefulWidget {
  const AvanceScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AvanceScreenState createState() => _AvanceScreenState();
}

class _AvanceScreenState extends State<AvanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();

    // Fecha de hace 7 días
    final DateTime sevenDaysAgo = today.subtract(const Duration(days: 7));
    // Calcula el inicio de la semana actual (asumiendo semana empieza en lunes)
    final DateTime startOfThisWeek =
        today.subtract(Duration(days: today.weekday - 1));

    // Inicio de la semana pasada
    final DateTime startOfLastWeek =
        startOfThisWeek.subtract(const Duration(days: 7));

    // Inicio de hace dos semanas
    startOfLastWeek.subtract(const Duration(days: 28));

    return Scaffold(
      appBar: AppBar(
        title: const Text('¡Es un gran progreso!',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Manrope',
                color: AppColors.morado,
                fontSize: 24)),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(
            fontFamily: 'Manrope',
          ),
          tabs: const [
            Tab(text: 'Días'),
            Tab(text: 'Semanas'),
            Tab(text: 'Meses'),
          ],
        ),
      ),
      body: Container(
        // Añadir un fondo de gradiente al contenedor
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              AppColors.morado,
              Color.fromRGBO(180, 145, 191, 1),
              Colors.white
            ], // El gradiente va de morado a blanco
            radius: 1.1, // Controla el tamaño del área del gradiente
            center: Alignment
                .center, // El centro del gradiente será el centro del widget
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            // Aquí controlas el tamaño con SizedBox
            SizedBox(
              height: 50, // Ajusta la altura aquí según lo necesites
              child: Container(
                  margin: const EdgeInsets.only(
                      top: 80,
                      bottom: 80,
                      left: 10,
                      right: 10), // Márgenes alrededor del gráfico
                  padding: const EdgeInsets.all(
                      38.0), // Relleno interno del contenedor
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        255, 255, 255, 255), // Color de fondo del contenedor
                    borderRadius:
                        BorderRadius.circular(12.0), // Bordes redondeados
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.morado,
                        AppColors.azul,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: MoodLineChart(
                    chartType: 'days', // Usuario actual
                    primerDia: sevenDaysAgo.day,
                    primerMes: sevenDaysAgo.month,
                    ultimoDia: today.day,
                    ultimoMes: today.month,
                  )),
            ),
            SizedBox(
              height: 250, // Ajusta la altura aquí según lo necesites
              child: Container(
                  margin: const EdgeInsets.only(
                      top: 80,
                      bottom: 80,
                      left: 10,
                      right: 10), // Márgenes alrededor del gráfico
                  padding: const EdgeInsets.all(
                      38.0), // Relleno interno del contenedor
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        255, 255, 255, 255), // Color de fondo del contenedor
                    borderRadius:
                        BorderRadius.circular(12.0), // Bordes redondeados
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.morado,
                        AppColors.azul,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: MoodLineChart(
                    chartType: 'weeks',
                    dia: today.day,
                    mes: today.month,
                  )),
            ),
            SizedBox(
              height: 250, // Ajusta la altura aquí según lo necesites
              child: Container(
                  margin: const EdgeInsets.only(
                      top: 80,
                      bottom: 80,
                      left: 10,
                      right: 10), // Márgenes alrededor del gráfico
                  padding: const EdgeInsets.all(
                      38.0), // Relleno interno del contenedor
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        255, 255, 255, 255), // Color de fondo del contenedor
                    borderRadius:
                        BorderRadius.circular(12.0), // Bordes redondeados
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.morado,
                        AppColors.azul,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: MoodLineChart(
                    chartType: 'months',
                    dia: today.day, // Día actual
                    mes: today.month, // Mes inicial (hace 6 meses)
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
