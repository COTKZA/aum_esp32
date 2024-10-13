<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *"); // อนุญาตให้ทุกโดเมนเข้าถึง
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");

include './../logn_config.php'; // Include your database connection file

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // ดึงข้อมูล JSON จากการร้องขอ
    $input = json_decode(file_get_contents('php://input'), true);
    
    // ตรวจสอบว่ามีข้อมูลอีเมลและรหัสผ่าน
    if (!isset($input['email']) || !isset($input['password'])) {
        echo json_encode(["status" => "error", "message" => "Email and password are required"]);
        exit();
    }

    $email = $input['email'];
    $password = $input['password'];

    // Prepare and execute the SQL statement
    if ($stmt = $conn->prepare("SELECT * FROM user WHERE email = ?")) {
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            $user = $result->fetch_assoc();
            // Verify the password (assuming you store hashed passwords)
            if (password_verify($password, $user['password'])) {
                echo json_encode(["status" => "success", "message" => "Login successful"]);
            } else {
                echo json_encode(["status" => "error", "message" => "Invalid password"]);
            }
        } else {
            echo json_encode(["status" => "error", "message" => "User not found"]);
        }

        $stmt->close();
    } else {
        echo json_encode(["status" => "error", "message" => "Database query error"]);
    }

    $conn->close();
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}
?>
