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
} else {
    echo json_encode(["status" => "error", "message" => "Acción no válida"]);
}

$conn->close();
?>