import 'package:baymind/frontend/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';

class EstadoCard extends StatefulWidget {
  final List<Color> gradientColors;
  final Color borderColor;
  final String moodText;
  final Color buttonColor;
  final Color animatedColor;
  final List<double> animado;
  final double progress;
  final ValueChanged<double> onSliderChanged;

  const EstadoCard({
    Key? key,
    required this.gradientColors,
    required this.borderColor,
    required this.moodText,
    required this.buttonColor,
    required this.animatedColor,
    required this.animado,
    required this.progress,
    required this.onSliderChanged,
  }) : super(key: key);

  @override
  _EstadoCardState createState() => _EstadoCardState();
}

class _EstadoCardState extends State<EstadoCard> with TickerProviderStateMixin {
  late AnimatedBackground controller;


  @override
  Widget build(BuildContext context) {
    final particleOptions = ParticleOptions(
     image: Image.network(''),
     baseColor: widget.animatedColor,
     spawnOpacity: 0.0,
     opacityChangeRate: 0.25,
     minOpacity: 0.9,
     maxOpacity: 1.0,
     spawnMinSpeed: widget.animado[0],
     spawnMaxSpeed: widget.animado[1],
     spawnMinRadius: widget.animado[2],
     spawnMaxRadius: widget.animado[3],
     particleCount: widget.animado[4].toInt(),
   );
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: widget.gradientColors,
          radius: 1.1,
          center: Alignment.center,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        border: Border.all(color: widget.borderColor, width: 2),
      ),
      child: Stack(
        children: [
          // Fondo animado de lluvia
          Positioned.fill(
            child: AnimatedBackground(
              behaviour:RandomParticleBehaviour(
                options: particleOptions
              ),
              vsync: this,
              child: Container(),
            ),
          ),
          // Contenido principal sobre el fondo animado
          Column(
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
                    child: Text(
                      "< Atrás",
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 3, 3, 3),
                        fontFamily: 'Manrope',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancelar",
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 7, 7, 7),
                        fontFamily: 'Manrope',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Center(
                child: Text(
                  "¿Cómo ha estado tu día?",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Manrope',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.30),
              Center(
                child: Text(
                  widget.moodText,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Manrope',
                  ),
                ),
              ),
              SizedBox(height: 20),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.grey[300],
                  inactiveTrackColor: Colors.grey[300],
                  thumbColor: Colors.white,
                  overlayColor: Colors.white.withOpacity(0.2),
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 24.0),
                ),
                child: Slider(
                  value: widget.progress,
                  onChanged: widget.onSliderChanged,
                  divisions: 4,
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text(
                    "Registrar",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'Manrope',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
