import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';



// class Connect_devices extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<Connect_devices> {
//   List<String> ipList = []; // รายการ IP ที่เก็บไว้
//   String currentIp = ""; // เก็บ IP ที่ป้อนล่าสุด
//   String statusMessage = "Press the button to connect"; // ข้อความสถานะ

//   void addIp() {
//     if (currentIp.isNotEmpty) {
//       setState(() {
//         ipList.add(currentIp);
//         currentIp = ""; // รีเซ็ตค่า IP หลังจากเพิ่มไปในรายการแล้ว
//       });
//     }
//   }

//   void removeIp(int index) {
//     setState(() {
//       ipList.removeAt(index); // ลบ IP ออกจากรายการ
//     });
//   }

//   void fetchData(String ip) async {
//     var url = Uri.parse('http://$ip'); // สร้าง URL จาก IP ที่เลือก
//     try {
//       var response = await http.get(url);

//       if (response.statusCode == 200) {
//         setState(() {
//           statusMessage = "คุณเชื่อม ip $ip สำเร็จแล้ว";
//         });
//       } else {
//         setState(() {
//           statusMessage = "Failed to connect to $ip: ${response.statusCode}";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         statusMessage = "Error: Could not connect to $ip \n Details: $e";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("ESP32 Connection"),
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.pop(context); // กลับไปยังหน้าก่อนหน้า
//             },
//           ),
//         ),
//         body: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextField(
//                   decoration: InputDecoration(
//                     labelText: "Enter IP Address",
//                     border: OutlineInputBorder(),
//                   ),
//                   onChanged: (value) {
//                     currentIp = value;
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: addIp,
//                   child: Text("Add IP"),
//                 ),
//                 SizedBox(height: 20),
//                 Text(statusMessage),
//                 SizedBox(height: 20),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: ipList.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(ipList[index]),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             ElevatedButton(
//                               onPressed: () => fetchData(ipList[index]),
//                               child: Text("Connect"),
//                             ),
//                             SizedBox(width: 10),
//                             IconButton(
//                               icon: Icon(Icons.delete),
//                               onPressed: () => removeIp(index), // ลบ IP
//                               color: Colors.red,
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }









class Connect_devices extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Connect_devices> {
  List<String> ipList = []; // รายการ IP ที่เก็บไว้
  String currentIp = ""; // เก็บ IP ที่ป้อนล่าสุด
  String statusMessage = "Press the button to connect"; // ข้อความสถานะ

  @override
  void initState() {
    super.initState();
    loadIpList(); // โหลดรายการ IP เมื่อเริ่มต้นแอป
  }

  // ฟังก์ชันสำหรับบันทึก IP ลงใน SharedPreferences
  Future<void> saveIpList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('ipList', ipList);
  }

  // ฟังก์ชันสำหรับโหลดรายการ IP จาก SharedPreferences
  Future<void> loadIpList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      ipList = prefs.getStringList('ipList') ?? [];
    });
  }

  void addIp() {
    if (currentIp.isNotEmpty) {
      setState(() {
        ipList.add(currentIp);
        currentIp = ""; // รีเซ็ตค่า IP หลังจากเพิ่มไปในรายการแล้ว
      });
      saveIpList(); // บันทึกข้อมูลหลังจากเพิ่ม IP
    }
  }

  void removeIp(int index) {
    setState(() {
      ipList.removeAt(index); // ลบ IP ออกจากรายการ
    });
    saveIpList(); // บันทึกข้อมูลหลังจากลบ IP
  }

  void fetchData(String ip) async {
    var url = Uri.parse('http://$ip'); // สร้าง URL จาก IP ที่เลือก
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          statusMessage = "คุณเชื่อม ip $ip สำเร็จแล้ว";
        });
      } else {
        setState(() {
          statusMessage = "Failed to connect to $ip: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        statusMessage = "Error: Could not connect to $ip \n Details: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("ESP32 Connection"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // กลับไปยังหน้าก่อนหน้า
            },
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "Enter IP Address",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    currentIp = value;
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: addIp,
                  child: Text("Add IP"),
                ),
                SizedBox(height: 20),
                Text(statusMessage),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: ipList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(ipList[index]),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () => fetchData(ipList[index]),
                              child: Text("Connect"),
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => removeIp(index), // ลบ IP
                              color: Colors.red,
                            ),
                          ],
                        ),
                      );
                    },
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
