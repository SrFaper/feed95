import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/perfiles_screen.dart';
import 'screens/home_screen.dart';
import 'services/api_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frontend/l10n/app_localizations.dart';

/// Colores de superficie propios de Feed95 que no vienen en el ColorScheme
/// estándar de Material. Al estar centralizados aquí, cambiarlos una vez
/// los actualiza en AppBar, tarjetas de lista y selectores de color, sin tener que tocar cada widget individualmente.
class SuperficiesFeed95 extends ThemeExtension<SuperficiesFeed95> {
  final Color superficieOscura;
  final Color superficieOscuraBorde;
  final Color textoSobreSuperficieOscura;

  const SuperficiesFeed95({
    required this.superficieOscura,
    required this.superficieOscuraBorde,
    required this.textoSobreSuperficieOscura,
  });

  @override
  SuperficiesFeed95 copyWith({
    Color? superficieOscura,
    Color? superficieOscuraBorde,
    Color? textoSobreSuperficieOscura,
  }) {
    return SuperficiesFeed95(
      superficieOscura: superficieOscura ?? this.superficieOscura,
      superficieOscuraBorde:
          superficieOscuraBorde ?? this.superficieOscuraBorde,
      textoSobreSuperficieOscura:
          textoSobreSuperficieOscura ?? this.textoSobreSuperficieOscura,
    );
  }

  @override
  SuperficiesFeed95 lerp(ThemeExtension<SuperficiesFeed95>? other, double t) {
    if (other is! SuperficiesFeed95) return this;
    return SuperficiesFeed95(
      superficieOscura: Color.lerp(
        superficieOscura,
        other.superficieOscura,
        t,
      )!,
      superficieOscuraBorde: Color.lerp(
        superficieOscuraBorde,
        other.superficieOscuraBorde,
        t,
      )!,
      textoSobreSuperficieOscura: Color.lerp(
        textoSobreSuperficieOscura,
        other.textoSobreSuperficieOscura,
        t,
      )!,
    );
  }
}

// dos constantes por dos instancias distintas (una en `theme`, otra en `darkTheme`).
const superficiesFeed95 = SuperficiesFeed95(
  superficieOscura: Color(0xFF1C1C1C),
  superficieOscuraBorde: Color(0xFF2E2E2E),
  textoSobreSuperficieOscura: Colors.white,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PaintingBinding.instance.imageCache.maximumSizeBytes = 75 * 1024 * 1024;

  // Máximo de entradas en cache (independiente del límite de bytes).
  // 150 es suficiente para un grid denso con buffer de precargado.
  PaintingBinding.instance.imageCache.maximumSize = 150;

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
      // locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale != null) {
          for (final supported in supportedLocales) {
            if (supported.languageCode == locale.languageCode) {
              return supported;
            }
          }
        }
        return const Locale(
          'en',
        ); // fallback explícito y a prueba de cambios futuros
      },
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: _accentColor,
          secondary: _accentColor,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: superficiesFeed95.superficieOscura,
          foregroundColor: superficiesFeed95.textoSobreSuperficieOscura,
          elevation: 0,
        ),
        extensions: const [superficiesFeed95],
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
        appBarTheme: AppBarTheme(
          backgroundColor: superficiesFeed95.superficieOscura,
          foregroundColor: superficiesFeed95.textoSobreSuperficieOscura,
          elevation: 0,
        ),
        extensions: const [superficiesFeed95],
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
