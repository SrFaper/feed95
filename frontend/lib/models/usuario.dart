import 'package:flutter/material.dart';

class Usuario {
  final int id;
  final String nombre;
  final Color color;

  Usuario({
    required this.id,
    required this.nombre,
    required this.color,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: int.parse(json['id'].toString()),
      nombre: json['nombre'],
      color: Color(json['color'] as int? ?? 0xFF607D8B),
    );
  }
}