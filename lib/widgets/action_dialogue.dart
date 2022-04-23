import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionDialogue extends StatelessWidget {
  final String infoText;
  final Function action;
  final String actionBtnText;

  const ActionDialogue(
      {Key? key,
      required this.infoText,
      required this.action,
      required this.actionBtnText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          Text(
            infoText,
                style: TextStyle(
                    fontSize: AppSizes.titleFont.sp,
                    fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              MaterialButton(
                minWidth: 130,
                 padding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
                color: AppColors.themeColor,
                onPressed: () {
                  Navigator.pop(context);
                  action();
                },
                child: Text(
                  actionBtnText,
                ),
              ),
              MaterialButton(
                 minWidth: 130,
                  padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)),
                color: Colors.grey[800],
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
