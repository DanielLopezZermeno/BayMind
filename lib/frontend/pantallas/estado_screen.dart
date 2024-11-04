import 'package:flutter/material.dart';
import 'package:baymind/frontend/widgets/estado_widgets.dart';

class EstadoScreen extends StatefulWidget {
  @override
  _EstadoScreenState createState() => _EstadoScreenState();
}

class _EstadoScreenState extends State<EstadoScreen> {
  double progress = 0.0; // Progreso inicial

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    String moodText;
    Color buttonColor;

    // Determinar el color de fondo, el texto del estado y el color del botón según el progreso
    if (progress == 0.0) {
      backgroundColor = Colors.grey[800]!;
      moodText = "Tormenta";
      buttonColor = Colors.grey[700]!;
    } else if (progress <= 0.25) {
      backgroundColor = Colors.purple;
      moodText = "Día nublado";
      buttonColor = Colors.purple[200]!;
    } else if (progress <= 0.5) {
      backgroundColor = Colors.lightBlue;
      moodText = "Olas calmadas";
      buttonColor = Colors.lightBlue[200]!;
    } else if (progress <= 0.75) {
      backgroundColor = Colors.teal;
      moodText = "Arcoíris";
      buttonColor = Colors.teal[200]!;
    } else {
      backgroundColor = Colors.lightGreen;
      moodText = "Sol radiante";
      buttonColor = Colors.lightGreen[200]!;
    }

    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(milliseconds: 300), // Duración de la animación
        color: backgroundColor,
        padding: const EdgeInsets.all(30.0),
        curve: Curves.easeInOut, // Tipo de curva de la animación
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Acción para el botón "Atrás"
                  },
                  child: Text("< Atrás", style: TextStyle(fontSize: 24)),
                ),
                TextButton(
                  onPressed: () {
                    // Acción para el botón "Cancelar"
                  },
                  child: Text("Cancelar", style: TextStyle(fontSize: 24)),
                ),
              ],
            ),
            SizedBox(height: 40),
            Text(
              "¿Cómo ha estado tu día?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 250),
            Text(
              moodText,
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.grey, // Color de la barra activa
                inactiveTrackColor: Colors.grey[300], // Color de la barra inactiva
                thumbColor: Colors.white, // Color de la bolita
                overlayColor: Colors.white.withOpacity(0.2), // Color de la sobreposición al tocar
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12), // Tamaño de la bolita
              ),
              child: Slider(
                value: progress,
                onChanged: (value) {
                  setState(() {
                    progress = value;
                  });
                },
                divisions: 4,
                label: (progress * 100).round().toString() + '%',
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Acción para el botón "Continuar"
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                ),
                child: Text("Continuar", style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
