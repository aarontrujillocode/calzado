import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const ShoeStoreApp());
}

class ShoeStoreApp extends StatelessWidget {
  const ShoeStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KICKS & CO.',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E1E24),
          primary: const Color(0xFF1E1E24),
          secondary: const Color(0xFFFF4B3E),
          surface: const Color(0xFFF8F9FA),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
      ),
      home: const MainLayoutScreen(),
    );
  }
}

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _selectedIndex = 0;
  bool isLoggedIn = false;
  String userName = '';
  String userEmail = '';

  List<dynamic> categories = [];
  bool isLoading = true;
  String selectedCategory = 'Todos';

  final List<Map<String, dynamic>> featuredShoes = [
    {
      'id': '1',
      'name': 'Air Max Boost Ultra',
      'category': 'Hombres',
      'subcategory': 'Zapatillas',
      'price': 'S/ 389.00',
      'rating': 4.9,
      'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&q=80',
      'badge': 'Bestseller',
      'color': const Color(0xFFE53935),
    },
    {
      'id': '2',
      'name': 'Urban Retro Runner',
      'category': 'Mujeres',
      'subcategory': 'Zapatillas',
      'price': 'S/ 299.00',
      'rating': 4.8,
      'image': 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=600&q=80',
      'badge': 'Nuevo',
      'color': const Color(0xFF8E24AA),
    },
    {
      'id': '3',
      'name': 'Classic Executive Oxford',
      'category': 'Hombres',
      'subcategory': 'Zapatos de vestir',
      'price': 'S/ 450.00',
      'rating': 4.7,
      'image': 'https://images.unsplash.com/photo-1614252235316-8c857d38b5f4?w=600&q=80',
      'badge': 'Premium',
      'color': const Color(0xFF3E2723),
    },
    {
      'id': '4',
      'name': 'Junior Speed Flex Kids',
      'category': 'Infantil',
      'subcategory': 'Zapatillas',
      'price': 'S/ 189.00',
      'rating': 4.9,
      'image': 'https://images.unsplash.com/photo-1514989940723-e8e51635b782?w=600&q=80',
      'badge': 'Popular',
      'color': const Color(0xFF0288D1),
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('http://localhost/calzado/api.php'));
      if (response.statusCode == 200) {
        setState(() {
          categories = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeView(),
      _buildCatalogView(),
      _buildFavoritesView(),
      _buildAccountView(),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E24),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.do_not_step, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1E24)),
                children: [
                  TextSpan(text: 'KICKS'),
                  TextSpan(text: '&CO', style: TextStyle(color: Color(0xFFFF4B3E))),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF1E1E24)),
            onPressed: () {},
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF1E1E24)),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF4B3E),
                    shape: BoxShape.circle,
                  ),
                  child: const Text('2', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFFFF4B3E),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.category_outlined), label: 'Catálogo'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Cuenta'),
        ],
      ),
    );
  }

  Widget _buildHomeView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPromoBanner(),
          const SizedBox(height: 24),
          const Text("Categorías Destacadas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildCategoryChips(),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Colección de Calzado", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(onPressed: () {}, child: const Text("Ver todo", style: TextStyle(color: Color(0xFFFF4B3E)))),
            ],
          ),
          const SizedBox(height: 12),
          _buildProductGrid(),
        ],
      ),
    );
  }

  Widget _buildCatalogView() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final List subcats = cat['subcategorias'] ?? [];
              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  leading: const Icon(Icons.category_outlined, color: Color(0xFF1E1E24)),
                  title: Text(cat['categoria'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${subcats.length} subcategorías"),
                  children: subcats.map<Widget>((sub) {
                    return ListTile(
                      leading: const Icon(Icons.arrow_right),
                      title: Text(sub['nombre']),
                      onTap: () {},
                    );
                  }).toList(),
                ),
              );
            },
          );
  }

  Widget _buildFavoritesView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text("No tienes productos favoritos aún", style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildAccountView() {
    if (isLoggedIn) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFF1E1E24),
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(userName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(userEmail, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: const Text('Mis Pedidos'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: const Text('Direcciones de Envío'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4B3E),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                setState(() {
                  isLoggedIn = false;
                  userName = '';
                  userEmail = '';
                });
              },
              child: const Text('Cerrar Sesión', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      );
    }

    return const LoginRegisterForm();
  }

  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1E1E24), Color(0xFF3A3D40)]),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('TEMPORADA 2026', style: TextStyle(color: Color(0xFFFF4B3E), fontWeight: FontWeight.bold, fontSize: 12)),
          SizedBox(height: 6),
          Text('Nuevos Modelos de Verano', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Hasta 30% OFF en calzado urbano', style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    final List<String> filterList = ['Todos', 'Hombres', 'Mujeres', 'Infantil'];
    return Row(
      children: filterList.map((cat) {
        final isSelected = selectedCategory == cat;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            selected: isSelected,
            label: Text(cat),
            selectedColor: const Color(0xFF1E1E24),
            labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
            onSelected: (selected) => setState(() => selectedCategory = cat),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProductGrid() {
    final filtered = selectedCategory == 'Todos'
        ? featuredShoes
        : featuredShoes.where((s) => s['category'] == selectedCategory).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final shoe = filtered[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    image: DecorationImage(image: NetworkImage(shoe['image']), fit: BoxFit.cover),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(shoe['name'], style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1),
                    Text(shoe['price'], style: const TextStyle(color: Color(0xFFFF4B3E), fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class LoginRegisterForm extends StatefulWidget {
  const LoginRegisterForm({super.key});

  @override
  State<LoginRegisterForm> createState() => _LoginRegisterFormState();
}

class _LoginRegisterFormState extends State<LoginRegisterForm> {
  bool isLogin = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isLogin ? 'Iniciar Sesión' : 'Crear Cuenta',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1E1E24)),
            ),
            const SizedBox(height: 6),
            Text(
              isLogin ? 'Ingresa para acceder a tus pedidos' : 'Regístrate para comprar en la tienda',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            if (!isLogin) ...[
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre Completo',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E1E24),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isLogin ? 'Procesando Inicio de Sesión...' : 'Registrando usuario...')),
                );
              },
              child: Text(
                isLogin ? 'INGRESAR' : 'REGISTRARME',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(isLogin ? '¿No tienes cuenta?' : '¿Ya tienes cuenta?'),
                TextButton(
                  onPressed: () => setState(() => isLogin = !isLogin),
                  child: Text(
                    isLogin ? 'Regístrate' : 'Inicia Sesión',
                    style: const TextStyle(color: Color(0xFFFF4B3E), fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}