<?php
require_once("../config/conexion.php");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["success" => false, "message" => "Método no permitido"]);
    exit;
}

$id = trim($_POST['id'] ?? '');

if ($id === '') {
    echo json_encode(["success" => false, "message" => "El id del juego es obligatorio"]);
    exit;
}

$sql = "DELETE FROM juegos WHERE id = ?";
$stmt = $conexion->prepare($sql);
$stmt->bind_param("i", $id);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Juego eliminado correctamente"]);
} else {
    echo json_encode(["success" => false, "message" => "No se pudo eliminar el juego"]);
}
?>