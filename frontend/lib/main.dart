import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/perfiles_screen.dart';
import 'screens/home_screen.dart';
import 'services/api_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frontend/l10n/app_localizations.dart';

/// Colores de superficie propios de Feed95.
/// Representa una superficie "elevada" (AppBar, tarjetas de lista, chips)
class SuperficiesFeed95 extends ThemeExtension<SuperficiesFeed95> {
  final Color superficieElevada;
  final Color superficieElevadaBorde;
  final Color textoSobreSuperficieElevada;

  const SuperficiesFeed95({
    required this.superficieElevada,
    required this.superficieElevadaBorde,
    required this.textoSobreSuperficieElevada,
  });

  @override
  SuperficiesFeed95 copyWith({
    Color? superficieElevada,
    Color? superficieElevadaBorde,
    Color? textoSobreSuperficieElevada,
  }) {
    return SuperficiesFeed95(
      superficieElevada: superficieElevada ?? this.superficieElevada,
      superficieElevadaBorde:
          superficieElevadaBorde ?? this.superficieElevadaBorde,
      textoSobreSuperficieElevada:
          textoSobreSuperficieElevada ?? this.textoSobreSuperficieElevada,
    );
  }

  @override
  SuperficiesFeed95 lerp(ThemeExtension<SuperficiesFeed95>? other, double t) {
    if (other is! SuperficiesFeed95) return this;
    return SuperficiesFeed95(
      superficieElevada: Color.lerp(
        superficieElevada,
        other.superficieElevada,
        t,
      )!,
      superficieElevadaBorde: Color.lerp(
        superficieElevadaBorde,
        other.superficieElevadaBorde,
        t,
      )!,
      textoSobreSuperficieElevada: Color.lerp(
        textoSobreSuperficieElevada,
        other.textoSobreSuperficieElevada,
        t,
      )!,
    );
  }
}

// Tema claro: fondo F7F7F5, superficie levemente MÁS OSCURA que ese fondo.
const superficiesFeed95Claro = SuperficiesFeed95(
  superficieElevada: Color(0xFFEAEAE7),
  superficieElevadaBorde: Color(0xFFD8D8D4),
  textoSobreSuperficieElevada: Color(0xFF1A1A1A),
);

// Tema oscuro: fondo 121212, superficie levemente MÁS OSCURA que ese fondo
const superficiesFeed95Oscuro = SuperficiesFeed95(
  superficieElevada: Color(0xFF0A0A0A),
  superficieElevadaBorde: Color(0xFF1E1E1E),
  textoSobreSuperficieElevada: Colors.white,
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
          surface: const Color(0xFFF7F7F5),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F7F5),
        appBarTheme: AppBarTheme(
          backgroundColor: superficiesFeed95Claro.superficieElevada,
          foregroundColor: superficiesFeed95Claro.textoSobreSuperficieElevada,
          elevation: 0,
        ),
        extensions: const [superficiesFeed95Claro],
        cardTheme: const CardThemeData(
          // Recordatorio: Cambiar estos colores para emparejarlos con los de la superficie elevada.
          color: Color(0xFFEAEAE7),
        ), // antes: Colors.white
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
          backgroundColor: superficiesFeed95Oscuro.superficieElevada,
          foregroundColor: superficiesFeed95Oscuro.textoSobreSuperficieElevada,
          elevation: 0,
        ),
        extensions: const [superficiesFeed95Oscuro],
        cardTheme: const CardThemeData(
          // Recordatorio: Cambiar estos colores para emparejarlos con los de la superficie elevada.
          color: Color(0xFF0A0A0A),
        ),
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
