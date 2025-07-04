<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
include '../connection.php';

$order_id = $_POST["order_id"];

$sqlQuery = "SELECT * FROM cancel_table WHERE order_id = '$order_id'";

$resultOfQuery = $connectNow->query($sqlQuery);

if ($resultOfQuery->num_rows > 0) {
    $cancelRecord = array();
    while ($rowFound = $resultOfQuery->fetch_assoc()) {
        $cancelRecord[] = $rowFound;
    }

    echo json_encode(
        array(
            "success" => true,
            "cancelData" => $cancelRecord,
        )
    );
} else {
    echo json_encode(array("success" => false));
}