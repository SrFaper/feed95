# Contexto Feed95
_Generado automáticamente. No editar a mano._

## `README.md`

```markdown
<div align="center">

# feed95

**Catálogo personal de videojuegos para Windows y Android.**
**Personal video game catalog for Windows and Android.**

Sin cuentas. Sin servidores. Sin internet. Solo tus juegos, en tu dispositivo.
No accounts. No servers. No internet. Just your games, on your device.

</div>

---

## Español

### Características

- **Múltiples perfiles locales** - Cada perfil tiene su propia contraseña, color de acento e imagen. Comparte el dispositivo sin mezclar catálogos.
- **100% offline** - Todo se guarda en una base de datos SQLite local. Sin cuentas, sin nube, sin conexión obligatoria. Tus datos no salen de tu dispositivo.
- **Búsqueda automática de metadatos** - Importa portada, descripción, géneros y capturas desde Steam, Epic Games o IGDB con un clic.
- **Categorías y filtros** - Organiza tu catálogo con categorías personalizadas. Filtra por estado, categoría o búsqueda de texto.
- **Estados y calificaciones** - Marca cada juego como Pendiente, Jugando, Completado o Abandonado. Puntúa del 1 al 10. Reordena tu catálogo a mano.
- **Catálogo secundario opcional** - Un segundo catálogo separado del principal, ideal para mantener colecciones distintas bajo el mismo perfil.
- **Lanzador integrado** - Vincula el ejecutable de cada juego y árrancalo directo desde la app. Solo en Windows.
- **Backup y restauración** - Exporta toda tu colección a un archivo JSON e impórtala en cualquier dispositivo cuando quieras.
- **Tema claro / oscuro con acento personalizable** - La interfaz se adapta al color que elijas para cada perfil.

### Descarga e instalación

**Android**

1. Descarga `feed95.apk` desde la sección de [Releases](https://github.com/SrFaper/feed95/releases).
2. Ábrelo en tu dispositivo. Si el sistema lo pide, permite la instalación desde fuentes desconocidas.

**Windows**

1. Descarga `feed95-windows.zip` desde la sección de [Releases](https://github.com/SrFaper/feed95/releases).
2. Extrae el contenido en la carpeta que prefieras.
3. Ejecuta `feed95.exe`. No requiere instalación.

### Búsqueda de metadatos

feed95 puede importar información de juegos desde tres fuentes:

| Fuente | Requiere configuración |
|--------|----------------------|
| Steam | No |
| Epic Games Store | No |
| IGDB | Sí, credenciales gratuitas de Twitch Developer |

Para configurar IGDB: visita [dev.twitch.tv](https://dev.twitch.tv), crea una aplicación y copia tu Client-ID y Client-Secret en Configuraciones dentro de la app.

### Construido con

- [Flutter](https://flutter.dev/) - Framework multiplataforma
- [SQLite / sqflite](https://pub.dev/packages/sqflite) - Base de datos local
- [dio](https://pub.dev/packages/dio) + [cookie_jar](https://pub.dev/packages/cookie_jar) - Peticiones HTTP
- [flutter_colorpicker](https://pub.dev/packages/flutter_colorpicker) - Selector de color de perfil
- [file_picker](https://pub.dev/packages/file_picker) / [image_picker](https://pub.dev/packages/image_picker) - Selección de archivos e imágenes

### Licencia

feed95 se distribuye bajo la licencia **GNU General Public License v3.0**. Consulta el archivo [`LICENSE`](LICENSE) para más detalles.

En cristiano: puedes usar, copiar, modificar y distribuir este software (incluso comercialmente), pero cualquier versión derivada debe distribuirse también bajo GPL v3 con el código fuente disponible.

### Avisos de terceros y atribución

feed95 utiliza datos de servicios externos para enriquecer el catálogo. Estos servicios no están afiliados al proyecto ni lo respaldan.

**Steam / Valve**
Los metadatos de juegos de Steam se obtienen a través de los endpoints públicos de la tienda de Steam (`store.steampowered.com/api`). Steam y el logotipo de Steam son marcas registradas de Valve Corporation. feed95 no está afiliado con Valve ni con Steam.

**Epic Games Store**
Los metadatos de Epic se obtienen a través del endpoint GraphQL público de la Epic Games Store. Este endpoint no está documentado oficialmente ni respaldado por Epic Games. feed95 no está afiliado con Epic Games.

**IGDB**
Los datos de videojuegos son provistos por [IGDB.com](https://www.igdb.com), propiedad de Twitch Interactive, Inc.

> Game data provided by IGDB.com

La API de IGDB es gratuita para proyectos no comerciales bajo los términos del [Twitch Developer Service Agreement](https://www.twitch.tv/p/legal/developer-agreement/). feed95 es un proyecto de código abierto sin monetización. Si realizas un fork comercial de este proyecto, deberás revisar los términos de uso de IGDB de forma independiente y considerar contactar a partner@igdb.com.

---

## English

### Features

- **Multiple local profiles** - Each profile has its own password, accent color, and image. Share a device without mixing catalogs.
- **100% offline** - Everything is stored in a local SQLite database. No accounts, no cloud, no required internet connection. Your data never leaves your device.
- **Automatic metadata search** - Import cover art, description, genres, and screenshots from Steam, Epic Games, or IGDB in one click.
- **Categories and filters** - Organize your catalog with custom categories. Filter by status, category, or text search.
- **Statuses and ratings** - Mark each game as Pending, Playing, Completed, or Abandoned. Rate from 1 to 10. Reorder your catalog manually.
- **Optional secondary catalog** - A second catalog separate from the main one, ideal for keeping distinct collections under the same profile.
- **Built-in launcher** - Link each game's executable and launch it directly from the app. Windows only.
- **Backup and restore** - Export your entire collection to a JSON file and import it on any device whenever you want.
- **Light / dark theme with custom accent** - The interface adapts to the color you choose for each profile.

### Download and Installation

**Android**

1. Download `feed95.apk` from the [Releases](https://github.com/SrFaper/feed95/releases) tab.
2. Open it on your device and allow installation from unknown sources if prompted.

**Windows**

1. Download `feed95-windows.zip` from the [Releases](https://github.com/SrFaper/feed95/releases) tab.
2. Extract the contents to any folder.
3. Run `feed95.exe`. No installation required.

### Metadata Search

feed95 can import game information from three sources:

| Source | Setup required |
|--------|---------------|
| Steam | No |
| Epic Games Store | No |
| IGDB | Yes, free Twitch Developer credentials |

To set up IGDB: visit [dev.twitch.tv](https://dev.twitch.tv), create an application, and enter your Client-ID and Client-Secret in the Settings section of the app.

### Built with

- [Flutter](https://flutter.dev/) - Cross-platform framework
- [SQLite / sqflite](https://pub.dev/packages/sqflite) - Local database
- [dio](https://pub.dev/packages/dio) + [cookie_jar](https://pub.dev/packages/cookie_jar) - HTTP requests
- [flutter_colorpicker](https://pub.dev/packages/flutter_colorpicker) - Profile color picker
- [file_picker](https://pub.dev/packages/file_picker) / [image_picker](https://pub.dev/packages/image_picker) - File and image selection

### License

feed95 is distributed under the **GNU General Public License v3.0**. See the [`LICENSE`](LICENSE) file for details.

In practical terms: you can use, copy, modify, and distribute this software (including commercially), but any derivative version must also be distributed under GPL v3 with the source code available.

### Third-Party Notices and Attribution

feed95 uses data from external services to enrich the catalog. These services are not affiliated with this project and do not endorse it.

**Steam / Valve**
Steam game metadata is fetched through the public endpoints of the Steam store (`store.steampowered.com/api`). Steam and the Steam logo are registered trademarks of Valve Corporation. feed95 is not affiliated with Valve or Steam.

**Epic Games Store**
Epic metadata is fetched through the public GraphQL endpoint of the Epic Games Store. This endpoint is not officially documented or endorsed by Epic Games. feed95 is not affiliated with Epic Games.

**IGDB**
Video game data is provided by [IGDB.com](https://www.igdb.com), owned by Twitch Interactive, Inc.

> Game data provided by IGDB.com

The IGDB API is free for non-commercial projects under the terms of the [Twitch Developer Service Agreement](https://www.twitch.tv/p/legal/developer-agreement/). feed95 is a non-monetized open source project. If you create a commercial fork of this project, you must review IGDB's terms of use independently and consider reaching out to partner@igdb.com.

---

<div align="center">
feed95 &copy; 2026
</div>
```

## `.github/workflows/build-apk.yml`

```yaml
name: Build Flutter APK

on:
  push:
    branches:
      - main
    paths:
      - 'frontend/**'
      - '.github/workflows/build-apk.yml'

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout código
        uses: actions/checkout@v4.2.2

      - name: Configurar Java
        uses: actions/setup-java@v4.7.0
        with:
          distribution: 'zulu'
          java-version: '17'

      - name: Configurar Flutter
        run: |
          git clone https://github.com/flutter/flutter.git --branch 3.41.7 --depth 1 $HOME/flutter
          echo "$HOME/flutter/bin" >> $GITHUB_PATH

      - name: Restaurar servicios privados
        run: |
          echo "${{ secrets.F95_SERVICE }}" | base64 --decode > frontend/lib/services/f95_service.dart
          echo "${{ secrets.F95_CONFIG_SCREEN }}" | base64 --decode > frontend/lib/screens/f95_config_screen.dart
          
      - name: Instalar dependencias
        working-directory: frontend
        run: flutter pub get

      - name: Build APK release
        working-directory: frontend
        run: flutter build apk --release

      - name: Renombrar APK
        run: mv frontend/build/app/outputs/flutter-apk/app-release.apk feed95.apk

      - name: Borrar Release 'beta' anterior
        uses: dev-drprasad/delete-tag-and-release@v1.1
        with:
          delete_release: true
          tag_name: beta-android
          github_token: ${{ secrets.GITHUB_TOKEN }}

      - name: Crear Pre-release 'beta'
        uses: softprops/action-gh-release@v2
        with:
          tag_name: beta-android
          name: "Feed95 - Versión Beta (Android)"
          body: "Versión beta de la aplicación para Android."
          # Para que sea un lanzamiento oficial solo debo cambiar el prerelease a false
          prerelease: true
          files: feed95.apk
          token: ${{ secrets.GITHUB_TOKEN }}
```

## `.github/workflows/build-exe.yml`

```yaml
name: Build Flutter Windows EXE

on:
  push:
    branches:
      - main
    paths:
      - 'frontend/**'
      - '.github/workflows/build-exe.yml'

jobs:
  build:
    runs-on: windows-latest

    steps:
      - name: Checkout código
        uses: actions/checkout@v4.2.2

      - name: Configurar Flutter
        run: |
          git clone https://github.com/flutter/flutter.git --branch 3.41.7 --depth 1 $env:USERPROFILE\flutter
          echo "$env:USERPROFILE\flutter\bin" >> $env:GITHUB_PATH

      - name: Restaurar servicios privados
        shell: pwsh
        run: |
          [System.IO.File]::WriteAllBytes("frontend/lib/services/f95_service.dart", [System.Convert]::FromBase64String("${{ secrets.F95_SERVICE }}"))
          [System.IO.File]::WriteAllBytes("frontend/lib/screens/f95_config_screen.dart", [System.Convert]::FromBase64String("${{ secrets.F95_CONFIG_SCREEN }}"))

      - name: Instalar dependencias
        working-directory: frontend
        run: flutter pub get

      - name: Habilitar soporte Windows
        working-directory: frontend
        run: flutter config --enable-windows-desktop

      - name: Build Windows
        working-directory: frontend
        run: flutter build windows --release

      - name: Comprimir ejecutable
        # Al renombrar el binario en CMakeLists, el ejecutable ya se llamará feed95.exe
        run: |
          Compress-Archive -Path "frontend\build\windows\x64\runner\Release\*" -DestinationPath "feed95.zip"

      - name: Borrar Release 'beta' anterior
        uses: dev-drprasad/delete-tag-and-release@v1.1
        with:
          delete_release: true
          tag_name: beta-windows
          github_token: ${{ secrets.GITHUB_TOKEN }}

      - name: Crear Pre-release 'beta'
        uses: softprops/action-gh-release@v2
        with:
          tag_name: beta-windows
          name: "Feed95 - Versión Beta (Windows)"
          body: "Versión beta de la aplicación para Windows."
          # Para que sea un lanzamiento oficial solo debo cambiar el prerelease a false
          prerelease: true
          files: feed95.zip
          token: ${{ secrets.GITHUB_TOKEN }}
```

## `frontend/pubspec.yaml`

```yaml
name: frontend
description: "A new Flutter project."
# The following line prevents the package from being accidentally published to
# pub.dev using `flutter pub publish`. This is preferred for private packages.
publish_to: 'none' # Remove this line if you wish to publish to pub.dev

version: 1.0.0+1

environment:
  sdk: ^3.11.1

dependencies:
  flutter:
    sdk: flutter

  flutter_localizations:
    sdk: flutter
  intl: ^0.20.2
  
  cupertino_icons: ^1.0.8
  sqflite: ^2.3.3
  path: ^1.9.0
  crypto: ^3.0.3
  shared_preferences: ^2.3.3
  sqflite_common_ffi: ^2.3.4
  image_picker: ^1.1.2
  file_picker: ^8.1.4
  http: ^1.4.0
  cookie_jar: ^4.0.8
  dio: ^5.7.0
  dio_cookie_manager: ^3.1.1
  path_provider: ^2.1.5
  flutter_colorpicker: ^1.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0

flutter:
  generate: true
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  # assets:
  #   - images/a_dot_burr.jpeg
  #   - images/a_dot_ham.jpeg

  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/to/resolution-aware-images

  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/to/asset-from-package

  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  # fonts:
  #   - family: Schyler
  #     fonts:
  #       - asset: fonts/Schyler-Regular.ttf
  #       - asset: fonts/Schyler-Italic.ttf
  #         style: italic
  #   - family: Trajan Pro
  #     fonts:
  #       - asset: fonts/TrajanPro.ttf
  #       - asset: fonts/TrajanPro_Bold.ttf
  #         weight: 700
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/to/font-from-package
```

## `frontend/l10n.yaml`

```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
```

## `frontend/lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/perfiles_screen.dart';
import 'screens/home_screen.dart';
import 'services/api_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frontend/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Feed95App());
}

class Feed95App extends StatefulWidget {
  const Feed95App({super.key});

  static Feed95AppState? of(BuildContext context) =>
      context.findAncestorStateOfType<Feed95AppState>();

  @override
  State<Feed95App> createState() => Feed95AppState();
}

class Feed95AppState extends State<Feed95App> {
  ThemeMode _themeMode = ThemeMode.system;
  Color _accentColor = const Color.fromARGB(255, 255, 54, 71);

  @override
  void initState() {
    super.initState();
    _cargarPreferencias();
  }

  Future<void> _cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    final tema = prefs.getString('theme_mode') ?? 'system';
    final colorInt =
        prefs.getInt('accent_color') ??
        const Color.fromARGB(255, 255, 54, 71).toARGB32();
    setState(() {
      _themeMode = tema == 'dark'
          ? ThemeMode.dark
          : tema == 'light'
          ? ThemeMode.light
          : ThemeMode.system;
      _accentColor = Color(colorInt);
    });
  }

  Future<void> cambiarTema(ThemeMode modo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'theme_mode',
      modo == ThemeMode.dark
          ? 'dark'
          : modo == ThemeMode.light
          ? 'light'
          : 'system',
    );
    setState(() => _themeMode = modo);
  }

  Future<void> cambiarColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accent_color', color.toARGB32());
    setState(() => _accentColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feed95',
      debugShowCheckedModeBanner: false,
   // locale: const Locale('en'), usar esta linea para probar el cambio de idioma sin cambiar la configuración del dispositivo
      // Configuración de localización
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      // Configuración de temas
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: _accentColor,
          secondary: _accentColor,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(color: Colors.white),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _accentColor,
            foregroundColor: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _accentColor, width: 2),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.dark(
          primary: _accentColor,
          secondary: _accentColor,
          surface: const Color(0xFF222222),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(color: Color(0xFF262626)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _accentColor,
            foregroundColor: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _accentColor, width: 2),
          ),
        ),
        dividerColor: Colors.white24,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _verificarSesion();
  }

  Future<void> _verificarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    final usuarioId = prefs.getInt('usuario_id');
    if (usuarioId != null) {
      final usuario = await ApiService.obtenerUsuarioPorId(usuarioId);
      if (usuario != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomeScreen(usuario: usuario, appState: Feed95App.of(context)),
          ),
        );
        return;
      }
    }
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PerfilesScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
```

## `frontend/lib/models/juego.dart`

```dart
class Juego {
  final int id;
  final String nombre;
  final String descripcion;
  final String imagen;
  final String? imagenLocal;
  final String imagenGrid;
  final String? imagenGridLocal;
  final String imagenesExtra;
  final String version;
  final int calificacion;
  final String generos;
  final String estado;
  final int usuarioId;
  final String? rutaEjecutable;
  final int catalogo; // 0 = principal, 1 = secundario
  final int? categoriaId;
  final int posicion;

  Juego({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagen,
    this.imagenLocal,
    required this.imagenGrid,
    this.imagenGridLocal,
    required this.imagenesExtra,
    required this.version,
    required this.calificacion,
    required this.generos,
    required this.estado,
    required this.usuarioId,
    this.rutaEjecutable,
    this.catalogo = 0,
    this.categoriaId,
    this.posicion = 0,
  });

