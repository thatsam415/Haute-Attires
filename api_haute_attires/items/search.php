<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
include '../connection.php';

$typedKeyWords = $_POST['typedKeyWords'];

$sqlQuery = "SELECT * FROM items_table WHERE name LIKE '%$typedKeyWords%'";

$resultOfQuery = $connectNow->query($sqlQuery);

if ($resultOfQuery->num_rows > 0) {
    $foundItemsRecord = array();
    while ($rowFound = $resultOfQuery->fetch_assoc()) {
        $foundItemsRecord[] = $rowFound;
    }

    echo json_encode(
        array(
            "success" => true,
            "itemsFoundData" => $foundItemsRecord,
        )
    );
} else {
    echo json_encode(array("success" => false));
}
