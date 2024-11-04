import 'package:baymind/frontend/pantallas/calendario_screen.dart';
import 'package:baymind/frontend/pantallas/cuestionario_screen.dart';
import 'package:baymind/frontend/pantallas/estado_screen.dart';
import 'package:baymind/frontend/pantallas/home_screen.dart';
import 'package:baymind/frontend/pantallas/scroll_design.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'estado_screen',
      routes: {
        'scroll_screen': ( _ ) => ScrollScreen(),
        'cuestionario_screen': ( _ ) => CuestionarioScreen(),
        'home_screen': ( _ ) => HomeScreen(),
        'calendario_screen': ( _ ) => CalendarioScreen(),
        'estado_screen': ( _ ) => EstadoScreen(),
      },
    );
  }
}

