<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
include '../connection.php';

//POST = send/save data to mysql db
//GET = retrieve/read data from mysql db

$adminEmail = $_POST['admin_email'];
$adminPassword = $_POST['admin_password'];

$sqlQuery = "SELECT * FROM admins_table WHERE admin_email = '$adminEmail' AND admin_password = '$adminPassword'";

$resultOfQuery = $connectNow->query($sqlQuery);

if ($resultOfQuery->num_rows > 0) { //allow admin to login
    $adminRecord = array();
    while ($rowFound = $resultOfQuery->fetch_assoc()) {
        $adminRecord[] = $rowFound;
    }
    echo json_encode(
        array(
            "success" => true,
            "adminData" => $adminRecord[0],
        )
    );
} else { //do not allow admin to login
    echo json_encode(array("success" => false));
}