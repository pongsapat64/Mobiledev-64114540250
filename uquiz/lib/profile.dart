import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uquiz/controllers.dart';
import 'package:uquiz/editprofile.dart';
import 'package:uquiz/login.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String username = '';
  String email = '';
  String name = '';

  final UQuizController uQuizController = Get.find<UQuizController>();

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // ดึงข้อมูลจาก PocketBase เมื่อเริ่มต้น
  }

  Future<void> _fetchUserData() async {
    try {
      // ดึง userId จาก UQuizController หลังจากล็อกอินสำเร็จ
      final userId = uQuizController.pb.authStore.model.id;

      // เรียกใช้ PocketBase API เพื่อดึงข้อมูลของผู้ใช้
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8090/api/collections/users/records/$userId'),
        headers: {
          'Authorization': 'Bearer ${uQuizController.pb.authStore.token}', // ใช้ Token จาก authStore
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          username = data['username'] ?? "N/A";
          email = data['email'] ?? "N/A";
          name = data['name'] ?? "N/A";
        });
      } else {
        print("Failed to load user data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void _editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          name: name, // ส่งค่าตัวแปร name ที่มีอยู่แล้ว
          email: email, // ส่งค่าตัวแปร email ที่มีอยู่แล้ว
        ),
      ),
    );
  }

  void _logout() {
    // ลบ token และออกจากระบบ
    uQuizController.pb.authStore.clear();
    Get.offAll(() => const LoginPage()); // สมมติว่ามีหน้า LoginPage สำหรับกลับไปหน้าแรก
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Username: $username",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Email: $email",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Name: $name",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _editProfile,
                child: const Text("Edit Profile"),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // ปรับสีปุ่มให้ออกเป็นสีแดง
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text("Logout"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
