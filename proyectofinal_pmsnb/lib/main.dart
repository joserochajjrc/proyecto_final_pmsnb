import 'package:flutter/material.dart';
import 'package:proyectofinal_pmsnb/routes.dart';
import 'package:proyectofinal_pmsnb/screens/login_screen.dart';

void main() async{
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