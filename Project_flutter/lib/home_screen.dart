import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 370, // กำหนดความกว้างของกล่อง
          height: 500, // กำหนดความสูงของกล่อง
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 3, 153, 253), // สีพื้นหลัง
            borderRadius: BorderRadius.circular(20), // มุมโค้งมน
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // เงาของกล่อง
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // เงาอยู่ด้านล่าง
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'เลือกฟังก์ชันที่คุณต้องการ',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white, // เปลี่ยนสีข้อความเป็นสีขาว
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/Current_value');
                  },
                  child: Text(
                    'ดูค่าสถานะปัจจุบัน',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.blue,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // ปุ่มโค้งมน
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/record_of_values');
                  },
                  child: Text(
                    'ดูค่าประวัติ',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.blue,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // ปุ่มโค้งมน
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/Graph_value');
                  },
                  child: Text(
                    'ดูค่ากราฟ',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.blue,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // ปุ่มโค้งมน
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 65, vertical: 15),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/Connect_devices');
                  },
                  child: Text(
                    'อุปกรณ์ตัวอื่น',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.blue,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // ปุ่มโค้งมน
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, '/');
                  },
                  child: Text(
                    'ออกจากระบบ',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.blue,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // ปุ่มโค้งมน
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
