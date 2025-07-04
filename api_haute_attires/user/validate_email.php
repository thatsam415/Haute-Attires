<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
include '../db.php';

$userEmail = $_POST['user_email'];

$sqlQuery = "SELECT * FROM users_table WHERE user_email='$userEmail'";

$resultOfQuery = $connectNow->query($sqlQuery);

if ($resultOfQuery -> num_rows > 0) {
    //num rows length == 1 --- email already in someone else use --- Error
    echo json_encode(array("emailFound" => true));
} else {
    //num rows length == 0 --- email is NOT already in someone else use
    //A user will allowed to signUp Successfully
    echo json_encode(array("emailFound" => false));
}