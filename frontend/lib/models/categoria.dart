class Categoria {
  final int id;
  final String nombre;
  final String? imagen;
  final int usuarioId;
  final int catalogo;

  Categoria({
    required this.id,
    required this.nombre,
    this.imagen,
    required this.usuarioId,
    required this.catalogo,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: int.parse(json['id'].toString()),
      nombre: json['nombre'],
      imagen: json['imagen'] as String?,
      usuarioId: int.parse(json['usuario_id'].toString()),
      catalogo: json['catalogo'] as int? ?? 0,
    );
  }
}