<?php
error_reporting(0);
include_once ("dbconnect.php");
$category = $_POST['category'];
$name = $_POST['name'];

if (isset($category)){
    if ($category == "Recent"){
        $sql = "SELECT * FROM PRODUCT ORDER BY DATE DESC lIMIT 20";    
    }else{
        $sql = "SELECT * FROM PRODUCT WHERE CATEGORY = '$category'";    
    }
}else{
    $sql = "SELECT * FROM PRODUCT ORDER BY DATE DESC lIMIT 20";    
}
if (isset($name)){
   $sql = "SELECT * FROM PRODUCT WHERE NAME LIKE  '%$name%'";
}


$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["products"] = array();
    while ($row = $result->fetch_assoc())
    {
        $productlist = array();
        $productlist["id"] = $row["ID"];
        $productlist["name"] = $row["NAME"];
        $productlist["brand"] = $row["BRAND"];
        $productlist["model"] = $row["MODEL"];
        $productlist["price"] = $row["PRICE"];
        $productlist["quantity"] = $row["QUANTITY"];
        $productlist["weight"] = $row["WEIGHT"];
        $productlist["category"] = $row["CATEGORY"];
        array_push($response["products"], $productlist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>
