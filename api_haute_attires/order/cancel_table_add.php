<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
include '../connection.php';

$order_id = $_POST['order_id'];
$cancel_by = $_POST['cancel_by'];
$reason = $_POST['reason'];

$sqlQuery = "INSERT INTO cancel_table (order_id, cancel_by, reason) VALUES ('$order_id', '$cancel_by', '$reason')";

$resultOfQuery = $connectNow->query($sqlQuery);

if ($resultOfQuery) {
    echo json_encode(array("success" => true));
} else {
    echo json_encode(array("success" => false));
}