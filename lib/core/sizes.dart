import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSizes {
  final BuildContext? context;
  AppSizes({this.context});

  double get screenHeight => MediaQuery.of(context!).size.height;
  double get screenWidth => MediaQuery.of(context!).size.width;

  static double maxToolBarHeight = 680.sp;
  static const double midToolBarHeight = 140.0;
  static  double minToolBarHeight = 280.sp;
  static const pagePading = 20.0;

  static const iconSize = 50.0;
  static const normalFontSize = 30.0;
  static const titleFont = 35.0;
}
