import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/juego.dart';
import '../models/usuario.dart';
import '../models/categoria.dart';
import '../services/api_service.dart';
import 'juego_form_screen.dart';
import 'juego_detalle_screen.dart';
import 'package:frontend/l10n/app_localizations.dart';
import '../widgets/imagen_ajustada.dart';

class JuegosScreen extends StatefulWidget {
  final Usuario usuario;

  const JuegosScreen({super.key, required this.usuario});

  @override
  State<JuegosScreen> createState() => _JuegosScreenState();
}

class _JuegosScreenState extends State<JuegosScreen> {
  List<Juego> juegos = [];
  List<Categoria> categorias = [];
  bool cargando = true;
  bool panelAbierto = false;
  bool _modosExtrasActivos = false;
  int catalogoActual = 0;
  String busqueda = '';
  String? filtroEstado;
  int? filtroCategoria;
  bool _modoReorden = false;
  bool _reordenEnGrid = false;
  final TextEditingController _busquedaController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _precargadoHasta = 0;
  static const int _lotePrecargado = 40;

  String nombreCatalogoSecundario = 'NSFW';

  @override
  void initState() {
    super.initState();
    _cargarModosExtras();
    _scrollController.addListener(_onScroll);
    cargarTodo();
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    _scrollController.dispose();
    PaintingBinding.instance.imageCache.clearLiveImages();
    super.dispose();
  }

  // ── Precargado inteligente ────────────────────────────────────────────────

  ImageProvider? _providerGrid(Juego j) {
    final local = j.imagenGridLocal?.isNotEmpty == true
        ? j.imagenGridLocal
        : (j.imagenLocal?.isNotEmpty == true ? j.imagenLocal : null);
    if (local != null) return FileImage(File(local));
    final url = j.imagenGrid.isNotEmpty
        ? j.imagenGrid
        : (j.imagen.isNotEmpty ? j.imagen : null);
    if (url != null) return NetworkImage(url);
    return null;
  }

  ImageProvider? _providerDetalle(Juego j) {
    final local = j.imagenLocal?.isNotEmpty == true ? j.imagenLocal : null;
    if (local != null) return FileImage(File(local));
    final url = j.imagen.isNotEmpty ? j.imagen : null;
    if (url != null) return NetworkImage(url);
    return null;
  }

  void _precargarRango(List<Juego> lista, int desde, int hasta) {
    final fin = hasta.clamp(0, lista.length);
    for (int i = desde; i < fin; i++) {
      final provider = _providerGrid(lista[i]);
      if (provider != null) {
        unawaited(precacheImage(provider, context).catchError((_) {}));
      }
    }
  }

  void _onScroll() {
    if (!mounted || _modoReorden) return;
    final sc = _scrollController;
    if (!sc.hasClients) return;
    final umbral = sc.position.maxScrollExtent - 600;
    if (sc.position.pixels < umbral) return;
    final lista = juegosFiltrados;
    if (_precargadoHasta >= lista.length) return;
    final desde = _precargadoHasta;
    final hasta = desde + _lotePrecargado;
    _precargadoHasta = hasta.clamp(0, lista.length);
    _precargarRango(lista, desde, hasta);
  }

  void _precargadoInicial() {
    if (!mounted) return;
    _precargadoHasta = 0;
    final lista = juegosFiltrados;
    _precargadoHasta = _lotePrecargado.clamp(0, lista.length);
    _precargarRango(lista, 0, _precargadoHasta);
  }

  void _precargarDetalle(Juego j) {
    final provider = _providerDetalle(j);
    if (provider != null) {
      unawaited(precacheImage(provider, context).catchError((_) {}));
    }
  }

  // ── Carga de datos ────────────────────────────────────────────────────────

