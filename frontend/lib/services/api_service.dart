import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
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
      version: 6,
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
          imagen_grid TEXT,
          imagen_grid_local TEXT,
          imagenes_extra TEXT,
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
          await db.execute('ALTER TABLE juegos ADD COLUMN imagen_local TEXT');
        }
        if (oldVersion < 5) {
          await db.execute(
            'ALTER TABLE juegos ADD COLUMN ruta_ejecutable TEXT',
          );
        }
        if (oldVersion < 6) {
          await db.execute('ALTER TABLE juegos ADD COLUMN imagen_grid TEXT');
          await db.execute(
            'ALTER TABLE juegos ADD COLUMN imagen_grid_local TEXT',
          );
          await db.execute('ALTER TABLE juegos ADD COLUMN imagenes_extra TEXT');
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
    required String version,
    required String calificacion,
    required String generos,
    required String estado,
    required int usuarioId,
    String? imagenLocal,
    String? rutaEjecutable,
    String? imagenGrid,
    String? imagenGridLocal,
    String? imagenesExtra,
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
      'imagen_grid': imagenGrid,
      'imagen_grid_local': imagenGridLocal,
      'imagenes_extra': imagenesExtra,
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
    String? rutaEjecutable,
    String? imagenLocal,
    String? imagenGrid,
    String? imagenGridLocal,
    String? imagenesExtra,
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
        'imagen_grid': imagenGrid,
        'imagen_grid_local': imagenGridLocal,
        'imagenes_extra': imagenesExtra ?? '',
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

  // Exportar backup
  static Future<String> exportarBackup() async {
    final database = await db;
    final usuarios = await database.query('usuarios');
    final juegos = await database.query('juegos');

    final backup = {
      'version': 1,
      'fecha': DateTime.now().toIso8601String(),
      'usuarios': usuarios,
      'juegos': juegos,
    };

    return jsonEncode(backup);
  }

  // Importar backup
  static Future<Map<String, dynamic>> importarBackup(String jsonStr) async {
    final database = await db;

    try {
      final backup = jsonDecode(jsonStr) as Map<String, dynamic>;
      final usuarios = (backup['usuarios'] as List)
          .cast<Map<String, dynamic>>();
      final juegos = (backup['juegos'] as List).cast<Map<String, dynamic>>();

      // Insertar usuarios — si el nombre ya existe se omite
      for (final u in usuarios) {
        try {
          await database.insert('usuarios', {
            'nombre': u['nombre'],
            'password': u['password'],
            'color': u['color'] ?? 4280391411,
          });
        } catch (_) {
          // Usuario ya existe, se omite
        }
      }

      // Obtener mapa de nombres a IDs nuevos para reasignar juegos
      final usuariosNuevos = await database.query('usuarios');
      final mapaIds = <int, int>{};
      for (final u in usuarios) {
        final encontrado = usuariosNuevos.where(
          (n) => n['nombre'] == u['nombre'],
        );
        if (encontrado.isNotEmpty) {
          mapaIds[u['id'] as int] = encontrado.first['id'] as int;
        }
      }

      // Insertar juegos reasignando usuario_id
      for (final j in juegos) {
        final idOriginal = j['usuario_id'] as int;
        final idNuevo = mapaIds[idOriginal];
        if (idNuevo == null) continue;

        try {
          await database.insert('juegos', {
            'nombre': j['nombre'],
            'descripcion': j['descripcion'],
            'imagen': j['imagen'],
            'imagen_local': j['imagen_local'],
            'version': j['version'],
            'calificacion': j['calificacion'] ?? 0,
            'generos': j['generos'],
            'estado': j['estado'],
            'ruta_ejecutable': j['ruta_ejecutable'],
            'imagen_grid': j['imagen_grid'],
            'imagen_grid_local': j['imagen_grid_local'],
            'imagenes_extra': j['imagenes_extra'],
            'usuario_id': idNuevo,
          });
        } catch (_) {
          // Si falla un juego individual se omite y continúa
        }
      }

      return {
        'success': true,
        'message':
            'Backup restaurado: ${usuarios.length} perfil(es), ${juegos.length} juego(s)',
      };
    } catch (e) {
      return {'success': false, 'message': 'Archivo de backup inválido'};
    }
  }
}
