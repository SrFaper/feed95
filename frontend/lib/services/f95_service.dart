import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

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
  static Dio? _dio;
  static PersistCookieJar? _cookieJar;

  static Future<Dio> _getDio() async {
    if (_dio != null) return _dio!;

    final appDir = await getApplicationDocumentsDirectory();
    final cookiePath = p.join(appDir.path, 'f95_cookies');
    await Directory(cookiePath).create(recursive: true);

    _cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        followRedirects: true,
        maxRedirects: 5,
        receiveTimeout: const Duration(seconds: 15),
        connectTimeout: const Duration(seconds: 10),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36',
          'Accept':
              'text/html,application/xhtml+xml,application/json,*/*;q=0.9',
          'Accept-Language': 'en-US,en;q=0.9',
        },
      ),
    );

    _dio!.interceptors.add(CookieManager(_cookieJar!));
    return _dio!;
  }

  // Verificar si hay sesión activa
  static Future<bool> tieneSesion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('f95_sesion_activa') ?? false;
  }

  // Login
  static Future<bool> login({
    required String usuario,
    required String password,
  }) async {
    try {
      final dio = await _getDio();

      // Paso 1: obtener página de login y token CSRF
      final loginPage = await dio.get(
        '/login/',
        options: Options(
          headers: {
            'Accept': 'text/html,application/xhtml+xml,*/*',
            'sec-fetch-dest': 'document',
            'sec-fetch-mode': 'navigate',
            'sec-fetch-site': 'none',
            'sec-fetch-user': '?1',
            'upgrade-insecure-requests': '1',
          },
        ),
      );

      final pageBody = loginPage.data.toString();
      final csrfMatch = RegExp(
        r'name="_xfToken" value="([^"]+)"',
      ).firstMatch(pageBody);
      if (csrfMatch == null) return false;
      final csrfToken = csrfMatch.group(1)!;

      // Paso 2: enviar credenciales SIN seguir redirects
      // para capturar las cookies de sesión del 303
      final response = await dio.post(
        '/login/login',
        data:
            'login=${Uri.encodeComponent(usuario)}'
            '&password=${Uri.encodeComponent(password)}'
            '&_xfToken=${Uri.encodeComponent(csrfToken)}'
            '&_xfRedirect=${Uri.encodeComponent('https://f95zone.to/')}'
            '&remember=1',
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          followRedirects: false, // ← clave: no seguir el redirect
          validateStatus: (status) => status != null && status < 500,
          headers: {
            'Referer': 'https://f95zone.to/login/',
            'Origin': 'https://f95zone.to',
            'sec-fetch-dest': 'document',
            'sec-fetch-mode': 'navigate',
            'sec-fetch-site': 'same-origin',
            'sec-fetch-user': '?1',
            'upgrade-insecure-requests': '1',
          },
        ),
      );

      debugPrint('LOGIN STATUS: ${response.statusCode}');
      debugPrint('RESPONSE HEADERS: ${response.headers.map}');

      final cookies = await _cookieJar?.loadForRequest(
        Uri.parse('https://f95zone.to'),
      );
      debugPrint('COOKIES AFTER LOGIN: $cookies');

      // Login exitoso si obtenemos 303 y la cookie xf_user
      final tieneSessionCookie =
          cookies?.any((c) => c.name == 'xf_user') ?? false;

      final exitoso = tieneSessionCookie;

      debugPrint('LOGIN LOGGED IN: $exitoso');
      debugPrint('TIENE xf_user: $tieneSessionCookie');

      if (exitoso) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('f95_sesion_activa', true);
        await prefs.setString('f95_usuario', usuario);
        await prefs.setString('f95_password', password);
      }

      return exitoso;
    } catch (e) {
      debugPrint('LOGIN ERROR: $e');
      return false;
    }
  }

  // Login automático con credenciales guardadas
  static Future<bool> loginGuardado() async {
    final prefs = await SharedPreferences.getInstance();
    final usuario = prefs.getString('f95_usuario');
    final password = prefs.getString('f95_password');
    if (usuario == null || password == null) return false;
    return login(usuario: usuario, password: password);
  }

  // Cerrar sesión
  static Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('f95_sesion_activa');
    await prefs.remove('f95_usuario');
    await prefs.remove('f95_password');
    await _cookieJar?.deleteAll();
    _dio = null;
    _cookieJar = null;
  }

  // Buscar juegos
  static Future<List<F95Resultado>> buscar(String query) async {
    try {
      final sesion = await tieneSesion();
      if (!sesion) {
        final ok = await loginGuardado();
        if (!ok) return [];
      }

      final dio = await _getDio();
      final response = await dio.get(
        '/search/1',
        queryParameters: {
          'q': query,
          't': 'post',
          'c[child_nodes]': '1',
          'c[nodes][0]': '2',
          'o': 'relevance',
        },
      );

      final body = response.data.toString();
      final resultados = <F95Resultado>[];

      final threadRegex = RegExp(
        r'href="(https://f95zone\.to/threads/([^"]+?)\.(\d+)/)"',
      );
      final imageRegex = RegExp(
        r'<img[^>]+(?:data-src|src)="(https://[^"]+attachments[^"]+)"',
      );

      final threadMatches = threadRegex.allMatches(body).toList();
      final imageMatches = imageRegex.allMatches(body).toList();

      for (int i = 0; i < threadMatches.length && i < 10; i++) {
        final match = threadMatches[i];
        final url = match.group(1) ?? '';
        final slug = match.group(2) ?? '';
        final id = int.tryParse(match.group(3) ?? '') ?? 0;

        String nombre = slug
            .replaceAll('-', ' ')
            .split(' ')
            .map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : w)
            .join(' ');

        final portada = i < imageMatches.length
            ? imageMatches[i].group(1) ?? ''
            : '';

        if (id > 0 && nombre.isNotEmpty) {
          resultados.add(
            F95Resultado(id: id, nombre: nombre, portada: portada, url: url),
          );
        }
      }

      return resultados;
    } catch (_) {
      return [];
    }
  }

  // Obtener detalle de un juego
  static Future<F95Detalle?> obtenerDetalle(String url) async {
    try {
      final dio = await _getDio();
      final response = await dio.get(url);
      final body = response.data.toString();

      // Título
      final ogTitleMatch = RegExp(
        r'<meta property="og:title" content="([^"]+)"',
      ).firstMatch(body);
      String nombre = ogTitleMatch?.group(1)?.trim() ?? '';
      nombre = nombre.replaceAll(' | F95zone', '').trim();

      // Versión
      final versionMatch = RegExp(
        r'\[v([^\]]+)\]',
        caseSensitive: false,
      ).firstMatch(nombre);
      final version = versionMatch?.group(1)?.trim() ?? '';
      if (version.isNotEmpty) {
        nombre = nombre
            .replaceAll('[v$version]', '')
            .replaceAll('[V$version]', '')
            .trim();
      }

      // Portada
      final ogImageMatch = RegExp(
        r'<meta property="og:image" content="([^"]+)"',
      ).firstMatch(body);
      final portada = ogImageMatch?.group(1) ?? '';

      // Descripción
      final ogDescMatch = RegExp(
        r'<meta property="og:description" content="([^"]+)"',
      ).firstMatch(body);
      String descripcion = ogDescMatch?.group(1)?.trim() ?? '';
      descripcion = descripcion
          .replaceAll('&quot;', '"')
          .replaceAll('&amp;', '&')
          .replaceAll('&#039;', "'")
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>');

      // Tags
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
}
