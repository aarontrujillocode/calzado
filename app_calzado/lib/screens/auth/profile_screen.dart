import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel? user;
  final VoidCallback onLogout;
  final Function(UserModel)? onProfileUpdated;

  const ProfileScreen({
    super.key,
    this.user,
    required this.onLogout,
    this.onProfileUpdated,
  });

  static const Color darkBlue = Color(0xFF0F2042);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Tarjeta Superior de Usuario
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: darkBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white24,
                          child: Text(
                            (user?.nombre.isNotEmpty ?? false)
                                ? user!.nombre[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.nombre ?? 'Usuario',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user?.email ?? 'correo@ejemplo.com',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              if (user?.telefono.isNotEmpty ?? false) ...[
                                const SizedBox(height: 2),
                                Text(
                                  user!.telefono,
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Colors.white24, height: 1),
                    const SizedBox(height: 12),

                    // Contadores de Pedidos y Favoritos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildCounter('PEDIDOS', user?.pedidos ?? 0),
                        Container(height: 30, width: 1, color: Colors.white24),
                        _buildCounter('FAVORITOS', user?.favoritos ?? 0),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Menú de Opciones
              _buildOptionTile(
                icon: Icons.person_outline,
                title: 'Información personal',
                subtitle: 'Actualiza tus datos personales',
                onTap: () {
                  if (user != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(
                          user: user!,
                          onProfileUpdated: (updatedUser) {
                            if (onProfileUpdated != null) {
                              onProfileUpdated!(updatedUser);
                            }
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
              _buildOptionTile(
                icon: Icons.location_on_outlined,
                title: 'Direcciones',
                subtitle: 'Gestiona tus direcciones',
                onTap: () {},
              ),
              _buildOptionTile(
                icon: Icons.shopping_bag_outlined,
                title: 'Mis pedidos',
                subtitle: 'Consulta el estado de tus pedidos',
                onTap: () {},
              ),
              _buildOptionTile(
                icon: Icons.help_outline,
                title: 'Ayuda y soporte',
                subtitle: 'Preguntas frecuentes y contacto',
                onTap: () {},
              ),

              const SizedBox(height: 20),

              // Botón Cerrar Sesión
              TextButton(
                onPressed: onLogout,
                child: const Text(
                  'CERRAR SESIÓN',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCounter(String label, int value) {
    return Column(
      children: [
        Text(
          '$value',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEDF2F7),
          child: Icon(icon, color: darkBlue),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}