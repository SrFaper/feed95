import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../widgets/avatar_usuario.dart';
import '../models/usuario.dart';
import 'package:frontend/l10n/app_localizations.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final nombreController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmarPasswordController = TextEditingController();
  Color colorSeleccionado = const Color.fromARGB(255, 255, 54, 71);
  String? _imagenLocal;
  bool _usarPassword = false;
  bool cargando = false;

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

  Future<void> _elegirImagen() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imagenLocal = picked.path);
    }
  }

  Future<void> registrar() async {
    final l10n = AppLocalizations.of(context)!;

    if (nombreController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.registroCamposObligatorios)));
      return;
    }
    if (_usarPassword) {
      if (passwordController.text.isEmpty ||
          confirmarPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.registroCamposObligatorios)),
        );
        return;
      }
      if (passwordController.text != confirmarPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.registroPasswordsNoCoinciden)),
        );
        return;
      }
    }

    setState(() => cargando = true);
    final respuesta = await ApiService.registrarUsuario(
      nombre: nombreController.text,
      password: _usarPassword ? passwordController.text : '',
      color: colorSeleccionado.toARGB32(),
      imagenPerfil: _imagenLocal,
    );
    setState(() => cargando = false);
    if (!mounted) return;
    final key = respuesta['messageKey'] as String? ?? '';
    final mensaje = key == 'apiPerfilCreadoOk'
        ? l10n.apiPerfilCreadoOk
        : l10n.apiNombreDuplicado;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
    if (respuesta['success'] == true) {
      Navigator.pop(context);
    }
  }

  // Preview del avatar con los datos actuales del formulario
  Usuario get _usuarioPreview => Usuario(
    id: 0,
    nombre: nombreController.text.isNotEmpty ? nombreController.text : '?',
    color: colorSeleccionado,
    imagenPerfil: _imagenLocal,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.registroTitulo)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Avatar preview con botón de imagen
              Center(
                child: Column(
                  children: [
                    AvatarUsuario(usuario: _usuarioPreview, size: 96),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.photo_library, size: 16),
                      label: Text(
                        _imagenLocal != null
                            ? l10n.perfilCambiarImagen
                            : l10n.registroAgregarImagen,
                      ),
                      onPressed: _elegirImagen,
                    ),
                    if (_imagenLocal != null) ...[
                      const SizedBox(height: 6),
                      TextButton.icon(
                        icon: const Icon(Icons.close, size: 14),
                        label: Text(l10n.perfilQuitarImagen),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () => setState(() => _imagenLocal = null),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),
              TextField(
                controller: nombreController,
                decoration: InputDecoration(labelText: l10n.registroUsuario),
                onChanged: (_) => setState(() {}),
              ),

              // Switch contraseña
              const SizedBox(height: 16),
              Row(
                children: [
                  Switch(
                    value: _usarPassword,
                    onChanged: (v) => setState(() {
                      _usarPassword = v;
                      if (!v) {
                        passwordController.clear();
                        confirmarPasswordController.clear();
                      }
                    }),
                    activeThumbColor: primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.registroUsarPassword,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),

              if (_usarPassword) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: l10n.registroPassword),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmarPasswordController,
                  decoration: InputDecoration(
                    labelText: l10n.registroRepetirPassword,
                  ),
                  obscureText: true,
                ),
              ],

              const SizedBox(height: 24),
              Text(
                l10n.registroColorPerfil,
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
                l10n.registroTocaColor,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: cargando ? null : registrar,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: cargando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.person_add, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              l10n.btnCrearPerfil,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
