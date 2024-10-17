import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uquiz/controllers.dart'; // controller ที่ใช้ในการจัดการ authen
import 'package:uquiz/register.dart';    // เพิ่มหน้า RegisterPage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<UQuizController>(); // เข้าถึง Controller ของ GetX
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Login', style: TextStyle(fontSize: 40))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: ctrl.emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                obscureText: true,
                controller: ctrl.passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // เรียกใช้ฟังก์ชันล็อกอินจาก Controller
                    ctrl.authen(
                      ctrl.emailController.text,
                      ctrl.passwordController.text,
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ),
            
            // ปุ่มเพิ่มสำหรับนำไปหน้า Register
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  Get.to(() => RegisterPage()); // นำทางไปหน้า Register
                },
                child: const Text("Don't have an account? Register here"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
