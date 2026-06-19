import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/juego.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import '../services/epic_service.dart';
import '../services/steam_service.dart';
import '../services/f95_service.dart';
import '../services/igdb_service.dart';
import '../services/image_cache_service.dart';
import '../widgets/campo_con_original.dart';
import '../widgets/imagen_con_original.dart';
import '../widgets/editor_ajuste_imagen.dart';
import 'f95_config_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'igdb_config_screen.dart';
import 'package:frontend/l10n/app_localizations.dart';
//import '../widgets/imagen_ajustada.dart';

class JuegoFormScreen extends StatefulWidget {
  final Usuario usuario;
  final Juego? juego;
  final int catalogoInicial;

  const JuegoFormScreen({
    super.key,
    required this.usuario,
    this.juego,
    this.catalogoInicial = 0,
  });

  @override
  State<JuegoFormScreen> createState() => _JuegoFormScreenState();
}

class _JuegoFormScreenState extends State<JuegoFormScreen> {
  // ── Controllers de override (lo que el usuario escribe) ──
  final nombreCtrl = TextEditingController();
  final descripcionCtrl = TextEditingController();
  final generosCtrl = TextEditingController();
  final imagenOverrideCtrl = TextEditingController();
  final imagenGridOverrideCtrl = TextEditingController();

  // Campos sin override (siempre directos)
  final versionController = TextEditingController();
  final calificacionController = TextEditingController();
  final rutaEjecutableController = TextEditingController();

  // ── Datos "originales" (de fuente externa). Vacíos si es creación manual. ──
  String _nombreOrig = '';
  String _descripcionOrig = '';
  String _generosOrig = '';
  String _imagenOrig = '';
  String? _imagenOrigLocal;
  String _imagenGridOrig = '';
  String? _imagenGridOrigLocal;

  // Imagen override local (si el usuario elige de galería)
  String? _imagenOverrideLocal;
  String? _imagenGridOverrideLocal;

  // Recorte (crop rect) sobre la imagen real, independiente de si se ve
  // override u original. (0,0,1,1) = toda la imagen, sin recorte.
  double _imagenCropX = 0;
  double _imagenCropY = 0;
  double _imagenCropW = 1;
  double _imagenCropH = 1;
  double _imagenGridCropX = 0;
  double _imagenGridCropY = 0;
  double _imagenGridCropW = 1;
  double _imagenGridCropH = 1;

  String _imagenesExtra = '';
  String estadoSeleccionado = 'Pending';
  bool cargando = false;
  bool _guardandoCache = false;
  ModoGuardadoImagen _modoGuardadoImagen = ModoGuardadoImagen.ninguno;
  bool _buscandoSteam = false;
  bool _buscandoEpic = false;
  bool _buscandoF95 = false;
  bool _f95Activado = false;
  bool _buscandoIgdb = false;
  bool _igdbConfigurado = false;

  bool get _mostrarEjecutable =>
      !kIsWeb && (Platform.isWindows || Platform.isLinux);

  @override
  void initState() {
    super.initState();
    _cargarF95();
    _cargarIgdb();
    if (widget.juego != null) {
      final j = widget.juego!;
      _nombreOrig = j.nombreOrig;
      _descripcionOrig = j.descripcionOrig;
      _generosOrig = j.generosOrig;
      _imagenOrig = j.imagenOrig;
      _imagenOrigLocal = j.imagenOrigLocal;
      _imagenGridOrig = j.imagenGridOrig;
      _imagenGridOrigLocal = j.imagenGridOrigLocal;

      nombreCtrl.text = j.nombreOverride ?? '';
      descripcionCtrl.text = j.descripcionOverride ?? '';
      generosCtrl.text = j.generosOverride ?? '';
      imagenOverrideCtrl.text = j.imagenOverride ?? '';
      imagenGridOverrideCtrl.text = j.imagenGridOverride ?? '';
      _imagenOverrideLocal = j.imagenOverrideLocal;
      _imagenGridOverrideLocal = j.imagenGridOverrideLocal;
      _imagenCropX = j.imagenCropX;
      _imagenCropY = j.imagenCropY;
      _imagenCropW = j.imagenCropW;
      _imagenCropH = j.imagenCropH;
      _imagenGridCropX = j.imagenGridCropX;
      _imagenGridCropY = j.imagenGridCropY;
      _imagenGridCropW = j.imagenGridCropW;
      _imagenGridCropH = j.imagenGridCropH;

      versionController.text = j.version;
      calificacionController.text = j.calificacion.toString();
      estadoSeleccionado = j.estado;
      _imagenesExtra = j.imagenesExtra;
      rutaEjecutableController.text = j.rutaEjecutable ?? '';
    }
  }