  factory Juego.fromJson(Map<String, dynamic> json) {
    return Juego(
      id: int.parse(json['id'].toString()),
      nombre: json['nombre'],
      descripcion: json['descripcion'] ?? '',
      imagen: json['imagen'] ?? '',
      imagenLocal: json['imagen_local'],
      imagenGrid: json['imagen_grid'] ?? json['imagen'] ?? '',
      imagenGridLocal: json['imagen_grid_local'],
      imagenesExtra: json['imagenes_extra'] ?? '',
      version: json['version'] ?? '',
      calificacion: int.parse(json['calificacion'].toString()),
      generos: json['generos'] ?? '',
      estado: json['estado'] ?? '',
      usuarioId: int.parse(json['usuario_id'].toString()),
      rutaEjecutable: json['ruta_ejecutable'],
      catalogo: json['catalogo'] as int? ?? 0,
      categoriaId: json['categoria_id'] as int?,
      posicion: json['posicion'] as int? ?? 0,
    );
  }

  // Lista de URLs del carrusel
  List<String> get listaImagenesExtra => imagenesExtra
      .split(',')
      .map((u) => u.trim())
      .where((u) => u.isNotEmpty)
      .toList();
}
```

## `frontend/lib/models/usuario.dart`

```dart
import 'package:flutter/material.dart';

class Usuario {
  final int id;
  final String nombre;
  final Color color;
  final String? imagenPerfil;

  Usuario({
    required this.id,
    required this.nombre,
    required this.color,
    this.imagenPerfil,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: int.parse(json['id'].toString()),
      nombre: json['nombre'],
      color: Color(json['color'] as int? ?? 0xFF607D8B),
      imagenPerfil: json['imagen_perfil'] as String?,
    );
  }
}
```

## `frontend/lib/models/categoria.dart`

```dart
class Categoria {
  final int id;
  final String nombre;
  final String? imagen;
  final int usuarioId;
  final int catalogo;

  Categoria({
    required this.id,
    required this.nombre,
    this.imagen,
    required this.usuarioId,
    required this.catalogo,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: int.parse(json['id'].toString()),
      nombre: json['nombre'],
      imagen: json['imagen'] as String?,
      usuarioId: int.parse(json['usuario_id'].toString()),
      catalogo: json['catalogo'] as int? ?? 0,
    );
  }
}
```

## `frontend/lib/services/api_service.dart`

```dart
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
      version: 9,
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
    int catalogo = 0,
    int? categoriaId,
  }) async {
    final database = await db;
    final maxResult = await database.rawQuery(
      'SELECT MAX(posicion) as max FROM juegos WHERE usuario_id = ? AND catalogo = ?',
      [usuarioId, catalogo],
    );
    final maxPos = (maxResult.first['max'] as int?) ?? -1;

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
      'catalogo': catalogo,
      'categoria_id': categoriaId,
      'posicion': maxPos + 1,
    });
    return {'success': true, 'messageKey': ApiKeys.juegoAgregadoOk};
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
    int catalogo = 0,
    int? categoriaId,
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
        'catalogo': catalogo,
        'categoria_id': categoriaId,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
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
      'version': 1,
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
```

## `frontend/lib/services/steam_service.dart`

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class SteamResultado {
  final int appId;
  final String nombre;
  final String portada;

  SteamResultado({
    required this.appId,
    required this.nombre,
    required this.portada,
  });
}

class SteamDetalle {
  final String nombre;
  final String descripcion;
  final String portada;
  final String portadaGrid;
  final String generos;
  final String imagenesExtra;

  SteamDetalle({
    required this.nombre,
    required this.descripcion,
    required this.portada,
    required this.portadaGrid,
    required this.generos,
    required this.imagenesExtra,
  });
}

class SteamService {
  // Buscar juegos por nombre
  static Future<List<SteamResultado>> buscar(String query) async {
    try {
      final uri = Uri.parse(
        'https://store.steampowered.com/api/storesearch/?term=${Uri.encodeComponent(query)}&l=spanish&cc=US',
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final items = data['items'] as List? ?? [];

      return items.map((item) {
        final appId = item['id'] as int;
        return SteamResultado(
          appId: appId,
          nombre: item['name'] ?? '',
          portada:
              'https://cdn.akamai.steamstatic.com/steam/apps/$appId/library_600x900.jpg',
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  // Obtener detalles de un juego por appId
  static Future<SteamDetalle?> obtenerDetalle(int appId) async {
    try {
      final uri = Uri.parse(
        'https://store.steampowered.com/api/appdetails?appids=$appId&l=spanish',
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      final appData = data['$appId'];
      if (appData == null || appData['success'] != true) return null;

      final info = appData['data'];
      final generos = (info['genres'] as List? ?? [])
          .map((g) => g['description'] as String)
          .join(', ');

      // Limpiar HTML básico de la descripción
      final descripcionRaw = (info['short_description'] ?? '') as String;
      final descripcion = descripcionRaw
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .trim();

      // Portada horizontal (para detalle)
      final portada =
          'https://cdn.akamai.steamstatic.com/steam/apps/$appId/header.jpg';

      // Portada vertical (para grid)
      final portadaGrid =
          'https://cdn.akamai.steamstatic.com/steam/apps/$appId/library_600x900.jpg';

      // Screenshots del carrusel
      final screenshots = (info['screenshots'] as List? ?? [])
          .take(10)
          .map((s) => s['path_full'] as String? ?? '')
          .where((s) => s.isNotEmpty)
          .join(',');

      return SteamDetalle(
        nombre: info['name'] ?? '',
        descripcion: descripcion,
        portada: portada,
        portadaGrid: portadaGrid,
        generos: generos,
        imagenesExtra: screenshots,
      );
    } catch (_) {
      return null;
    }
  }
}
```

## `frontend/lib/services/epic_service.dart`

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class EpicResultado {
  final String id;
  final String namespace;
  final String nombre;
  final String portada;

  EpicResultado({
    required this.id,
    required this.namespace,
    required this.nombre,
    required this.portada,
  });
}

class EpicDetalle {
  final String nombre;
  final String descripcion;
  final String portada;
  final String portadaGrid;
  final String generos;
  final String imagenesExtra;

  EpicDetalle({
    required this.nombre,
    required this.descripcion,
    required this.portada,
    required this.portadaGrid,
    required this.generos,
    required this.imagenesExtra,
  });
}

class EpicService {
  static Future<List<EpicResultado>> buscar(String query) async {
    try {
      final queryLimpia = query.replaceAll('"', ''); // ← agrega esto
      final searchUri = Uri.parse('https://store.epicgames.com/graphql');
      final graphqlQuery =
          '''
    {
      Catalog {
        searchStore(
          keywords: "$queryLimpia"
          count: 10
          category: "games/edition/base"
        ) {
          elements {
            id
            namespace
            title
            keyImages {
              type
              url
            }
          }
        }
      }
    }
    ''';

      final response = await http
          .post(
            searchUri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'query': graphqlQuery}),
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      final elements =
          data['data']?['Catalog']?['searchStore']?['elements'] as List? ?? [];

      return elements
          .map((e) {
            final images = e['keyImages'] as List? ?? [];
            final portadaMap = images.firstWhere(
              (img) => img['type'] == 'OfferImageTall',
              orElse: () => images.isNotEmpty ? images.first : {},
            );
            return EpicResultado(
              id: e['id'] as String? ?? '',
              namespace: e['namespace'] as String? ?? '',
              nombre: e['title'] as String? ?? '',
              portada: portadaMap['url'] as String? ?? '',
            );
          })
          .where((r) => r.nombre.isNotEmpty)
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<EpicDetalle?> obtenerDetalle(
    String id,
    String namespace,
  ) async {
    try {
      final uri = Uri.parse('https://store.epicgames.com/graphql');

      final graphqlQuery =
          '''
    {
      Catalog {
        catalogOffer(
          namespace: "$namespace"
          id: "$id"
        ) {
          title
          description
          keyImages {
            type
            url
          }
          categories {
            path
          }
          tags {
            name
          }
          catalogNs {
            mappings(pageType: "productHome") {
              pageSlug
              pageType
            }
          }
        }
      }
    }
    ''';

      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'query': graphqlQuery}),
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      final offer = data['data']?['Catalog']?['catalogOffer'];
      if (offer == null) return null;
      final images = offer['keyImages'] as List? ?? [];
      final mappings = offer['catalogNs']?['mappings'] as List? ?? [];
      final tags = (offer['tags'] as List? ?? [])
          .map((t) => t['name'] as String? ?? '')
          .where((t) => t.isNotEmpty)
          .take(5)
          .join(', ');
      final descripcionRaw = offer['description'] as String? ?? '';
      final descripcion = descripcionRaw
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .trim();
      final portadaGrid =
          (images.firstWhere(
                (img) => img['type'] == 'OfferImageTall',
                orElse: () => images.isNotEmpty ? images.first : {},
              )['url']
              as String?) ??
          '';
      final portada =
          (images.firstWhere(
                (img) =>
                    img['type'] == 'OfferImageWide' ||
                    img['type'] == 'DieselGameBoxWide',
                orElse: () => images.isNotEmpty ? images.first : {},
              )['url']
              as String?) ??
          '';

      // Obtener screenshots desde el storefront usando el pageSlug
      String imagenesExtra = images
          .where((img) => img['type'] == 'featuredMedia')
          .take(10)
          .map((img) => img['url'] as String? ?? '')
          .where((u) => u.isNotEmpty)
          .join(',');

      try {
        final slug = mappings.isNotEmpty
            ? mappings.first['pageSlug'] as String? ?? ''
            : '';

        if (slug.isNotEmpty) {
          final screenshotUri = Uri.parse(
            'https://store-content.ak.epicgames.com/api/en-US/content/products/$slug',
          );

          final screenshotResponse = await http.get(screenshotUri);

          if (screenshotResponse.statusCode == 200) {
            final screenshotData = jsonDecode(screenshotResponse.body);

            final pages = screenshotData['pages'];

            if (pages is List && pages.isNotEmpty) {
              final firstPage = pages.first as Map<String, dynamic>;

              final pageData = firstPage['data'] as Map<String, dynamic>?;

              if (pageData != null && imagenesExtra.isEmpty) {
                final carousel = pageData['carousel'];

                if (carousel != null) {
                  final items = carousel['items'] as List? ?? [];

                  final urls = items
                      .map((item) => item['image']?['src'] as String? ?? '')
                      .where((url) => url.isNotEmpty)
                      .take(10)
                      .toList();

                  if (urls.isNotEmpty) {
                    imagenesExtra = urls.join(',');
                  }
                }
              }
            }
          }
        }
      } catch (e) {
        debugPrint('SLUG ERROR: $e');
      }

      return EpicDetalle(
        nombre: offer['title'] as String? ?? '',
        descripcion: descripcion,
        portada: portada,
        portadaGrid: portadaGrid,
        generos: tags,
        imagenesExtra: imagenesExtra,
      );
    } catch (_) {
      return null;
    }
  }
}
```

## `frontend/lib/services/igdb_service.dart`

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class IgdbResultado {
  final int id;
  final String nombre;
  final String portada;

  IgdbResultado({
    required this.id,
    required this.nombre,
    required this.portada,
  });
}

class IgdbDetalle {
  final String nombre;
  final String descripcion;
  final String portada;
  final String portadaGrid;
  final String generos;
  final String imagenesExtra;

  IgdbDetalle({
    required this.nombre,
    required this.descripcion,
    required this.portada,
    required this.portadaGrid,
    required this.generos,
    required this.imagenesExtra,
  });
}

class IgdbService {
  static const _prefClientId = 'igdb_client_id';
  static const _prefClientSecret = 'igdb_client_secret';
  static const _prefToken = 'igdb_token';
  static const _prefTokenExpiry = 'igdb_token_expiry';

  static Future<bool> tieneCredenciales() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString(_prefClientId)?.isNotEmpty ?? false) &&
        (prefs.getString(_prefClientSecret)?.isNotEmpty ?? false);
  }

  static Future<bool> verificarCredenciales({
    required String clientId,
    required String clientSecret,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://id.twitch.tv/oauth2/token'),
        body: {
          'client_id': clientId,
          'client_secret': clientSecret,
          'grant_type': 'client_credentials',
        },
      ).timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<void> guardarCredenciales({
    required String clientId,
    required String clientSecret,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefClientId, clientId);
    await prefs.setString(_prefClientSecret, clientSecret);
    await prefs.remove(_prefToken);
    await prefs.remove(_prefTokenExpiry);
  }

  static Future<void> limpiarCredenciales() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefClientId);
    await prefs.remove(_prefClientSecret);
    await prefs.remove(_prefToken);
    await prefs.remove(_prefTokenExpiry);
  }

  static Future<Map<String, String>?> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final clientId = prefs.getString(_prefClientId) ?? '';
    final clientSecret = prefs.getString(_prefClientSecret) ?? '';
    if (clientId.isEmpty || clientSecret.isEmpty) return null;

    // Usar token cacheado si sigue vigente
    final cachedToken = prefs.getString(_prefToken);
    final expiry = prefs.getInt(_prefTokenExpiry) ?? 0;
    if (cachedToken != null &&
        DateTime.now().millisecondsSinceEpoch < expiry) {
      return {
        'Client-ID': clientId,
        'Authorization': 'Bearer $cachedToken',
        'Content-Type': 'text/plain',
      };
    }

    // Obtener nuevo token
    try {
      final response = await http.post(
        Uri.parse('https://id.twitch.tv/oauth2/token'),
        body: {
          'client_id': clientId,
          'client_secret': clientSecret,
          'grant_type': 'client_credentials',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      final token = data['access_token'] as String?;
      final expiresIn = data['expires_in'] as int? ?? 3600;
      if (token == null) return null;

      await prefs.setString(_prefToken, token);
      await prefs.setInt(
        _prefTokenExpiry,
        DateTime.now().millisecondsSinceEpoch + (expiresIn - 300) * 1000,
      );

      return {
        'Client-ID': clientId,
        'Authorization': 'Bearer $token',
        'Content-Type': 'text/plain',
      };
    } catch (_) {
      return null;
    }
  }

  static Future<List<IgdbResultado>> buscar(String query) async {
    try {
      final headers = await _getHeaders();
      if (headers == null) return [];

      final queryLimpia = query.replaceAll('"', '');
      final response = await http.post(
        Uri.parse('https://api.igdb.com/v4/games'),
        headers: headers,
        body:
            'search "$queryLimpia"; fields name,cover.image_id; limit 10; where version_parent = null;',
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body) as List;
      return data.map((game) {
        final imageId = game['cover']?['image_id'] as String? ?? '';
        final portada = imageId.isNotEmpty
            ? 'https://images.igdb.com/igdb/image/upload/t_cover_big/$imageId.jpg'
            : '';
        return IgdbResultado(
          id: game['id'] as int,
          nombre: game['name'] as String? ?? '',
          portada: portada,
        );
      }).where((r) => r.nombre.isNotEmpty).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<IgdbDetalle?> obtenerDetalle(int id) async {
    try {
      final headers = await _getHeaders();
      if (headers == null) return null;

      final response = await http.post(
        Uri.parse('https://api.igdb.com/v4/games'),
        headers: headers,
        body:
            'fields name,summary,cover.image_id,genres.name,screenshots.image_id,artworks.image_id; where id = $id;',
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as List;
      if (data.isEmpty) return null;

      final game = data.first;
      final coverId = game['cover']?['image_id'] as String? ?? '';

      // Portada vertical para grid
      final portadaGrid = coverId.isNotEmpty
          ? 'https://images.igdb.com/igdb/image/upload/t_cover_big/$coverId.jpg'
          : '';

      // Portada horizontal para detalle — artwork si existe
      final artworks = game['artworks'] as List? ?? [];
      String portada = portadaGrid;
      if (artworks.isNotEmpty) {
        final artId = artworks.first['image_id'] as String? ?? '';
        if (artId.isNotEmpty) {
          portada =
              'https://images.igdb.com/igdb/image/upload/t_screenshot_huge/$artId.jpg';
        }
      }

      final generos = (game['genres'] as List? ?? [])
          .map((g) => g['name'] as String? ?? '')
          .where((g) => g.isNotEmpty)
          .join(', ');

      final imagenesExtra = (game['screenshots'] as List? ?? [])
          .take(8)
          .map((s) => s['image_id'] as String? ?? '')
          .where((imgId) => imgId.isNotEmpty)
          .map((imgId) =>
              'https://images.igdb.com/igdb/image/upload/t_screenshot_big/$imgId.jpg')
          .join(',');

      return IgdbDetalle(
        nombre: game['name'] as String? ?? '',
        descripcion: game['summary'] as String? ?? '',
        portada: portada,
        portadaGrid: portadaGrid,
        generos: generos,
        imagenesExtra: imagenesExtra,
      );
    } catch (_) {
      return null;
    }
  }
}
```

## `frontend/lib/services/f95_service.dart`

```dart
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
```

## `frontend/lib/screens/home_screen.dart`

