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
  final double imagenAjusteX;
  final double imagenAjusteY;
  final double imagenAjusteZoom;

  // ── Imagen grid (vertical/portada) ──
  final String imagenGridOrig;
  final String? imagenGridOrigLocal;
  final String? imagenGridOverride;
  final String? imagenGridOverrideLocal;
  final double imagenGridAjusteX;
  final double imagenGridAjusteY;
  final double imagenGridAjusteZoom;

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
    this.imagenAjusteX = 0,
    this.imagenAjusteY = 0,
    this.imagenAjusteZoom = 1,
    required this.imagenGridOrig,
    this.imagenGridOrigLocal,
    this.imagenGridOverride,
    this.imagenGridOverrideLocal,
    this.imagenGridAjusteX = 0,
    this.imagenGridAjusteY = 0,
    this.imagenGridAjusteZoom = 1,
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
      imagenAjusteX: (json['imagen_ajuste_x'] as num?)?.toDouble() ?? 0,
      imagenAjusteY: (json['imagen_ajuste_y'] as num?)?.toDouble() ?? 0,
      imagenAjusteZoom: (json['imagen_ajuste_zoom'] as num?)?.toDouble() ?? 1,
      imagenGridOrig: json['imagen_grid_orig'] ?? '',
      imagenGridOrigLocal: json['imagen_grid_orig_local'] as String?,
      imagenGridOverride: json['imagen_grid_override'] as String?,
      imagenGridOverrideLocal: json['imagen_grid_override_local'] as String?,
      imagenGridAjusteX:
          (json['imagen_grid_ajuste_x'] as num?)?.toDouble() ?? 0,
      imagenGridAjusteY:
          (json['imagen_grid_ajuste_y'] as num?)?.toDouble() ?? 0,
      imagenGridAjusteZoom:
          (json['imagen_grid_ajuste_zoom'] as num?)?.toDouble() ?? 1,
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
