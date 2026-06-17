import 'dart:io';
import 'package:flutter/material.dart';

/// Vista previa de imagen que distingue entre original y override.
/// - Si hay override (local o URL): se muestra normal, con botón "quitar".
/// - Si NO hay override pero hay original: se muestra atenuado + badge "Original".
/// - Si no hay nada: placeholder vacío.
class ImagenConOriginal extends StatelessWidget {
  final String? overrideUrl;
  final String? overrideLocal;
  final String origUrl;
  final String? origLocal;
  final VoidCallback onQuitarOverride;

  const ImagenConOriginal({
    super.key,
    required this.overrideUrl,
    required this.overrideLocal,
    required this.origUrl,
    required this.origLocal,
    required this.onQuitarOverride,
  });

  bool get _tieneOverride =>
      (overrideLocal != null && overrideLocal!.isNotEmpty) ||
      (overrideUrl != null && overrideUrl!.isNotEmpty);

  bool get _tieneOriginal =>
      (origLocal != null && origLocal!.isNotEmpty) || origUrl.isNotEmpty;

  Widget _imagenWidget({String? local, String? url, required bool atenuada}) {
    Widget img;
    if (local != null && local.isNotEmpty) {
      img = Image.file(
        File(local),
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const SizedBox(),
      );
    } else if (url != null && url.isNotEmpty) {
      img = Image.network(
        url,
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const SizedBox(),
      );
    } else {
      return const SizedBox();
    }
    if (atenuada) {
      return Opacity(opacity: 0.45, child: img);
    }
    return img;
  }

  @override
  Widget build(BuildContext context) {
    if (!_tieneOverride && !_tieneOriginal) return const SizedBox();

    final mostrarOverride = _tieneOverride;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          mostrarOverride
              ? _imagenWidget(
                  local: overrideLocal,
                  url: overrideUrl,
                  atenuada: false,
                )
              : _imagenWidget(local: origLocal, url: origUrl, atenuada: true),
          if (!mostrarOverride && _tieneOriginal)
            Positioned(
              bottom: 6,
              left: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Original (sin personalizar)',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ),
          if (mostrarOverride)
            Positioned(
              top: 4,
              right: 4,
              child: Material(
                color: Colors.black.withValues(alpha: 0.55),
                shape: const CircleBorder(),
                child: IconButton(
                  icon: const Icon(Icons.close, size: 16, color: Colors.white),
                  tooltip: 'Quitar personalización (volver al original)',
                  onPressed: onQuitarOverride,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
