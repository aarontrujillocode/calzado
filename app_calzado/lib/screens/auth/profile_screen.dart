import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const ProfileScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
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
          const Text('Aaron Ross', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text('aaron@ejemplo.com', style: TextStyle(color: Colors.grey)),
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
            onPressed: onLogout,
            child: const Text('Cerrar Sesión', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}