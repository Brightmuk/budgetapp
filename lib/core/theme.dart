import 'package:flutter/material.dart';

FilledButtonThemeData fButtonStyle = FilledButtonThemeData(
  style: FilledButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
);
OutlinedButtonThemeData oButtonStyle = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF48BF84), // Your brand green
    brightness: Brightness.dark,
    primary: const Color(0xFF48BF84),
    surface: const Color(0xFF1A1C1A),
  ),
  // Global component overrides
  appBarTheme: const AppBarTheme(
    centerTitle: false,
    elevation: 0,
    backgroundColor: Colors.transparent,
  ),
  cardTheme: CardThemeData(
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  filledButtonTheme: fButtonStyle,
  outlinedButtonTheme: oButtonStyle,
);

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF48BF84),
    brightness: Brightness.light,
  ),
  filledButtonTheme: fButtonStyle,
  outlinedButtonTheme: oButtonStyle,
);
