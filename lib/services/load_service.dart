import 'package:budgetapp/constants/colors.dart';
import 'package:flutter/material.dart';

class LoadService {
  final BuildContext context;
  LoadService({required this.context});

  static const dataLoader = Center(child:CircularProgressIndicator(
    color: AppColors.themeColor,
  ));

  void showLoader() {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Container(
              
              width: 130,
              height: 70,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(10)),
              child: Scaffold(
                 backgroundColor: Colors.grey[900],
                body: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    CircularProgressIndicator(
                      color: AppColors.themeColor,
                    ),
                    Text(
                      'Loading...',
                      style: TextStyle(color: AppColors.themeColor, fontSize: 13),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void hideLoader() {
    Navigator.pop(context);
  }
}
