<?php
require_once("../config/conexion.php");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["success" => false, "message" => "Método no permitido"]);
    exit;
}

$nombre = trim($_POST['nombre'] ?? '');
$descripcion = trim($_POST['descripcion'] ?? '');
$imagen = trim($_POST['imagen'] ?? '');
$version = trim($_POST['version'] ?? '');
$calificacion = trim($_POST['calificacion'] ?? '');
$generos = trim($_POST['generos'] ?? '');
$estado = trim($_POST['estado'] ?? '');
$usuarioId = trim($_POST['usuario_id'] ?? '');

if ($nombre === '' || $usuarioId === '') {
    echo json_encode(["success" => false, "message" => "El nombre y el usuario son obligatorios"]);
    exit;
}

$sql = "INSERT INTO juegos (nombre, descripcion, imagen, version, calificacion, generos, estado, usuario_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
$stmt = $conexion->prepare($sql);
$stmt->bind_param("ssssissi", $nombre, $descripcion, $imagen, $version, $calificacion, $generos, $estado, $usuarioId);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Juego añadido correctamente"]);
} else {
    echo json_encode(["success" => false, "message" => "No se pudo añadir el juego"]);
}
?>