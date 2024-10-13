import 'dart:async'; // สำหรับ Timer
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // สำหรับแปลงรูปแบบวันที่และเวลา
import 'package:http/http.dart' as http; // สำหรับการเรียก API
import 'dart:convert'; // สำหรับการแปลง JSON

class graph_temperature extends StatefulWidget {
  @override
  _GraphTemperatureState createState() => _GraphTemperatureState();
}

class _GraphTemperatureState extends State<graph_temperature> {
  List<FlSpot> spots = [];
  bool isAlertShowing = false; // Flag to prevent multiple alerts
  Timer? timer; // เพิ่มตัวจับเวลา

  @override
  void initState() {
    super.initState();
    fetchTemperatureData(); // เรียกข้อมูลเมื่อเริ่มต้น
    timer = Timer.periodic(Duration(seconds: 10),
        (Timer t) => fetchTemperatureData()); // อัปเดตข้อมูลทุก ๆ 10 วินาที
  }

  @override
  void dispose() {
    timer?.cancel(); // ยกเลิกการทำงานของ Timer เมื่อปิดหน้าจอ
    super.dispose();
  }

  Future<void> fetchTemperatureData() async {
    try {
      final response = await http
          .get(Uri.parse('http://127.0.0.1/aum_esp32/api/v1/api_value.php'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body); // แปลง JSON
        print(data);

        List<FlSpot> fetchedSpots = [];
        for (var entry in data) {
          try {
            String timeString = entry['time']; // ดึงเวลา
            String tempString = entry['temp']; // ดึงอุณหภูมิในรูปแบบสตริง

            // ตรวจสอบถ้าเป็นแค่เวลา (เช่น "15:53:05")
            if (timeString.contains(':')) {
              DateTime now = DateTime.now();
              String fullDateString =
                  '${DateFormat('yyyy-MM-dd').format(now)} $timeString'; // รวมวันที่และเวลา
              final DateTime time = DateTime.parse(fullDateString);

              // แปลงอุณหภูมิจากสตริงเป็น double
              final double temperature = double.parse(tempString);
              fetchedSpots.add(FlSpot(_convertTimeToX(time), temperature));

              // ตรวจสอบค่า temperature เกิน 50 หรือไม่
              if (temperature > 50 && !isAlertShowing) {
                _showAlert(
                    'คำเตือน: ค่า Temperature เกิน 50 สำหรับเวลา: $timeString');
              }
            }
          } catch (e) {
            print(
                'Error parsing date or temperature: ${entry['time']}'); // แสดงข้อความผิดพลาด
          }
        }

        setState(() {
          spots = fetchedSpots.reversed.take(30).toList(); // เก็บ 30 ค่าล่าสุด
        });
      } else {
        throw Exception('Failed to load temperature data');
      }
    } catch (e) {
      print(e); // แสดงข้อผิดพลาดใน console
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('กราฟแสดงค่าอุณหภูมิ'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // ไอคอนปุ่มย้อนกลับ
            onPressed: () {
              Navigator.pop(context); // ย้อนกลับไปยังหน้าก่อนหน้า
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: spots.isEmpty
              ? Center(
                  child:
                      CircularProgressIndicator()) // แสดง loading indicator หากไม่มีข้อมูล
              : LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        colors: [Colors.blue], // สีหลักของกราฟ
                        barWidth: 4, // ความกว้างของเส้นกราฟ
                        belowBarData: BarAreaData(
                          show: true, // เพิ่มพื้นที่ด้านล่างเส้น
                          colors: [
                            Colors.blue.withOpacity(0.2)
                          ], // ใส่สีแบบโปร่งแสงใต้เส้นกราฟ
                        ),
                        dotData: FlDotData(show: true),
                        isStrokeCapRound: true, // ปรับเส้นโค้งให้มีขอบมน
                      ),
                    ],
                    titlesData: FlTitlesData(
                      leftTitles: SideTitles(
                        showTitles: true,
                        margin: 10,
                        interval: 20, // ให้ตัวเลขแสดงในทุกๆ 20 หน่วย
                      ),
                      bottomTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        rotateAngle: 45, // หมุนข้อความแกน X 45 องศา
                        getTitles: (value) {
                          return _formatXToTime(value); // แปลงค่า X ให้เป็นเวลา
                        },
                        margin: 8, // ระยะห่างจากแกน X
                      ),
                    ),
                    gridData: FlGridData(
                      show: true, // แสดงเส้นกริด
                      drawHorizontalLine: true,
                      drawVerticalLine: true,
                      horizontalInterval: 20, // ระยะห่างของเส้นกริดแนวนอน
                      verticalInterval:
                          3600000, // ระยะห่างของเส้นกริดแนวตั้ง (1 ชั่วโมง)
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey
                              .withOpacity(0.2), // สีของเส้นกริดแนวนอน
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Colors.grey
                              .withOpacity(0.2), // สีของเส้นกริดแนวนตั้ง
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(
                      show: true, // แสดงเส้นกรอบ
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.4), // สีของเส้นกรอบ
                        width: 1,
                      ),
                    ),
                    minX: spots.isNotEmpty
                        ? spots.map((e) => e.x).reduce((a, b) => a < b ? a : b)
                        : 0,
                    maxX: spots.isNotEmpty
                        ? spots.map((e) => e.x).reduce((a, b) => a > b ? a : b)
                        : 1,
                    minY: 0, // ค่าต่ำสุดของแกน Y
                    maxY: 100, // ค่าสูงสุดของแกน Y
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.blue.withOpacity(0.8),
                        getTooltipItems: (List<LineBarSpot> touchedSpots) {
                          return touchedSpots.map((spot) {
                            final DateTime date =
                                DateTime.fromMillisecondsSinceEpoch(
                                    spot.x.toInt());
                            return LineTooltipItem(
                              '${DateFormat.Hm().format(date)}\n${spot.y.toStringAsFixed(1)}',
                              const TextStyle(color: Colors.white),
                            );
                          }).toList();
                        },
                      ),
                      handleBuiltInTouches: true,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  // ฟังก์ชันสำหรับแปลง DateTime เป็นค่าบนแกน X
  double _convertTimeToX(DateTime time) {
    return time.millisecondsSinceEpoch.toDouble(); // แปลงเวลาเป็น millisecond
  }

  // ฟังก์ชันสำหรับแปลงค่า X ให้เป็นรูปแบบเวลา
  String _formatXToTime(double value) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    return DateFormat.Hm().format(date); // แปลงเวลาให้เป็นรูปแบบ "HH:mm"
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
