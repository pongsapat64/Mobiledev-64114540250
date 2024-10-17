import 'package:flutter/material.dart';
import 'package:uquiz/controllers.dart';
import 'package:get/get.dart';
import 'app.dart';

void main() {
  print('Hello, world');
  final controller = Get.put(UQuizController());
  controller.checkAuthStatus();
  runApp(const UQuizApp());
}
