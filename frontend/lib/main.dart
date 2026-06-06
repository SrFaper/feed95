import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/perfiles_screen.dart';
import 'screens/home_screen.dart';
import 'services/api_service.dart';

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

  @override
  void initState() {
    super.initState();
    _cargarTema();
  }

  Future<void> _cargarTema() async {
    final prefs = await SharedPreferences.getInstance();
    final tema = prefs.getString('theme_mode') ?? 'system';
    setState(() {
      _themeMode = tema == 'dark'
          ? ThemeMode.dark
          : tema == 'light'
          ? ThemeMode.light
          : ThemeMode.system;
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

    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feed95',
      debugShowCheckedModeBanner: false,

      // Usa el tema seleccionado por el usuario:
      // ThemeMode.system = sigue Windows/Android
      // ThemeMode.light = siempre claro
      // ThemeMode.dark = siempre oscuro
      themeMode: _themeMode,

      // ==========================================================
      // TEMA CLARO
      // ==========================================================
      theme: ThemeData(
        useMaterial3: true,

        colorScheme: const ColorScheme.light(

          // Color principal de la aplicación.
          // Botones, switches, controles activos, etc.
          primary: Color.fromARGB(255, 255, 54, 71),

          // Color secundario utilizado en algunos widgets.
          secondary: Color.fromARGB(255, 255, 54, 71),

          // Color de tarjetas, dialogs y superficies elevadas.
          surface: Colors.white,
        ),

        // Fondo general de todas las pantallas.
        scaffoldBackgroundColor: Colors.white,

        // Barra superior (AppBar).
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),

        // Tarjetas (Card).
        cardTheme: const CardThemeData(
          color: Colors.white,
        ),

        // Botones elevados (ElevatedButton).
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(

            // Fondo del botón.
            backgroundColor: Color.fromARGB(255, 255, 54, 71),

            // Texto e iconos del botón.
            foregroundColor: Colors.white,
          ),
        ),

        // Campos de texto (TextField).
        inputDecorationTheme: InputDecorationTheme(

          // Borde normal.
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          // Borde cuando tiene foco.
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 255, 54, 71),
              width: 2,
            ),
          ),
        ),
      ),

      // ==========================================================
      // TEMA OSCURO
      // ==========================================================
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,

        // Fondo principal de la aplicación.
        // Similar al modo oscuro que usa ChatGPT.
        scaffoldBackgroundColor: const Color(0xFF121212),

        colorScheme: const ColorScheme.dark(

          // Color de acento principal.
          // Botones, sliders, switches, etc.
          primary: Color.fromARGB(255, 255, 54, 71),

          // Segundo color de acento.
          secondary: Color.fromARGB(255, 255, 54, 71),

          // Color de tarjetas y superficies elevadas.
          surface: Color(0xFF222222),
        ),

        // Barra superior.
        appBarTheme: const AppBarTheme(

          // Fondo de la AppBar.
          backgroundColor: Color(0xFF1E1E1E),

          // Color del texto e iconos.
          foregroundColor: Colors.white,

          elevation: 0,
        ),

        // Tarjetas (Card).
        cardTheme: const CardThemeData(

          // Fondo de las tarjetas.
          color: Color(0xFF262626),
        ),

        // Botones elevados.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(

            // Fondo rojo fuerte.
            backgroundColor: Color.fromARGB(255, 255, 54, 71),

            // Texto blanco.
            foregroundColor: Colors.white,
          ),
        ),

        // Campos de texto.
        inputDecorationTheme: InputDecorationTheme(

          // Borde normal.
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          // Borde cuando tiene foco.
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 255, 54, 71),
              width: 2,
            ),
          ),
        ),

        // Color del divisor entre elementos.
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