  Future<void> _cargarModosExtras() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _modosExtrasActivos = prefs.getBool('f95_activado') ?? false;
      });
    }
  }

  Future<void> cargarTodo() async {
    setState(() => cargando = true);
    juegos = await ApiService.obtenerJuegos(
      widget.usuario.id,
      catalogo: catalogoActual,
    );
    categorias = await ApiService.obtenerCategorias(
      widget.usuario.id,
      catalogoActual,
    );
    setState(() => cargando = false);
    WidgetsBinding.instance.addPostFrameCallback((_) => _precargadoInicial());
  }

  // ── Filtrado con búsqueda extendida ───────────────────────────────────────

  /// Parsea el texto de búsqueda en grupos AND separados por coma.
  /// Dentro de cada grupo, los términos separados por | son OR entre sí.
  ///
  /// Ejemplo: "Netorare, Sandbox | Character Creation, Violence"
  ///   → grupo 1: ["Netorare"]           (AND con el resto)
  ///   → grupo 2: ["Sandbox", "Character Creation"]  (OR interno)
  ///   → grupo 3: ["Violence"]           (AND con el resto)
  ///
  /// El juego debe satisfacer TODOS los grupos. Dentro de cada grupo basta
  /// con que nombre o géneros contengan AL MENOS UNO de los términos.
  bool _coincideBusqueda(Juego j, String query) {
    if (query.isEmpty) return true;
    final nombreLow = j.nombre.toLowerCase();
    final generosLow = j.generos.toLowerCase();

    // Dividir por coma → grupos AND
    final grupos = query
        .split(',')
        .map((g) => g.trim())
        .where((g) => g.isNotEmpty)
        .toList();

    for (final grupo in grupos) {
      // Dentro de cada grupo, dividir por | → términos OR
      final terminos = grupo
          .split('|')
          .map((t) => t.trim().toLowerCase())
          .where((t) => t.isNotEmpty)
          .toList();

      if (terminos.isEmpty) continue;

      // El juego debe satisfacer al menos uno de los términos del grupo
      final satisfaceGrupo = terminos.any(
        (t) => nombreLow.contains(t) || generosLow.contains(t),
      );

      if (!satisfaceGrupo) return false;
    }
    return true;
  }

  List<Juego> get juegosFiltrados {
    return juegos.where((j) {
      final matchBusqueda = _coincideBusqueda(j, busqueda);
      final matchEstado = filtroEstado == null || j.estado == filtroEstado;
      // Filtro de categoría: el juego debe tener la categoría entre sus categorías
      final matchCategoria =
          filtroCategoria == null || j.categorias.contains(filtroCategoria);
      return matchBusqueda && matchEstado && matchCategoria;
    }).toList();
  }

  // ── Categorías ────────────────────────────────────────────────────────────

  Future<void> _mostrarDialogoCategoria({Categoria? editar}) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: editar?.nombre ?? '');
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          editar == null
              ? l10n.categoriaNuevaTitulo
              : l10n.categoriaEditarTitulo,
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: l10n.categoriaNombreLabel),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.btnCancelar),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isEmpty) return;
              final navigator = Navigator.of(context);
              if (editar == null) {
                await ApiService.crearCategoria(
                  nombre: controller.text,
                  usuarioId: widget.usuario.id,
                  catalogo: catalogoActual,
                );
              } else {
                await ApiService.editarCategoria(
                  id: editar.id,
                  nombre: controller.text,
                );
              }
              if (!mounted) return;
              navigator.pop();
              cargarTodo();
            },
            child: Text(l10n.btnGuardar),
          ),
        ],
      ),
    );
  }

  Future<void> _eliminarCategoria(Categoria cat) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.categoriaEliminarTitulo),
        content: Text(l10n.categoriaEliminarContenido(cat.nombre)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.btnCancelar),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.btnEliminar,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (confirmar == true) {
      await ApiService.eliminarCategoria(cat.id);
      if (filtroCategoria == cat.id) {
        setState(() => filtroCategoria = null);
      }
      cargarTodo();
    }
  }

  // ── Dialog de acción rápida ───────────────────────────────────────────────

  Future<void> _mostrarDialogoAccionRapida(Juego juego) async {
    final l10n = AppLocalizations.of(context)!;
    final primary = Theme.of(context).colorScheme.primary;

    // Estado local del dialog — no afecta al widget padre hasta confirmar
    String estadoLocal = juego.estado;
    final calCtrl = TextEditingController(
      text: juego.calificacion > 0 ? '${juego.calificacion}' : '',
    );
    // Copia local de categorías para que los chips respondan sin await
    final List<int> categoriasLocal = List.from(juego.categorias);

    final estados = {
      'Pending': l10n.estadoPendiente,
      'Playing': l10n.estadoJugando,
      'Completed': l10n.estadoCompletado,
      'Abandoned': l10n.estadoAbandonado,
    };

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(
              juego.nombre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            content: SizedBox(
              width: 360,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Estado ──────────────────────────────────────────────
                    _labelSeccion('Estado'),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: estadoLocal,
                      isDense: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      items: estados.entries
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.key,
                              child: Text(e.value),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setDialogState(() => estadoLocal = v);
                      },
                    ),

                    const SizedBox(height: 14),
                    const Divider(height: 1),
                    const SizedBox(height: 14),

                    // ── Calificación ─────────────────────────────────────────
                    _labelSeccion('Calificación (1-10)'),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: calCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              hintText: '0 = sin calificación',
                            ),
                            onSubmitted: (_) {
                              // Enter cierra el teclado pero no el dialog
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                      ],
                    ),

                    if (categorias.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      const Divider(height: 1),
                      const SizedBox(height: 14),

                      // ── Categorías ────────────────────────────────────────
                      _labelSeccion('Categorías'),
                      const SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 220),
                        child: SingleChildScrollView(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: categorias.map((cat) {
                              final activa = categoriasLocal.contains(cat.id);
                              return _ChipCategoria(
                                nombre: cat.nombre,
                                activa: activa,
                                color: primary,
                                onTap: () async {
                                  setDialogState(() {
                                    if (activa) {
                                      categoriasLocal.remove(cat.id);
                                    } else {
                                      categoriasLocal.add(cat.id);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.btnCancelar),
              ),
              ElevatedButton(
                onPressed: () async {
                  final cal = (int.tryParse(calCtrl.text) ?? 0).clamp(0, 10);
                  // Guardar estado y calificación
                  await ApiService.actualizarEstadoYCalificacion(
                    id: juego.id,
                    estado: estadoLocal,
                    calificacion: cal,
                  );
                  // Guardar categorías
                  await ApiService.sincronizarCategorias(
                    juego.id,
                    categoriasLocal,
                  );
                  if (context.mounted) Navigator.pop(context);
                },
                child: Text(l10n.btnGuardar),
              ),
            ],
          );
        },
      ),
    );

    // Recargar para reflejar cambios en el grid
    cargarTodo();
  }

  Widget _labelSeccion(String texto) {
    return Text(
      texto.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.8,
        color: Colors.grey.shade500,
      ),
    );
  }

  // ── Reordenamiento ────────────────────────────────────────────────────────

  Future<void> _moverJuegoAPosicion(
    List<Juego> lista,
    int juegoIndex,
    int nuevaPosicion1Based,
  ) async {
    final total = lista.length;
    final destino = nuevaPosicion1Based.clamp(1, total) - 1;
    if (destino == juegoIndex) return;
    final item = lista.removeAt(juegoIndex);
    lista.insert(destino, item);
    setState(() {});
    await ApiService.guardarOrden(juegos.map((j) => j.id).toList());
  }

  Future<void> _intercambiarEnGrid(int fromIndex, int toIndex) async {
    if (fromIndex == toIndex) return;
    setState(() {
      final item = juegos.removeAt(fromIndex);
      juegos.insert(toIndex, item);
    });
    await ApiService.guardarOrden(juegos.map((j) => j.id).toList());
  }

  // ── Panel lateral ─────────────────────────────────────────────────────────

  Widget _panelLateral() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: 220,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              controller: _busquedaController,
              decoration: InputDecoration(
                hintText: l10n.catalogoBuscar,
                prefixIcon: const Icon(Icons.search, size: 18),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: busqueda.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: () {
                          _busquedaController.clear();
                          setState(() {
                            busqueda = '';
                            _precargadoHasta = 0;
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (v) => setState(() {
                busqueda = v;
                _precargadoHasta = 0;
              }),
            ),
          ),
          // Hint de sintaxis de búsqueda
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 12, 8),
            child: Text(
              ', = AND   |  = OR',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade400,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              l10n.catalogoSeccionEstado,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _itemFiltro(
            label: l10n.catalogoFiltroTodos,
            seleccionado: filtroEstado == null,
            onTap: () => setState(() {
              filtroEstado = null;
              _precargadoHasta = 0;
            }),
          ),
          for (final entry in {
            'Pending': l10n.estadoPendiente,
            'Playing': l10n.estadoJugando,
            'Completed': l10n.estadoCompletado,
            'Abandoned': l10n.estadoAbandonado,
          }.entries)
            _itemFiltro(
              label: entry.value,
              seleccionado: filtroEstado == entry.key,
              onTap: () => setState(() {
                filtroEstado = filtroEstado == entry.key ? null : entry.key;
                _precargadoHasta = 0;
              }),
            ),
          const Divider(indent: 12, endIndent: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.catalogoSeccionCategorias,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 16),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => _mostrarDialogoCategoria(),
                ),
              ],
            ),
          ),
          _itemFiltro(
            label: l10n.catalogoFiltroTodas,
            seleccionado: filtroCategoria == null,
            onTap: () => setState(() {
              filtroCategoria = null;
              _precargadoHasta = 0;
            }),
          ),
          Expanded(
            child: ListView(
              children: categorias.map((cat) => _itemCategoria(cat)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemFiltro({
    required String label,
    required bool seleccionado,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: seleccionado
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
            : null,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: seleccionado ? FontWeight.bold : FontWeight.normal,
            color: seleccionado ? Theme.of(context).colorScheme.primary : null,
          ),
        ),
      ),
    );
  }

  Widget _itemCategoria(Categoria cat) {
    final seleccionada = filtroCategoria == cat.id;
    return InkWell(
      onTap: () => setState(() {
        filtroCategoria = seleccionada ? null : cat.id;
        _precargadoHasta = 0;
      }),
      onLongPress: () => _mostrarMenuCategoria(cat),
      onSecondaryTap: () => _mostrarMenuCategoria(cat),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: seleccionada
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
            : null,
        child: Row(
          children: [
            if (cat.imagen != null && cat.imagen!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    cat.imagen!,
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        const Icon(Icons.folder, size: 16),
                  ),
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.folder, size: 16),
              ),
            Expanded(
              child: Text(
                cat.nombre,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: seleccionada
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: seleccionada
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarMenuCategoria(Categoria cat) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text(l10n.btnEditar),
            onTap: () {
              Navigator.pop(context);
              _mostrarDialogoCategoria(editar: cat);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: Text(
              l10n.btnEliminar,
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              _eliminarCategoria(cat);
            },
          ),
        ],
      ),
    );
  }

  // ── Vistas ────────────────────────────────────────────────────────────────

  Widget _vistaGrid(List<Juego> lista) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      cacheExtent: 400,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: lista.length,
      itemBuilder: (context, index) {
        final juego = lista[index];
        return _TarjetaJuego(
          juego: juego,
          onTap: () async {
            _precargarDetalle(juego);
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    JuegoDetalleScreen(juego: juego, usuario: widget.usuario),
              ),
            );
            cargarTodo();
          },
          onAccionRapida: () => _mostrarDialogoAccionRapida(juego),
        );
      },
    );
  }

  Widget _vistaReordenLista(List<Juego> lista) {
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      cacheExtent: 200,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: lista.length,
      onReorder: (oldIndex, newIndex) async {
        if (newIndex > oldIndex) newIndex--;
        setState(() {
          final item = lista.removeAt(oldIndex);
          lista.insert(newIndex, item);
        });
        await ApiService.guardarOrden(juegos.map((j) => j.id).toList());
      },
      itemBuilder: (context, index) {
        final juego = lista[index];
        return Container(
          key: ValueKey(juego.id),
          child: ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _InputPosicion(
                  posicionActual: index + 1,
                  total: lista.length,
                  onConfirmar: (nuevaPos) =>
                      _moverJuegoAPosicion(lista, index, nuevaPos),
                ),
                const SizedBox(width: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    width: 40,
                    height: 56,
                    child: _ImagenJuego(juego: juego),
                  ),
                ),
              ],
            ),
            title: Text(juego.nombre),
            subtitle: Text(
              '${traducirEstadoJuego(juego.estado, context)}${juego.version.isNotEmpty ? ' · v${juego.version}' : ''}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (juego.calificacion > 0)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          '${juego.calificacion}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ReorderableDragStartListener(
                  index: index,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.grab,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(Icons.drag_handle, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      JuegoDetalleScreen(juego: juego, usuario: widget.usuario),
                ),
              );
              cargarTodo();
            },
          ),
        );
      },
    );
  }

  Widget _vistaReordenGrid(List<Juego> lista) {
    return _ReordenGrid(
      juegos: lista,
      onReorder: _intercambiarEnGrid,
      onMoverAPosicion: (index, nuevaPos) =>
          _moverJuegoAPosicion(lista, index, nuevaPos),
      onTapJuego: (juego) async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                JuegoDetalleScreen(juego: juego, usuario: widget.usuario),
          ),
        );
        cargarTodo();
      },
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final juegosMostrados = _modoReorden ? juegos : juegosFiltrados;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          catalogoActual == 0 ? l10n.catalogoTitulo : nombreCatalogoSecundario,
        ),
        actions: [
          if (_modoReorden) ...[
            IconButton(
              icon: Icon(_reordenEnGrid ? Icons.view_list : Icons.grid_view),
              tooltip: _reordenEnGrid
                  ? l10n.catalogoTooltipVistaLista
                  : l10n.catalogoTooltipVistaGrid,
              onPressed: () => setState(() => _reordenEnGrid = !_reordenEnGrid),
            ),
          ] else ...[
            IconButton(
              icon: Icon(panelAbierto ? Icons.menu_open : Icons.menu),
              tooltip: l10n.catalogoTooltipFiltros,
              onPressed: () => setState(() => panelAbierto = !panelAbierto),
            ),
          ],
          IconButton(
            icon: Icon(
              _modoReorden ? Icons.dashboard_customize_sharp : Icons.swap_vert,
            ),
            tooltip: _modoReorden
                ? l10n.catalogoTooltipVerCatalogo
                : l10n.catalogoTooltipReordenar,
            onPressed: () => setState(() => _modoReorden = !_modoReorden),
          ),
          if (_modosExtrasActivos)
            IconButton(
              icon: Icon(
                catalogoActual == 0 ? Icons.lock_open : Icons.lock,
                color: catalogoActual == 1
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              tooltip: catalogoActual == 0
                  ? l10n.catalogoTooltipCatalogoSecundario(
                      nombreCatalogoSecundario,
                    )
                  : l10n.catalogoTooltipCatalogoPrincipal,
              onPressed: () {
                setState(() {
                  catalogoActual = catalogoActual == 0 ? 1 : 0;
                  filtroCategoria = null;
                  filtroEstado = null;
                  busqueda = '';
                  _busquedaController.clear();
                  _precargadoHasta = 0;
                });
                cargarTodo();
              },
            ),
        ],
      ),
      floatingActionButton: _modoReorden
          ? null
          : FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JuegoFormScreen(
                      usuario: widget.usuario,
                      catalogoInicial: catalogoActual,
                    ),
                  ),
                );
                cargarTodo();
              },
              child: const Icon(Icons.add),
            ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                if (!_modoReorden)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: panelAbierto ? 220 : 0,
                    child: panelAbierto
                        ? ClipRect(child: _panelLateral())
                        : const SizedBox.shrink(),
                  ),
                Expanded(
                  child: juegosMostrados.isEmpty
                      ? Center(
                          child: Text(
                            _modoReorden
                                ? l10n.catalogoReordenarVacio
                                : (busqueda.isNotEmpty ||
                                          filtroEstado != null ||
                                          filtroCategoria != null
                                      ? l10n.catalogoVacioFiltros
                                      : l10n.catalogoVacio),
                          ),
                        )
                      : _modoReorden
                      ? (_reordenEnGrid
                            ? _vistaReordenGrid(juegosMostrados)
                            : _vistaReordenLista(juegosMostrados))
                      : _vistaGrid(juegosMostrados),
                ),
              ],
            ),
    );
  }
}

