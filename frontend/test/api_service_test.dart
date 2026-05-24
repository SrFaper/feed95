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