```dart
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import '../main.dart';
import '../widgets/avatar_usuario.dart';
import 'juegos_screen.dart';
import 'perfiles_screen.dart';
import 'perfil_screen.dart';
import 'f95_config_screen.dart';
import 'igdb_config_screen.dart';
import 'package:frontend/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  final Usuario usuario;
  final Feed95AppState? appState;

  const HomeScreen({super.key, required this.usuario, this.appState});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Usuario usuario;
  int _tapContador = 0;
  bool _modosExtrasActivos = false;
  int _totalJuegos = 0;
  int _completados = 0;
  int _jugando = 0;

  @override
  void initState() {
    super.initState();
    usuario = widget.usuario;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.appState?.cambiarColor(usuario.color);
    });
    _cargarTodo();
  }

  Future<void> _cargarTodo() async {
    final prefs = await SharedPreferences.getInstance();
    final stats = await ApiService.obtenerEstadisticas(usuario.id);
    if (mounted) {
      setState(() {
        _modosExtrasActivos = prefs.getBool('f95_activado') ?? false;
        _totalJuegos = stats['total'] as int;
        _completados = stats['completados'] as int;
        _jugando = stats['jugando'] as int;
      });
    }
  }

  Future<void> _cambiarPerfil() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuario_id');
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PerfilesScreen()),
      );
    }
  }

  Future<void> _exportarBackup() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final json = await ApiService.exportarBackup();
      if (kIsWeb) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.homeBackupNoDisponibleWeb)));
        return;
      }
      final carpeta = await FilePicker.platform.getDirectoryPath(
        dialogTitle: l10n.homeGuardarBackupEn,
      );
      if (carpeta == null) return;
      final fecha = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .substring(0, 19);
      final archivo = File('$carpeta/feed95_backup_$fecha.json');
      await archivo.writeAsString(json);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.homeBackupGuardado(archivo.path))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.homeErrorExportar(e.toString()))),
      );
    }
  }

  Future<void> _importarBackup() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      if (kIsWeb) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.homeImportarNoDisponibleWeb)),
        );
        return;
      }
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        dialogTitle: l10n.homeDialogoImportarTitulo,
      );
      if (result == null || result.files.single.path == null) return;
      if (!mounted) return;
      final confirmar = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.homeDialogoImportarTitulo),
          content: Text(l10n.homeDialogoImportarContenido),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.btnCancelar),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.btnImportar),
            ),
          ],
        ),
      );
      if (confirmar != true) return;
      final archivo = File(result.files.single.path!);
      final contenido = await archivo.readAsString();
      final respuesta = await ApiService.importarBackup(contenido);
      if (!mounted) return;
      final String mensaje;
      if (respuesta['messageKey'] == 'apiBackupRestaurado') {
        mensaje = l10n.apiBackupRestaurado(
          respuesta['perfiles'] as int,
          respuesta['categorias'] as int,
          respuesta['juegos'] as int,
        );
      } else {
        mensaje = l10n.apiBackupArchivoInvalido;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mensaje)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.homeErrorImportar(e.toString()))),
      );
    }
  }

  void _mostrarBottomSheet() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.homeSeccionConfiguraciones,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _botonSheet(
                        icon: Icons.sports_esports,
                        label: l10n.homeConfigurarIGDB,
                        onTap: () {
                          Navigator.pop(ctx);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const IgdbConfigScreen(),
                            ),
                          );
                        },
                      ),
                      if (_modosExtrasActivos) ...[
                        const SizedBox(height: 8),
                        _botonSheet(
                          icon: Icons.settings,
                          label: l10n.homeConfigurarF95,
                          onTap: () {
                            Navigator.pop(ctx);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const F95ConfigScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.homeSeccionSistema,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _botonSheet(
                        icon: Icons.upload,
                        label: l10n.homeExportarCopia,
                        onTap: () {
                          Navigator.pop(ctx);
                          _exportarBackup();
                        },
                      ),
                      const SizedBox(height: 8),
                      _botonSheet(
                        icon: Icons.download,
                        label: l10n.homeImportarCopia,
                        onTap: () {
                          Navigator.pop(ctx);
                          _importarBackup();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _botonSheet({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF2A2A2A)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF333333)
                : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey.shade500),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String valor, String etiqueta) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          valor,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          etiqueta.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _separadorVertical() {
    return Container(
      width: 1,
      height: 32,
      color: Theme.of(context).dividerColor,
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _contenidoPrincipal(bool esAncho) {
    final l10n = AppLocalizations.of(context)!;

    final avatarWidget = GestureDetector(
      onTap: () async {
        _tapContador++;
        if (_tapContador >= 5) {
          _tapContador = 0;
          final prefs = await SharedPreferences.getInstance();
          final activado = prefs.getBool('f95_activado') ?? false;
          await prefs.setBool('f95_activado', !activado);
          if (!mounted) return;
          setState(() => _modosExtrasActivos = !activado);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                !activado
                    ? l10n.homeModoExtendidoActivado
                    : l10n.homeModoExtendidoDesactivado,
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: AvatarUsuario(usuario: usuario, size: 150),
    );

    final colAvatar = Column(
      children: [
        avatarWidget,
        const SizedBox(height: 10),
        TextButton.icon(
          icon: const Icon(Icons.edit, size: 14),
          label: Text(
            l10n.homeEditarPerfil,
            style: const TextStyle(fontSize: 13),
          ),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PerfilScreen(
                  usuario: usuario,
                  appState: widget.appState,
                  onActualizado: () async {
                    final actualizado = await ApiService.obtenerUsuarioPorId(
                      usuario.id,
                    );
                    if (actualizado != null && mounted) {
                      setState(() => usuario = actualizado);
                      widget.appState?.cambiarColor(actualizado.color);
                      _cargarTodo();
                    }
                  },
                ),
              ),
            );
          },
        ),
      ],
    );

    final colInfo = Column(
      crossAxisAlignment: esAncho
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Text(
          l10n.homeBienvenido(usuario.nombre),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: esAncho ? TextAlign.left : TextAlign.center,
        ),
        const SizedBox(height: 14),
        ElevatedButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JuegosScreen(usuario: usuario),
              ),
            );
            _cargarTodo();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.videogame_asset, size: 18),
              const SizedBox(width: 8),
              Text(
                l10n.homeMiCatalogo,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 16),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              mainAxisSize: esAncho ? MainAxisSize.min : MainAxisSize.max,
              mainAxisAlignment: esAncho
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                _statItem('$_totalJuegos', l10n.homeStatJuegos),
                _separadorVertical(),
                _statItem('$_completados', l10n.homeStatCompletados),
                _separadorVertical(),
                _statItem('$_jugando', l10n.homeStatJugando),
              ],
            ),
          ),
        ),
      ],
    );

    if (esAncho) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          colAvatar,
          const SizedBox(width: 32),
          Flexible(child: colInfo),
        ],
      );
    } else {
      return Column(children: [colAvatar, const SizedBox(height: 20), colInfo]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final esAncho = MediaQuery.of(context).size.width > 500;
    final appState = widget.appState;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.homeTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: l10n.homeTooltipCambiarTema,
            onPressed: () {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              appState?.cambiarTema(isDark ? ThemeMode.light : ThemeMode.dark);
            },
          ),
          IconButton(
            icon: const Icon(Icons.switch_account),
            tooltip: l10n.homeTooltipCambiarPerfil,
            onPressed: _cambiarPerfil,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.homeTooltipCerrarSesion,
            onPressed: _cambiarPerfil,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: _contenidoPrincipal(esAncho),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        child: SafeArea(
          child: InkWell(
            onTap: _mostrarBottomSheet,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.keyboard_arrow_up, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    l10n.homeConfiguraciones,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

## `frontend/lib/screens/juegos_screen.dart`

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/juego.dart';
import '../models/usuario.dart';
import '../models/categoria.dart';
import '../services/api_service.dart';
import 'juego_form_screen.dart';
import 'juego_detalle_screen.dart';
import 'package:frontend/l10n/app_localizations.dart';

class JuegosScreen extends StatefulWidget {
  final Usuario usuario;

  const JuegosScreen({super.key, required this.usuario});

  @override
  State<JuegosScreen> createState() => _JuegosScreenState();
}

class _JuegosScreenState extends State<JuegosScreen> {
  List<Juego> juegos = [];
  List<Categoria> categorias = [];
  bool cargando = true;
  bool panelAbierto = false;
  bool _modosExtrasActivos = false;
  int catalogoActual = 0;
  String busqueda = '';
  String? filtroEstado;
  int? filtroCategoria;
  bool _modoReorden = false;
  bool _reordenEnGrid = false;
  final TextEditingController _busquedaController = TextEditingController();

  String nombreCatalogoSecundario = 'NSFW';

  @override
  void initState() {
    super.initState();
    _cargarModosExtras();
    cargarTodo();
  }

  Future<void> _cargarModosExtras() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _modosExtrasActivos = prefs.getBool('f95_activado') ?? false;
      });
    }
  }

  Future<void> cargarTodo() async {
    setState(() => cargando = true);
    juegos = await ApiService.obtenerJuegos(
      widget.usuario.id,
      catalogo: catalogoActual,
    );
    categorias = await ApiService.obtenerCategorias(
      widget.usuario.id,
      catalogoActual,
    );
    setState(() => cargando = false);
  }

  List<Juego> get juegosFiltrados {
    return juegos.where((j) {
      final matchBusqueda =
          busqueda.isEmpty ||
          j.nombre.toLowerCase().contains(busqueda.toLowerCase());
      final matchEstado = filtroEstado == null || j.estado == filtroEstado;
      final matchCategoria =
          filtroCategoria == null || j.categoriaId == filtroCategoria;
      return matchBusqueda && matchEstado && matchCategoria;
    }).toList();
  }

  Future<void> _mostrarDialogoCategoria({Categoria? editar}) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: editar?.nombre ?? '');
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          editar == null
              ? l10n.categoriaNuevaTitulo
              : l10n.categoriaEditarTitulo,
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: l10n.categoriaNombreLabel),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.btnCancelar),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isEmpty) return;
              final navigator = Navigator.of(context);
              if (editar == null) {
                await ApiService.crearCategoria(
                  nombre: controller.text,
                  usuarioId: widget.usuario.id,
                  catalogo: catalogoActual,
                );
              } else {
                await ApiService.editarCategoria(
                  id: editar.id,
                  nombre: controller.text,
                );
              }
              if (!mounted) return;
              navigator.pop();
              cargarTodo();
            },
            child: Text(l10n.btnGuardar),
          ),
        ],
      ),
    );
  }

  Future<void> _eliminarCategoria(Categoria cat) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.categoriaEliminarTitulo),
        content: Text(l10n.categoriaEliminarContenido(cat.nombre)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.btnCancelar),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.btnEliminar,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (confirmar == true) {
      await ApiService.eliminarCategoria(cat.id);
      if (filtroCategoria == cat.id) {
        setState(() => filtroCategoria = null);
      }
      cargarTodo();
    }
  }

  Future<void> _moverJuegoAPosicion(
    List<Juego> lista,
    int juegoIndex,
    int nuevaPosicion1Based,
  ) async {
    final total = lista.length;
    final destino = nuevaPosicion1Based.clamp(1, total) - 1;
    if (destino == juegoIndex) return;
    final item = lista.removeAt(juegoIndex);
    lista.insert(destino, item);
    setState(() {});
    await ApiService.guardarOrden(juegos.map((j) => j.id).toList());
  }

  Future<void> _intercambiarEnGrid(int fromIndex, int toIndex) async {
    if (fromIndex == toIndex) return;
    setState(() {
      final item = juegos.removeAt(fromIndex);
      juegos.insert(toIndex, item);
    });
    await ApiService.guardarOrden(juegos.map((j) => j.id).toList());
  }

  Widget _panelLateral() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: 220,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _busquedaController,
              decoration: InputDecoration(
                hintText: l10n.catalogoBuscar,
                prefixIcon: const Icon(Icons.search, size: 18),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: busqueda.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: () {
                          _busquedaController.clear();
                          setState(() => busqueda = '');
                        },
                      )
                    : null,
              ),
              onChanged: (v) => setState(() => busqueda = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              l10n.catalogoSeccionEstado,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _itemFiltro(
            label: l10n.catalogoFiltroTodos,
            seleccionado: filtroEstado == null,
            onTap: () => setState(() => filtroEstado = null),
          ),
          for (final entry in {
            'Pending': l10n.estadoPendiente,
            'Playing': l10n.estadoJugando,
            'Completed': l10n.estadoCompletado,
            'Abandoned': l10n.estadoAbandonado,
          }.entries)
            _itemFiltro(
              label: entry.value,
              seleccionado: filtroEstado == entry.key,
              onTap: () => setState(
                () =>
                    filtroEstado = filtroEstado == entry.key ? null : entry.key,
              ),
            ),
          const Divider(indent: 12, endIndent: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.catalogoSeccionCategorias,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 16),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => _mostrarDialogoCategoria(),
                ),
              ],
            ),
          ),
          _itemFiltro(
            label: l10n.catalogoFiltroTodas,
            seleccionado: filtroCategoria == null,
            onTap: () => setState(() => filtroCategoria = null),
          ),
          Expanded(
            child: ListView(
              children: categorias.map((cat) => _itemCategoria(cat)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemFiltro({
    required String label,
    required bool seleccionado,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: seleccionado
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
            : null,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: seleccionado ? FontWeight.bold : FontWeight.normal,
            color: seleccionado ? Theme.of(context).colorScheme.primary : null,
          ),
        ),
      ),
    );
  }

  Widget _itemCategoria(Categoria cat) {
    final seleccionada = filtroCategoria == cat.id;
    return InkWell(
      onTap: () =>
          setState(() => filtroCategoria = seleccionada ? null : cat.id),
      onLongPress: () => _mostrarMenuCategoria(cat),
      onSecondaryTap: () => _mostrarMenuCategoria(cat),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: seleccionada
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
            : null,
        child: Row(
          children: [
            if (cat.imagen != null && cat.imagen!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    cat.imagen!,
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        const Icon(Icons.folder, size: 16),
                  ),
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.folder, size: 16),
              ),
            Expanded(
              child: Text(
                cat.nombre,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: seleccionada
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: seleccionada
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vistaGrid(List<Juego> lista) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: lista.length,
      itemBuilder: (context, index) {
        final juego = lista[index];
        return _TarjetaJuego(
          juego: juego,
          categorias: categorias,
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    JuegoDetalleScreen(juego: juego, usuario: widget.usuario),
              ),
            );
            cargarTodo();
          },
          onAsignarCategoria: (catId) async {
            await ApiService.asignarCategoria(juego.id, catId);
            cargarTodo();
          },
        );
      },
    );
  }

  Widget _vistaReordenLista(List<Juego> lista) {
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: lista.length,
      onReorder: (oldIndex, newIndex) async {
        if (newIndex > oldIndex) newIndex--;
        setState(() {
          final item = lista.removeAt(oldIndex);
          lista.insert(newIndex, item);
        });
        await ApiService.guardarOrden(juegos.map((j) => j.id).toList());
      },
      itemBuilder: (context, index) {
        final juego = lista[index];
        return Container(
          key: ValueKey(juego.id),
          child: ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _InputPosicion(
                  posicionActual: index + 1,
                  total: lista.length,
                  onConfirmar: (nuevaPos) =>
                      _moverJuegoAPosicion(lista, index, nuevaPos),
                ),
                const SizedBox(width: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: juego.imagenGrid.isNotEmpty
                      ? Image.network(
                          juego.imagenGrid,
                          width: 40,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              const Icon(Icons.videogame_asset),
                        )
                      : const Icon(Icons.videogame_asset),
                ),
              ],
            ),
            title: Text(juego.nombre),
            subtitle: Text(
              '${traducirEstadoJuego(juego.estado, context)}${juego.version.isNotEmpty ? ' · v${juego.version}' : ''}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (juego.calificacion > 0)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          '${juego.calificacion}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ReorderableDragStartListener(
                  index: index,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.grab,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(Icons.drag_handle, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      JuegoDetalleScreen(juego: juego, usuario: widget.usuario),
                ),
              );
              cargarTodo();
            },
          ),
        );
      },
    );
  }

  Widget _vistaReordenGrid(List<Juego> lista) {
    return _ReordenGrid(
      juegos: lista,
      onReorder: _intercambiarEnGrid,
      onMoverAPosicion: (index, nuevaPos) =>
          _moverJuegoAPosicion(lista, index, nuevaPos),
      onTapJuego: (juego) async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                JuegoDetalleScreen(juego: juego, usuario: widget.usuario),
          ),
        );
        cargarTodo();
      },
    );
  }

  void _mostrarMenuCategoria(Categoria cat) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text(l10n.btnEditar),
            onTap: () {
              Navigator.pop(context);
              _mostrarDialogoCategoria(editar: cat);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: Text(
              l10n.btnEliminar,
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              _eliminarCategoria(cat);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final juegosMostrados = _modoReorden ? juegos : juegosFiltrados;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          catalogoActual == 0 ? l10n.catalogoTitulo : nombreCatalogoSecundario,
        ),
        actions: [
          if (_modoReorden) ...[
            IconButton(
              icon: Icon(_reordenEnGrid ? Icons.view_list : Icons.grid_view),
              tooltip: _reordenEnGrid
                  ? l10n.catalogoTooltipVistaLista
                  : l10n.catalogoTooltipVistaGrid,
              onPressed: () => setState(() => _reordenEnGrid = !_reordenEnGrid),
            ),
          ] else ...[
            IconButton(
              icon: Icon(panelAbierto ? Icons.menu_open : Icons.menu),
              tooltip: l10n.catalogoTooltipFiltros,
              onPressed: () => setState(() => panelAbierto = !panelAbierto),
            ),
          ],
          IconButton(
            icon: Icon(
              _modoReorden ? Icons.dashboard_customize_sharp : Icons.swap_vert,
            ),
            tooltip: _modoReorden
                ? l10n.catalogoTooltipVerCatalogo
                : l10n.catalogoTooltipReordenar,
            onPressed: () => setState(() => _modoReorden = !_modoReorden),
          ),
          if (_modosExtrasActivos)
            IconButton(
              icon: Icon(
                catalogoActual == 0 ? Icons.lock_open : Icons.lock,
                color: catalogoActual == 1
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              tooltip: catalogoActual == 0
                  ? l10n.catalogoTooltipCatalogoSecundario(
                      nombreCatalogoSecundario,
                    )
                  : l10n.catalogoTooltipCatalogoPrincipal,
              onPressed: () {
                setState(() {
                  catalogoActual = catalogoActual == 0 ? 1 : 0;
                  filtroCategoria = null;
                  filtroEstado = null;
                  busqueda = '';
                  _busquedaController.clear();
                });
                cargarTodo();
              },
            ),
        ],
      ),
      floatingActionButton: _modoReorden
          ? null
          : FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JuegoFormScreen(
                      usuario: widget.usuario,
                      catalogoInicial: catalogoActual,
                    ),
                  ),
                );
                cargarTodo();
              },
              child: const Icon(Icons.add),
            ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                if (!_modoReorden)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: panelAbierto ? 220 : 0,
                    child: panelAbierto
                        ? ClipRect(child: _panelLateral())
                        : const SizedBox.shrink(),
                  ),
                Expanded(
                  child: juegosMostrados.isEmpty
                      ? Center(
                          child: Text(
                            _modoReorden
                                ? l10n.catalogoReordenarVacio
                                : (busqueda.isNotEmpty ||
                                          filtroEstado != null ||
                                          filtroCategoria != null
                                      ? l10n.catalogoVacioFiltros
                                      : l10n.catalogoVacio),
                          ),
                        )
                      : _modoReorden
                      ? (_reordenEnGrid
                            ? _vistaReordenGrid(juegosMostrados)
                            : _vistaReordenLista(juegosMostrados))
                      : _vistaGrid(juegosMostrados),
                ),
              ],
            ),
    );
  }
}

// ── Grid con drag & drop nativo ──────────────────────────────────────────────

class _ReordenGrid extends StatefulWidget {
  final List<Juego> juegos;
  final Future<void> Function(int from, int to) onReorder;
  final void Function(int index, int nuevaPos) onMoverAPosicion;
  final void Function(Juego juego) onTapJuego;

  const _ReordenGrid({
    required this.juegos,
    required this.onReorder,
    required this.onMoverAPosicion,
    required this.onTapJuego,
  });

  @override
  State<_ReordenGrid> createState() => _ReordenGridState();
}

class _ReordenGridState extends State<_ReordenGrid> {
  int? _draggingIndex;
  int? _hoverIndex;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.68,
      ),
      itemCount: widget.juegos.length,
      itemBuilder: (context, index) {
        final juego = widget.juegos[index];
        final isDragging = _draggingIndex == index;
        final isHover = _hoverIndex == index && _draggingIndex != index;

        return DragTarget<int>(
          onWillAcceptWithDetails: (details) {
            if (details.data != index) {
              setState(() => _hoverIndex = index);
            }
            return details.data != index;
          },
          onLeave: (_) => setState(() => _hoverIndex = null),
          onAcceptWithDetails: (details) {
            setState(() => _hoverIndex = null);
            widget.onReorder(details.data, index);
          },
          builder: (context, candidateData, rejectedData) {
            return LongPressDraggable<int>(
              data: index,
              delay: const Duration(milliseconds: 300),
              onDragStarted: () => setState(() => _draggingIndex = index),
              onDragEnd: (_) => setState(() => _draggingIndex = null),
              onDraggableCanceled: (_, _) =>
                  setState(() => _draggingIndex = null),
              feedback: SizedBox(
                width: 120,
                height: 120 / 0.68,
                child: Opacity(
                  opacity: 0.85,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _ImagenJuego(juego: juego),
                  ),
                ),
              ),
              childWhenDragging: AnimatedOpacity(
                opacity: 0.25,
                duration: const Duration(milliseconds: 150),
                child: _TarjetaReordenGrid(
                  juego: juego,
                  posicion: index + 1,
                  total: widget.juegos.length,
                  onTap: () {},
                  onMover: (_) {},
                  mostrarInput: false,
                ),
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: isHover
                      ? Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2.5,
                        )
                      : null,
                  boxShadow: isHover
                      ? [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isHover ? 8 : 10),
                  child: isDragging
                      ? _TarjetaReordenGrid(
                          juego: juego,
                          posicion: index + 1,
                          total: widget.juegos.length,
                          onTap: () {},
                          onMover: (_) {},
                          mostrarInput: false,
                        )
                      : _TarjetaReordenGrid(
                          juego: juego,
                          posicion: index + 1,
                          total: widget.juegos.length,
                          onTap: () => widget.onTapJuego(juego),
                          onMover: (nuevaPos) =>
                              widget.onMoverAPosicion(index, nuevaPos),
                        ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ── Input de posición ────────────────────────────────────────────────────────

class _InputPosicion extends StatefulWidget {
  final int posicionActual;
  final int total;
  final void Function(int nuevaPos) onConfirmar;
  final bool esGrid;
  final bool fondoOscuro;

  const _InputPosicion({
    required this.posicionActual,
    required this.total,
    required this.onConfirmar,
    this.esGrid = false,
    this.fondoOscuro = false,
  });

  @override
  State<_InputPosicion> createState() => _InputPosicionState();
}

class _InputPosicionState extends State<_InputPosicion> {
  late TextEditingController _ctrl;
  late FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: '${widget.posicionActual}');
    _focus = FocusNode();
    _focus.addListener(() {
      if (_focus.hasFocus) {
        _ctrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _ctrl.text.length,
        );
      }
    });
  }

  @override
  void didUpdateWidget(_InputPosicion old) {
    super.didUpdateWidget(old);
    if (!_focus.hasFocus && old.posicionActual != widget.posicionActual) {
      _ctrl.text = '${widget.posicionActual}';
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _confirmar() {
    final valor = int.tryParse(_ctrl.text);
    if (valor != null) {
      widget.onConfirmar(valor);
    } else {
      _ctrl.text = '${widget.posicionActual}';
    }
    _focus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final ancho = widget.esGrid ? 36.0 : 42.0;
    final alto = widget.esGrid ? 26.0 : 32.0;
    final fontSize = widget.esGrid ? 11.0 : 13.0;

    final fillColor = widget.fondoOscuro
        ? Colors.black.withValues(alpha: 0.72)
        : primary.withValues(alpha: 0.08);
    final textColor = widget.fondoOscuro ? Colors.white : primary;
    final borderColor = widget.fondoOscuro
        ? Colors.white.withValues(alpha: 0.45)
        : primary.withValues(alpha: 0.4);
    final borderColorFocus = widget.fondoOscuro ? Colors.white : primary;

    return SizedBox(
      width: ancho,
      height: alto,
      child: TextField(
        controller: _ctrl,
        focusNode: _focus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 2,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: borderColorFocus, width: 2),
          ),
          filled: true,
          fillColor: fillColor,
        ),
        onSubmitted: (_) => _confirmar(),
        onTapOutside: (_) {
          if (_focus.hasFocus) _confirmar();
        },
      ),
    );
  }
}

// ── Tarjeta en modo reordenamiento grid ─────────────────────────────────────

class _TarjetaReordenGrid extends StatelessWidget {
  final Juego juego;
  final int posicion;
  final int total;
  final VoidCallback onTap;
  final void Function(int nuevaPos) onMover;
  final bool mostrarInput;

  const _TarjetaReordenGrid({
    required this.juego,
    required this.posicion,
    required this.total,
    required this.onTap,
    required this.onMover,
    this.mostrarInput = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _ImagenJuego(juego: juego),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.82),
                  ],
                  stops: const [0.42, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            left: 6,
            right: 6,
            bottom: 6,
            child: Text(
              juego.nombre,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11,
                shadows: [Shadow(blurRadius: 4, color: Colors.black)],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (mostrarInput)
            Positioned(
              top: 6,
              left: 6,
              child: _InputPosicion(
                posicionActual: posicion,
                total: total,
                onConfirmar: onMover,
                esGrid: true,
                fondoOscuro: true,
              ),
            ),
        ],
      ),
    );
  }
}

// ── Widget imagen reutilizable ───────────────────────────────────────────────

class _ImagenJuego extends StatelessWidget {
  final Juego juego;

  const _ImagenJuego({required this.juego});

  @override
  Widget build(BuildContext context) {
    if (juego.imagenGridLocal != null && juego.imagenGridLocal!.isNotEmpty) {
      return Image.file(
        File(juego.imagenGridLocal!),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    if (juego.imagenGrid.isNotEmpty) {
      return Image.network(
        juego.imagenGrid,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    if (juego.imagenLocal != null && juego.imagenLocal!.isNotEmpty) {
      return Image.file(
        File(juego.imagenLocal!),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    if (juego.imagen.isNotEmpty) {
      return Image.network(
        juego.imagen,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey.shade800,
      child: const Center(
        child: Icon(Icons.videogame_asset, size: 32, color: Colors.white38),
      ),
    );
  }
}

// ── Tarjeta de juego en vista grid ─────────────────────────────────────────
class _TarjetaJuego extends StatelessWidget {
  final Juego juego;
  final List<Categoria> categorias;
  final VoidCallback onTap;
  final Function(int?) onAsignarCategoria;

  const _TarjetaJuego({
    required this.juego,
    required this.categorias,
    required this.onTap,
    required this.onAsignarCategoria,
  });

  void _mostrarMenuContextual(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              juego.nombre,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.folder),
            title: Text(l10n.catalogoAsignarCategoria),
            onTap: () {
              Navigator.pop(ctx);
              _mostrarSelectorCategoria(context);
            },
          ),
        ],
      ),
    );
  }

  void _mostrarSelectorCategoria(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.catalogoAsignarCategoria),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: const Icon(Icons.clear),
                title: Text(l10n.catalogoSinCategoria),
                onTap: () {
                  Navigator.pop(ctx);
                  onAsignarCategoria(null);
                },
              ),
              ...categorias.map(
                (cat) => ListTile(
                  leading: const Icon(Icons.folder),
                  title: Text(cat.nombre),
                  selected: juego.categoriaId == cat.id,
                  onTap: () {
                    Navigator.pop(ctx);
                    onAsignarCategoria(cat.id);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorEstado = _colorEstado(juego.estado, context);

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _mostrarMenuContextual(context),
      onSecondaryTap: () => _mostrarMenuContextual(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _ImagenJuego(juego: juego),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.75),
                    ],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Text(
                juego.nombre,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (juego.calificacion > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        '${juego.calificacion}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: colorEstado.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  traducirEstadoJuego(juego.estado, context),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _colorEstado(String estado, BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    switch (estado) {
      case 'Playing':
        return primary;
      case 'Completed':
        return primary.withValues(alpha: 0.75);
      case 'Abandoned':
        return Colors.grey.shade700;
      default:
        return Colors.grey.shade500;
    }
  }
}

String traducirEstadoJuego(String estado, BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  switch (estado) {
    case 'Playing':
      return l10n.estadoJugando;
    case 'Completed':
      return l10n.estadoCompletado;
    case 'Abandoned':
      return l10n.estadoAbandonado;
    default:
      return l10n.estadoPendiente;
  }
}
```

