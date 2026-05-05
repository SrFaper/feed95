import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import 'registro_screen.dart';

class PerfilScreen extends StatefulWidget {
  final Usuario usuario;
  final VoidCallback onActualizado;

  const PerfilScreen({
    super.key,
    required this.usuario,
    required this.onActualizado,
  });

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  late TextEditingController nombreController;
  late TextEditingController passwordController;
  late TextEditingController confirmarPasswordController;
  late Color colorSeleccionado;
  bool cargando = false;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.usuario.nombre);
    passwordController = TextEditingController();
    confirmarPasswordController = TextEditingController();
    colorSeleccionado = widget.usuario.color;
  }

  Future<void> guardar() async {
    if (nombreController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre no puede estar vacío')),
      );
      return;
    }

    if (passwordController.text.isNotEmpty &&
        passwordController.text != confirmarPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    setState(() => cargando = true);

    final respuesta = await ApiService.editarUsuario(
      id: widget.usuario.id,
      nombre: nombreController.text,
      password: passwordController.text.isNotEmpty ? passwordController.text : null,
      color: colorSeleccionado.toARGB32(),  // ← corregido: era .value
    );

    setState(() => cargando = false);

    if (!mounted) return;  // ← guard mounted

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(respuesta['message'])),
    );

    if (respuesta['success'] == true) {
      widget.onActualizado();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: colorSeleccionado,
                  child: Text(
                    nombreController.text.isNotEmpty
                        ? nombreController.text[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Usuario'),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Nueva contraseña',
                  hintText: 'Dejar vacío para no cambiar',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmarPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Repetir nueva contraseña',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              const Text('Color del perfil',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: coloresDisponibles.map((color) {
                  final seleccionado = color == colorSeleccionado;
                  return GestureDetector(
                    onTap: () => setState(() => colorSeleccionado = color),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: seleccionado
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                        boxShadow: seleccionado
                            ? [BoxShadow(
                                color: color.withValues(alpha: 0.6), // ← corregido: era withOpacity
                                blurRadius: 8,
                              )]
                            : null,
                      ),
                      child: seleccionado
                          ? const Icon(Icons.check, color: Colors.white, size: 20)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: cargando ? null : guardar,
                  child: cargando
                      ? const CircularProgressIndicator()
                      : const Text('Guardar cambios'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}