import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import '../main.dart';
import '../widgets/avatar_usuario.dart';
import 'juegos_screen.dart';
import 'perfiles_screen.dart';
import 'perfil_screen.dart';
import 'f95_config_screen.dart';
import 'igdb_config_screen.dart';
import 'package:frontend/l10n/app_localizations.dart';
import '../services/image_cache_service.dart';
import 'acerca_screen.dart';

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
  bool _modosExtrasActivos = false;
  int _totalJuegos = 0;
  int _completados = 0;
  int _jugando = 0;

  @override
  void initState() {
    super.initState();
    usuario = widget.usuario;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.appState?.cambiarColor(usuario.color);
    });
    _cargarTodo();
  }

  // Función para cargar estadísticas y configuraciones
  Future<void> _cargarTodo() async {
    final prefs = await SharedPreferences.getInstance();
    final stats = await ApiService.obtenerEstadisticas(usuario.id);
    if (mounted) {
      setState(() {
        _modosExtrasActivos = prefs.getBool('f95_activado') ?? false;
        _totalJuegos = stats['total'] as int;
        _completados = stats['completados'] as int;
        _jugando = stats['jugando'] as int;
      });
    }
  }

  // Función para cambiar de perfil (cerrar sesión)
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

  // Función para exportar el backup
  Future<void> _exportarBackup() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final json = await ApiService.exportarBackup();
      if (kIsWeb) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.homeBackupNoDisponibleWeb)));
        return;
      }
      final carpeta = await FilePicker.getDirectoryPath(
        dialogTitle: l10n.homeGuardarBackupEn,
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
        SnackBar(content: Text(l10n.homeBackupGuardado(archivo.path))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.homeErrorExportar(e.toString()))),
      );
    }
  }

  // Función para ver la ruta de las imágenes
  Future<void> _verRutaImagenes() async {
    final l10n = AppLocalizations.of(context)!;
    final ruta = await ImageCacheService.rutaVisible();
    final bytes = await ImageCacheService.tamanoTotal();
    final mb = (bytes / (1024 * 1024)).toStringAsFixed(2);
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.homeCarpetaImagenesTitulo),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(ruta, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 12),
            Text(l10n.homeCarpetaImagenesEspacio(mb)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.btnAceptar),
          ),
        ],
      ),
    );
  }

  // Función para importar un backup
  Future<void> _importarBackup() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      if (kIsWeb) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.homeImportarNoDisponibleWeb)),
        );
        return;
      }
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        dialogTitle: l10n.homeDialogoImportarTitulo,
      );
      if (result == null || result.files.single.path == null) return;
      if (!mounted) return;
      final confirmar = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.homeDialogoImportarTitulo),
          content: Text(l10n.homeDialogoImportarContenido),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.btnCancelar),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.btnImportar),
            ),
          ],
        ),
      );
      if (confirmar != true) return;
      final archivo = File(result.files.single.path!);
      final contenido = await archivo.readAsString();
      final respuesta = await ApiService.importarBackup(contenido);
      if (!mounted) return;
      final String mensaje;
      if (respuesta['messageKey'] == 'apiBackupRestaurado') {
        mensaje = l10n.apiBackupRestaurado(
          respuesta['perfiles'] as int,
          respuesta['categorias'] as int,
          respuesta['juegos'] as int,
        );
      } else {
        mensaje = l10n.apiBackupArchivoInvalido;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mensaje)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.homeErrorImportar(e.toString()))),
      );
    }
  }

  void _mostrarBottomSheet() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.homeSeccionConfiguraciones,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _botonSheet(
                        icon: Icons.sports_esports,
                        label: l10n.homeConfigurarIGDB,
                        onTap: () {
                          Navigator.pop(ctx);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const IgdbConfigScreen(),
                            ),
                          );
                        },
                      ),
                      if (_modosExtrasActivos) ...[
                        const SizedBox(height: 8),
                        _botonSheet(
                          icon: Icons.settings,
                          label: l10n.homeConfigurarF95,
                          onTap: () {
                            Navigator.pop(ctx);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const F95ConfigScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.homeSeccionSistema,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _botonSheet(
                        icon: Icons.upload,
                        label: l10n.homeExportarCopia,
                        onTap: () {
                          Navigator.pop(ctx);
                          _exportarBackup();
                        },
                      ),
                      const SizedBox(height: 8),
                      _botonSheet(
                        icon: Icons.download,
                        label: l10n.homeImportarCopia,
                        onTap: () {
                          Navigator.pop(ctx);
                          _importarBackup();
                        },
                      ),
                      const SizedBox(height: 8),
                      _botonSheet(
                        icon: Icons.folder_outlined,
                        label: l10n.homeCarpetaImagenes,
                        onTap: () {
                          Navigator.pop(ctx);
                          _verRutaImagenes();
                        },
                      ),
                      const SizedBox(height: 8),
                      _botonSheet(
                        icon: Icons.info_outline,
                        label: l10n.acercaTitulo,
                        onTap: () {
                          Navigator.pop(ctx);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AcercaScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _botonSheet({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF2A2A2A)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF333333)
                : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey.shade500),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String valor, String etiqueta) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          valor,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          etiqueta.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _separadorVertical() {
    return Container(
      width: 1,
      height: 32,
      color: Theme.of(context).dividerColor,
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _contenidoPrincipal(bool esAncho) {
    final l10n = AppLocalizations.of(context)!;

    final avatarWidget = GestureDetector(
      onTap: () async {
        _tapContador++;
        if (_tapContador >= 5) {
          _tapContador = 0;
          final prefs = await SharedPreferences.getInstance();
          final activado = prefs.getBool('f95_activado') ?? false;
          await prefs.setBool('f95_activado', !activado);
          if (!mounted) return;
          setState(() => _modosExtrasActivos = !activado);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                !activado
                    ? l10n.homeModoExtendidoActivado
                    : l10n.homeModoExtendidoDesactivado,
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: AvatarUsuario(usuario: usuario, size: 150),
    );

    final colAvatar = Column(
      children: [
        avatarWidget,
        const SizedBox(height: 10),
        TextButton.icon(
          icon: const Icon(Icons.edit, size: 14),
          label: Text(
            l10n.homeEditarPerfil,
            style: const TextStyle(fontSize: 13),
          ),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PerfilScreen(
                  usuario: usuario,
                  appState: widget.appState,
                  onActualizado: () async {
                    final actualizado = await ApiService.obtenerUsuarioPorId(
                      usuario.id,
                    );
                    if (actualizado != null && mounted) {
                      setState(() => usuario = actualizado);
                      widget.appState?.cambiarColor(actualizado.color);
                      _cargarTodo();
                    }
                  },
                ),
              ),
            );
          },
        ),
      ],
    );

    final colInfo = Column(
      crossAxisAlignment: esAncho
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Text(
          l10n.homeBienvenido(usuario.nombre),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: esAncho ? TextAlign.left : TextAlign.center,
        ),
        const SizedBox(height: 14),
        ElevatedButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JuegosScreen(usuario: usuario),
              ),
            );
            _cargarTodo();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.videogame_asset, size: 18),
              const SizedBox(width: 8),
              Text(
                l10n.homeMiCatalogo,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 16),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              mainAxisSize: esAncho ? MainAxisSize.min : MainAxisSize.max,
              mainAxisAlignment: esAncho
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                _statItem('$_totalJuegos', l10n.homeStatJuegos),
                _separadorVertical(),
                _statItem('$_completados', l10n.homeStatCompletados),
                _separadorVertical(),
                _statItem('$_jugando', l10n.homeStatJugando),
              ],
            ),
          ),
        ),
      ],
    );

    if (esAncho) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          colAvatar,
          const SizedBox(width: 32),
          Flexible(child: colInfo),
        ],
      );
    } else {
      return Column(children: [colAvatar, const SizedBox(height: 20), colInfo]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final esAncho = MediaQuery.of(context).size.width > 500;
    final appState = widget.appState;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.homeTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: l10n.homeTooltipCambiarTema,
            onPressed: () {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              appState?.cambiarTema(isDark ? ThemeMode.light : ThemeMode.dark);
            },
          ),
          IconButton(
            icon: const Icon(Icons.switch_account),
            tooltip: l10n.homeTooltipCambiarPerfil,
            onPressed: _cambiarPerfil,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.homeTooltipCerrarSesion,
            onPressed: _cambiarPerfil,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: _contenidoPrincipal(esAncho),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        child: SafeArea(
          child: InkWell(
            onTap: _mostrarBottomSheet,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.keyboard_arrow_up, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    l10n.homeConfiguraciones,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
