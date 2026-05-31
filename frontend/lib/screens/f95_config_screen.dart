import 'package:flutter/material.dart';
import '../services/f95_service.dart';

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
    if (usuarioController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa usuario y contraseña')),
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
        const SnackBar(content: Text('Sesión iniciada correctamente')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo iniciar sesión. Verifica tus datos.')),
      );
    }
  }

  Future<void> _cerrarSesion() async {
    await F95Service.cerrarSesion();
    if (!mounted) return;
    setState(() => tieneSesion = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sesión cerrada')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('F95Zone')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: tieneSesion
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle,
                      color: Color.fromARGB(255, 255, 54, 71), size: 48),
                  const SizedBox(height: 12),
                  const Text('Sesión activa',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                    'Las cookies de sesión están guardadas en tu dispositivo. '
                    'La búsqueda en F95Zone está disponible.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('Cerrar sesión'),
                    onPressed: _cerrarSesion,
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Conectar con F95Zone',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                    'Tus credenciales se usan solo para iniciar sesión. '
                    'Las cookies se guardan localmente en tu dispositivo.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: usuarioController,
                    decoration:
                        const InputDecoration(labelText: 'Usuario de F95Zone'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    decoration:
                        const InputDecoration(labelText: 'Contraseña'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: cargando ? null : _login,
                      child: cargando
                          ? const CircularProgressIndicator()
                          : const Text('Iniciar sesión'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}