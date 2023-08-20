<?php 

ini_set('display_errors', 'On');
error_reporting(E_ALL);
session_start();

require('conn.php');


$cust_selection = $_POST['cust_selection'];
$price = $_POST['price'];

//Query
$conn->query("INSERT INTO `log`(`log_id`, `cust_selection`, `price`, `timestamp`) VALUES (NULL, '$cust_selection', '$price', NOW())");





?>