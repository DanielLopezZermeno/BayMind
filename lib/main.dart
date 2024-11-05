import 'package:baymind/frontend/pantallas/calendario_screen.dart';
import 'package:baymind/frontend/pantallas/avance_screen.dart';
import 'package:baymind/frontend/pantallas/perfil_screen.dart';
import 'package:baymind/frontend/pantallas/home_screen.dart';
import 'package:baymind/frontend/menu/navigation_bar.dart';
import 'package:baymind/frontend/pantallas/scroll_design.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BayMind',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,

      ),
      home: ScrollScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    CalendarioScreen(),
    SizedBox.shrink(), // Espacio reservado para el botón "BayMind"
    AvanceScreen(),
    PerfilScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}