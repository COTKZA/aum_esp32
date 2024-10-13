<?php
$servername = "localhost"; // หรือชื่อเซิร์ฟเวอร์ของคุณ
$username = "root"; // ชื่อผู้ใช้ฐานข้อมูลของคุณ
$password = ""; // รหัสผ่านฐานข้อมูลของคุณ
$dbname = "flutter_temp"; // ชื่อฐานข้อมูลของคุณ

// สร้างการเชื่อมต่อ
$conn = new mysqli($servername, $username, $password, $dbname);

// ตรวจสอบการเชื่อมต่อ
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// กำหนด Charset
$conn->set_charset("utf8mb4");
?>
