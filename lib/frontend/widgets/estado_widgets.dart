// estado_widgets.dart
import 'package:flutter/material.dart';

class EstadoBarraProgreso extends StatelessWidget {
  final double percentage;
  final Color color;

  const EstadoBarraProgreso({required this.percentage, required this.color});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: percentage,
      backgroundColor: Colors.white,
      valueColor: AlwaysStoppedAnimation<Color>(color),
    );
  }
}
