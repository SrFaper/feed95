class Juego {
  final int id;
  final String nombre;
  final String descripcion;
  final String imagen;
  final String? imagenLocal;
  final String version;
  final int calificacion;
  final String generos;
  final String estado;
  final int usuarioId;
  final String? rutaEjecutable;

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
    this.rutaEjecutable,
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
      rutaEjecutable: json['ruta_ejecutable'],
    );
  }
}