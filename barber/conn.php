<?php 

$conn = new mysqli('localhost','root','','barber');

if($conn){

}else{
    echo 'Connection Failed';
    exit();
}


?>