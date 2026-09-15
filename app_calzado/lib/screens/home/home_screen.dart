import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;
  final List<String> categories = ['Todos', 'Hombres', 'Mujeres', 'Infantil'];

  final List<Map<String, dynamic>> products = [
    {
      'id': '1',
      'brand': 'R18',
      'title': 'Zapatillas Urbanas R18 Roma XL Mujer',
      'originalPrice': 'S/ 219.90',
      'offerPrice': 'S/ 87.90',
      'discount': '60% OFF',
      'image': 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=600&q=80',
      'isFavorite': false,
    },
    {
      'id': '2',
      'brand': 'ADIDAS',
      'title': 'Zapatillas Deportivas Hombres Lite Racer 4.0',
      'originalPrice': 'S/ 179.00',
      'offerPrice': 'S/ 107.90',
      'discount': '60% OFF',
      'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&q=80',
      'isFavorite': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                              // CONTENEDOR CON TU ARCHIVO icono1.png
                              Container(
                                width: 42,
                                height: 42,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF384967),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Image.asset(
                                  'lib/assets/icono1.png', // Ruta actualizada
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
 // BANNER PROMOCIONAL (SOLUCIONADO OVERFLOW)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 180, // Aumentado a 180 para dar más espacio
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

            // GRILLA DE PRODUCTOS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
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
                  return ProductCardHomeWidget(
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

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ProductCardHomeWidget extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onFavoriteToggle;

  const ProductCardHomeWidget({
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
                  Icons.favorite_rounded,
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
          Row(
            children: [
              const Text(
                'Precio oferta: ',
                style: TextStyle(fontSize: 9, color: Color(0xFF8C98A4)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4B3E),
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
        ],
      ),
    );
  }
}