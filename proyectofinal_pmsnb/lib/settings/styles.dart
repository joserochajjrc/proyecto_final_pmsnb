import 'package:flutter/material.dart';

class StylesApp {
  static ThemeData lightTheme() {
    return ThemeData.light();
  }

  static ThemeData ecoTheme() {
    return ThemeData.from(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(255, 68, 219, 68),
          onPrimary: Colors.white,
          secondary: Color(0xff8b4513),
          onSecondary: Colors.white,
          error: Color(0xffb00020),
          onError: Colors.white,
          background: Colors.white,
          onBackground: Colors.black,
          surface: Color(0xffe6d8ad),
          onSurface: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Coolvetica'),
          bodyMedium: TextStyle(fontFamily: 'Coolvetica'),
          bodySmall: TextStyle(fontFamily: 'Coolvetica'),
          displayLarge: TextStyle(fontFamily: 'Coolvetica'),
          displayMedium: TextStyle(fontFamily: 'Coolvetica'),
          displaySmall: TextStyle(fontFamily: 'Coolvetica'),
          labelLarge: TextStyle(fontFamily: 'Coolvetica'),
          labelMedium: TextStyle(fontFamily: 'Coolvetica'),
          labelSmall: TextStyle(fontFamily: 'Coolvetica'),
          titleLarge: TextStyle(fontFamily: 'Coolvetica'),
          titleMedium: TextStyle(fontFamily: 'Coolvetica'),
          titleSmall: TextStyle(fontFamily: 'Coolvetica'),
        ));
  }
}
