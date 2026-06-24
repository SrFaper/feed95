import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
export 'imagen_ajustada.dart' show ModoAjuste;
import 'imagen_ajustada.dart' show ModoAjuste;

/// Resultado del ajuste. Su significado depende del [ModoAjuste] con el que
/// se haya abierto el editor:
///
/// - [ModoAjuste.rect]: offsetX/offsetY = esquina superior izquierda del
///   recorte, cropW/cropH = ancho/alto. Todo en fracción 0-1. (0,0,1,1) =
///   toda la imagen.
///
/// - [ModoAjuste.foco]: offsetX/offsetY = punto focal (fracción 0-1 del
///   centro de interés), cropW = factor de zoom (1 = cover completo, menor =
///   más acercado). cropH no se usa, se guarda igual a cropW por
///   compatibilidad.
class AjusteImagen {
  final double offsetX;
  final double offsetY;
  final double zoom;
  final double cropW;
  final double cropH;

  const AjusteImagen({
    this.offsetX = 0,
    this.offsetY = 0,
    this.zoom = 1,
    this.cropW = 1,
    this.cropH = 1,
  });
}

/// Editor de recorte/encuadre interactivo.
///
/// El lienzo muestra la imagen completa (contain). Sobre ella se dibuja un
/// marco de selección con la proporción [aspectRatio] que el usuario puede
/// mover (arrastrar) y escalar (pellizco táctil o rueda del mouse).
class EditorAjusteImagenScreen extends StatefulWidget {
  final String? imagenUrl;
  final String? imagenLocal;
  final double aspectRatio;
  final AjusteImagen ajusteInicial;
  final ModoAjuste modo;

  const EditorAjusteImagenScreen({
    super.key,
    this.imagenUrl,
    this.imagenLocal,
    required this.aspectRatio,
    this.ajusteInicial = const AjusteImagen(),
    this.modo = ModoAjuste.rect,
  });

  @override
  State<EditorAjusteImagenScreen> createState() =>
      _EditorAjusteImagenScreenState();
}

class _EditorAjusteImagenScreenState extends State<EditorAjusteImagenScreen> {
  // Región de recorte en fracción de la imagen real (0-1).
  late double _cropX;
  late double _cropY;
  late double _cropW;
  late double _cropH;

  double _cropWBase = 1;
  double _cropHBase = 1;

  // ── Gestión de imagen ────────────────────────────────────────────────────
  // Usamos ImageInfo en lugar de ui.Image directamente para que Flutter pueda
  // gestionar el refcount correctamente. Al hacer dispose() de este widget,
  // llamamos _imageInfo?.dispose() para liberar la referencia y permitir que
  // el PaintingCache descarte la textura si nadie más la referencia.
  // La versión anterior guardaba ui.Image sin dispose, dejando la textura
  // en RAM mientras el editor estuviera en el historial de navegación.
  ImageInfo? _imageInfo;
  bool _cargando = true;
  String? _error;

  ImageStream? _stream;
  late ImageStreamListener _listener;

  static const double _minCropFraction = 0.1;

  bool get _esModoFoco => widget.modo == ModoAjuste.foco;

  // Estado táctil/mouse temporal durante el gesto
  Offset _focoInicio = Offset.zero;
  double _cropXInicio = 0;
  double _cropYInicio = 0;
  double _cropWInicio = 1;

  @override
  void initState() {
    super.initState();
    _listener = ImageStreamListener(
      (ImageInfo info, bool synchronousCall) {
        if (!mounted) return;
        final anterior = _imageInfo;
        setState(() {
          _imageInfo = info;
          _cargando = false;
          _calcularBase();
          _inicializarDesdeAjuste();
        });
        // Liberar la referencia anterior después del setState para que el
        // painter ya tenga la nueva imagen antes de que descartemos la vieja.
        anterior?.dispose();
      },
      onError: (Object exception, StackTrace? stackTrace) {
        if (!mounted) return;
        setState(() {
          _error = 'No se pudo cargar la imagen';
          _cargando = false;
        });
      },
    );
    _resolveStream();
  }

  @override
  void dispose() {
    // Cancelar el stream primero para que el listener no intente actualizar
    // estado después de que el widget esté desmontado.
    _stream?.removeListener(_listener);
    _stream = null;
    // Liberar la referencia al ImageInfo. Sin esto, la textura decodificada
    // quedaría en RAM hasta que el GC de Dart la recoja eventualmente, lo
    // que puede tardar varios segundos o minutos.
    _imageInfo?.dispose();
    _imageInfo = null;
    super.dispose();
  }

