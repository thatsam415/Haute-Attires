<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
include '../connection.php';

$itemID = $_POST['item_id'];
$itemName = $_POST['name'];
$itemRating = $_POST['rating']; 
$itemTags = $_POST['tags'];
$itemPrice = $_POST['price'];
$itemSizes = $_POST['sizes'];
$itemColors = $_POST['colors'];
$itemDescription = $_POST['description'];
$itemCategories = $_POST['categories']; // New field for categories
$itemOffer = $_POST['offer'];            // New field for offer in percent
$actualprice = $_POST['actualprice'];

$sqlQuery = "UPDATE items_table SET name='$itemName', rating='$itemRating', tags='$itemTags', price='$itemPrice', sizes='$itemSizes', colors='$itemColors', description='$itemDescription', categories='$itemCategories', offer='$itemOffer', actualprice='$actualprice' WHERE item_id='$itemID'";

$resultOfQuery = $connectNow->query($sqlQuery);

if($resultOfQuery)
{
    echo json_encode(array("success"=>true));
}
else
{
    echo json_encode(array("success"=>false));
}