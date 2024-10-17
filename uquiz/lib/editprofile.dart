import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uquiz/controllers.dart';

class EditProfilePage extends StatefulWidget {
  final String name;
  final String email;

  const EditProfilePage({super.key, required this.name, required this.email});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final UQuizController uQuizController = Get.find<UQuizController>();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _emailController.text = widget.email;
  }

  Future<void> _saveProfile() async {
    try {
      final userId = uQuizController.pb.authStore.model.id;

      // เรียก API ของ PocketBase เพื่ออัปเดตข้อมูลผู้ใช้
      final response = await http.patch(
        Uri.parse('http://127.0.0.1:8090/api/collections/users/records/$userId'),
        headers: {
          'Authorization': 'Bearer ${uQuizController.pb.authStore.token}', // ใช้ Token จาก authStore
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "name": _nameController.text,
          "email": _emailController.text,
        }),
      );

      if (response.statusCode == 200) {
        print("Profile updated successfully");
        Get.back(); // กลับไปที่หน้า Profile หลังจากอัปเดตสำเร็จ
      } else {
        print("Failed to update profile: ${response.statusCode}");
        Get.snackbar("Error", "Failed to update profile");
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar("Error", "An error occurred while updating profile");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
