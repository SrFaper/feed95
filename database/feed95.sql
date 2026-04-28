-- phpMyAdmin SQL Dump
-- Base de datos: feed95

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
SET NAMES utf8mb4;

-- --------------------------------------------------------
-- Tabla: usuarios
-- --------------------------------------------------------

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `usuarios` (`id`, `nombre`, `correo`, `password`) VALUES
(1, 'Test', 'test@feed95.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi');

-- --------------------------------------------------------
-- Tabla: juegos
-- --------------------------------------------------------

CREATE TABLE `juegos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `imagen` varchar(500) DEFAULT NULL,
  `version` varchar(50) DEFAULT NULL,
  `calificacion` int(11) DEFAULT NULL,
  `generos` varchar(200) DEFAULT NULL,
  `estado` varchar(50) DEFAULT NULL,
  `usuario_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `juegos` (`id`, `nombre`, `descripcion`, `imagen`, `version`, `calificacion`, `generos`, `estado`, `usuario_id`) VALUES
(1, 'Halo Infinite', 'El último juego de la mejor saga de la historia', 'https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/1240440/5c09b42d3b89901b78c322bb366bb34a1123f468/library_capsule.jpg', 'Operation: Infinite Out Now', 10, 'Acción, Aventura, Ciencia Ficción', 'Completado', 1);

-- --------------------------------------------------------
-- Índices y claves
-- --------------------------------------------------------

ALTER TABLE `juegos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `correo` (`correo`);

ALTER TABLE `juegos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

ALTER TABLE `juegos`
  ADD CONSTRAINT `juegos_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

COMMIT;