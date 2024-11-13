import 'package:flutter/material.dart';
import 'package:baymind/frontend/widgets/estado_widgets.dart';
import 'package:baymind/frontend/widgets/colors.dart';
class EstadoScreen extends StatefulWidget {
  @override
  _EstadoScreenState createState() => _EstadoScreenState();
}

class _EstadoScreenState extends State<EstadoScreen> with SingleTickerProviderStateMixin {
  double progress = 0.0;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Color> _getGradientColors() {
    if (progress == 0.0) return [const Color.fromARGB(255, 122, 105, 127), const Color.fromRGBO(137, 111, 145, 1), Colors.white];
    if (progress <= 0.25) return [const Color.fromRGBO(202, 163, 214, 1), const Color.fromRGBO(180,145,191, 1),Colors.white];
    if (progress <= 0.5) return [const Color.fromRGBO(50, 151, 245, 1), const Color.fromRGBO(134, 162, 224, 1),Colors.white];
    if (progress <= 0.75) return [const Color.fromRGBO(190, 237, 179, 0.4), const Color.fromRGBO(134, 224, 217, 1), Colors.white];
    return [const Color.fromRGBO(255, 254, 177, 0.73), const Color.fromRGBO(162, 231, 198, 0.7),const Color.fromRGBO(134, 224, 217, 1),Colors.white];
  }

  Color _getBorderColor() {
    if (progress == 0.0) return Color.fromARGB(255, 122, 105, 127);
    if (progress <= 0.25) return Colors.purple[300]!;
    if (progress <= 0.5) return Colors.lightBlue[300]!;
    if (progress <= 0.75) return Colors.teal[300]!;
    return Colors.lightGreen[300]!;
  }

  String _getMoodText() {
    if (progress == 0.0) return "Tormenta";
    if (progress <= 0.25) return "Día nublado";
    if (progress <= 0.5) return "Olas calmadas";
    if (progress <= 0.75) return "Arcoíris";
    return "Sol radiante";
  }

  Color _getButtonColor() {
    if (progress == 0.0) return Color.fromRGBO(137, 111, 145, 1);
    if (progress <= 0.25) return  Color.fromRGBO(202, 163, 214, 1);
    if (progress <= 0.5) return  Color.fromRGBO(50, 151, 245, 1);
    if (progress <= 0.75) return Color.fromRGBO(190, 237, 179, 0.4);
    return Color.fromRGBO(255, 254, 177, 0.73);
  }
  Color _getanimatedColor() {
    if (progress == 0.0) return Color.fromARGB(255, 162, 0, 211);
    if (progress <= 0.25) return  Color.fromARGB(255, 185, 39, 230);
    if (progress <= 0.5) return  Color.fromRGBO(16, 132, 240, 1);
    if (progress <= 0.75) return Color.fromRGBO(58, 255, 14, 0.795);
    return Color.fromRGBO(247, 244, 66, 1);
  }
  List<double> _getanimated(){
    if (progress == 0.0) return [900,1100,7,25,100];
    if (progress <= 0.25) return [700,900,7,20,80];
    if (progress <= 0.5) return  [500,700,7,15,60];
    if (progress <= 0.75) return [300,500,7,10,80];
    return [100,300,7,8,100];
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    // El fondo del Scaffold será un contenedor con gradiente
    backgroundColor: Colors.transparent,
    body: Container(
      // Añadir un fondo de gradiente al contenedor
      decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [AppColors.morado,Color.fromRGBO(180, 145, 191, 1), Colors.white], // El gradiente va de morado a blanco
              radius: 1.1, // Controla el tamaño del área del gradiente
              center: Alignment.center, // El centro del gradiente será el centro del widget
            ),  
        ),
      child: Center(
        child: SlideTransition(
          position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: EstadoCard(
              gradientColors: _getGradientColors(),
              borderColor: _getBorderColor(),
              moodText: _getMoodText(),
              buttonColor: _getButtonColor(),
              animatedColor: _getanimatedColor(),
              animado: _getanimated(),
              progress: progress,
              onSliderChanged: (value) {
                setState(() {
                  progress = value;
                });
              },
            ),
          ),
        ),
      ),
    ),
  );
}

}
