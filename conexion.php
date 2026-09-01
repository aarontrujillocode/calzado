<?php
$host = "localhost";
$user = "root";
$password = "";
$database = "calzado_store";

$conexion = new mysqli($host, $user, $password, $database);

if ($conexion->connect_error) {
    die("Error de conexión: " . $conexion->connect_error);
}

$conexion->set_charset("utf8");
?>