import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'Todos';
  int _currentBannerIndex = 0;
  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> banners = [
    {
      'title': 'VELOCITY\nBLUE',
      'subtitle': 'HIGH-PERFORMANCE\nENERGY RETURN',
      'image': 'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=800&q=80',
    },
    {
      'title': 'URBAN\nSTYLE',
      'subtitle': 'COMFORT FOR YOUR\nEVERYDAY STEPS',
      'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&q=80',
    },
  ];

  final List<Map<String, dynamic>> products = [
    {
      'id': '1',
      'brand': 'R18',
      'title': 'Zapatillas Urbanas R18 Roma XL Mujer',
      'rating': 5,
      'originalPrice': 'S/ 219.90',
      'offerPrice': 'S/ 87.90',
      'discount': '60% OFF',
      'image': 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=600&q=80',
      'category': 'Mujeres',
      'isFavorite': false,
    },
    {
      'id': '2',
      'brand': 'ADIDAS',
      'title': 'Zapatillas Deportivas Hombres Lite Racer 4.0',
      'rating': 5,
      'originalPrice': 'S/ 179.00',
      'offerPrice': 'S/ 107.90',
      'discount': '60% OFF',
      'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&q=80',
      'category': 'Hombres',
      'isFavorite': true,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = selectedCategory == 'Todos'
        ? products
        : products.where((p) => p['category'] == selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header Azul Superior Curvo
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF0F2042),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                padding: const EdgeInsets.only(top: 48, left: 20, right: 20, bottom: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.roller_skating_rounded,
                                color: Color(0xFF1D52D8),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 10),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                                children: [
                                  TextSpan(text: 'Step'),
                                  TextSpan(text: 'Up', style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 26),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Buscador redondeado con Controller
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Color(0xFFA0AEC0)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: 'Buscar calzado...',
                                hintStyle: TextStyle(color: Color(0xFFA0AEC0), fontSize: 14),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Carousel de Banners Promocionales
              SizedBox(
                height: 180,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: banners.length,
                  onPageChanged: (index) {
                    setState(() => _currentBannerIndex = index);
                  },
                  itemBuilder: (context, index) {
                    final banner = banners[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: NetworkImage(banner['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.black.withOpacity(0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                banner['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                banner['subtitle'],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1D52D8),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  'SHOP NOW',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              // Indicadores del Slider dinámicos
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  banners.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: _currentBannerIndex == index ? 20 : 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: _currentBannerIndex == index
                          ? const Color(0xFF0F2042)
                          : const Color(0xFFCBD5E0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Categorías Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: ['Todos', 'Hombres', 'Mujeres', 'Infantil'].map((category) {
                    final isSelected = selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => selectedCategory = category),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF0F2042) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF0F2042) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF4A5568),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),

              // Grid de Productos usando Widget Modular
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
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
                    final item = filteredProducts[index];
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
              ),
              const SizedBox(height: 24),
            ],
          ),
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEDF2F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
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
                    Icons.star_rounded,
                    color: i < (item['rating'] ?? 0) ? const Color(0xFFFFB800) : const Color(0xFFE2E8F0),
                    size: 14,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onFavoriteToggle,
                child: Icon(
                  isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isFav ? const Color(0xFFE53E3E) : const Color(0xFFCBD5E0),
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A202C),
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Precio oferta: ',
                style: TextStyle(fontSize: 9, color: Color(0xFF718096)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53E3E),
                  borderRadius: BorderRadius.circular(10),
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
              const SizedBox(width: 6),
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
        ],
      ),
    );
  }
}