<?php
error_reporting(0);
include_once ("dbconnect.php");
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$password = sha1($_POST['password']);

$sqlinsert = "INSERT INTO USER(NAME,EMAIL,PASSWORD,PHONE,CREDIT,VERIFY) VALUES ('$name','$email','$password','$phone','0','0')";

if ($conn->query($sqlinsert) === true) {
     
    echo "success";
    
    
} else {
    echo "failed";
}


?>