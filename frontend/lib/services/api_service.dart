import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/juego.dart';
import '../models/usuario.dart';

// Clase encargada de centralizar todas las peticiones HTTP al backend
class ApiService {
  static const String baseUrl = 'http://localhost/feed95/backend';

  // Registro de usuario
  static Future<Map<String, dynamic>> registrarUsuario({
    required String nombre,
    required String correo,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/registro.php'),
      body: {
        'nombre': nombre,
        'correo': correo,
        'password': password,
      },
    );
    return jsonDecode(response.body);
  }

  // Inicio de sesión
  static Future<Map<String, dynamic>> login({
    required String correo,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login.php'),
      body: {
        'correo': correo,
        'password': password,
      },
    );
    return jsonDecode(response.body);
  }

  // Listar juegos
  static Future<List<Juego>> obtenerJuegos() async {
    final response = await http.get(
      Uri.parse('$baseUrl/productos/listar.php'),
    );
    final data = jsonDecode(response.body);
    if (data['success'] == true) {
      return (data['juegos'] as List)
          .map((item) => Juego.fromJson(item))
          .toList();
    }
    return [];
  }

  // Crear juego
  static Future<Map<String, dynamic>> crearJuego({
    required String nombre,
    required String descripcion,
    required String imagen,
    required String version,
    required String calificacion,
    required String generos,
    required String estado,
    required int usuarioId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/productos/crear.php'),
      body: {
        'nombre': nombre,
        'descripcion': descripcion,
        'imagen': imagen,
        'version': version,
        'calificacion': calificacion,
        'generos': generos,
        'estado': estado,
        'usuario_id': usuarioId.toString(),
      },
    );
    return jsonDecode(response.body);
  }

  // Actualizar juego
  static Future<Map<String, dynamic>> actualizarJuego({
    required int id,
    required String nombre,
    required String descripcion,
    required String imagen,
    required String version,
    required String calificacion,
    required String generos,
    required String estado,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/productos/actualizar.php'),
      body: {
        'id': id.toString(),
        'nombre': nombre,
        'descripcion': descripcion,
        'imagen': imagen,
        'version': version,
        'calificacion': calificacion,
        'generos': generos,
        'estado': estado,
      },
    );
    return jsonDecode(response.body);
  }

  // Eliminar juego
  static Future<Map<String, dynamic>> eliminarJuego(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/productos/eliminar.php'),
      body: {
        'id': id.toString(),
      },
    );
    return jsonDecode(response.body);
  }

  // Convierte JSON de usuario en objeto Usuario
  static Usuario convertirUsuario(Map<String, dynamic> json) {
    return Usuario.fromJson(json);
  }
}