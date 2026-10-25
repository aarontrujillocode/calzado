import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../home/home_screen.dart';
import '../auth/orders_screen.dart'; // O ajusta la ruta según donde tengas tu OrdersScreen

class OrderSuccessScreen extends StatelessWidget {
  final UserModel? currentUser;

  const OrderSuccessScreen({
    super.key,
    this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F2546);
    const accentColor = Color(0xFFFF4B3E);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '¡Compra exitosa!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tu pago ha sido procesado correctamente y el pedido fue registrado en tu cuenta.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // Ir directo a Mis Pedidos pasando el usuario actual
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrdersScreen(currentUser: currentUser),
                      ),
                    );
                  },
                  child: const Text(
                    'VER MI PEDIDO',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  // Regresar al inicio limpiando todo el historial de rutas de compra
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(
                        isLoggedIn: currentUser != null,
                        currentUser: currentUser,
                      ),
                    ),
                    (route) => false,
                  );
                },
                child: const Text(
                  'VOLVER AL INICIO',
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}