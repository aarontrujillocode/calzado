import 'package:flutter/material.dart';
import 'package:app_calzado/models/cart_item_model.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderCode;
  final List<CartItem> items;
  final double subtotal;
  final double shippingFee;
  final double discount;
  final double total;
  final dynamic currentUser;

  const OrderSuccessScreen({
    super.key,
    required this.orderCode,
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.discount,
    required this.total,
    this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F2546);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('pago'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey[700],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Column(
          children: [
            // Logo StepUp
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.directions_run, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 8),
                const Text(
                  'StepUp',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Icono de Check Verde
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFFD1FADF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Color(0xFF12B76A), size: 40),
            ),
            const SizedBox(height: 16),

            // Título
            const Text(
              '¡Compra exitosa!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tu pago ha sido procesado correctamente.',
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 16),

            // Badge Código de Pedido
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'PEDIDO #$orderCode',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF344054),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Lista de productos comprados
            ...items.map((item) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFEAECF0)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          item.product.imagen.isNotEmpty
                              ? item.product.imagen
                              : 'https://via.placeholder.com/100',
                          width: 65,
                          height: 65,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 65,
                            height: 65,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product.nombre,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Talla ${item.talla}',
                              style: const TextStyle(color: Colors.black45, fontSize: 13),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Cantidad: ${item.cantidad}',
                              style: const TextStyle(color: Colors.black45, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'S/ ${(item.product.precio * item.cantidad).toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: 16),

            // Resumen de pago
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEAECF0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Resumen de pago',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryRow('Subtotal', 'S/ ${subtotal.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Envío', 'S/ ${shippingFee.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Descuento', '-S/ ${discount.toStringAsFixed(2)}'),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text(
                        'S/ ${total.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Icon(Icons.local_shipping_outlined, size: 18, color: Colors.black54),
                      SizedBox(width: 8),
                      Text('Entrega estimada', style: TextStyle(color: Colors.black54, fontSize: 13)),
                      Spacer(),
                      Text('2-4 días hábiles', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Botones de Acción
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () {
                  // Redirige al inicio limpiando el stack de pantallas
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('VER MI PEDIDO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text(
                'VOLVER AL INICIO',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54, fontSize: 14)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
      ],
    );
  }
}