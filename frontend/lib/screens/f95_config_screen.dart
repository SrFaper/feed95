import 'package:flutter/material.dart';
import '../services/f95_service.dart';
import 'package:frontend/l10n/app_localizations.dart';

class F95ConfigScreen extends StatefulWidget {
  const F95ConfigScreen({super.key});

  @override
  State<F95ConfigScreen> createState() => _F95ConfigScreenState();
}

class _F95ConfigScreenState extends State<F95ConfigScreen> {
  final usuarioController = TextEditingController();
  final passwordController = TextEditingController();
  bool cargando = false;
  bool tieneSesion = false;

  @override
  void initState() {
    super.initState();
    _verificar();
  }

  Future<void> _verificar() async {
    final tiene = await F95Service.tieneSesion();
    setState(() => tieneSesion = tiene);
  }

  Future<void> _login() async {
    final l10n = AppLocalizations.of(context)!;
    if (usuarioController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.f95CamposObligatorios)),
      );
      return;
    }
    setState(() => cargando = true);
    final ok = await F95Service.login(
      usuario: usuarioController.text,
      password: passwordController.text,
    );
    setState(() => cargando = false);
    if (!mounted) return;
    if (ok) {
      setState(() => tieneSesion = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.f95SesionOk)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.f95ErrorSesion)),
      );
    }
  }

  Future<void> _cerrarSesion() async {
    final l10n = AppLocalizations.of(context)!;
    await F95Service.cerrarSesion();
    if (!mounted) return;
    setState(() => tieneSesion = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.f95SesionCerrada)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.f95Titulo)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: tieneSesion
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Color.fromARGB(255, 255, 54, 71),
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.f95SesionActivaTitulo,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.f95SesionActivaDescripcion,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: Text(l10n.f95CerrarSesion),
                    onPressed: _cerrarSesion,
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.f95ConectarTitulo,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.f95ConectarDescripcion,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: usuarioController,
                    decoration: InputDecoration(labelText: l10n.f95Usuario),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: l10n.f95Password),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: cargando ? null : _login,
                      child: cargando
                          ? const CircularProgressIndicator()
                          : Text(l10n.f95IniciarSesion),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
