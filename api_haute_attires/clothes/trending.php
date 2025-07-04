<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
include '../connection.php';

$minRating = 4.4;
$limitClothItems = 10;

$sqlQuery = "SELECT * FROM items_table WHERE rating>= '$minRating' ORDER BY rating DESC LIMIT $limitClothItems";
//10 or less than 10 newly available top rated clothes item
//not greater than 10

$resultOfQuery = $connectNow->query($sqlQuery);

if ($resultOfQuery->num_rows > 0) {
    $clothItemsRecord = array();
    while ($rowFound = $resultOfQuery->fetch_assoc()) {
        $clothItemsRecord[] = $rowFound;
    }
    echo json_encode(
        array(
            "success" => true,
            "clothItemsData" => $clothItemsRecord,
        )
    );
} else {
    echo json_encode(array("success" => false));
}