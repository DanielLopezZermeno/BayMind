import 'package:flutter/material.dart';
import 'package:baymind/frontend/widgets/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:baymind/frontend/pantallas/estado_screen.dart';
import 'package:baymind/main.dart';
import 'package:baymind/servicios/api_service.dart';


class MoodBarChart extends StatefulWidget {
  const MoodBarChart({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MoodBarChartState createState() => _MoodBarChartState();
}

class _MoodBarChartState extends State<MoodBarChart> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BarChartGroupData>>(
      // Llamamos al método obtenerDatosBarChart desde ApiService
      future: ApiService.obtenerDatosBarChart(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error al cargar los datos"));
        } else if (snapshot.hasData) {
          // Si tenemos datos, los usamos para el gráfico
          final barGroups = snapshot.data!;
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
        } else {
          // Si no hay datos (caso de error o vacío), mostramos el gráfico vacío con 0s
          return const Center(child: Text("No hay datos disponibles"));
        }
      },
    );
  }

  // Datos de interacción al tocar las barras
  BarTouchData get barTouchData => BarTouchData(
  enabled: true,
  touchTooltipData: BarTouchTooltipData(
    tooltipPadding: const EdgeInsets.all(8),
    tooltipMargin: 8,
    getTooltipItem: (
      BarChartGroupData group,
      int groupIndex,
      BarChartRodData rod,
      int rodIndex,
    ) {
      String tooltipText;
      switch (rod.toY.round()) {
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

      return BarTooltipItem(
        tooltipText,
        const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    },
  ),
);


  // Títulos del gráfico
  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      shadows: [
        Shadow(
          offset: Offset(2.0, 2.0),
          blurRadius: 3.0,
          color: Colors.grey,
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

  // Datos de los títulos en el gráfico
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

  // Datos de borde (en este caso no se muestra el borde)
  FlBorderData get borderData => FlBorderData(show: false);
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen>{
  String fraseDelDia = 'Cargando frase...';
  @override
    void initState() {
      super.initState();
      obtenerFraseDelDia();
    }
  Future<void> obtenerFraseDelDia() async {
    // Aquí llamas a tu API o servicio para obtener la frase
    try {
      // Supongamos que tienes una función en api_service.dart que obtiene la frase
      String nuevaFrase = await ApiService.obtenerFraseAleatoria();
      
      setState(() {
        fraseDelDia = nuevaFrase;
      });
    } catch (error) {
      setState(() {
        fraseDelDia = 'Hoy no hay frase, pero ánimo';
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    
    DateTime today = DateTime.now();
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
                    '¡Hola hermosura!',
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
                  width: MediaQuery.of(context).size.width * 0.90,
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
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fraseDelDia,
                          style: const TextStyle(
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
                              //al presionar este botón, se manda la fecha actual
                              onPressed: () {
                                Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EstadoScreen(dayNumber: today.day.toString(), month: today.month.toString(),)),
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
                // ignore: sized_box_for_whitespace
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
