import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificacionesService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future initializeApp() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('Permisos del usuario: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage mensaje) {
      print('Tenemos un mensaje en la bandeja');
      print('Message title: ${mensaje.notification?.title}');
      print('Message body: ${mensaje.notification?.body}');
      notificationsPlugin.show(
          0,
          mensaje.notification?.title,
          mensaje.notification?.body,
          const NotificationDetails(
              android: AndroidNotificationDetails(
                'channelId',
                'channelName',
                importance: Importance.max,
              ),
              iOS: DarwinNotificationDetails()));
      if (mensaje.notification != null) {
        print(
            'Mensaje contiene tambien una notificacion: ${mensaje.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage mensaje) {
      print('Tenemos un mensaje en la bandeja');
      print('Message data: ${mensaje.data}');
      if (mensaje.notification != null) {
        print(
            'Mensaje contiene tambien una notificacion: ${mensaje.notification}');
      }
    });

    final token = await FirebaseMessaging.instance.getToken();
    print('Tu token: ${token}');
  }
}
