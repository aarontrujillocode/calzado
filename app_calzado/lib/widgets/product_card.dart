import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:app_calzado/models/product_model.dart';
import 'package:app_calzado/services/favorites_service.dart';
import 'package:app_calzado/screens/home/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final bool tieneStock = product.stockTotal > 0;

    return ListenableBuilder(
      listenable: FavoritesService.instance,
      builder: (context, _) {
        final isFav = FavoritesService.instance.isFavorite(product.id);

        return InkWell(
          onTap: tieneStock
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(product: product),
                    ),
                  );
                }
              : null,
          borderRadius: BorderRadius.circular(12),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: CachedNetworkImage(
                          key: ValueKey('img_${product.id}_${product.imagen}'),
                          imageUrl: product.imagen.isNotEmpty
                              ? product.imagen
                              : 'https://via.placeholder.com/150',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: const Color(0xFFF7FAFC),
                            child: const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: const Color(0xFFF7FAFC),
                            child: const Icon(
                              Icons.broken_image_rounded,
                              color: Color(0xFFA0AEC0),
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                      // BOTÓN DE CORAZÓN / FAVORITO
                      Positioned(
                        top: 6,
                        right: 6,
                        child: GestureDetector(
                          onTap: () {
                            FavoritesService.instance.toggleFavorite(product);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFav ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                              color: isFav ? Colors.red : const Color(0xFFCBD5E0),
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                      if (!tieneStock)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'AGOTADO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.nombre,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: tieneStock ? Colors.black : Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'S/ ${product.precio.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: tieneStock ? const Color(0xFFFF4B3E) : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}