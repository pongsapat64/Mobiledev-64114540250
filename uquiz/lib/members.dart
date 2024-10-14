import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:uquiz/create.dart';

class MemberListPage extends StatefulWidget {
  const MemberListPage({super.key});

  @override
  State<MemberListPage> createState() => _MemberListPageState();
}

class _MemberListPageState extends State<MemberListPage> {
  final pb = PocketBase('http://127.0.0.1:8090'); // PocketBase instance
  Future<List<dynamic>>? membersFuture; // ตัวแปรสำหรับเก็บผลลัพธ์ async

  @override
  void initState() {
    super.initState();
    loginAndFetchMembers(); // เรียกฟังก์ชันดึงข้อมูลเมื่อหน้าเริ่มต้น
  }

  // ฟังก์ชันล็อกอินและดึงข้อมูลสมาชิก
  Future<void> loginAndFetchMembers() async {
    final email = 'anna@ubu.ac.th';
    final password = 'anna@dssi';

    try {
      // ล็อกอินเป็น admin
      await pb.collection('users').authWithPassword(email, password);
      if (pb.authStore.isValid) {
        // ดึงรายการสมาชิก
        final result = await pb.collection('members').getList(
          page: 1,
          perPage: 20,
        );

        // อัปเดต state ด้วยข้อมูลที่ดึงมา
        setState(() {
          membersFuture =
              Future.value(result.items); // ดึงรายการสมาชิกจาก result
        });
      } else {
        print('Login failed.');
      }
    } catch (e) {
      print('Error logging in or fetching members: $e');
    }
  }

  // ฟังก์ชันลบสมาชิกโดยใช้ member.id
  Future<void> deleteMember(String memberId) async {
    try {
      await pb.collection('members').delete(memberId); // ลบสมาชิกจาก PocketBase

      // ดึงข้อมูลสมาชิกใหม่หลังจากลบ
      final result = await pb.collection('members').getList(
        page: 1,
        perPage: 20,
      );
      setState(() {
        membersFuture = Future.value(result.items); // อัปเดต membersFuture
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Member deleted successfully')),
      );
    } catch (e) {
      print('Error deleting member: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete member: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Member List')),
      body: FutureBuilder<List<dynamic>>(
        future: membersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // แสดง loading ระหว่างดึงข้อมูล
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // แสดงข้อผิดพลาด
          } else if (snapshot.hasData && snapshot.data != null) {
            final members = snapshot.data!;
            return ListView.separated(  // ใช้ ListView.separated เพื่อเพิ่ม Divider ระหว่างรายการ
              separatorBuilder: (context, index) => const Divider(
                color: Colors.grey, // สีของ Divider
                thickness: 1.0,     // ความหนาของ Divider
              ),
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                final memberId = member.id; // ดึง memberId เพื่อใช้ในการลบ
                final firstName = member.data['first'] ?? 'No First Name';
                final lastName = member.data['last'] ?? 'No Last Name';
                final email = member.data['email'] ?? 'No Email';

                return ListTile(
                  title: Text(
                    '$firstName $lastName',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(email),
                  tileColor: index % 2 == 0 ? Colors.grey[200] : Colors.white, // สลับสีพื้นหลังเพื่อให้มองง่ายขึ้น
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // แสดง dialog ยืนยันก่อนลบ
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                                'Are you sure you want to delete this member?'),
                            actions: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Delete'),
                                onPressed: () {
                                  deleteMember(memberId); // ลบสมาชิก
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No members found.'));
          }
        },
      ),
            floatingActionButton: FloatingActionButton(
        onPressed: () {
          // เมื่อกดปุ่ม จะนำไปสู่หน้าสร้างสมาชิก
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateMemberPage()),
          );
        },
        child: const Icon(Icons.add), // ไอคอนรูปเครื่องหมายบวก
        backgroundColor: Colors.blue, // สีพื้นหลังของปุ่ม
      ),
    );
  }
}
