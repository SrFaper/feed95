class Juego {
  final int id;

  // ── Nombre ──
  final String nombreOrig;
  final String? nombreOverride;

  // ── Descripción ──
  final String descripcionOrig;
  final String? descripcionOverride;

  // ── Géneros ──
  final String generosOrig;
  final String? generosOverride;

  // ── Imagen detalle (horizontal/banner) ──
  final String imagenOrig;
  final String? imagenOrigLocal;
  final String? imagenOverride;
  final String? imagenOverrideLocal;
  // Recorte: región de la imagen ORIGINAL seleccionada, en fracción 0-1.
  // (0,0,1,1) = toda la imagen, sin recorte.
  final double imagenCropX;
  final double imagenCropY;
  final double imagenCropW;
  final double imagenCropH;

  // ── Imagen grid (vertical/portada) ──
  final String imagenGridOrig;
  final String? imagenGridOrigLocal;
  final String? imagenGridOverride;
  final String? imagenGridOverrideLocal;
  final double imagenGridCropX;
  final double imagenGridCropY;
  final double imagenGridCropW;
  final double imagenGridCropH;

  // ── Resto de campos (sin override, no tiene sentido para estos) ──
  final String imagenesExtra;
  final String version;
  final int calificacion;
  final String estado;
  final int usuarioId;
  final String? rutaEjecutable;
  final int catalogo; // 0 = principal, 1 = secundario
  final int? categoriaId;
  final int posicion;

  Juego({
    required this.id,
    required this.nombreOrig,
    this.nombreOverride,
    required this.descripcionOrig,
    this.descripcionOverride,
    required this.generosOrig,
    this.generosOverride,
    required this.imagenOrig,
    this.imagenOrigLocal,
    this.imagenOverride,
    this.imagenOverrideLocal,
    this.imagenCropX = 0,
    this.imagenCropY = 0,
    this.imagenCropW = 1,
    this.imagenCropH = 1,
    required this.imagenGridOrig,
    this.imagenGridOrigLocal,
    this.imagenGridOverride,
    this.imagenGridOverrideLocal,
    this.imagenGridCropX = 0,
    this.imagenGridCropY = 0,
    this.imagenGridCropW = 1,
    this.imagenGridCropH = 1,
    required this.imagenesExtra,
    required this.version,
    required this.calificacion,
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
      nombreOrig: json['nombre_orig'] ?? '',
      nombreOverride: json['nombre_override'] as String?,
      descripcionOrig: json['descripcion_orig'] ?? '',
      descripcionOverride: json['descripcion_override'] as String?,
      generosOrig: json['generos_orig'] ?? '',
      generosOverride: json['generos_override'] as String?,
      imagenOrig: json['imagen_orig'] ?? '',
      imagenOrigLocal: json['imagen_orig_local'] as String?,
      imagenOverride: json['imagen_override'] as String?,
      imagenOverrideLocal: json['imagen_override_local'] as String?,
      imagenCropX: (json['imagen_crop_x'] as num?)?.toDouble() ?? 0,
      imagenCropY: (json['imagen_crop_y'] as num?)?.toDouble() ?? 0,
      imagenCropW: (json['imagen_crop_w'] as num?)?.toDouble() ?? 1,
      imagenCropH: (json['imagen_crop_h'] as num?)?.toDouble() ?? 1,
      imagenGridOrig: json['imagen_grid_orig'] ?? '',
      imagenGridOrigLocal: json['imagen_grid_orig_local'] as String?,
      imagenGridOverride: json['imagen_grid_override'] as String?,
      imagenGridOverrideLocal: json['imagen_grid_override_local'] as String?,
      imagenGridCropX: (json['imagen_grid_crop_x'] as num?)?.toDouble() ?? 0,
      imagenGridCropY: (json['imagen_grid_crop_y'] as num?)?.toDouble() ?? 0,
      imagenGridCropW: (json['imagen_grid_crop_w'] as num?)?.toDouble() ?? 1,
      imagenGridCropH: (json['imagen_grid_crop_h'] as num?)?.toDouble() ?? 1,
      imagenesExtra: json['imagenes_extra'] ?? '',
      version: json['version'] ?? '',
      calificacion: int.parse(json['calificacion'].toString()),
      estado: json['estado'] ?? '',
      usuarioId: int.parse(json['usuario_id'].toString()),
      rutaEjecutable: json['ruta_ejecutable'] as String?,
      catalogo: json['catalogo'] as int? ?? 0,
      categoriaId: json['categoria_id'] as int?,
      posicion: json['posicion'] as int? ?? 0,
    );
  }

  // ── Getters resueltos: override si existe y no está vacío, si no el original ──

  bool get tieneNombreOverride =>
      nombreOverride != null && nombreOverride!.isNotEmpty;
  String get nombre => tieneNombreOverride ? nombreOverride! : nombreOrig;

  bool get tieneDescripcionOverride =>
      descripcionOverride != null && descripcionOverride!.isNotEmpty;
  String get descripcion =>
      tieneDescripcionOverride ? descripcionOverride! : descripcionOrig;

  bool get tieneGenerosOverride =>
      generosOverride != null && generosOverride!.isNotEmpty;
  String get generos => tieneGenerosOverride ? generosOverride! : generosOrig;

  // Imagen detalle: prioridad override-local > override-url > orig-local > orig-url
  bool get tieneImagenOverride =>
      (imagenOverrideLocal != null && imagenOverrideLocal!.isNotEmpty) ||
      (imagenOverride != null && imagenOverride!.isNotEmpty);

  String? get imagenLocal =>
      tieneImagenOverride ? imagenOverrideLocal : imagenOrigLocal;
  String get imagen =>
      tieneImagenOverride ? (imagenOverride ?? '') : imagenOrig;

  // Imagen grid: misma lógica
  bool get tieneImagenGridOverride =>
      (imagenGridOverrideLocal != null &&
          imagenGridOverrideLocal!.isNotEmpty) ||
      (imagenGridOverride != null && imagenGridOverride!.isNotEmpty);

  String? get imagenGridLocal =>
      tieneImagenGridOverride ? imagenGridOverrideLocal : imagenGridOrigLocal;
  String get imagenGrid => tieneImagenGridOverride
      ? (imagenGridOverride ?? '')
      : (imagenGridOrig.isNotEmpty ? imagenGridOrig : imagenOrig);

  // ¿Tiene algún dato "original" de fuente externa? (para mostrar placeholders fantasma)
  bool get tieneOriginal =>
      nombreOrig.isNotEmpty ||
      imagenOrig.isNotEmpty ||
      imagenGridOrig.isNotEmpty;

  // Lista de URLs del carrusel
  List<String> get listaImagenesExtra => imagenesExtra
      .split(',')
      .map((u) => u.trim())
      .where((u) => u.isNotEmpty)
      .toList();
}
