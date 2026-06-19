import 'package:flutter/material.dart';
import 'imagen_ajustada.dart';

/// Vista previa de imagen que distingue entre original y override.
/// - Si hay override (local o URL): se muestra normal, con botón "quitar".
/// - Si NO hay override pero hay original: se muestra atenuado + badge "Original".
/// - Si no hay nada: placeholder vacío.
/// Usa ImagenAjustada internamente para aplicar el recorte/ajuste con
/// fidelidad exacta, según el [modo] (ver [ModoAjuste]).
class ImagenConOriginal extends StatelessWidget {
  final String? overrideUrl;
  final String? overrideLocal;
  final String origUrl;
  final String? origLocal;
  final VoidCallback onQuitarOverride;
  final double aspectRatio;
  final double cropX;
  final double cropY;
  final double cropW;
  final double cropH;
  final ModoAjuste modo;

  const ImagenConOriginal({
    super.key,
    required this.overrideUrl,
    required this.overrideLocal,
    required this.origUrl,
    required this.origLocal,
    required this.onQuitarOverride,
    this.aspectRatio = 16 / 9,
    this.cropX = 0,
    this.cropY = 0,
    this.cropW = 1,
    this.cropH = 1,
    this.modo = ModoAjuste.rect,
  });

  bool get _tieneOverride =>
      (overrideLocal != null && overrideLocal!.isNotEmpty) ||
      (overrideUrl != null && overrideUrl!.isNotEmpty);

  bool get _tieneOriginal =>
      (origLocal != null && origLocal!.isNotEmpty) || origUrl.isNotEmpty;

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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Opacity(
              opacity: mostrarOverride ? 1.0 : 0.45,
              child: ImagenAjustada(
                local: mostrarOverride ? overrideLocal : origLocal,
                url: mostrarOverride ? overrideUrl : origUrl,
                cropX: cropX,
                cropY: cropY,
                cropW: cropW,
                cropH: cropH,
                modo: modo,
                placeholder: const SizedBox(),
              ),
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
      ),
    );
  }
}
