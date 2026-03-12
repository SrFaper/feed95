import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const Feed95App());
}

class Feed95App extends StatelessWidget {
  const Feed95App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feed95',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}