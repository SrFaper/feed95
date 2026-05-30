import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/usuario.dart';
import '../main.dart';
import 'juegos_screen.dart';
import 'perfiles_screen.dart';
import 'perfil_screen.dart';
import 'f95_config_screen.dart';

class HomeScreen extends StatefulWidget {
  final Usuario usuario;
  final Feed95AppState? appState;

  const HomeScreen({super.key, required this.usuario, this.appState});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Usuario usuario;
  int _tapContador = 0;

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

  Future<void> _exportarBackup() async {
    try {
      final json = await ApiService.exportarBackup();

      if (kIsWeb) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exportar backup no está disponible en Web'),
          ),
        );
        return;
      }

      // Elegir carpeta destino
      String? carpeta = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Guardar backup en...',
      );

      if (carpeta == null) return;

      final fecha = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .substring(0, 19);
      final archivo = File('$carpeta/feed95_backup_$fecha.json');
      await archivo.writeAsString(json);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Backup guardado en ${archivo.path}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al exportar: $e')));
    }
  }

  Future<void> _importarBackup() async {
    try {
      if (kIsWeb) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Importar backup no está disponible en Web'),
          ),
        );
        return;
      }

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        dialogTitle: 'Seleccionar backup de Feed95',
      );

      if (result == null || result.files.single.path == null) return;

      // Confirmar antes de importar
      if (!mounted) return;
      final confirmar = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Importar backup'),
          content: const Text(
            'Se agregarán los perfiles y juegos del backup. '
            'Los perfiles con el mismo nombre serán omitidos.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Importar'),
            ),
          ],
        ),
      );

      if (confirmar != true) return;

      final archivo = File(result.files.single.path!);
      final contenido = await archivo.readAsString();
      final respuesta = await ApiService.importarBackup(contenido);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(respuesta['message'])));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al importar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = widget.appState;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed95'),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: 'Cambiar tema',
            onPressed: () {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              appState?.cambiarTema(isDark ? ThemeMode.light : ThemeMode.dark);
            },
          ),
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
            GestureDetector(
              onTap: () async {
                _tapContador++;
                if (_tapContador >= 5) {
                  _tapContador = 0;
                  final prefs = await SharedPreferences.getInstance();
                  final activado = prefs.getBool('f95_activado') ?? false;
                  await prefs.setBool('f95_activado', !activado);
                  if (!mounted) return;
                  setState(() {});
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        !activado
                            ? 'Modo extendido activado'
                            : 'Modo extendido desactivado',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: CircleAvatar(
                radius: 48,
                backgroundColor: usuario.color,
                child: Text(
                  usuario.nombre[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                        final actualizado =
                            await ApiService.obtenerUsuarioPorId(usuario.id);
                        if (actualizado != null && mounted) {
                          setState(() => usuario = actualizado);
                        }
                      },
                    ),
                  ),
                );
              },
            ),

            FutureBuilder<bool>(
              future: SharedPreferences.getInstance().then(
                (p) => p.getBool('f95_activado') ?? false,
              ),
              builder: (context, snapshot) {
                if (snapshot.data != true) return const SizedBox();
                return Column(
                  children: [
                    const SizedBox(height: 8),
                    TextButton.icon(
                      icon: const Icon(Icons.settings, size: 16),
                      label: const Text('Configurar F95Zone'),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const F95ConfigScreen(),
                        ),
                      ),
                    ),
                  ],
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
            const SizedBox(height: 32),
            const Divider(indent: 48, endIndent: 48),
            const SizedBox(height: 8),
            const Text(
              'Backup',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.upload),
                  label: const Text('Exportar'),
                  onPressed: _exportarBackup,
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text('Importar'),
                  onPressed: _importarBackup,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
