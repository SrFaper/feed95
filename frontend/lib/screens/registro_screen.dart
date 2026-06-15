import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../services/api_service.dart';
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

  Future<void> registrar() async {
    final l10n = AppLocalizations.of(context)!;

    if (nombreController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmarPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.registroCamposObligatorios)));
      return;
    }
    if (passwordController.text != confirmarPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.registroPasswordsNoCoinciden)),
      );
      return;
    }

    setState(() => cargando = true);
    final respuesta = await ApiService.registrarUsuario(
      nombre: nombreController.text,
      password: passwordController.text,
      color: colorSeleccionado.toARGB32(),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final inicial = nombreController.text.isNotEmpty
        ? nombreController.text[0].toUpperCase()
        : '?';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.registroTitulo)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: colorSeleccionado,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      inicial,
                      style: const TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                  child: cargando
                      ? const CircularProgressIndicator()
                      : Text(l10n.btnCrearPerfil),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
