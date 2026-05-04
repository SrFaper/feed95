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
    // Inicializar sqflite_common_ffi para Windows y Linux
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'feed95.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE juegos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            descripcion TEXT,
            imagen TEXT,
            version TEXT,
            calificacion INTEGER,
            generos TEXT,
            estado TEXT,
            usuario_id INTEGER NOT NULL,
            FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Por si alguien tenía la versión anterior con correo
        await db.execute('DROP TABLE IF EXISTS usuarios');
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL
          )
        ''');
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
  }) async {
    final database = await db;
    try {
      await database.insert('usuarios', {
        'nombre': nombre,
        'password': _hashPassword(password),
      });
      return {'success': true, 'message': 'Usuario registrado correctamente'};
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
    return {'success': false, 'message': 'Usuario o contraseña incorrectos'};
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
    required String version,
    required String calificacion,
    required String generos,
    required String estado,
    required int usuarioId,
  }) async {
    final database = await db;
    await database.insert('juegos', {
      'nombre': nombre,
      'descripcion': descripcion,
      'imagen': imagen,
      'version': version,
      'calificacion': int.tryParse(calificacion) ?? 0,
      'generos': generos,
      'estado': estado,
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
    required String version,
    required String calificacion,
    required String generos,
    required String estado,
  }) async {
    final database = await db;
    await database.update(
      'juegos',
      {
        'nombre': nombre,
        'descripcion': descripcion,
        'imagen': imagen,
        'version': version,
        'calificacion': int.tryParse(calificacion) ?? 0,
        'generos': generos,
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