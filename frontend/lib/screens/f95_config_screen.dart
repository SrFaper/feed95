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
  bool tieneCredenciales = false;

  @override
  void initState() {
    super.initState();
    _verificar();
  }

  Future<void> _verificar() async {
    final tiene = await F95Service.tieneCredenciales();
    setState(() => tieneCredenciales = tiene);
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
      setState(() => tieneCredenciales = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesión iniciada correctamente')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No se pudo iniciar sesión. Verifica tus datos.')),
      );
    }
  }

  Future<void> _cerrarSesion() async {
    await F95Service.cerrarSesion();
    if (!mounted) return;
    setState(() => tieneCredenciales = false);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (tieneCredenciales) ...[
              const Icon(Icons.check_circle, color: Colors.green, size: 48),
              const SizedBox(height: 12),
              const Text(
                'Sesión activa',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Las credenciales están guardadas en tu dispositivo. '
                'La sesión se renueva automáticamente al buscar.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
                onPressed: _cerrarSesion,
              ),
            ] else ...[
              const Text(
                'Conectar con F95Zone',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tus credenciales se guardan solo en este dispositivo '
                'y se usan únicamente para buscar metadatos.',
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
                decoration: const InputDecoration(labelText: 'Contraseña'),
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
          ],
        ),
      ),
    );
  }
}