import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class IgdbResultado {
  final int id;
  final String nombre;
  final String portada;

  IgdbResultado({
    required this.id,
    required this.nombre,
    required this.portada,
  });
}

class IgdbDetalle {
  final String nombre;
  final String descripcion;
  final String portada;
  final String portadaGrid;
  final String generos;
  final String imagenesExtra;

  IgdbDetalle({
    required this.nombre,
    required this.descripcion,
    required this.portada,
    required this.portadaGrid,
    required this.generos,
    required this.imagenesExtra,
  });
}

class IgdbService {
  static const _prefClientId = 'igdb_client_id';
  static const _prefClientSecret = 'igdb_client_secret';
  static const _prefToken = 'igdb_token';
  static const _prefTokenExpiry = 'igdb_token_expiry';

  static Future<bool> tieneCredenciales() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString(_prefClientId)?.isNotEmpty ?? false) &&
        (prefs.getString(_prefClientSecret)?.isNotEmpty ?? false);
  }

  static Future<bool> verificarCredenciales({
    required String clientId,
    required String clientSecret,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://id.twitch.tv/oauth2/token'),
        body: {
          'client_id': clientId,
          'client_secret': clientSecret,
          'grant_type': 'client_credentials',
        },
      ).timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<void> guardarCredenciales({
    required String clientId,
    required String clientSecret,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefClientId, clientId);
    await prefs.setString(_prefClientSecret, clientSecret);
    await prefs.remove(_prefToken);
    await prefs.remove(_prefTokenExpiry);
  }

  static Future<void> limpiarCredenciales() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefClientId);
    await prefs.remove(_prefClientSecret);
    await prefs.remove(_prefToken);
    await prefs.remove(_prefTokenExpiry);
  }

  static Future<Map<String, String>?> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final clientId = prefs.getString(_prefClientId) ?? '';
    final clientSecret = prefs.getString(_prefClientSecret) ?? '';
    if (clientId.isEmpty || clientSecret.isEmpty) return null;

    // Usar token cacheado si sigue vigente
    final cachedToken = prefs.getString(_prefToken);
    final expiry = prefs.getInt(_prefTokenExpiry) ?? 0;
    if (cachedToken != null &&
        DateTime.now().millisecondsSinceEpoch < expiry) {
      return {
        'Client-ID': clientId,
        'Authorization': 'Bearer $cachedToken',
        'Content-Type': 'text/plain',
      };
    }

    // Obtener nuevo token
    try {
      final response = await http.post(
        Uri.parse('https://id.twitch.tv/oauth2/token'),
        body: {
          'client_id': clientId,
          'client_secret': clientSecret,
          'grant_type': 'client_credentials',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      final token = data['access_token'] as String?;
      final expiresIn = data['expires_in'] as int? ?? 3600;
      if (token == null) return null;

      await prefs.setString(_prefToken, token);
      await prefs.setInt(
        _prefTokenExpiry,
        DateTime.now().millisecondsSinceEpoch + (expiresIn - 300) * 1000,
      );

      return {
        'Client-ID': clientId,
        'Authorization': 'Bearer $token',
        'Content-Type': 'text/plain',
      };
    } catch (_) {
      return null;
    }
  }

  static Future<List<IgdbResultado>> buscar(String query) async {
    try {
      final headers = await _getHeaders();
      if (headers == null) return [];

      final queryLimpia = query.replaceAll('"', '');
      final response = await http.post(
        Uri.parse('https://api.igdb.com/v4/games'),
        headers: headers,
        body:
            'search "$queryLimpia"; fields name,cover.image_id; limit 10; where version_parent = null;',
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body) as List;
      return data.map((game) {
        final imageId = game['cover']?['image_id'] as String? ?? '';
        final portada = imageId.isNotEmpty
            ? 'https://images.igdb.com/igdb/image/upload/t_cover_big/$imageId.jpg'
            : '';
        return IgdbResultado(
          id: game['id'] as int,
          nombre: game['name'] as String? ?? '',
          portada: portada,
        );
      }).where((r) => r.nombre.isNotEmpty).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<IgdbDetalle?> obtenerDetalle(int id) async {
    try {
      final headers = await _getHeaders();
      if (headers == null) return null;

      final response = await http.post(
        Uri.parse('https://api.igdb.com/v4/games'),
        headers: headers,
        body:
            'fields name,summary,cover.image_id,genres.name,screenshots.image_id,artworks.image_id; where id = $id;',
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as List;
      if (data.isEmpty) return null;

      final game = data.first;
      final coverId = game['cover']?['image_id'] as String? ?? '';

      // Portada vertical para grid
      final portadaGrid = coverId.isNotEmpty
          ? 'https://images.igdb.com/igdb/image/upload/t_cover_big/$coverId.jpg'
          : '';

      // Portada horizontal para detalle — artwork si existe
      final artworks = game['artworks'] as List? ?? [];
      String portada = portadaGrid;
      if (artworks.isNotEmpty) {
        final artId = artworks.first['image_id'] as String? ?? '';
        if (artId.isNotEmpty) {
          portada =
              'https://images.igdb.com/igdb/image/upload/t_screenshot_huge/$artId.jpg';
        }
      }

      final generos = (game['genres'] as List? ?? [])
          .map((g) => g['name'] as String? ?? '')
          .where((g) => g.isNotEmpty)
          .join(', ');

      final imagenesExtra = (game['screenshots'] as List? ?? [])
          .take(8)
          .map((s) => s['image_id'] as String? ?? '')
          .where((imgId) => imgId.isNotEmpty)
          .map((imgId) =>
              'https://images.igdb.com/igdb/image/upload/t_screenshot_big/$imgId.jpg')
          .join(',');

      return IgdbDetalle(
        nombre: game['name'] as String? ?? '',
        descripcion: game['summary'] as String? ?? '',
        portada: portada,
        portadaGrid: portadaGrid,
        generos: generos,
        imagenesExtra: imagenesExtra,
      );
    } catch (_) {
      return null;
    }
  }
}