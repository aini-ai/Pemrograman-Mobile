import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _currentTheme;
  late SharedPreferences _prefs;
  bool _isDarkMode = false;

  ThemeProvider() {
    _currentTheme = lightTheme;
    _loadTheme();
  }

  // GETTERS
  ThemeData get currentTheme => _currentTheme;
  bool get isDarkMode => _isDarkMode;

  // THEMES
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.grey[50],
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    cardTheme: CardThemeData(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[800],
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    cardTheme: CardThemeData(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.grey[800],
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    dialogBackgroundColor: Colors.grey[800],
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.grey[700],
      contentTextStyle: const TextStyle(color: Colors.white),
    ),
  );

  // LOAD THEME DARI SHAREDPREFERENCES
  Future<void> _loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool('darkMode') ?? false;

    if (_isDarkMode) {
      _currentTheme = darkTheme;
    } else {
      _currentTheme = lightTheme;
    }

    notifyListeners();
  }

  // TOGGLE DARK MODE
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setBool('darkMode', _isDarkMode);

    if (_isDarkMode) {
      _currentTheme = darkTheme;
    } else {
      _currentTheme = lightTheme;
    }

    notifyListeners();
  }

  // SET DARK MODE
  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    await _prefs.setBool('darkMode', value);

    if (_isDarkMode) {
      _currentTheme = darkTheme;
    } else {
      _currentTheme = lightTheme;
    }

    notifyListeners();
  }
}
