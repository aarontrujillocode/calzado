import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../auth/login_screen.dart'; // Asegúrate de que la ruta a tu pantalla de login sea correcta
import 'admin_dashboard_screen.dart';
import 'admin_orders_screen.dart';
import 'admin_products_screen.dart';
import 'admin_clients_screen.dart';
import 'admin_sales_screen.dart';

class AdminMainLayout extends StatefulWidget {
  final UserModel? adminUser;

  const AdminMainLayout({super.key, this.adminUser});

  @override
  State<AdminMainLayout> createState() => _AdminMainLayoutState();
}

class _AdminMainLayoutState extends State<AdminMainLayout> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 850;

    // Listado de pantallas del panel administrativo conectadas con MySQL
    final List<Widget> adminPages = [
      AdminDashboardScreen(adminUser: widget.adminUser),
      const AdminProductsScreen(), // Índice 1: Productos
      AdminOrdersScreen(),          // Índice 2: Pedidos
      const AdminClientsScreen(),   // Índice 3: Clientes
      const AdminSalesScreen(),     // Índice 4: Ventas
      const Center(child: Text('Módulo de Promociones', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      const Center(child: Text('Configuración del Sistema', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: isSmallScreen
          ? AppBar(
              backgroundColor: const Color(0xFF0F2042),
              title: const Text('StepUp Admin', style: TextStyle(color: Colors.white, fontSize: 18)),
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 0,
            )
          : null,
      drawer: isSmallScreen
          ? Drawer(
              backgroundColor: const Color(0xFF0F2042),
              child: _buildSidebarContent(context, isDrawer: true),
            )
          : null,
      body: Row(
        children: [
          if (!isSmallScreen)
            Container(
              width: 260,
              color: const Color(0xFF0F2042),
              child: _buildSidebarContent(context, isDrawer: false),
            ),
          Expanded(
            child: adminPages[_currentIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarContent(BuildContext context, {required bool isDrawer}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.directions_run, color: Color(0xFF0F2042)),
              ),
              const SizedBox(width: 12),
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
        ),
        const SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildSidebarItem(0, Icons.grid_view_rounded, 'Inicio', isDrawer),
                _buildSidebarItem(1, Icons.inventory_2_outlined, 'Productos', isDrawer),
                _buildSidebarItem(2, Icons.shopping_bag_outlined, 'Pedidos', isDrawer),
                _buildSidebarItem(3, Icons.people_outline, 'Clientes', isDrawer),
                _buildSidebarItem(4, Icons.trending_up, 'Ventas', isDrawer),
                _buildSidebarItem(5, Icons.local_offer_outlined, 'Promociones', isDrawer),
                _buildSidebarItem(6, Icons.settings_outlined, 'Configuración', isDrawer),
              ],
            ),
          ),
        ),
        // --- SECCIÓN INFERIOR: PERFIL Y BOTÓN DE CERRAR SESIÓN ---
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF384967),
                child: Text(
                  widget.adminUser?.nombre.isNotEmpty == true ? widget.adminUser!.nombre[0].toUpperCase() : 'A',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.adminUser?.nombre ?? 'Administrador',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.adminUser?.email ?? 'admin@stepup.com',
                      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Botón de Cerrar Sesión
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.redAccent, size: 22),
                tooltip: 'Cerrar Sesión',
                onPressed: () {
                  // Opcional: Cerrar el Drawer si está en pantalla pequeña
                  if (isDrawer) {
                    Navigator.pop(context);
                  }
                  // Redirigir al Login y limpiar el historial de navegación
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarItem(int index, IconData icon, String title, bool isDrawer) {
    final bool isSelected = _currentIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 20),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        onTap: () {
          setState(() => _currentIndex = index);
          if (isDrawer) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}