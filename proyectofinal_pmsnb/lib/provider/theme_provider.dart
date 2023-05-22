import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settings/styles.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _currentTheme = ThemeData.light();
  ThemeData get currentTheme => _currentTheme;

  String getTheme() {
    String theme = "light";
    if (_currentTheme == ThemeData.light()) {
      theme = 'light';
    }
    if (_currentTheme == StylesApp.ecoTheme()) {
      theme = 'eco';
    }
    return theme;
  }

  ThemeProvider(String theme) {
    switch (theme) {
      case 'light':
        _currentTheme = ThemeData.light();
        break;
      case 'eco':
        _currentTheme = StylesApp.ecoTheme();
        break;
      default:
        _currentTheme = StylesApp.ecoTheme();
        break;
    }
  }

  void toggleTheme(theme) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    switch (theme) {
      case 'light':
        _currentTheme = ThemeData.light();
        sharedPreferences.setString('theme', 'light');
        break;
      case 'eco':
        _currentTheme = StylesApp.ecoTheme();
        sharedPreferences.setString('theme', 'eco');
        break;
      default:
        _currentTheme = StylesApp.lightTheme();
        sharedPreferences.setString('theme', 'light');
        break;
    }
    notifyListeners();
  }
}
