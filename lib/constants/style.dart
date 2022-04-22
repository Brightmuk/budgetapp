import 'package:budgetapp/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyles {
  InputDecoration textFieldDecoration({String? label, String? hintText}) =>
      InputDecoration(
        label: Padding(
          padding:EdgeInsets.only(left: 8.0.sp),
          child: Text(
            label!,
            style: TextStyle(color: Colors.white,fontSize: 35.sp),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Color.fromRGBO(72, 191, 132, 1), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Color.fromRGBO(217, 4, 41, 1), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Color.fromRGBO(217, 4, 41, 1), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.themeColor, width: 1.5),
        ),
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 35.sp),
      );
}
