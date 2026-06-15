import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/juego.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import 'juego_form_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:frontend/l10n/app_localizations.dart';

class JuegoDetalleScreen extends StatefulWidget {
  final Juego juego;
  final Usuario usuario;

  const JuegoDetalleScreen({
    super.key,
    required this.juego,
    required this.usuario,
  });

  @override
  State<JuegoDetalleScreen> createState() => _JuegoDetalleScreenState();
}

class _JuegoDetalleScreenState extends State<JuegoDetalleScreen> {
  late Juego juego;

  @override
  void initState() {
    super.initState();
    juego = widget.juego;
  }

  Color _colorEstado(String estado) {
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

  Future<void> _eliminar() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.juegoDetalleEliminarTitulo),
        content: Text(l10n.juegoDetalleEliminarContenido(juego.nombre)),
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
      await ApiService.eliminarJuego(juego.id);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  Future<void> _ejecutar() async {
    final l10n = AppLocalizations.of(context)!;
    if (juego.rutaEjecutable == null || juego.rutaEjecutable!.isEmpty) return;
    try {
      await Process.run(juego.rutaEjecutable!, [], runInShell: true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.juegoDetalleErrorEjecutable(e.toString()))),
      );
    }
  }

  Widget _imagen() {
    if (juego.imagenLocal != null && juego.imagenLocal!.isNotEmpty) {
      return Image.file(
        File(juego.imagenLocal!),
        width: double.infinity,
        height: 280,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    if (juego.imagen.isNotEmpty) {
      return Image.network(
        juego.imagen,
        width: double.infinity,
        height: 280,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: 280,
      color: Colors.grey.shade800,
      child: const Center(
        child: Icon(Icons.videogame_asset, size: 64, color: Colors.white38),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final generos = juego.generos
        .split(',')
        .map((g) => g.trim())
        .where((g) => g.isNotEmpty)
        .toList();

    final tieneEjecutable =
        !kIsWeb &&
        (Platform.isWindows || Platform.isLinux) &&
        juego.rutaEjecutable != null &&
        juego.rutaEjecutable!.isNotEmpty;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: l10n.juegoDetalleTooltipEditar,
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JuegoFormScreen(
                        usuario: widget.usuario,
                        juego: juego,
                      ),
                    ),
                  );
                  final juegos = await ApiService.obtenerJuegos(
                    widget.usuario.id,
                  );
                  final actualizado = juegos
                      .where((j) => j.id == juego.id)
                      .toList();
                  if (actualizado.isNotEmpty && mounted) {
                    setState(() => juego = actualizado.first);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: l10n.juegoDetalleTooltipEliminar,
                onPressed: _eliminar,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _imagen(),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          juego.nombre,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (tieneEjecutable) ...[
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.play_arrow, size: 18),
                          label: Text(l10n.juegoDetalleJugar),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              255,
                              54,
                              71,
                            ),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                          onPressed: _ejecutar,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (juego.version.isNotEmpty)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.tag, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              juego.version,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      if (juego.calificacion > 0)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${juego.calificacion}/10',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _colorEstado(juego.estado),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          juego.estado,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (generos.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: generos.map((g) {
                        return Chip(
                          label: Text(g, style: const TextStyle(fontSize: 12)),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 0,
                          ),
                          visualDensity: VisualDensity.compact,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (juego.descripcion.isNotEmpty) ...[
                    Text(
                      l10n.juegoDetalleDescripcion,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      juego.descripcion,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ],

                  if (juego.listaImagenesExtra.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      l10n.juegoDetalleImagenes,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 180,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          dragDevices: {
                            PointerDeviceKind.touch,
                            PointerDeviceKind.mouse,
                            PointerDeviceKind.trackpad,
                          },
                        ),
                        child: Scrollbar(
                          thumbVisibility: false,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: juego.listaImagenesExtra.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final url = juego.listaImagenesExtra[index];
                              return GestureDetector(
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: InteractiveViewer(
                                        child: Image.network(
                                          url,
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, _, _) =>
                                              const SizedBox(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    url,
                                    height: 180,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => const SizedBox(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
