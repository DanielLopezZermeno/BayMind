import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

// Inicialización del plugin de notificaciones
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// Función de inicialización para las notificaciones
Future<void> initNotifications() async {
  // Inicializa las zonas horarias necesarias para programar notificaciones exactas
  tz_data.initializeTimeZones();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('icono_notificacion'); // Reemplaza 'icono_notificacion' por tu ícono de notificación

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Inicializa las configuraciones del plugin
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

// Función para guardar las horas seleccionadas en preferencias compartidas
Future<void> guardarHorasSeleccionadas(
  DateTime timeRespirar,
  DateTime timePausa,
  DateTime timeReflexion,
  DateTime timeMeditar,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('timeRespirar', timeRespirar.toIso8601String());
  await prefs.setString('timePausa', timePausa.toIso8601String());
  await prefs.setString('timeReflexion', timeReflexion.toIso8601String());
  await prefs.setString('timeMeditar', timeMeditar.toIso8601String());
}

// Función para recuperar las horas guardadas y programar las notificaciones
Future<void> recuperarHorasYProgramarNotificaciones() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Recuperar las horas guardadas de las preferencias compartidas
  String? timeRespirarStr = prefs.getString('timeRespirar');
  String? timePausaStr = prefs.getString('timePausa');
  String? timeReflexionStr = prefs.getString('timeReflexion');
  String? timeMeditarStr = prefs.getString('timeMeditar');

  if (timeRespirarStr != null &&
      timePausaStr != null &&
      timeReflexionStr != null &&
      timeMeditarStr != null) {
    // Parsear las horas guardadas
    DateTime timeRespirar = DateTime.parse(timeRespirarStr);
    DateTime timePausa = DateTime.parse(timePausaStr);
    DateTime timeReflexion = DateTime.parse(timeReflexionStr);
    DateTime timeMeditar = DateTime.parse(timeMeditarStr);

    // Programar las notificaciones
    programarTodasLasNotificaciones(
      timeRespirar,
      timePausa,
      timeReflexion,
      timeMeditar,
    );
  }
}

// Función para mostrar una notificación simple
 Future<void> mostrarNotificacion() async {
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

  await flutterLocalNotificationsPlugin.show(
    0,
    'Registro creado',
    'Tu registro se agregó exitosamente',
    notificationDetails,
  );
}
Future<void> guardarNotificacion() async {
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

  await flutterLocalNotificationsPlugin.show(
    0,
    'Horario actualizado',
    'Tus horarios se actualizaron correctamente',
    notificationDetails,
  );
}

// Función para programar todas las notificaciones
void programarTodasLasNotificaciones(
  DateTime timeRespirar,
  DateTime timePausa,
  DateTime timeReflexion,
  DateTime timeMeditar,
) {
  programarNotificacionRespirar(timeRespirar);
  programarNotificacionPausa(timePausa);
  programarNotificacionReflexion(timeReflexion);
  programarNotificacionMeditar(timeMeditar);
}

// Funciones para programar notificaciones específicas
Future<void> programarNotificacionRespirar(DateTime time) async {
  final tz.TZDateTime tzTime = _convertToTZDateTime(time);
  await _programarNotificacion(
    'Momento de autocuidado',
    'Haz una pausa para respirar',
    tzTime,
    1,
  );
}

Future<void> programarNotificacionPausa(DateTime time) async {
  final tz.TZDateTime tzTime = _convertToTZDateTime(time);
  await _programarNotificacion(
    'Haz una pausa',
    'Recuerda detenerte un momento',
    tzTime,
    2,
  );
}

Future<void> programarNotificacionReflexion(DateTime time) async {
  final tz.TZDateTime tzTime = _convertToTZDateTime(time);
  await _programarNotificacion(
    'Reflexiona tu día',
    'Recuerda tus momentos positivos',
    tzTime,
    3,
  );
}

Future<void> programarNotificacionMeditar(DateTime time) async {
  final tz.TZDateTime tzTime = _convertToTZDateTime(time);
  await _programarNotificacion(
    'Momento de meditar',
    'Tómate un momento para meditar',
    tzTime,
    4,
  );
}

// Función auxiliar para programar notificaciones
Future<void> _programarNotificacion(
  String titulo,
  String mensaje,
  tz.TZDateTime tzTime,
  int id,
) async {
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

  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    titulo,
    mensaje,
    tzTime,
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}
// Función para obtener la zona horaria local automáticamente
tz.TZDateTime getLocalTimeZone() {
  final location = tz.local; // Esto obtiene la zona horaria local del dispositivo
  final now = tz.TZDateTime.now(location); // La hora actual en la zona horaria local
  return now;
}
// Función para convertir un DateTime a TZDateTime usando la zona horaria local
tz.TZDateTime _convertToTZDateTime(DateTime time) {
  final location = tz.local; // Zona horaria local del dispositivo
  final now = tz.TZDateTime.now(location); // La hora actual en la zona horaria local
  return tz.TZDateTime(location, now.year, now.month, now.day, time.hour, time.minute);
}
