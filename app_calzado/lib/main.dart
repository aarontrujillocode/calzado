import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';
import 'screens/catalog/catalog_screen.dart';
import 'screens/favorites/favorites_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/profile_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeScreen(),
      const CatalogScreen(),
      const FavoritesScreen(),
      isLoggedIn
          ? ProfileScreen(onLogout: () => setState(() => isLoggedIn = false))
          : LoginScreen(onLoginSuccess: () => setState(() => isLoggedIn = true)),
    ];

    return Scaffold(
      // Si la pestaña actual es 'Catálogo' (índice 1), oculta el AppBar blanco.
      // Para cualquier otra pestaña, sí muestra la barra blanca de KICKS&CO.
      appBar: _selectedIndex == 1
          ? null
          : AppBar(
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
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E1E24)),
                      children: [
                        TextSpan(text: 'KICKS'),
                        TextSpan(
                            text: '&CO',
                            style: TextStyle(color: Color(0xFFFF4B3E))),
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
                      icon: const Icon(Icons.shopping_bag_outlined,
                          color: Color(0xFF1E1E24)),
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
                        child: const Text('2',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
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
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined), label: 'Catálogo'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: 'Favoritos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Cuenta'),
        ],
      ),
    );
  }
}