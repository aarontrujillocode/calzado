import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  final UserModel? adminUser;

  const AdminDashboardScreen({super.key, this.adminUser});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late Future<Map<String, dynamic>> _statsFuture;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    setState(() {
      _statsFuture = ApiService.getDashboardStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _statsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Error al cargar las estadísticas del servidor.'),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: _loadStats, child: const Text('Reintentar'))
              ],
            ),
          );
        }

        final data = snapshot.data!;
        final double ventasTotales = (data['ventas_totales'] ?? 0).toDouble();
        final int pedidosTotales = data['pedidos_totales'] ?? 0;
        final int clientesTotales = data['clientes_totales'] ?? 0;
        final int productosStock = data['productos_stock'] ?? 0;
        final List<dynamic> subcategorias = data['ventas_por_subcategoria'] ?? [];

        // Colores predefinidos para las categorías dinámicas
        final List<Color> categoryColors = [
          const Color(0xFF2563EB),
          const Color(0xFF06B6D4),
          const Color(0xFFF59E0B),
          const Color(0xFFEC4899),
          const Color(0xFF8B5CF6),
          const Color(0xFF10B981),
        ];

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
                              Text('Tiempo Real (MySQL)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Color(0xFF64748B)),
                          onPressed: _loadStats,
                          tooltip: 'Actualizar métricas',
                        ),
                        const SizedBox(width: 12),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: const Color(0xFF2563EB),
                          child: Text(
                            widget.adminUser?.nombre.isNotEmpty == true ? widget.adminUser!.nombre[0].toUpperCase() : 'A',
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
                  '¡Hola, ${widget.adminUser?.nombre ?? 'Administrador'}!',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Aquí tienes un resumen en tiempo real del rendimiento de tu tienda.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 20),

                // Tarjetas de Métricas Superiores Adaptables con datos reales
                LayoutBuilder(
                  builder: (context, constraints) {
                    double cardWidth = constraints.maxWidth > 900 
                        ? (constraints.maxWidth - 48) / 4 
                        : (constraints.maxWidth - 16) / 2;
                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        SizedBox(width: cardWidth, child: _buildMetricCard('Ventas totales', 'S/ ${ventasTotales.toStringAsFixed(2)}', 'Base de datos', true)),
                        SizedBox(width: cardWidth, child: _buildMetricCard('Pedidos', '$pedidosTotales', 'Registrados', true)),
                        SizedBox(width: cardWidth, child: _buildMetricCard('Clientes', '$clientesTotales', 'Activos', true)),
                        SizedBox(width: cardWidth, child: _buildMetricCard('Productos en stock', '$productosStock', 'Unidades', true)),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Sección Inferior (Gráficos dinámicos basados en transacciones reales)
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isWide = constraints.maxWidth > 900;
                    return isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 3, child: _buildCategorySalesCard(ventasTotales, subcategorias, categoryColors)),
                              const SizedBox(width: 24),
                              Expanded(flex: 2, child: _buildTopProductsCard(subcategorias)),
                            ],
                          )
                        : Column(
                            children: [
                              _buildCategorySalesCard(ventasTotales, subcategorias, categoryColors),
                              const SizedBox(height: 24),
                              _buildTopProductsCard(subcategorias),
                            ],
                          );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricCard(String title, String value, String subtitle, bool isPositive) {
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
              Icon(isPositive ? Icons.check_circle : Icons.info, size: 14, color: Colors.blue),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.blue, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySalesCard(double ventasTotales, List<dynamic> subcategorias, List<Color> colors) {
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
          const Text('Ventas por subcategoría', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const Text('Porcentaje basado en ventas reales de MySQL', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
          const SizedBox(height: 30),
          subcategorias.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Text('No hay suficientes ventas registradas para generar el gráfico.'),
                  ),
                )
              : Center(
                  child: Wrap(
                    spacing: 30,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SweepGradient(
                            colors: subcategorias.asMap().entries.map((e) {
                              return colors[e.key % colors.length];
                            }).toList(),
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 85,
                            height: 85,
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Total', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text('S/ ${ventasTotales.toStringAsFixed(0)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: subcategorias.asMap().entries.map((entry) {
                          int index = entry.key;
                          var cat = entry.value;
                          Color color = colors[index % colors.length];
                          return _buildLegendItem(color, cat['subcategoria'].toString(), '${cat['porcentaje']}%');
                        }).toList(),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildTopProductsCard(List<dynamic> subcategorias) {
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
          const Text('Rendimiento por Línea', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 16),
          subcategorias.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text('Sin datos de ventas aún.'),
                )
              : Column(
                  children: subcategorias.map((cat) {
                    return _buildTopProductItem(cat['subcategoria'].toString(), 'S/ ${cat['total'].toStringAsFixed(2)}');
                  }).toList(),
                ),
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
          Text(percentage, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
        ],
      ),
    );
  }
}