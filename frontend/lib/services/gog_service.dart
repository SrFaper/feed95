import 'dart:convert';
import 'package:http/http.dart' as http;

class GogResultado {
  final int id;
  final String nombre;
  final String portada;

  GogResultado({
    required this.id,
    required this.nombre,
    required this.portada,
  });
}

class GogDetalle {
  final String nombre;
  final String descripcion;
  final String portada;
  final String generos;

  GogDetalle({
    required this.nombre,
    required this.descripcion,
    required this.portada,
    required this.generos,
  });
}

class GogService {
  static Future<List<GogResultado>> buscar(String query) async {
    try {
      final uri = Uri.parse(
        'https://www.gog.com/games/ajax/filtered?search=${Uri.encodeComponent(query)}&mediaType=game',
      );
      final response = await http.get(
        uri,
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final products = data['products'] as List? ?? [];

      return products.map((p) {
        final imagen = p['image'] as String? ?? '';
        return GogResultado(
          id: p['id'] as int,
          nombre: p['title'] as String? ?? '',
          portada: imagen.isNotEmpty
              ? 'https:$imagen.jpg'
              : '',
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<GogDetalle?> obtenerDetalle(int id) async {
    try {
      final uri = Uri.parse(
        'https://api.gog.com/products/$id?expand=description,genres',
      );
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);

      final descripcionRaw =
          data['description']?['lead'] as String? ?? '';
      final descripcion = descripcionRaw
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .trim();

      final generos = (data['genres'] as List? ?? [])
          .map((g) => g['name'] as String? ?? '')
          .where((g) => g.isNotEmpty)
          .join(', ');

      final imagen = data['images']?['logo2x'] as String? ?? '';

      return GogDetalle(
        nombre: data['title'] as String? ?? '',
        descripcion: descripcion,
        portada: imagen.isNotEmpty ? 'https:$imagen' : '',
        generos: generos,
      );
    } catch (_) {
      return null;
    }
  }
}