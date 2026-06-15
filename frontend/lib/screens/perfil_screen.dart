import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import '../widgets/avatar_usuario.dart';
import '../main.dart';
import 'package:frontend/l10n/app_localizations.dart';

class PerfilScreen extends StatefulWidget {
  final Usuario usuario;
  final VoidCallback onActualizado;
  final Feed95AppState? appState;

  const PerfilScreen({
    super.key,
    required this.usuario,
    required this.onActualizado,
    this.appState,
  });

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  late TextEditingController nombreController;
  late TextEditingController passwordController;
  late TextEditingController confirmarPasswordController;
  late Color colorSeleccionado;
  String? _imagenLocal;
  bool _limpiarImagen = false;
  bool cargando = false;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.usuario.nombre);
    passwordController = TextEditingController();
    confirmarPasswordController = TextEditingController();
    colorSeleccionado = widget.usuario.color;
    _imagenLocal = widget.usuario.imagenPerfil;
  }

  Future<void> _elegirImagen() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imagenLocal = picked.path;
        _limpiarImagen = false;
      });
    }
  }

  void _quitarImagen() {
    setState(() {
      _imagenLocal = null;
      _limpiarImagen = true;
    });
  }

  void _abrirColorPicker() {
    final l10n = AppLocalizations.of(context)!;
    Color colorTemporal = colorSeleccionado;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.registroElegirColor),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: colorTemporal,
            onColorChanged: (color) => colorTemporal = color,
            pickerAreaHeightPercent: 0.7,
            enableAlpha: false,
            hexInputBar: true,
            displayThumbColor: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.btnCancelar),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => colorSeleccionado = colorTemporal);
              Navigator.pop(context);
            },
            child: Text(l10n.registroColorAplicar),
          ),
        ],
      ),
    );
  }

  Future<void> guardar() async {
    final l10n = AppLocalizations.of(context)!;

    if (nombreController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.perfilNombreVacio)));
      return;
    }
    if (passwordController.text.isNotEmpty &&
        passwordController.text != confirmarPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.registroPasswordsNoCoinciden)),
      );
      return;
    }

    setState(() => cargando = true);

    final respuesta = await ApiService.editarUsuario(
      id: widget.usuario.id,
      nombre: nombreController.text,
      password: passwordController.text.isNotEmpty
          ? passwordController.text
          : null,
      color: colorSeleccionado.toARGB32(),
      imagenPerfil:
          (_imagenLocal != widget.usuario.imagenPerfil && !_limpiarImagen)
          ? _imagenLocal
          : null,
      limpiarImagen: _limpiarImagen,
    );

    setState(() => cargando = false);
    if (!mounted) return;

    final key = respuesta['messageKey'] as String? ?? '';
    final mensaje = key == 'apiPerfilActualizadoOk'
        ? l10n.apiPerfilActualizadoOk
        : l10n.apiNombreEnUso;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));

    if (respuesta['success'] == true) {
      widget.onActualizado();
      Navigator.pop(context);
    }
  }

  Usuario get _usuarioPreview => Usuario(
    id: widget.usuario.id,
    nombre: nombreController.text.isNotEmpty
        ? nombreController.text
        : widget.usuario.nombre,
    color: colorSeleccionado,
    imagenPerfil: _limpiarImagen ? null : _imagenLocal,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.perfilTitulo)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    AvatarUsuario(usuario: _usuarioPreview, size: 96),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OutlinedButton.icon(
                          icon: const Icon(Icons.photo_library, size: 16),
                          label: Text(l10n.perfilCambiarImagen),
                          onPressed: _elegirImagen,
                        ),
                        if (_imagenLocal != null) ...[
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.close, size: 16),
                            label: Text(l10n.perfilQuitarImagen),
                            onPressed: _quitarImagen,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nombreController,
                decoration: InputDecoration(labelText: l10n.registroUsuario),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: l10n.perfilNuevaPassword,
                  hintText: l10n.perfilNuevaPasswordHint,
                ),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmarPasswordController,
                decoration: InputDecoration(
                  labelText: l10n.perfilRepetirNuevaPassword,
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.perfilColorTitulo,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _abrirColorPicker,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: colorSeleccionado,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                  ),
                  child: const Icon(Icons.colorize, color: Colors.white),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.perfilColorTocar,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: cargando ? null : guardar,
                  child: cargando
                      ? const CircularProgressIndicator()
                      : Text(l10n.perfilGuardarCambios),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
