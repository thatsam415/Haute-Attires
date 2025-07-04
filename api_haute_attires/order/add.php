<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
include '../connection.php';

// Read the raw POST data (assuming it's JSON)
$input = file_get_contents('php://input');
$data = json_decode($input, true);

// Check if the data was successfully decoded
if (!$data) {
    echo json_encode(array("success" => false, "message" => "Invalid JSON input"));
    exit();
}

// Extract variables from the decoded JSON data
$userID = $data["user_id"] ?? null;
$selectedItems = $data["selectedItems"] ?? null;
$deliverySystem = $data["deliverySystem"] ?? null;
$paymentSystem = $data["paymentSystem"] ?? null;
$note = $data["note"] ?? null;
$totalAmount = $data["totalAmount"] ?? null;
$status = $data["status"] ?? null;
$shipmentAddress = $data["shipmentAddress"] ?? null;
$phoneNumber = $data["phoneNumber"] ?? null;

// Validate required fields
if (!$userID || !$selectedItems || !$deliverySystem || !$paymentSystem || !$totalAmount || !$shipmentAddress || !$phoneNumber) {
    echo json_encode(array(
        "success" => false,
        "message" => "Missing required fields"
    ));
    exit();
}

// Insert the data into the database
$sqlQuery = "INSERT INTO order_table (user_id, selectedItems, deliverySystem, paymentSystem, note, totalAmount, status, shipmentAddress, phoneNumber) 
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
$stmt = $connectNow->prepare($sqlQuery);

if ($stmt) {
    $stmt->bind_param("issssdsss", $userID, $selectedItems, $deliverySystem, $paymentSystem, $note, $totalAmount, $status, $shipmentAddress, $phoneNumber);
    
    if ($stmt->execute()) {
        echo json_encode(array("success" => true));
    } else {
        echo json_encode(array("success" => false, "message" => "Query execution failed", "error" => $stmt->error));
    }
    
    $stmt->close();
} else {
    echo json_encode(array("success" => false, "message" => "Failed to prepare the SQL query"));
}

$connectNow->close();
