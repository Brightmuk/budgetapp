import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.themeColor,
      body: Container(
          height: AppSizes(context: context).screenHeight,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(72, 191, 132, 1),
              Color.fromRGBO(50, 84, 67, 1),
            ],
          ))),
    );
  }
}
