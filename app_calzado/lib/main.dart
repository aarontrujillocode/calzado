import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';
import 'screens/catalog/catalog_screen.dart';
import 'screens/favorites/favorites_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/profile_screen.dart';
import 'screens/admin/admin_main_layout.dart'; // <--- 1. Importa el layout de administrador
import 'package:app_calzado/models/user_model.dart';
import 'package:app_calzado/services/orders_service.dart';

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
  UserModel? currentUser;

  void _updateUserSession(UserModel user) {
    // --- 2. VERIFICACIÓN DE ROL DE ADMINISTRADOR ---
    if (user.rol == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AdminMainLayout(adminUser: user),
        ),
      );
      return;
    }

    // Si es cliente regular, continúa con la lógica normal de la tienda
    setState(() {
      currentUser = user;
      isLoggedIn = true;
    });
    OrdersService.instance.fetchOrders(user.id);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(
        isLoggedIn: isLoggedIn,
        currentUser: currentUser,
        onLoginSuccess: _updateUserSession,
      ),
      CatalogScreen(
        isLoggedIn: isLoggedIn,
        currentUser: currentUser,
        onLoginSuccess: _updateUserSession,
      ),
      FavoritesScreen(
        isLoggedIn: isLoggedIn,
        currentUser: currentUser,
        onLoginSuccess: _updateUserSession,
      ),
      isLoggedIn
          ? ProfileScreen(
              user: currentUser,
              onLogout: () {
                setState(() {
                  currentUser = null;
                  isLoggedIn = false;
                });
                OrdersService.instance.clearOrders();
              },
              onProfileUpdated: (updatedUser) {
                setState(() {
                  currentUser = updatedUser;
                });
              },
            )
          : LoginScreen(
              onLoginSuccess: _updateUserSession,
            ),
    ];

    return Scaffold(
      appBar: null,
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFFFF4B3E),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            label: 'Catálogo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Cuenta',
          ),
        ],
      ),
    );
  }
}