import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1/calzado/api.php';

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl?action=login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {
        'status': 'error',
        'message': 'Error en el servidor (${response.statusCode})'
      };
    } catch (e) {
      if (kDebugMode) print('Error en login: $e');
      return {
        'status': 'error',
        'message': 'No se pudo conectar al servidor. Revisa tu conexión'
      };
    }
  }

  static Future<Map<String, dynamic>> register(
      String nombre, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl?action=register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombre,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {
        'status': 'error',
        'message': 'Error en el servidor (${response.statusCode})'
      };
    } catch (e) {
      if (kDebugMode) print('Error en register: $e');
      return {
        'status': 'error',
        'message': 'No se pudo conectar al servidor'
      };
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    required int id,
    required String nombre,
    required String email,
    required String telefono,
    required String fechaNacimiento,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl?action=update_profile'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
          'nombre': nombre,
          'email': email,
          'telefono': telefono,
          'fecha_nacimiento': fechaNacimiento,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {
        'status': 'error',
        'message': 'Error en el servidor (${response.statusCode})'
      };
    } catch (e) {
      if (kDebugMode) print('Error en updateProfile: $e');
      return {
        'status': 'error',
        'message': 'No se pudo conectar al servidor'
      };
    }
  }
}