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

  String nombreCatalogoSecundario = 'NSFW';

  @override
  void initState() {
    super.initState();
    _cargarModosExtras();
    cargarTodo();
  }

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
  }

  List<Juego> get juegosFiltrados {
    return juegos.where((j) {
      final matchBusqueda =
          busqueda.isEmpty ||
          j.nombre.toLowerCase().contains(busqueda.toLowerCase());
      final matchEstado = filtroEstado == null || j.estado == filtroEstado;
      final matchCategoria =
          filtroCategoria == null || j.categoriaId == filtroCategoria;
      return matchBusqueda && matchEstado && matchCategoria;
    }).toList();
  }

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
            padding: const EdgeInsets.all(12),
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
                          setState(() => busqueda = '');
                        },
                      )
                    : null,
              ),
              onChanged: (v) => setState(() => busqueda = v),
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
            onTap: () => setState(() => filtroEstado = null),
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
              onTap: () => setState(
                () =>
                    filtroEstado = filtroEstado == entry.key ? null : entry.key,
              ),
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
            onTap: () => setState(() => filtroCategoria = null),
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
      onTap: () =>
          setState(() => filtroCategoria = seleccionada ? null : cat.id),
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

  Widget _vistaGrid(List<Juego> lista) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
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
          categorias: categorias,
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
          onAsignarCategoria: (catId) async {
            await ApiService.asignarCategoria(juego.id, catId);
            cargarTodo();
          },
        );
      },
    );
  }

  Widget _vistaReordenLista(List<Juego> lista) {
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
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
                  child: juego.imagenGrid.isNotEmpty
                      ? Image.network(
                          juego.imagenGrid,
                          width: 40,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              const Icon(Icons.videogame_asset),
                        )
                      : const Icon(Icons.videogame_asset),
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

// ── Grid con drag & drop nativo ──────────────────────────────────────────────

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

// ── Input de posición ────────────────────────────────────────────────────────

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

// ── Tarjeta en modo reordenamiento grid ─────────────────────────────────────

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

// ── Widget imagen reutilizable ───────────────────────────────────────────────

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

// ── Tarjeta de juego en vista grid ─────────────────────────────────────────
class _TarjetaJuego extends StatelessWidget {
  final Juego juego;
  final List<Categoria> categorias;
  final VoidCallback onTap;
  final Function(int?) onAsignarCategoria;

  const _TarjetaJuego({
    required this.juego,
    required this.categorias,
    required this.onTap,
    required this.onAsignarCategoria,
  });

  void _mostrarMenuContextual(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              juego.nombre,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.folder),
            title: Text(l10n.catalogoAsignarCategoria),
            onTap: () {
              Navigator.pop(ctx);
              _mostrarSelectorCategoria(context);
            },
          ),
        ],
      ),
    );
  }

  void _mostrarSelectorCategoria(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.catalogoAsignarCategoria),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: const Icon(Icons.clear),
                title: Text(l10n.catalogoSinCategoria),
                onTap: () {
                  Navigator.pop(ctx);
                  onAsignarCategoria(null);
                },
              ),
              ...categorias.map(
                (cat) => ListTile(
                  leading: const Icon(Icons.folder),
                  title: Text(cat.nombre),
                  selected: juego.categoriaId == cat.id,
                  onTap: () {
                    Navigator.pop(ctx);
                    onAsignarCategoria(cat.id);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorEstado = _colorEstado(juego.estado, context);

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _mostrarMenuContextual(context),
      onSecondaryTap: () => _mostrarMenuContextual(context),
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
