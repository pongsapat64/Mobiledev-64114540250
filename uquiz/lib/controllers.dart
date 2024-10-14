import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:uquiz/members.dart';
import 'package:uquiz/shopping.dart';
import 'models.dart';

class UQuizController extends GetxController {
  var appName = 'uQuiz'.obs;
  var memberCount = 0.obs;
  var isAdmin = false.obs;
  var memberList = <Member>[].obs;
  final pb = PocketBase('http://127.0.0.1:8090');
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> authen(String email, String password) async {
    try {
      // ตรวจสอบการเข้าสู่ระบบสำหรับ Admin
      try {
        final adminRes = await pb.admins.authWithPassword(email, password);
        if (pb.authStore.isValid) {
          isAdmin.value = true;
          print('Admin logged in: $email');
          Get.to(() => const MemberListPage()); // ไปหน้า Admin
          return;
        }
      } catch (e) {
        print('Not an admin or failed admin login: $e');
      }

      // ถ้าไม่ใช่ admin ให้ตรวจสอบว่าเป็นผู้ใช้ทั่วไปหรือไม่
      final userRes =
          await pb.collection('users').authWithPassword(email, password);
      if (pb.authStore.isValid) {
        isAdmin.value = false;
        print('User logged in: $email');
        Get.to(() => const Shopping()); // ไปหน้า Shopping
      } else {
        Get.snackbar("Error", "Invalid email or password");
      }
    } catch (e) {
      Get.snackbar("Error", "Login failed: $e");
    }
  }
}
