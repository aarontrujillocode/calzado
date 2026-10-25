import 'package:flutter/material.dart';
import '../models/order_model.dart';
import 'api_service.dart';

class OrdersService extends ChangeNotifier {
  static final OrdersService instance = OrdersService._internal();
  OrdersService._internal();

  List<OrderModel> _orders = [];

  List<OrderModel> get orders => List.unmodifiable(_orders);
  int get orderCount => _orders.length;

  // Método para consultar los pedidos del usuario directamente desde MySQL
  Future<void> fetchOrders(int userId) async {
    _orders = await ApiService.getOrders(userId);
    notifyListeners();
  }

  // Método por si añades pedidos de forma local temporal
  void addOrder(OrderModel order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }
}