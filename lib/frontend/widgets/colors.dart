import 'package:flutter/material.dart';

class AppColors {
  // Colores predeterminados
  static const Color morado = Color.fromARGB(255, 202, 163, 214); // Un color morado
  static const Color azul = Color.fromARGB(255, 50, 151, 245); // Un color verde agua
}
class AppGradients {
  // Degradado morado a azul
  static const LinearGradient purpleBlueGradient = LinearGradient(
    colors: [Color.fromARGB(255, 202, 163, 214), Color.fromARGB(255, 50, 151, 245)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}