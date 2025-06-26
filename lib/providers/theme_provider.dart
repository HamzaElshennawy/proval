import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}

// Improved light color scheme for better contrast and harmony
final lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Colors.teal, // Main accent color
  onPrimary: Colors.white,
  secondary: Colors.blueAccent, // Secondary accent
  onSecondary: Colors.white,
  error: Colors.red.shade700,
  onError: Colors.white,
  background: Color(0xFFEFF6F9), // Soft blue-gray background
  onBackground: Colors.black87,
  surface: Colors.white, // Cards and sheets
  onSurface: Colors.black87,
  surfaceVariant: Color(0xFFD9F3F0), // Very light teal for cards/containers
  outline: Colors.teal.shade100,
  inversePrimary: Colors.teal.shade100,
);

final darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Colors.teal[300]!, // Teal accent for dark mode
  onPrimary: Colors.black,
  secondary: Colors.blueAccent[100]!, // Soft blue accent
  onSecondary: Colors.black,
  error: Colors.red[400]!,
  onError: Colors.black,
  background: Color(0xFF151A1E), // Deep blue-gray background
  onBackground: Colors.white,
  surface: Color(0xFF23272B), // Slightly lighter for cards/sheets
  onSurface: Colors.white,
  surfaceVariant: Color(0xFF1B2227), // For containers/cards
  outline: Colors.teal[800]!,
  inversePrimary: Colors.teal[900]!,
);

final lightTheme = ThemeData(
  colorScheme: lightColorScheme,
  useMaterial3: true,
  scaffoldBackgroundColor: lightColorScheme.background,
  appBarTheme: AppBarTheme(
    backgroundColor: lightColorScheme.background,
    elevation: 0,
    iconTheme: IconThemeData(color: lightColorScheme.primary),
    titleTextStyle: TextStyle(
      color: lightColorScheme.primary,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    centerTitle: true,
  ),
  cardColor: lightColorScheme.surface,
  dialogBackgroundColor: lightColorScheme.surface,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black87),
    bodyMedium: TextStyle(color: Colors.black87),
    titleLarge: TextStyle(color: Colors.black87),
  ),
);

final darkTheme = ThemeData(
  colorScheme: darkColorScheme,
  useMaterial3: true,
  scaffoldBackgroundColor: darkColorScheme.background,
  appBarTheme: AppBarTheme(
    backgroundColor: darkColorScheme.background,
    elevation: 0,
    iconTheme: IconThemeData(color: darkColorScheme.primary),
    titleTextStyle: TextStyle(
      color: darkColorScheme.primary,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    centerTitle: true,
  ),
  cardColor: darkColorScheme.surface,
  dialogBackgroundColor: darkColorScheme.surface,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white),
  ),
);
