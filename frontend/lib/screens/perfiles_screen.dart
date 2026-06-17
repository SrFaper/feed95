import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import '../main.dart';
import '../widgets/avatar_usuario.dart';
import 'home_screen.dart';
import 'registro_screen.dart';
import 'package:frontend/l10n/app_localizations.dart';

class PerfilesScreen extends StatefulWidget {
  const PerfilesScreen({super.key});

  @override
  State<PerfilesScreen> createState() => _PerfilesScreenState();
}

class _PerfilesScreenState extends State<PerfilesScreen> {
  List<Usuario> perfiles = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarPerfiles();
  }

  Future<void> _cargarPerfiles() async {
    setState(() => cargando = true);
    perfiles = await ApiService.listarUsuarios();
    setState(() => cargando = false);
  }

  Future<void> _seleccionarPerfil(Usuario usuario) async {
    // Verificar si el perfil tiene contraseña
    final tienePassword = await ApiService.perfilTienePassword(usuario.id);

    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    if (!tienePassword) {
      // Acceso directo sin pedir contraseña
      final respuesta = await ApiService.login(
        nombre: usuario.nombre,
        password: '',
      );
      if (respuesta['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('usuario_id', usuario.id);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(usuario: usuario, appState: Feed95App.of(context)),
            ),
          );
        }
      }
      return;
    }

    // Perfil con contraseña → mostrar diálogo
    final passwordController = TextEditingController();

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(usuario.nombre),
        content: TextField(
          controller: passwordController,
          decoration: InputDecoration(labelText: l10n.perfilesInputPassword),
          obscureText: true,
          autofocus: true,
          onSubmitted: (_) => Navigator.pop(context, true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.btnCancelar),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.login, size: 16),
                const SizedBox(width: 6),
                Text(
                  l10n.btnEnter,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    final respuesta = await ApiService.login(
      nombre: usuario.nombre,
      password: passwordController.text,
    );

    if (respuesta['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('usuario_id', usuario.id);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomeScreen(usuario: usuario, appState: Feed95App.of(context)),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.perfilesPasswordIncorrecta)),
        );
      }
    }
  }

  Future<void> _eliminarPerfil(Usuario usuario) async {
    final tienePassword = await ApiService.perfilTienePassword(usuario.id);
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    // Paso 1: confirmación general
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.perfilesEliminarTitulo),
        content: Text(l10n.perfilesEliminarContenido(usuario.nombre)),
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

    if (confirmar != true) return;

    // Paso 2: si tiene contraseña, verificarla antes de borrar
    if (tienePassword) {
      if (!mounted) return;
      final passwordController = TextEditingController();
      final passwordOk = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.perfilesEliminarConfirmarTitulo),
          content: TextField(
            controller: passwordController,
            decoration: InputDecoration(labelText: l10n.perfilesInputPassword),
            obscureText: true,
            autofocus: true,
            onSubmitted: (_) => Navigator.pop(context, true),
          ),
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

      if (passwordOk != true) return;

      final respuesta = await ApiService.login(
        nombre: usuario.nombre,
        password: passwordController.text,
      );

      if (!mounted) return;
      if (respuesta['success'] != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.perfilesPasswordIncorrecta)),
        );
        return;
      }
    }

    await ApiService.eliminarUsuario(usuario.id);
    if (!mounted) return;
    _cargarPerfiles();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.perfilesTitulo)),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : perfiles.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.perfilesVacio),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistroScreen(),
                        ),
                      );
                      _cargarPerfiles();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          l10n.btnCrearPerfil,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 160,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.85,
                          ),
                      itemCount: perfiles.length,
                      itemBuilder: (context, index) {
                        final perfil = perfiles[index];
                        return GestureDetector(
                          onTap: () => _seleccionarPerfil(perfil),
                          onLongPress: () => _eliminarPerfil(perfil),
                          onSecondaryTap: () => _eliminarPerfil(perfil),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Avatar cuadrado redondeado (igual al del home)
                              AvatarUsuario(usuario: perfil, size: 80),
                              const SizedBox(height: 8),
                              Text(
                                perfil.nombre,
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistroScreen(),
                        ),
                      );
                      _cargarPerfiles();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          l10n.btnNuevoPerfil,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
