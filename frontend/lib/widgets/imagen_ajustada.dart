import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Modo de interpretación de los 4 valores de recorte (cropX, cropY, cropW,
/// cropH) almacenados en la base de datos:
///
/// - [ModoAjuste.rect]: los 4 valores son un rectángulo absoluto sobre la
///   imagen original (cropX,cropY = esquina superior izquierda; cropW,cropH
///   = ancho/alto). Funciona perfecto cuando el contenedor SIEMPRE tiene la
///   misma proporción (como el grid, que siempre es 2:3). Si el contenedor
///   cambia de proporción, este rectángulo puede no coincidir y la imagen
///   se ve estirada.
///
/// - [ModoAjuste.foco]: cropX,cropY se interpretan como un PUNTO focal
///   (fracción 0-1 del centro de interés en la imagen), y cropW se
///   interpreta como un factor de ZOOM (1 = cover completo sin recortar de
///   más; valores menores = más acercado). En cada render se recalcula un
///   recorte tipo `BoxFit.cover` centrado en ese punto y ajustado a la
///   proporción ACTUAL del contenedor — por eso nunca se deforma, sin
///   importar cuánto cambie el tamaño de la ventana. Ideal para el banner
///   de detalle, cuyo contenedor no tiene una proporción fija.
enum ModoAjuste { rect, foco }

/// Renderiza la imagen aplicando el recorte/ajuste indicado, usando
/// drawImageRect para fidelidad exacta de píxeles.
///
/// Si no hay imagen, muestra el [placeholder] dado (o uno genérico).
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
  ui.Image? _image;
  bool _error = false;
  ImageProvider? _providerActual;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void didUpdateWidget(ImagenAjustada old) {
    super.didUpdateWidget(old);
    if (old.url != widget.url || old.local != widget.local) {
      _cargar();
    }
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

  void _cargar() {
    final provider = _provider;
    _providerActual = provider;
    if (provider == null) {
      setState(() {
        _image = null;
        _error = false;
      });
      return;
    }
    setState(() {
      _image = null;
      _error = false;
    });
    final stream = provider.resolve(const ImageConfiguration());
    late ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, _) {
        if (!mounted || _providerActual != provider) return;
        setState(() => _image = info.image);
        stream.removeListener(listener);
      },
      onError: (error, stackTrace) {
        if (!mounted || _providerActual != provider) return;
        setState(() => _error = true);
        stream.removeListener(listener);
      },
    );
    stream.addListener(listener);
  }

  Widget _placeholderDefault() {
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
    if (!widget._tieneImagen || _error) return _placeholderDefault();
    if (_image == null) return _placeholderDefault();

    return CustomPaint(
      painter: _RecortePainter(
        image: _image!,
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

class _RecortePainter extends CustomPainter {
  final ui.Image image;
  final double cropX, cropY, cropW, cropH;
  final ModoAjuste modo;

  _RecortePainter({
    required this.image,
    required this.cropX,
    required this.cropY,
    required this.cropW,
    required this.cropH,
    required this.modo,
  });

  /// Detecta si el crop en modo `rect` es el valor "sin ajustar" (toda la
  /// imagen). En ese caso no queremos estirarla: queremos un recorte tipo
  /// cover, igual que en modo `foco` con foco centrado y zoom completo.
  bool get _esRectDefault =>
      cropX == 0 && cropY == 0 && cropW == 1 && cropH == 1;

  /// Calcula un rectángulo fuente (en píxeles reales) tipo BoxFit.cover,
  /// centrado en el punto focal [focoX,focoY] (fracción 0-1 de la imagen),
  /// y reducido según [zoom] (1 = cover completo; menor = más acercado).
  /// Nunca deforma la imagen: siempre respeta el aspect ratio real del
  /// contenedor [dstSize], que puede cambiar libremente entre renders.
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

    // Tamaño del recorte "cover completo" (zoom = 1) para esta proporción.
    double srcW, srcH;
    if (imgAspect > dstAspect) {
      srcH = imgH;
      srcW = srcH * dstAspect;
    } else {
      srcW = imgW;
      srcH = srcW / dstAspect;
    }

    // Aplicar zoom (acercar reduce el área visible, sin cambiar proporción).
    final z = zoom.clamp(0.05, 1.0);
    srcW *= z;
    srcH *= z;

    // Centrar en el punto focal, sin salirse de los límites de la imagen.
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
      // cropX/cropY = punto focal (default 0.5,0.5 si nunca se ajustó).
      // cropW = factor de zoom (default 1 = cover completo).
      final esDefault = cropX == 0 && cropY == 0 && cropW == 1 && cropH == 1;
      final focoX = esDefault ? 0.5 : cropX;
      final focoY = esDefault ? 0.5 : cropY;
      final zoom = esDefault ? 1.0 : cropW;
      srcRect = _srcRectCoverFoco(size, focoX, focoY, zoom);
    } else if (_esRectDefault) {
      // Modo rect sin ajustar: comportarse como cover centrado (zoom=1,
      // foco=centro) para no estirar la imagen completa.
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
