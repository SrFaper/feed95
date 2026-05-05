import 'dart:io';
import 'package:flutter/material.dart';
import '../models/juego.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import 'juego_form_screen.dart';

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

  Future<void> eliminarJuego(int id) async {
    final respuesta = await ApiService.eliminarJuego(id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(respuesta['message'])),
    );
    if (respuesta['success'] == true) cargarJuegos();
  }

  Widget _imagenJuego(Juego juego) {
    // Prioridad: imagen local > URL > ícono por defecto
    if (juego.imagenLocal != null && juego.imagenLocal!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.file(
          File(juego.imagenLocal!),
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.videogame_asset),
        ),
      );
    }
    if (juego.imagen.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          juego.imagen,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.videogame_asset),
        ),
      );
    }
    return const Icon(Icons.videogame_asset);
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
              : ListView.builder(
                  itemCount: juegos.length,
                  itemBuilder: (context, index) {
                    final juego = juegos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: _imagenJuego(juego),
                        title: Text(juego.nombre),
                        subtitle: Text(
                          '${juego.estado} · ${juego.generos} · ⭐ ${juego.calificacion}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
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
                                cargarJuegos();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => eliminarJuego(juego.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}