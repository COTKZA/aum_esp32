import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // สำหรับ jsonDecode

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';

  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage =
            'กรุณากรอกอีเมลและรหัสผ่าน'; // Please enter email and password
      });
      return;
    }

    // URL ของสคริปต์ PHP ของคุณ
    final url =
        'http://127.0.0.1/aum_esp32/api/v1/login.php'; // เปลี่ยนเป็น IP สำหรับ Android Emulator

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: {
          'Content-Type':
              'application/json', // ตั้งค่า Content-Type เป็น application/json
        },
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result['status'] == 'success') {
          // เปลี่ยนเป็น 'status' ตามที่คุณกำหนดใน PHP
          setState(() {
            _errorMessage = ''; // Reset error message
          });
          Navigator.pushNamed(
              context, '/home_screen'); // เปลี่ยนเส้นทางหลังล็อกอินสำเร็จ
        } else {
          setState(() {
            _errorMessage = result['message']; // ข้อความผิดพลาดจาก PHP
          });
        }
      } else {
        setState(() {
          _errorMessage =
              'เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์'; // ข้อผิดพลาดในการเชื่อมต่อ
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'เกิดข้อผิดพลาด: $e'; // ข้อผิดพลาด
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ล็อกอิน'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: FlutterLogo(
                size: 100,
              ),
            ),
            SizedBox(height: 40),
            // ช่องกรอกอีเมล
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'อีเมล',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20),
            // ช่องกรอกรหัสผ่าน
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'รหัสผ่าน',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text(
                'เข้าสู่ระบบ',
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
