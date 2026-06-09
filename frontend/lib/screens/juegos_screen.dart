import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/juego.dart';
import '../models/usuario.dart';
import '../models/categoria.dart';
import '../services/api_service.dart';
import 'juego_form_screen.dart';
import 'juego_detalle_screen.dart';

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
  int catalogoActual = 0; // 0 = principal, 1 = secundario
  String busqueda = '';
  String? filtroEstado;
  int? filtroCategoria; // null = todas
  final TextEditingController _busquedaController = TextEditingController();

  // Nombre editable del catálogo secundario
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
    final controller = TextEditingController(text: editar?.nombre ?? '');
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(editar == null ? 'Nueva categoría' : 'Editar categoría'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nombre'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
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
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _eliminarCategoria(Categoria cat) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar categoría'),
        content: Text(
          '¿Eliminar "${cat.nombre}"? Los juegos perderán esta categoría.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.white),
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

  Widget _panelLateral() {
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
          // Búsqueda
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _busquedaController,
              decoration: InputDecoration(
                hintText: 'Buscar...',
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

          // Filtro por estado
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              'Estado',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _itemFiltro(
            label: 'Todos',
            seleccionado: filtroEstado == null,
            onTap: () => setState(() => filtroEstado = null),
          ),
          for (final estado in [
            'Pendiente',
            'Jugando',
            'Completado',
            'Abandonado',
          ])
            _itemFiltro(
              label: estado,
              seleccionado: filtroEstado == estado,
              onTap: () => setState(
                () => filtroEstado = filtroEstado == estado ? null : estado,
              ),
            ),

          const Divider(indent: 12, endIndent: 12),

          // Categorías
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Categorías',
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
            label: 'Todas',
            seleccionado: filtroCategoria == null,
            onTap: () => setState(() => filtroCategoria = null),
          ),
          Expanded(
            child: ListView(
              children: categorias.map((cat) {
                return _itemCategoria(cat);
              }).toList(),
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
            ? const Color.fromARGB(255, 255, 54, 71).withValues(alpha: 0.15)
            : null,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: seleccionado ? FontWeight.bold : FontWeight.normal,
            color: seleccionado ? const Color.fromARGB(255, 255, 54, 71) : null,
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
            ? const Color.fromARGB(255, 255, 54, 71).withValues(alpha: 0.15)
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
                      ? const Color.fromARGB(255, 255, 54, 71)
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
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Editar'),
            onTap: () {
              Navigator.pop(context);
              _mostrarDialogoCategoria(editar: cat);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Eliminar', style: TextStyle(color: Colors.red)),
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
    final juegosMostrados = juegosFiltrados;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          catalogoActual == 0 ? 'Mi catálogo' : nombreCatalogoSecundario,
        ),
        actions: [
          // Toggle panel lateral
          IconButton(
            icon: Icon(panelAbierto ? Icons.menu_open : Icons.menu),
            tooltip: 'Filtros y categorías',
            onPressed: () => setState(() => panelAbierto = !panelAbierto),
          ),
          // Switcher de catálogo
          if (_modosExtrasActivos)
            IconButton(
              icon: Icon(
                catalogoActual == 0 ? Icons.lock_open : Icons.lock,
                color: catalogoActual == 1
                    ? const Color.fromARGB(255, 255, 54, 71)
                    : null,
              ),
              tooltip: catalogoActual == 0
                  ? 'Ir a $nombreCatalogoSecundario'
                  : 'Ir al catálogo principal',
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
      floatingActionButton: FloatingActionButton(
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
                // Panel lateral animado
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: panelAbierto ? 220 : 0,
                  child: panelAbierto
                      ? ClipRect(child: _panelLateral())
                      : const SizedBox.shrink(),
                ),

                // Grid principal
                Expanded(
                  child: juegosMostrados.isEmpty
                      ? Center(
                          child: Text(
                            busqueda.isNotEmpty ||
                                    filtroEstado != null ||
                                    filtroCategoria != null
                                ? 'No hay juegos con esos filtros'
                                : 'No hay juegos en este catálogo',
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 180,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.65,
                              ),
                          itemCount: juegosMostrados.length,
                          itemBuilder: (context, index) {
                            final juego = juegosMostrados[index];
                            return _TarjetaJuego(
                              juego: juego,
                              categorias: categorias,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JuegoDetalleScreen(
                                      juego: juego,
                                      usuario: widget.usuario,
                                    ),
                                  ),
                                );
                                cargarTodo();
                              },
                              onAsignarCategoria: (catId) async {
                                await ApiService.asignarCategoria(
                                  juego.id,
                                  catId,
                                );
                                cargarTodo();
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

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

  Widget _imagen() {
    if (juego.imagenGridLocal != null && juego.imagenGridLocal!.isNotEmpty) {
      return Image.file(
        File(juego.imagenGridLocal!),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    if (juego.imagenGrid.isNotEmpty) {
      return Image.network(
        juego.imagenGrid,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    if (juego.imagenLocal != null && juego.imagenLocal!.isNotEmpty) {
      return Image.file(
        File(juego.imagenLocal!),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    if (juego.imagen.isNotEmpty) {
      return Image.network(
        juego.imagen,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey.shade800,
      child: const Center(
        child: Icon(Icons.videogame_asset, size: 48, color: Colors.white38),
      ),
    );
  }

  void _mostrarMenuContextual(BuildContext context) {
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
            title: const Text('Asignar categoría'),
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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Asignar categoría'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: const Icon(Icons.clear),
                title: const Text('Sin categoría'),
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
    final colorEstado = _colorEstado(juego.estado);

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _mostrarMenuContextual(context),
      onSecondaryTap: () => _mostrarMenuContextual(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _imagen(),
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
                  juego.estado,
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

  Color _colorEstado(String estado) {
    switch (estado) {
      case 'Jugando':
        return const Color.fromARGB(255, 255, 54, 71);
      case 'Completado':
        return const Color.fromARGB(255, 255, 82, 98);
      case 'Abandonado':
        return const Color.fromARGB(255, 90, 42, 54);
      default:
        return const Color.fromARGB(255, 122, 122, 122);
    }
  }
}
