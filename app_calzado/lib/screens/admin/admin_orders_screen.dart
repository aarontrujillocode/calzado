import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  late Future<List<dynamic>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    setState(() {
      _ordersFuture = ApiService.getAdminOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Gestión de Pedidos',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Color(0xFF2563EB)),
                onPressed: _loadOrders,
                tooltip: 'Actualizar pedidos',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar pedidos: ${snapshot.error}'));
                }

                final orders = snapshot.data ?? [];
                if (orders.isEmpty) {
                  return const Center(child: Text('No hay pedidos registrados en la base de datos.'));
                }

                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final orderId = order['id'];
                    final cliente = order['cliente_nombre'] ?? 'Cliente';
                    final email = order['cliente_email'] ?? '';
                    final total = order['total'] ?? 0.0;
                    final fecha = order['fecha'] ?? '';
                    String estado = order['estado'] ?? 'pendiente';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Pedido #$orderId', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(height: 4),
                                  Text('Cliente: $cliente ($email)', style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                                  const SizedBox(height: 4),
                                  Text('Fecha: $fecha', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                                  const SizedBox(height: 8),
                                  Text('S/ ${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF2563EB))),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(estado).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    estado,
                                    style: TextStyle(color: _getStatusColor(estado), fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                DropdownButton<String>(
                                  value: ['pendiente', 'En preparación', 'En camino', 'Entregado', 'Cancelado'].contains(estado) ? estado : 'En preparación',
                                  items: ['pendiente', 'En preparación', 'En camino', 'Entregado', 'Cancelado'].map((String val) {
                                    return DropdownMenuItem<String>(
                                      value: val,
                                      child: Text(val, style: const TextStyle(fontSize: 12)),
                                    );
                                  }).toList(),
                                  onChanged: (nuevoEstado) async {
                                    if (nuevoEstado != null && nuevoEstado != estado) {
                                      bool success = await ApiService.updateOrderStatus(orderId, nuevoEstado);
                                      if (success) {
                                        _loadOrders(); // Recarga la lista para reflejar el cambio
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'entregado':
        return Colors.green;
      case 'en camino':
        return Colors.blue;
      case 'en preparación':
        return Colors.orange;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}