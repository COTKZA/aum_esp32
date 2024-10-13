<?php
include 'config_api.php';

// รับข้อมูลจาก ESP32
$temp = $_GET['temp'];
$humidity = $_GET['humidity'];

// ตั้งค่าวันที่และเวลา
$date = date("Y-m-d");
$time = date("H:i:s");

// SQL สำหรับบันทึกข้อมูลลงในตาราง sensor_data
$sql = "INSERT INTO sensor_data (date, time, temp, humidity) VALUES ('$date', '$time', '$temp', '$humidity')";

if ($conn->query($sql) === TRUE) {
    echo "New record created successfully";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->close();
?>
