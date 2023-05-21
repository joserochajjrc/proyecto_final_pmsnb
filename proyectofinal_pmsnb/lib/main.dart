import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:proyectofinal_pmsnb/routes.dart';
import 'package:proyectofinal_pmsnb/screens/login_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(proyectoFinal());
}

class proyectoFinal extends StatelessWidget {
  proyectoFinal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: getApplicationRoutes(),
      home: LoginScreen(),
    );
  }
}
