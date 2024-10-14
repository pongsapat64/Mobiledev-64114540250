import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class CreateMemberPage extends StatefulWidget {
  const CreateMemberPage({super.key});

  @override
  State<CreateMemberPage> createState() => _CreateMemberPageState();
}

class _CreateMemberPageState extends State<CreateMemberPage> {
  final pb = PocketBase('http://127.0.0.1:8090'); // PocketBase instance

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pictureController = TextEditingController();

  // ฟังก์ชันล็อกอินและสร้างสมาชิกใหม่
  Future<void> loginAndCreateMember() async {
    try {
      // ทำการล็อกอินเป็น Admin ก่อน
      final email = 'admin@ubu.ac.th'; // อีเมลของ Admin
      final password = 'admin@dssi'; // รหัสผ่านของ Admin

      await pb.admins.authWithPassword(email, password);

      if (pb.authStore.isValid) {
        // ล็อกอินสำเร็จ ให้ทำการสร้างสมาชิก
        await createMember();
      } else {
        print('Login failed');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed')),
        );
      }
    } catch (e) {
      print('Error logging in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login error: $e')),
      );
    }
  }

  // ฟังก์ชันสร้างสมาชิกใหม่
  Future<void> createMember() async {
    try {
      final body = <String, dynamic>{
        'username': usernameController.text.isEmpty ? null : usernameController.text,
        'first': firstNameController.text,
        'last': lastNameController.text,
        'email': emailController.text,
        'picture': pictureController.text.isEmpty ? null : pictureController.text,
      };

      print('Sending body: $body'); // ตรวจสอบข้อมูลที่ส่ง
      await pb.collection('members').create(body: body); // สร้างสมาชิกใหม่ใน PocketBase
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Member created successfully')),
      );
      Navigator.pop(context); // กลับไปยังหน้า MemberList หลังจากสร้างสำเร็จ
    } catch (e) {
      print('Error creating member: $e'); // ตรวจสอบข้อผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create member: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Member')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username (optional)'),
            ),
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: pictureController,
              decoration: const InputDecoration(labelText: 'Picture URL (optional)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loginAndCreateMember, // เรียกฟังก์ชันล็อกอินและสร้างสมาชิก
              child: const Text('Create Member'),
            ),
          ],
        ),
      ),
    );
  }
}