// ── Chip de categoría para el Dialog ─────────────────────────────────────────

class _ChipCategoria extends StatelessWidget {
  final String nombre;
  final bool activa;
  final Color color;
  final VoidCallback onTap;

  const _ChipCategoria({
    required this.nombre,
    required this.activa,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: activa ? color.withValues(alpha: 0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: activa ? color : Colors.grey.shade400,
            width: activa ? 1.5 : 1,
          ),
        ),
        child: Text(
          nombre,
          style: TextStyle(
            fontSize: 13,
            color: activa ? color : Colors.grey.shade600,
            fontWeight: activa ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// ── Grid con drag & drop ──────────────────────────────────────────────────────

class _ReordenGrid extends StatefulWidget {
  final List<Juego> juegos;
  final Future<void> Function(int from, int to) onReorder;
  final void Function(int index, int nuevaPos) onMoverAPosicion;
  final void Function(Juego juego) onTapJuego;

  const _ReordenGrid({
    required this.juegos,
    required this.onReorder,
    required this.onMoverAPosicion,
    required this.onTapJuego,
  });

  @override
  State<_ReordenGrid> createState() => _ReordenGridState();
}

class _ReordenGridState extends State<_ReordenGrid> {
  int? _draggingIndex;
  int? _hoverIndex;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      cacheExtent: 300,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.68,
      ),
      itemCount: widget.juegos.length,
      itemBuilder: (context, index) {
        final juego = widget.juegos[index];
        final isDragging = _draggingIndex == index;
        final isHover = _hoverIndex == index && _draggingIndex != index;

        return DragTarget<int>(
          onWillAcceptWithDetails: (details) {
            if (details.data != index) {
              setState(() => _hoverIndex = index);
            }
            return details.data != index;
          },
          onLeave: (_) => setState(() => _hoverIndex = null),
          onAcceptWithDetails: (details) {
            setState(() => _hoverIndex = null);
            widget.onReorder(details.data, index);
          },
          builder: (context, candidateData, rejectedData) {
            return LongPressDraggable<int>(
              data: index,
              delay: const Duration(milliseconds: 300),
              onDragStarted: () => setState(() => _draggingIndex = index),
              onDragEnd: (_) => setState(() => _draggingIndex = null),
              onDraggableCanceled: (_, _) =>
                  setState(() => _draggingIndex = null),
              feedback: SizedBox(
                width: 120,
                height: 120 / 0.68,
                child: Opacity(
                  opacity: 0.85,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _ImagenJuego(juego: juego),
                  ),
                ),
              ),
              childWhenDragging: AnimatedOpacity(
                opacity: 0.25,
                duration: const Duration(milliseconds: 150),
                child: _TarjetaReordenGrid(
                  juego: juego,
                  posicion: index + 1,
                  total: widget.juegos.length,
                  onTap: () {},
                  onMover: (_) {},
                  mostrarInput: false,
                ),
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: isHover
                      ? Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2.5,
                        )
                      : null,
                  boxShadow: isHover
                      ? [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isHover ? 8 : 10),
                  child: isDragging
                      ? _TarjetaReordenGrid(
                          juego: juego,
                          posicion: index + 1,
                          total: widget.juegos.length,
                          onTap: () {},
                          onMover: (_) {},
                          mostrarInput: false,
                        )
                      : _TarjetaReordenGrid(
                          juego: juego,
                          posicion: index + 1,
                          total: widget.juegos.length,
                          onTap: () => widget.onTapJuego(juego),
                          onMover: (nuevaPos) =>
                              widget.onMoverAPosicion(index, nuevaPos),
                        ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ── Input de posición ─────────────────────────────────────────────────────────

class _InputPosicion extends StatefulWidget {
  final int posicionActual;
  final int total;
  final void Function(int nuevaPos) onConfirmar;
  final bool esGrid;
  final bool fondoOscuro;

  const _InputPosicion({
    required this.posicionActual,
    required this.total,
    required this.onConfirmar,
    this.esGrid = false,
    this.fondoOscuro = false,
  });

  @override
  State<_InputPosicion> createState() => _InputPosicionState();
}

class _InputPosicionState extends State<_InputPosicion> {
  late TextEditingController _ctrl;
  late FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: '${widget.posicionActual}');
    _focus = FocusNode();
    _focus.addListener(() {
      if (_focus.hasFocus) {
        _ctrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _ctrl.text.length,
        );
      }
    });
  }

  @override
  void didUpdateWidget(_InputPosicion old) {
    super.didUpdateWidget(old);
    if (!_focus.hasFocus && old.posicionActual != widget.posicionActual) {
      _ctrl.text = '${widget.posicionActual}';
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _confirmar() {
    final valor = int.tryParse(_ctrl.text);
    if (valor != null) {
      widget.onConfirmar(valor);
    } else {
      _ctrl.text = '${widget.posicionActual}';
    }
    _focus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final ancho = widget.esGrid ? 36.0 : 42.0;
    final alto = widget.esGrid ? 26.0 : 32.0;
    final fontSize = widget.esGrid ? 11.0 : 13.0;

    final fillColor = widget.fondoOscuro
        ? Colors.black.withValues(alpha: 0.72)
        : primary.withValues(alpha: 0.08);
    final textColor = widget.fondoOscuro ? Colors.white : primary;
    final borderColor = widget.fondoOscuro
        ? Colors.white.withValues(alpha: 0.45)
        : primary.withValues(alpha: 0.4);
    final borderColorFocus = widget.fondoOscuro ? Colors.white : primary;

    return SizedBox(
      width: ancho,
      height: alto,
      child: TextField(
        controller: _ctrl,
        focusNode: _focus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 2,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: borderColorFocus, width: 2),
          ),
          filled: true,
          fillColor: fillColor,
        ),
        onSubmitted: (_) => _confirmar(),
        onTapOutside: (_) {
          if (_focus.hasFocus) _confirmar();
        },
      ),
    );
  }
}

// ── Tarjeta en modo reorden grid ──────────────────────────────────────────────

class _TarjetaReordenGrid extends StatelessWidget {
  final Juego juego;
  final int posicion;
  final int total;
  final VoidCallback onTap;
  final void Function(int nuevaPos) onMover;
  final bool mostrarInput;

  const _TarjetaReordenGrid({
    required this.juego,
    required this.posicion,
    required this.total,
    required this.onTap,
    required this.onMover,
    this.mostrarInput = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _ImagenJuego(juego: juego),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.82),
                  ],
                  stops: const [0.42, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            left: 6,
            right: 6,
            bottom: 6,
            child: Text(
              juego.nombre,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11,
                shadows: [Shadow(blurRadius: 4, color: Colors.black)],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (mostrarInput)
            Positioned(
              top: 6,
              left: 6,
              child: _InputPosicion(
                posicionActual: posicion,
                total: total,
                onConfirmar: onMover,
                esGrid: true,
                fondoOscuro: true,
              ),
            ),
        ],
      ),
    );
  }
}

// ── Widget imagen reutilizable ────────────────────────────────────────────────

class _ImagenJuego extends StatelessWidget {
  final Juego juego;

  const _ImagenJuego({required this.juego});

  @override
  Widget build(BuildContext context) {
    String? url;
    String? local;

    if (juego.imagenGridLocal != null && juego.imagenGridLocal!.isNotEmpty) {
      local = juego.imagenGridLocal;
    } else if (juego.imagenGrid.isNotEmpty) {
      url = juego.imagenGrid;
    } else if (juego.imagenLocal != null && juego.imagenLocal!.isNotEmpty) {
      local = juego.imagenLocal;
    } else if (juego.imagen.isNotEmpty) {
      url = juego.imagen;
    }

    return ImagenAjustada(
      url: url,
      local: local,
      cropX: juego.imagenGridCropX,
      cropY: juego.imagenGridCropY,
      cropW: juego.imagenGridCropW,
      cropH: juego.imagenGridCropH,
      placeholder: Container(
        color: Colors.grey.shade800,
        child: const Center(
          child: Icon(Icons.videogame_asset, size: 32, color: Colors.white38),
        ),
      ),
    );
  }
}

// ── Tarjeta de juego en el grid ───────────────────────────────────────────────

class _TarjetaJuego extends StatelessWidget {
  final Juego juego;
  final VoidCallback onTap;
  final VoidCallback onAccionRapida;

  const _TarjetaJuego({
    required this.juego,
    required this.onTap,
    required this.onAccionRapida,
  });

  @override
  Widget build(BuildContext context) {
    final colorEstado = _colorEstado(juego.estado, context);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onAccionRapida,
      onSecondaryTap: onAccionRapida,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _ImagenJuego(juego: juego),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.75),
                    ],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Text(
                juego.nombre,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (juego.calificacion > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        '${juego.calificacion}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: colorEstado.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  traducirEstadoJuego(juego.estado, context),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _colorEstado(String estado, BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    switch (estado) {
      case 'Playing':
        return primary;
      case 'Completed':
        return primary.withValues(alpha: 0.75);
      case 'Abandoned':
        return Colors.grey.shade700;
      default:
        return Colors.grey.shade500;
    }
  }
}

String traducirEstadoJuego(String estado, BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  switch (estado) {
    case 'Playing':
      return l10n.estadoJugando;
    case 'Completed':
      return l10n.estadoCompletado;
    case 'Abandoned':
      return l10n.estadoAbandonado;
    default:
      return l10n.estadoPendiente;
  }
}