  ImageProvider get _imageProvider {
    if (widget.imagenLocal != null && widget.imagenLocal!.isNotEmpty) {
      return FileImage(File(widget.imagenLocal!));
    }
    return NetworkImage(widget.imagenUrl ?? '');
  }

  void _resolveStream() {
    final stream = _imageProvider.resolve(ImageConfiguration.empty);
    _stream = stream;
    stream.addListener(_listener);
  }

  void _calcularBase() {
    final image = _imageInfo?.image;
    if (image == null) return;
    final imgW = image.width.toDouble();
    final imgH = image.height.toDouble();
    final imgAspect = imgW / imgH;

    double cropWFrac, cropHFrac;
    if (imgAspect > widget.aspectRatio) {
      cropHFrac = 1.0;
      cropWFrac = (imgH * widget.aspectRatio) / imgW;
    } else {
      cropWFrac = 1.0;
      cropHFrac = (imgW / widget.aspectRatio) / imgH;
    }
    _cropWBase = cropWFrac.clamp(0.0, 1.0);
    _cropHBase = cropHFrac.clamp(0.0, 1.0);
  }

  void _inicializarDesdeAjuste() {
    final a = widget.ajusteInicial;
    final esDefault =
        a.offsetX == 0 && a.offsetY == 0 && a.cropW == 1 && a.cropH == 1;

    if (esDefault) {
      _cropW = _cropWBase;
      _cropH = _cropHBase;
      _cropX = (1 - _cropW) / 2;
      _cropY = (1 - _cropH) / 2;
      return;
    }

    if (_esModoFoco) {
      final zoom = a.cropW.clamp(_minCropFraction, 1.0);
      _cropW = (_cropWBase * zoom).clamp(_minCropFraction, 1.0);
      _cropH = (_cropHBase * zoom).clamp(_minCropFraction, 1.0);
      _cropX = (a.offsetX - _cropW / 2).clamp(0.0, 1 - _cropW);
      _cropY = (a.offsetY - _cropH / 2).clamp(0.0, 1 - _cropH);
    } else {
      _cropX = a.offsetX;
      _cropY = a.offsetY;
      _cropW = a.cropW;
      _cropH = a.cropH;
    }
  }

  // ── Gestos ───────────────────────────────────────────────────────────────

  void _onScaleStart(ScaleStartDetails details) {
    _focoInicio = details.localFocalPoint;
    _cropXInicio = _cropX;
    _cropYInicio = _cropY;
    _cropWInicio = _cropW;
  }

  void _onScaleUpdate(ScaleUpdateDetails details, Size lienzoSize) {
    if (details.pointerCount >= 2) {
      _cambiarTamanoCrop(_cropWInicio / details.scale);
    } else {
      setState(() {
        final delta = details.localFocalPoint - _focoInicio;
        final deltaXFrac = delta.dx / lienzoSize.width;
        final deltaYFrac = delta.dy / lienzoSize.height;
        _cropX = (_cropXInicio + deltaXFrac).clamp(0.0, 1 - _cropW);
        _cropY = (_cropYInicio + deltaYFrac).clamp(0.0, 1 - _cropH);
      });
    }
  }

  void _onPointerScroll(PointerScrollEvent event) {
    final factor = event.scrollDelta.dy > 0 ? 1.08 : 1 / 1.08;
    _cambiarTamanoCrop(_cropW * factor);
  }

  void _cambiarTamanoCrop(double nuevoCropW) {
    final image = _imageInfo?.image;
    if (image == null) return;
    final imgAspect = image.width / image.height;
    final nuevoCropH =
        (nuevoCropW * image.width) / widget.aspectRatio / image.height;

    final cropWClamped = nuevoCropW.clamp(_minCropFraction, 1.0);
    final cropHClamped = nuevoCropH.clamp(_minCropFraction / imgAspect, 1.0);

    setState(() {
      final centroX = _cropX + _cropW / 2;
      final centroY = _cropY + _cropH / 2;
      _cropW = cropWClamped;
      _cropH = cropHClamped;
      _cropX = (centroX - _cropW / 2).clamp(0.0, 1 - _cropW);
      _cropY = (centroY - _cropH / 2).clamp(0.0, 1 - _cropH);
    });
  }

  void _resetear() {
    setState(() {
      _cropW = _cropWBase;
      _cropH = _cropHBase;
      _cropX = (1 - _cropW) / 2;
      _cropY = (1 - _cropH) / 2;
    });
  }

