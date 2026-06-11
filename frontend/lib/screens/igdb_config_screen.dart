import 'package:flutter/material.dart';
import '../services/igdb_service.dart';

class IgdbConfigScreen extends StatefulWidget {
  const IgdbConfigScreen({super.key});

  @override
  State<IgdbConfigScreen> createState() => _IgdbConfigScreenState();
}

class _IgdbConfigScreenState extends State<IgdbConfigScreen> {
  final _clientIdController = TextEditingController();
  final _clientSecretController = TextEditingController();
  bool _cargando = false;
  bool _tieneCredenciales = false;
  bool _mostrarSecret = false;

  @override
  void initState() {
    super.initState();
    _verificar();
  }

  Future<void> _verificar() async {
    final tiene = await IgdbService.tieneCredenciales();
    if (!mounted) return;
    setState(() => _tieneCredenciales = tiene);
  }

  Future<void> _guardar() async {
    if (_clientIdController.text.isEmpty ||
        _clientSecretController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Completa ambos campos')));
      return;
    }
    setState(() => _cargando = true);

    final validas = await IgdbService.verificarCredenciales(
      clientId: _clientIdController.text.trim(),
      clientSecret: _clientSecretController.text.trim(),
    );

    if (!validas) {
      setState(() => _cargando = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Credenciales inválidas. Verifica tus datos.'),
        ),
      );
      return;
    }

    await IgdbService.guardarCredenciales(
      clientId: _clientIdController.text.trim(),
      clientSecret: _clientSecretController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _cargando = false;
      _tieneCredenciales = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('IGDB configurado correctamente')),
    );
  }

  Future<void> _limpiar() async {
    await IgdbService.limpiarCredenciales();
    if (!mounted) return;
    setState(() => _tieneCredenciales = false);
    _clientIdController.clear();
    _clientSecretController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IGDB')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _tieneCredenciales
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Color.fromARGB(255, 255, 54, 71),
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'IGDB configurado',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Las credenciales están guardadas localmente. '
                    'El botón IGDB está disponible al añadir juegos.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Eliminar credenciales'),
                    onPressed: _limpiar,
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Configurar IGDB',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'IGDB es la base de datos de videojuegos de Twitch. '
                    'Es gratuita y cubre prácticamente cualquier juego.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '¿Cómo obtener credenciales?\n'
                    '1. Ve a dev.twitch.tv\n'
                    '2. Inicia sesión con tu cuenta de Twitch\n'
                    '3. Crea una nueva aplicación (cualquier nombre)\n'
                    '4. Copia el Client-ID y genera un Client-Secret',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _clientIdController,
                    decoration: const InputDecoration(labelText: 'Client-ID'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _clientSecretController,
                    decoration: InputDecoration(
                      labelText: 'Client-Secret',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _mostrarSecret
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () =>
                            setState(() => _mostrarSecret = !_mostrarSecret),
                      ),
                    ),
                    obscureText: !_mostrarSecret,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _cargando ? null : _guardar,
                      child: _cargando
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Guardar y verificar'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
