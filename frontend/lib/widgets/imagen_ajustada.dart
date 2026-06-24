import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Modo de interpretación de los 4 valores de recorte almacenados en BD.
///
/// - [ModoAjuste.rect]: cropX/cropY = esquina superior izquierda del recorte,
///   cropW/cropH = ancho/alto. Todo en fracción 0-1. Ideal para el grid donde
///   el contenedor siempre tiene la misma proporción (2:3).
///
/// - [ModoAjuste.foco]: cropX/cropY = punto focal (fracción 0-1), cropW =
///   factor de zoom (1 = cover completo). Se recalcula en cada render según
///   la proporción actual del contenedor, nunca deforma la imagen. Ideal para
///   el banner de detalle donde el contenedor puede cambiar de tamaño.
enum ModoAjuste { rect, foco }

/// Renderiza una imagen con recorte/ajuste exacto usando [CustomPainter].
///
/// ## Por qué este widget gestiona memoria de forma diferente al anterior
///
/// La versión anterior guardaba el [ui.Image] decodificado directamente en el
/// estado local del widget (via [ImageStreamListener]). Esto significa que cada
/// instancia del widget mantenía su propia copia en RAM, completamente fuera
/// del control del [PaintingCache] de Flutter. Con 200 tarjetas en el grid,
/// eran 200 imágenes decodificadas simultáneamente, ~2 MB cada una = ~400 MB
/// solo en imágenes.
///
/// Esta versión resuelve el problema delegando la carga al [ImageProvider]
/// estándar de Flutter, que sí pasa por [PaintingCache]. El cache usa una
/// política LRU con límite configurable: cuando hay presión de memoria, descarta
/// las imágenes menos usadas. Cuando un widget sale del árbol (p.ej. se
/// scrollea fuera de pantalla), Flutter puede liberar su referencia al
/// [ImageInfo] y el cache decide si la conserva o la descarta.
///
/// El [CustomPainter] con [drawImageRect] se conserva porque es la forma más
/// eficiente de aplicar el recorte con fidelidad exacta de píxeles.
class ImagenAjustada extends StatefulWidget {
  final String? url;
  final String? local;
  final double cropX;
  final double cropY;
  final double cropW;
  final double cropH;
  final ModoAjuste modo;
  final Widget? placeholder;

  const ImagenAjustada({
    super.key,
    this.url,
    this.local,
    this.cropX = 0,
    this.cropY = 0,
    this.cropW = 1,
    this.cropH = 1,
    this.modo = ModoAjuste.rect,
    this.placeholder,
  });

  bool get _tieneImagen =>
      (local != null && local!.isNotEmpty) || (url != null && url!.isNotEmpty);

  @override
  State<ImagenAjustada> createState() => _ImagenAjustadaState();
}

class _ImagenAjustadaState extends State<ImagenAjustada> {
  // ImageInfo en lugar de ui.Image directamente: así Flutter sabe que este
  // widget tiene una referencia activa y puede gestionar el ciclo de vida.
  ImageInfo? _imageInfo;
  bool _error = false;

  // Stream activo — lo guardamos para poder cancelarlo al desmontar o cambiar.
  ImageStream? _stream;
  late ImageStreamListener _listener;

  @override
  void initState() {
    super.initState();
    // El listener se crea una sola vez. Actualiza el estado con el ImageInfo
    // cuando la imagen esté lista, o marca error si falla.
    _listener = ImageStreamListener(
      (ImageInfo info, bool synchronousCall) {
        if (!mounted) return;
        // Liberar el ImageInfo anterior antes de reemplazarlo.
        // Esto decremente el refcount interno de Flutter, permitiendo al
        // PaintingCache liberar la textura si nadie más la referencia.
        final anteriorInfo = _imageInfo;
        setState(() {
          _imageInfo = info;
          _error = false;
        });
        anteriorInfo?.dispose();
      },
      onError: (Object exception, StackTrace? stackTrace) {
        if (!mounted) return;
        setState(() => _error = true);
      },
    );
    _resolveStream();
  }

  @override
  void didUpdateWidget(ImagenAjustada oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Solo recargar si la fuente de imagen cambió realmente.
    if (oldWidget.url != widget.url || oldWidget.local != widget.local) {
      _cancelarStream();
      setState(() {
        _error = false;
        // Limpiar la imagen anterior inmediatamente para que el placeholder
        // aparezca mientras carga la nueva, en lugar de mostrar la imagen vieja.
        final anteriorInfo = _imageInfo;
        _imageInfo = null;
        anteriorInfo?.dispose();
      });
      _resolveStream();
    }
  }

