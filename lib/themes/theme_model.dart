import 'package:flutter/material.dart';
import 'package:reminder_app/themes/theme_shared_prefs.dart';

class ThemeModel extends ChangeNotifier {
  late bool _isDark;
  late ThemeSharedPreferences themeSharedPreferences;
  bool get isDark => _isDark;

  ThemeModel() {
    _isDark = false;
    themeSharedPreferences = ThemeSharedPreferences();
    getThemePreferences();
  }

  set isDark(bool value) {
    _isDark = value;
    themeSharedPreferences.setTheme(value);
    notifyListeners();
  }

  getThemePreferences() async {
    _isDark = await themeSharedPreferences.getTheme();
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
        primaryColor: Colors.black,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(headline6: TextStyle(color: Colors.black)),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.black, foregroundColor: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white));
  }

  static ThemeData get darkTheme {
    return ThemeData(
        primaryColor: Colors.white,
        backgroundColor: Colors.grey[900],
        scaffoldBackgroundColor: Colors.grey[800],
        textTheme: const TextTheme(headline6: TextStyle(color: Colors.white)),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.white, foregroundColor: Colors.black),
        iconTheme: const IconThemeData(color: Colors.white));
  }
}
