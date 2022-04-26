import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

class ToastService {
  final BuildContext context;
  ToastService({required this.context});

 void showSuccessToast(String msg) {
    MotionToast.success(
            title: Text('Success'),
            description: Text(msg),
            width: 300)
        .show(context);
  }

  static void showErrorToast(String msg) {}
}
