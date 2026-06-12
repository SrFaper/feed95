import 'dart:io';
import 'package:flutter/material.dart';
import '../models/usuario.dart';

class AvatarUsuario extends StatelessWidget {
  final Usuario usuario;
  final double size;
  final bool circular;

  const AvatarUsuario({
    super.key,
    required this.usuario,
    this.size = 80,
    this.circular = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = circular ? size / 2 : 12.0;
    if (usuario.imagenPerfil != null && usuario.imagenPerfil!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.file(
          File(usuario.imagenPerfil!),
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _colorAvatar(radius),
        ),
      );
    }
    return _colorAvatar(radius);
  }

  Widget _colorAvatar(double radius) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: usuario.color,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Center(
        child: Text(
          usuario.nombre[0].toUpperCase(),
          style: TextStyle(
            fontSize: size * 0.42,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}