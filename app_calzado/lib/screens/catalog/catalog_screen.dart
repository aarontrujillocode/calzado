import 'package:flutter/material.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String selectedSubCategory = 'Zapatillas';

  final List<Map<String, dynamic>> products = [
    {
      'id': '1',
      'brand': 'ADIDAS',
      'title': 'Zapatillas Urbanas Adidas Hombres Court Base',
      'rating': 4.5,
      'originalPrice': 'S/ 199.00',
      'offerPrice': 'S/ 159.90',
      'discount': '20% OFF',
      'image': 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=600&q=80',
      'isFavorite': false,
    },
    {
      'id': '2',
      'brand': 'ADIDAS',
      'title': 'Zapatillas Running Adidas Hombres Switch Move U',
      'rating': 4.5,
      'originalPrice': 'S/ 179.00',
      'offerPrice': 'S/ 125.90',
      'discount': '30% OFF',
      'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&q=80',
      'isFavorite': false,
    },
    {
      'id': '3',
      'brand': 'ADIDAS',
      'title': 'Zapatillas Deportivas Adidas Hombre Runblaze M',
      'rating': 4.5,
      'originalPrice': null,
      'offerPrice': 'S/ 179.00',
      'discount': null,
      'image': 'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=600&q=80',
      'isFavorite': false,
    },
    {
      'id': '4',
      'brand': 'R18',
      'title': 'Zapatillas Running Adidas Hombres Galaxy 8 M',
      'rating': 4.5,
      'originalPrice': null,
      'offerPrice': 'S/ 199.00',
      'discount': null,
      'image': 'https://images.unsplash.com/photo-1584735935682-2f2b69dff9d2?w=600&q=80',
      'isFavorite': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F2042);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // BARRA AZUL SUPERIOR PERSONALIZADA (Reemplaza el AppBar estándar)
            Container(
              color: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 26),
                    onPressed: () {},
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white, size: 24),
                        onPressed: () {},
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.filter_alt_outlined, color: Colors.white, size: 24),
                            onPressed: () {},
                          ),
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFF1D52D8),
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: const Text(
                                '4',
                                textAlign: TextAlign.center,
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
                    ],
                  ),
                ],
              ),
            ),
            
            // CONTENIDO PRINCIPAL
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Calzado de Hombre',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F2042),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      '128 Productos',
                      style: TextStyle(fontSize: 13, color: Color(0xFF8C98A4)),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Categoría',
                      style: TextStyle(
                        fontSize: 13,
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
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.58,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        final item = products[index];
                        return ProductCardWidget(
                          item: item,
                          onFavoriteToggle: () {
                            setState(() {
                              item['isFavorite'] = !(item['isFavorite'] ?? false);
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCardWidget extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onFavoriteToggle;

  const ProductCardWidget({
    super.key,
    required this.item,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFav = item['isFavorite'] ?? false;
    final bool hasDiscount = item['discount'] != null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEDF2F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                onTap: onFavoriteToggle,
                child: Icon(
                  isFav ? Icons.favorite_rounded : Icons.favorite_rounded,
                  color: isFav ? Colors.red : const Color(0xFFCBD5E0),
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFF7FAFC),
                image: DecorationImage(
                  image: NetworkImage(item['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item['brand'],
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFFA0AEC0),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item['title'],
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A202C),
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          if (hasDiscount) ...[
            Row(
              children: [
                const Text(
                  'Precio oferta: ',
                  style: TextStyle(fontSize: 9, color: Color(0xFF8C98A4)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B6B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item['discount'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  item['originalPrice'],
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFFA0AEC0),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  item['offerPrice'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F2042),
                  ),
                ),
              ],
            ),
          ] else ...[
            const Text(
              'Precio normal:',
              style: TextStyle(fontSize: 9, color: Color(0xFF8C98A4)),
            ),
            const SizedBox(height: 2),
            Text(
              item['offerPrice'],
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F2042),
              ),
            ),
          ],
        ],
      ),
    );
  }
}