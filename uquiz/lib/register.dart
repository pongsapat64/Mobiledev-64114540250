import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';

class RegisterPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController(); // เพิ่มฟิลด์ยืนยันรหัสผ่าน
  final pb = PocketBase('http://127.0.0.1:8090'); // เปลี่ยน URL ตาม server ของคุณ

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(labelText: "Confirm Password"),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                if (passwordController.text != confirmPasswordController.text) {
                  Get.snackbar("Error", "Passwords do not match");
                  return;
                }
                try {
                  final body = <String, dynamic>{
                    'email': emailController.text,
                    'password': passwordController.text,
                    'passwordConfirm': confirmPasswordController.text, // ยืนยันรหัสผ่าน
                  };

                  // ส่งข้อมูลไปยัง PocketBase เพื่อสร้างผู้ใช้ใหม่
                  await pb.collection('users').create(body: body);

                  Get.snackbar("Success", "Registration complete");
                  Get.offNamed('/login'); // หลังจากสมัครสมาชิกเสร็จ กลับไปหน้า Login
                } catch (e) {
                  Get.snackbar("Error", "Registration failed: $e");
                }
              },
              child: const Text("Register"),
            ),

            // ปุ่มสำหรับกลับไปหน้า Login
            TextButton(
              onPressed: () {
                Get.offNamed('/login'); // นำทางกลับไปหน้า Login
              },
              child: const Text("Already have an account? Login here"),
            ),
          ],
        ),
      ),
    );
  }
}
