import 'package:flutter/material.dart';
import 'package:app_calzado/models/cart_item_model.dart';
import 'package:app_calzado/services/cart_service.dart';
import 'package:app_calzado/screens/auth/login_screen.dart';
import 'package:app_calzado/screens/catalog/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  final bool isLoggedIn;
  final Function(dynamic)? onLoginSuccess;

  const CartScreen({
    super.key,
    this.isLoggedIn = false,
    this.onLoginSuccess,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cartService = CartService.instance;
  bool _localIsLoggedIn = false;

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

  void _goToCheckout() {
    final itemsPurchased = List<CartItem>.from(cartService.items);
    final subtotal = cartService.totalAmount;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          items: itemsPurchased,
          subtotal: subtotal,
        ),
      ),
    );
  }

  void _handleCheckout() {
    final hasSession = widget.isLoggedIn || _localIsLoggedIn;

    if (!hasSession) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Inicio de sesión requerido', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text(
            'Debes iniciar sesión para procesar tu compra y asociar el pedido a tu cuenta.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F2546),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.pop(context);
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(
                      onLoginSuccess: (user) {
                        if (widget.onLoginSuccess != null) {
                          widget.onLoginSuccess!(user);
                        }
                        if (mounted) {
                          setState(() {
                            _localIsLoggedIn = true;
                          });
                        }
                        Navigator.pop(context);
                        _goToCheckout();
                      },
                    ),
                  ),
                );
              },
              child: const Text('Iniciar Sesión', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      _goToCheckout();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          onPressed: _handleCheckout,
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