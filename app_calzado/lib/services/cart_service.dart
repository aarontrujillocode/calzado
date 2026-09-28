import 'package:flutter/material.dart';
import 'package:app_calzado/models/cart_item_model.dart';
import 'package:app_calzado/models/product_model.dart';

class CartService extends ChangeNotifier {
  static final CartService instance = CartService._internal();
  factory CartService() => instance;
  CartService._internal();

  final List<CartItem> _items = [];
  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold<int>(0, (sum, item) => sum + item.cantidad);
  double get totalAmount => _items.fold<double>(0.0, (sum, item) => sum + item.subtotal);

  void addProduct(Product product, String talla, {int cantidad = 1}) {
    final index = _items.indexWhere(
      (item) => item.product.id == product.id && item.talla == talla,
    );

    if (index >= 0) {
      _items[index].cantidad += cantidad;
    } else {
      _items.add(CartItem(
        product: product,
        talla: talla,
        cantidad: cantidad,
      ));
    }
    notifyListeners();
  }

  void updateQuantity(CartItem item, int newQuantity) {
    if (newQuantity <= 0) {
      _items.remove(item);
    } else {
      item.cantidad = newQuantity;
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}