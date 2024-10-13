import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // Import dart:async for Timer

// หน้าที่บันทึกอุณหภูมิ
class record_of_values extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ค่าประวัตของเซนเซอร์',
          style: TextStyle(color: Colors.white), // เปลี่ยนสีข้อความเป็นสีขาว
        ),
        backgroundColor: const Color.fromARGB(255, 3, 153, 253),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // ย้อนกลับไปหน้าก่อน
          },
        ),
      ),
      body: MyHomePage(), // เรียกหน้า MyHomePage
    );
  }
}

// หน้าแสดงข้อมูล
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> data = [];
  Timer? timer;
  bool isError = false; // Track if there's an error
  bool isAlertShowing = false; // เพิ่มตัวแปรนี้เพื่อเก็บสถานะของการแจ้งเตือน

  // ฟังก์ชันสำหรับดึงข้อมูลจาก API
  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('http://127.0.0.1/aum_esp32/api/v1/api_value.php'));

      if (response.statusCode == 200) {
        List<dynamic> newData = json.decode(response.body);
        if (!listEquals(data, newData)) {
          if (mounted) {
            // ตรวจสอบว่า widget ยังคงถูก mount อยู่หรือไม่
            setState(() {
              data = newData.reversed
                  .take(10)
                  .toList(); // เรียงข้อมูลล่าสุดให้อยู่บนสุดและแสดงแค่ 10 ค่า
              isError =
                  false; // Reset error state if data is loaded successfully
            });
            _checkForAlerts(); // เรียกใช้ฟังก์ชันตรวจสอบค่าเกิน
          }
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      if (mounted) {
        // ตรวจสอบว่า widget ยังคงถูก mount อยู่หรือไม่
        setState(() {
          isError = true; // Mark error state
        });
      }
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data on app start
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      fetchData();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: isError
            ? Center(child: Text('Failed to load data. Please try again.'))
            : data.isEmpty
                ? Center(child: CircularProgressIndicator())
                : LayoutBuilder(builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DataTable(
                              columnSpacing: 20.0,
                              headingRowColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      const Color.fromARGB(255, 214, 208, 208)),
                              columns: [
                                DataColumn(
                                    label: Text('วันที่',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('เวลา',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('อุณหภูมิ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('ความชื้น',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                              ],
                              rows: data.map((item) {
                                return DataRow(cells: [
                                  DataCell(Text(item['date'] ?? '',
                                      style: TextStyle(fontSize: 16))),
                                  DataCell(Text(item['time'] ?? '',
                                      style: TextStyle(fontSize: 16))),
                                  DataCell(Text(item['temp'].toString(),
                                      style: TextStyle(fontSize: 16))),
                                  DataCell(Text(item['humidity'].toString(),
                                      style: TextStyle(fontSize: 16))),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
      ),
    );
  }

  // ฟังก์ชันช่วยเปรียบเทียบสองลิสต์
  bool listEquals(List a, List b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  // ฟังก์ชันแจ้งเตือนเมื่อค่าเกินกว่าที่กำหนด
  void _checkForAlerts() {
    if (isAlertShowing) return; // ตรวจสอบว่ามีการแจ้งเตือนอยู่หรือไม่

    // ตรวจสอบค่าในรายการล่าสุด
    if (data.isNotEmpty) {
      var latestItem = data.last; // Get the latest entry

      // ตรวจสอบค่าความชื้นเกิน 60%
      if (double.tryParse(latestItem['Humidity.'].toString()) != null &&
          double.parse(latestItem['Humidity.'].toString()) > 60) {
        _showAlert(
            'คำเตือน: ค่า Humidity เกิน 60 สำหรับวันที่: ${latestItem['Date.']} และเวลา: ${latestItem['Time.']}');
      }

      // ตรวจสอบค่าอุณหภูมิเกิน 30°C
      if (double.tryParse(latestItem['Temperature.'].toString()) != null &&
          double.parse(latestItem['Temperature.'].toString()) > 50) {
        _showAlert(
            'คำเตือน: ค่า Temperature เกิน 50°C สำหรับวันที่: ${latestItem['Date.']} และเวลา: ${latestItem['Time.']}');
      }
    }
  }

  // ฟังก์ชันแสดง Alert
  void _showAlert(String message) {
    isAlertShowing = true; // ตั้งค่าสถานะว่าการแจ้งเตือนกำลังแสดงอยู่
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                isAlertShowing = false; // รีเซ็ตสถานะเมื่อปิดการแจ้งเตือน
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
