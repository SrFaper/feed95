import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

enum ModoGuardadoImagen { ninguno, original, comprimido }

class ImageCacheService {
  /// Directorio raíz: %APPDATA%/feed95/covers/ (Windows) o appDir/covers/ (Android/otros)
  static Future<Directory> coversDir() async {
    String base;
    if (!kIsWeb && Platform.isWindows) {
      base = p.join(Platform.environment['APPDATA']!, 'feed95', 'covers');
    } else {
      final appDir = await getApplicationDocumentsDirectory();
      base = p.join(appDir.path, 'covers');
    }
    final dir = Directory(base);
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  /// Ruta absoluta de la carpeta de covers, para mostrar en Configuración.
  static Future<String> rutaVisible() async => (await coversDir()).path;

  /// Detecta si los bytes corresponden a un GIF o WebP animado (más de 1 frame).
  /// Chequeo barato: revisa cabeceras, no decodifica el archivo completo.
  static bool _esAnimado(Uint8List bytes) {
    if (bytes.length < 16) return false;

    // GIF: firma "GIF87a" o "GIF89a"
    final esGif =
        bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46; // "GIF"
    if (esGif) {
      // Contar bloques de imagen (0x2C) fuera de extensiones; suficiente
      // contar apariciones del separador de imagen para detectar >1 frame.
      int frames = 0;
      for (int i = 0; i < bytes.length - 1; i++) {
        if (bytes[i] == 0x2C) frames++;
        if (frames > 1) return true;
      }
      return false;
    }

    // WebP: firma "RIFF....WEBP", animado si contiene chunk "ANIM"
    final esWebp =
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50;
    if (esWebp) {
      final texto = String.fromCharCodes(bytes);
      return texto.contains('ANIM');
    }

    return false;
  }

  static Future<Uint8List?> _obtenerBytes({
    String? urlRemota,
    String? rutaLocalExistente,
  }) async {
    if (rutaLocalExistente != null && rutaLocalExistente.isNotEmpty) {
      final f = File(rutaLocalExistente);
      if (!await f.exists()) return null;
      return await f.readAsBytes();
    }
    if (urlRemota != null && urlRemota.isNotEmpty) {
      final response = await http
          .get(Uri.parse(urlRemota))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) return null;
      return response.bodyBytes;
    }
    return null;
  }

  /// Borra cualquier archivo previo bajo ese nombre base, sin importar su
  /// extensión (evita basura tipo "1_grid.jpg" + "1_grid.gif" coexistiendo).
  static Future<void> _limpiarVariantesPrevias(
    Directory dir,
    String nombreBase,
  ) async {
    try {
      for (final entity in dir.listSync()) {
        if (entity is File &&
            p.basenameWithoutExtension(entity.path) == nombreBase) {
          await entity.delete();
        }
      }
    } catch (_) {}
  }

  /// Guarda una imagen (URL remota o ruta local) bajo un nombre base estable
  /// (ej: "42_grid"), según el modo elegido:
  /// - [ModoGuardadoImagen.original]: copia tal cual, conservando su formato.
  ///   Si es GIF/WebP animado, se respeta la animación sin comprimir.
  /// - [ModoGuardadoImagen.comprimido]: si es animado, igual se respeta tal
  ///   cual (nunca se comprime una animación); si es estático, se recodifica
  ///   a JPEG calidad 85.
  /// Devuelve la ruta final, o null si falla.
  static Future<String?> guardarImagen({
    required String nombreBase,
    required ModoGuardadoImagen modo,
    String? urlRemota,
    String? rutaLocalExistente,
    int calidadJpeg = 85,
  }) async {
    if (modo == ModoGuardadoImagen.ninguno) return null;
    try {
      final bytes = await _obtenerBytes(
        urlRemota: urlRemota,
        rutaLocalExistente: rutaLocalExistente,
      );
      if (bytes == null) return null;

      final dir = await coversDir();
      await _limpiarVariantesPrevias(dir, nombreBase);

      final animado = _esAnimado(bytes);

      // Las animaciones nunca se comprimen, sin importar el modo elegido.
      if (animado || modo == ModoGuardadoImagen.original) {
        final extension = rutaLocalExistente != null
            ? p.extension(rutaLocalExistente)
            : (urlRemota != null ? p.extension(Uri.parse(urlRemota).path) : '');
        final destino = File(
          p.join(
            dir.path,
            '$nombreBase${extension.isNotEmpty ? extension : ".img"}',
          ),
        );
        await destino.writeAsBytes(bytes);
        return destino.path;
      }

      // Modo comprimido + imagen estática → recodificar a JPEG.
      final decoded = img.decodeImage(bytes);
      if (decoded == null) {
        // No se pudo decodificar (formato raro) → fallback a copia tal cual.
        final destino = File(p.join(dir.path, '$nombreBase.img'));
        await destino.writeAsBytes(bytes);
        return destino.path;
      }
      final jpegBytes = img.encodeJpg(decoded, quality: calidadJpeg);
      final destino = File(p.join(dir.path, '$nombreBase.jpg'));
      await destino.writeAsBytes(jpegBytes);
      return destino.path;
    } catch (e) {
      debugPrint('ImageCacheService error: $e');
      return null;
    }
  }

  /// Elimina las imágenes cacheadas de un juego (grid + detalle), cualquier extensión.
  static Future<void> eliminarCache(int juegoId) async {
    try {
      final dir = await coversDir();
      await _limpiarVariantesPrevias(dir, '${juegoId}_grid');
      await _limpiarVariantesPrevias(dir, '${juegoId}_detalle');
    } catch (_) {}
  }

  /// Elimina archivos temporales huérfanos de versiones anteriores del cache.
  static Future<void> limpiarTemporales() async {
    try {
      final dir = await coversDir();
      if (!await dir.exists()) return;
      for (final entity in dir.listSync()) {
        if (entity is File && entity.path.contains('_tmp')) {
          await entity.delete();
        }
      }
    } catch (_) {}
  }

  /// Tamaño total ocupado por la carpeta de covers, en bytes.
  static Future<int> tamanoTotal() async {
    try {
      final dir = await coversDir();
      int total = 0;
      if (await dir.exists()) {
        for (final entity in dir.listSync(recursive: true)) {
          if (entity is File) total += await entity.length();
        }
      }
      return total;
    } catch (_) {
      return 0;
    }
  }
}
