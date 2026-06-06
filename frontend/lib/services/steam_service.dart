import 'dart:convert';
import 'package:http/http.dart' as http;

class SteamResultado {
  final int appId;
  final String nombre;
  final String portada;

  SteamResultado({
    required this.appId,
    required this.nombre,
    required this.portada,
  });
}

class SteamDetalle {
  final String nombre;
  final String descripcion;
  final String portada;
  final String portadaGrid;
  final String generos;
  final String imagenesExtra;

  SteamDetalle({
    required this.nombre,
    required this.descripcion,
    required this.portada,
    required this.portadaGrid,
    required this.generos,
    required this.imagenesExtra,
  });
}

class SteamService {
  // Buscar juegos por nombre
  static Future<List<SteamResultado>> buscar(String query) async {
    try {
      final uri = Uri.parse(
        'https://store.steampowered.com/api/storesearch/?term=${Uri.encodeComponent(query)}&l=spanish&cc=US',
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final items = data['items'] as List? ?? [];

      return items.map((item) {
        final appId = item['id'] as int;
        return SteamResultado(
          appId: appId,
          nombre: item['name'] ?? '',
          portada:
              'https://cdn.akamai.steamstatic.com/steam/apps/$appId/library_600x900.jpg',
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  // Obtener detalles de un juego por appId
  static Future<SteamDetalle?> obtenerDetalle(int appId) async {
    try {
      final uri = Uri.parse(
        'https://store.steampowered.com/api/appdetails?appids=$appId&l=spanish',
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      final appData = data['$appId'];
      if (appData == null || appData['success'] != true) return null;

      final info = appData['data'];
      final generos = (info['genres'] as List? ?? [])
          .map((g) => g['description'] as String)
          .join(', ');

      // Limpiar HTML básico de la descripción
      final descripcionRaw = (info['short_description'] ?? '') as String;
      final descripcion = descripcionRaw
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .trim();

      // Portada horizontal (para detalle)
      final portada =
          'https://cdn.akamai.steamstatic.com/steam/apps/$appId/header.jpg';

      // Portada vertical (para grid)
      final portadaGrid =
          'https://cdn.akamai.steamstatic.com/steam/apps/$appId/library_600x900.jpg';

      // Screenshots del carrusel
      final screenshots = (info['screenshots'] as List? ?? [])
          .take(10)
          .map((s) => s['path_full'] as String? ?? '')
          .where((s) => s.isNotEmpty)
          .join(',');

      return SteamDetalle(
        nombre: info['name'] ?? '',
        descripcion: descripcion,
        portada: portada,
        portadaGrid: portadaGrid,
        generos: generos,
        imagenesExtra: screenshots,
      );
    } catch (_) {
      return null;
    }
  }
}
