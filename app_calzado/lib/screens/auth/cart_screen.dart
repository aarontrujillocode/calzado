import 'package:flutter/material.dart';
import 'package:app_calzado/services/cart_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cartService = CartService.instance;

  @override
  void initState() {
    super.initState();
    cartService.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    cartService.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // CAMBIO AQUÍ: Color azul marino correspondiente al catálogo
    const primaryColor = Color(0xFF0F2546); 
    const accentColor = Color(0xFFFF4B3E);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Carrito'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: cartService.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Tu carrito está vacío',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartService.items.length,
                    itemBuilder: (context, index) {
                      final item = cartService.items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.product.imagen.isNotEmpty
                                      ? item.product.imagen
                                      : 'https://via.placeholder.com/100',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 70,
                                    height: 70,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.broken_image),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.nombre,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Talla: ${item.talla} | S/ ${item.product.precio.toStringAsFixed(2)}',
                                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        IconButton(
                                          constraints: const BoxConstraints(),
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(Icons.remove_circle_outline),
                                          onPressed: () => cartService.updateQuantity(item, item.cantidad - 1),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Text(
                                            '${item.cantidad}',
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                          ),
                                        ),
                                        IconButton(
                                          constraints: const BoxConstraints(),
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(Icons.add_circle_outline),
                                          onPressed: () => cartService.updateQuantity(item, item.cantidad + 1),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: accentColor),
                                onPressed: () => cartService.removeItem(item),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                            'S/ ${cartService.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: accentColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('¡Pedido enviado a procesar!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          child: const Text(
                            'PROCESAR COMPRA',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}