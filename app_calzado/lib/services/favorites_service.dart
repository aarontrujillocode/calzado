import 'package:flutter/material.dart';
import 'package:app_calzado/models/product_model.dart';

class FavoritesService extends ChangeNotifier {
  FavoritesService._internal();
  static final FavoritesService instance = FavoritesService._internal();

  final List<Product> _favoriteItems = [];

  List<Product> get favorites => List.unmodifiable(_favoriteItems);

  bool isFavorite(int productId) {
    return _favoriteItems.any((item) => item.id == productId);
  }

  void toggleFavorite(Product product) {
    final exists = isFavorite(product.id);
    if (exists) {
      _favoriteItems.removeWhere((item) => item.id == product.id);
    } else {
      _favoriteItems.add(product);
    }
    notifyListeners();
  }
}