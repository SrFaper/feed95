import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../models/juego.dart';
import '../models/usuario.dart';

class ApiService {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    String path;

    if (!kIsWeb && Platform.isWindows) {
      // Guardar en AppData\Roaming\feed95\ en Windows
      final appData = Platform.environment['APPDATA']!;
      final dir = Directory(join(appData, 'feed95'));
      if (!await dir.exists()) await dir.create(recursive: true);
      path = join(dir.path, 'feed95.db');
    } else {
      final dbPath = await getDatabasesPath();
      path = join(dbPath, 'feed95.db');
    }

    return await openDatabase(
      path,
      version: 5,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE usuarios (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT NOT NULL UNIQUE,
          password TEXT NOT NULL,
          color INTEGER NOT NULL DEFAULT 4280391411
        )
      ''');
        await db.execute('''
        CREATE TABLE juegos (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT NOT NULL,
          descripcion TEXT,
          imagen TEXT,
          imagen_local TEXT,
          version TEXT,
          calificacion INTEGER,
          generos TEXT,
          estado TEXT,
          ruta_ejecutable TEXT,
          usuario_id INTEGER NOT NULL,
          FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute(
            'ALTER TABLE usuarios ADD COLUMN color INTEGER NOT NULL DEFAULT 4280391411',
          );
        }
        if (oldVersion < 4) {
          await db.execute('ALTER TABLE juegos ADD COLUMN imagen_local TEXT'
          );
        }
        if (oldVersion < 5) {
          await db.execute(
            'ALTER TABLE juegos ADD COLUMN ruta_ejecutable TEXT',
          );
        }
      },
    );
  }

  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  // Registro
  static Future<Map<String, dynamic>> registrarUsuario({
    required String nombre,
    required String password,
    required int color,
  }) async {
    final database = await db;
    try {
      final id = await database.insert('usuarios', {
        'nombre': nombre,
        'password': _hashPassword(password),
        'color': color,
      });
      final result = await database.query(
        'usuarios',
        where: 'id = ?',
        whereArgs: [id],
      );
      return {
        'success': true,
        'message': 'Perfil creado correctamente',
        'usuario': result.first,
      };
    } catch (e) {
      return {'success': false, 'message': 'Ese nombre de usuario ya existe'};
    }
  }

  // Login
  static Future<Map<String, dynamic>> login({
    required String nombre,
    required String password,
  }) async {
    final database = await db;
    final result = await database.query(
      'usuarios',
      where: 'nombre = ? AND password = ?',
      whereArgs: [nombre, _hashPassword(password)],
    );
    if (result.isNotEmpty) {
      return {'success': true, 'usuario': result.first};
    }
    return {'success': false, 'message': 'Contraseña incorrecta'};
  }

  // Listar todos los perfiles
  static Future<List<Usuario>> listarUsuarios() async {
    final database = await db;
    final result = await database.query('usuarios', orderBy: 'nombre ASC');
    return result.map((item) => Usuario.fromJson(item)).toList();
  }

  // Editar perfil
  static Future<Map<String, dynamic>> editarUsuario({
    required int id,
    required String nombre,
    String? password,
    int? color,
  }) async {
    final database = await db;
    try {
      final Map<String, dynamic> data = {'nombre': nombre};
      if (password != null && password.isNotEmpty) {
        data['password'] = _hashPassword(password);
      }
      if (color != null) data['color'] = color;
      await database.update('usuarios', data, where: 'id = ?', whereArgs: [id]);
      return {'success': true, 'message': 'Perfil actualizado correctamente'};
    } catch (e) {
      return {'success': false, 'message': 'Ese nombre ya está en uso'};
    }
  }

  // Eliminar perfil y sus juegos
  static Future<Map<String, dynamic>> eliminarUsuario(int id) async {
    final database = await db;
    await database.delete('juegos', where: 'usuario_id = ?', whereArgs: [id]);
    await database.delete('usuarios', where: 'id = ?', whereArgs: [id]);
    return {'success': true, 'message': 'Perfil eliminado'};
  }

  // Listar juegos del usuario
  static Future<List<Juego>> obtenerJuegos(int usuarioId) async {
    final database = await db;
    final result = await database.query(
      'juegos',
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
    );
    return result.map((item) => Juego.fromJson(item)).toList();
  }

  // Crear juego
  static Future<Map<String, dynamic>> crearJuego({
    required String nombre,
    required String descripcion,
    required String imagen,
    String? imagenLocal,
    required String version,
    required String calificacion,
    required String generos,
    required String estado,
    String? rutaEjecutable,
    required int usuarioId,
  }) async {
    final database = await db;
    await database.insert('juegos', {
      'nombre': nombre,
      'descripcion': descripcion,
      'imagen': imagen,
      'imagen_local': imagenLocal,
      'version': version,
      'calificacion': int.tryParse(calificacion) ?? 0,
      'generos': generos,
      'estado': estado,
      'ruta_ejecutable': rutaEjecutable,
      'usuario_id': usuarioId,
    });
    return {'success': true, 'message': 'Juego agregado correctamente'};
  }

  // Actualizar juego
  static Future<Map<String, dynamic>> actualizarJuego({
    required int id,
    required String nombre,
    required String descripcion,
    required String imagen,
    String? imagenLocal,
    required String version,
    required String calificacion,
    required String generos,
    String? rutaEjecutable,
    required String estado,
  }) async {
    final database = await db;
    await database.update(
      'juegos',
      {
        'nombre': nombre,
        'descripcion': descripcion,
        'imagen': imagen,
        'imagen_local': imagenLocal,
        'version': version,
        'calificacion': int.tryParse(calificacion) ?? 0,
        'generos': generos,
        'ruta_ejecutable': rutaEjecutable,
        'estado': estado,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    return {'success': true, 'message': 'Juego actualizado correctamente'};
  }

  // Eliminar juego
  static Future<Map<String, dynamic>> eliminarJuego(int id) async {
    final database = await db;
    await database.delete('juegos', where: 'id = ?', whereArgs: [id]);
    return {'success': true, 'message': 'Juego eliminado correctamente'};
  }

  static Usuario convertirUsuario(Map<String, dynamic> json) {
    return Usuario.fromJson(json);
  }

  static Future<Usuario?> obtenerUsuarioPorId(int id) async {
    final database = await db;
    final result = await database.query(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) return convertirUsuario(result.first);
    return null;
  }
}
