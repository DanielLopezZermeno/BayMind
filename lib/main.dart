import 'package:baymind/frontend/pantallas/Baymind.dart';
import 'package:baymind/frontend/pantallas/calendario_screen.dart';
import 'package:baymind/frontend/pantallas/avance_screen.dart';
import 'package:baymind/frontend/pantallas/perfil_screen.dart';
import 'package:baymind/frontend/pantallas/home_screen.dart';
import 'package:baymind/frontend/menu/navigation_bar.dart';
import 'package:baymind/frontend/pantallas/scroll_design.dart';
import 'package:baymind/servicios/notification_services.dart';
import 'package:flutter/material.dart';
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Esto elimina la etiqueta DEBUG
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
class NavigationController {
  static Function(int)? changeTab;

  static void updateTab(int index) {
    if (changeTab != null) {
      changeTab!(index);
    }
  }
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    CalendarioScreen(),
    BaymindScreen(),
    AvanceScreen(),
    PerfilScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
@override
  void initState() {
    super.initState();
    // Asigna la función de cambio de índice al controlador
    NavigationController.changeTab = (int index) {
      setState(() {
        _currentIndex = index;
      });
    };
  }

  @override
  void dispose() {
    // Limpia el callback para evitar fugas de memoria
    NavigationController.changeTab = null;
    super.dispose();
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

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await initNotificactions();
  runApp(MyApp());
}