<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
include '../connection.php';

$categories = $_POST['categories'];

if (empty($categories)) {
    echo json_encode(array("success" => false, "error" => "Categories parameter is missing."));
    exit;
}

$sqlQuery = "SELECT * FROM items_table WHERE categories LIKE '%$categories%'"; // Corrected typo

$resultOfQuery = $connectNow->query($sqlQuery);

if ($resultOfQuery === false) {
    echo json_encode(array(
        "success" => false,
        "error" => $connectNow->error // Output SQL error
    ));
    exit; // Stop further execution
}

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
