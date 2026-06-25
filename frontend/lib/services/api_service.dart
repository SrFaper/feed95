import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../models/juego.dart';
import '../models/usuario.dart';
import '../models/categoria.dart';

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
  static const backupRestaurado = 'apiBackupRestaurado';
}

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
      version: 13,
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
            imagen_crop_x REAL NOT NULL DEFAULT 0,
            imagen_crop_y REAL NOT NULL DEFAULT 0,
            imagen_crop_w REAL NOT NULL DEFAULT 1,
            imagen_crop_h REAL NOT NULL DEFAULT 1,
            imagen_grid_orig TEXT,
            imagen_grid_orig_local TEXT,
            imagen_grid_override TEXT,
            imagen_grid_override_local TEXT,
            imagen_grid_crop_x REAL NOT NULL DEFAULT 0,
            imagen_grid_crop_y REAL NOT NULL DEFAULT 0,
            imagen_grid_crop_w REAL NOT NULL DEFAULT 1,
            imagen_grid_crop_h REAL NOT NULL DEFAULT 1,
            version TEXT,
            calificacion INTEGER,
            estado TEXT,
            ruta_ejecutable TEXT,
            imagenes_extra TEXT,
            usuario_id INTEGER NOT NULL,
            catalogo INTEGER NOT NULL DEFAULT 0,
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
        // Tabla de relación muchos-a-muchos juego ↔ categoría
        await db.execute('''
          CREATE TABLE juego_categorias (
            juego_id INTEGER NOT NULL,
            categoria_id INTEGER NOT NULL,
            PRIMARY KEY (juego_id, categoria_id),
            FOREIGN KEY (juego_id) REFERENCES juegos(id) ON DELETE CASCADE,
            FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE CASCADE
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
        if (oldVersion < 12) {
          await db.execute(
            'ALTER TABLE juegos ADD COLUMN imagen_crop_x REAL NOT NULL DEFAULT 0',
          );
          await db.execute(
            'ALTER TABLE juegos ADD COLUMN imagen_crop_y REAL NOT NULL DEFAULT 0',
          );
          await db.execute(
            'ALTER TABLE juegos ADD COLUMN imagen_crop_w REAL NOT NULL DEFAULT 1',
          );
          await db.execute(
            'ALTER TABLE juegos ADD COLUMN imagen_crop_h REAL NOT NULL DEFAULT 1',
          );
          await db.execute(
            'ALTER TABLE juegos ADD COLUMN imagen_grid_crop_x REAL NOT NULL DEFAULT 0',
          );
          await db.execute(
            'ALTER TABLE juegos ADD COLUMN imagen_grid_crop_y REAL NOT NULL DEFAULT 0',
          );
          await db.execute(
            'ALTER TABLE juegos ADD COLUMN imagen_grid_crop_w REAL NOT NULL DEFAULT 1',
          );
          await db.execute(
            'ALTER TABLE juegos ADD COLUMN imagen_grid_crop_h REAL NOT NULL DEFAULT 1',
          );
        }
        if (oldVersion < 13) {
          // Crear tabla de relación muchos-a-muchos
          await db.execute('''
            CREATE TABLE IF NOT EXISTS juego_categorias (
              juego_id INTEGER NOT NULL,
              categoria_id INTEGER NOT NULL,
              PRIMARY KEY (juego_id, categoria_id),
              FOREIGN KEY (juego_id) REFERENCES juegos(id) ON DELETE CASCADE,
              FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE CASCADE
            )
          ''');
          // Migrar categoria_id existente → juego_categorias
          // Solo para juegos que tenían una categoría asignada
          try {
            final rows = await db.rawQuery(
              'SELECT id, categoria_id FROM juegos WHERE categoria_id IS NOT NULL',
            );
            final batch = db.batch();
            for (final row in rows) {
              batch.insert('juego_categorias', {
                'juego_id': row['id'],
                'categoria_id': row['categoria_id'],
              }, conflictAlgorithm: ConflictAlgorithm.ignore);
            }
            await batch.commit(noResult: true);
          } catch (_) {
            // Si categoria_id no existe (v10 en adelante la tabla fue recreada
            // sin ella en algunos paths), simplemente no hay nada que migrar.
          }
        }
      },
    );
  }

  // ── Helpers de contraseña ─────────────────────────────────────────────────

  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  static bool _sinPassword(String storedPassword) =>
      storedPassword == _kNoPassword;

  // ── Usuarios ──────────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> registrarUsuario({
    required String nombre,
    required String password,
    required int color,
    String? imagenPerfil,
  }) async {
    final database = await db;
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

  static Future<Map<String, dynamic>> login({
    required String nombre,
    required String password,
  }) async {
    final database = await db;
    final byName = await database.query(
      'usuarios',
      where: 'nombre = ?',
      whereArgs: [nombre],
    );
    if (byName.isEmpty) {
      return {'success': false, 'messageKey': ApiKeys.passwordIncorrecta};
    }
    final stored = byName.first['password'] as String;
    if (_sinPassword(stored)) {
      return {'success': true, 'usuario': byName.first};
    }
    if (stored == _hashPassword(password)) {
      return {'success': true, 'usuario': byName.first};
    }
    return {'success': false, 'messageKey': ApiKeys.passwordIncorrecta};
  }

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

  static Future<List<Usuario>> listarUsuarios() async {
    final database = await db;
    final result = await database.query('usuarios', orderBy: 'nombre ASC');
    return result.map((item) => Usuario.fromJson(item)).toList();
  }

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

  static Future<Map<String, dynamic>> eliminarUsuario(int id) async {
    final database = await db;
    await database.delete('juegos', where: 'usuario_id = ?', whereArgs: [id]);
    await database.delete('usuarios', where: 'id = ?', whereArgs: [id]);
    return {'success': true, 'messageKey': ApiKeys.perfilEliminado};
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

  static Usuario convertirUsuario(Map<String, dynamic> json) {
    return Usuario.fromJson(json);
  }

  // ── Juegos ────────────────────────────────────────────────────────────────

  /// Obtiene los juegos del usuario con sus categorías ya populadas.
  /// Hace una sola query a juegos + una query de categorías para todo el lote,
  /// evitando N+1 queries (una por juego).
  static Future<List<Juego>> obtenerJuegos(
    int usuarioId, {
    int catalogo = 0,
  }) async {
    final database = await db;

    final rows = await database.query(
      'juegos',
      where: 'usuario_id = ? AND catalogo = ?',
      whereArgs: [usuarioId, catalogo],
      orderBy: 'posicion ASC, id ASC',
    );

    if (rows.isEmpty) return [];

    // Obtener todas las categorías de los juegos del lote en una sola query
    final ids = rows.map((r) => r['id'] as int).toList();
    final placeholders = List.filled(ids.length, '?').join(',');
    final catRows = await database.rawQuery(
      'SELECT juego_id, categoria_id FROM juego_categorias WHERE juego_id IN ($placeholders)',
      ids,
    );

    // Construir mapa juego_id → List<categoria_id>
    final mapaCategs = <int, List<int>>{};
    for (final c in catRows) {
      final jid = c['juego_id'] as int;
      final cid = c['categoria_id'] as int;
      mapaCategs.putIfAbsent(jid, () => []).add(cid);
    }

    return rows.map((row) {
      final id = row['id'] as int;
      return Juego.fromJson(row, categorias: mapaCategs[id] ?? []);
    }).toList();
  }

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
    double imagenCropX = 0,
    double imagenCropY = 0,
    double imagenCropW = 1,
    double imagenCropH = 1,
    String imagenGridOrig = '',
    String? imagenGridOrigLocal,
    String? imagenGridOverride,
    String? imagenGridOverrideLocal,
    double imagenGridCropX = 0,
    double imagenGridCropY = 0,
    double imagenGridCropW = 1,
    double imagenGridCropH = 1,
    required String version,
    required String calificacion,
    required String estado,
    required int usuarioId,
    String? rutaEjecutable,
    String? imagenesExtra,
    int catalogo = 0,
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
      'imagen_crop_x': imagenCropX,
      'imagen_crop_y': imagenCropY,
      'imagen_crop_w': imagenCropW,
      'imagen_crop_h': imagenCropH,
      'imagen_grid_orig': imagenGridOrig,
      'imagen_grid_orig_local': imagenGridOrigLocal,
      'imagen_grid_override': imagenGridOverride,
      'imagen_grid_override_local': imagenGridOverrideLocal,
      'imagen_grid_crop_x': imagenGridCropX,
      'imagen_grid_crop_y': imagenGridCropY,
      'imagen_grid_crop_w': imagenGridCropW,
      'imagen_grid_crop_h': imagenGridCropH,
      'version': version,
      'calificacion': int.tryParse(calificacion) ?? 0,
      'estado': estado,
      'ruta_ejecutable': rutaEjecutable,
      'imagenes_extra': imagenesExtra,
      'usuario_id': usuarioId,
      'catalogo': catalogo,
      'posicion': maxPos + 1,
    });
    return {'success': true, 'messageKey': ApiKeys.juegoAgregadoOk, 'id': id};
  }

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
    double imagenCropX = 0,
    double imagenCropY = 0,
    double imagenCropW = 1,
    double imagenCropH = 1,
    String? imagenGridOrig,
    String? imagenGridOrigLocal,
    String? imagenGridOverride,
    String? imagenGridOverrideLocal,
    double imagenGridCropX = 0,
    double imagenGridCropY = 0,
    double imagenGridCropW = 1,
    double imagenGridCropH = 1,
    required String version,
    required String calificacion,
    required String estado,
    String? rutaEjecutable,
    String? imagenesExtra,
    int catalogo = 0,
  }) async {
    final database = await db;

    final data = <String, dynamic>{
      'version': version,
      'calificacion': int.tryParse(calificacion) ?? 0,
      'estado': estado,
      'ruta_ejecutable': rutaEjecutable,
      'imagenes_extra': imagenesExtra ?? '',
      'catalogo': catalogo,
      'nombre_override': nombreOverride,
      'descripcion_override': descripcionOverride,
      'generos_override': generosOverride,
      'imagen_override': imagenOverride,
      'imagen_override_local': imagenOverrideLocal,
      'imagen_crop_x': imagenCropX,
      'imagen_crop_y': imagenCropY,
      'imagen_crop_w': imagenCropW,
      'imagen_crop_h': imagenCropH,
      'imagen_grid_override': imagenGridOverride,
      'imagen_grid_override_local': imagenGridOverrideLocal,
      'imagen_grid_crop_x': imagenGridCropX,
      'imagen_grid_crop_y': imagenGridCropY,
      'imagen_grid_crop_w': imagenGridCropW,
      'imagen_grid_crop_h': imagenGridCropH,
    };

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

  /// Actualización rápida de estado y/o calificación desde el Dialog del grid.
  /// No toca ningún otro campo para minimizar escrituras a disco.
  static Future<void> actualizarEstadoYCalificacion({
    required int id,
    required String estado,
    required int calificacion,
  }) async {
    final database = await db;
    await database.update(
      'juegos',
      {'estado': estado, 'calificacion': calificacion},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> actualizarRutasLocales({
    required int id,
    String? imagenGridLocal,
    bool imagenGridEsOverride = false,
    String? imagenDetalleLocal,
    bool imagenDetalleEsOverride = false,
  }) async {
    final database = await db;
    final data = <String, dynamic>{};
    if (imagenGridLocal != null) {
      data[imagenGridEsOverride
              ? 'imagen_grid_override_local'
              : 'imagen_grid_orig_local'] =
          imagenGridLocal;
    }
    if (imagenDetalleLocal != null) {
      data[imagenDetalleEsOverride
              ? 'imagen_override_local'
              : 'imagen_orig_local'] =
          imagenDetalleLocal;
    }
    if (data.isEmpty) return;
    await database.update('juegos', data, where: 'id = ?', whereArgs: [id]);
  }

  static Future<Map<String, dynamic>> eliminarJuego(int id) async {
    final database = await db;
    // ON DELETE CASCADE en juego_categorias elimina las relaciones automáticamente
    await database.delete('juegos', where: 'id = ?', whereArgs: [id]);
    return {'success': true, 'messageKey': ApiKeys.juegoEliminadoOk};
  }

  // ── Categorías ────────────────────────────────────────────────────────────

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

  static Future<void> eliminarCategoria(int id) async {
    final database = await db;
    // ON DELETE CASCADE en juego_categorias elimina las relaciones automáticamente
    await database.delete('categorias', where: 'id = ?', whereArgs: [id]);
  }

  // ── Categorías de juego (muchos-a-muchos) ─────────────────────────────────

  /// Devuelve los IDs de categorías asignadas a un juego.
  static Future<List<int>> obtenerCategoriasDeJuego(int juegoId) async {
    final database = await db;
    final rows = await database.query(
      'juego_categorias',
      columns: ['categoria_id'],
      where: 'juego_id = ?',
      whereArgs: [juegoId],
    );
    return rows.map((r) => r['categoria_id'] as int).toList();
  }

  /// Asigna una categoría a un juego. No elimina las existentes.
  static Future<void> asignarCategoria(int juegoId, int categoriaId) async {
    final database = await db;
    await database.insert('juego_categorias', {
      'juego_id': juegoId,
      'categoria_id': categoriaId,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  /// Quita una categoría de un juego.
  static Future<void> quitarCategoria(int juegoId, int categoriaId) async {
    final database = await db;
    await database.delete(
      'juego_categorias',
      where: 'juego_id = ? AND categoria_id = ?',
      whereArgs: [juegoId, categoriaId],
    );
  }

  /// Reemplaza todas las categorías de un juego por la lista dada.
  /// Útil cuando el Dialog cierra y queremos sincronizar el estado completo.
  static Future<void> sincronizarCategorias(
    int juegoId,
    List<int> categoriaIds,
  ) async {
    final database = await db;
    final batch = database.batch();
    batch.delete(
      'juego_categorias',
      where: 'juego_id = ?',
      whereArgs: [juegoId],
    );
    for (final cid in categoriaIds) {
      batch.insert('juego_categorias', {
        'juego_id': juegoId,
        'categoria_id': cid,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch.commit(noResult: true);
  }

  // ── Orden ─────────────────────────────────────────────────────────────────

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

  // ── Estadísticas ──────────────────────────────────────────────────────────

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
              "SELECT COUNT(*) as c FROM juegos WHERE usuario_id = ? AND estado = 'Completed'",
              [usuarioId],
            )).first['c']
            as int? ??
        0;
    final jugando =
        (await database.rawQuery(
              "SELECT COUNT(*) as c FROM juegos WHERE usuario_id = ? AND estado = 'Playing'",
              [usuarioId],
            )).first['c']
            as int? ??
        0;
    return {'total': total, 'completados': completados, 'jugando': jugando};
  }

  // ── Backup ────────────────────────────────────────────────────────────────

  static Future<String> exportarBackup() async {
    final database = await db;
    final usuarios = await database.query('usuarios');
    final juegos = await database.query('juegos');
    final categorias = await database.query('categorias');
    final juegoCategorias = await database.query('juego_categorias');

    final backup = {
      'version': 3,
      'fecha': DateTime.now().toIso8601String(),
      'usuarios': usuarios,
      'juegos': juegos,
      'categorias': categorias,
      'juego_categorias': juegoCategorias,
    };

    return jsonEncode(backup);
  }

  static Future<Map<String, dynamic>> importarBackup(String jsonStr) async {
    final database = await db;

    try {
      final backup = jsonDecode(jsonStr) as Map<String, dynamic>;
      final usuarios = (backup['usuarios'] as List)
          .cast<Map<String, dynamic>>();
      final juegos = (backup['juegos'] as List).cast<Map<String, dynamic>>();
      final categorias = (backup['categorias'] as List? ?? [])
          .cast<Map<String, dynamic>>();
      final juegoCategorias = (backup['juego_categorias'] as List? ?? [])
          .cast<Map<String, dynamic>>();

      // Insertar usuarios
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

      // Insertar categorías y mapear sus IDs
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

      // Insertar juegos y mapear sus IDs
      final mapaJuegos = <int, int>{};
      for (final j in juegos) {
        final idOriginal = j['usuario_id'] as int;
        final idNuevo = mapaIds[idOriginal];
        if (idNuevo == null) continue;
        try {
          final nuevoId = await database.insert('juegos', {
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
            'imagen_crop_x': j['imagen_crop_x'] ?? 0,
            'imagen_crop_y': j['imagen_crop_y'] ?? 0,
            'imagen_crop_w': j['imagen_crop_w'] ?? 1,
            'imagen_crop_h': j['imagen_crop_h'] ?? 1,
            'imagen_grid_orig': j['imagen_grid_orig'] ?? '',
            'imagen_grid_orig_local': j['imagen_grid_orig_local'],
            'imagen_grid_override': j['imagen_grid_override'],
            'imagen_grid_override_local': j['imagen_grid_override_local'],
            'imagen_grid_crop_x': j['imagen_grid_crop_x'] ?? 0,
            'imagen_grid_crop_y': j['imagen_grid_crop_y'] ?? 0,
            'imagen_grid_crop_w': j['imagen_grid_crop_w'] ?? 1,
            'imagen_grid_crop_h': j['imagen_grid_crop_h'] ?? 1,
            'version': j['version'],
            'calificacion': j['calificacion'] ?? 0,
            'estado': j['estado'],
            'ruta_ejecutable': j['ruta_ejecutable'],
            'imagenes_extra': j['imagenes_extra'],
            'catalogo': j['catalogo'] ?? 0,
            'posicion': j['posicion'] ?? 0,
            'usuario_id': idNuevo,
          });
          mapaJuegos[j['id'] as int] = nuevoId;
        } catch (_) {}
      }

      // Restaurar relaciones juego_categorias
      // Soporta tanto backup v3 (con juego_categorias) como v2 legacy
      // (con categoria_id en juegos, ya migrado arriba vía mapaJuegos)
      if (juegoCategorias.isNotEmpty) {
        final batch = database.batch();
        for (final jc in juegoCategorias) {
          final nuevoJuegoId = mapaJuegos[jc['juego_id'] as int];
          final nuevoCatId = mapaCategorias[jc['categoria_id'] as int];
          if (nuevoJuegoId == null || nuevoCatId == null) continue;
          batch.insert('juego_categorias', {
            'juego_id': nuevoJuegoId,
            'categoria_id': nuevoCatId,
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
        }
        await batch.commit(noResult: true);
      } else {
        // Compatibilidad con backup v2: leer categoria_id del propio objeto juego
        final batch = database.batch();
        for (final j in juegos) {
          final catIdOriginal = j['categoria_id'];
          if (catIdOriginal == null) continue;
          final nuevoJuegoId = mapaJuegos[j['id'] as int];
          final nuevoCatId = mapaCategorias[catIdOriginal as int];
          if (nuevoJuegoId == null || nuevoCatId == null) continue;
          batch.insert('juego_categorias', {
            'juego_id': nuevoJuegoId,
            'categoria_id': nuevoCatId,
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
        }
        await batch.commit(noResult: true);
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
