import 'package:flutter/material.dart';
import 'package:baymind/frontend/widgets/estado_widgets.dart';

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
      duration: Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Color> _getGradientColors() {
    if (progress == 0.0) return [Colors.grey.withOpacity(0.8), Colors.grey.withOpacity(0.2)];
    if (progress <= 0.25) return [Colors.purple.withOpacity(0.8), Colors.purple.withOpacity(0.2)];
    if (progress <= 0.5) return [Colors.lightBlue.withOpacity(0.8), Colors.blueAccent.withOpacity(0.2)];
    if (progress <= 0.75) return [Colors.teal.withOpacity(0.8), Colors.greenAccent.withOpacity(0.2)];
    return [Colors.lightGreen.withOpacity(0.8), Colors.limeAccent.withOpacity(0.2)];
  }

  Color _getBorderColor() {
    if (progress == 0.0) return Colors.grey[700]!;
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
    if (progress == 0.0) return Colors.grey[700]!;
    if (progress <= 0.25) return Colors.purple[500]!;
    if (progress <= 0.5) return Colors.lightBlue[500]!;
    if (progress <= 0.75) return Colors.teal[500]!;
    return Colors.lightGreen[500]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SlideTransition(
          position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: EstadoCard(
              gradientColors: _getGradientColors(),
              borderColor: _getBorderColor(),
              moodText: _getMoodText(),
              buttonColor: _getButtonColor(),
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
    );
  }
}
