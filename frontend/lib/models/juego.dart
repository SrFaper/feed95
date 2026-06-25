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

  // ── Resto de campos ──
  final String imagenesExtra;
  final String version;
  final int calificacion;
  final String estado;
  final int usuarioId;
  final String? rutaEjecutable;
  final int catalogo; // 0 = principal, 1 = secundario
  final int posicion;

  // ── Categorías múltiples (IDs) ──
  // Pobladas por ApiService.obtenerJuegos via JOIN con juego_categorias.
  // No se persisten en este objeto directamente: la fuente de verdad es la BD.
  final List<int> categorias;

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
    this.posicion = 0,
    this.categorias = const [],
  });

  factory Juego.fromJson(Map<String, dynamic> json, {List<int>? categorias}) {
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
      posicion: json['posicion'] as int? ?? 0,
      categorias: categorias ?? const [],
    );
  }

  // ── Getters resueltos ──

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

  bool get tieneImagenOverride =>
      (imagenOverrideLocal != null && imagenOverrideLocal!.isNotEmpty) ||
      (imagenOverride != null && imagenOverride!.isNotEmpty);

  String? get imagenLocal =>
      tieneImagenOverride ? imagenOverrideLocal : imagenOrigLocal;
  String get imagen =>
      tieneImagenOverride ? (imagenOverride ?? '') : imagenOrig;

  bool get tieneImagenGridOverride =>
      (imagenGridOverrideLocal != null &&
          imagenGridOverrideLocal!.isNotEmpty) ||
      (imagenGridOverride != null && imagenGridOverride!.isNotEmpty);

  String? get imagenGridLocal =>
      tieneImagenGridOverride ? imagenGridOverrideLocal : imagenGridOrigLocal;
  String get imagenGrid => tieneImagenGridOverride
      ? (imagenGridOverride ?? '')
      : (imagenGridOrig.isNotEmpty ? imagenGridOrig : imagenOrig);

  bool get tieneOriginal =>
      nombreOrig.isNotEmpty ||
      imagenOrig.isNotEmpty ||
      imagenGridOrig.isNotEmpty;

  List<String> get listaImagenesExtra => imagenesExtra
      .split(',')
      .map((u) => u.trim())
      .where((u) => u.isNotEmpty)
      .toList();
}
