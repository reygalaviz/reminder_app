import 'package:flutter/material.dart';
import 'package:reminder_app/themes/theme_shared_prefs.dart';
import 'package:reminder_app/screens/settings.dart' as setting;

// Color.fromARGB(255, 193, 92, 92)

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

  static ThemeData get textTheme {
    return ThemeData(
      textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      ),
    );
  }

  static ThemeData get lightTheme {
    setting.col = Colors.white;
    return ThemeData(
      colorScheme: const ColorScheme.light(),
      primaryColor: Colors.black,
      backgroundColor: Colors.white,
      bottomNavigationBarTheme:
          const BottomNavigationBarThemeData(backgroundColor: Colors.white),
      appBarTheme: const AppBarTheme(
          color: Colors.white, iconTheme: IconThemeData(color: Colors.black)),
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(headline6: TextStyle(color: Colors.black)),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.black, foregroundColor: Colors.white),
    );
  }

  static ThemeData get darkTheme {
    setting.col = const Color.fromARGB(255, 48, 48, 48);
    return ThemeData(
      colorScheme: const ColorScheme.dark(),
      primaryColor: Colors.white,
      backgroundColor: Colors.grey[900],
      bottomNavigationBarTheme:
          const BottomNavigationBarThemeData(backgroundColor: Colors.black),
      appBarTheme: const AppBarTheme(
          color: Colors.black, iconTheme: IconThemeData(color: Colors.white)),
      scaffoldBackgroundColor: Colors.grey[900],
      textTheme: const TextTheme(headline6: TextStyle(color: Colors.white)),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.white, foregroundColor: Colors.black),
    );
  }
}
