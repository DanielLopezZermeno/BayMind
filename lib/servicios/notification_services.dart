import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Inicialización de las notificaciones para Android
Future<void> initNotificactions() async {
  tz_data.initializeTimeZones();  // Inicializa las zonas horarias

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('icono_notificacion'); 

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

// Función para programar notificación en una zona horaria específica
Future<void> programarNotificacion(DateTime time) async {
 final location = tz.getLocation('America/Mexico_City');
  final tzTime = tz.TZDateTime.from(time, location);  // Convierte la hora a TZDateTime

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
    tzTime,  // Hora programada con zona horaria
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, 
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime, 
    matchDateTimeComponents: DateTimeComponents.time, 
  );
}

// Función para programar una notificación diaria (11:00 AM)
Future<void> programarNotificacionRespirar() async {
  final location = tz.getLocation('America/Argentina/Buenos_Aires'); // Cambia la zona horaria si es necesario
  final now = tz.TZDateTime.now(location);
  final scheduledTime = tz.TZDateTime(location, now.year, now.month, now.day, 11, 0); // 11:00 AM

  if (scheduledTime.isBefore(now)) {
    scheduledTime.add(Duration(days: 1)); // Si ya pasó la hora de hoy, agenda para el día siguiente
  }

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
    scheduledTime,
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, 
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime, 
    matchDateTimeComponents: DateTimeComponents.time, 
  );
}

// Función para programar una notificación diaria (3:00 PM)
Future<void> programarNotificacionPausa() async {
  final location = tz.getLocation('America/Argentina/Buenos_Aires'); // Cambia la zona horaria si es necesario
  final now = tz.TZDateTime.now(location);
  final scheduledTime = tz.TZDateTime(location, now.year, now.month, now.day, 15, 0); // 3:00 PM

  if (scheduledTime.isBefore(now)) {
    scheduledTime.add(Duration(days: 1)); // Si ya pasó la hora de hoy, agenda para el día siguiente
  }

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
    scheduledTime,
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, 
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime, 
    matchDateTimeComponents: DateTimeComponents.time, 
  );
}

// Función para programar una notificación diaria (6:00 PM)
Future<void> programarNotificacionReflexion() async {
  final location = tz.getLocation('America/Argentina/Buenos_Aires'); // Cambia la zona horaria si es necesario
  final now = tz.TZDateTime.now(location);
  final scheduledTime = tz.TZDateTime(location, now.year, now.month, now.day, 18, 0); // 6:00 PM

  if (scheduledTime.isBefore(now)) {
    scheduledTime.add(Duration(days: 1)); // Si ya pasó la hora de hoy, agenda para el día siguiente
  }

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
    scheduledTime,
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, 
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime, 
    matchDateTimeComponents: DateTimeComponents.time, 
  );
}

// Función para programar una notificación diaria (7:00 PM)
Future<void> programarNotificacionMeditar() async {
  final location = tz.getLocation('America/Argentina/Buenos_Aires'); // Cambia la zona horaria si es necesario
  final now = tz.TZDateTime.now(location);
  final scheduledTime = tz.TZDateTime(location, now.year, now.month, now.day, 19, 0); // 7:00 PM

  if (scheduledTime.isBefore(now)) {
    scheduledTime.add(Duration(days: 1)); // Si ya pasó la hora de hoy, agenda para el día siguiente
  }

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
    scheduledTime,
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, 
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime, 
    matchDateTimeComponents: DateTimeComponents.time, 
  );
}

// Llamar las funciones para programar todas las notificaciones
void programarTodasLasNotificaciones() {
  programarNotificacion(DateTime(2024, 11, 17, 9, 0, 0)); // 9:00 AM
  programarNotificacionRespirar();
  programarNotificacionPausa();
  programarNotificacionReflexion();
  programarNotificacionMeditar();
}
