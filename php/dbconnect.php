<?php
$servername = "localhost";
$username   = "saujanae_techGoodsadmin";
$password   = "M{FkOE-n7hu9";
$dbname     = "saujanae_techGoods";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 
?>