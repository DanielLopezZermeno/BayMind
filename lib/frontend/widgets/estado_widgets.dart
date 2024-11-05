import 'package:flutter/material.dart';

class EstadoCard extends StatelessWidget {
  final List<Color> gradientColors;
  final Color borderColor;
  final String moodText;
  final Color buttonColor;
  final double progress;
  final ValueChanged<double> onSliderChanged;

  const EstadoCard({
    Key? key,
    required this.gradientColors,
    required this.borderColor,
    required this.moodText,
    required this.buttonColor,
    required this.progress,
    required this.onSliderChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: borderColor, width: 2), // Borde que cambia de color
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("< Atrás", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              TextButton(
                onPressed: () {},
                child: Text("Cancelar", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05), // Ajustar espacio
          Center(
            child: Text(
              "¿Cómo ha estado tu día?",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.20), // Ajustar espacio
          Center(
            child: Text(
              moodText,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          SizedBox(height: 20),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.grey[300],
              inactiveTrackColor: Colors.grey,
              thumbColor: Colors.white,
              overlayColor: Colors.white.withOpacity(0.2),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 24.0),
            ),
            child: Slider(
              value: progress,
              onChanged: onSliderChanged,
              divisions: 4,
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                "Continuar",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
