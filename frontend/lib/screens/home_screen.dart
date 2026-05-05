import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/usuario.dart';
import 'juegos_screen.dart';
import 'perfiles_screen.dart';
import 'perfil_screen.dart';

class HomeScreen extends StatefulWidget {
  final Usuario usuario;
  const HomeScreen({super.key, required this.usuario});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Usuario usuario;

  @override
  void initState() {
    super.initState();
    usuario = widget.usuario;
  }

  Future<void> _cambiarPerfil() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuario_id');
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PerfilesScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed95'),
        actions: [
          IconButton(
            icon: const Icon(Icons.switch_account),
            tooltip: 'Cambiar perfil',
            onPressed: _cambiarPerfil,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: _cambiarPerfil,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: usuario.color,
              child: Text(
                usuario.nombre[0].toUpperCase(),
                style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Bienvenido, ${usuario.nombre}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Editar perfil'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PerfilScreen(
                      usuario: usuario,
                      onActualizado: () async {
                        final actualizado = await ApiService.obtenerUsuarioPorId(usuario.id);
                        if (actualizado != null && mounted) {
                          setState(() => usuario = actualizado);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.videogame_asset),
              label: const Text('Mi catálogo'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JuegosScreen(usuario: usuario),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}