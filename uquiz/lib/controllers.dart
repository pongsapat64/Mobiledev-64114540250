import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uquiz/login.dart';
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

  // ฟังก์ชันเก็บ token ใน SharedPreferences
  Future<void> saveLoginState(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  // ฟังก์ชันโหลด token จาก SharedPreferences
  Future<String?> loadLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  // ฟังก์ชันสำหรับการล็อกอิน
  Future<void> authen(String email, String password) async {
    try {
      // ตรวจสอบการเข้าสู่ระบบสำหรับ Admin
      try {
        final adminRes = await pb.admins.authWithPassword(email, password);
        if (pb.authStore.isValid) {
          isAdmin.value = true;
          await saveLoginState(pb.authStore.token); // เก็บ token
          print('Admin logged in: $email');
          Get.to(() => const MemberListPage()); // ไปหน้า Admin
          return;
        }
      } catch (e) {
        print('Not an admin or failed admin login: $e');
      }

      // ถ้าไม่ใช่ admin ให้ตรวจสอบว่าเป็นผู้ใช้ทั่วไปหรือไม่
      final userRes = await pb.collection('users').authWithPassword(email, password);
      if (pb.authStore.isValid) {
        isAdmin.value = false;
        await saveLoginState(pb.authStore.token); // เก็บ token
        print('User logged in: $email');
        Get.to(() => const Shopping()); // ไปหน้า Shopping
      } else {
        Get.snackbar("Error", "Invalid email or password");
      }
    } catch (e) {
      Get.snackbar("Error", "Login failed: $e");
    }
  }

  // ฟังก์ชันเช็คว่าผู้ใช้ยังล็อกอินอยู่หรือไม่
  Future<void> checkAuthStatus() async {
    final token = await loadLoginState();
    if (token != null) {
      final model = pb.authStore.model; // ดึง model ที่เก็บไว้
      if (model != null) {
        pb.authStore.save(token, model); // ส่ง token และ model ไปยังเมธอด save
        if (pb.authStore.isValid) {
          if (isAdmin.value) {
            Get.to(() => const MemberListPage());
          } else {
            Get.to(() => const Shopping());
          }
        }
      }
    }
  }


  // ฟังก์ชันสำหรับออกจากระบบ
  Future<void> logout() async {
    pb.authStore.clear(); // ลบข้อมูลการ authen ออกจาก PocketBase
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken'); // ลบ token ที่เก็บไว้
    Get.offAll(() => const LoginPage()); // กลับไปที่หน้า Login
  }
}
