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
  State createState() => _MainLayoutScreenState();
}

// ATENCIÓN: Se añade  aquí abajo
class _MainLayoutScreenState extends State {
  int _selectedIndex = 0;
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    final List pages = [
      const HomeScreen(),
      const CatalogScreen(),
      const FavoritesScreen(),
      isLoggedIn
          ? ProfileScreen(onLogout: () => setState(() => isLoggedIn = false))
          : LoginScreen(onLoginSuccess: () => setState(() => isLoggedIn = true)),
    ];

    return Scaffold(
      appBar: null,
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