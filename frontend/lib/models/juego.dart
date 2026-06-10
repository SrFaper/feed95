class Juego {
  final int id;
  final String nombre;
  final String descripcion;
  final String imagen;
  final String? imagenLocal;
  final String imagenGrid;
  final String? imagenGridLocal;
  final String imagenesExtra;
  final String version;
  final int calificacion;
  final String generos;
  final String estado;
  final int usuarioId;
  final String? rutaEjecutable;
  final int catalogo; // 0 = principal, 1 = secundario
  final int? categoriaId;
  final int posicion;

  Juego({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagen,
    this.imagenLocal,
    required this.imagenGrid,
    this.imagenGridLocal,
    required this.imagenesExtra,
    required this.version,
    required this.calificacion,
    required this.generos,
    required this.estado,
    required this.usuarioId,
    this.rutaEjecutable,
    this.catalogo = 0,
    this.categoriaId,
    this.posicion = 0,
  });

  factory Juego.fromJson(Map<String, dynamic> json) {
    return Juego(
      id: int.parse(json['id'].toString()),
      nombre: json['nombre'],
      descripcion: json['descripcion'] ?? '',
      imagen: json['imagen'] ?? '',
      imagenLocal: json['imagen_local'],
      imagenGrid: json['imagen_grid'] ?? json['imagen'] ?? '',
      imagenGridLocal: json['imagen_grid_local'],
      imagenesExtra: json['imagenes_extra'] ?? '',
      version: json['version'] ?? '',
      calificacion: int.parse(json['calificacion'].toString()),
      generos: json['generos'] ?? '',
      estado: json['estado'] ?? '',
      usuarioId: int.parse(json['usuario_id'].toString()),
      rutaEjecutable: json['ruta_ejecutable'],
      catalogo: json['catalogo'] as int? ?? 0,
      categoriaId: json['categoria_id'] as int?,
      posicion: json['posicion'] as int? ?? 0,
    );
  }

  // Lista de URLs del carrusel
  List<String> get listaImagenesExtra => imagenesExtra
      .split(',')
      .map((u) => u.trim())
      .where((u) => u.isNotEmpty)
      .toList();
}
