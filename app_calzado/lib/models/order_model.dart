import 'cart_item_model.dart';
import 'product_model.dart';

class OrderModel {
  final String id;
  final String fecha;
  final double total;
  final String estado;
  final List<CartItem> items;

  OrderModel({
    required this.id,
    required this.fecha,
    required this.total,
    required this.estado,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // 1. Obtenemos la lista cruda que viene del JSON de la API
    var rawItems = json['items'] as List? ?? [];

    // 2. Mapeamos cada elemento convirtiéndolo en un CartItem con su respectivo Product
    List<CartItem> parsedItems = rawItems.map((itemJson) {
      final productData = itemJson['product'] ?? {};
      final product = Product.fromJson(productData);
      
      return CartItem(
        product: product,
        cantidad: int.tryParse(itemJson['cantidad'].toString()) ?? 1,
        talla: itemJson['talla']?.toString() ?? '',
      );
    }).toList();

    return OrderModel(
      id: json['id']?.toString() ?? 'STP-0248',
      fecha: json['fecha']?.toString() ?? 'Reciente',
      total: (json['total'] is num)
          ? (json['total'] as num).toDouble()
          : double.tryParse(json['total']?.toString() ?? '0.0') ?? 0.0,
      estado: json['estado'] ?? 'En preparación',
      items: parsedItems, // <--- Asignamos la lista ya procesada
    );
  }
}