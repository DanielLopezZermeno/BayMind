import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Inicialización de las notificaciones para Android
Future<void> initNotificactions() async {
  tz_data.initializeTimeZones();  // Inicializa las zonas horarias

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('icono_notificacion'); // Asegúrate de tener el icono

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

// Función para mostrar una notificación simple
Future<void> mostrarNotificacion() async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'yout_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    1, // ID único
    'Registro creado',
    'Tu registro se agregó exitosamente',
    notificationDetails,
  );
}

// Función para programar notificación en una zona horaria específica
Future<void> programarNotificacion(DateTime time) async {
  final location = tz.getLocation('America/Mexico_City');
  final tzTime = tz.TZDateTime.from(time, location); // Convierte la hora a TZDateTime

  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'yout_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    1, // ID único para la notificación
    'Registro creado',
    'Tu registro se agregó exitosamente',
    tzTime, // Hora programada con zona horaria
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

// Función para programar una notificación diaria a las 11:00 AM (o la hora seleccionada)
Future<void> programarNotificacionRespirar(DateTime time) async {
  final location = tz.getLocation('America/Argentina/Buenos_Aires');
  final tzTime = tz.TZDateTime.from(time, location); // Convertir DateTime a TZDateTime

  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'yout_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    2, // ID único
    'Momento de autocuidado',
    'Tomarte un momento para respirar profundamente es un acto de autocuidado. ¡Hazlo ahora! 🌬️💆‍♀️',
    tzTime, // Hora programada con zona horaria
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

// Función para programar una notificación diaria a las 3:00 PM (o la hora seleccionada)
Future<void> programarNotificacionPausa(DateTime time) async {
  final location = tz.getLocation('America/Argentina/Buenos_Aires');
  final tzTime = tz.TZDateTime.from(time, location); // Convertir DateTime a TZDateTime

  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'yout_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    3, // ID único
    'Haz una pausa',
    'A veces el mejor cuidado es simplemente detenerte y respirar. 🌸💆‍♂️',
    tzTime, // Hora programada con zona horaria
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

// Función para programar una notificación diaria a las 6:00 PM (o la hora seleccionada)
Future<void> programarNotificacionReflexion(DateTime time) async {
  final location = tz.getLocation('America/Mexico_City');
  final tzTime = tz.TZDateTime.from(time, location); // Convertir DateTime a TZDateTime

  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'yout_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    5, // ID único
    'Hoy, reflexionemos juntos',
    'Hoy, reflexionemos juntos. 🌸 ¿Qué te hace sentir bien en este momento? Puedo ayudarte a encontrar maneras de nutrir esa sensación.',
    tzTime, // Hora programada con zona horaria
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

// Función para programar una notificación diaria a las 7:00 PM (o la hora seleccionada)
Future<void> programarNotificacionMeditar(DateTime time) async {
  final location = tz.getLocation('America/Argentina/Buenos_Aires');
  final tzTime = tz.TZDateTime.from(time, location); // Convertir DateTime a TZDateTime

  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'yout_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    6, // ID único
    'Reduce el estrés con meditación',
    '¿Sabías que meditar solo 5 minutos puede ayudarte a reducir el estrés? 🧘‍♀️ Si te interesa, puedo guiarte en una breve sesión.',
    tzTime, // Hora programada con zona horaria
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}


// Llamar las funciones para programar todas las notificaciones con las horas seleccionadas
void programarTodasLasNotificaciones(DateTime timeRespirar, DateTime timePausa, DateTime timeReflexion, DateTime timeMeditar) {
  programarNotificacion(DateTime(2024, 11, 17, 9, 0, 0)); // 9:00 AM
  programarNotificacionRespirar(timeRespirar);  
  programarNotificacionPausa(timePausa);      
  programarNotificacionReflexion(timeReflexion);  
  programarNotificacionMeditar(timeMeditar);  
}