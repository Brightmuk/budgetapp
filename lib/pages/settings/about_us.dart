import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: EdgeInsets.zero,
      title: Container(
          decoration: const BoxDecoration(
            color: AppColors.themeColor,
            borderRadius:BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              )),
          height: 100.sp,
          
          child: const Center(
              child: Text('About Spenditize',
                  style: TextStyle(fontWeight: FontWeight.bold)))),
      content: const Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
            'Spenditize helps you plan your future spending and keeps your wishlist in one place. Tell us what you want to buy and when, and we’ll handle the reminders!'),
      ),
      actions: [
        MaterialButton(
          child: const Text('CLOSE',style: TextStyle(color: AppColors.themeColor),),
          onPressed: () {
          Navigator.pop(context);
        })
      ],
    );
  }
}
