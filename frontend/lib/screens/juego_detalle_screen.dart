import 'dart:io';
import 'package:flutter/material.dart';
import '../models/juego.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import 'juego_form_screen.dart';
import 'package:flutter/foundation.dart';

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

  Future<void> _eliminar() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar juego'),
        content: Text(
          '¿Eliminar "${juego.nombre}"? Esta acción no se puede deshacer.',
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
      await ApiService.eliminarJuego(juego.id);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  Future<void> _ejecutar() async {
    if (juego.rutaEjecutable == null || juego.rutaEjecutable!.isEmpty) return;
    try {
      await Process.run(juego.rutaEjecutable!, [], runInShell: true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No se pudo ejecutar: $e')));
    }
  }

  Widget _imagen() {
    if (juego.imagenLocal != null && juego.imagenLocal!.isNotEmpty) {
      return Image.file(
        File(juego.imagenLocal!),
        width: double.infinity,
        height: 280,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    if (juego.imagen.isNotEmpty) {
      return Image.network(
        juego.imagen,
        width: double.infinity,
        height: 280,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
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

  Color _colorEstado(String estado) {
    switch (estado) {
      case 'Jugando':
        return Colors.green.shade700;
      case 'Completado':
        return Colors.blue.shade700;
      case 'Abandonado':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final generos = juego.generos
        .split(',')
        .map((g) => g.trim())
        .where((g) => g.isNotEmpty)
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar con imagen de fondo
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Editar',
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
                  // Recargar juego actualizado
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
                tooltip: 'Eliminar',
                onPressed: _eliminar,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _imagen(),
                  // Gradiente para que el AppBar sea legible
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

          // Contenido
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre y estado
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      const SizedBox(width: 8),
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
                  const SizedBox(height: 8),

                  // Versión y calificación
                  Row(
                    children: [
                      if (juego.version.isNotEmpty) ...[
                        const Icon(Icons.tag, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          juego.version,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      if (juego.calificacion > 0) ...[
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${juego.calificacion}/10',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Géneros como tags
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

                  // Botón ejecutar — solo en Windows/Linux si tiene ruta
                  if (!kIsWeb &&
                      (Platform.isWindows || Platform.isLinux) &&
                      juego.rutaEjecutable != null &&
                      juego.rutaEjecutable!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Ejecutar juego'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _ejecutar,
                      ),
                    ),
                  ],

                  // Descripción
                  if (juego.descripcion.isNotEmpty) ...[
                    const Text(
                      'Descripción',
                      style: TextStyle(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
