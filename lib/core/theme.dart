import 'package:flutter/material.dart';

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
);

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF48BF84),
    brightness: Brightness.light,
  ),
);
