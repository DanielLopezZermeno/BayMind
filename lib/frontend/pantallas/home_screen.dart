import 'package:baymind/frontend/menu/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:baymind/frontend/widgets/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:baymind/frontend/pantallas/estado_screen.dart';
import 'package:baymind/main.dart';
class MoodBarChart extends StatelessWidget {
  const MoodBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          //tooltipBgColor: Colors.blueGrey,
          tooltipPadding: const EdgeInsets.all(8),
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    final style = const TextStyle(
      shadows: [
        Shadow(
          offset: Offset(2.0, 2.0), // Desplazamiento de la sombra
          blurRadius: 3.0, // Radio de desenfoque de la sombra
          color: Colors.grey, // Color de la sombra
        ),
      ],
      color: Colors.blueGrey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Lun';
        break;
      case 1:
        text = 'Mar';
        break;
      case 2:
        text = 'Mié';
        break;
      case 3:
        text = 'Jue';
        break;
      case 4:
        text = 'Vie';
        break;
      case 5:
        text = 'Sáb';
        break;
      case 6:
        text = 'Dom';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
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

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          AppColors.azul,
          AppColors.morado,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: 10,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: 8,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: 14,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: 15,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              toY: 9,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              toY: 11,
              gradient: _barsGradient,
            )
          ],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
              toY: 13,
              gradient: _barsGradient,
            )
          ],
        ),
      ];
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 42),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '¡Hola preciosa!',
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Manrope'),
                  ),
                ),
                const SizedBox(height: 20),
                // Primer cuadro: Saludo y cita
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(
                        2), // Margen para ver el borde degradado
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          28), // Borde interno más pequeño
                      color: Colors.white, // Fondo del contenido
                    ),
                    padding: const EdgeInsets.all(16), // Padding interno
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '"Sé tú mismo. Todos los demás ya están ocupados" - Oscar Wilde.',
                          style: TextStyle(
                              shadows: [
                                Shadow(
                                  offset: Offset(
                                      2.0, 2.0), // Desplazamiento de la sombra
                                  blurRadius:
                                      3.0, // Radio de desenfoque de la sombra
                                  color: Colors.grey, // Color de la sombra
                                ),
                              ],
                              fontFamily: 'Manrope',
                              fontSize: 16,
                              color: Color.fromRGBO(117, 117, 117, 1)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Segundo cuadro: Gráfico
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Primer container
                    Container(
                      height: MediaQuery.of(context).size.height * 0.20,
                      width: MediaQuery.of(context).size.width * 0.42,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.morado, AppColors.azul],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(
                            2), // Margen para ver el borde degradado
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          color: Colors.white, // Fondo del contenido interno
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '¿Qué tal tu día?',
                              style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 16,
                                  color: Color.fromRGBO(117, 117, 117, 1),
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EstadoScreen()),
                    );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                padding: const EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: ShaderMask(
                                shaderCallback: (bounds) {
                                  return const LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 205, 89, 240),
                                      Color.fromARGB(255, 159, 209, 255),
                                      Color.fromARGB(255, 205, 89, 240),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds);
                                },
                                child: const Text(
                                  'Registrar',
                                  style: TextStyle(
                                      fontFamily: 'Manrope',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Espacio entre los contenedores
                    const SizedBox(width: 12),

                    // Segundo container
                    Container(
                      height: MediaQuery.of(context).size.height * 0.20,
                      width: MediaQuery.of(context).size.width * 0.42,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.morado, AppColors.azul],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(
                            2), // Margen para ver el borde degradado
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          color: Colors.white, // Fondo del contenido interno
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Cuéntamelo todo',
                              style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 16,
                                  color: Color.fromRGBO(117, 117, 117, 1),
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                NavigationController.updateTab(2);
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                padding: const EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: ShaderMask(
                                shaderCallback: (bounds) {
                                  return const LinearGradient(
                                    colors: [AppColors.morado, AppColors.azul],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds);
                                },
                                child: const Text(
                                  'Platicar',
                                  style: TextStyle(
                                      fontFamily: 'Manrope',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: MediaQuery.of(context).size.height * 0.42,
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: Container(
                    margin: const EdgeInsets.all(
                        2), // Margen para ver el borde degradado
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16), // Padding interno
                    child: const Column(
                      children: [
                        Text(
                          'Todos tus sentimientos son válidos',
                          style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 16,
                              color: Color.fromRGBO(117, 117, 117, 1),
                              fontWeight: FontWeight.bold),
                        ),
                        // Aquí iría el gráfico de barras.
                        SizedBox(height: 20),
                        Expanded(
                          child: MoodBarChart(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
