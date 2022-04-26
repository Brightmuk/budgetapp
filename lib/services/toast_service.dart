import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class ToastService {
  final BuildContext context;
  ToastService({required this.context});

 void showSuccessToast(String msg) {
  toast(msg);
  }

}
