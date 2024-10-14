import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';

class DeleteUserPage extends StatelessWidget {
  final pb = PocketBase('http://127.0.0.1:8090'); // URL ของ PocketBase
  final TextEditingController userIdController = TextEditingController();

  DeleteUserPage({super.key}); // Controller เก็บ User ID ที่ต้องการลบ

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete User"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: userIdController,
              decoration: const InputDecoration(
                labelText: "User ID to delete",
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // ตรวจสอบว่าเป็นแอดมินก่อนลบ
                  if (pb.authStore.model != null && pb.authStore.model!.email == 'admin@example.com') {
                    final userId = userIdController.text;

                    // ลบผู้ใช้จาก PocketBase ด้วย userId
                    await pb.collection('users').delete(userId);

                    Get.snackbar("Success", "User deleted successfully");
                  } else {
                    Get.snackbar("Error", "You are not authorized to delete users");
                  }
                } catch (e) {
                  Get.snackbar("Error", "Failed to delete user: $e");
                }
              },
              child: const Text("Delete User"),
            ),
          ],
        ),
      ),
    );
  }
}
