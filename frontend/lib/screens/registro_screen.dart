import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final nombreController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmarPasswordController = TextEditingController();
  bool cargando = false;

  Future<void> registrar() async {
    if (nombreController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmarPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete todos los campos')),
      );
      return;
    }

    if (passwordController.text != confirmarPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    setState(() => cargando = true);

    final respuesta = await ApiService.registrarUsuario(
      nombre: nombreController.text,
      password: passwordController.text,
    );

    setState(() => cargando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(respuesta['message'])),
    );

    if (respuesta['success'] == true) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Crear cuenta',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmarPasswordController,
              decoration: const InputDecoration(labelText: 'Repetir contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: cargando ? null : registrar,
              child: cargando
                  ? const CircularProgressIndicator()
                  : const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}