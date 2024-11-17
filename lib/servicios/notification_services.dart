import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

// Inicialización de las notificaciones
Future<void> initNotificactions() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('icono_notificacion');  // Asegúrate de tener un icono para la notificación.

  const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

// Mostrar notificación de registro creado
Future<void> mostrarNotificacion() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    'yout_channel_id', 
    'your_channel_name', 
    importance: Importance.max, 
    priority: Priority.high
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    1, 
    'Registro creado', 
    'Tu registro se agregó exitosamente', 
    notificationDetails
  );
}

// Notificación para recordar respirar profundamente
Future<void> mostrarNotificacionRespirar() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    'yout_channel_id', 
    'your_channel_name', 
    importance: Importance.max, 
    priority: Priority.high
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    2,  // Un ID diferente para esta notificación
    'Momento de autocuidado', 
    'Tomarte un momento para respirar profundamente es un acto de autocuidado. ¡Hazlo ahora! 🌬️💆‍♀️',
    notificationDetails
  );
}

// Notificación para recordar hacer una pausa
Future<void> mostrarNotificacionPausa() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    'yout_channel_id', 
    'your_channel_name', 
    importance: Importance.max, 
    priority: Priority.high
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    3,  // Un ID diferente para esta nueva notificación
    'Haz una pausa', 
    'A veces el mejor cuidado es simplemente detenerte y respirar. 🌸💆‍♂️',
    notificationDetails
  );
}

// Notificación para detenerse y explorar lo que estás sintiendo
Future<void> mostrarNotificacionSentir() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    'yout_channel_id', 
    'your_channel_name', 
    importance: Importance.max, 
    priority: Priority.high
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    4,  // Un ID único para esta nueva notificación
    'Detén tu día', 
    'Detén tu día por un momento. ¿Qué estás sintiendo ahora mismo? Tómate un minuto para explorar. 🧠💭',
    notificationDetails
  );
}

// Notificación para reflexionar juntos sobre el bienestar
Future<void> mostrarNotificacionReflexion() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    'yout_channel_id', 
    'your_channel_name', 
    importance: Importance.max, 
    priority: Priority.high
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    5,  // Un ID único para esta nueva notificación
    'Hoy, reflexionemos juntos', 
    'Hoy, reflexionemos juntos. 🌸 ¿Qué te hace sentir bien en este momento? Puedo ayudarte a encontrar maneras de nutrir esa sensación.',
    notificationDetails
  );
}

// Nueva notificación para meditar y reducir el estrés
Future<void> mostrarNotificacionMeditar() async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    'yout_channel_id', 
    'your_channel_name', 
    importance: Importance.max, 
    priority: Priority.high
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    6,  // Un ID único para esta nueva notificación
    'Reduce el estrés con meditación', 
    '¿Sabías que meditar solo 5 minutos puede ayudarte a reducir el estrés? 🧘‍♀️ Si te interesa, puedo guiarte en una breve sesión.',
    notificationDetails
  );
}
