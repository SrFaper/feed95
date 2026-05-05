class Juego {
  final int id;
  final String nombre;
  final String descripcion;
  final String imagen;
  final String? imagenLocal; // ruta local del dispositivo
  final String version;
  final int calificacion;
  final String generos;
  final String estado;
  final int usuarioId;

  Juego({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagen,
    this.imagenLocal,
    required this.version,
    required this.calificacion,
    required this.generos,
    required this.estado,
    required this.usuarioId,
  });

  factory Juego.fromJson(Map<String, dynamic> json) {
    return Juego(
      id: int.parse(json['id'].toString()),
      nombre: json['nombre'],
      descripcion: json['descripcion'] ?? '',
      imagen: json['imagen'] ?? '',
      imagenLocal: json['imagen_local'],
      version: json['version'] ?? '',
      calificacion: int.parse(json['calificacion'].toString()),
      generos: json['generos'] ?? '',
      estado: json['estado'] ?? '',
      usuarioId: int.parse(json['usuario_id'].toString()),
    );
  }
}