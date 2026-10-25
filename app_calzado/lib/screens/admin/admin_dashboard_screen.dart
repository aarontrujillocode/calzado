import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class AdminDashboardScreen extends StatelessWidget {
  final UserModel? adminUser;

  const AdminDashboardScreen({super.key, this.adminUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra superior (Buscador, Fecha y Notificaciones)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 42,
                    constraints: const BoxConstraints(maxWidth: 320),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(21),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar...',
                        hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                        prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.calendar_today, size: 14, color: Color(0xFF64748B)),
                          SizedBox(width: 8),
                          Text('1 - 31 Ago 2026', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                          Icon(Icons.arrow_drop_down, color: Color(0xFF64748B)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const CircleAvatar(radius: 18, backgroundColor: Colors.white, child: Icon(Icons.notifications_none, color: Colors.black54)),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFF2563EB),
                      child: Text(
                        adminUser?.nombre.isNotEmpty == true ? adminUser!.nombre[0].toUpperCase() : 'A',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Saludo personalizado
            Text(
              '¡Hola, ${adminUser?.nombre ?? 'Administrador'}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 4),
            const Text(
              'Aquí tienes un resumen del rendimiento de tu tienda.',
              style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 20),

            // Tarjetas de Métricas Superiores Adaptables
            LayoutBuilder(
              builder: (context, constraints) {
                double cardWidth = constraints.maxWidth > 900 
                    ? (constraints.maxWidth - 48) / 4 
                    : (constraints.maxWidth - 16) / 2;
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(width: cardWidth, child: _buildMetricCard('Ventas totales', 'S/ 12,480.00', '12% vs. mes anterior', true)),
                    SizedBox(width: cardWidth, child: _buildMetricCard('Pedidos', '124', '8% vs. mes anterior', true)),
                    SizedBox(width: cardWidth, child: _buildMetricCard('Clientes', '86', '15% vs. mes anterior', true)),
                    SizedBox(width: cardWidth, child: _buildMetricCard('Productos en stock', '342', '5% vs. mes anterior', true)),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Sección Inferior (Gráficos y Productos más vendidos)
            LayoutBuilder(
              builder: (context, constraints) {
                bool isWide = constraints.maxWidth > 900;
                return isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: _buildCategorySalesCard()),
                          const SizedBox(width: 24),
                          Expanded(flex: 2, child: _buildTopProductsCard()),
                        ],
                      )
                    : Column(
                        children: [
                          _buildCategorySalesCard(),
                          const SizedBox(height: 24),
                          _buildTopProductsCard(),
                        ],
                      );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String percentage, bool isPositive) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(isPositive ? Icons.arrow_upward : Icons.arrow_downward, size: 14, color: Colors.green),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  percentage,
                  style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySalesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ventas por categoría', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const Text('En porcentaje', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
          const SizedBox(height: 30),
          Center(
            child: Wrap(
              spacing: 30,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF06B6D4), Color(0xFFF59E0B), Color(0xFFEC4899), Color(0xFF8B5CF6)],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 85,
                      height: 85,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Total', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                          Text('S/ 12,480', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem(const Color(0xFF2563EB), 'Zapatillas', '45%'),
                    _buildLegendItem(const Color(0xFF06B6D4), 'Zapatos de vestir', '25%'),
                    _buildLegendItem(const Color(0xFFF59E0B), 'Tacos', '15%'),
                    _buildLegendItem(const Color(0xFFEC4899), 'Botas', '10%'),
                    _buildLegendItem(const Color(0xFF8B5CF6), 'Sandalias', '5%'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopProductsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Productos más vendidos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 16),
          _buildTopProductItem('Nike Air Max 270', '18%'),
          _buildTopProductItem('Adidas Forum', '15%'),
          _buildTopProductItem('Converse Chuck 70', '12%'),
          _buildTopProductItem('Puma RS-X', '10%'),
          _buildTopProductItem('New Balance 550', '8%'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String category, String percent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(category, style: const TextStyle(fontSize: 12, color: Color(0xFF334155))),
          const SizedBox(width: 16),
          Text(percent, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }

  Widget _buildTopProductItem(String name, String percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.shopping_bag, size: 18, color: Color(0xFF64748B)),
              ),
              const SizedBox(width: 12),
              Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            ],
          ),
          Text(percentage, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }
}