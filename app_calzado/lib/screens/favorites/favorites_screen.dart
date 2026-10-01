import 'package:flutter/material.dart';
import 'package:app_calzado/models/product_model.dart';
import 'package:app_calzado/services/favorites_service.dart';
import 'package:app_calzado/services/cart_service.dart';
import 'package:app_calzado/screens/auth/cart_screen.dart';
import 'package:app_calzado/screens/home/product_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  static const Color darkBlue = Color(0xFF0F2042);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: darkBlue,
        elevation: 0,
        automaticallyImplyLeading: false, // Oculta la flecha si es una pestaña principal
        title: const Text(
          'Mis favoritos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          // ICONO DE CARRITO DINÁMICO
          ListenableBuilder(
            listenable: CartService.instance,
            builder: (context, _) {
              final count = CartService.instance.itemCount;
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CartScreen()),
                      );
                    },
                  ),
                  if (count > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF4B3E),
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$count',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: FavoritesService.instance,
        builder: (context, _) {
          final favorites = FavoritesService.instance.favorites;

          if (favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    "No tienes productos favoritos aún",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: favorites.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final product = favorites[index];
              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFEDF2F7)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.imagen.isNotEmpty
                          ? product.imagen
                          : 'https://via.placeholder.com/150',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                    ),
                  ),
                  title: Text(
                    product.nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: Text(
                    'S/ ${product.precio.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: darkBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite_rounded, color: Colors.red),
                    onPressed: () {
                      FavoritesService.instance.toggleFavorite(product);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}