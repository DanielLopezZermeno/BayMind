// ignore_for_file: unnecessary_string_interpolations

import 'package:baymind/frontend/pantallas/scroll_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:baymind/servicios/notification_services.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  DateTime dateTime = DateTime.now(); // Sumar un día a la fecha actual
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _notificationsEnabled = false;
  TimeOfDay _selectedTimeRespirar = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _selectedTimePausa = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay _selectedTimeReflexion = const TimeOfDay(hour: 18, minute: 0);
  TimeOfDay _selectedTimeMeditar = const TimeOfDay(hour: 21, minute: 0);

  @override
  void initState() {
    super.initState();
    initNotifications(); // Inicializar notificaciones
    _loadSettings(); // Cargar configuraciones al iniciar
    tz_data.initializeTimeZones();
    final tz.TZDateTime scheduledAt = tz.TZDateTime.from(dateTime, tz.local);
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    flutterLocalNotificationsPlugin.zonedSchedule(
        1, "title", "body", scheduledAt, notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }

  // Cargar configuraciones guardadas (desde SharedPreferences)
  void _loadSettings() async {
    // Realizar la carga de datos asincrónicamente primero
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
    TimeOfDay selectedTimeRespirar = await _loadTime('respirar');
    TimeOfDay selectedTimePausa = await _loadTime('pausa');
    TimeOfDay selectedTimeReflexion = await _loadTime('reflexion');
    TimeOfDay selectedTimeMeditar = await _loadTime('meditar');

    // Ahora actualizamos el estado de forma síncrona
    setState(() {
      _notificationsEnabled = notificationsEnabled;
      _selectedTimeRespirar = selectedTimeRespirar;
      _selectedTimePausa = selectedTimePausa;
      _selectedTimeReflexion = selectedTimeReflexion;
      _selectedTimeMeditar = selectedTimeMeditar;
    });

    // Si las notificaciones están habilitadas, actualizamos las horas
    if (_notificationsEnabled) {
      _updateNotificationTimes();
    }
  }

  // Cargar hora desde SharedPreferences
  Future<TimeOfDay> _loadTime(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? hour = prefs.getInt('$key.hour');
    int? minute = prefs.getInt('$key.minute');

    if (hour != null && minute != null) {
      return TimeOfDay(hour: hour, minute: minute);
    }

    // Si no hay hora guardada, devolver un valor predeterminado
    return const TimeOfDay(hour: 9, minute: 0); // Hora predeterminada
  }

  // Guardar configuraciones en SharedPreferences
  void _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notificationsEnabled', _notificationsEnabled);
    prefs.setInt('respirar.hour', _selectedTimeRespirar.hour);
    prefs.setInt('respirar.minute', _selectedTimeRespirar.minute);
    prefs.setInt('pausa.hour', _selectedTimePausa.hour);
    prefs.setInt('pausa.minute', _selectedTimePausa.minute);
    prefs.setInt('reflexion.hour', _selectedTimeReflexion.hour);
    prefs.setInt('reflexion.minute', _selectedTimeReflexion.minute);
    prefs.setInt('meditar.hour', _selectedTimeMeditar.hour);
    prefs.setInt('meditar.minute', _selectedTimeMeditar.minute);
    _updateNotificationTimes();
  }

  // Actualizar las notificaciones con las horas seleccionadas
  void _updateNotificationTimes() {
    if (_notificationsEnabled) {
      DateTime timeRespirar = _convertToDateTime(_selectedTimeRespirar);
      DateTime timePausa = _convertToDateTime(_selectedTimePausa);
      DateTime timeReflexion = _convertToDateTime(_selectedTimeReflexion);
      DateTime timeMeditar = _convertToDateTime(_selectedTimeMeditar);
      DateTime newDT = DateTime(dateTime.year, dateTime.month, dateTime.day,
          _selectedTimeRespirar.hour, _selectedTimeRespirar.minute);
      // Programar las notificaciones

      dateTime = newDT;
      programarNotificacionRespirar(timeRespirar);
      programarNotificacionPausa(timePausa);
      programarNotificacionReflexion(timeReflexion);
      programarNotificacionMeditar(timeMeditar);
    }
  }

  // Convertir TimeOfDay a DateTime
  DateTime _convertToDateTime(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    return DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  }

  // Función para mostrar el selector de hora
  Future<void> _selectTime(
      BuildContext context, String tipo, TimeOfDay initialTime) async {
    TimeOfDay newTime = await showTimePicker(
          context: context,
          initialTime: initialTime,
        ) ??
        initialTime;

    setState(() {
      if (tipo == 'Respirar') {
        _selectedTimeRespirar = newTime;
      } else if (tipo == 'Pausa') {
        _selectedTimePausa = newTime;
      } else if (tipo == 'Reflexion') {
        _selectedTimeReflexion = newTime;
      } else if (tipo == 'Meditar') {
        _selectedTimeMeditar = newTime;
      }
    });
  }

  // Método para cerrar sesión (simulación)
  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cerrar Sesión"),
        content: const Text("¿Estás seguro de que deseas cerrar sesión?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ScrollScreen()),
              );
            },
            child: const Text("Salir"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Activar Notificaciones'),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                _saveSettings();
              },
            ),
            ListTile(
              title: const Text('Hora de Respirar'),
              subtitle: Text('${_selectedTimeRespirar.format(context)}'),
              trailing: const Icon(Icons.access_time),
              onTap: () =>
                  _selectTime(context, 'Respirar', _selectedTimeRespirar),
            ),
            ListTile(
              title: const Text('Hora de Pausa'),
              subtitle: Text('${_selectedTimePausa.format(context)}'),
              trailing: const Icon(Icons.access_time),
              onTap: () => _selectTime(context, 'Pausa', _selectedTimePausa),
            ),
            ListTile(
              title: const Text('Hora de Reflexión'),
              subtitle: Text('${_selectedTimeReflexion.format(context)}'),
              trailing: const Icon(Icons.access_time),
              onTap: () =>
                  _selectTime(context, 'Reflexion', _selectedTimeReflexion),
            ),
            ListTile(
              title: const Text('Hora de Meditar'),
              subtitle: Text('${_selectedTimeMeditar.format(context)}'),
              trailing: const Icon(Icons.access_time),
              onTap: () =>
                  _selectTime(context, 'Meditar', _selectedTimeMeditar),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveSettings;
                guardarNotificacion();
              },
              child: const Text('Guardar Configuración'),
            ),
            const SizedBox(height: 20),

            // Botón de Cerrar Sesión
            Center(
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  "Cerrar Sesión",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Manrope',
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
