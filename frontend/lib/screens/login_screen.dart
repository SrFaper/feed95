import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../main.dart';
import 'home_screen.dart';
import 'registro_screen.dart';
import 'package:frontend/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final nombreController = TextEditingController();
  final passwordController = TextEditingController();
  bool cargando = false;

  Future<void> iniciarSesion() async {
    final l10n = AppLocalizations.of(context)!;

    if (nombreController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.registroCamposObligatorios)));
      return;
    }

    setState(() => cargando = true);

    final respuesta = await ApiService.login(
      nombre: nombreController.text,
      password: passwordController.text,
    );

    setState(() => cargando = false);

    if (!mounted) return;

    if (respuesta['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('usuario_id', respuesta['usuario']['id'] as int);
      final usuario = ApiService.convertirUsuario(respuesta['usuario']);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomeScreen(usuario: usuario, appState: Feed95App.of(context)),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.perfilesPasswordIncorrecta)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: const Text('Feed95')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.perfilesTitulo,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: l10n.registroUsuario),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: l10n.perfilesInputPassword,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: cargando ? null : iniciarSesion,
              child: cargando
                  ? const CircularProgressIndicator()
                  : Text(l10n.btnEnter),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistroScreen(),
                  ),
                );
              },
              child: Text(l10n.loginSinCuenta),
            ),
          ],
        ),
      ),
    );
  }
}
