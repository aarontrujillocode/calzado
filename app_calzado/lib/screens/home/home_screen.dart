import 'package:flutter/material.dart';
import 'package:app_calzado/models/product_model.dart';
import 'package:app_calzado/services/api_service.dart';
import 'package:app_calzado/screens/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  int selectedCategoryIndex = 0;
  final List<String> categories = ['Todos', 'Hombres', 'Mujeres', 'Infantil'];
  late Future<List<Product>> _futureProducts;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _futureProducts = ApiService.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    const primaryBlue = Color(0xFF0F2042);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // CABECERA AZUL CON CURVA
            Container(
              decoration: const BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  child: Column(
                    children: [
                      // LOGO Y CARRITO
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF384967),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Image.asset(
                                  'lib/assets/icono1.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.do_not_step,
                                      color: Colors.white,
                                      size: 22,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'StepUp',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 24),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // CAMPO DE BÚSQUEDA
                      Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(23),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Buscar calzado...',
                            hintStyle: TextStyle(color: Color(0xFFA0AEC0), fontSize: 14),
                            prefixIcon: Icon(Icons.search, color: Color(0xFFA0AEC0)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // BANNER PROMOCIONAL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1552346154-21d32810aba3?w=800&q=80'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'VELOCITY\nBLUE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'HIGH-PERFORMANCE\nENERGY RETURN',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1D52D8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            minimumSize: const Size(0, 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'SHOP NOW',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // INDICADORES DEL BANNER
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 18,
                  height: 6,
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFFCBD5E0),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFFCBD5E0),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // CATEGORÍAS EN CHIPS
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedCategoryIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => selectedCategoryIndex = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? primaryBlue : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? primaryBlue : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF4A5568),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // GRILLA DE PRODUCTOS DINÁMICA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FutureBuilder<List<Product>>(
                future: _futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: Text('No hay productos disponibles')),
                    );
                  }

                  final allProducts = snapshot.data!;
                  final selectedCategory = categories[selectedCategoryIndex];

                  final filteredProducts = selectedCategory == 'Todos'
                      ? allProducts
                      : allProducts.where((p) {
                          final catProd = p.categoria.trim().toLowerCase();
                          final catSel = selectedCategory.trim().toLowerCase();
                          return catProd == catSel;
                        }).toList();

                  if (filteredProducts.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: Text('No hay productos en esta categoría')),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.58,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      // SE AGREGA LA KEY ÚNICA POR PRODUCTO AQUÍ
                      return ProductCardHomeWidget(
                        key: ValueKey('prod_${product.id}_${product.categoria}'),
                        product: product,
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ProductCardHomeWidget extends StatefulWidget {
  final Product product;

  const ProductCardHomeWidget({
    super.key,
    required this.product,
  });

  @override
  State<ProductCardHomeWidget> createState() => _ProductCardHomeWidgetState();
}

class _ProductCardHomeWidgetState extends State<ProductCardHomeWidget> {
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    final bool tieneStock = widget.product.stockTotal > 0;

    return GestureDetector(
      onTap: tieneStock
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: widget.product),
                ),
              );
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFEDF2F7)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ESTRELLAS Y FAVORITO
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < 4 ? Icons.star_rounded : Icons.star_half_rounded,
                      color: const Color(0xFFFFB800),
                      size: 14,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isFav = !isFav;
                    });
                  },
                  child: Icon(
                    Icons.favorite_rounded,
                    color: isFav ? Colors.red : const Color(0xFFCBD5E0),
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // IMAGEN OPTIMIZADA PARA FLUTTER WEB / WEBGL
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.product.imagen.isNotEmpty
                          ? widget.product.imagen
                          : 'https://via.placeholder.com/300',
                      key: ValueKey('img_${widget.product.id}'),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      gaplessPlayback: true, // EVITA PARPADEO Y ERRORES DE TEXTURA AL CAMBIAR DE PESTAÑA
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: const Color(0xFFF7FAFC),
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFF7FAFC),
                        child: const Icon(
                          Icons.broken_image_rounded,
                          color: Color(0xFFA0AEC0),
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  if (!tieneStock)
                    Positioned(
                      top: 6,
                      right: 6,
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
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // SUBCATEGORÍA
            Text(
              widget.product.subcategoria.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color(0xFFA0AEC0),
              ),
            ),
            const SizedBox(height: 2),

            // NOMBRE DEL PRODUCTO
            Text(
              widget.product.nombre,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: tieneStock ? const Color(0xFF1A202C) : Colors.grey,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // PRECIO
            Text(
              'S/ ${widget.product.precio.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: tieneStock ? const Color(0xFF0F2042) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}