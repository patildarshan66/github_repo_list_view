import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackBar(String msg, {String actionTex = ''}) {
  ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar();
  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    duration: const Duration(seconds: 2),
    content: Text(msg),
    action: actionTex == ''
        ? null
        : SnackBarAction(
            label: actionTex, textColor: Colors.green, onPressed: () {}),
  ));
}
