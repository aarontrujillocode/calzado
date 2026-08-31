<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");

include('conexion.php');

// Obtener todas las categorías con sus subcategorías
$sql = "SELECT c.id AS categoria_id, c.nombre AS categoria, 
               s.id AS subcategoria_id, s.nombre AS subcategoria 
        FROM categorias c 
        LEFT JOIN subcategorias s ON c.id = s.categoria_id 
        ORDER BY c.id, s.id";

$result = $conexion->query($sql);
$data = array();

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $cat_id = $row['categoria_id'];
        
        if (!isset($data[$cat_id])) {
            $data[$cat_id] = array(
                "id" => $cat_id,
                "categoria" => $row['categoria'],
                "subcategorias" => array()
            );
        }
        
        if ($row['subcategoria']) {
            $data[$cat_id]['subcategorias'][] = array(
                "id" => $row['subcategoria_id'],
                "nombre" => $row['subcategoria']
            );
        }
    }
}

echo json_encode(array_values($data), JSON_UNESCAPED_UNICODE);
?>