  @override
  void dispose() {
    _cancelarStream();
    // Liberar la referencia al ImageInfo al desmontar el widget.
    // Esto es clave: sin este dispose(), el PaintingCache no puede liberar
    // la textura aunque el widget ya no esté en el árbol.
    _imageInfo?.dispose();
    _imageInfo = null;
    super.dispose();
  }

  ImageProvider? get _provider {
    if (widget.local != null && widget.local!.isNotEmpty) {
      return FileImage(File(widget.local!));
    }
    if (widget.url != null && widget.url!.isNotEmpty) {
      return NetworkImage(widget.url!);
    }
    return null;
  }

  void _resolveStream() {
    final provider = _provider;
    if (provider == null) return;

    // resolve() devuelve el stream del PaintingCache. Si la imagen ya está
    // cacheada, el listener se llama de forma síncrona. Si no, se descarga
    // o decodifica y se llama cuando esté lista.
    final stream = provider.resolve(ImageConfiguration.empty);
    _stream = stream;
    stream.addListener(_listener);
  }

  void _cancelarStream() {
    _stream?.removeListener(_listener);
    _stream = null;
  }

  Widget _placeholder() {
    return widget.placeholder ??
        Container(
          color: Colors.grey.shade800,
          child: const Center(
            child: Icon(Icons.videogame_asset, color: Colors.white38),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget._tieneImagen || _error) return _placeholder();

    final image = _imageInfo?.image;
    if (image == null) return _placeholder();

    return CustomPaint(
      painter: _RecortePainter(
        image: image,
        cropX: widget.cropX,
        cropY: widget.cropY,
        cropW: widget.cropW,
        cropH: widget.cropH,
        modo: widget.modo,
      ),
      child: const SizedBox.expand(),
    );
  }
}

// ── Painter — sin cambios de lógica respecto a la versión anterior ───────────

class _RecortePainter extends CustomPainter {
  final ui.Image image;
  final double cropX, cropY, cropW, cropH;
  final ModoAjuste modo;

  const _RecortePainter({
    required this.image,
    required this.cropX,
    required this.cropY,
    required this.cropW,
    required this.cropH,
    required this.modo,
  });

  bool get _esRectDefault =>
      cropX == 0 && cropY == 0 && cropW == 1 && cropH == 1;

  Rect _srcRectCoverFoco(
    Size dstSize,
    double focoX,
    double focoY,
    double zoom,
  ) {
    final imgW = image.width.toDouble();
    final imgH = image.height.toDouble();
    final imgAspect = imgW / imgH;
    final dstAspect = dstSize.width / dstSize.height;

    double srcW, srcH;
    if (imgAspect > dstAspect) {
      srcH = imgH;
      srcW = srcH * dstAspect;
    } else {
      srcW = imgW;
      srcH = srcW / dstAspect;
    }

    final z = zoom.clamp(0.05, 1.0);
    srcW *= z;
    srcH *= z;

    double srcX = focoX * imgW - srcW / 2;
    double srcY = focoY * imgH - srcH / 2;
    srcX = srcX.clamp(0.0, (imgW - srcW).clamp(0.0, imgW));
    srcY = srcY.clamp(0.0, (imgH - srcH).clamp(0.0, imgH));

    return Rect.fromLTWH(srcX, srcY, srcW, srcH);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect srcRect;

    if (modo == ModoAjuste.foco) {
      final esDefault = cropX == 0 && cropY == 0 && cropW == 1 && cropH == 1;
      final focoX = esDefault ? 0.5 : cropX;
      final focoY = esDefault ? 0.5 : cropY;
      final zoom = esDefault ? 1.0 : cropW;
      srcRect = _srcRectCoverFoco(size, focoX, focoY, zoom);
    } else if (_esRectDefault) {
      srcRect = _srcRectCoverFoco(size, 0.5, 0.5, 1.0);
    } else {
      srcRect = Rect.fromLTWH(
        cropX * image.width,
        cropY * image.height,
        cropW * image.width,
        cropH * image.height,
      );
    }

    final dstRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(image, srcRect, dstRect, Paint());
  }

  @override
  bool shouldRepaint(covariant _RecortePainter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.cropX != cropX ||
        oldDelegate.cropY != cropY ||
        oldDelegate.cropW != cropW ||
        oldDelegate.cropH != cropH ||
        oldDelegate.modo != modo;
  }
}
