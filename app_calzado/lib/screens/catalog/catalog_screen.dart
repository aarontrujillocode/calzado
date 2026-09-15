import 'package:flutter/material.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String selectedSubCategory = 'Zapatillas';

  // ESTADOS DE FILTROS SELECCIONADOS
  final Map<String, bool> selectedBrands = {
    'Nike': true,
    'Adidas': false,
    'Puma': false,
    'Reebok': false,
    'Skechers': false,
  };

  final List<String> selectedSizes = ['8.5'];

  String selectedColor = 'Azul';

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
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFFAFAFA),
      
      // PANEL LATERAL DE FILTROS RÁPIDOS
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.8,
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'FILTROS RÁPIDOS',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F2042),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // SECCIÓN MARCAS
                      _buildFilterCard(
                        title: 'Marca',
                        content: Column(
                          children: selectedBrands.keys.map((brand) {
                            return CheckboxListTile(
                              title: Text(
                                brand,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              value: selectedBrands[brand],
                              activeColor: const Color(0xFF0F2042),
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (val) {
                                setState(() {
                                  selectedBrands[brand] = val ?? false;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // SECCIÓN TALLA
                      _buildFilterCard(
                        title: 'Talla',
                        content: Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            '6', '7', '7.5', '8.5', '9.5', '10', '10.5', '11', '12', '13'
                          ].map((size) {
                            final isSelected = selectedSizes.contains(size);
                            return SizedBox(
                              width: 60,
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      value: isSelected,
                                      activeColor: const Color(0xFF0F2042),
                                      onChanged: (val) {
                                        setState(() {
                                          if (val == true) {
                                            selectedSizes.add(size);
                                          } else {
                                            selectedSizes.remove(size);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    size,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // SECCIÓN COLOR
                      _buildFilterCard(
                        title: 'Color',
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildColorOption('Negro', Colors.black),
                            _buildColorOption('Blanco', Colors.white, hasBorder: true),
                            _buildColorOption('Gris', const Color(0xFF90A4AE)),
                            _buildColorOption('Azul', const Color(0xFF1D52D8)),
                            _buildColorOption('Marrón', const Color(0xFF8D4B18)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // BOTÓN APLICAR FILTROS
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F2042),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'APLICAR FILTROS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // BARRA AZUL SUPERIOR
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
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white, size: 24),
                    onPressed: () {},
                  ),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.filter_alt_outlined, color: Colors.white, size: 24),
                        onPressed: () {
                          // Abre el panel lateral al hacer tap en el filtro
                          _scaffoldKey.currentState?.openDrawer();
                        },
                      ),
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(3),
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
      ),
      
      body: SingleChildScrollView(
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
    );
  }

  // WIDGETS AUXILIARES DE FILTRO
  Widget _buildFilterCard({required String title, required Widget content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F2042),
            ),
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  Widget _buildColorOption(String label, Color color, {bool hasBorder = false}) {
    final isSelected = selectedColor == label;
    return GestureDetector(
      onTap: () => setState(() => selectedColor = label),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: hasBorder ? Border.all(color: const Color(0xFFCBD5E0)) : null,
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    color: color == Colors.white ? Colors.black : Colors.white,
                    size: 18,
                  )
                : null,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF4A5568),
            ),
          ),
        ],
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