  void _aplicar() {
    AjusteImagen resultado;
    if (_esModoFoco) {
      final centroX = _cropX + _cropW / 2;
      final centroY = _cropY + _cropH / 2;
      final zoom = (_cropW / _cropWBase).clamp(_minCropFraction, 1.0);
      resultado = AjusteImagen(
        offsetX: centroX,
        offsetY: centroY,
        cropW: zoom,
        cropH: zoom,
      );
    } else {
      resultado = AjusteImagen(
        offsetX: _cropX,
        offsetY: _cropY,
        cropW: _cropW,
        cropH: _cropH,
      );
    }
    Navigator.pop(context, resultado);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          _esModoFoco ? 'Ajustar punto de enfoque' : 'Ajustar encuadre',
        ),
        actions: [
          if (!_cargando && _error == null)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Restablecer',
              onPressed: _resetear,
            ),
        ],
      ),
      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white54),
            )
          : _error != null
          ? Center(
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.white54),
              ),
            )
          : _buildEditor(),
    );
  }

  Widget _buildEditor() {
    final image = _imageInfo?.image;
    if (image == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white54),
      );
    }

    return Column(
      children: [
        Expanded(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxW = constraints.maxWidth * 0.94;
                final maxH = constraints.maxHeight * 0.94;
                final imgAspect = image.width / image.height;

                double lienzoW = maxW;
                double lienzoH = lienzoW / imgAspect;
                if (lienzoH > maxH) {
                  lienzoH = maxH;
                  lienzoW = lienzoH * imgAspect;
                }
                final lienzoSize = Size(lienzoW, lienzoH);

                return Listener(
                  onPointerSignal: (event) {
                    if (event is PointerScrollEvent) {
                      _onPointerScroll(event);
                    }
                  },
                  child: GestureDetector(
                    onScaleStart: _onScaleStart,
                    onScaleUpdate: (d) => _onScaleUpdate(d, lienzoSize),
                    child: SizedBox(
                      width: lienzoW,
                      height: lienzoH,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Usamos RawImage para renderizar directamente desde
                          // el ui.Image del ImageInfo sin pasar por un
                          // ImageProvider adicional, evitando doble decodificado.
                          RawImage(
                            image: image,
                            fit: BoxFit.fill,
                            width: lienzoW,
                            height: lienzoH,
                          ),
                          IgnorePointer(
                            child: CustomPaint(
                              painter: _MarcoSeleccionPainter(
                                cropX: _cropX,
                                cropY: _cropY,
                                cropW: _cropW,
                                cropH: _cropH,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Text(
            _esModoFoco
                ? 'Arrastra para elegir qué parte mostrar. Pellizca (o usa '
                      'la rueda del mouse) para acercar. Este recorte se '
                      'adapta solo al tamaño de la ventana, sin deformarse.'
                : 'Arrastra para mover. Pellizca con dos dedos (o usa la '
                      'rueda del mouse) para acercar o alejar el marco.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _aplicar,
                    child: const Text('Aplicar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Painter del marco de selección — sin cambios ─────────────────────────────

class _MarcoSeleccionPainter extends CustomPainter {
  final double cropX, cropY, cropW, cropH;

  _MarcoSeleccionPainter({
    required this.cropX,
    required this.cropY,
    required this.cropW,
    required this.cropH,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final marcoRect = Rect.fromLTWH(
      cropX * size.width,
      cropY * size.height,
      cropW * size.width,
      cropH * size.height,
    );

    final overlayPaint = Paint()..color = Colors.black.withValues(alpha: 0.6);
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(marcoRect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, overlayPaint);

    final bordePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(marcoRect, bordePaint);

    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..strokeWidth = 1;
    for (int i = 1; i < 3; i++) {
      final x = marcoRect.left + marcoRect.width * i / 3;
      canvas.drawLine(
        Offset(x, marcoRect.top),
        Offset(x, marcoRect.bottom),
        gridPaint,
      );
      final y = marcoRect.top + marcoRect.height * i / 3;
      canvas.drawLine(
        Offset(marcoRect.left, y),
        Offset(marcoRect.right, y),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MarcoSeleccionPainter oldDelegate) {
    return oldDelegate.cropX != cropX ||
        oldDelegate.cropY != cropY ||
        oldDelegate.cropW != cropW ||
        oldDelegate.cropH != cropH;
  }
}
