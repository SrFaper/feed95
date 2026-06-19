import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:frontend/l10n/app_localizations.dart';

const String kFeed95Version = '1.0.0'; // mantener sincronizado con pubspec.yaml
const String kFeed95RepoUrl = 'https://github.com/SrFaper/feed95';

class AcercaScreen extends StatelessWidget {
  const AcercaScreen({super.key});

  Future<void> _abrirUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _seccion(BuildContext context, String titulo, Widget contenido) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 8),
          contenido,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.acercaTitulo)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.videogame_asset,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Feed95',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'v$kFeed95Version',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          _seccion(
            context,
            l10n.acercaQueEs,
            Text(l10n.acercaDescripcion, style: const TextStyle(height: 1.4)),
          ),

          _seccion(
            context,
            l10n.acercaCodigo,
            OutlinedButton.icon(
              icon: const Icon(Icons.code, size: 16),
              label: const Text('GitHub'),
              onPressed: () => _abrirUrl(kFeed95RepoUrl),
            ),
          ),

          _seccion(
            context,
            l10n.acercaLicencia,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.acercaLicenciaTexto,
                  style: const TextStyle(height: 1.4),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () =>
                      _abrirUrl('$kFeed95RepoUrl/blob/main/LICENSE'),
                  child: Text(l10n.acercaVerLicenciaCompleta),
                ),
              ],
            ),
          ),

          _seccion(
            context,
            l10n.acercaFuentesDatos,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• Steam/Valve — store.steampowered.com/api',
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  '• Epic Games Store — GraphQL público',
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 4),
                const Text(
                  '• Game data provided by IGDB.com',
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.acercaFuentesDatosNota,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),

          _seccion(
            context,
            l10n.acercaCreditos,
            OutlinedButton.icon(
              icon: const Icon(Icons.list_alt, size: 16),
              label: Text(l10n.acercaVerLicenciasPaquetes),
              onPressed: () => showLicensePage(
                context: context,
                applicationName: 'Feed95',
                applicationVersion: kFeed95Version,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
