import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uquiz/controllers.dart'; // controller ที่ใช้ในการจัดการ authen
import 'package:uquiz/register.dart';    // เพิ่มหน้า RegisterPage
import 'members.dart';                   // เพิ่มหน้า MemberListPage
import 'shopping.dart';                  // เพิ่มหน้า ShoppingPage

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
          children: [
            const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Login', style: TextStyle(fontSize: 40))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: ctrl.emailController,
                validator: (value) {
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
                    // Perform login logic here
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
                  Get.toNamed('/register'); // นำทางไปหน้า Register
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