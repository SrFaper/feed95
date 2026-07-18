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
  final String imagenesExtra;

  F95Detalle({
    required this.nombre,
    required this.descripcion,
    required this.portada,
    required this.generos,
    required this.version,
    required this.imagenesExtra,
  });
}

class F95Service {
  static const _baseUrl = 'https://f95zone.to';
  static Dio? _dio;
  static PersistCookieJar? _cookieJar;

  static Future<Dio> _getDio() async {
    if (_dio != null) return _dio!;

    await _limpiarRutaVieja();
    final cookiePath = await _rutaCookies();
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

  static Future<String> _rutaCookies() async {
    if (!kIsWeb && Platform.isWindows) {
      final appData = Platform.environment['APPDATA']!;
      return p.join(appData, 'feed95', 'f95_cookies');
    }
    final appDir = await getApplicationDocumentsDirectory();
    return p.join(appDir.path, 'f95_cookies');
  }

  static Future<void> _limpiarRutaVieja() async {
    if (kIsWeb || !Platform.isWindows) return;
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final rutaVieja = Directory(p.join(docsDir.path, 'f95_cookies'));
      if (await rutaVieja.exists()) {
        await rutaVieja.delete(recursive: true);
      }
    } catch (_) {}
  }

  // Verificar si hay sesión activa
  static Future<bool> tieneSesion() async {
    try {
      await _getDio();

      final cookies = await _cookieJar?.loadForRequest(
        Uri.parse('https://f95zone.to'),
      );

      return cookies?.any((c) => c.name == 'xf_user') ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> asegurarSesion() async {
    await _getDio();

    final cookies = await _cookieJar?.loadForRequest(
      Uri.parse('https://f95zone.to'),
    );

    final tieneCookie = cookies?.any((c) => c.name == 'xf_user') ?? false;

    if (tieneCookie) {
      return true;
    }

    return await loginGuardado();
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
    final ok = await login(usuario: usuario, password: password);

    if (!ok) {
      await cerrarSesion();
    }

    return ok;
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
      final ok = await asegurarSesion();
      if (!ok) return [];

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
      final vistos = <int>{};

      // Regex ajustado para URLs relativas
      final threadRegex = RegExp(r'href="/threads/([^"]+?)\.(\d+)/"');
      final imageRegex = RegExp(
        r'<img[^>]+(?:data-src|src)="(https://[^"]+(?:attachments|preview)[^"]+)"',
      );

      final threadMatches = threadRegex.allMatches(body).toList();
      final imageMatches = imageRegex.allMatches(body).toList();

      int imageIndex = 0;

      for (int i = 0; i < threadMatches.length && resultados.length < 10; i++) {
        final match = threadMatches[i];
        final slug = match.group(1) ?? '';
        final id = int.tryParse(match.group(2) ?? '') ?? 0;

        // Saltar duplicados
        if (id == 0 || vistos.contains(id)) continue;
        vistos.add(id);

        final url = 'https://f95zone.to/threads/$slug.$id/';

        String nombre = slug
            .replaceAll('-', ' ')
            .split(' ')
            .map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : w)
            .join(' ');

        final portada = imageIndex < imageMatches.length
            ? imageMatches[imageIndex].group(1) ?? ''
            : '';
        imageIndex++;

        resultados.add(
          F95Resultado(id: id, nombre: nombre, portada: portada, url: url),
        );
      }

      return resultados;
    } catch (_) {
      return [];
    }
  }

  // Obtener detalle de un juego
  static Future<F95Detalle?> obtenerDetalle(String url) async {
    try {
      final ok = await asegurarSesion();
      if (!ok) return null;
      final dio = await _getDio();
      final response = await dio.get(url);
      final body = response.data.toString();

      // Título desde og:title
      final ogTitleMatch = RegExp(
        r'<meta property="og:title" content="([^"]+)"',
      ).firstMatch(body);
      String nombre = ogTitleMatch?.group(1)?.trim() ?? '';
      nombre = nombre.replaceAll(' | F95zone', '').trim();

      // Extraer versión del título si existe, formato común: "Nombre del Juego [v1.2.3]"
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

      // Limpiar prefijo de autor: "Autor - " al inicio, incluso con múltiples niveles "Autor1 - Autor2 - "
      nombre = nombre.replaceAll(RegExp(r'^(?:[^-]+ - )+'), '').trim();

      // Limpiar sufijo de tags: " [Tag1] [Tag2]" al final del título
      nombre = nombre.replaceAll(RegExp(r'\s*\[[^\]]+\]\s*$'), '').trim();

      // Decodificar entidades HTML básicas
      nombre = nombre
          .replaceAll('&amp;', '&')
          .replaceAll('&#039;', "'")
          .replaceAll('&quot;', '"')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>');

      // Portada — intentar varias fuentes en orden de prioridad
      String portada = '';

      // 1. Primera imagen grande del post (lbContainer-zoomer)
      final lbMatch = RegExp(
        r'lbContainer-zoomer[^>]+data-src="(https://attachments\.f95zone\.to/[^"]+)"',
      ).firstMatch(body);
      if (lbMatch != null) {
        portada = lbMatch.group(1) ?? '';
      }

      // 2. Primera bbImage con attachments
      if (portada.isEmpty) {
        final bbMatch = RegExp(
          r'<img[^>]+data-src="(https://attachments\.f95zone\.to/(?!.*thumb)[^"]+)"',
        ).firstMatch(body);
        if (bbMatch != null) {
          portada = bbMatch.group(1) ?? '';
        }
      }

      // 3. og:image como último recurso (puede ser el favicon)
      if (portada.isEmpty || portada.contains('favicon')) {
        final ogImageMatch = RegExp(
          r'<meta property="og:image" content="([^"]+)"',
        ).firstMatch(body);
        final ogImage = ogImageMatch?.group(1) ?? '';
        if (!ogImage.contains('favicon')) {
          portada = ogImage;
        }
      }

      // Extraer imagenes adicionales desde el post usando regex, limitando a 8
      final primerPostMatch = RegExp(
        r'<article[^>]*class="[^"]*message-body[^"]*"[^>]*>(.*?)</article>',
        dotAll: true,
      ).firstMatch(body);

      final primerPost = primerPostMatch?.group(1) ?? body;

      // Screenshots — buscar todas las imágenes de attachments en el primer post
      final screenshotMatches = RegExp(
        r'(?:data-src|src)="(https://attachments\.f95zone\.to/[^"]+)"',
      ).allMatches(primerPost);

      // Debug: imprimir portada y screenshots encontrados
      debugPrint('PORTADA: $portada');

      for (final match in screenshotMatches) {
        debugPrint('SCREENSHOT: ${match.group(1)}');
      }

      final urls = screenshotMatches
          .map((m) => m.group(1) ?? '')
          .where((u) => u.isNotEmpty)
          .map((u) => u.replaceFirst('/thumb/', '/'))
          .where((u) => u != portada)
          .toSet()
          .take(20)
          .toList();

      final imagenesExtra = urls.join(',');

      // Descripción desde og:description
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

      // Tags — sin límite
      final tagMatches = RegExp(
        r'<a[^>]+class="tagItem"[^>]*>([^<]+)</a>',
      ).allMatches(body);
      final generos = tagMatches
          .map((m) => m.group(1)?.trim() ?? '')
          .where((t) => t.isNotEmpty)
          .join(', ');

      return F95Detalle(
        nombre: nombre,
        descripcion: descripcion,
        portada: portada,
        generos: generos,
        version: version,
        imagenesExtra: imagenesExtra,
      );
    } catch (_) {
      return null;
    }
  }
}
