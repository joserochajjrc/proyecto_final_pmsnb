import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectofinal_pmsnb/provider/theme_provider.dart';
import 'package:proyectofinal_pmsnb/routes.dart';
import 'package:proyectofinal_pmsnb/screens/dashboard_screen.dart';
import 'package:proyectofinal_pmsnb/screens/onBoarding_screen.dart';
import 'package:proyectofinal_pmsnb/services/push_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final theme = sharedPreferences.getString('theme') ?? 'light';
  await Firebase.initializeApp();
  //await FirebaseHelper.setupFirebase();
  //await NotificationService.initializeNotification();
  await Firebase.initializeApp();
  await NotificacionesService().initializeApp();

/*
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  flutterLocalNotificationsPlugin.initialize(initializationSettings);
*/
  runApp(proyectoFinal(theme: theme));
}

class proyectoFinal extends StatelessWidget {
  final String theme;
  const proyectoFinal({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider(theme)),
      ],
      child: ChangeNotifierProvider(
        create: (context) => ThemeProvider(theme),
        builder: (context, snapshot) {
          return const ProyectoApp();
        },
      ),
    );
  }
}

class ProyectoApp extends StatelessWidget {
  const ProyectoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: settings.currentTheme,
      routes: getApplicationRoutes(),
      home: FirebaseAuth.instance.currentUser == null
          ? onBoardingScreen()
          : DashboardScreen(),
    );
  }
}
