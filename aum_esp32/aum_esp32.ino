#include <WiFi.h>
#include <HTTPClient.h>
#include <DHT.h>

// ข้อมูล WiFi
const char* ssid = "cotkza";
const char* password = "12345678";

// URL ของ PHP API สำหรับบันทึกข้อมูล
const char* serverName = "http://127.0.0.1/aum_esp32/api/insert_sensor_data.php";

// กำหนดพินของ DHT22
#define DHTPIN 4 // กำหนดพินที่เชื่อมต่อ       DHT22
#define DHTTYPE DHT22

DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(115200);
  
  // เชื่อมต่อ WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");

  dht.begin(); // เริ่มต้น DHT22
}

void loop() {
  // อ่านค่าอุณหภูมิและความชื้นจาก DHT22
  float temp = dht.readTemperature();
  float humidity = dht.readHumidity();

  // ตรวจสอบว่าการอ่านค่าถูกต้องหรือไม่
  if (isnan(temp) || isnan(humidity)) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }

  // ส่งข้อมูลไปยังเซิร์ฟเวอร์
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;

    // สร้าง URL พร้อมข้อมูลที่ต้องการส่ง
    String serverPath = serverName + String("?temp=") + String(temp) + "&humidity=" + String(humidity);

    http.begin(serverPath.c_str());
    int httpResponseCode = http.GET();

    if (httpResponseCode > 0) {
      String response = http.getString();
      Serial.println(httpResponseCode);
      Serial.println(response);
    }
    else {
      Serial.print("Error on sending request: ");
      Serial.println(httpResponseCode);
    }

    http.end();
  }

  // หน่วงเวลา 1 วินาทีก่อนอ่านค่าใหม่
  delay(1000);
}
