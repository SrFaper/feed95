<?php
require_once("../config/conexion.php");

$sql = "SELECT id, nombre, descripcion, imagen, version, calificacion, generos, estado, usuario_id FROM juegos ORDER BY id DESC";
$resultado = $conexion->query($sql);

$juegos = [];

while ($fila = $resultado->fetch_assoc()) {
    $juegos[] = $fila;
}

echo json_encode([
    "success" => true,
    "juegos" => $juegos
]);
?>