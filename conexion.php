<?php
$host = "127.0.0.1"; 
$user = "root";
$password = "";
$database = "calzado";

$conexion = new mysqli($host, $user, $password, $database);

if ($conexion->connect_error) {
    die("Error de conexión: " . $conexion->connect_error);
}

$conexion->set_charset("utf8");
?>