import 'package:flutter/material.dart';
import '../services/igdb_service.dart';
import 'package:frontend/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    if (_clientIdController.text.isEmpty ||
        _clientSecretController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.igdbCamposObligatorios)));
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.igdbCredencialesInvalidas)));
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

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.igdbConfiguradoOk)));
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.igdbTitulo)),
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
                  Text(
                    l10n.igdbConfiguradoTitulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.igdbConfiguradoDescripcion,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.delete_outline),
                    label: Text(l10n.igdbEliminarCredenciales),
                    onPressed: _limpiar,
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.igdbConfigurarTitulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.igdbDescripcion,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.igdbInstrucciones,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _clientIdController,
                    decoration: InputDecoration(labelText: l10n.igdbClientId),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _clientSecretController,
                    decoration: InputDecoration(
                      labelText: l10n.igdbClientSecret,
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
                          : Text(l10n.igdbGuardarVerificar),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
