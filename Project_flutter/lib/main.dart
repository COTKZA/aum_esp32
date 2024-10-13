import 'package:flutter/material.dart';
import 'home_screen.dart';  // Import หน้า Home เชื่อม
import 'Current_value.dart';  // Import หน้า Current_value มาเชื่อม
import 'record_of_values.dart'; // Import หน้า record_of_values เชื่อม
import 'Graph_value.dart'; // Import หน้า Graph_value เชื่อม
import 'Connect_devices.dart'; // Import หน้า Connect_devices เชื่อม
import 'LoginPage.dart'; // Import หน้า LoginPage เชื่อม
import 'graph_temperature.dart'; // Import หน้า graph_temperature เชื่อม
import 'graph_moisture.dart'; // Import หน้า graph_moisture เชื่อม

/*************  ✨ Codeium Command ⭐  *************/
/******  871cf1d2-2e4c-43f4-9199-460b43f17ac7  *******/ 
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),  // หน้า LoginPage เป็นหน้าแรก
        '/home_screen': (context) => HomeScreen(), // หน้า home_screen เป็นหน้าแยก
        '/Current_value': (context) => Current_value(), // หน้า Current_value เป็นหน้าแยก
        '/record_of_values': (context) => record_of_values(), // หน้า record_of_values เป็นหน้าแยก
        '/Graph_value': (context) => Graph_value(), // หน้า Graph_value เป็นหน้าแยก
        '/Connect_devices': (context) => Connect_devices(), // หน้า Connect_devices เป็นหน้าแยก
        '/graph_temperature': (context) => graph_temperature(), // หน้า graph_temperature เป็นหน้าแยก
        '/graph_moisture': (context) => graph_moisture(), // หน้า graph_moisture เป็นหน้าแยก
      },
    );
  }
}
