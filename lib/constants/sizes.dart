import 'package:flutter/material.dart';

class AppSizes {
  final BuildContext? context;
  AppSizes({this.context});

  double get screenHeight => MediaQuery.of(context!).size.height;
  double screenWidth() => MediaQuery.of(context!).size.width;

  static const double maxToolBarHeight = 300.0;
  static const double midToolBarHeight = 140.0;
  static const double minToolBarHeight = 120.0;
  static const pagePading = 30;

  static const iconSize = 50.0;
  static const normalFontSize = 30.0;
  static const titleFont = 35.0;
}
