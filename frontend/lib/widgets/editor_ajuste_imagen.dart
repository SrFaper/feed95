import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
export 'imagen_ajustada.dart' show ModoAjuste;
import 'imagen_ajustada.dart' show ModoAjuste;

/// Resultado del ajuste. Su significado depende del [ModoAjuste] con el que
/// se haya abierto el editor:
///
/// - [ModoAjuste.rect] (grid/portada): offsetX/offsetY = esquina superior
///   izquierda del recorte, cropW/cropH = ancho/alto del recorte. Todo en
///   fracción 0-1 de la imagen original. (0,0,1,1) = toda la imagen.
///
/// - [ModoAjuste.foco] (detalle/banner): offsetX/offsetY = punto focal
///   (fracción 0-1 del centro de interés), cropW = factor de zoom (1 =
///   cover completo, menor = más acercado). cropH no se usa, se guarda
///   igual a cropW por compatibilidad. Este modo nunca deforma la imagen
///   sin importar cómo cambie la proporción del contenedor al usarse.
class AjusteImagen {
  final double offsetX;
  final double offsetY;
  final double zoom; // no usado, se mantiene a 1 por compatibilidad histórica
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

/// Editor de recorte/encuadre. El lienzo es SIEMPRE la imagen completa
/// (BoxFit.contain). Sobre ella se dibuja un marco de selección con la
/// proporción [aspectRatio] (de referencia visual), que el usuario puede
/// mover (arrastrar) y escalar (pellizcar en móvil, o rueda del mouse en
/// Windows/desktop), sin poder salir nunca de los límites de la imagen real.
///
/// El marco se ve y se maneja igual en ambos modos — la diferencia está en
/// qué se hace con el resultado al pulsar "Aplicar" (ver [AjusteImagen]).
///
/// NOTA sobre el gesto: Flutter no permite combinar un reconocedor de "pan"
/// y uno de "scale" en el mismo GestureDetector (scale ya es un superset de
/// pan; mezclarlos lanza "Incorrect GestureDetector arguments"). Por eso
/// todo el manejo de arrastre y zoom táctil pasa por onScaleStart/
/// onScaleUpdate, distinguiendo "mover" (1 puntero) de "zoom" (2+ punteros).
/// El zoom con rueda del mouse (típico en Windows) se maneja aparte con un
/// Listener de PointerScrollEvent.
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
  // En modo foco, esto es solo una representación visual interna: el marco
  // que el usuario ve y manipula. Al aplicar, se convierte a centro+zoom.
  late double _cropX;
  late double _cropY;
  late double _cropW;
  late double _cropH;

  // Tamaño del marco "base" (zoom = 1, cover completo) para el aspectRatio
  // de este editor. Se usa solo en modo foco para traducir entre el
  // rectángulo visual y el factor de zoom guardado.
  double _cropWBase = 1;
  double _cropHBase = 1;

  // Dimensiones reales de la imagen (se resuelven de forma asíncrona)
  int? _imgWidthPx;
  int? _imgHeightPx;
  bool _cargando = true;
  String? _error;

  // Estado táctil/mouse temporal durante el gesto (unificado pan+zoom)
  Offset _focoInicio = Offset.zero;
  double _cropXInicio = 0;
  double _cropYInicio = 0;
  double _cropWInicio = 1;

  static const double _minCropFraction =
      0.1; // no permitir recortes < 10% de la imagen

  bool get _esModoFoco => widget.modo == ModoAjuste.foco;

  @override
  void initState() {
    super.initState();
    _resolverDimensiones();
  }

  ImageProvider get _imageProvider {
    if (widget.imagenLocal != null && widget.imagenLocal!.isNotEmpty) {
      return FileImage(File(widget.imagenLocal!));
    }
    return NetworkImage(widget.imagenUrl ?? '');
  }

  void _resolverDimensiones() {
    final stream = _imageProvider.resolve(const ImageConfiguration());
    late ImageStreamListener listener;
    listener = ImageStreamListener(
      (ImageInfo info, bool _) {
        if (!mounted) return;
        setState(() {
          _imgWidthPx = info.image.width;
          _imgHeightPx = info.image.height;
          _cargando = false;
          _calcularBase();
          _inicializarDesdeAjuste();
        });
        stream.removeListener(listener);
      },
      onError: (error, stackTrace) {
        if (!mounted) return;
        setState(() {
          _error = 'No se pudo cargar la imagen';
          _cargando = false;
        });
        stream.removeListener(listener);
      },
    );
    stream.addListener(listener);
  }

