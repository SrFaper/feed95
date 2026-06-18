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
  final double aspectRatio;
  final double ajusteX;
  final double ajusteY;
  final double ajusteZoom;

  const ImagenConOriginal({
    super.key,
    required this.overrideUrl,
    required this.overrideLocal,
    required this.origUrl,
    required this.origLocal,
    required this.onQuitarOverride,
    this.aspectRatio = 16 / 9,
    this.ajusteX = 0,
    this.ajusteY = 0,
    this.ajusteZoom = 1,
  });

  bool get _tieneOverride =>
      (overrideLocal != null && overrideLocal!.isNotEmpty) ||
      (overrideUrl != null && overrideUrl!.isNotEmpty);

  bool get _tieneOriginal =>
      (origLocal != null && origLocal!.isNotEmpty) || origUrl.isNotEmpty;

  Widget _imagenWidget({
    String? local,
    String? url,
    required bool atenuada,
    required Size marcoSize,
  }) {
    Widget img;
    if (local != null && local.isNotEmpty) {
      img = Image.file(
        File(local),
        fit: BoxFit.cover,
        width: marcoSize.width,
        height: marcoSize.height,
        errorBuilder: (_, _, _) => const SizedBox(),
      );
    } else if (url != null && url.isNotEmpty) {
      img = Image.network(
        url,
        fit: BoxFit.cover,
        width: marcoSize.width,
        height: marcoSize.height,
        errorBuilder: (_, _, _) => const SizedBox(),
      );
    } else {
      return const SizedBox();
    }

    if (ajusteX != 0 || ajusteY != 0 || ajusteZoom != 1) {
      img = ClipRect(
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translateByDouble(
              ajusteX * marcoSize.width,
              ajusteY * marcoSize.height,
              0,
              1,
            )
            ..scaleByDouble(ajusteZoom, ajusteZoom, ajusteZoom, 1),
          child: img,
        ),
      );
    }

    if (atenuada) {
      return Opacity(opacity: 0.45, child: img);
    }
    return img;
  }

  @override
  Widget build(BuildContext context) {
    if (!_tieneOverride && !_tieneOriginal) {
      return AspectRatio(
        aspectRatio: aspectRatio,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF222222)),
          ),
          child: const Center(
            child: Icon(Icons.image_outlined, color: Colors.white24, size: 32),
          ),
        ),
      );
    }

    final mostrarOverride = _tieneOverride;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final marcoSize = Size(constraints.maxWidth, constraints.maxHeight);
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                mostrarOverride
                    ? _imagenWidget(
                        local: overrideLocal,
                        url: overrideUrl,
                        atenuada: false,
                        marcoSize: marcoSize,
                      )
                    : _imagenWidget(
                        local: origLocal,
                        url: origUrl,
                        atenuada: true,
                        marcoSize: marcoSize,
                      ),
                if (!mostrarOverride && _tieneOriginal)
                  Positioned(
                    bottom: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Original',
                        style: TextStyle(color: Colors.white, fontSize: 10),
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
                        icon: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                        tooltip: 'Quitar personalización (volver al original)',
                        onPressed: onQuitarOverride,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
