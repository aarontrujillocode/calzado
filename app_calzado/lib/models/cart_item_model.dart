import 'product_model.dart';

class CartItem {
  final Product product;
  final String talla;
  int cantidad;

  CartItem({
    required this.product,
    required this.talla,
    this.cantidad = 1,
  });

  // Getter necesario para cart_service.dart
  double get subtotal => product.precio * cantidad;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] ?? {}),
      talla: json['talla'] ?? '',
      cantidad: json['cantidad'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'talla': talla,
      'cantidad': cantidad,
    };
  }
}