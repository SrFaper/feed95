<?php
require_once("../config/conexion.php");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["success" => false, "message" => "Método no permitido"]);
    exit;
}

$id = trim($_POST['id'] ?? '');
$nombre = trim($_POST['nombre'] ?? '');
$descripcion = trim($_POST['descripcion'] ?? '');
$imagen = trim($_POST['imagen'] ?? '');
$version = trim($_POST['version'] ?? '');
$calificacion = trim($_POST['calificacion'] ?? '');
$generos = trim($_POST['generos'] ?? '');
$estado = trim($_POST['estado'] ?? '');

if ($id === '' || $nombre === '') {
    echo json_encode(["success" => false, "message" => "El id y el nombre son obligatorios"]);
    exit;
}

$sql = "UPDATE juegos SET nombre = ?, descripcion = ?, imagen = ?, version = ?, calificacion = ?, generos = ?, estado = ? WHERE id = ?";
$stmt = $conexion->prepare($sql);
$stmt->bind_param("ssssissi", $nombre, $descripcion, $imagen, $version, $calificacion, $generos, $estado, $id);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Juego actualizado correctamente"]);
} else {
    echo json_encode(["success" => false, "message" => "No se pudo actualizar el juego"]);
}
?>