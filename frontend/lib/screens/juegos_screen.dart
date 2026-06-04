import 'dart:io';
import 'package:flutter/material.dart';
import '../models/juego.dart';
import '../models/usuario.dart';
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
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarJuegos();
  }

  Future<void> cargarJuegos() async {
    setState(() => cargando = true);
    juegos = await ApiService.obtenerJuegos(widget.usuario.id);
    setState(() => cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi catálogo')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JuegoFormScreen(usuario: widget.usuario),
            ),
          );
          cargarJuegos();
        },
        child: const Icon(Icons.add),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : juegos.isEmpty
          ? const Center(child: Text('No hay juegos en tu catálogo'))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 180,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemCount: juegos.length,
              itemBuilder: (context, index) {
                final juego = juegos[index];
                return _TarjetaJuego(
                  juego: juego,
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
                    cargarJuegos();
                  },
                );
              },
            ),
    );
  }
}

class _TarjetaJuego extends StatelessWidget {
  final Juego juego;
  final VoidCallback onTap;

  const _TarjetaJuego({required this.juego, required this.onTap});

  Widget _imagen() {
    // Imagen específica para el grid
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

    // Fallback a imagen principal
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

  @override
  Widget build(BuildContext context) {
    final colorEstado = _colorEstado(juego.estado);

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Portada
            _imagen(),

            // Gradiente inferior para legibilidad
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

            // Nombre en la parte inferior
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

            // Badge calificación — esquina superior derecha
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

            // Badge estado — esquina superior izquierda
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
