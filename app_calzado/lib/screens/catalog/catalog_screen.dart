import 'package:flutter/material.dart';
import 'package:app_calzado/models/product_model.dart';
import 'package:app_calzado/services/api_service.dart';
import 'package:app_calzado/services/cart_service.dart';
import 'package:app_calzado/services/favorites_service.dart';
import 'package:app_calzado/screens/auth/cart_screen.dart';
import 'package:app_calzado/screens/favorites/favorites_screen.dart';
import 'package:app_calzado/screens/home/product_detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late Future<List<Product>> _futureProducts;
  String selectedSubCategory = 'Zapatillas';

  @override
  void initState() {
    super.initState();
    _futureProducts = ApiService.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F2042);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 24),
                onPressed: () {},
              ),
              Row(
                children: [
                  // BOTÓN DE FAVORITOS
                  IconButton(
                    icon: const Icon(Icons.favorite_outline, color: Colors.white, size: 24),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white, size: 24),
                    onPressed: () {},
                  ),
                  ListenableBuilder(
                    listenable: CartService.instance,
                    builder: (context, _) {
                      final count = CartService.instance.itemCount;
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 24),
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
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text(
                'No hay productos disponibles en la base de datos',
                style: TextStyle(color: Color(0xFF8C98A4)),
              ),
            );
          }

          final List<Product> allProducts = snapshot.data!;

          if (allProducts.isEmpty) {
            return const Center(
              child: Text(
                'No hay productos disponibles',
                style: TextStyle(color: Color(0xFF8C98A4)),
              ),
            );
          }

          final filteredProducts = allProducts.where((p) {
            final subCatProd = p.subcategoria.trim().toLowerCase();
            final subCatSel = selectedSubCategory.trim().toLowerCase();
            return subCatProd == subCatSel || subCatProd.contains(subCatSel);
          }).toList();

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Calzado de Hombre',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F2042),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${filteredProducts.length} Productos',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8C98A4),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Categoría',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F2042),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: ['Zapatillas', 'Vestir', 'Sandalias'].map((cat) {
                    final isSelected = selectedSubCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => selectedSubCategory = cat),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? primaryColor : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? primaryColor : const Color(0xFFCBD5E0),
                            ),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF4A5568),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                filteredProducts.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            'No hay productos para esta categoría',
                            style: TextStyle(color: Color(0xFF8C98A4)),
                          ),
                        ),
                      )
                    : ListenableBuilder(
                        listenable: FavoritesService.instance,
                        builder: (context, _) {
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredProducts.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.65,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
                              final isFav = FavoritesService.instance.isFavorite(product.id);

                              final String marcaTexto = product.marca.isNotEmpty
                                  ? product.marca.toUpperCase()
                                  : product.subcategoria.toUpperCase();

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailScreen(product: product),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: const Color(0xFFEDF2F7)),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Image.network(
                                                product.imagen.isNotEmpty
                                                    ? product.imagen
                                                    : 'https://via.placeholder.com/300',
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) => Container(
                                                  color: const Color(0xFFF7FAFC),
                                                  child: const Icon(
                                                    Icons.broken_image_rounded,
                                                    color: Color(0xFFA0AEC0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // BOTÓN CORAZÓN DE FAVORITO
                                            Positioned(
                                              top: 6,
                                              right: 6,
                                              child: GestureDetector(
                                                onTap: () {
                                                  FavoritesService.instance.toggleFavorite(product);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(0.9),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    isFav ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                                                    color: isFav ? Colors.red : const Color(0xFFCBD5E0),
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        marcaTexto,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFA0AEC0),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        product.nombre,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1A202C),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'S/ ${product.precio.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF0F2042),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}