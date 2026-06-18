import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../models/juego.dart';
import '../models/usuario.dart';
import '../models/categoria.dart';

// Claves de respuesta — se traducen en la UI con l10n
// (evita pasar BuildContext al service)
class ApiKeys {
  static const perfilCreadoOk = 'apiPerfilCreadoOk';
  static const nombreDuplicado = 'apiNombreDuplicado';
  static const passwordIncorrecta = 'apiPasswordIncorrecta';
  static const perfilActualizadoOk = 'apiPerfilActualizadoOk';
  static const nombreEnUso = 'apiNombreEnUso';
  static const perfilEliminado = 'apiPerfilEliminado';
  static const categoriaCreada = 'apiCategoriaCreada';
  static const categoriaActualizada = 'apiCategoriaActualizada';
  static const juegoAgregadoOk = 'juegoFormAgregado';
  static const juegoActualizadoOk = 'juegoFormActualizado';
  static const juegoEliminadoOk = 'juegoFormEliminado';
  static const backupArchivoInvalido = 'apiBackupArchivoInvalido';
  // Para el backup restaurado se usa una clave especial con parámetros:
  // el caller debe detectar 'apiBackupRestaurado' y usar l10n.apiBackupRestaurado(...)
  static const backupRestaurado = 'apiBackupRestaurado';
}