## `frontend/lib/screens/juego_detalle_screen.dart`

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/juego.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import 'juego_form_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:frontend/l10n/app_localizations.dart';

class JuegoDetalleScreen extends StatefulWidget {
  final Juego juego;
  final Usuario usuario;

  const JuegoDetalleScreen({
    super.key,
    required this.juego,
    required this.usuario,
  });

  @override
  State<JuegoDetalleScreen> createState() => _JuegoDetalleScreenState();
}

class _JuegoDetalleScreenState extends State<JuegoDetalleScreen> {
  late Juego juego;

  @override
  void initState() {
    super.initState();
    juego = widget.juego;
  }

  Color _colorEstado(String estado) {
    final primary = Theme.of(context).colorScheme.primary;
    switch (estado) {
      case 'Playing':
        return primary;
      case 'Completed':
        return primary.withValues(alpha: 0.75);
      case 'Abandoned':
        return Colors.grey.shade700;
      default:
        return Colors.grey.shade500;
    }
  }

  String _traducirEstado(String estado, AppLocalizations l10n) {
    switch (estado) {
      case 'Playing':
        return l10n.estadoJugando;
      case 'Completed':
        return l10n.estadoCompletado;
      case 'Abandoned':
        return l10n.estadoAbandonado;
      default:
        return l10n.estadoPendiente;
    }
  }

