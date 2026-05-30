import 'package:http/http.dart' as http;

class F95Resultado {
  final int id;
  final String nombre;
  final String portada;
  final String url;

  F95Resultado({
    required this.id,
    required this.nombre,
    required this.portada,
    required this.url,
  });
}

class F95Detalle {
  final String nombre;
  final String descripcion;
  final String portada;
  final String generos;
  final String version;

  F95Detalle({
    required this.nombre,
    required this.descripcion,
    required this.portada,
    required this.generos,
    required this.version,
  });
}

class F95Service {
  static const _baseUrl = 'https://f95zone.to';

  static Future<List<F95Resultado>> buscar(String query) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/search/1?q=${Uri.encodeComponent(query)}&t=post&c[child_nodes]=1&c[nodes][0]=2&o=relevance',
      );

      final response = await http
          .get(uri, headers: _headers())
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return [];

      final resultados = <F95Resultado>[];

      final threadRegex = RegExp(
        r'href="(https://f95zone\.to/threads/([^"]+?)\.(\d+)/)"',
      );
      final imageRegex = RegExp(
        r'<img[^>]+class="[^"]*lazyload[^"]*"[^>]+data-src="([^"]+)"',
      );

      final threadMatches = threadRegex.allMatches(response.body).toList();
      final imageMatches = imageRegex.allMatches(response.body).toList();

      for (int i = 0; i < threadMatches.length && i < 10; i++) {
        final match = threadMatches[i];
        final url = match.group(1) ?? '';
        final slug = match.group(2) ?? '';
        final id = int.tryParse(match.group(3) ?? '') ?? 0;

        String nombre = slug
            .replaceAll('-', ' ')
            .split(' ')
            .map((w) => w.isNotEmpty
                ? w[0].toUpperCase() + w.substring(1)
                : w)
            .join(' ');

        final portada =
            i < imageMatches.length ? imageMatches[i].group(1) ?? '' : '';

        if (id > 0 && nombre.isNotEmpty) {
          resultados.add(F95Resultado(
            id: id,
            nombre: nombre,
            portada: portada,
            url: url,
          ));
        }
      }

      return resultados;
    } catch (_) {
      return [];
    }
  }

  static Future<F95Detalle?> obtenerDetalle(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: _headers())
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return null;

      final body = response.body;

      // Título
      final ogTitleMatch =
          RegExp(r'<meta property="og:title" content="([^"]+)"')
              .firstMatch(body);
      String nombre = ogTitleMatch?.group(1)?.trim() ?? '';
      nombre = nombre.replaceAll(' | F95zone', '').trim();

      // Versión
      final versionMatch =
          RegExp(r'\[v([^\]]+)\]', caseSensitive: false).firstMatch(nombre);
      final version = versionMatch?.group(1)?.trim() ?? '';
      if (version.isNotEmpty) {
        nombre = nombre
            .replaceAll('[v$version]', '')
            .replaceAll('[V$version]', '')
            .trim();
      }

      // Portada
      final ogImageMatch =
          RegExp(r'<meta property="og:image" content="([^"]+)"')
              .firstMatch(body);
      final portada = ogImageMatch?.group(1) ?? '';

      // Descripción
      final ogDescMatch =
          RegExp(r'<meta property="og:description" content="([^"]+)"')
              .firstMatch(body);
      String descripcion = ogDescMatch?.group(1)?.trim() ?? '';
      descripcion = descripcion
          .replaceAll('&quot;', '"')
          .replaceAll('&amp;', '&')
          .replaceAll('&#039;', "'")
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>');

      // Tags
      final tagMatches =
          RegExp(r'<a[^>]+class="[^"]*tagItem[^"]*"[^>]*>([^<]+)</a>')
              .allMatches(body);
      final generos = tagMatches
          .map((m) => m.group(1)?.trim() ?? '')
          .where((t) => t.isNotEmpty)
          .take(8)
          .join(', ');

      return F95Detalle(
        nombre: nombre,
        descripcion: descripcion,
        portada: portada,
        generos: generos,
        version: version,
      );
    } catch (_) {
      return null;
    }
  }

  static Map<String, String> _headers() {
    return {
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36',
      'Accept':
          'text/html,application/xhtml+xml,application/json,*/*;q=0.9',
      'Accept-Language': 'en-US,en;q=0.9',
      'sec-fetch-dest': 'document',
      'sec-fetch-mode': 'navigate',
      'sec-fetch-site': 'none',
    };
  }
}