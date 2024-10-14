import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uquiz/controllers.dart';
import 'package:uquiz/login.dart';
import 'package:uquiz/register.dart'; // นำเข้า RegisterPage

class UQuizBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UQuizController());
  }
}

class UQuizApp extends StatefulWidget {
  const UQuizApp({super.key});

  @override
  State<UQuizApp> createState() => _UQuizAppState();
}

class _UQuizAppState extends State<UQuizApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'UQuiz App',
      initialBinding: UQuizBindings(),
      initialRoute: '/login', // หน้าแรกเป็นหน้า login
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()), // หน้า LoginPage
        GetPage(name: '/register', page: () => RegisterPage()), // หน้า RegisterPage
      ],
    );
  }
}
