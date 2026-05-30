import 'package:flutter/material.dart';

class F95ConfigScreen extends StatelessWidget {
  const F95ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('F95Zone')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 48),
            SizedBox(height: 12),
            Text(
              'F95Zone activo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'La búsqueda en F95Zone funciona sin necesidad de cuenta. '
              'Se accede a los metadatos públicos de cada juego.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}