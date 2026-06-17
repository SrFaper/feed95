import 'package:flutter/material.dart';

/// Campo de texto que muestra un "placeholder fantasma" con el valor original
/// cuando el campo de override está vacío. El placeholder se ve atenuado y
/// NO es interactuable (es solo un hint visual, no texto real del campo).
///
/// Si el usuario escribe algo, eso pasa a ser el valor real (override).
/// Si lo borra todo, vuelve a verse el original de fondo.
class CampoConOriginal extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String valorOriginal;
  final int maxLines;
  final TextInputType? keyboardType;

  const CampoConOriginal({
    super.key,
    required this.controller,
    required this.label,
    required this.valorOriginal,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final tieneOriginal = valorOriginal.isNotEmpty;

    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        // El placeholder fantasma: solo se muestra si el campo está vacío
        // Y existe un original. Flutter ya maneja esto: si el controller
        // tiene texto, el hintText queda oculto automáticamente.
        hintText: tieneOriginal ? valorOriginal : null,
        hintStyle: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: 0.35)
              : Colors.black.withValues(alpha: 0.30),
          fontStyle: FontStyle.italic,
        ),
        suffixIcon: tieneOriginal
            ? Tooltip(
                message: 'Valor original disponible',
                child: Icon(
                  Icons.history,
                  size: 16,
                  color: Colors.grey.withValues(alpha: 0.6),
                ),
              )
            : null,
      ),
    );
  }
}