  // ── Helpers ──────────────────────────────────────────────

  Widget _botonFuente({
    required String label,
    required bool cargando,
    required VoidCallback onTap,
  }) {
    return cargando
        ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : ActionChip(
            label: Text(label, style: const TextStyle(fontSize: 12)),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            onPressed: onTap,
          );
  }

  Future<void> _mostrarResultados<T>({
    required String titulo,
    required List<T> resultados,
    required String Function(T) nombre,
    required String Function(T) portada,
    required Future<void> Function(T) onSeleccionar,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: resultados.length,
            itemBuilder: (context, index) {
              final r = resultados[index];
              final url = portada(r);
              return ListTile(
                leading: url.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          url,
                          width: 40,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              const Icon(Icons.videogame_asset),
                        ),
                      )
                    : const Icon(Icons.videogame_asset),
                title: Text(nombre(r), style: const TextStyle(fontSize: 14)),
                onTap: () async {
                  Navigator.pop(context);
                  await onSeleccionar(r);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.btnCancelar),
          ),
        ],
      ),
    );
  }

  /// Al traer datos de una fuente externa, se llenan los campos "original".
  /// Los overrides existentes NO se tocan (si el usuario ya personalizó algo,
  /// se mantiene su personalización por encima del nuevo original).
  void _rellenarOriginal({
    required String nombre,
    required String descripcion,
    required String portada,
    required String portadaGrid,
    required String generos,
    String imagenesExtra = '',
  }) {
    setState(() {
      _nombreOrig = nombre;
      _descripcionOrig = descripcion;
      _imagenOrig = portada;
      _imagenOrigLocal = null;
      _imagenGridOrig = portadaGrid;
      _imagenGridOrigLocal = null;
      _generosOrig = generos;
      _imagenesExtra = imagenesExtra;
    });
  }

  // ── Steam ─────────────────────────────────────────────────

  Future<void> _buscarEnSteam() async {
    final l10n = AppLocalizations.of(context)!;
    final query = nombreCtrl.text.trim().isNotEmpty
        ? nombreCtrl.text.trim()
        : _nombreOrig;
    if (query.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.juegoFormNoBusqueda)));
      return;
    }
    setState(() => _buscandoSteam = true);
    final resultados = await SteamService.buscar(query);
    setState(() => _buscandoSteam = false);
    if (!mounted) return;
    if (resultados.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.juegoFormSinResultadosSteam)));
      return;
    }
    await _mostrarResultados(
      titulo: l10n.juegoFormResultadosSteam,
      resultados: resultados,
      nombre: (r) => r.nombre,
      portada: (r) => r.portada,
      onSeleccionar: (r) async {
        setState(() => cargando = true);
        final detalle = await SteamService.obtenerDetalle(r.appId);
        setState(() => cargando = false);
        if (!mounted) return;
        if (detalle == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.juegoFormErrorDetalles)));
          return;
        }
        _rellenarOriginal(
          nombre: detalle.nombre,
          descripcion: detalle.descripcion,
          portada: detalle.portada,
          portadaGrid: detalle.portadaGrid,
          generos: detalle.generos,
          imagenesExtra: detalle.imagenesExtra,
        );
      },
    );
  }

  // ── Epic ──────────────────────────────────────────────────

  Future<void> _buscarEnEpic() async {
    final l10n = AppLocalizations.of(context)!;
    final query = nombreCtrl.text.trim().isNotEmpty
        ? nombreCtrl.text.trim()
        : _nombreOrig;
    if (query.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.juegoFormNoBusqueda)));
      return;
    }
    setState(() => _buscandoEpic = true);
    final resultados = await EpicService.buscar(query);
    setState(() => _buscandoEpic = false);
    if (!mounted) return;
    if (resultados.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.juegoFormSinResultadosEpic)));
      return;
    }
    await _mostrarResultados(
      titulo: l10n.juegoFormResultadosEpic,
      resultados: resultados,
      nombre: (r) => r.nombre,
      portada: (r) => r.portada,
      onSeleccionar: (r) async {
        setState(() => cargando = true);
        final detalle = await EpicService.obtenerDetalle(r.id, r.namespace);
        setState(() => cargando = false);
        if (!mounted) return;
        if (detalle == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.juegoFormErrorDetalles)));
          return;
        }
        _rellenarOriginal(
          nombre: detalle.nombre,
          descripcion: detalle.descripcion,
          portada: detalle.portada,
          portadaGrid: detalle.portadaGrid,
          generos: detalle.generos,
          imagenesExtra: detalle.imagenesExtra,
        );
      },
    );
  }

  // ── F95 ──────────────────────────────────────────────────

  Future<void> _cargarF95() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() => _f95Activado = prefs.getBool('f95_activado') ?? false);
    }
  }

  Future<void> _buscarEnF95() async {
    final l10n = AppLocalizations.of(context)!;
    final query = nombreCtrl.text.trim().isNotEmpty
        ? nombreCtrl.text.trim()
        : _nombreOrig;
    if (query.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.juegoFormNoBusqueda)));
      return;
    }

    final tiene = await F95Service.tieneSesion();
    if (!mounted) return;

    if (!tiene) {
      final confirmar = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.f95Titulo),
          content: Text(l10n.f95NecesitaSesion),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.btnCancelar),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.btnConfigurar),
            ),
          ],
        ),
      );
      if (confirmar == true && mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const F95ConfigScreen()),
        );
      }
      return;
    }

    setState(() => _buscandoF95 = true);
    final resultados = await F95Service.buscar(query);
    setState(() => _buscandoF95 = false);
    if (!mounted) return;

    if (resultados.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.juegoFormSinResultadosF95)));
      return;
    }

    await _mostrarResultados(
      titulo: l10n.juegoFormResultadosF95,
      resultados: resultados,
      nombre: (r) => r.nombre,
      portada: (r) => r.portada,
      onSeleccionar: (r) async {
        setState(() => cargando = true);
        final detalle = await F95Service.obtenerDetalle(r.url);
        setState(() => cargando = false);
        if (!mounted) return;
        if (detalle == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.juegoFormErrorDetalles)));
          return;
        }
        _rellenarOriginal(
          nombre: detalle.nombre,
          descripcion: detalle.descripcion,
          portada: detalle.portada,
          portadaGrid: r.portada.isNotEmpty ? r.portada : detalle.portada,
          generos: detalle.generos,
          imagenesExtra: detalle.imagenesExtra,
        );
        if (detalle.version.isNotEmpty) {
          versionController.text = detalle.version;
        }
      },
    );
  }

  // ── IGDB ─────────────────────────────────────────────────

  Future<void> _cargarIgdb() async {
    final tiene = await IgdbService.tieneCredenciales();
    if (mounted) {
      setState(() => _igdbConfigurado = tiene);
    }
  }

  Future<void> _buscarEnIgdb() async {
    final l10n = AppLocalizations.of(context)!;
    final query = nombreCtrl.text.trim().isNotEmpty
        ? nombreCtrl.text.trim()
        : _nombreOrig;
    if (query.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.juegoFormNoBusqueda)));
      return;
    }

    if (!_igdbConfigurado) {
      final navigator = Navigator.of(context);
      final configurar = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.igdbTitulo),
          content: Text(l10n.igdbNecesitaConfiguracion),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.btnCancelar),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.btnConfigurar),
            ),
          ],
        ),
      );
      if (configurar == true) {
        await navigator.push(
          MaterialPageRoute(builder: (context) => const IgdbConfigScreen()),
        );
        _cargarIgdb();
      }
      return;
    }

    setState(() => _buscandoIgdb = true);
    final resultados = await IgdbService.buscar(query);
    setState(() => _buscandoIgdb = false);
    if (!mounted) return;

    if (resultados.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.juegoFormSinResultadosIgdb)));
      return;
    }

    await _mostrarResultados(
      titulo: l10n.juegoFormResultadosIgdb,
      resultados: resultados,
      nombre: (r) => r.nombre,
      portada: (r) => r.portada,
      onSeleccionar: (r) async {
        setState(() => cargando = true);
        final detalle = await IgdbService.obtenerDetalle(r.id);
        setState(() => cargando = false);
        if (!mounted) return;
        if (detalle == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.juegoFormErrorDetalles)));
          return;
        }
        _rellenarOriginal(
          nombre: detalle.nombre,
          descripcion: detalle.descripcion,
          portada: detalle.portada,
          portadaGrid: detalle.portadaGrid,
          generos: detalle.generos,
          imagenesExtra: detalle.imagenesExtra,
        );
      },
    );
  }

  // ── Imagen (override manual) ────────────────────────────────

  Future<void> _elegirImagen({required bool esGrid}) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (esGrid) {
          _imagenGridOverrideLocal = picked.path;
          imagenGridOverrideCtrl.clear();
          _imagenGridCropX = 0;
          _imagenGridCropY = 0;
          _imagenGridCropW = 1;
          _imagenGridCropH = 1;
        } else {
          _imagenOverrideLocal = picked.path;
          imagenOverrideCtrl.clear();
          _imagenCropX = 0;
          _imagenCropY = 0;
          _imagenCropW = 1;
          _imagenCropH = 1;
        }
      });
    }
  }

  void _quitarOverrideImagen({required bool esGrid}) {
    setState(() {
      if (esGrid) {
        _imagenGridOverrideLocal = null;
        imagenGridOverrideCtrl.clear();
        _imagenGridCropX = 0;
        _imagenGridCropY = 0;
        _imagenGridCropW = 1;
        _imagenGridCropH = 1;
      } else {
        _imagenOverrideLocal = null;
        imagenOverrideCtrl.clear();
        _imagenCropX = 0;
        _imagenCropY = 0;
        _imagenCropW = 1;
        _imagenCropH = 1;
      }
    });
  }

  Future<void> _elegirEjecutable() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['exe', 'bat', 'sh', 'app'],
      dialogTitle: l10n.juegoFormBuscarArchivo,
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        rutaEjecutableController.text = result.files.single.path!;
      });
    }
  }

  // ── Guardado de imagen en disco (cache comprimido WebP) ───────────────
  // Toma la imagen ACTUALMENTE resuelta (override si existe, si no original)
  // y la comprime/guarda. Solo tiene sentido llamarlo si el juego ya existe
  // (necesita un id estable para el nombre de archivo); si es nuevo, se hace
  // automáticamente justo después de crearlo.

  String? get _imagenDetalleResueltaUrl =>
      (_imagenOverrideLocal == null || _imagenOverrideLocal!.isEmpty)
      ? (imagenOverrideCtrl.text.isNotEmpty
            ? imagenOverrideCtrl.text
            : _imagenOrig)
      : null;

  String? get _imagenDetalleResueltaLocal =>
      (_imagenOverrideLocal != null && _imagenOverrideLocal!.isNotEmpty)
      ? _imagenOverrideLocal
      : ((imagenOverrideCtrl.text.isEmpty) ? _imagenOrigLocal : null);

  String? get _imagenGridResueltaUrl =>
      (_imagenGridOverrideLocal == null || _imagenGridOverrideLocal!.isEmpty)
      ? (imagenGridOverrideCtrl.text.isNotEmpty
            ? imagenGridOverrideCtrl.text
            : _imagenGridOrig)
      : null;

  String? get _imagenGridResueltaLocal =>
      (_imagenGridOverrideLocal != null && _imagenGridOverrideLocal!.isNotEmpty)
      ? _imagenGridOverrideLocal
      : ((imagenGridOverrideCtrl.text.isEmpty) ? _imagenGridOrigLocal : null);

  Future<void> _guardarImagenesEnCache(
    int juegoId, {
    bool mostrarSnackbar = true,
  }) async {
    if (_modoGuardadoImagen == ModoGuardadoImagen.ninguno) return;
    setState(() => _guardandoCache = true);

    final rutaGrid = await ImageCacheService.guardarImagen(
      nombreBase: '${juegoId}_grid',
      modo: _modoGuardadoImagen,
      urlRemota: _imagenGridResueltaLocal == null
          ? _imagenGridResueltaUrl
          : null,
      rutaLocalExistente: _imagenGridResueltaLocal,
    );
    final rutaDetalle = await ImageCacheService.guardarImagen(
      nombreBase: '${juegoId}_detalle',
      modo: _modoGuardadoImagen,
      urlRemota: _imagenDetalleResueltaLocal == null
          ? _imagenDetalleResueltaUrl
          : null,
      rutaLocalExistente: _imagenDetalleResueltaLocal,
    );

    if (!mounted) return;
    setState(() => _guardandoCache = false);

    if (!mostrarSnackbar) return;

    final l10n = AppLocalizations.of(context)!;
    if (rutaGrid != null || rutaDetalle != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.juegoFormCacheGuardadoOk)));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.juegoFormCacheError)));
    }
  }

  // ── Guardar ───────────────────────────────────────────────

  Future<void> guardarJuego() async {
    final l10n = AppLocalizations.of(context)!;
    final nombreEfectivo = nombreCtrl.text.trim().isNotEmpty
        ? nombreCtrl.text.trim()
        : _nombreOrig;
    if (nombreEfectivo.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.juegoFormNombreObligatorio)));
      return;
    }

    setState(() => cargando = true);

    final rutaEjecutable = rutaEjecutableController.text.isNotEmpty
        ? rutaEjecutableController.text
        : null;

    Map<String, dynamic> respuesta;
    int? idJuegoNuevo;

    if (widget.juego == null) {
      respuesta = await ApiService.crearJuego(
        nombreOrig: _nombreOrig,
        nombreOverride: nombreCtrl.text.trim().isEmpty
            ? null
            : nombreCtrl.text.trim(),
        descripcionOrig: _descripcionOrig,
        descripcionOverride: descripcionCtrl.text.isEmpty
            ? null
            : descripcionCtrl.text,
        generosOrig: _generosOrig,
        generosOverride: generosCtrl.text.isEmpty ? null : generosCtrl.text,
        imagenOrig: _imagenOrig,
        imagenOrigLocal: _imagenOrigLocal,
        imagenOverride: imagenOverrideCtrl.text.isEmpty
            ? null
            : imagenOverrideCtrl.text,
        imagenOverrideLocal: _imagenOverrideLocal,
        imagenCropX: _imagenCropX,
        imagenCropY: _imagenCropY,
        imagenCropW: _imagenCropW,
        imagenCropH: _imagenCropH,
        imagenGridOrig: _imagenGridOrig,
        imagenGridOrigLocal: _imagenGridOrigLocal,
        imagenGridOverride: imagenGridOverrideCtrl.text.isEmpty
            ? null
            : imagenGridOverrideCtrl.text,
        imagenGridOverrideLocal: _imagenGridOverrideLocal,
        imagenGridCropX: _imagenGridCropX,
        imagenGridCropY: _imagenGridCropY,
        imagenGridCropW: _imagenGridCropW,
        imagenGridCropH: _imagenGridCropH,
        version: versionController.text,
        calificacion: calificacionController.text,
        estado: estadoSeleccionado,
        usuarioId: widget.usuario.id,
        rutaEjecutable: rutaEjecutable,
        imagenesExtra: _imagenesExtra,
        catalogo: widget.catalogoInicial,
      );
      idJuegoNuevo = respuesta['id'] as int?;
    } else {
      respuesta = await ApiService.actualizarJuego(
        id: widget.juego!.id,
        nombreOrig: _nombreOrig,
        nombreOverride: nombreCtrl.text.trim().isEmpty
            ? null
            : nombreCtrl.text.trim(),
        descripcionOrig: _descripcionOrig,
        descripcionOverride: descripcionCtrl.text.isEmpty
            ? null
            : descripcionCtrl.text,
        generosOrig: _generosOrig,
        generosOverride: generosCtrl.text.isEmpty ? null : generosCtrl.text,
        imagenOrig: _imagenOrig,
        imagenOrigLocal: _imagenOrigLocal,
        imagenOverride: imagenOverrideCtrl.text.isEmpty
            ? null
            : imagenOverrideCtrl.text,
        imagenOverrideLocal: _imagenOverrideLocal,
        imagenCropX: _imagenCropX,
        imagenCropY: _imagenCropY,
        imagenCropW: _imagenCropW,
        imagenCropH: _imagenCropH,
        imagenGridOrig: _imagenGridOrig,
        imagenGridOrigLocal: _imagenGridOrigLocal,
        imagenGridOverride: imagenGridOverrideCtrl.text.isEmpty
            ? null
            : imagenGridOverrideCtrl.text,
        imagenGridOverrideLocal: _imagenGridOverrideLocal,
        imagenGridCropX: _imagenGridCropX,
        imagenGridCropY: _imagenGridCropY,
        imagenGridCropW: _imagenGridCropW,
        imagenGridCropH: _imagenGridCropH,
        version: versionController.text,
        calificacion: calificacionController.text,
        estado: estadoSeleccionado,
        rutaEjecutable: rutaEjecutable,
        imagenesExtra: _imagenesExtra,
        catalogo: widget.juego?.catalogo ?? widget.catalogoInicial,
      );
    }

    setState(() => cargando = false);
    if (!mounted) return;

    final key = respuesta['messageKey'] as String? ?? '';
    final mensaje = _traducirClave(l10n, key);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));

    if (respuesta['success'] == true) {
      final idParaCache = idJuegoNuevo ?? widget.juego?.id;
      if (idParaCache != null &&
          _modoGuardadoImagen != ModoGuardadoImagen.ninguno) {
        await _guardarImagenesEnCache(idParaCache, mostrarSnackbar: false);
      }
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  String _traducirClave(AppLocalizations l10n, String key) {
    switch (key) {
      case 'juegoFormAgregado':
        return l10n.juegoFormAgregado;
      case 'juegoFormActualizado':
        return l10n.juegoFormActualizado;
      default:
        return key;
    }
  }

  // ── Build ─────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final esEdicion = widget.juego != null;

    final estados = {
      'Pending': l10n.estadoPendiente,
      'Playing': l10n.estadoJugando,
      'Completed': l10n.estadoCompletado,
      'Abandoned': l10n.estadoAbandonado,
    };

    if (!estados.containsKey(estadoSeleccionado)) {
      estadoSeleccionado = estados.keys.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          esEdicion ? l10n.juegoFormEditarTitulo : l10n.juegoFormNuevoTitulo,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CampoConOriginal(
              controller: nombreCtrl,
              label: l10n.juegoFormNombre,
              valorOriginal: _nombreOrig,
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Text(
                  l10n.juegoFormBuscarEn,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(width: 8),
                _botonFuente(
                  label: 'Steam',
                  cargando: _buscandoSteam,
                  onTap: _buscarEnSteam,
                ),
                const SizedBox(width: 6),
                _botonFuente(
                  label: 'Epic',
                  cargando: _buscandoEpic,
                  onTap: _buscarEnEpic,
                ),
                const SizedBox(width: 6),
                _botonFuente(
                  label: 'IGDB',
                  cargando: _buscandoIgdb,
                  onTap: _buscarEnIgdb,
                ),
                if (_f95Activado) ...[
                  const SizedBox(width: 6),
                  _botonFuente(
                    label: 'F95',
                    cargando: _buscandoF95,
                    onTap: _buscarEnF95,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),

            CampoConOriginal(
              controller: descripcionCtrl,
              label: l10n.juegoFormDescripcion,
              valorOriginal: _descripcionOrig,
              maxLines: 3,
            ),
            const SizedBox(height: 12),

            // ── Imágenes: layout responsivo (2 columnas en PC, apilado en móvil) ──
            _seccionImagenes(l10n),

            const SizedBox(height: 12),
            CampoConOriginal(
              controller: generosCtrl,
              label: l10n.juegoFormGeneros,
              valorOriginal: _generosOrig,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: estadoSeleccionado,
              items: estados.entries
                  .map(
                    (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                  )
                  .toList(),
              onChanged: (v) => setState(() => estadoSeleccionado = v!),
            ),

            if (_mostrarEjecutable) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                l10n.juegoFormLanzador,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: rutaEjecutableController,
                      decoration: InputDecoration(
                        labelText: l10n.juegoFormRutaEjecutable,
                        hintText: l10n.juegoFormRutaEjecutableHint,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.folder_open),
                    tooltip: l10n.juegoFormBuscarArchivo,
                    onPressed: _elegirEjecutable,
                  ),
                  if (rutaEjecutableController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: l10n.juegoFormQuitarRuta,
                      onPressed: () =>
                          setState(() => rutaEjecutableController.clear()),
                    ),
                ],
              ),
            ],

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cargando ? null : guardarJuego,
                child: cargando
                    ? const CircularProgressIndicator()
                    : Text(
                        esEdicion
                            ? l10n.juegoFormBtnActualizar
                            : l10n.juegoFormBtnGuardar,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Sección de imágenes: responsiva (PC: 2 columnas, móvil: apilado) ──

  Widget _seccionImagenes(AppLocalizations l10n) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final esAncho = constraints.maxWidth >= 600;

        if (esAncho) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _bloqueGrid(l10n)),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _bloqueDetalle(l10n),
                    const SizedBox(height: 16),
                    _bloqueOpcionesGuardado(l10n),
                    const SizedBox(height: 12),
                    _camposVersionYCalificacion(l10n),
                  ],
                ),
              ),
            ],
          );
        }

        // Móvil: apilado vertical — Grid, luego Detalle, opciones de guardado,
        // y al final versión/calificación lado a lado (son campos cortos).
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _bloqueGrid(l10n),
            const SizedBox(height: 16),
            _bloqueDetalle(l10n),
            const SizedBox(height: 16),
            _bloqueOpcionesGuardado(l10n),
            const SizedBox(height: 12),
            _camposVersionYCalificacion(l10n),
          ],
        );
      },
    );
  }

  Widget _camposVersionYCalificacion(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: versionController,
            decoration: InputDecoration(labelText: l10n.juegoFormVersion),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: TextField(
            controller: calificacionController,
            decoration: InputDecoration(labelText: l10n.juegoFormCalificacion),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget _headerImagen(
    AppLocalizations l10n,
    String titulo,
    VoidCallback onAjustar,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            titulo,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: onAjustar,
          child: Text(
            l10n.juegoFormAjustar,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Future<void> _abrirEditorAjuste({required bool esGrid}) async {
    final url = esGrid ? _imagenGridResueltaUrl : _imagenDetalleResueltaUrl;
    final local = esGrid
        ? _imagenGridResueltaLocal
        : _imagenDetalleResueltaLocal;

    if ((url == null || url.isEmpty) && (local == null || local.isEmpty)) {
      return; // no hay imagen que ajustar
    }

    final resultado = await Navigator.push<AjusteImagen>(
      context,
      MaterialPageRoute(
        builder: (context) => EditorAjusteImagenScreen(
          imagenUrl: url,
          imagenLocal: local,
          aspectRatio: esGrid ? 2 / 3 : 16 / 6,
          modo: esGrid ? ModoAjuste.rect : ModoAjuste.foco,
          ajusteInicial: esGrid
              ? AjusteImagen(
                  offsetX: _imagenGridCropX,
                  offsetY: _imagenGridCropY,
                  cropW: _imagenGridCropW,
                  cropH: _imagenGridCropH,
                )
              : AjusteImagen(
                  offsetX: _imagenCropX,
                  offsetY: _imagenCropY,
                  cropW: _imagenCropW,
                  cropH: _imagenCropH,
                ),
        ),
      ),
    );

    if (resultado == null) return;
    setState(() {
      if (esGrid) {
        _imagenGridCropX = resultado.offsetX;
        _imagenGridCropY = resultado.offsetY;
        _imagenGridCropW = resultado.cropW;
        _imagenGridCropH = resultado.cropH;
      } else {
        _imagenCropX = resultado.offsetX;
        _imagenCropY = resultado.offsetY;
        _imagenCropW = resultado.cropW;
        _imagenCropH = resultado.cropH;
      }
    });
  }

  Widget _bloqueGrid(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerImagen(
          l10n,
          l10n.juegoFormImagenGrid,
          () => _abrirEditorAjuste(esGrid: true),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: imagenGridOverrideCtrl,
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  labelText: l10n.juegoFormUrlImagenGrid,
                  labelStyle: const TextStyle(fontSize: 11),
                  hintText: _imagenGridOrig.isNotEmpty ? _imagenGridOrig : null,
                  hintStyle: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.withValues(alpha: 0.5),
                    fontStyle: FontStyle.italic,
                  ),
                  isDense: true,
                ),
                onChanged: (_) => setState(() {
                  _imagenGridOverrideLocal = null;
                  _imagenGridCropX = 0;
                  _imagenGridCropY = 0;
                  _imagenGridCropW = 1;
                  _imagenGridCropH = 1;
                }),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.photo_library, size: 18),
              onPressed: () => _elegirImagen(esGrid: true),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ImagenConOriginal(
          overrideUrl: imagenGridOverrideCtrl.text,
          overrideLocal: _imagenGridOverrideLocal,
          origUrl: _imagenGridOrig,
          origLocal: _imagenGridOrigLocal,
          aspectRatio: 2 / 3,
          cropX: _imagenGridCropX,
          cropY: _imagenGridCropY,
          cropW: _imagenGridCropW,
          cropH: _imagenGridCropH,
          onQuitarOverride: () => _quitarOverrideImagen(esGrid: true),
        ),
      ],
    );
  }

  Widget _bloqueDetalle(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerImagen(
          l10n,
          l10n.juegoFormImagenDetalle,
          () => _abrirEditorAjuste(esGrid: false),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: imagenOverrideCtrl,
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  labelText: l10n.juegoFormUrlImagenDetalle,
                  labelStyle: const TextStyle(fontSize: 11),
                  hintText: _imagenOrig.isNotEmpty ? _imagenOrig : null,
                  hintStyle: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.withValues(alpha: 0.5),
                    fontStyle: FontStyle.italic,
                  ),
                  isDense: true,
                ),
                onChanged: (_) => setState(() {
                  _imagenOverrideLocal = null;
                  _imagenCropX = 0;
                  _imagenCropY = 0;
                  _imagenCropW = 1;
                  _imagenCropH = 1;
                }),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.photo_library, size: 18),
              onPressed: () => _elegirImagen(esGrid: false),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ImagenConOriginal(
          overrideUrl: imagenOverrideCtrl.text,
          overrideLocal: _imagenOverrideLocal,
          origUrl: _imagenOrig,
          origLocal: _imagenOrigLocal,
          aspectRatio: 16 / 6,
          cropX: _imagenCropX,
          cropY: _imagenCropY,
          cropW: _imagenCropW,
          cropH: _imagenCropH,
          modo: ModoAjuste.foco,
          onQuitarOverride: () => _quitarOverrideImagen(esGrid: false),
        ),
      ],
    );
  }

  Widget _bloqueOpcionesGuardado(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.juegoFormGuardarImagenesLocal.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: Colors.grey.shade500,
            ),
          ),
          if (_guardandoCache)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: LinearProgressIndicator(),
            ),
          RadioGroup<ModoGuardadoImagen>(
            groupValue: _modoGuardadoImagen,
            onChanged: (v) => setState(() => _modoGuardadoImagen = v!),
            child: Column(
              children: [
                RadioListTile<ModoGuardadoImagen>(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.juegoFormModoNinguno,
                    style: const TextStyle(fontSize: 13),
                  ),
                  value: ModoGuardadoImagen.ninguno,
                ),
                RadioListTile<ModoGuardadoImagen>(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.juegoFormModoOriginal,
                    style: const TextStyle(fontSize: 13),
                  ),
                  value: ModoGuardadoImagen.original,
                ),
                RadioListTile<ModoGuardadoImagen>(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.juegoFormModoComprimido,
                    style: const TextStyle(fontSize: 13),
                  ),
                  value: ModoGuardadoImagen.comprimido,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
