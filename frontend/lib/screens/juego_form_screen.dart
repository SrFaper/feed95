import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/juego.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';

class JuegoFormScreen extends StatefulWidget {
  final Usuario usuario;
  final Juego? juego;

  const JuegoFormScreen({
    super.key,
    required this.usuario,
    this.juego,
  });

  @override
  State<JuegoFormScreen> createState() => _JuegoFormScreenState();
}

class _JuegoFormScreenState extends State<JuegoFormScreen> {
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final imagenController = TextEditingController();
  final versionController = TextEditingController();
  final calificacionController = TextEditingController();
  final generosController = TextEditingController();
  String estadoSeleccionado = 'Pendiente';
  String? _imagenLocal;

  final List<String> estados = [
    'Pendiente', 'Jugando', 'Completado', 'Abandonado'
  ];

  bool cargando = false;

  @override
  void initState() {
    super.initState();
    if (widget.juego != null) {
      nombreController.text = widget.juego!.nombre;
      descripcionController.text = widget.juego!.descripcion;
      imagenController.text = widget.juego!.imagen;
      versionController.text = widget.juego!.version;
      calificacionController.text = widget.juego!.calificacion.toString();
      generosController.text = widget.juego!.generos;
      estadoSeleccionado = widget.juego!.estado;
      _imagenLocal = widget.juego!.imagenLocal;
    }
  }

  Future<void> _elegirImagen() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imagenLocal = picked.path;
        imagenController.clear();
      });
    }
  }

  Future<void> guardarJuego() async {
    if (nombreController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre es obligatorio')),
      );
      return;
    }

    setState(() => cargando = true);

    Map<String, dynamic> respuesta;

    if (widget.juego == null) {
      respuesta = await ApiService.crearJuego(
        nombre: nombreController.text,
        descripcion: descripcionController.text,
        imagen: imagenController.text,
        imagenLocal: _imagenLocal,
        version: versionController.text,
        calificacion: calificacionController.text,
        generos: generosController.text,
        estado: estadoSeleccionado,
        usuarioId: widget.usuario.id,
      );
    } else {
      respuesta = await ApiService.actualizarJuego(
        id: widget.juego!.id,
        nombre: nombreController.text,
        descripcion: descripcionController.text,
        imagen: imagenController.text,
        imagenLocal: _imagenLocal,
        version: versionController.text,
        calificacion: calificacionController.text,
        generos: generosController.text,
        estado: estadoSeleccionado,
      );
    }

    setState(() => cargando = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(respuesta['message'])),
    );

    if (respuesta['success'] == true) {
      Navigator.pop(context);
    }
  }

  Widget _vistaPrevia() {
    if (_imagenLocal != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(_imagenLocal!),
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }
    if (imagenController.text.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imagenController.text,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const SizedBox(),
        ),
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.juego != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion ? 'Editar juego' : 'Nuevo juego'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre *'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),

            // Vista previa
            _vistaPrevia(),
            if (_imagenLocal != null || imagenController.text.isNotEmpty)
              const SizedBox(height: 8),

            // URL o galería
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: imagenController,
                    decoration: const InputDecoration(labelText: 'URL de imagen'),
                    onChanged: (_) => setState(() => _imagenLocal = null),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.photo_library),
                  tooltip: 'Elegir desde galería',
                  onPressed: _elegirImagen,
                ),
                if (_imagenLocal != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'Quitar imagen',
                    onPressed: () => setState(() => _imagenLocal = null),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            TextField(
              controller: versionController,
              decoration: const InputDecoration(labelText: 'Versión'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: calificacionController,
              decoration: const InputDecoration(labelText: 'Calificación (1-10)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: generosController,
              decoration: const InputDecoration(labelText: 'Géneros'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: estadoSeleccionado,
              decoration: const InputDecoration(labelText: 'Estado'),
              items: estados.map((estado) {
                return DropdownMenuItem(value: estado, child: Text(estado));
              }).toList(),
              onChanged: (valor) {
                setState(() => estadoSeleccionado = valor!);
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cargando ? null : guardarJuego,
                child: cargando
                    ? const CircularProgressIndicator()
                    : Text(esEdicion ? 'Actualizar' : 'Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}