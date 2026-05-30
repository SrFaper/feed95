import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/juego.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import '../services/gog_service.dart';
import '../services/epic_service.dart';
import '../services/steam_service.dart';

class JuegoFormScreen extends StatefulWidget {
  final Usuario usuario;
  final Juego? juego;

  const JuegoFormScreen({super.key, required this.usuario, this.juego});

  @override
  State<JuegoFormScreen> createState() => _JuegoFormScreenState();
}

class _JuegoFormScreenState extends State<JuegoFormScreen> {
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final imagenController = TextEditingController();
  final versionController = TextEditingController();
  final calificacionController = TextEditingController();
  final generosController = TextEditingController();
  final rutaEjecutableController = TextEditingController();
  String estadoSeleccionado = 'Pendiente';
  String? _imagenLocal;
  bool cargando = false;
  bool _buscandoSteam = false;
  bool _buscandoGog = false;
  bool _buscandoEpic = false;

  final List<String> estados = [
    'Pendiente', 'Jugando', 'Completado', 'Abandonado',
  ];

  bool get _mostrarEjecutable =>
      !kIsWeb && (Platform.isWindows || Platform.isLinux);

  @override
  void initState() {
    super.initState();
    if (widget.juego != null) {
      nombreController.text = widget.juego!.nombre;
      descripcionController.text = widget.juego!.descripcion;
      imagenController.text = widget.juego!.imagen;
      versionController.text = widget.juego!.version;
      calificacionController.text = widget.juego!.calificacion.toString();
      generosController.text = widget.juego!.generos;
      estadoSeleccionado = widget.juego!.estado;
      _imagenLocal = widget.juego!.imagenLocal;
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

  Widget _vistaPrevia() {
    if (_imagenLocal != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(_imagenLocal!),
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }
    if (imagenController.text.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imagenController.text,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const SizedBox(),
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
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.videogame_asset),
                        ),
                      )
                    : const Icon(Icons.videogame_asset),
                title: Text(nombre(r),
                    style: const TextStyle(fontSize: 14)),
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
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _rellenarCampos({
    required String nombre,
    required String descripcion,
    required String portada,
    required String generos,
  }) {
    setState(() {
      nombreController.text = nombre;
      descripcionController.text = descripcion;
      imagenController.text = portada;
      generosController.text = generos;
      _imagenLocal = null;
    });
  }

  // ── Steam ─────────────────────────────────────────────────

  Future<void> _buscarEnSteam() async {
    final query = nombreController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe un nombre para buscar')),
      );
      return;
    }
    setState(() => _buscandoSteam = true);
    final resultados = await SteamService.buscar(query);
    setState(() => _buscandoSteam = false);
    if (!mounted) return;
    if (resultados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontraron resultados en Steam')),
      );
      return;
    }
    await _mostrarResultados(
      titulo: 'Resultados en Steam',
      resultados: resultados,
      nombre: (r) => r.nombre,
      portada: (r) => r.portada,
      onSeleccionar: (r) async {
        setState(() => cargando = true);
        final detalle = await SteamService.obtenerDetalle(r.appId);
        setState(() => cargando = false);
        if (!mounted) return;
        if (detalle == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudieron obtener los detalles')),
          );
          return;
        }
        _rellenarCampos(
          nombre: detalle.nombre,
          descripcion: detalle.descripcion,
          portada: detalle.portada,
          generos: detalle.generos,
        );
      },
    );
  }

  // ── GOG ───────────────────────────────────────────────────

  Future<void> _buscarEnGog() async {
    final query = nombreController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe un nombre para buscar')),
      );
      return;
    }
    setState(() => _buscandoGog = true);
    final resultados = await GogService.buscar(query);
    setState(() => _buscandoGog = false);
    if (!mounted) return;
    if (resultados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontraron resultados en GOG')),
      );
      return;
    }
    await _mostrarResultados(
      titulo: 'Resultados en GOG',
      resultados: resultados,
      nombre: (r) => r.nombre,
      portada: (r) => r.portada,
      onSeleccionar: (r) async {
        setState(() => cargando = true);
        final detalle = await GogService.obtenerDetalle(r.id);
        setState(() => cargando = false);
        if (!mounted) return;
        if (detalle == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudieron obtener los detalles')),
          );
          return;
        }
        _rellenarCampos(
          nombre: detalle.nombre,
          descripcion: detalle.descripcion,
          portada: detalle.portada,
          generos: detalle.generos,
        );
      },
    );
  }

  // ── Epic ──────────────────────────────────────────────────

  Future<void> _buscarEnEpic() async {
    final query = nombreController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe un nombre para buscar')),
      );
      return;
    }
    setState(() => _buscandoEpic = true);
    final resultados = await EpicService.buscar(query);
    setState(() => _buscandoEpic = false);
    if (!mounted) return;
    if (resultados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontraron resultados en Epic')),
      );
      return;
    }
    await _mostrarResultados(
      titulo: 'Resultados en Epic Games',
      resultados: resultados,
      nombre: (r) => r.nombre,
      portada: (r) => r.portada,
      onSeleccionar: (r) async {
        setState(() => cargando = true);
        final detalle = await EpicService.obtenerDetalle(r.id, r.namespace);
        setState(() => cargando = false);
        if (!mounted) return;
        if (detalle == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudieron obtener los detalles')),
          );
          return;
        }
        _rellenarCampos(
          nombre: detalle.nombre,
          descripcion: detalle.descripcion,
          portada: detalle.portada,
          generos: detalle.generos,
        );
      },
    );
  }

  // ── Imagen ────────────────────────────────────────────────

  Future<void> _elegirImagen() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imagenLocal = picked.path;
        imagenController.clear();
      });
    }
  }

  Future<void> _elegirEjecutable() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['exe', 'bat', 'sh', 'app'],
      dialogTitle: 'Seleccionar ejecutable',
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        rutaEjecutableController.text = result.files.single.path!;
      });
    }
  }

  // ── Guardar ───────────────────────────────────────────────

  Future<void> guardarJuego() async {
    if (nombreController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre es obligatorio')),
      );
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
        imagen: imagenController.text,
        imagenLocal: _imagenLocal,
        version: versionController.text,
        calificacion: calificacionController.text,
        generos: generosController.text,
        estado: estadoSeleccionado,
        usuarioId: widget.usuario.id,
        rutaEjecutable: rutaEjecutable,
      );
    } else {
      respuesta = await ApiService.actualizarJuego(
        id: widget.juego!.id,
        nombre: nombreController.text,
        descripcion: descripcionController.text,
        imagen: imagenController.text,
        imagenLocal: _imagenLocal,
        version: versionController.text,
        calificacion: calificacionController.text,
        generos: generosController.text,
        estado: estadoSeleccionado,
        rutaEjecutable: rutaEjecutable,
      );
    }

    setState(() => cargando = false);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(respuesta['message'])),
    );

    if (respuesta['success'] == true) {
      Navigator.pop(context);
    }
  }

  // ── Build ─────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.juego != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion ? 'Editar juego' : 'Nuevo juego'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre *'),
            ),
            const SizedBox(height: 8),

            // Botones de fuentes
            Row(
              children: [
                const Text('Buscar en:',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(width: 8),
                _botonFuente(
                  label: 'Steam',
                  cargando: _buscandoSteam,
                  onTap: _buscarEnSteam,
                ),
                const SizedBox(width: 6),
                _botonFuente(
                  label: 'GOG',
                  cargando: _buscandoGog,
                  onTap: _buscarEnGog,
                ),
                const SizedBox(width: 6),
                _botonFuente(
                  label: 'Epic',
                  cargando: _buscandoEpic,
                  onTap: _buscarEnEpic,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Descripción
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),

            // Vista previa imagen
            _vistaPrevia(),
            if (_imagenLocal != null || imagenController.text.isNotEmpty)
              const SizedBox(height: 8),

            // URL imagen + galería
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: imagenController,
                    decoration:
                        const InputDecoration(labelText: 'URL de imagen'),
                    onChanged: (_) => setState(() => _imagenLocal = null),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.photo_library),
                  tooltip: 'Elegir desde galería',
                  onPressed: _elegirImagen,
                ),
                if (_imagenLocal != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'Quitar imagen',
                    onPressed: () => setState(() => _imagenLocal = null),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            TextField(
              controller: versionController,
              decoration: const InputDecoration(labelText: 'Versión'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: calificacionController,
              decoration: const InputDecoration(
                  labelText: 'Calificación (1-10)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: generosController,
              decoration: const InputDecoration(labelText: 'Géneros'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: estadoSeleccionado,
              decoration: const InputDecoration(labelText: 'Estado'),
              items: estados
                  .map((e) =>
                      DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) =>
                  setState(() => estadoSeleccionado = v!),
            ),

            // Lanzador — solo Windows/Linux
            if (_mostrarEjecutable) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 8),
              const Text('Lanzador',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: rutaEjecutableController,
                      decoration: const InputDecoration(
                        labelText: 'Ruta del ejecutable',
                        hintText: 'C:\\juegos\\myjuego.exe',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.folder_open),
                    tooltip: 'Buscar archivo',
                    onPressed: _elegirEjecutable,
                  ),
                  if (rutaEjecutableController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: 'Quitar ruta',
                      onPressed: () => setState(
                          () => rutaEjecutableController.clear()),
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
                    : Text(esEdicion ? 'Actualizar' : 'Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}