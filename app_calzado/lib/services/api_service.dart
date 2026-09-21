import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart'; // Asegúrate de que el nombre coincida con tu archivo en lib/models/

class ApiService {
  static const String baseUrl = 'http://127.0.0.1/calzado/api.php';

  // --- OBTENER PRODUCTOS DE LA BASE DE DATOS ---
  static Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?action=get_products'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          List<dynamic> list = data['productos'];
          return list.map((item) => Product.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e) {
      if (kDebugMode) print('Error en getProducts: $e');
      return [];
    }
  }

  // --- AUTENTICACIÓN Y PERFIL ---
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

  // --- GESTIÓN DE DIRECCIONES ---
  static Future<List<dynamic>> getAddresses(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?action=get_addresses&usuario_id=$userId'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return data['direcciones'];
        }
      }
      return [];
    } catch (e) {
      if (kDebugMode) print('Error en getAddresses: $e');
      return [];
    }
  }

  static Future<bool> addAddress(Map<String, dynamic> addressData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl?action=add_address'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(addressData),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'success';
      }
      return false;
    } catch (e) {
      if (kDebugMode) print('Error en addAddress: $e');
      return false;
    }
  }

  static Future<bool> deleteAddress(int addressId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl?action=delete_address'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': addressId}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'success';
      }
      return false;
    } catch (e) {
      if (kDebugMode) print('Error en deleteAddress: $e');
      return false;
    }
  }
}