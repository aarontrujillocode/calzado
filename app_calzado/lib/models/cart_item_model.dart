import 'package:app_calzado/models/product_model.dart';

class CartItem {
  final Product product;
  final String talla;
  int cantidad;

  CartItem({
    required this.product,
    required this.talla,
    this.cantidad = 1,
  });

  double get subtotal => product.precio * cantidad;
}