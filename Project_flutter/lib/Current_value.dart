import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // สำหรับแปลง JSON
import 'dart:async'; // เพิ่มการนำเข้าเพื่อใช้ Timer

class Current_value extends StatefulWidget {
  @override
  _CurrentValueState createState() => _CurrentValueState();
}

class _CurrentValueState extends State<Current_value> {
  double temperature = 0.0; // ตัวแปรสำหรับเก็บค่าอุณหภูมิ
  int humidity = 0; // ตัวแปรสำหรับเก็บค่าความชื้น
  bool isLoading = true; // สถานะการโหลดข้อมูล
  Timer? timer; // ตัวแปรสำหรับ Timer
  bool isTemperatureAlertShown = false; // สถานะแจ้งเตือนสำหรับ Temperature
  bool isHumidityAlertShown = false; // สถานะแจ้งเตือนสำหรับ Humidity

  @override
  void initState() {
    super.initState();
    fetchData(); // เรียกฟังก์ชันดึงข้อมูลเมื่อเริ่มต้น

    // เริ่ม Timer เพื่อดึงข้อมูลใหม่ทุก 3 วินาที
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => fetchData());
  }

  @override
  void dispose() {
    timer?.cancel(); // ยกเลิก Timer เมื่อ widget ถูกทำลาย
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('http://127.0.0.1/aum_esp32/api/v1/api_value.php'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body); // Convert JSON to Map

        // Assuming JSON structure is a List containing the latest values
        var latestData = data.last; // Get the latest entry

        setState(() {
          // Convert string values to appropriate types
          temperature = double.tryParse(latestData['temp'].toString()) ??
              0.0; // Convert to double
          humidity = int.tryParse(latestData['humidity'].toString()) ??
              0; // Convert to int
          isLoading = false; // Update loading status
        });

        _checkForAlerts(); // Check for alerts
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e'); // Log error to console
    }
  }

  void _checkForAlerts() {
    if (temperature > 50 && !isTemperatureAlertShown) {
      // ตั้งค่าเกณฑ์สำหรับ Temperature
      _showAlert('คำเตือน: ค่า Temperature เกิน 50 °C', 'Temperature');
      isTemperatureAlertShown = true; // ตั้งสถานะแจ้งเตือนเป็น true
    }

    if (humidity > 60 && !isHumidityAlertShown) {
      // ตั้งค่าเกณฑ์สำหรับ Humidity
      _showAlert('คำเตือน: ค่า Humidity เกิน 60%', 'Humidity');
      isHumidityAlertShown = true; // ตั้งสถานะแจ้งเตือนเป็น true
    }
  }

  void _showAlert(String message, String alertType) {
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
                Navigator.of(context).pop();
                setState(() {
                  if (alertType == 'Temperature') {
                    isTemperatureAlertShown =
                        false; // Reset แจ้งเตือน Temperature
                  } else if (alertType == 'Humidity') {
                    isHumidityAlertShown = false; // Reset แจ้งเตือน Humidity
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ดูค่าสถานะปัจจุบัน',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 153, 253),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator()) // แสดง Loader ขณะโหลดข้อมูล
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // กล่องที่หนึ่ง
                  Container(
                    width: 370,
                    height: 280,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 3, 153, 253),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: <Widget>[
                        // ข้อความ "อุณหภูมิ" ที่มุมบนซ้าย
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'อุณหภูมิ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                        // แสดงค่าจาก API
                        Center(
                          child: Text(
                            '${temperature.toStringAsFixed(1)} °C', // ใช้ค่า Temperature ที่ดึงมา
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 60,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // กล่องที่สอง
                  Container(
                    width: 370,
                    height: 280,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 3, 153, 253),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: <Widget>[
                        // ข้อความ "ความชื้น" ที่มุมบนซ้าย
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'ความชื้น',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                        // แสดงค่าจาก API
                        Center(
                          child: Text(
                            '${humidity.toStringAsFixed(1)} %', // ใช้ค่า Humidity ที่ดึงมา
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 60,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
