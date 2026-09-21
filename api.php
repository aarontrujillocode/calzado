<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$host = "127.0.0.1";
$user = "root";
$pass = "";
$db   = "calzado_store";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Error de conexión a la BD"]);
    exit();
}

$action = $_GET['action'] ?? '';
$data = json_decode(file_get_contents("php://input"), true);

if ($action === 'login') {
    $email = trim($data['email'] ?? '');
    $password = trim($data['password'] ?? '');

    if (empty($email) || empty($password)) {
        echo json_encode(["status" => "error", "message" => "Faltan campos obligatorios"]);
        exit();
    }

    $sql = "SELECT 
                u.id, u.nombre, u.email, u.telefono, u.fecha_nacimiento, u.foto_perfil, u.password, u.rol,
                (SELECT COUNT(*) FROM pedidos WHERE usuario_id = u.id) AS pedidos,
                (SELECT COUNT(*) FROM favoritos WHERE usuario_id = u.id) AS favoritos
            FROM usuarios u 
            WHERE u.email = ?";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($user = $result->fetch_assoc()) {
        if ($password === $user['password'] || password_verify($password, $user['password'])) {
            unset($user['password']);
            $user['id'] = (int)$user['id'];
            $user['telefono'] = $user['telefono'] ?? '';
            $user['fecha_nacimiento'] = $user['fecha_nacimiento'] ?? '';
            $user['foto_perfil'] = $user['foto_perfil'] ?? '';
            $user['pedidos'] = (int)($user['pedidos'] ?? 0);
            $user['favoritos'] = (int)($user['favoritos'] ?? 0);

            echo json_encode([
                "status" => "success", 
                "message" => "Login correcto", 
                "user" => $user
            ]);
        } else {
            echo json_encode(["status" => "error", "message" => "Contraseña incorrecta"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "El usuario no existe"]);
    }
    $stmt->close();

} else if ($action === 'register') {
    $nombre = trim($data['nombre'] ?? '');
    $email = trim($data['email'] ?? '');
    $password = trim($data['password'] ?? '');

    if (empty($nombre) || empty($email) || empty($password)) {
        echo json_encode(["status" => "error", "message" => "Todos los campos son requeridos"]);
        exit();
    }

    $checkStmt = $conn->prepare("SELECT id FROM usuarios WHERE email = ?");
    $checkStmt->bind_param("s", $email);
    $checkStmt->execute();
    if ($checkStmt->get_result()->num_rows > 0) {
        echo json_encode(["status" => "error", "message" => "El correo ya está registrado"]);
        exit();
    }
    $checkStmt->close();

    $passwordHash = password_hash($password, PASSWORD_BCRYPT);
    $stmt = $conn->prepare("INSERT INTO usuarios (nombre, email, password, rol) VALUES (?, ?, ?, 'cliente')");
    $stmt->bind_param("sss", $nombre, $email, $passwordHash);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Usuario registrado correctamente"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error al registrar usuario"]);
    }
    $stmt->close();

} else if ($action === 'update_profile') {
    $id               = $data['id'] ?? null;
    $nombre           = trim($data['nombre'] ?? '');
    $email            = trim($data['email'] ?? '');
    $telefono         = trim($data['telefono'] ?? '');
    $fecha_nacimiento = trim($data['fecha_nacimiento'] ?? '');

    if (empty($id) || empty($nombre) || empty($email)) {
        echo json_encode(["status" => "error", "message" => "El ID, nombre y correo son obligatorios"]);
        exit();
    }

    $stmt = $conn->prepare("UPDATE usuarios SET nombre = ?, email = ?, telefono = ?, fecha_nacimiento = ? WHERE id = ?");
    $stmt->bind_param("ssssi", $nombre, $email, $telefono, $fecha_nacimiento, $id);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Perfil actualizado correctamente"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error al actualizar perfil"]);
    }
    $stmt->close();

} else if ($action === 'get_addresses') {
    $usuario_id = $_GET['usuario_id'] ?? null;
    if (empty($usuario_id)) {
        echo json_encode(["status" => "error", "message" => "ID de usuario requerido"]);
        exit();
    }

    $stmt = $conn->prepare("SELECT * FROM direcciones WHERE usuario_id = ? ORDER BY es_principal DESC, id DESC");
    $stmt->bind_param("i", $usuario_id);
    $stmt->execute();
    $result = $stmt->get_result();

    $direcciones = [];
    while ($row = $result->fetch_assoc()) {
        $row['id'] = (int)$row['id'];
        $row['usuario_id'] = (int)$row['usuario_id'];
        $row['es_principal'] = (bool)$row['es_principal'];
        $direcciones[] = $row;
    }

    echo json_encode(["status" => "success", "direcciones" => $direcciones]);
    $stmt->close();

} else if ($action === 'add_address') {
    $usuario_id   = $data['usuario_id'] ?? null;
    $titulo       = trim($data['titulo'] ?? '');
    $direccion    = trim($data['direccion'] ?? '');
    $distrito     = trim($data['distrito'] ?? '');
    $ciudad       = trim($data['ciudad'] ?? 'Lima');
    $pais         = trim($data['pais'] ?? 'Perú');
    $codigo_postal= trim($data['codigo_postal'] ?? '15037');
    $telefono     = trim($data['telefono'] ?? '');
    $es_principal = !empty($data['es_principal']) ? 1 : 0;

    if (empty($usuario_id) || empty($titulo) || empty($direccion) || empty($distrito) || empty($telefono)) {
        echo json_encode(["status" => "error", "message" => "Campos obligatorios incompletos"]);
        exit();
    }

    if ($es_principal === 1) {
        $resetStmt = $conn->prepare("UPDATE direcciones SET es_principal = 0 WHERE usuario_id = ?");
        $resetStmt->bind_param("i", $usuario_id);
        $resetStmt->execute();
        $resetStmt->close();
    }

    $stmt = $conn->prepare("INSERT INTO direcciones (usuario_id, titulo, direccion, distrito, ciudad, pais, codigo_postal, telefono, es_principal) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("isssssssi", $usuario_id, $titulo, $direccion, $distrito, $ciudad, $pais, $codigo_postal, $telefono, $es_principal);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Dirección agregada con éxito"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error al guardar dirección"]);
    }
    $stmt->close();

} else if ($action === 'delete_address') {
    $id = $data['id'] ?? null;
    if (empty($id)) {
        echo json_encode(["status" => "error", "message" => "ID de dirección requerido"]);
        exit();
    }

    $stmt = $conn->prepare("DELETE FROM direcciones WHERE id = ?");
    $stmt->bind_param("i", $id);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Dirección eliminada correctamente"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error al eliminar"]);
    }
    $stmt->close();

} else if ($action === 'get_products') {
    // Consulta directa a las columnas de la tabla productos
    $sql = "SELECT 
                id, 
                nombre, 
                descripcion, 
                precio, 
                imagen, 
                subcategoria, 
                categoria,
                stock_total,
                tallas
            FROM productos
            ORDER BY id DESC";

    $result = $conn->query($sql);

    $productos = [];
    if ($result) {
        while ($row = $result->fetch_assoc()) {
            $row['id'] = (int)$row['id'];
            $row['precio'] = (float)$row['precio'];
            $row['stock_total'] = (int)$row['stock_total'];
            $row['tallas'] = $row['tallas'] ?? 'Sin tallas';
            $productos[] = $row;
        }
    }

    echo json_encode(["status" => "success", "productos" => $productos]);

} else {
    echo json_encode(["status" => "error", "message" => "Acción no válida"]);
}

$conn->close();
?>