// Valor especial que indica "sin contraseña"
const _kNoPassword = '';

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
      version: 11,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE usuarios (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT NOT NULL UNIQUE,
          password TEXT NOT NULL,
          color INTEGER NOT NULL DEFAULT 4280391411,
          imagen_perfil TEXT
        )
      ''');
        await db.execute('''
        CREATE TABLE juegos (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre_orig TEXT,
          nombre_override TEXT,
          descripcion_orig TEXT,
          descripcion_override TEXT,
          generos_orig TEXT,
          generos_override TEXT,
          imagen_orig TEXT,
          imagen_orig_local TEXT,
          imagen_override TEXT,
          imagen_override_local TEXT,
          imagen_ajuste_x REAL NOT NULL DEFAULT 0,
          imagen_ajuste_y REAL NOT NULL DEFAULT 0,
          imagen_ajuste_zoom REAL NOT NULL DEFAULT 1,
          imagen_grid_orig TEXT,
          imagen_grid_orig_local TEXT,
          imagen_grid_override TEXT,
          imagen_grid_override_local TEXT,
          imagen_grid_ajuste_x REAL NOT NULL DEFAULT 0,
          imagen_grid_ajuste_y REAL NOT NULL DEFAULT 0,
          imagen_grid_ajuste_zoom REAL NOT NULL DEFAULT 1,
          version TEXT,
          calificacion INTEGER,
          estado TEXT,
          ruta_ejecutable TEXT,
          imagenes_extra TEXT,
          usuario_id INTEGER NOT NULL,
          catalogo INTEGER NOT NULL DEFAULT 0,
          categoria_id INTEGER,
          posicion INTEGER NOT NULL DEFAULT 0,
          FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
        )
      ''');
        await db.execute('''
        CREATE TABLE categorias (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT NOT NULL,
          imagen TEXT,
          catalogo INTEGER NOT NULL DEFAULT 0,
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
        if (oldVersion < 7) {
          await db.execute(
            'ALTER TABLE juegos ADD COLUMN catalogo INTEGER NOT NULL DEFAULT 0',
          );
          await db.execute(
            'ALTER TABLE juegos ADD COLUMN categoria_id INTEGER',
          );
          await db.execute('''
            CREATE TABLE IF NOT EXISTS categorias (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nombre TEXT NOT NULL,
              imagen TEXT,
              catalogo INTEGER NOT NULL DEFAULT 0,
              usuario_id INTEGER NOT NULL,
              FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
          )
        ''');
        }
        if (oldVersion < 8) {
          await db.execute(
            'ALTER TABLE juegos ADD COLUMN posicion INTEGER NOT NULL DEFAULT 0',
          );
        }
        if (oldVersion < 9) {
          await db.execute(
            'ALTER TABLE usuarios ADD COLUMN imagen_perfil TEXT',
          );
        }
        if (oldVersion < 10) {
          // Migración al esquema original/override.
          // No hay forma fiable de separar "original" vs "personalizado" en datos
          // viejos, así que se recrea la tabla juegos desde cero (se pidió reimportar).
          await db.execute('DROP TABLE IF EXISTS juegos');
          await db.execute('''
            CREATE TABLE juegos (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nombre_orig TEXT,
              nombre_override TEXT,
              descripcion_orig TEXT,
              descripcion_override TEXT,
              generos_orig TEXT,
              generos_override TEXT,
              imagen_orig TEXT,
              imagen_orig_local TEXT,
              imagen_override TEXT,
              imagen_override_local TEXT,
              imagen_grid_orig TEXT,
              imagen_grid_orig_local TEXT,
              imagen_grid_override TEXT,
              imagen_grid_override_local TEXT,
              version TEXT,
              calificacion INTEGER,
              estado TEXT,
              ruta_ejecutable TEXT,
              imagenes_extra TEXT,
              usuario_id INTEGER NOT NULL,
              catalogo INTEGER NOT NULL DEFAULT 0,
              categoria_id INTEGER,
              posicion INTEGER NOT NULL DEFAULT 0,
              FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
            )
          ''');
        }
        if (oldVersion < 11) {
          await db.execute(
            'ALTER TABLE juegos ADD COLUMN imagen_ajuste_x REAL NOT NULL DEFAULT 0',
          );
          await db.execute(
            'ALTER TABLE juegos ADD COLUMN imagen_ajuste_y REAL NOT NULL DEFAULT 0',
          );
          await db.execute(
            'ALTER TABLE juegos ADD COLUMN imagen_ajuste_zoom REAL NOT NULL DEFAULT 1',
          );
          await db.execute(
            'ALTER TABLE juegos ADD COLUMN imagen_grid_ajuste_x REAL NOT NULL DEFAULT 0',
          );
          await db.execute(
            'ALTER TABLE juegos ADD COLUMN imagen_grid_ajuste_y REAL NOT NULL DEFAULT 0',
          );
          await db.execute(
            'ALTER TABLE juegos ADD COLUMN imagen_grid_ajuste_zoom REAL NOT NULL DEFAULT 1',
          );
        }
      },
    );
  }

  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  // Devuelve true si el perfil no tiene contraseña
  static bool _sinPassword(String storedPassword) =>
      storedPassword == _kNoPassword;

  // Registro
  static Future<Map<String, dynamic>> registrarUsuario({
    required String nombre,
    required String password,
    required int color,
    String? imagenPerfil,
  }) async {
    final database = await db;
    // Si password está vacío, se guarda '' (sin contraseña)
    final stored = password.isEmpty ? _kNoPassword : _hashPassword(password);
    try {
      final id = await database.insert('usuarios', {
        'nombre': nombre,
        'password': stored,
        'color': color,
        // ignore: use_null_aware_elements
        if (imagenPerfil != null) 'imagen_perfil': imagenPerfil,
      });
      final result = await database.query(
        'usuarios',
        where: 'id = ?',
        whereArgs: [id],
      );
      return {
        'success': true,
        'messageKey': ApiKeys.perfilCreadoOk,
        'usuario': result.first,
      };
    } catch (e) {
      return {'success': false, 'messageKey': ApiKeys.nombreDuplicado};
    }
  }

  // Login — si el perfil no tiene contraseña, acepta cualquier entrada (incluido vacío)
  static Future<Map<String, dynamic>> login({
    required String nombre,
    required String password,
  }) async {
    final database = await db;
    // Buscar el perfil por nombre
    final byName = await database.query(
      'usuarios',
      where: 'nombre = ?',
      whereArgs: [nombre],
    );
    if (byName.isEmpty) {
      return {'success': false, 'messageKey': ApiKeys.passwordIncorrecta};
    }
    final stored = byName.first['password'] as String;
    // Perfil sin contraseña → acceso directo
    if (_sinPassword(stored)) {
      return {'success': true, 'usuario': byName.first};
    }
    // Perfil con contraseña → verificar hash
    if (stored == _hashPassword(password)) {
      return {'success': true, 'usuario': byName.first};
    }
    return {'success': false, 'messageKey': ApiKeys.passwordIncorrecta};
  }

  // Indica si un perfil concreto tiene contraseña establecida
  static Future<bool> perfilTienePassword(int id) async {
    final database = await db;
    final result = await database.query(
      'usuarios',
      columns: ['password'],
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return false;
    return !_sinPassword(result.first['password'] as String);
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
    String? imagenPerfil,
    bool limpiarImagen = false,
    bool quitarPassword = false,
  }) async {
    final database = await db;
    try {
      final Map<String, dynamic> data = {'nombre': nombre};
      if (quitarPassword) {
        data['password'] = _kNoPassword;
      } else if (password != null && password.isNotEmpty) {
        data['password'] = _hashPassword(password);
      }
      if (color != null) data['color'] = color;
      if (limpiarImagen) {
        data['imagen_perfil'] = null;
      } else if (imagenPerfil != null) {
        data['imagen_perfil'] = imagenPerfil;
      }
      await database.update('usuarios', data, where: 'id = ?', whereArgs: [id]);
      return {'success': true, 'messageKey': ApiKeys.perfilActualizadoOk};
    } catch (e) {
      return {'success': false, 'messageKey': ApiKeys.nombreEnUso};
    }
  }

  // Eliminar perfil y sus juegos
  static Future<Map<String, dynamic>> eliminarUsuario(int id) async {
    final database = await db;
    await database.delete('juegos', where: 'usuario_id = ?', whereArgs: [id]);
    await database.delete('usuarios', where: 'id = ?', whereArgs: [id]);
    return {'success': true, 'messageKey': ApiKeys.perfilEliminado};
  }

  // Listar juegos del usuario
  static Future<List<Juego>> obtenerJuegos(
    int usuarioId, {
    int catalogo = 0,
  }) async {
    final database = await db;
    final result = await database.query(
      'juegos',
      where: 'usuario_id = ? AND catalogo = ?',
      whereArgs: [usuarioId, catalogo],
      orderBy: 'posicion ASC, id ASC',
    );
    return result.map((item) => Juego.fromJson(item)).toList();
  }

  // ── Crear juego ──────────────────────────────────────────────────────
  // Todos los campos "orig" representan datos importados de una fuente externa
  // (Steam/Epic/IGDB/F95). Los campos "override" son ediciones manuales del
  // usuario y siempre tienen prioridad visual sobre el original.
  // Si el juego se crea 100% manual (sin buscar en ninguna fuente), todo va
  // a override y el original queda vacío.
  static Future<Map<String, dynamic>> crearJuego({
    String nombreOrig = '',
    String? nombreOverride,
    String descripcionOrig = '',
    String? descripcionOverride,
    String generosOrig = '',
    String? generosOverride,
    String imagenOrig = '',
    String? imagenOrigLocal,
    String? imagenOverride,
    String? imagenOverrideLocal,
    double imagenAjusteX = 0,
    double imagenAjusteY = 0,
    double imagenAjusteZoom = 1,
    String imagenGridOrig = '',
    String? imagenGridOrigLocal,
    String? imagenGridOverride,
    String? imagenGridOverrideLocal,
    double imagenGridAjusteX = 0,
    double imagenGridAjusteY = 0,
    double imagenGridAjusteZoom = 1,
    required String version,
    required String calificacion,
    required String estado,
    required int usuarioId,
    String? rutaEjecutable,
    String? imagenesExtra,
    int catalogo = 0,
    int? categoriaId,
  }) async {
    final database = await db;
    final maxResult = await database.rawQuery(
      'SELECT MAX(posicion) as max FROM juegos WHERE usuario_id = ? AND catalogo = ?',
      [usuarioId, catalogo],
    );
    final maxPos = (maxResult.first['max'] as int?) ?? -1;

    final id = await database.insert('juegos', {
      'nombre_orig': nombreOrig,
      'nombre_override': nombreOverride,
      'descripcion_orig': descripcionOrig,
      'descripcion_override': descripcionOverride,
      'generos_orig': generosOrig,
      'generos_override': generosOverride,
      'imagen_orig': imagenOrig,
      'imagen_orig_local': imagenOrigLocal,
      'imagen_override': imagenOverride,
      'imagen_override_local': imagenOverrideLocal,
      'imagen_ajuste_x': imagenAjusteX,
      'imagen_ajuste_y': imagenAjusteY,
      'imagen_ajuste_zoom': imagenAjusteZoom,
      'imagen_grid_orig': imagenGridOrig,
      'imagen_grid_orig_local': imagenGridOrigLocal,
      'imagen_grid_override': imagenGridOverride,
      'imagen_grid_override_local': imagenGridOverrideLocal,
      'imagen_grid_ajuste_x': imagenGridAjusteX,
      'imagen_grid_ajuste_y': imagenGridAjusteY,
      'imagen_grid_ajuste_zoom': imagenGridAjusteZoom,
      'version': version,
      'calificacion': int.tryParse(calificacion) ?? 0,
      'estado': estado,
      'ruta_ejecutable': rutaEjecutable,
      'imagenes_extra': imagenesExtra,
      'usuario_id': usuarioId,
      'catalogo': catalogo,
      'categoria_id': categoriaId,
      'posicion': maxPos + 1,
    });
    return {'success': true, 'messageKey': ApiKeys.juegoAgregadoOk, 'id': id};
  }

  // ── Actualizar juego ─────────────────────────────────────────────────
  // Nota: los campos "orig" solo se actualizan si se vuelve a buscar en una
  // fuente externa; esta función siempre recibe el set completo resultante
  // desde la pantalla de formulario (que ya sabe qué cambió).
  static Future<Map<String, dynamic>> actualizarJuego({
    required int id,
    String? nombreOrig,
    String? nombreOverride,
    String? descripcionOrig,
    String? descripcionOverride,
    String? generosOrig,
    String? generosOverride,
    String? imagenOrig,
    String? imagenOrigLocal,
    String? imagenOverride,
    String? imagenOverrideLocal,
    double imagenAjusteX = 0,
    double imagenAjusteY = 0,
    double imagenAjusteZoom = 1,
    String? imagenGridOrig,
    String? imagenGridOrigLocal,
    String? imagenGridOverride,
    String? imagenGridOverrideLocal,
    double imagenGridAjusteX = 0,
    double imagenGridAjusteY = 0,
    double imagenGridAjusteZoom = 1,
    required String version,
    required String calificacion,
    required String estado,
    String? rutaEjecutable,
    String? imagenesExtra,
    int catalogo = 0,
    int? categoriaId,
  }) async {
    final database = await db;

    final data = <String, dynamic>{
      'version': version,
      'calificacion': int.tryParse(calificacion) ?? 0,
      'estado': estado,
      'ruta_ejecutable': rutaEjecutable,
      'imagenes_extra': imagenesExtra ?? '',
      'catalogo': catalogo,
      'categoria_id': categoriaId,
      // Overrides: se guardan siempre (pueden ser null para "limpiar")
      'nombre_override': nombreOverride,
      'descripcion_override': descripcionOverride,
      'generos_override': generosOverride,
      'imagen_override': imagenOverride,
      'imagen_override_local': imagenOverrideLocal,
      'imagen_ajuste_x': imagenAjusteX,
      'imagen_ajuste_y': imagenAjusteY,
      'imagen_ajuste_zoom': imagenAjusteZoom,
      'imagen_grid_override': imagenGridOverride,
      'imagen_grid_override_local': imagenGridOverrideLocal,
      'imagen_grid_ajuste_x': imagenGridAjusteX,
      'imagen_grid_ajuste_y': imagenGridAjusteY,
      'imagen_grid_ajuste_zoom': imagenGridAjusteZoom,
    };

    // Originales: solo se tocan si se proveen explícitamente (re-búsqueda en fuente)
    if (nombreOrig != null) data['nombre_orig'] = nombreOrig;
    if (descripcionOrig != null) data['descripcion_orig'] = descripcionOrig;
    if (generosOrig != null) data['generos_orig'] = generosOrig;
    if (imagenOrig != null) data['imagen_orig'] = imagenOrig;
    if (imagenOrigLocal != null) data['imagen_orig_local'] = imagenOrigLocal;
    if (imagenGridOrig != null) data['imagen_grid_orig'] = imagenGridOrig;
    if (imagenGridOrigLocal != null) {
      data['imagen_grid_orig_local'] = imagenGridOrigLocal;
    }

    await database.update('juegos', data, where: 'id = ?', whereArgs: [id]);
    return {'success': true, 'messageKey': ApiKeys.juegoActualizadoOk};
  }

  // Eliminar juego
  static Future<Map<String, dynamic>> eliminarJuego(int id) async {
    final database = await db;
    await database.delete('juegos', where: 'id = ?', whereArgs: [id]);
    return {'success': true, 'messageKey': ApiKeys.juegoEliminadoOk};
  }

  // Listar categorías del usuario
  static Future<List<Categoria>> obtenerCategorias(
    int usuarioId,
    int catalogo,
  ) async {
    final database = await db;
    final result = await database.query(
      'categorias',
      where: 'usuario_id = ? AND catalogo = ?',
      whereArgs: [usuarioId, catalogo],
      orderBy: 'nombre ASC',
    );
    return result.map((item) => Categoria.fromJson(item)).toList();
  }

  // Crear categoría
  static Future<Map<String, dynamic>> crearCategoria({
    required String nombre,
    String? imagen,
    required int usuarioId,
    required int catalogo,
  }) async {
    final database = await db;
    await database.insert('categorias', {
      'nombre': nombre,
      'imagen': imagen,
      'usuario_id': usuarioId,
      'catalogo': catalogo,
    });
    return {'success': true, 'messageKey': ApiKeys.categoriaCreada};
  }

  // Editar categoría
  static Future<Map<String, dynamic>> editarCategoria({
    required int id,
    required String nombre,
    String? imagen,
  }) async {
    final database = await db;
    await database.update(
      'categorias',
      {'nombre': nombre, 'imagen': imagen},
      where: 'id = ?',
      whereArgs: [id],
    );
    return {'success': true, 'messageKey': ApiKeys.categoriaActualizada};
  }

  // Eliminar categoría (desasigna juegos)
  static Future<void> eliminarCategoria(int id) async {
    final database = await db;
    await database.update(
      'juegos',
      {'categoria_id': null},
      where: 'categoria_id = ?',
      whereArgs: [id],
    );
    await database.delete('categorias', where: 'id = ?', whereArgs: [id]);
  }

  // Asignar categoría a juego
  static Future<void> asignarCategoria(int juegoId, int? categoriaId) async {
    final database = await db;
    await database.update(
      'juegos',
      {'categoria_id': categoriaId},
      where: 'id = ?',
      whereArgs: [juegoId],
    );
  }

  // Guardar orden de juegos
  static Future<void> guardarOrden(List<int> idsOrdenados) async {
    final database = await db;
    final batch = database.batch();
    for (int i = 0; i < idsOrdenados.length; i++) {
      batch.update(
        'juegos',
        {'posicion': i},
        where: 'id = ?',
        whereArgs: [idsOrdenados[i]],
      );
    }
    await batch.commit(noResult: true);
  }

  // Obtener estadísticas del usuario
  static Future<Map<String, dynamic>> obtenerEstadisticas(int usuarioId) async {
    final database = await db;
    final total =
        (await database.rawQuery(
              'SELECT COUNT(*) as c FROM juegos WHERE usuario_id = ?',
              [usuarioId],
            )).first['c']
            as int? ??
        0;
    final completados =
        (await database.rawQuery(
              'SELECT COUNT(*) as c FROM juegos WHERE usuario_id = ? AND estado = ?',
              [usuarioId, 'Completed'],
            )).first['c']
            as int? ??
        0;
    final jugando =
        (await database.rawQuery(
              'SELECT COUNT(*) as c FROM juegos WHERE usuario_id = ? AND estado = ?',
              [usuarioId, 'Playing'],
            )).first['c']
            as int? ??
        0;
    return {'total': total, 'completados': completados, 'jugando': jugando};
  }

  // Convertir JSON a Usuario
  static Usuario convertirUsuario(Map<String, dynamic> json) {
    return Usuario.fromJson(json);
  }

  // Obtener usuario por ID
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
    final categorias = await database.query('categorias');

    final backup = {
      'version': 2,
      'fecha': DateTime.now().toIso8601String(),
      'usuarios': usuarios,
      'juegos': juegos,
      'categorias': categorias,
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
      final categorias = (backup['categorias'] as List? ?? [])
          .cast<Map<String, dynamic>>();

      for (final u in usuarios) {
        try {
          await database.insert('usuarios', {
            'nombre': u['nombre'],
            'password': u['password'],
            'color': u['color'] ?? 4280391411,
          });
        } catch (_) {}
      }

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

      final mapaCategorias = <int, int>{};

      for (final c in categorias) {
        final idUsuarioOriginal = c['usuario_id'] as int;
        final idUsuarioNuevo = mapaIds[idUsuarioOriginal];
        if (idUsuarioNuevo == null) continue;

        try {
          final nuevaId = await database.insert('categorias', {
            'nombre': c['nombre'],
            'imagen': c['imagen'],
            'catalogo': c['catalogo'] ?? 0,
            'usuario_id': idUsuarioNuevo,
          });
          mapaCategorias[c['id'] as int] = nuevaId;
        } catch (_) {}
      }

      for (final j in juegos) {
        final idOriginal = j['usuario_id'] as int;
        final idNuevo = mapaIds[idOriginal];
        if (idNuevo == null) continue;

        try {
          int? categoriaNueva;
          if (j['categoria_id'] != null) {
            categoriaNueva = mapaCategorias[j['categoria_id']];
          }
          await database.insert('juegos', {
            'nombre_orig': j['nombre_orig'] ?? '',
            'nombre_override': j['nombre_override'],
            'descripcion_orig': j['descripcion_orig'] ?? '',
            'descripcion_override': j['descripcion_override'],
            'generos_orig': j['generos_orig'] ?? '',
            'generos_override': j['generos_override'],
            'imagen_orig': j['imagen_orig'] ?? '',
            'imagen_orig_local': j['imagen_orig_local'],
            'imagen_override': j['imagen_override'],
            'imagen_override_local': j['imagen_override_local'],
            'imagen_grid_orig': j['imagen_grid_orig'] ?? '',
            'imagen_grid_orig_local': j['imagen_grid_orig_local'],
            'imagen_grid_override': j['imagen_grid_override'],
            'imagen_grid_override_local': j['imagen_grid_override_local'],
            'version': j['version'],
            'calificacion': j['calificacion'] ?? 0,
            'estado': j['estado'],
            'ruta_ejecutable': j['ruta_ejecutable'],
            'imagenes_extra': j['imagenes_extra'],
            'catalogo': j['catalogo'] ?? 0,
            'categoria_id': categoriaNueva,
            'posicion': j['posicion'] ?? 0,
            'usuario_id': idNuevo,
          });
        } catch (_) {}
      }

      return {
        'success': true,
        'messageKey': ApiKeys.backupRestaurado,
        'perfiles': usuarios.length,
        'categorias': categorias.length,
        'juegos': juegos.length,
      };
    } catch (e) {
      return {'success': false, 'messageKey': ApiKeys.backupArchivoInvalido};
    }
  }
}
