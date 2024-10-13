import 'package:flutter/material.dart';

class Graph_value extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ดูกราฟ',
        style: TextStyle(color: Colors.white), // เปลี่ยนสีข้อความเป็นสีขาว
        ),
        backgroundColor: const Color.fromARGB(255, 3, 153, 253),
      ),
      body: Center(
        child: Container(
          width: 370, // กำหนดความกว้างของกล่อง
          height: 300, // กำหนดความสูงของกล่อง
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'เลือกกราฟที่คุณต้องการ',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  ),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/graph_temperature');
                },
                child: Text(
                  'กราฟของอุณหภูมิ',
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

              // เพิ่มระยะห่างระหว่างปุ่ม
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/graph_moisture');
                },
                child: Text(
                  'กราฟของความชื้น',
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
            ],
          ),
        ),
      ),
    );
  }
}