import 'package:flutter/material.dart';
import 'package:app_calzado/models/cart_item_model.dart';
import 'package:app_calzado/services/cart_service.dart';
import 'package:app_calzado/screens/auth/order_success_screen.dart';
import 'package:app_calzado/services/api_service.dart';
import 'package:app_calzado/services/orders_service.dart'; // <--- Importante para actualizar los pedidos
import 'package:app_calzado/models/user_model.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> items;
  final double subtotal;
  final UserModel? currentUser;

  const CheckoutScreen({
    super.key,
    required this.items,
    required this.subtotal,
    this.currentUser,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'card';
  bool _isProcessing = false;
  final double shippingFee = 10.0;

  void _confirmPayment() async {
    setState(() => _isProcessing = true);

    final double totalCalculado = widget.subtotal + shippingFee;
    
    // Obtenemos el ID real del usuario logueado (si es null, usa 1 por seguridad)
    final int usuarioId = widget.currentUser?.id ?? 1; 

    // 1. Enviar pedido al servidor PHP para registrar en MySQL y descontar stock
    bool exitoBD = await ApiService.createOrder(
      usuarioId: usuarioId,
      total: totalCalculado,
      items: widget.items,
    );

    if (!exitoBD) {
      if (!mounted) return;
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al procesar la compra en el servidor'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // 2. Sincronizar el historial de pedidos de este usuario inmediatamente desde MySQL
    await OrdersService.instance.fetchOrders(usuarioId);

    // 3. Vaciar el carrito de compras
    CartService.instance.clearCart();

    if (!mounted) return;

    // 4. Navegar a la pantalla de éxito
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSuccessScreen(
          orderCode: 'STP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          items: widget.items,
          subtotal: widget.subtotal,
          shippingFee: shippingFee,
          discount: 0.0,
          total: totalCalculado,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F2546);
    const accentColor = Color(0xFFFF4B3E);
    final total = widget.subtotal + shippingFee;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Finalizar Compra'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isProcessing
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(color: accentColor),
                  SizedBox(height: 20),
                  Text(
                    'Procesando tu pago...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Método de Pago', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          activeColor: primaryColor,
                          title: const Text('Tarjeta de Crédito / Débito'),
                          secondary: const Icon(Icons.credit_card),
                          value: 'card',
                          groupValue: _selectedPaymentMethod,
                          onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
                        ),
                        const Divider(height: 1),
                        RadioListTile<String>(
                          activeColor: primaryColor,
                          title: const Text('Yape / Plin'),
                          secondary: const Icon(Icons.phone_android),
                          value: 'wallet',
                          groupValue: _selectedPaymentMethod,
                          onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Resumen del Pedido', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Subtotal'),
                              Text('S/ ${widget.subtotal.toStringAsFixed(2)}'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Envío'),
                              Text('S/ ${shippingFee.toStringAsFixed(2)}'),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total a pagar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(
                                'S/ ${total.toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: accentColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _isProcessing ? null : _confirmPayment,
              child: Text(
                'PAGAR S/ ${total.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}