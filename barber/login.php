<?php 

ini_set('display_errors', 'On');
error_reporting(E_ALL);
session_start();

require('conn.php');


$icNum = $_POST['icNum'];
$password = md5($_POST['password']);

//Query
$queryRes = $conn->query("SELECT * FROM auth WHERE icNum = '". $icNum ."' AND password = '". $password ."' ");

//Create variable as array
$result = array();


while($fetchData = $queryRes->fetch_assoc()){
    $result[]=$fetchData;
}


echo json_encode($result);



?>