<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");

require './../config_api.php'; // ไฟล์การเชื่อมต่อฐานข้อมูล

$request_method = $_SERVER["REQUEST_METHOD"];

switch ($request_method) {
    case 'GET':
        // Handle GET request
        if (isset($_GET['id'])) {
            // ดึงค่าจาก id เดียว
            $id = intval($_GET['id']);
            $stmt = $conn->prepare("SELECT * FROM sensor_data WHERE id = :id");
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);
            $stmt->execute();
            $sensor_data = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if ($sensor_data) {
                echo json_encode($sensor_data);
            } else {
                echo json_encode(['message' => 'No data found for this ID']);
            }
        } else {
            // ดึงค่าทั้งหมดจากตาราง sensor_data
            $stmt = $conn->query("SELECT * FROM sensor_data");
            $sensor_data = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            if ($sensor_data) {
                echo json_encode($sensor_data);
            } else {
                echo json_encode(['message' => 'No data found']);
            }
        }
        break;

    default:
        // กรณีมี request method ที่ไม่ใช่ GET
        http_response_code(405);
        echo json_encode(['message' => 'Method not allowed']);
        break;
}
?>
