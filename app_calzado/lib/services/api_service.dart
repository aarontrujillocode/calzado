import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../models/order_model.dart';

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

  // --- OBTENER HISTORIAL DE PEDIDOS DESDE MYSQL ---
  static Future<List<OrderModel>> getOrders(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?action=get_orders&usuario_id=$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          List<dynamic> list = data['pedidos'];
          return list.map((item) => OrderModel.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e) {
      if (kDebugMode) print('Error en getOrders: $e');
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

  // --- CREAR PEDIDO Y DESCONTAR STOCK EN MYSQL ---
  static Future<bool> createOrder({
    required int usuarioId,
    required double total,
    required List<dynamic> items,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl?action=create_order'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuario_id': usuarioId,
          'total': total,
          'items': items.map((item) => {
            'producto_id': item.product.id,
            'cantidad': item.cantidad,
            'precio': item.product.precio,
            'talla': item.talla,
          }).toList(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'success';
      }
      return false;
    } catch (e) {
      if (kDebugMode) print('Error en createOrder: $e');
      return false;
    }
  }

  // --- GESTIÓN DE ADMINISTRADOR: OBTENER TODOS LOS PEDIDOS ---
  static Future<List<dynamic>> getAdminOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?action=get_admin_orders'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return data['pedidos'];
        }
      }
      return [];
    } catch (e) {
      if (kDebugMode) print('Error en getAdminOrders: $e');
      return [];
    }
  }

  // --- GESTIÓN DE ADMINISTRADOR: ACTUALIZAR ESTADO DE PEDIDO ---
  static Future<bool> updateOrderStatus(int orderId, String nuevoEstado) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl?action=update_order_status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'pedido_id': orderId,
          'estado': nuevoEstado,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'success';
      }
      return false;
    } catch (e) {
      if (kDebugMode) print('Error en updateOrderStatus: $e');
      return false;
    }
  }

  // --- GESTIÓN DE ADMINISTRADOR: OBTENER TODOS LOS CLIENTES ---
  static Future<List<dynamic>> getAdminUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?action=get_admin_users'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return data['usuarios'];
        }
      }
      return [];
    } catch (e) {
      if (kDebugMode) print('Error en getAdminUsers: $e');
      return [];
    }
  }

  // --- GESTIÓN DE ADMINISTRADOR: OBTENER REPORTE DE VENTAS ---
  static Future<Map<String, dynamic>> getAdminSales() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?action=get_admin_sales'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return data;
        }
      }
      return {'total_ingresos': 0.0, 'total_ventas': 0, 'ventas': []};
    } catch (e) {
      if (kDebugMode) print('Error en getAdminSales: $e');
      return {'total_ingresos': 0.0, 'total_ventas': 0, 'ventas': []};
    }
  }

  // --- GESTIÓN DE ADMINISTRADOR: CREAR PRODUCTO ---
  static Future<bool> addProduct(Map<String, dynamic> productData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl?action=add_product'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(productData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'success';
      }
      return false;
    } catch (e) {
      if (kDebugMode) print('Error en addProduct: $e');
      return false;
    }
  }

  // --- GESTIÓN DE ADMINISTRADOR: ACTUALIZAR PRODUCTO ---
  static Future<bool> updateProduct(Map<String, dynamic> productData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl?action=update_product'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(productData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'success';
      }
      return false;
    } catch (e) {
      if (kDebugMode) print('Error en updateProduct: $e');
      return false;
    }
  }

  // --- GESTIÓN DE ADMINISTRADOR: ELIMINAR PRODUCTO ---
  static Future<bool> deleteProduct(int productId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl?action=delete_product'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': productId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'success';
      }
      return false;
    } catch (e) {
      if (kDebugMode) print('Error en deleteProduct: $e');
      return false;
    }
  }
}