  Future<void> _eliminar() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.juegoDetalleEliminarTitulo),
        content: Text(l10n.juegoDetalleEliminarContenido(juego.nombre)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.btnCancelar),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.btnEliminar,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await ApiService.eliminarJuego(juego.id);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  Future<void> _ejecutar() async {
    final l10n = AppLocalizations.of(context)!;
    if (juego.rutaEjecutable == null || juego.rutaEjecutable!.isEmpty) return;
    try {
      await Process.run(juego.rutaEjecutable!, [], runInShell: true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.juegoDetalleErrorEjecutable(e.toString()))),
      );
    }
  }

  Widget _imagen() {
    if (juego.imagenLocal != null && juego.imagenLocal!.isNotEmpty) {
      return Image.file(
        File(juego.imagenLocal!),
        width: double.infinity,
        height: 280,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    if (juego.imagen.isNotEmpty) {
      return Image.network(
        juego.imagen,
        width: double.infinity,
        height: 280,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: 280,
      color: Colors.grey.shade800,
      child: const Center(
        child: Icon(Icons.videogame_asset, size: 64, color: Colors.white38),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final generos = juego.generos
        .split(',')
        .map((g) => g.trim())
        .where((g) => g.isNotEmpty)
        .toList();

    final tieneEjecutable =
        !kIsWeb &&
        (Platform.isWindows || Platform.isLinux) &&
        juego.rutaEjecutable != null &&
        juego.rutaEjecutable!.isNotEmpty;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: l10n.juegoDetalleTooltipEditar,
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JuegoFormScreen(
                        usuario: widget.usuario,
                        juego: juego,
                      ),
                    ),
                  );
                  final juegos = await ApiService.obtenerJuegos(
                    widget.usuario.id,
                  );
                  final actualizado = juegos
                      .where((j) => j.id == juego.id)
                      .toList();
                  if (actualizado.isNotEmpty && mounted) {
                    setState(() => juego = actualizado.first);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: l10n.juegoDetalleTooltipEliminar,
                onPressed: _eliminar,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _imagen(),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          juego.nombre,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (tieneEjecutable) ...[
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.play_arrow, size: 18),
                          label: Text(l10n.juegoDetalleJugar),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              255,
                              54,
                              71,
                            ),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                          onPressed: _ejecutar,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (juego.version.isNotEmpty)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.tag, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              juego.version,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      if (juego.calificacion > 0)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${juego.calificacion}/10',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _colorEstado(juego.estado),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _traducirEstado(juego.estado, l10n),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (generos.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: generos.map((g) {
                        return Chip(
                          label: Text(g, style: const TextStyle(fontSize: 12)),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 0,
                          ),
                          visualDensity: VisualDensity.compact,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (juego.descripcion.isNotEmpty) ...[
                    Text(
                      l10n.juegoDetalleDescripcion,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      juego.descripcion,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ],

                  if (juego.listaImagenesExtra.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      l10n.juegoDetalleImagenes,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 180,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          dragDevices: {
                            PointerDeviceKind.touch,
                            PointerDeviceKind.mouse,
                            PointerDeviceKind.trackpad,
                          },
                        ),
                        child: Scrollbar(
                          thumbVisibility: false,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: juego.listaImagenesExtra.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final url = juego.listaImagenesExtra[index];
                              return GestureDetector(
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: InteractiveViewer(
                                        child: Image.network(
                                          url,
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, _, _) =>
                                              const SizedBox(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    url,
                                    height: 180,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => const SizedBox(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

## `frontend/lib/screens/juego_form_screen.dart`

```dart
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/juego.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import '../services/epic_service.dart';
import '../services/steam_service.dart';
import '../services/f95_service.dart';
import 'f95_config_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/igdb_service.dart';
import 'igdb_config_screen.dart';
import 'package:frontend/l10n/app_localizations.dart';

class JuegoFormScreen extends StatefulWidget {
  final Usuario usuario;
  final Juego? juego;
  final int catalogoInicial;

  const JuegoFormScreen({
    super.key,
    required this.usuario,
    this.juego,
    this.catalogoInicial = 0,
  });

  @override
  State<JuegoFormScreen> createState() => _JuegoFormScreenState();
}

class _JuegoFormScreenState extends State<JuegoFormScreen> {
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final versionController = TextEditingController();
  final calificacionController = TextEditingController();
  final generosController = TextEditingController();
  final rutaEjecutableController = TextEditingController();
  final imagenDetalleController = TextEditingController();
  final imagenGridController = TextEditingController();
  String? _imagenDetalleLocal;
  String? _imagenGridLocal;
  String _imagenesExtra = '';
  String estadoSeleccionado = 'Pending';
  bool cargando = false;
  bool _buscandoSteam = false;
  bool _buscandoEpic = false;
  bool _buscandoF95 = false;
  bool _f95Activado = false;
  bool _buscandoIgdb = false;
  bool _igdbConfigurado = false;

  bool get _mostrarEjecutable =>
      !kIsWeb && (Platform.isWindows || Platform.isLinux);

  @override
  void initState() {
    super.initState();
    _cargarF95();
    _cargarIgdb();
    if (widget.juego != null) {
      nombreController.text = widget.juego!.nombre;
      descripcionController.text = widget.juego!.descripcion;
      versionController.text = widget.juego!.version;
      calificacionController.text = widget.juego!.calificacion.toString();
      generosController.text = widget.juego!.generos;
      estadoSeleccionado = widget.juego!.estado;
      imagenDetalleController.text = widget.juego!.imagen;
      imagenGridController.text = widget.juego!.imagenGrid;
      _imagenDetalleLocal = widget.juego!.imagenLocal;
      _imagenGridLocal = widget.juego!.imagenGridLocal;
      _imagenesExtra = widget.juego!.imagenesExtra;
      rutaEjecutableController.text = widget.juego!.rutaEjecutable ?? '';
    }
  }

  // ── Helpers ──────────────────────────────────────────────

  Widget _botonFuente({
    required String label,
    required bool cargando,
    required VoidCallback onTap,
  }) {
    return cargando
        ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : ActionChip(
            label: Text(label, style: const TextStyle(fontSize: 12)),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            onPressed: onTap,
          );
  }

  Widget _vistaPrevia(String url, String? local) {
    if (local != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(local),
          height: 120,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }
    if (url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          url,
          height: 120,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const SizedBox(),
        ),
      );
    }
    return const SizedBox();
  }

  Future<void> _mostrarResultados<T>({
    required String titulo,
    required List<T> resultados,
    required String Function(T) nombre,
    required String Function(T) portada,
    required Future<void> Function(T) onSeleccionar,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: resultados.length,
            itemBuilder: (context, index) {
              final r = resultados[index];
              final url = portada(r);
              return ListTile(
                leading: url.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          url,
                          width: 40,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              const Icon(Icons.videogame_asset),
                        ),
                      )
                    : const Icon(Icons.videogame_asset),
                title: Text(nombre(r), style: const TextStyle(fontSize: 14)),
                onTap: () async {
                  Navigator.pop(context);
                  await onSeleccionar(r);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.btnCancelar),
          ),
        ],
      ),
    );
  }

  void _rellenarCampos({
    required String nombre,
    required String descripcion,
    required String portada,
    required String portadaGrid,
    required String generos,
    String imagenesExtra = '',
  }) {
    setState(() {
      nombreController.text = nombre;
      descripcionController.text = descripcion;
      imagenDetalleController.text = portada;
      imagenGridController.text = portadaGrid;
      generosController.text = generos;
      _imagenDetalleLocal = null;
      _imagenGridLocal = null;
      _imagenesExtra = imagenesExtra;
    });
  }

  // ── Steam ─────────────────────────────────────────────────

  Future<void> _buscarEnSteam() async {
    final l10n = AppLocalizations.of(context)!;
    final query = nombreController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.juegoFormNoBusqueda)));
      return;
    }
    setState(() => _buscandoSteam = true);
    final resultados = await SteamService.buscar(query);
    setState(() => _buscandoSteam = false);
    if (!mounted) return;
    if (resultados.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.juegoFormSinResultadosSteam)));
      return;
    }
    await _mostrarResultados(
      titulo: l10n.juegoFormResultadosSteam,
      resultados: resultados,
      nombre: (r) => r.nombre,
      portada: (r) => r.portada,
      onSeleccionar: (r) async {
        setState(() => cargando = true);
        final detalle = await SteamService.obtenerDetalle(r.appId);
        setState(() => cargando = false);
        if (!mounted) return;
        if (detalle == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.juegoFormErrorDetalles)));
          return;
        }
        _rellenarCampos(
          nombre: detalle.nombre,
          descripcion: detalle.descripcion,
          portada: detalle.portada,
          portadaGrid: detalle.portadaGrid,
          generos: detalle.generos,
          imagenesExtra: detalle.imagenesExtra,
        );
      },
    );
  }

  // ── Epic ──────────────────────────────────────────────────

  Future<void> _buscarEnEpic() async {
    final l10n = AppLocalizations.of(context)!;
    final query = nombreController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.juegoFormNoBusqueda)));
      return;
    }
    setState(() => _buscandoEpic = true);
    final resultados = await EpicService.buscar(query);
    setState(() => _buscandoEpic = false);
    if (!mounted) return;
    if (resultados.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.juegoFormSinResultadosEpic)));
      return;
    }
    await _mostrarResultados(
      titulo: l10n.juegoFormResultadosEpic,
      resultados: resultados,
      nombre: (r) => r.nombre,
      portada: (r) => r.portada,
      onSeleccionar: (r) async {
        setState(() => cargando = true);
        final detalle = await EpicService.obtenerDetalle(r.id, r.namespace);
        setState(() => cargando = false);
        if (!mounted) return;
        if (detalle == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.juegoFormErrorDetalles)));
          return;
        }
        _rellenarCampos(
          nombre: detalle.nombre,
          descripcion: detalle.descripcion,
          portada: detalle.portada,
          portadaGrid: detalle.portadaGrid,
          generos: detalle.generos,
          imagenesExtra: detalle.imagenesExtra,
        );
      },
    );
  }

  // ── F95 ──────────────────────────────────────────────────

  Future<void> _cargarF95() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() => _f95Activado = prefs.getBool('f95_activado') ?? false);
    }
  }

  Future<void> _buscarEnF95() async {
    final l10n = AppLocalizations.of(context)!;
    final query = nombreController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.juegoFormNoBusqueda)));
      return;
    }

    final tiene = await F95Service.tieneSesion();
    if (!mounted) return;

    if (!tiene) {
      final confirmar = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.f95Titulo),
          content: Text(l10n.f95NecesitaSesion),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.btnCancelar),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.btnConfigurar),
            ),
          ],
        ),
      );
      if (confirmar == true && mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const F95ConfigScreen()),
        );
      }
      return;
    }

    setState(() => _buscandoF95 = true);
    final resultados = await F95Service.buscar(query);
    setState(() => _buscandoF95 = false);
    if (!mounted) return;

    if (resultados.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.juegoFormSinResultadosF95)));
      return;
    }

    await _mostrarResultados(
      titulo: l10n.juegoFormResultadosF95,
      resultados: resultados,
      nombre: (r) => r.nombre,
      portada: (r) => r.portada,
      onSeleccionar: (r) async {
        setState(() => cargando = true);
        final detalle = await F95Service.obtenerDetalle(r.url);
        setState(() => cargando = false);
        if (!mounted) return;
        if (detalle == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.juegoFormErrorDetalles)));
          return;
        }
        _rellenarCampos(
          nombre: detalle.nombre,
          descripcion: detalle.descripcion,
          portada: detalle.portada,
          portadaGrid: r.portada.isNotEmpty ? r.portada : detalle.portada,
          generos: detalle.generos,
          imagenesExtra: detalle.imagenesExtra,
        );
      },
    );
  }

  // ── IGDB ─────────────────────────────────────────────────

  Future<void> _cargarIgdb() async {
    final tiene = await IgdbService.tieneCredenciales();
    if (mounted) {
      setState(() => _igdbConfigurado = tiene);
    }
  }

  Future<void> _buscarEnIgdb() async {
    final l10n = AppLocalizations.of(context)!;
    final query = nombreController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.juegoFormNoBusqueda)));
      return;
    }

    if (!_igdbConfigurado) {
      final navigator = Navigator.of(context);
      final configurar = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.igdbTitulo),
          content: Text(l10n.igdbNecesitaConfiguracion),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.btnCancelar),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.btnConfigurar),
            ),
          ],
        ),
      );
      if (configurar == true) {
        await navigator.push(
          MaterialPageRoute(builder: (context) => const IgdbConfigScreen()),
        );
        _cargarIgdb();
      }
      return;
    }

    setState(() => _buscandoIgdb = true);
    final resultados = await IgdbService.buscar(query);
    setState(() => _buscandoIgdb = false);
    if (!mounted) return;

    if (resultados.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.juegoFormSinResultadosIgdb)));
      return;
    }

    await _mostrarResultados(
      titulo: l10n.juegoFormResultadosIgdb,
      resultados: resultados,
      nombre: (r) => r.nombre,
      portada: (r) => r.portada,
      onSeleccionar: (r) async {
        setState(() => cargando = true);
        final detalle = await IgdbService.obtenerDetalle(r.id);
        setState(() => cargando = false);
        if (!mounted) return;
        if (detalle == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.juegoFormErrorDetalles)));
          return;
        }
        _rellenarCampos(
          nombre: detalle.nombre,
          descripcion: detalle.descripcion,
          portada: detalle.portada,
          portadaGrid: detalle.portadaGrid,
          generos: detalle.generos,
          imagenesExtra: detalle.imagenesExtra,
        );
      },
    );
  }

  // ── Imagen ────────────────────────────────────────────────

  Future<void> _elegirImagen({required bool esGrid}) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (esGrid) {
          _imagenGridLocal = picked.path;
          imagenGridController.clear();
        } else {
          _imagenDetalleLocal = picked.path;
          imagenDetalleController.clear();
        }
      });
    }
  }

  Future<void> _elegirEjecutable() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['exe', 'bat', 'sh', 'app'],
      dialogTitle: l10n.juegoFormBuscarArchivo,
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        rutaEjecutableController.text = result.files.single.path!;
      });
    }
  }

  // ── Guardar ───────────────────────────────────────────────

  Future<void> guardarJuego() async {
    final l10n = AppLocalizations.of(context)!;
    if (nombreController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.juegoFormNombreObligatorio)));
      return;
    }

    setState(() => cargando = true);

    final rutaEjecutable = rutaEjecutableController.text.isNotEmpty
        ? rutaEjecutableController.text
        : null;

    Map<String, dynamic> respuesta;

    if (widget.juego == null) {
      respuesta = await ApiService.crearJuego(
        nombre: nombreController.text,
        descripcion: descripcionController.text,
        imagen: imagenDetalleController.text,
        imagenLocal: _imagenDetalleLocal,
        imagenGrid: imagenGridController.text,
        imagenGridLocal: _imagenGridLocal,
        imagenesExtra: _imagenesExtra,
        version: versionController.text,
        calificacion: calificacionController.text,
        generos: generosController.text,
        estado: estadoSeleccionado,
        usuarioId: widget.usuario.id,
        rutaEjecutable: rutaEjecutable,
        catalogo: widget.catalogoInicial,
      );
    } else {
      respuesta = await ApiService.actualizarJuego(
        id: widget.juego!.id,
        nombre: nombreController.text,
        descripcion: descripcionController.text,
        imagen: imagenDetalleController.text,
        imagenLocal: _imagenDetalleLocal,
        imagenGrid: imagenGridController.text,
        imagenGridLocal: _imagenGridLocal,
        imagenesExtra: _imagenesExtra,
        version: versionController.text,
        calificacion: calificacionController.text,
        generos: generosController.text,
        estado: estadoSeleccionado,
        rutaEjecutable: rutaEjecutable,
        catalogo: widget.juego?.catalogo ?? widget.catalogoInicial,
      );
    }

    setState(() => cargando = false);
    if (!mounted) return;

    final key = respuesta['messageKey'] as String? ?? '';
    final mensaje = _traducirClave(l10n, key);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));

    if (respuesta['success'] == true) {
      Navigator.pop(context);
    }
  }

  String _traducirClave(AppLocalizations l10n, String key) {
    switch (key) {
      case 'juegoFormAgregado':
        return l10n.juegoFormAgregado;
      case 'juegoFormActualizado':
        return l10n.juegoFormActualizado;
      default:
        return key;
    }
  }

  // ── Build ─────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final esEdicion = widget.juego != null;

    // Los estados se leen del l10n para que el dropdown también esté traducido
    final estados = {
      'Pending': l10n.estadoPendiente,
      'Playing': l10n.estadoJugando,
      'Completed': l10n.estadoCompletado,
      'Abandoned': l10n.estadoAbandonado,
    };

    // Asegurar que el estado guardado tenga equivalente en el idioma actual
    if (!estados.containsKey(estadoSeleccionado)) {
      estadoSeleccionado = estados.keys.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          esEdicion ? l10n.juegoFormEditarTitulo : l10n.juegoFormNuevoTitulo,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: l10n.juegoFormNombre),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Text(
                  l10n.juegoFormBuscarEn,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(width: 8),
                _botonFuente(
                  label: 'Steam',
                  cargando: _buscandoSteam,
                  onTap: _buscarEnSteam,
                ),
                const SizedBox(width: 6),
                _botonFuente(
                  label: 'Epic',
                  cargando: _buscandoEpic,
                  onTap: _buscarEnEpic,
                ),
                const SizedBox(width: 6),
                _botonFuente(
                  label: 'IGDB',
                  cargando: _buscandoIgdb,
                  onTap: _buscarEnIgdb,
                ),
                if (_f95Activado) ...[
                  const SizedBox(width: 6),
                  _botonFuente(
                    label: 'F95',
                    cargando: _buscandoF95,
                    onTap: _buscarEnF95,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),

            TextField(
              controller: descripcionController,
              decoration: InputDecoration(labelText: l10n.juegoFormDescripcion),
              maxLines: 3,
            ),
            const SizedBox(height: 12),

            Text(
              l10n.juegoFormImagenDetalle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            _vistaPrevia(imagenDetalleController.text, _imagenDetalleLocal),
            if (_imagenDetalleLocal != null ||
                imagenDetalleController.text.isNotEmpty)
              const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: imagenDetalleController,
                    decoration: InputDecoration(
                      labelText: l10n.juegoFormUrlImagenDetalle,
                    ),
                    onChanged: (_) =>
                        setState(() => _imagenDetalleLocal = null),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.photo_library),
                  onPressed: () => _elegirImagen(esGrid: false),
                ),
                if (_imagenDetalleLocal != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _imagenDetalleLocal = null),
                  ),
              ],
            ),

            const SizedBox(height: 12),
            Text(
              l10n.juegoFormImagenGrid,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            _vistaPrevia(imagenGridController.text, _imagenGridLocal),
            if (_imagenGridLocal != null ||
                imagenGridController.text.isNotEmpty)
              const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: imagenGridController,
                    decoration: InputDecoration(
                      labelText: l10n.juegoFormUrlImagenGrid,
                    ),
                    onChanged: (_) => setState(() => _imagenGridLocal = null),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.photo_library),
                  onPressed: () => _elegirImagen(esGrid: true),
                ),
                if (_imagenGridLocal != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _imagenGridLocal = null),
                  ),
              ],
            ),

            const SizedBox(height: 12),
            TextField(
              controller: versionController,
              decoration: InputDecoration(labelText: l10n.juegoFormVersion),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: calificacionController,
              decoration: InputDecoration(
                labelText: l10n.juegoFormCalificacion,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: generosController,
              decoration: InputDecoration(labelText: l10n.juegoFormGeneros),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: estadoSeleccionado,
              items: estados.entries
                  .map(
                    (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                  )
                  .toList(),
              onChanged: (v) => setState(() => estadoSeleccionado = v!),
            ),

            if (_mostrarEjecutable) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                l10n.juegoFormLanzador,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: rutaEjecutableController,
                      decoration: InputDecoration(
                        labelText: l10n.juegoFormRutaEjecutable,
                        hintText: l10n.juegoFormRutaEjecutableHint,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.folder_open),
                    tooltip: l10n.juegoFormBuscarArchivo,
                    onPressed: _elegirEjecutable,
                  ),
                  if (rutaEjecutableController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: l10n.juegoFormQuitarRuta,
                      onPressed: () =>
                          setState(() => rutaEjecutableController.clear()),
                    ),
                ],
              ),
            ],

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cargando ? null : guardarJuego,
                child: cargando
                    ? const CircularProgressIndicator()
                    : Text(
                        esEdicion
                            ? l10n.juegoFormBtnActualizar
                            : l10n.juegoFormBtnGuardar,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## `frontend/lib/screens/perfiles_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import '../main.dart';
import '../widgets/avatar_usuario.dart';
import 'home_screen.dart';
import 'registro_screen.dart';
import 'package:frontend/l10n/app_localizations.dart';

class PerfilesScreen extends StatefulWidget {
  const PerfilesScreen({super.key});

  @override
  State<PerfilesScreen> createState() => _PerfilesScreenState();
}

class _PerfilesScreenState extends State<PerfilesScreen> {
  List<Usuario> perfiles = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarPerfiles();
  }

  Future<void> _cargarPerfiles() async {
    setState(() => cargando = true);
    perfiles = await ApiService.listarUsuarios();
    setState(() => cargando = false);
  }

  Future<void> _seleccionarPerfil(Usuario usuario) async {
    // Verificar si el perfil tiene contraseña
    final tienePassword = await ApiService.perfilTienePassword(usuario.id);

    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    if (!tienePassword) {
      // Acceso directo sin pedir contraseña
      final respuesta = await ApiService.login(
        nombre: usuario.nombre,
        password: '',
      );
      if (respuesta['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('usuario_id', usuario.id);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(usuario: usuario, appState: Feed95App.of(context)),
            ),
          );
        }
      }
      return;
    }

    // Perfil con contraseña → mostrar diálogo
    final passwordController = TextEditingController();

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(usuario.nombre),
        content: TextField(
          controller: passwordController,
          decoration: InputDecoration(labelText: l10n.perfilesInputPassword),
          obscureText: true,
          autofocus: true,
          onSubmitted: (_) => Navigator.pop(context, true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.btnCancelar),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.login, size: 16),
                const SizedBox(width: 6),
                Text(
                  l10n.btnEnter,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    final respuesta = await ApiService.login(
      nombre: usuario.nombre,
      password: passwordController.text,
    );

    if (respuesta['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('usuario_id', usuario.id);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomeScreen(usuario: usuario, appState: Feed95App.of(context)),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.perfilesPasswordIncorrecta)),
        );
      }
    }
  }

  Future<void> _eliminarPerfil(Usuario usuario) async {
    final tienePassword = await ApiService.perfilTienePassword(usuario.id);
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    // Paso 1: confirmación general
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.perfilesEliminarTitulo),
        content: Text(l10n.perfilesEliminarContenido(usuario.nombre)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.btnCancelar),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.btnEliminar,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    // Paso 2: si tiene contraseña, verificarla antes de borrar
    if (tienePassword) {
      if (!mounted) return;
      final passwordController = TextEditingController();
      final passwordOk = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.perfilesEliminarConfirmarTitulo),
          content: TextField(
            controller: passwordController,
            decoration: InputDecoration(labelText: l10n.perfilesInputPassword),
            obscureText: true,
            autofocus: true,
            onSubmitted: (_) => Navigator.pop(context, true),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.btnCancelar),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                l10n.btnEliminar,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );

      if (passwordOk != true) return;

      final respuesta = await ApiService.login(
        nombre: usuario.nombre,
        password: passwordController.text,
      );

      if (!mounted) return;
      if (respuesta['success'] != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.perfilesPasswordIncorrecta)),
        );
        return;
      }
    }

    await ApiService.eliminarUsuario(usuario.id);
    if (!mounted) return;
    _cargarPerfiles();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.perfilesTitulo)),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : perfiles.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.perfilesVacio),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistroScreen(),
                        ),
                      );
                      _cargarPerfiles();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          l10n.btnCrearPerfil,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 160,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.85,
                          ),
                      itemCount: perfiles.length,
                      itemBuilder: (context, index) {
                        final perfil = perfiles[index];
                        return GestureDetector(
                          onTap: () => _seleccionarPerfil(perfil),
                          onLongPress: () => _eliminarPerfil(perfil),
                          onSecondaryTap: () => _eliminarPerfil(perfil),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Avatar cuadrado redondeado (igual al del home)
                              AvatarUsuario(usuario: perfil, size: 80),
                              const SizedBox(height: 8),
                              Text(
                                perfil.nombre,
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistroScreen(),
                        ),
                      );
                      _cargarPerfiles();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          l10n.btnNuevoPerfil,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
```

## `frontend/lib/screens/perfil_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import '../widgets/avatar_usuario.dart';
import '../main.dart';
import 'package:frontend/l10n/app_localizations.dart';

class PerfilScreen extends StatefulWidget {
  final Usuario usuario;
  final VoidCallback onActualizado;
  final Feed95AppState? appState;

  const PerfilScreen({
    super.key,
    required this.usuario,
    required this.onActualizado,
    this.appState,
  });

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  late TextEditingController nombreController;
  late TextEditingController passwordController;
  late TextEditingController confirmarPasswordController;
  late Color colorSeleccionado;
  String? _imagenLocal;
  bool _limpiarImagen = false;
  bool cargando = false;

  // Estado de contraseña
  bool _tienePasswordActual = false;
  bool _usarPassword = false; // estado deseado tras guardar

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.usuario.nombre);
    passwordController = TextEditingController();
    confirmarPasswordController = TextEditingController();
    colorSeleccionado = widget.usuario.color;
    _imagenLocal = widget.usuario.imagenPerfil;
    _cargarEstadoPassword();
  }

  Future<void> _cargarEstadoPassword() async {
    final tiene = await ApiService.perfilTienePassword(widget.usuario.id);
    if (mounted) {
      setState(() {
        _tienePasswordActual = tiene;
        _usarPassword = tiene;
      });
    }
  }

  Future<void> _elegirImagen() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imagenLocal = picked.path;
        _limpiarImagen = false;
      });
    }
  }

  void _quitarImagen() {
    setState(() {
      _imagenLocal = null;
      _limpiarImagen = true;
    });
  }

  void _abrirColorPicker() {
    final l10n = AppLocalizations.of(context)!;
    Color colorTemporal = colorSeleccionado;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.registroElegirColor),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: colorTemporal,
            onColorChanged: (color) => colorTemporal = color,
            pickerAreaHeightPercent: 0.7,
            enableAlpha: false,
            hexInputBar: true,
            displayThumbColor: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.btnCancelar),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => colorSeleccionado = colorTemporal);
              Navigator.pop(context);
            },
            child: Text(l10n.registroColorAplicar),
          ),
        ],
      ),
    );
  }

  Future<void> guardar() async {
    final l10n = AppLocalizations.of(context)!;

    if (nombreController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.perfilNombreVacio)));
      return;
    }

    // Si el usuario quiere tener contraseña y está cambiándola
    if (_usarPassword && passwordController.text.isNotEmpty) {
      if (passwordController.text != confirmarPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.registroPasswordsNoCoinciden)),
        );
        return;
      }
    }

    setState(() => cargando = true);

    final respuesta = await ApiService.editarUsuario(
      id: widget.usuario.id,
      nombre: nombreController.text,
      // Si quiere contraseña y escribió algo → cambiarla
      password: (_usarPassword && passwordController.text.isNotEmpty)
          ? passwordController.text
          : null,
      // Si desactivó el switch → quitar contraseña
      quitarPassword: !_usarPassword,
      color: colorSeleccionado.toARGB32(),
      imagenPerfil:
          (_imagenLocal != widget.usuario.imagenPerfil && !_limpiarImagen)
          ? _imagenLocal
          : null,
      limpiarImagen: _limpiarImagen,
    );

    setState(() => cargando = false);
    if (!mounted) return;

    final key = respuesta['messageKey'] as String? ?? '';
    final mensaje = key == 'apiPerfilActualizadoOk'
        ? l10n.apiPerfilActualizadoOk
        : l10n.apiNombreEnUso;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));

    if (respuesta['success'] == true) {
      widget.onActualizado();
      Navigator.pop(context);
    }
  }

  Usuario get _usuarioPreview => Usuario(
    id: widget.usuario.id,
    nombre: nombreController.text.isNotEmpty
        ? nombreController.text
        : widget.usuario.nombre,
    color: colorSeleccionado,
    imagenPerfil: _limpiarImagen ? null : _imagenLocal,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.perfilTitulo)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    AvatarUsuario(usuario: _usuarioPreview, size: 96),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OutlinedButton.icon(
                          icon: const Icon(Icons.photo_library, size: 16),
                          label: Text(l10n.perfilCambiarImagen),
                          onPressed: _elegirImagen,
                        ),
                        if (_imagenLocal != null) ...[
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.close, size: 16),
                            label: Text(l10n.perfilQuitarImagen),
                            onPressed: _quitarImagen,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nombreController,
                decoration: InputDecoration(labelText: l10n.registroUsuario),
                onChanged: (_) => setState(() {}),
              ),

              // Switch contraseña
              const SizedBox(height: 16),
              Row(
                children: [
                  Switch(
                    value: _usarPassword,
                    onChanged: (v) => setState(() {
                      _usarPassword = v;
                      if (!v) {
                        passwordController.clear();
                        confirmarPasswordController.clear();
                      }
                    }),
                    activeThumbColor: primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.registroUsarPassword,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),

              if (_usarPassword) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: _tienePasswordActual
                        ? l10n.perfilNuevaPassword
                        : l10n.registroPassword,
                    hintText: _tienePasswordActual
                        ? l10n.perfilNuevaPasswordHint
                        : null,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmarPasswordController,
                  decoration: InputDecoration(
                    labelText: _tienePasswordActual
                        ? l10n.perfilRepetirNuevaPassword
                        : l10n.registroRepetirPassword,
                  ),
                  obscureText: true,
                ),
              ],

              const SizedBox(height: 24),
              Text(
                l10n.perfilColorTitulo,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _abrirColorPicker,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: colorSeleccionado,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                  ),
                  child: const Icon(Icons.colorize, color: Colors.white),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.perfilColorTocar,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: cargando ? null : guardar,
                  child: cargando
                      ? const CircularProgressIndicator()
                      : Text(l10n.perfilGuardarCambios),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## `frontend/lib/screens/registro_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../widgets/avatar_usuario.dart';
