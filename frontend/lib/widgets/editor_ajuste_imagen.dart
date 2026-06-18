import 'dart:io';
import 'package:flutter/material.dart';

/// Resultado del ajuste: posición relativa (offset) y zoom aplicados sobre
/// la imagen original. offsetX/offsetY en fracción del marco (negativo = izquierda/arriba).
/// zoom >= 1.0. Los límites garantizan que nunca haya espacio vacío visible.
class AjusteImagen {
  final double offsetX;
  final double offsetY;
  final double zoom;

  const AjusteImagen({this.offsetX = 0, this.offsetY = 0, this.zoom = 1});
}

/// Pantalla de edición de encuadre:
/// - La imagen parte de BoxFit.cover (idéntico al resultado final).
/// - Pan limitado geométricamente: nunca se puede dejar espacio vacío.
/// - Zoom con slider + pinch.
/// - Al confirmar devuelve [AjusteImagen] con offset/zoom aplicables directamente
///   con la misma Matrix4 que usan ImagenAjustada e ImagenConOriginal.
class EditorAjusteImagenScreen extends StatefulWidget {
  final String? imagenUrl;
  final String? imagenLocal;
  final double aspectRatio;
  final AjusteImagen ajusteInicial;

  const EditorAjusteImagenScreen({
    super.key,
    this.imagenUrl,
    this.imagenLocal,
    required this.aspectRatio,
    this.ajusteInicial = const AjusteImagen(),
  });

  @override
  State<EditorAjusteImagenScreen> createState() =>
      _EditorAjusteImagenScreenState();
}

class _EditorAjusteImagenScreenState extends State<EditorAjusteImagenScreen> {
  // offsetX/Y: fracción del marcoSize (-1..1 teórico, acotado por zoom en práctica)
  late double _offsetX;
  late double _offsetY;
  late double _zoom;

  // Captura del estado al inicio del gesto
  Offset _focoInicio = Offset.zero;
  double _offsetXInicio = 0;
  double _offsetYInicio = 0;
  double _zoomInicio = 1;

  static const double _zoomMin = 1.0;
  static const double _zoomMax = 4.0;

  @override
  void initState() {
    super.initState();
    _offsetX = widget.ajusteInicial.offsetX;
    _offsetY = widget.ajusteInicial.offsetY;
    _zoom = widget.ajusteInicial.zoom;
  }

  ImageProvider get _imageProvider {
    if (widget.imagenLocal != null && widget.imagenLocal!.isNotEmpty) {
      return FileImage(File(widget.imagenLocal!));
    }
    return NetworkImage(widget.imagenUrl ?? '');
  }

  /// Límite máximo de offsetX/Y en fracción del marco para el zoom actual.
  /// Con BoxFit.cover en zoom 1.0 la imagen ya llena el marco exactamente,
  /// así que el pan permitido es 0. Con zoom z, la imagen "sobresale"
  /// (z-1)/2 por cada lado en fracción del marco.
  double _maxOffset(double zoom) => (zoom - 1) / 2;

  double _clampOffset(double offset, double zoom) {
    final max = _maxOffset(zoom);
    return offset.clamp(-max, max);
  }

  void _onScaleStart(ScaleStartDetails details) {
    _focoInicio = details.focalPoint;
    _offsetXInicio = _offsetX;
    _offsetYInicio = _offsetY;
    _zoomInicio = _zoom;
  }

  void _onScaleUpdate(ScaleUpdateDetails details, Size marcoSize) {
    setState(() {
      // Nuevo zoom
      final nuevoZoom = (_zoomInicio * details.scale).clamp(_zoomMin, _zoomMax);
      _zoom = nuevoZoom;

      // Nuevo offset: delta en píxeles → fracción del marco
      final delta = details.focalPoint - _focoInicio;
      final nuevoX = _offsetXInicio + delta.dx / marcoSize.width;
      final nuevoY = _offsetYInicio + delta.dy / marcoSize.height;

      // Acotar para que la imagen nunca deje espacio vacío
      _offsetX = _clampOffset(nuevoX, nuevoZoom);
      _offsetY = _clampOffset(nuevoY, nuevoZoom);
    });
  }

  void _onZoomSlider(double nuevoZoom, Size marcoSize) {
    setState(() {
      _zoom = nuevoZoom;
      // Al reducir el zoom, puede que el offset actual ya no sea válido
      _offsetX = _clampOffset(_offsetX, nuevoZoom);
      _offsetY = _clampOffset(_offsetY, nuevoZoom);
    });
  }

  void _resetear() {
    setState(() {
      _offsetX = 0;
      _offsetY = 0;
      _zoom = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Ajustar encuadre'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Restablecer',
            onPressed: _resetear,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxW = constraints.maxWidth * 0.92;
                  final maxH = constraints.maxHeight * 0.92;
                  double w = maxW;
                  double h = w / widget.aspectRatio;
                  if (h > maxH) {
                    h = maxH;
                    w = h * widget.aspectRatio;
                  }
                  final marcoSize = Size(w, h);

                  return GestureDetector(
                    onScaleStart: _onScaleStart,
                    onScaleUpdate: (d) => _onScaleUpdate(d, marcoSize),
                    child: Container(
                      width: w,
                      height: h,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Imagen con BoxFit.cover: mismo punto de partida
                          // que ImagenAjustada/ImagenConOriginal en el resultado.
                          // La Matrix4 es idéntica a la que se aplica al mostrar.
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..translateByDouble(
                                _offsetX * w,
                                _offsetY * h,
                                0,
                                1,
                              )
                              ..scaleByDouble(_zoom, _zoom, _zoom, 1),
                            child: Image(
                              image: _imageProvider,
                              fit: BoxFit.cover,
                              width: w,
                              height: h,
                              errorBuilder: (_, _, _) => const ColoredBox(
                                color: Color(0xFF222222),
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.white24,
                                ),
                              ),
                            ),
                          ),
                          IgnorePointer(
                            child: CustomPaint(painter: _CuadriculaPainter()),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Slider de zoom
          LayoutBuilder(
            builder: (context, constraints) {
              // Necesitamos marcoSize para pasar al slider, pero aquí no
              // tenemos el Size del marco (está en el LayoutBuilder de arriba).
              // Usamos una Size simbólica — el slider solo cambia _zoom y
              // luego _clampOffset hace el resto con el valor de _zoom.
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.zoom_out, color: Colors.white54, size: 18),
                    Expanded(
                      child: Slider(
                        value: _zoom,
                        min: _zoomMin,
                        max: _zoomMax,
                        onChanged: (v) => _onZoomSlider(v, Size.zero),
                      ),
                    ),
                    const Icon(Icons.zoom_in, color: Colors.white54, size: 18),
                  ],
                ),
              );
            },
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
                      onPressed: () => Navigator.pop(
                        context,
                        AjusteImagen(
                          offsetX: _offsetX,
                          offsetY: _offsetY,
                          zoom: _zoom,
                        ),
                      ),
                      child: const Text('Aplicar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CuadriculaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..strokeWidth = 1;
    for (int i = 1; i < 3; i++) {
      final x = size.width * i / 3;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
