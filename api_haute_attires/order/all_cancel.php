<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
include '../connection.php';

$sqlQuery = "SELECT * FROM order_table WHERE status = 'cancel' ORDER BY dateTime DESC";

$resultOfQuery = $connectNow->query($sqlQuery);

if ($resultOfQuery->num_rows > 0) {
    $ordersRecord = array();
    while ($rowFound = $resultOfQuery->fetch_assoc()) {
        $ordersRecord[] = $rowFound;
    }

    echo json_encode(
        array(
            "success" => true,
            "allCancel" => $ordersRecord,
        )
    );
} else {
    echo json_encode(array("success" => false));
}