import '../models/usuario.dart';
import 'package:frontend/l10n/app_localizations.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final nombreController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmarPasswordController = TextEditingController();
  Color colorSeleccionado = const Color.fromARGB(255, 255, 54, 71);
  String? _imagenLocal;
  bool _usarPassword = false;
  bool cargando = false;

  void _abrirColorPicker() {
    final l10n = AppLocalizations.of(context)!;
    Color colorTemporal = colorSeleccionado;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.registroElegirColor),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: colorTemporal,
            onColorChanged: (color) => colorTemporal = color,
            pickerAreaHeightPercent: 0.7,
            enableAlpha: false,
            hexInputBar: true,
            displayThumbColor: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.btnCancelar),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => colorSeleccionado = colorTemporal);
              Navigator.pop(context);
            },
            child: Text(l10n.registroColorAplicar),
          ),
        ],
      ),
    );
  }

  Future<void> _elegirImagen() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imagenLocal = picked.path);
    }
  }

  Future<void> registrar() async {
    final l10n = AppLocalizations.of(context)!;

    if (nombreController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.registroCamposObligatorios)));
      return;
    }
    if (_usarPassword) {
      if (passwordController.text.isEmpty ||
          confirmarPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.registroCamposObligatorios)),
        );
        return;
      }
      if (passwordController.text != confirmarPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.registroPasswordsNoCoinciden)),
        );
        return;
      }
    }

    setState(() => cargando = true);
    final respuesta = await ApiService.registrarUsuario(
      nombre: nombreController.text,
      password: _usarPassword ? passwordController.text : '',
      color: colorSeleccionado.toARGB32(),
      imagenPerfil: _imagenLocal,
    );
    setState(() => cargando = false);
    if (!mounted) return;
    final key = respuesta['messageKey'] as String? ?? '';
    final mensaje = key == 'apiPerfilCreadoOk'
        ? l10n.apiPerfilCreadoOk
        : l10n.apiNombreDuplicado;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
    if (respuesta['success'] == true) {
      Navigator.pop(context);
    }
  }

  // Preview del avatar con los datos actuales del formulario
  Usuario get _usuarioPreview => Usuario(
    id: 0,
    nombre: nombreController.text.isNotEmpty ? nombreController.text : '?',
    color: colorSeleccionado,
    imagenPerfil: _imagenLocal,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.registroTitulo)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Avatar preview con botón de imagen
              Center(
                child: Column(
                  children: [
                    AvatarUsuario(usuario: _usuarioPreview, size: 96),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.photo_library, size: 16),
                      label: Text(
                        _imagenLocal != null
                            ? l10n.perfilCambiarImagen
                            : l10n.registroAgregarImagen,
                      ),
                      onPressed: _elegirImagen,
                    ),
                    if (_imagenLocal != null) ...[
                      const SizedBox(height: 6),
                      TextButton.icon(
                        icon: const Icon(Icons.close, size: 14),
                        label: Text(l10n.perfilQuitarImagen),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () => setState(() => _imagenLocal = null),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),
              TextField(
                controller: nombreController,
                decoration: InputDecoration(labelText: l10n.registroUsuario),
                onChanged: (_) => setState(() {}),
              ),

              // Switch contraseña
              const SizedBox(height: 16),
              Row(
                children: [
                  Switch(
                    value: _usarPassword,
                    onChanged: (v) => setState(() {
                      _usarPassword = v;
                      if (!v) {
                        passwordController.clear();
                        confirmarPasswordController.clear();
                      }
                    }),
                    activeColor: primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.registroUsarPassword,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),

              if (_usarPassword) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: l10n.registroPassword),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmarPasswordController,
                  decoration: InputDecoration(
                    labelText: l10n.registroRepetirPassword,
                  ),
                  obscureText: true,
                ),
              ],

              const SizedBox(height: 24),
              Text(
                l10n.registroColorPerfil,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _abrirColorPicker,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: colorSeleccionado,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                  ),
                  child: const Icon(Icons.colorize, color: Colors.white),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.registroTocaColor,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: cargando ? null : registrar,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: cargando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.person_add, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              l10n.btnCrearPerfil,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## `frontend/lib/screens/login_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../main.dart';
import 'home_screen.dart';
import 'registro_screen.dart';
import 'package:frontend/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final nombreController = TextEditingController();
  final passwordController = TextEditingController();
  bool cargando = false;

  Future<void> iniciarSesion() async {
    final l10n = AppLocalizations.of(context)!;

    if (nombreController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.registroCamposObligatorios)));
      return;
    }

    setState(() => cargando = true);

    final respuesta = await ApiService.login(
      nombre: nombreController.text,
      password: passwordController.text,
    );

    setState(() => cargando = false);

    if (!mounted) return;

    if (respuesta['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('usuario_id', respuesta['usuario']['id'] as int);
      final usuario = ApiService.convertirUsuario(respuesta['usuario']);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomeScreen(usuario: usuario, appState: Feed95App.of(context)),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.perfilesPasswordIncorrecta)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: const Text('Feed95')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.perfilesTitulo,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: l10n.registroUsuario),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: l10n.perfilesInputPassword,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: cargando ? null : iniciarSesion,
              child: cargando
                  ? const CircularProgressIndicator()
                  : Text(l10n.btnEnter),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistroScreen(),
                  ),
                );
              },
              child: Text(l10n.loginSinCuenta),
            ),
          ],
        ),
      ),
    );
  }
}
```

## `frontend/lib/screens/f95_config_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../services/f95_service.dart';
import 'package:frontend/l10n/app_localizations.dart';

class F95ConfigScreen extends StatefulWidget {
  const F95ConfigScreen({super.key});

  @override
  State<F95ConfigScreen> createState() => _F95ConfigScreenState();
}

class _F95ConfigScreenState extends State<F95ConfigScreen> {
  final usuarioController = TextEditingController();
  final passwordController = TextEditingController();
  bool cargando = false;
  bool tieneSesion = false;

  @override
  void initState() {
    super.initState();
    _verificar();
  }

  Future<void> _verificar() async {
    final tiene = await F95Service.tieneSesion();
    setState(() => tieneSesion = tiene);
  }

  Future<void> _login() async {
    final l10n = AppLocalizations.of(context)!;
    if (usuarioController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.f95CamposObligatorios)),
      );
      return;
    }
    setState(() => cargando = true);
    final ok = await F95Service.login(
      usuario: usuarioController.text,
      password: passwordController.text,
    );
    setState(() => cargando = false);
    if (!mounted) return;
    if (ok) {
      setState(() => tieneSesion = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.f95SesionOk)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.f95ErrorSesion)),
      );
    }
  }

  Future<void> _cerrarSesion() async {
    final l10n = AppLocalizations.of(context)!;
    await F95Service.cerrarSesion();
    if (!mounted) return;
    setState(() => tieneSesion = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.f95SesionCerrada)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.f95Titulo)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: tieneSesion
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Color.fromARGB(255, 255, 54, 71),
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.f95SesionActivaTitulo,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.f95SesionActivaDescripcion,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: Text(l10n.f95CerrarSesion),
                    onPressed: _cerrarSesion,
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.f95ConectarTitulo,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.f95ConectarDescripcion,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: usuarioController,
                    decoration: InputDecoration(labelText: l10n.f95Usuario),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: l10n.f95Password),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: cargando ? null : _login,
                      child: cargando
                          ? const CircularProgressIndicator()
                          : Text(l10n.f95IniciarSesion),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
```

## `frontend/lib/screens/igdb_config_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../services/igdb_service.dart';
import 'package:frontend/l10n/app_localizations.dart';

class IgdbConfigScreen extends StatefulWidget {
  const IgdbConfigScreen({super.key});

  @override
  State<IgdbConfigScreen> createState() => _IgdbConfigScreenState();
}

class _IgdbConfigScreenState extends State<IgdbConfigScreen> {
  final _clientIdController = TextEditingController();
  final _clientSecretController = TextEditingController();
  bool _cargando = false;
  bool _tieneCredenciales = false;
  bool _mostrarSecret = false;

  @override
  void initState() {
    super.initState();
    _verificar();
  }

  Future<void> _verificar() async {
    final tiene = await IgdbService.tieneCredenciales();
    if (!mounted) return;
    setState(() => _tieneCredenciales = tiene);
  }

  Future<void> _guardar() async {
    final l10n = AppLocalizations.of(context)!;
    if (_clientIdController.text.isEmpty ||
        _clientSecretController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.igdbCamposObligatorios)));
      return;
    }
    setState(() => _cargando = true);

    final validas = await IgdbService.verificarCredenciales(
      clientId: _clientIdController.text.trim(),
      clientSecret: _clientSecretController.text.trim(),
    );

    if (!validas) {
      setState(() => _cargando = false);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.igdbCredencialesInvalidas)));
      return;
    }

    await IgdbService.guardarCredenciales(
      clientId: _clientIdController.text.trim(),
      clientSecret: _clientSecretController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _cargando = false;
      _tieneCredenciales = true;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.igdbConfiguradoOk)));
  }

  Future<void> _limpiar() async {
    await IgdbService.limpiarCredenciales();
    if (!mounted) return;
    setState(() => _tieneCredenciales = false);
    _clientIdController.clear();
    _clientSecretController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.igdbTitulo)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _tieneCredenciales
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Color.fromARGB(255, 255, 54, 71),
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.igdbConfiguradoTitulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.igdbConfiguradoDescripcion,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.delete_outline),
                    label: Text(l10n.igdbEliminarCredenciales),
                    onPressed: _limpiar,
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.igdbConfigurarTitulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.igdbDescripcion,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.igdbInstrucciones,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _clientIdController,
                    decoration: InputDecoration(labelText: l10n.igdbClientId),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _clientSecretController,
                    decoration: InputDecoration(
                      labelText: l10n.igdbClientSecret,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _mostrarSecret
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () =>
                            setState(() => _mostrarSecret = !_mostrarSecret),
                      ),
                    ),
                    obscureText: !_mostrarSecret,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _cargando ? null : _guardar,
                      child: _cargando
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.igdbGuardarVerificar),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
```

## `frontend/lib/widgets/avatar_usuario.dart`

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/usuario.dart';

class AvatarUsuario extends StatelessWidget {
  final Usuario usuario;
  final double size;
  final bool circular;

  const AvatarUsuario({
    super.key,
    required this.usuario,
    this.size = 80,
    this.circular = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = circular ? size / 2 : 12.0;
    if (usuario.imagenPerfil != null && usuario.imagenPerfil!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.file(
          File(usuario.imagenPerfil!),
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _colorAvatar(radius),
        ),
      );
    }
    return _colorAvatar(radius);
  }

  Widget _colorAvatar(double radius) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: usuario.color,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Center(
        child: Text(
          usuario.nombre[0].toUpperCase(),
          style: TextStyle(
            fontSize: size * 0.42,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
```

