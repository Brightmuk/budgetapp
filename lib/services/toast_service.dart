import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ToastServcie{

  static void showToast(String msg) {
    Toast.show(msg, duration: 2, gravity: Toast.bottom, backgroundColor: Colors.grey[900]!);
  }

}