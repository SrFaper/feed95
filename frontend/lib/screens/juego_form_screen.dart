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
import 'f95_config_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/igdb_service.dart';
import 'igdb_config_screen.dart';
import 'package:frontend/l10n/app_localizations.dart';

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
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final versionController = TextEditingController();
  final calificacionController = TextEditingController();
  final generosController = TextEditingController();
  final rutaEjecutableController = TextEditingController();
  final imagenDetalleController = TextEditingController();
  final imagenGridController = TextEditingController();
  String? _imagenDetalleLocal;
  String? _imagenGridLocal;
  String _imagenesExtra = '';
  String estadoSeleccionado = 'Pending';
  bool cargando = false;
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
      nombreController.text = widget.juego!.nombre;
      descripcionController.text = widget.juego!.descripcion;
      versionController.text = widget.juego!.version;
      calificacionController.text = widget.juego!.calificacion.toString();
      generosController.text = widget.juego!.generos;
      estadoSeleccionado = widget.juego!.estado;
      imagenDetalleController.text = widget.juego!.imagen;
      imagenGridController.text = widget.juego!.imagenGrid;
      _imagenDetalleLocal = widget.juego!.imagenLocal;
      _imagenGridLocal = widget.juego!.imagenGridLocal;
      _imagenesExtra = widget.juego!.imagenesExtra;
      rutaEjecutableController.text = widget.juego!.rutaEjecutable ?? '';
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

  Widget _vistaPrevia(String url, String? local) {
    if (local != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(local),
          height: 120,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }
    if (url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          url,
          height: 120,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const SizedBox(),
        ),
      );
    }
    return const SizedBox();
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

  void _rellenarCampos({
    required String nombre,
    required String descripcion,
    required String portada,
    required String portadaGrid,
    required String generos,
    String imagenesExtra = '',
  }) {
    setState(() {
      nombreController.text = nombre;
      descripcionController.text = descripcion;
      imagenDetalleController.text = portada;
      imagenGridController.text = portadaGrid;
      generosController.text = generos;
      _imagenDetalleLocal = null;
      _imagenGridLocal = null;
      _imagenesExtra = imagenesExtra;
    });
  }

  // ── Steam ─────────────────────────────────────────────────

  Future<void> _buscarEnSteam() async {
    final l10n = AppLocalizations.of(context)!;
    final query = nombreController.text.trim();
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
        _rellenarCampos(
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
    final query = nombreController.text.trim();
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
        _rellenarCampos(
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
    final query = nombreController.text.trim();
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
        _rellenarCampos(
          nombre: detalle.nombre,
          descripcion: detalle.descripcion,
          portada: detalle.portada,
          portadaGrid: r.portada.isNotEmpty ? r.portada : detalle.portada,
          generos: detalle.generos,
          imagenesExtra: detalle.imagenesExtra,
        );
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
    final query = nombreController.text.trim();
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
        _rellenarCampos(
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

  // ── Imagen ────────────────────────────────────────────────

  Future<void> _elegirImagen({required bool esGrid}) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (esGrid) {
          _imagenGridLocal = picked.path;
          imagenGridController.clear();
        } else {
          _imagenDetalleLocal = picked.path;
          imagenDetalleController.clear();
        }
      });
    }
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

  // ── Guardar ───────────────────────────────────────────────

  Future<void> guardarJuego() async {
    final l10n = AppLocalizations.of(context)!;
    if (nombreController.text.isEmpty) {
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

    if (widget.juego == null) {
      respuesta = await ApiService.crearJuego(
        nombre: nombreController.text,
        descripcion: descripcionController.text,
        imagen: imagenDetalleController.text,
        imagenLocal: _imagenDetalleLocal,
        imagenGrid: imagenGridController.text,
        imagenGridLocal: _imagenGridLocal,
        imagenesExtra: _imagenesExtra,
        version: versionController.text,
        calificacion: calificacionController.text,
        generos: generosController.text,
        estado: estadoSeleccionado,
        usuarioId: widget.usuario.id,
        rutaEjecutable: rutaEjecutable,
        catalogo: widget.catalogoInicial,
      );
    } else {
      respuesta = await ApiService.actualizarJuego(
        id: widget.juego!.id,
        nombre: nombreController.text,
        descripcion: descripcionController.text,
        imagen: imagenDetalleController.text,
        imagenLocal: _imagenDetalleLocal,
        imagenGrid: imagenGridController.text,
        imagenGridLocal: _imagenGridLocal,
        imagenesExtra: _imagenesExtra,
        version: versionController.text,
        calificacion: calificacionController.text,
        generos: generosController.text,
        estado: estadoSeleccionado,
        rutaEjecutable: rutaEjecutable,
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

    // Los estados se leen del l10n para que el dropdown también esté traducido
    final estados = {
      'Pending': l10n.estadoPendiente,
      'Playing': l10n.estadoJugando,
      'Completed': l10n.estadoCompletado,
      'Abandoned': l10n.estadoAbandonado,
    };

    // Asegurar que el estado guardado tenga equivalente en el idioma actual
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
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: l10n.juegoFormNombre),
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

            TextField(
              controller: descripcionController,
              decoration: InputDecoration(labelText: l10n.juegoFormDescripcion),
              maxLines: 3,
            ),
            const SizedBox(height: 12),

            Text(
              l10n.juegoFormImagenDetalle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            _vistaPrevia(imagenDetalleController.text, _imagenDetalleLocal),
            if (_imagenDetalleLocal != null ||
                imagenDetalleController.text.isNotEmpty)
              const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: imagenDetalleController,
                    decoration: InputDecoration(
                      labelText: l10n.juegoFormUrlImagenDetalle,
                    ),
                    onChanged: (_) =>
                        setState(() => _imagenDetalleLocal = null),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.photo_library),
                  onPressed: () => _elegirImagen(esGrid: false),
                ),
                if (_imagenDetalleLocal != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _imagenDetalleLocal = null),
                  ),
              ],
            ),

            const SizedBox(height: 12),
            Text(
              l10n.juegoFormImagenGrid,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            _vistaPrevia(imagenGridController.text, _imagenGridLocal),
            if (_imagenGridLocal != null ||
                imagenGridController.text.isNotEmpty)
              const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: imagenGridController,
                    decoration: InputDecoration(
                      labelText: l10n.juegoFormUrlImagenGrid,
                    ),
                    onChanged: (_) => setState(() => _imagenGridLocal = null),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.photo_library),
                  onPressed: () => _elegirImagen(esGrid: true),
                ),
                if (_imagenGridLocal != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _imagenGridLocal = null),
                  ),
              ],
            ),

            const SizedBox(height: 12),
            TextField(
              controller: versionController,
              decoration: InputDecoration(labelText: l10n.juegoFormVersion),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: calificacionController,
              decoration: InputDecoration(
                labelText: l10n.juegoFormCalificacion,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: generosController,
              decoration: InputDecoration(labelText: l10n.juegoFormGeneros),
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
}
