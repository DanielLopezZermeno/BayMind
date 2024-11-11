import 'package:baymind/frontend/widgets/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AvanceScreen extends StatefulWidget {
  @override
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

  // Generar datos para los últimos 7 días (5 valores posibles)
  List<FlSpot> _getDailyData() {
    return List.generate(7, (index) {
      return FlSpot(
        index.toDouble(),
        (index % 6).toDouble(), // Datos simulados, valores entre 0 y 5
      );
    });
  }

  // Generar datos para las últimas 8 semanas (5 valores posibles)
  List<FlSpot> _getWeeklyData() {
    return List.generate(8, (index) {
      return FlSpot(
        index.toDouble(),
        (index % 6).toDouble(), // Datos simulados, valores entre 0 y 5
      );
    });
  }

  // Generar datos para los últimos 5 meses (5 valores posibles)
  List<FlSpot> _getMonthlyData() {
    return List.generate(8, (index) {
      return FlSpot(
        index.toDouble(),
        (index % 6).toDouble(), // Datos simulados, valores entre 0 y 5
      );
    });
  }

  // Formatear la fecha según el periodo seleccionado
  String _formatDate(int index, String type) {
    DateTime today = DateTime.now();
    DateFormat dateFormat;

    switch (type) {
      case 'Días':
        DateTime date = today.subtract(Duration(days: 6 - index));
        dateFormat = DateFormat('dd/MM');
        return dateFormat.format(date);
      case 'Semanas':
        DateTime startOfWeek =
            today.subtract(Duration(days: (7 * (7 - index))));
        dateFormat = DateFormat('dd/MM');
        return '${dateFormat.format(startOfWeek)}';
      case 'Meses':
        DateTime month = DateTime(today.year, today.month - (4 - index), 1);
        dateFormat = DateFormat('MMM ');
        return dateFormat.format(month);
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('¡Es un gran progreso!',
            style:
                TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Manrope', color: AppColors.morado, fontSize: 24)),
        bottom: TabBar(
          controller: _tabController,
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
              height: 250, // Ajusta la altura aquí según lo necesites
              child: _buildLineChart(_getDailyData(), 'Días'),
            ),
            SizedBox(
              height: 250, // Ajusta la altura aquí según lo necesites
              child: _buildLineChart(_getWeeklyData(), 'Semanas'),
            ),
            SizedBox(
              height: 250, // Ajusta la altura aquí según lo necesites
              child: _buildLineChart(_getMonthlyData(), 'Meses'),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir el gráfico dentro de un Container
  Widget _buildLineChart(List<FlSpot> data, String type) {
    return Container(
      margin: const EdgeInsets.only(
          top: 80, bottom: 80,left: 10, right: 10), // Márgenes alrededor del gráfico
      padding: const EdgeInsets.all(38.0), // Relleno interno del contenedor
      decoration: BoxDecoration(
        color: const Color.fromARGB(
            255, 255, 255, 255), // Color de fondo del contenedor
        borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
        border: Border.all(
          color: AppColors.azul, // Color del borde
          width: 2, // Grosor del borde
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            verticalInterval:
                1, // Define el intervalo entre las líneas verticales
            horizontalInterval:
                1, // Define el intervalo entre las líneas horizontales (1 en 1)
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  String label = _formatDate(value.toInt(), type);
                  return Text(label, style: const TextStyle(fontSize: 10));
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: data,
              isCurved: true,
              color: AppColors.morado,
              barWidth: 3,
              dotData: FlDotData(show: true),
              //belowBarData: BarAreaData(show: true, color: Colors.purple.withOpacity(0.2)),
            ),
          ],
        ),
      ),
    );
  }
}
