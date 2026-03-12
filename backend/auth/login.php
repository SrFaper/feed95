<?php
require_once("../config/conexion.php");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["success" => false, "message" => "Método no permitido"]);
    exit;
}

$correo = trim($_POST['correo'] ?? '');
$password = trim($_POST['password'] ?? '');

if ($correo === '' || $password === '') {
    echo json_encode(["success" => false, "message" => "Correo y contraseña son obligatorios"]);
    exit;
}

$sql = "SELECT id, nombre, correo, password FROM usuarios WHERE correo = ?";
$stmt = $conexion->prepare($sql);
$stmt->bind_param("s", $correo);
$stmt->execute();
$resultado = $stmt->get_result();

if ($resultado->num_rows === 0) {
    echo json_encode(["success" => false, "message" => "Usuario no encontrado"]);
    exit;
}

$usuario = $resultado->fetch_assoc();

if (password_verify($password, $usuario['password'])) {
    echo json_encode([
        "success" => true,
        "message" => "Inicio de sesión correcto",
        "usuario" => [
            "id" => $usuario['id'],
            "nombre" => $usuario['nombre'],
            "correo" => $usuario['correo']
        ]
    ]);
} else {
    echo json_encode(["success" => false, "message" => "Contraseña incorrecta"]);
}
?>