import 'dart:io';
import 'package:flutter/material.dart';

/// Renderiza una imagen (red o local) dentro de un marco de proporción fija,
/// aplicando el ajuste de encuadre (offset + zoom) guardado para ese juego.
/// Si no hay imagen, muestra el [placeholder] dado (o uno genérico).
class ImagenAjustada extends StatelessWidget {
  final String? url;
  final String? local;
  final double offsetX;
  final double offsetY;
  final double zoom;
  final BoxFit fit;
  final Widget? placeholder;

  const ImagenAjustada({
    super.key,
    this.url,
    this.local,
    this.offsetX = 0,
    this.offsetY = 0,
    this.zoom = 1,
    this.fit = BoxFit.cover,
    this.placeholder,
  });

  bool get _tieneImagen =>
      (local != null && local!.isNotEmpty) || (url != null && url!.isNotEmpty);

  Widget _imagenBase(Size marcoSize) {
    if (local != null && local!.isNotEmpty) {
      return Image.file(
        File(local!),
        fit: fit,
        width: marcoSize.width,
        height: marcoSize.height,
        errorBuilder: (_, _, _) => _placeholderDefault(),
      );
    }
    return Image.network(
      url ?? '',
      fit: fit,
      width: marcoSize.width,
      height: marcoSize.height,
      errorBuilder: (_, _, _) => _placeholderDefault(),
    );
  }

  Widget _placeholderDefault() {
    return placeholder ??
        Container(
          color: Colors.grey.shade800,
          child: const Center(
            child: Icon(Icons.videogame_asset, color: Colors.white38),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    if (!_tieneImagen) return _placeholderDefault();

    return LayoutBuilder(
      builder: (context, constraints) {
        final marcoSize = Size(constraints.maxWidth, constraints.maxHeight);
        final base = _imagenBase(marcoSize);

        // Sin ajuste, se renderiza directo (evita Transform innecesario)
        if (offsetX == 0 && offsetY == 0 && zoom == 1) {
          return base;
        }

        return ClipRect(
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..translateByDouble(
                offsetX * marcoSize.width,
                offsetY * marcoSize.height,
                0,
                1,
              )
              ..scaleByDouble(zoom, zoom, zoom, 1),
            child: base,
          ),
        );
      },
    );
  }
}
