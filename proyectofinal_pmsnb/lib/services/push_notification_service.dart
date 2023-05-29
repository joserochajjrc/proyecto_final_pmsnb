import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificacionesService {
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
      print('Message data: ${mensaje.data}');
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