  /// Calcula el tamaño del marco "cover completo" (zoom = 1) para el
  /// aspectRatio de este editor, sobre la imagen real actual.
  void _calcularBase() {
    final imgW = _imgWidthPx!.toDouble();
    final imgH = _imgHeightPx!.toDouble();
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

  /// Traduce el [widget.ajusteInicial] al rectángulo visual interno
  /// (_cropX/_cropY/_cropW/_cropH) según el modo.
  void _inicializarDesdeAjuste() {
    final a = widget.ajusteInicial;
    final esDefault =
        a.offsetX == 0 && a.offsetY == 0 && a.cropW == 1 && a.cropH == 1;

    if (esDefault) {
      // Sin ajuste guardado todavía → marco centrado, cover completo.
      _cropW = _cropWBase;
      _cropH = _cropHBase;
      _cropX = (1 - _cropW) / 2;
      _cropY = (1 - _cropH) / 2;
      return;
    }

    if (_esModoFoco) {
      // a.offsetX/offsetY = punto focal; a.cropW = zoom.
      final zoom = a.cropW.clamp(_minCropFraction, 1.0);
      _cropW = (_cropWBase * zoom).clamp(_minCropFraction, 1.0);
      _cropH = (_cropHBase * zoom).clamp(_minCropFraction, 1.0);
      _cropX = (a.offsetX - _cropW / 2).clamp(0.0, 1 - _cropW);
      _cropY = (a.offsetY - _cropH / 2).clamp(0.0, 1 - _cropH);
    } else {
      // Modo rect: valores absolutos directos.
      _cropX = a.offsetX;
      _cropY = a.offsetY;
      _cropW = a.cropW;
      _cropH = a.cropH;
    }
  }

  // ── Gesto unificado: mover (1 puntero) + zoom (2+ punteros / pellizco) ──
  // Todo pasa por onScale* porque Flutter no permite mezclar un
  // PanGestureRecognizer con un ScaleGestureRecognizer en el mismo
  // GestureDetector (scale ya cubre el caso de 1 dedo).

  void _onScaleStart(ScaleStartDetails details) {
    _focoInicio = details.localFocalPoint;
    _cropXInicio = _cropX;
    _cropYInicio = _cropY;
    _cropWInicio = _cropW;
  }

  void _onScaleUpdate(ScaleUpdateDetails details, Size lienzoSize) {
    if (details.pointerCount >= 2) {
      // Pellizco con 2+ dedos → zoom del marco de selección.
      final nuevoCropW = _cropWInicio / details.scale;
      _cambiarTamanoCrop(nuevoCropW);
    } else {
      // 1 dedo (o click sostenido con mouse) → mover el marco.
      setState(() {
        final delta = details.localFocalPoint - _focoInicio;
        final deltaXFrac = delta.dx / lienzoSize.width;
        final deltaYFrac = delta.dy / lienzoSize.height;

        _cropX = (_cropXInicio + deltaXFrac).clamp(0.0, 1 - _cropW);
        _cropY = (_cropYInicio + deltaYFrac).clamp(0.0, 1 - _cropH);
      });
    }
  }

  // ── Zoom con rueda del mouse (principal en Windows/desktop, donde no
  // hay pellizco de 2 dedos) ──

  void _onPointerScroll(PointerScrollEvent event) {
    final factor = event.scrollDelta.dy > 0 ? 1.08 : 1 / 1.08;
    _cambiarTamanoCrop(_cropW * factor);
  }

  /// Cambia el tamaño del marco de selección (zoom), manteniendo el centro
  /// fijo y respetando siempre el aspectRatio y los límites de la imagen.
  void _cambiarTamanoCrop(double nuevoCropW) {
    final imgAspect = _imgWidthPx! / _imgHeightPx!;
    final nuevoCropH =
        (nuevoCropW * _imgWidthPx!) / widget.aspectRatio / _imgHeightPx!;

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
      // Convertir el rectángulo visual a centro + zoom (independiente de
      // aspectRatio: por eso nunca se deforma al usarse en un contenedor
      // con una proporción distinta a la de este editor).
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
    return Column(
      children: [
        Expanded(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxW = constraints.maxWidth * 0.94;
                final maxH = constraints.maxHeight * 0.94;
                final imgAspect = _imgWidthPx! / _imgHeightPx!;

                // El lienzo muestra la imagen COMPLETA (contain) dentro del
                // espacio disponible, sin recortar nada todavía.
                double lienzoW = maxW;
                double lienzoH = lienzoW / imgAspect;
                if (lienzoH > maxH) {
                  lienzoH = maxH;
                  lienzoW = lienzoH * imgAspect;
                }
                final lienzoSize = Size(lienzoW, lienzoH);

                return Listener(
                  // Zoom con rueda del mouse — clave en Windows/desktop,
                  // donde normalmente no hay pantalla táctil para pellizcar.
                  onPointerSignal: (event) {
                    if (event is PointerScrollEvent) {
                      _onPointerScroll(event);
                    }
                  },
                  child: GestureDetector(
                    // Único set de callbacks: scale cubre tanto el arrastre
                    // (1 puntero) como el pellizco (2+ punteros). NO se debe
                    // agregar onPanStart/onPanUpdate aquí: mezclar pan y
                    // scale en el mismo GestureDetector lanza la excepción
                    // "Incorrect GestureDetector arguments".
                    onScaleStart: _onScaleStart,
                    onScaleUpdate: (d) => _onScaleUpdate(d, lienzoSize),
                    child: SizedBox(
                      width: lienzoW,
                      height: lienzoH,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // La imagen completa, sin recortar
                          Image(
                            image: _imageProvider,
                            fit: BoxFit.fill,
                            width: lienzoW,
                            height: lienzoH,
                            errorBuilder: (_, _, _) =>
                                const ColoredBox(color: Color(0xFF222222)),
                          ),
                          // Overlay oscuro fuera del marco de selección +
                          // recuadro de selección dibujado encima.
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

/// Dibuja el overlay oscuro fuera del marco de selección y el borde del marco.
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

    // Overlay oscuro en toda la imagen, luego "recortamos" el área del marco
    final overlayPaint = Paint()..color = Colors.black.withValues(alpha: 0.6);
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(marcoRect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, overlayPaint);

    // Borde del marco
    final bordePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(marcoRect, bordePaint);

    // Cuadrícula de tercios dentro del marco
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
