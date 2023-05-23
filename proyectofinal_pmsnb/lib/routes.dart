import 'package:flutter/material.dart';
import 'package:proyectofinal_pmsnb/screens/dashboard_screen.dart';
import 'package:proyectofinal_pmsnb/screens/login_screen.dart';
import 'package:proyectofinal_pmsnb/screens/password_screen.dart';
import 'package:proyectofinal_pmsnb/screens/post_screen.dart';
import 'package:proyectofinal_pmsnb/screens/register_screen.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/login': (BuildContext context) => LoginScreen(),
    '/dash': (BuildContext context) => DashboardScreen(),
    '/register': (BuildContext context) => RegisterScreen(),
    '/post': (BuildContext context) => PostScreen(),
    '/pwd': (BuildContext context) => passwordScreen()
  };
}
