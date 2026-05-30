import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  static const _prefKeyToken = 'f95_token';
  static const _prefKeyUser = 'f95_usuario';
  static const _prefKeyPass = 'f95_password';

  // Guardar credenciales localmente
  static Future<void> guardarCredenciales({
    required String usuario,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKeyUser, usuario);
    await prefs.setString(_prefKeyPass, password);
  }

  // Verificar si hay credenciales guardadas
  static Future<bool> tieneCredenciales() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefKeyUser) != null &&
        prefs.getString(_prefKeyPass) != null;
  }

  // Borrar credenciales y token
  static Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKeyUser);
    await prefs.remove(_prefKeyPass);
    await prefs.remove(_prefKeyToken);
  }

  // Login y obtener token
  static Future<bool> login({
    required String usuario,
    required String password,
  }) async {
    try {
      // Paso 1: obtener token CSRF de la página de login
      final loginPage = await http.get(
        Uri.parse('$_baseUrl/login/'),
        headers: _headers(),
      ).timeout(const Duration(seconds: 10));

      final csrfMatch = RegExp(r'name="_xfToken" value="([^"]+)"')
          .firstMatch(loginPage.body);
      if (csrfMatch == null) return false;
      final csrfToken = csrfMatch.group(1)!;

      // Extraer cookies de la respuesta
      final cookies = _parseCookies(loginPage.headers['set-cookie'] ?? '');

      // Paso 2: enviar credenciales
      final response = await http.post(
        Uri.parse('$_baseUrl/login/login'),
        headers: {
          ..._headers(),
          'Content-Type': 'application/x-www-form-urlencoded',
          'Cookie': cookies,
          'Referer': '$_baseUrl/login/',
        },
        body: {
          'login': usuario,
          'password': password,
          '_xfToken': csrfToken,
          'remember': '1',
        },
      ).timeout(const Duration(seconds: 10));

      // Login exitoso si redirige o devuelve cookie de sesión
      final sessionCookie = response.headers['set-cookie'] ?? '';
      if (sessionCookie.contains('xf_user') ||
          response.statusCode == 303 ||
          response.statusCode == 302) {
        final prefs = await SharedPreferences.getInstance();
        final allCookies = '$cookies; $sessionCookie';
        await prefs.setString(_prefKeyToken, allCookies);
        await guardarCredenciales(usuario: usuario, password: password);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  // Login automático con credenciales guardadas
  static Future<bool> loginGuardado() async {
    final prefs = await SharedPreferences.getInstance();
    final usuario = prefs.getString(_prefKeyUser);
    final password = prefs.getString(_prefKeyPass);
    if (usuario == null || password == null) return false;
    return login(usuario: usuario, password: password);
  }

  // Buscar juegos
  static Future<List<F95Resultado>> buscar(String query) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(_prefKeyToken);

      // Si no hay token intentar login automático
      if (token == null) {
        final ok = await loginGuardado();
        if (!ok) return [];
        token = prefs.getString(_prefKeyToken);
        if (token == null) return [];
      }

      final uri = Uri.parse(
        '$_baseUrl/search/search?q=${Uri.encodeComponent(query)}&t=post&c[child_nodes]=1&c[nodes][0]=2&o=relevance',
      );

      final response = await http.get(
        uri,
        headers: {..._headers(), 'Cookie': token},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 403 || response.statusCode == 401) {
        // Token expirado, relogin
        final ok = await loginGuardado();
        if (!ok) return [];
        return buscar(query);
      }

      if (response.statusCode != 200) return [];

      // Parsear resultados del HTML
      final resultados = <F95Resultado>[];
      final regex = RegExp(
        r'href="(https://f95zone\.to/threads/([^/]+)-(\d+)/)"[^>]*>.*?<h3[^>]*>(.*?)</h3>.*?<img[^>]+src="([^"]+)"',
        dotAll: true,
      );

      for (final match in regex.allMatches(response.body)) {
        final url = match.group(1) ?? '';
        final id = int.tryParse(match.group(3) ?? '') ?? 0;
        final nombre = match.group(4)
                ?.replaceAll(RegExp(r'<[^>]*>'), '')
                .trim() ??
            '';
        final portada = match.group(5) ?? '';
        if (id > 0 && nombre.isNotEmpty) {
          resultados.add(F95Resultado(
            id: id,
            nombre: nombre,
            portada: portada,
            url: url,
          ));
        }
      }

      // Si el regex no dio resultados intentar con la API interna
      if (resultados.isEmpty) {
        return _buscarConApi(query, token);
      }

      return resultados;
    } catch (_) {
      return [];
    }
  }

  // Búsqueda alternativa usando la API interna de F95
  static Future<List<F95Resultado>> _buscarConApi(
      String query, String token) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/content/search');
      final response = await http.post(
        uri,
        headers: {
          ..._headers(),
          'Cookie': token,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'query': query,
          'content_type': 'thread',
          'nodes[]': '2',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final items = data['msg']?['data'] as List? ?? [];

      return items.map((item) {
        return F95Resultado(
          id: item['thread_id'] as int? ?? 0,
          nombre: item['title'] as String? ?? '',
          portada: item['cover_image'] as String? ?? '',
          url: '$_baseUrl/threads/${item['thread_id']}/',
        );
      }).where((r) => r.id > 0).toList();
    } catch (_) {
      return [];
    }
  }

  // Obtener detalle de un juego
  static Future<F95Detalle?> obtenerDetalle(String url) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_prefKeyToken);
      if (token == null) return null;

      final response = await http.get(
        Uri.parse(url),
        headers: {..._headers(), 'Cookie': token},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return null;

      final body = response.body;

      // Título
      final titleMatch =
          RegExp(r'<title>([^<]+)</title>').firstMatch(body);
      String nombre = titleMatch?.group(1)?.trim() ?? '';
      nombre = nombre.replaceAll(' | F95zone', '').trim();

      // Versión desde el título (patrón común en F95: "[v1.0]" o "[Version 1.0]")
      final versionMatch =
          RegExp(r'\[v?(?:ersion\s*)?([0-9][^\]]*)\]', caseSensitive: false)
              .firstMatch(nombre);
      final version = versionMatch?.group(1)?.trim() ?? '';
      if (version.isNotEmpty) {
        nombre = nombre.replaceAll(versionMatch!.group(0)!, '').trim();
      }

      // Portada (primera imagen del post)
      final portadaMatch = RegExp(
        r'<img[^>]+class="[^"]*bbImage[^"]*"[^>]+src="([^"]+)"',
      ).firstMatch(body);
      final portada = portadaMatch?.group(1) ?? '';

      // Descripción (primer párrafo del post)
      final descMatch = RegExp(
        r'<article[^>]*class="[^"]*message-body[^"]*"[^>]*>(.*?)</article>',
        dotAll: true,
      ).firstMatch(body);
      String descripcion = descMatch?.group(1) ?? '';
      descripcion = descripcion
          .replaceAll(RegExp(r'<[^>]*>'), ' ')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      if (descripcion.length > 800) {
        descripcion = '${descripcion.substring(0, 800)}...';
      }

      // Tags/géneros
      final tagMatches = RegExp(
        r'<a[^>]+class="[^"]*tagItem[^"]*"[^>]*>([^<]+)</a>',
      ).allMatches(body);
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
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      'Accept': 'text/html,application/xhtml+xml,application/json,*/*',
      'Accept-Language': 'en-US,en;q=0.9',
    };
  }

  static String _parseCookies(String setCookieHeader) {
    return setCookieHeader
        .split(RegExp(r',(?=[^;]+=[^;]+;)'))
        .map((c) => c.split(';').first.trim())
        .join('; ');
  }
}