## `frontend/test/api_service_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/services/api_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Pruebas de usuarios', () {

    test('Registrar usuario correctamente', () async {
      final result = await ApiService.registrarUsuario(
        nombre: 'test_user',
        password: '1234',
        color: 0xFF0000FF,
      );

      expect(result['success'], true);
    });

    test('No permitir usuarios duplicados', () async {
      await ApiService.registrarUsuario(
        nombre: 'duplicado',
        password: '1234',
        color: 0xFF0000FF,
      );

      final result = await ApiService.registrarUsuario(
        nombre: 'duplicado',
        password: '5678',
        color: 0xFFFF0000,
      );

      expect(result['success'], false);
    });

    test('Login correcto', () async {
      await ApiService.registrarUsuario(
        nombre: 'login_test',
        password: '1234',
        color: 0xFF00FF00,
      );

      final result = await ApiService.login(
        nombre: 'login_test',
        password: '1234',
      );

      expect(result['success'], true);
    });

    test('Login incorrecto', () async {
      final result = await ApiService.login(
        nombre: 'usuario_fake',
        password: 'incorrecta',
      );

      expect(result['success'], false);
    });

  });
}
```

## `frontend/lib/l10n/app_es.arb`

```json
{
  "@@locale": "es",

  "appTitle": "Feed95",

  "btnCancelar": "Cancelar",
  "btnGuardar": "Guardar",
  "btnEliminar": "Eliminar",
  "btnEditar": "Editar",
  "btnAceptar": "Aceptar",
  "btnEnter": "Entrar",
  "btnImportar": "Importar",
  "btnConfigurar": "Configurar",
  "btnCrearPerfil": "Crear perfil",
  "btnNuevoPerfil": "Nuevo perfil",
  "loginSinCuenta": "¿No tienes cuenta? Créala aquí",

  "estadoPendiente": "Pendiente",
  "estadoJugando": "Jugando",
  "estadoCompletado": "Completado",
  "estadoAbandonado": "Abandonado",

  "splashCargando": "Cargando...",

  "homeTitle": "Feed95",
  "homeBienvenido": "Bienvenido, {nombre}",
  "@homeBienvenido": {
    "placeholders": {
      "nombre": { "type": "String" }
    }
  },
  "homeMiCatalogo": "Mi catálogo",
  "homeStatJuegos": "Juegos",
  "homeStatCompletados": "Completados",
  "homeStatJugando": "Jugando",
  "homeTooltipCambiarTema": "Cambiar tema",
  "homeTooltipCambiarPerfil": "Cambiar perfil",
  "homeTooltipCerrarSesion": "Cerrar sesión",
  "homeEditarPerfil": "Editar perfil",
  "homeModoExtendidoActivado": "Modo extendido activado",
  "homeModoExtendidoDesactivado": "Modo extendido desactivado",
  "homeConfiguraciones": "Configuraciones y Backup",
  "homeSeccionConfiguraciones": "CONFIGURACIONES",
  "homeSeccionSistema": "SISTEMA",
  "homeConfigurarIGDB": "Configurar IGDB",
  "homeConfigurarF95": "Configurar F95Zone",
  "homeExportarCopia": "Exportar copia",
  "homeImportarCopia": "Importar copia",
  "homeErrorExportar": "Error al exportar: {error}",
  "@homeErrorExportar": {
    "placeholders": {
      "error": { "type": "String" }
    }
  },
  "homeErrorImportar": "Error al importar: {error}",
  "@homeErrorImportar": {
    "placeholders": {
      "error": { "type": "String" }
    }
  },
  "homeBackupGuardado": "Backup guardado en {ruta}",
  "@homeBackupGuardado": {
    "placeholders": {
      "ruta": { "type": "String" }
    }
  },
  "homeBackupNoDisponibleWeb": "Exportar backup no está disponible en Web",
  "homeImportarNoDisponibleWeb": "Importar backup no está disponible en Web",
  "homeDialogoImportarTitulo": "Importar backup",
  "homeDialogoImportarContenido": "Se agregarán los perfiles y juegos del backup. Los perfiles con el mismo nombre serán omitidos.",
  "homeGuardarBackupEn": "Guardar backup en...",

  "perfilesTitulo": "Feed95 — Perfiles",
  "perfilesVacio": "No hay perfiles todavía",
  "perfilesEliminarTitulo": "Eliminar perfil",
  "perfilesEliminarContenido": "¿Eliminar a {nombre}? Se borrarán todos sus juegos.",
  "@perfilesEliminarContenido": {
    "placeholders": {
      "nombre": { "type": "String" }
    }
  },
  "perfilesPasswordIncorrecta": "Contraseña incorrecta",
  "perfilesInputPassword": "Contraseña",
  "registroTitulo": "Nuevo perfil",
  "registroUsuario": "Usuario",
  "registroUsarPassword": "Proteger con contraseña",
  "registroAgregarImagen": "Agregar imagen",
  "registroPassword": "Contraseña",
  "registroRepetirPassword": "Repetir contraseña",
  "registroColorPerfil": "Color del perfil",
  "registroTocaColor": "Toca para elegir un color",
  "registroElegirColor": "Elige un color",
  "registroCamposObligatorios": "Complete todos los campos",
  "registroPasswordsNoCoinciden": "Las contraseñas no coinciden",
  "registroColorAplicar": "Aplicar",

  "perfilTitulo": "Editar perfil",
  "perfilCambiarImagen": "Cambiar imagen",
  "perfilQuitarImagen": "Quitar",
  "perfilNuevaPassword": "Nueva contraseña",
  "perfilNuevaPasswordHint": "Dejar vacío para no cambiar",
  "perfilRepetirNuevaPassword": "Repetir nueva contraseña",
  "perfilColorTitulo": "Color del perfil",
  "perfilColorTocar": "Toca para cambiar el color",
  "perfilGuardarCambios": "Guardar cambios",
  "perfilNombreVacio": "El nombre no puede estar vacío",
  "perfilActualizado": "Perfil actualizado correctamente",
  "perfilesEliminarConfirmarTitulo": "Confirmar eliminación",

  "catalogoTitulo": "Mi catálogo",
  "catalogoSecundarioNombre": "NSFW",
  "catalogoVacio": "No hay juegos en este catálogo",
  "catalogoVacioFiltros": "No hay juegos con esos filtros",
  "catalogoReordenarVacio": "No hay juegos para reordenar",
  "catalogoBuscar": "Buscar...",
  "catalogoTooltipFiltros": "Filtros y categorías",
  "catalogoTooltipReordenar": "Reordenar",
  "catalogoTooltipVerCatalogo": "Ver catálogo",
  "catalogoTooltipVistaLista": "Vista lista",
  "catalogoTooltipVistaGrid": "Vista cuadrícula",
  "catalogoTooltipCatalogoSecundario": "Ir a {nombre}",
  "@catalogoTooltipCatalogoSecundario": {
    "placeholders": {
      "nombre": { "type": "String" }
    }
  },
  "catalogoTooltipCatalogoPrincipal": "Ir al catálogo principal",
  "catalogoSeccionEstado": "Estado",
  "catalogoSeccionCategorias": "Categorías",
  "catalogoFiltroTodos": "Todos",
  "catalogoFiltroTodas": "Todas",
  "catalogoAsignarCategoria": "Asignar categoría",
  "catalogoSinCategoria": "Sin categoría",

  "categoriaNuevaTitulo": "Nueva categoría",
  "categoriaEditarTitulo": "Editar categoría",
  "categoriaNombreLabel": "Nombre",
  "categoriaEliminarTitulo": "Eliminar categoría",
  "categoriaEliminarContenido": "¿Eliminar \"{nombre}\"? Los juegos perderán esta categoría.",
  "@categoriaEliminarContenido": {
    "placeholders": {
      "nombre": { "type": "String" }
    }
  },

  "juegoDetalleTitulo": "Detalle",
  "juegoDetalleDescripcion": "Descripción",
  "juegoDetalleImagenes": "Imágenes",
  "juegoDetalleJugar": "Jugar",
  "juegoDetalleEliminarTitulo": "Eliminar juego",
  "juegoDetalleEliminarContenido": "¿Eliminar \"{nombre}\"? Esta acción no se puede deshacer.",
  "@juegoDetalleEliminarContenido": {
    "placeholders": {
      "nombre": { "type": "String" }
    }
  },
  "juegoDetalleErrorEjecutable": "No se pudo ejecutar: {error}",
  "@juegoDetalleErrorEjecutable": {
    "placeholders": {
      "error": { "type": "String" }
    }
  },
  "juegoDetalleTooltipEditar": "Editar",
  "juegoDetalleTooltipEliminar": "Eliminar",

  "juegoFormNuevoTitulo": "Nuevo juego",
  "juegoFormEditarTitulo": "Editar juego",
  "juegoFormNombre": "Nombre *",
  "juegoFormBuscarEn": "Buscar en:",
  "juegoFormDescripcion": "Descripción",
  "juegoFormImagenDetalle": "Imagen del detalle",
  "juegoFormUrlImagenDetalle": "URL imagen detalle",
  "juegoFormImagenGrid": "Imagen del grid",
  "juegoFormUrlImagenGrid": "URL imagen grid",
  "juegoFormVersion": "Versión",
  "juegoFormCalificacion": "Calificación (1-10)",
  "juegoFormGeneros": "Géneros",
  "juegoFormEstado": "Estado",
  "juegoFormLanzador": "Lanzador",
  "juegoFormRutaEjecutable": "Ruta del ejecutable",
  "juegoFormRutaEjecutableHint": "C:\\juegos\\myjuego.exe",
  "juegoFormBuscarArchivo": "Buscar archivo",
  "juegoFormQuitarRuta": "Quitar ruta",
  "juegoFormBtnGuardar": "Guardar",
  "juegoFormBtnActualizar": "Actualizar",
  "juegoFormNombreObligatorio": "El nombre es obligatorio",
  "juegoFormNoBusqueda": "Escribe un nombre para buscar",
  "juegoFormSinResultadosSteam": "No se encontraron resultados en Steam",
  "juegoFormSinResultadosEpic": "No se encontraron resultados en Epic",
  "juegoFormSinResultadosIgdb": "No se encontraron resultados en IGDB",
  "juegoFormSinResultadosF95": "No se encontraron resultados en F95Zone",
  "juegoFormErrorDetalles": "No se pudieron obtener los detalles",
  "juegoFormResultadosSteam": "Resultados en Steam",
  "juegoFormResultadosEpic": "Resultados en Epic Games",
  "juegoFormResultadosIgdb": "Resultados en IGDB",
  "juegoFormResultadosF95": "Resultados en F95Zone",
  "juegoFormAgregado": "Juego agregado correctamente",
  "juegoFormActualizado": "Juego actualizado correctamente",
  "juegoFormEliminado": "Juego eliminado correctamente",

  "igdbTitulo": "IGDB",
  "igdbConfiguradoTitulo": "IGDB configurado",
  "igdbConfiguradoDescripcion": "Las credenciales están guardadas localmente. El botón IGDB está disponible al añadir juegos.",
  "igdbEliminarCredenciales": "Eliminar credenciales",
  "igdbConfigurarTitulo": "Configurar IGDB",
  "igdbDescripcion": "IGDB es la base de datos de videojuegos de Twitch. Es gratuita y cubre prácticamente cualquier juego.",
  "igdbInstrucciones": "¿Cómo obtener credenciales?\n1. Ve a dev.twitch.tv\n2. Inicia sesión con tu cuenta de Twitch\n3. Crea una nueva aplicación (cualquier nombre)\n4. Copia el Client-ID y genera un Client-Secret",
  "igdbClientId": "Client-ID",
  "igdbClientSecret": "Client-Secret",
  "igdbGuardarVerificar": "Guardar y verificar",
  "igdbCamposObligatorios": "Completa ambos campos",
  "igdbCredencialesInvalidas": "Credenciales inválidas. Verifica tus datos.",
  "igdbConfiguradoOk": "IGDB configurado correctamente",
  "igdbNecesitaConfiguracion": "Necesitas configurar IGDB primero.",

  "f95Titulo": "F95Zone",
  "f95SesionActivaTitulo": "Sesión activa",
  "f95SesionActivaDescripcion": "Las cookies de sesión están guardadas en tu dispositivo. La búsqueda en F95Zone está disponible.",
  "f95CerrarSesion": "Cerrar sesión",
  "f95SesionCerrada": "Sesión cerrada",
  "f95ConectarTitulo": "Conectar con F95Zone",
  "f95ConectarDescripcion": "Tus credenciales se usan solo para iniciar sesión. Las cookies se guardan localmente en tu dispositivo.",
  "f95Usuario": "Usuario de F95Zone",
  "f95Password": "Contraseña",
  "f95IniciarSesion": "Iniciar sesión",
  "f95CamposObligatorios": "Completa usuario y contraseña",
  "f95SesionOk": "Sesión iniciada correctamente",
  "f95ErrorSesion": "No se pudo iniciar sesión. Verifica tus datos.",
  "f95NecesitaSesion": "Necesitas iniciar sesión en F95Zone primero.",

  "apiPerfilCreadoOk": "Perfil creado correctamente",
  "apiNombreDuplicado": "Ese nombre de usuario ya existe",
  "apiPasswordIncorrecta": "Contraseña incorrecta",
  "apiPerfilActualizadoOk": "Perfil actualizado correctamente",
  "apiNombreEnUso": "Ese nombre ya está en uso",
  "apiPerfilEliminado": "Perfil eliminado",
  "apiCategoriaCreada": "Categoría creada",
  "apiCategoriaActualizada": "Categoría actualizada",
  "apiBackupArchivoInvalido": "Archivo de backup inválido",
  "apiBackupRestaurado": "Backup restaurado: {perfiles} perfil(es), {categorias} categoría(s), {juegos} juego(s)",
  "@apiBackupRestaurado": {
    "placeholders": {
      "perfiles": { "type": "int" },
      "categorias": { "type": "int" },
      "juegos": { "type": "int" }
    }
  }
}
```

## `frontend/lib/l10n/app_en.arb`

```json
{
  "@@locale": "en",

  "appTitle": "Feed95",

  "btnCancelar": "Cancel",
  "btnGuardar": "Save",
  "btnEliminar": "Delete",
  "btnEditar": "Edit",
  "btnAceptar": "OK",
  "btnEnter": "Enter",
  "btnImportar": "Import",
  "btnConfigurar": "Configure",
  "btnCrearPerfil": "Create profile",
  "btnNuevoPerfil": "New profile",
  "loginSinCuenta": "Don't have an account? Create one here",

  "estadoPendiente": "Pending",
  "estadoJugando": "Playing",
  "estadoCompletado": "Completed",
  "estadoAbandonado": "Abandoned",

  "splashCargando": "Loading...",

  "homeTitle": "Feed95",
  "homeBienvenido": "Welcome, {nombre}",
  "@homeBienvenido": {
    "placeholders": {
      "nombre": { "type": "String" }
    }
  },
  "homeMiCatalogo": "My catalog",
  "homeStatJuegos": "Games",
  "homeStatCompletados": "Completed",
  "homeStatJugando": "Playing",
  "homeTooltipCambiarTema": "Toggle theme",
  "homeTooltipCambiarPerfil": "Switch profile",
  "homeTooltipCerrarSesion": "Log out",
  "homeEditarPerfil": "Edit profile",
  "homeModoExtendidoActivado": "Extended mode enabled",
  "homeModoExtendidoDesactivado": "Extended mode disabled",
  "homeConfiguraciones": "Settings & Backup",
  "homeSeccionConfiguraciones": "SETTINGS",
  "homeSeccionSistema": "SYSTEM",
  "homeConfigurarIGDB": "Configure IGDB",
  "homeConfigurarF95": "Configure F95Zone",
  "homeExportarCopia": "Export backup",
  "homeImportarCopia": "Import backup",
  "homeErrorExportar": "Export error: {error}",
  "@homeErrorExportar": {
    "placeholders": {
      "error": { "type": "String" }
    }
  },
  "homeErrorImportar": "Import error: {error}",
  "@homeErrorImportar": {
    "placeholders": {
      "error": { "type": "String" }
    }
  },
  "homeBackupGuardado": "Backup saved to {ruta}",
  "@homeBackupGuardado": {
    "placeholders": {
      "ruta": { "type": "String" }
    }
  },
  "homeBackupNoDisponibleWeb": "Export backup is not available on Web",
  "homeImportarNoDisponibleWeb": "Import backup is not available on Web",
  "homeDialogoImportarTitulo": "Import backup",
  "homeDialogoImportarContenido": "Profiles and games from the backup will be added. Profiles with the same name will be skipped.",
  "homeGuardarBackupEn": "Save backup to...",

  "perfilesTitulo": "Feed95 — Profiles",
  "perfilesVacio": "No profiles yet",
  "perfilesEliminarTitulo": "Delete profile",
  "perfilesEliminarContenido": "Delete {nombre}? All their games will be removed.",
  "@perfilesEliminarContenido": {
    "placeholders": {
      "nombre": { "type": "String" }
    }
  },
  "perfilesPasswordIncorrecta": "Wrong password",
  "perfilesInputPassword": "Password",
  "registroTitulo": "New profile",
  "registroUsuario": "Username",
  "registroUsarPassword": "Protect with password",
  "registroAgregarImagen": "Add image",
  "registroPassword": "Password",
  "registroRepetirPassword": "Repeat password",
  "registroColorPerfil": "Profile color",
  "registroTocaColor": "Tap to choose a color",
  "registroElegirColor": "Choose a color",
  "registroCamposObligatorios": "Please fill in all fields",
  "registroPasswordsNoCoinciden": "Passwords do not match",
  "registroColorAplicar": "Apply",

  "perfilTitulo": "Edit profile",
  "perfilCambiarImagen": "Change image",
  "perfilQuitarImagen": "Remove",
  "perfilNuevaPassword": "New password",
  "perfilNuevaPasswordHint": "Leave blank to keep current",
  "perfilRepetirNuevaPassword": "Repeat new password",
  "perfilColorTitulo": "Profile color",
  "perfilColorTocar": "Tap to change color",
  "perfilGuardarCambios": "Save changes",
  "perfilNombreVacio": "Name cannot be empty",
  "perfilActualizado": "Profile updated successfully",
  "perfilesEliminarConfirmarTitulo": "Confirm deletion",

  "catalogoTitulo": "My catalog",
  "catalogoSecundarioNombre": "NSFW",
  "catalogoVacio": "No games in this catalog",
  "catalogoVacioFiltros": "No games match those filters",
  "catalogoReordenarVacio": "No games to reorder",
  "catalogoBuscar": "Search...",
  "catalogoTooltipFiltros": "Filters & categories",
  "catalogoTooltipReordenar": "Reorder",
  "catalogoTooltipVerCatalogo": "View catalog",
  "catalogoTooltipVistaLista": "List view",
  "catalogoTooltipVistaGrid": "Grid view",
  "catalogoTooltipCatalogoSecundario": "Go to {nombre}",
  "@catalogoTooltipCatalogoSecundario": {
    "placeholders": {
      "nombre": { "type": "String" }
    }
  },
  "catalogoTooltipCatalogoPrincipal": "Go to main catalog",
  "catalogoSeccionEstado": "Status",
  "catalogoSeccionCategorias": "Categories",
  "catalogoFiltroTodos": "All",
  "catalogoFiltroTodas": "All",
  "catalogoAsignarCategoria": "Assign category",
  "catalogoSinCategoria": "No category",

  "categoriaNuevaTitulo": "New category",
  "categoriaEditarTitulo": "Edit category",
  "categoriaNombreLabel": "Name",
  "categoriaEliminarTitulo": "Delete category",
  "categoriaEliminarContenido": "Delete \"{nombre}\"? Games will lose this category.",
  "@categoriaEliminarContenido": {
    "placeholders": {
      "nombre": { "type": "String" }
    }
  },

  "juegoDetalleTitulo": "Detail",
  "juegoDetalleDescripcion": "Description",
  "juegoDetalleImagenes": "Screenshots",
  "juegoDetalleJugar": "Play",
  "juegoDetalleEliminarTitulo": "Delete game",
  "juegoDetalleEliminarContenido": "Delete \"{nombre}\"? This action cannot be undone.",
  "@juegoDetalleEliminarContenido": {
    "placeholders": {
      "nombre": { "type": "String" }
    }
  },
  "juegoDetalleErrorEjecutable": "Could not launch: {error}",
  "@juegoDetalleErrorEjecutable": {
    "placeholders": {
      "error": { "type": "String" }
    }
  },
  "juegoDetalleTooltipEditar": "Edit",
  "juegoDetalleTooltipEliminar": "Delete",

  "juegoFormNuevoTitulo": "New game",
  "juegoFormEditarTitulo": "Edit game",
  "juegoFormNombre": "Name *",
  "juegoFormBuscarEn": "Search on:",
  "juegoFormDescripcion": "Description",
  "juegoFormImagenDetalle": "Detail image",
  "juegoFormUrlImagenDetalle": "Detail image URL",
  "juegoFormImagenGrid": "Grid image",
  "juegoFormUrlImagenGrid": "Grid image URL",
  "juegoFormVersion": "Version",
  "juegoFormCalificacion": "Rating (1-10)",
  "juegoFormGeneros": "Genres",
  "juegoFormEstado": "Status",
  "juegoFormLanzador": "Launcher",
  "juegoFormRutaEjecutable": "Executable path",
  "juegoFormRutaEjecutableHint": "C:\\games\\mygame.exe",
  "juegoFormBuscarArchivo": "Browse file",
  "juegoFormQuitarRuta": "Remove path",
  "juegoFormBtnGuardar": "Save",
  "juegoFormBtnActualizar": "Update",
  "juegoFormNombreObligatorio": "Name is required",
  "juegoFormNoBusqueda": "Enter a name to search",
  "juegoFormSinResultadosSteam": "No results found on Steam",
  "juegoFormSinResultadosEpic": "No results found on Epic",
  "juegoFormSinResultadosIgdb": "No results found on IGDB",
  "juegoFormSinResultadosF95": "No results found on F95Zone",
  "juegoFormErrorDetalles": "Could not fetch details",
  "juegoFormResultadosSteam": "Steam results",
  "juegoFormResultadosEpic": "Epic Games results",
  "juegoFormResultadosIgdb": "IGDB results",
  "juegoFormResultadosF95": "F95Zone results",
  "juegoFormAgregado": "Game added successfully",
  "juegoFormActualizado": "Game updated successfully",
  "juegoFormEliminado": "Game deleted successfully",

  "igdbTitulo": "IGDB",
  "igdbConfiguradoTitulo": "IGDB configured",
  "igdbConfiguradoDescripcion": "Credentials are saved locally. The IGDB button is available when adding games.",
  "igdbEliminarCredenciales": "Remove credentials",
  "igdbConfigurarTitulo": "Set up IGDB",
  "igdbDescripcion": "IGDB is Twitch's video game database. It's free and covers virtually any game.",
  "igdbInstrucciones": "How to get credentials?\n1. Go to dev.twitch.tv\n2. Sign in with your Twitch account\n3. Create a new application (any name)\n4. Copy the Client-ID and generate a Client-Secret",
  "igdbClientId": "Client-ID",
  "igdbClientSecret": "Client-Secret",
  "igdbGuardarVerificar": "Save and verify",
  "igdbCamposObligatorios": "Please fill in both fields",
  "igdbCredencialesInvalidas": "Invalid credentials. Please check your data.",
  "igdbConfiguradoOk": "IGDB configured successfully",
  "igdbNecesitaConfiguracion": "You need to configure IGDB first.",

  "f95Titulo": "F95Zone",
  "f95SesionActivaTitulo": "Active session",
  "f95SesionActivaDescripcion": "Session cookies are saved on your device. F95Zone search is available.",
  "f95CerrarSesion": "Log out",
  "f95SesionCerrada": "Session closed",
  "f95ConectarTitulo": "Connect to F95Zone",
  "f95ConectarDescripcion": "Your credentials are only used to log in. Cookies are stored locally on your device.",
  "f95Usuario": "F95Zone username",
  "f95Password": "Password",
  "f95IniciarSesion": "Log in",
  "f95CamposObligatorios": "Please enter your username and password",
  "f95SesionOk": "Logged in successfully",
  "f95ErrorSesion": "Could not log in. Please check your credentials.",
  "f95NecesitaSesion": "You need to log in to F95Zone first.",

  "apiPerfilCreadoOk": "Profile created successfully",
  "apiNombreDuplicado": "That username already exists",
  "apiPasswordIncorrecta": "Wrong password",
  "apiPerfilActualizadoOk": "Profile updated successfully",
  "apiNombreEnUso": "That name is already taken",
  "apiPerfilEliminado": "Profile deleted",
  "apiCategoriaCreada": "Category created",
  "apiCategoriaActualizada": "Category updated",
  "apiBackupArchivoInvalido": "Invalid backup file",
  "apiBackupRestaurado": "Backup restored: {perfiles} profile(s), {categorias} categor(y/ies), {juegos} game(s)",
  "@apiBackupRestaurado": {
    "placeholders": {
      "perfiles": { "type": "int" },
      "categorias": { "type": "int" },
      "juegos": { "type": "int" }
    }
  }
}
```

## `frontend/lib/l10n/app_zh.arb`

```json
{
  "@@locale": "zh",

  "appTitle": "Feed95",

  "btnCancelar": "取消",
  "btnGuardar": "保存",
  "btnEliminar": "删除",
  "btnEditar": "编辑",
  "btnAceptar": "确定",
  "btnEnter": "进入",
  "btnImportar": "导入",
  "btnConfigurar": "配置",
  "btnCrearPerfil": "创建档案",
  "btnNuevoPerfil": "新建档案",
  "loginSinCuenta": "还没有账号？点击此处创建",

  "estadoPendiente": "待玩",
  "estadoJugando": "正在游玩",
  "estadoCompletado": "已通关",
  "estadoAbandonado": "已弃坑",

  "splashCargando": "正在加载...",

  "homeTitle": "Feed95",
  "homeBienvenido": "欢迎，{nombre}",
  "@homeBienvenido": {
    "placeholders": {
      "nombre": { "type": "String" }
    }
  },
  "homeMiCatalogo": "我的库",
  "homeStatJuegos": "游戏总数",
  "homeStatCompletados": "已通关",
  "homeStatJugando": "正在游玩",
  "homeTooltipCambiarTema": "切换主题",
  "homeTooltipCambiarPerfil": "切换档案",
  "homeTooltipCerrarSesion": "退出登录",
  "homeEditarPerfil": "编辑档案",
  "homeModoExtendidoActivado": "扩展模式已开启",
  "homeModoExtendidoDesactivado": "扩展模式已关闭",
  "homeConfiguraciones": "配置与备份",
  "homeSeccionConfiguraciones": "设置",
  "homeSeccionSistema": "系统",
  "homeConfigurarIGDB": "配置 IGDB",
  "homeConfigurarF95": "配置 F95Zone",
  "homeExportarCopia": "导出备份",
  "homeImportarCopia": "导入备份",
  "homeErrorExportar": "导出失败：{error}",
  "@homeErrorExportar": {
    "placeholders": {
      "error": { "type": "String" }
    }
  },
  "homeErrorImportar": "导入失败：{error}",
  "@homeErrorImportar": {
    "placeholders": {
      "error": { "type": "String" }
    }
  },
  "homeBackupGuardado": "备份已保存至 {ruta}",
  "@homeBackupGuardado": {
    "placeholders": {
      "ruta": { "type": "String" }
    }
  },
  "homeBackupNoDisponibleWeb": "网页端不支持导出备份",
  "homeImportarNoDisponibleWeb": "网页端不支持导入备份",
  "homeDialogoImportarTitulo": "导入备份",
  "homeDialogoImportarContenido": "备份中的档案和游戏将被添加。同名的现有档案将被忽略。",
  "homeGuardarBackupEn": "保存备份至...",

  "perfilesTitulo": "Feed95 — 档案管理",
  "perfilesVacio": "暂无档案",
  "perfilesEliminarTitulo": "删除档案",
  "perfilesEliminarContenido": "确定要删除 {nombre} 吗？该档案下的所有游戏数据都将被清除。",
  "@perfilesEliminarContenido": {
    "placeholders": {
      "nombre": { "type": "String" }
    }
  },
  "perfilesPasswordIncorrecta": "密码错误",
  "perfilesInputPassword": "密码",
  "registroTitulo": "新建档案",
  "registroUsuario": "用户名",
  "registroUsarPassword": "使用密码保护",
  "registroAgregarImagen": "添加图片",
  "registroPassword": "密码",
  "registroRepetirPassword": "确认密码",
  "registroColorPerfil": "档案个性颜色",
  "registroTocaColor": "点击选择颜色",
  "registroElegirColor": "选择一个颜色",
  "registroCamposObligatorios": "请填写所有必填项",
  "registroPasswordsNoCoinciden": "两次输入的密码不一致",
  "registroColorAplicar": "应用",

  "perfilTitulo": "编辑档案",
  "perfilCambiarImagen": "更换头像",
  "perfilQuitarImagen": "移除",
  "perfilNuevaPassword": "新密码",
  "perfilNuevaPasswordHint": "留空则不修改",
  "perfilRepetirNuevaPassword": "确认新密码",
  "perfilColorTitulo": "档案个性颜色",
  "perfilColorTocar": "点击更改颜色",
  "perfilGuardarCambios": "保存修改",
  "perfilNombreVacio": "用户名不能为空",
  "perfilActualizado": "档案更新成功",
  "perfilesEliminarConfirmarTitulo": "确认删除",

  "catalogoTitulo": "我的库",
  "catalogoSecundarioNombre": "NSFW",
  "catalogoVacio": "当前库中没有游戏",
  "catalogoVacioFiltros": "没有找到符合筛选条件的游戏",
  "catalogoReordenarVacio": "没有可重新排序的游戏",
  "catalogoBuscar": "搜索...",
  "catalogoTooltipFiltros": "筛选与分类",
  "catalogoTooltipReordenar": "重新排序",
  "catalogoTooltipVerCatalogo": "查看游戏库",
  "catalogoTooltipVistaLista": "列表视图",
  "catalogoTooltipVistaGrid": "网格视图",
  "catalogoTooltipCatalogoSecundario": "前往 {nombre}",
  "@catalogoTooltipCatalogoSecundario": {
    "placeholders": {
      "nombre": { "type": "String" }
    }
  },
  "catalogoTooltipCatalogoPrincipal": "返回主游戏库",
  "catalogoSeccionEstado": "游玩状态",
  "catalogoSeccionCategorias": "游戏分类",
  "catalogoFiltroTodos": "全部状态",
  "catalogoFiltroTodas": "全部分类",
  "catalogoAsignarCategoria": "分配分类",
  "catalogoSinCategoria": "未分类",

  "categoriaNuevaTitulo": "新建分类",
  "categoriaEditarTitulo": "编辑分类",
  "categoriaNombreLabel": "分类名称",
  "categoriaEliminarTitulo": "删除分类",
  "categoriaEliminarContenido": "确定要删除分类 \"{nombre}\" 吗？属于该分类的游戏将变为未分类状态。",
  "@categoriaEliminarContenido": {
    "placeholders": {
      "nombre": { "type": "String" }
    }
  },

  "juegoDetalleTitulo": "游戏详情",
  "juegoDetalleDescripcion": "简介",
  "juegoDetalleImagenes": "屏幕截图",
  "juegoDetalleJugar": "开始游戏",
  "juegoDetalleEliminarTitulo": "删除游戏",
  "juegoDetalleEliminarContenido": "确定要删除 \"{nombre}\" 吗？此操作无法撤销。",
  "@juegoDetalleEliminarContenido": {
    "placeholders": {
      "nombre": { "type": "String" }
    }
  },
  "juegoDetalleErrorEjecutable": "无法启动游戏：{error}",
  "@juegoDetalleErrorEjecutable": {
    "placeholders": {
      "error": { "type": "String" }
    }
  },
  "juegoDetalleTooltipEditar": "编辑",
  "juegoDetalleTooltipEliminar": "删除",

  "juegoFormNuevoTitulo": "添加游戏",
  "juegoFormEditarTitulo": "编辑游戏",
  "juegoFormNombre": "游戏名称 *",
  "juegoFormBuscarEn": "搜索平台：",
  "juegoFormDescripcion": "简介",
  "juegoFormImagenDetalle": "详情页背景图",
  "juegoFormUrlImagenDetalle": "详情图 URL",
  "juegoFormImagenGrid": "封面图 (Grid)",
  "juegoFormUrlImagenGrid": "封面图 URL",
  "juegoFormVersion": "版本",
  "juegoFormCalificacion": "评分 (1-10)",
  "juegoFormGeneros": "游戏标签 / 类型",
  "juegoFormEstado": "游玩状态",
  "juegoFormLanzador": "启动器",
  "juegoFormRutaEjecutable": "可执行文件路径 (.exe)",
  "juegoFormRutaEjecutableHint": "C:\\juegos\\myjuego.exe",
  "juegoFormBuscarArchivo": "浏览文件",
  "juegoFormQuitarRuta": "清除路径",
  "juegoFormBtnGuardar": "添加游戏",
  "juegoFormBtnActualizar": "更新信息",
  "juegoFormNombreObligatorio": "游戏名称为必填项",
  "juegoFormNoBusqueda": "请输入名称以进行搜索",
  "juegoFormSinResultadosSteam": "未在 Steam 上找到相关结果",
  "juegoFormSinResultadosEpic": "未在 Epic Games 上找到相关结果",
  "juegoFormSinResultadosIgdb": "未在 IGDB 上找到相关结果",
  "juegoFormSinResultadosF95": "未在 F95Zone 上找到相关结果",
  "juegoFormErrorDetalles": "无法获取详细信息",
  "juegoFormResultadosSteam": "Steam 搜索结果",
  "juegoFormResultadosEpic": "Epic Games 搜索结果",
  "juegoFormResultadosIgdb": "IGDB 搜索结果",
  "juegoFormResultadosF95": "F95Zone 搜索结果",
  "juegoFormAgregado": "游戏成功添加到库中",
  "juegoFormActualizado": "游戏信息更新成功",
  "juegoFormEliminado": "游戏删除成功",

  "igdbTitulo": "IGDB",
  "igdbConfiguradoTitulo": "IGDB 已配置",
  "igdbConfiguradoDescripcion": "凭据已保存在本地。现在可以在添加游戏时使用 IGDB 搜索。",
  "igdbEliminarCredenciales": "清除凭据",
  "igdbConfigurarTitulo": "配置 IGDB",
  "igdbDescripcion": "IGDB 是由 Twitch 运营的官方游戏数据库。它是完全免费的，涵盖了几乎所有的主流游戏。",
  "igdbInstrucciones": "如何获取凭据？\n1. 访问 dev.twitch.tv\n2. 使用你的 Twitch 账号登录\n3. 创建一个新应用（名称任意）\n4. 复制生成的 Client-ID 并创建 Client-Secret",
  "igdbClientId": "Client-ID",
  "igdbClientSecret": "Client-Secret",
  "igdbGuardarVerificar": "保存并验证",
  "igdbCamposObligatorios": "请填写两个输入框",
  "igdbCredencialesInvalidas": "凭据无效，请检查你输入的数据。",
  "igdbConfiguradoOk": "IGDB 成功配置完成",
  "igdbNecesitaConfiguracion": "需要先配置 IGDB 接口。",

  "f95Titulo": "F95Zone",
  "f95SesionActivaTitulo": "会话处于活动状态",
  "f95SesionActivaDescripcion": "登录 Cookie 已安全保存在此设备中。现在可以使用 F95Zone 搜索功能。",
  "f95CerrarSesion": "退出登录",
  "f95SesionCerrada": "会话已关闭",
  "f95ConectarTitulo": "连接到 F95Zone",
  "f95ConectarDescripcion": "你的凭据仅用于直接登录官方平台。Cookie 将保存在你本地设备中。",
  "f95Usuario": "F95Zone 用户名",
  "f95Password": "密码",
  "f95IniciarSesion": "登录",
  "f95CamposObligatorios": "请输入用户名和密码",
  "f95SesionOk": "成功登录 F95Zone",
  "f95ErrorSesion": "登录失败，请检查你的账号和密码。",
  "f95NecesitaSesion": "请先登录你的 F95Zone 账号。",

  "apiPerfilCreadoOk": "档案创建成功",
  "apiNombreDuplicado": "该用户名已存在",
  "apiPasswordIncorrecta": "密码错误",
  "apiPerfilActualizadoOk": "档案更新成功",
  "apiNombreEnUso": "该名称已被使用",
  "apiPerfilEliminado": "档案已删除",
  "apiCategoriaCreada": "分类创建成功",
  "apiCategoriaActualizada": "分类更新成功",
  "apiBackupArchivoInvalido": "无效的备份文件",
  "apiBackupRestaurado": "备份还原成功：已导入 {perfiles} 个档案，{categorias} 个分类，{juegos} 个游戏",
  "@apiBackupRestaurado": {
    "placeholders": {
      "perfiles": { "type": "int" },
      "categorias": { "type": "int" },
      "juegos": { "type": "int" }
    }
  }
}
```

