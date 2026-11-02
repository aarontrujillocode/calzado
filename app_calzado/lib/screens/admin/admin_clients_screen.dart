import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class AdminClientsScreen extends StatefulWidget {
  const AdminClientsScreen({super.key});

  @override
  State<AdminClientsScreen> createState() => _AdminClientsScreenState();
}

class _AdminClientsScreenState extends State<AdminClientsScreen> {
  late Future<List<dynamic>> _clientsFuture;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  void _loadClients() {
    setState(() {
      _clientsFuture = ApiService.getAdminUsers();
    });
  }

  // Método para confirmar y eliminar un cliente con privilegios de administrador
  void _confirmDeleteUser(BuildContext context, Map<String, dynamic> client) {
    final String rol = client['rol'] ?? 'cliente';

    // Regla de seguridad: Proteger cuentas de administrador
    if (rol == 'admin' || rol == 'administrador') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Acción no permitida: No puedes eliminar cuentas de administrador.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Cliente'),
        content: Text(
          '¿Estás seguro de eliminar al cliente "${client['nombre'] ?? client['email']}"? Esta acción lo borrará permanentemente de la base de datos MySQL.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              await _deleteUser(client['id']);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Método que ejecuta la petición al backend para eliminar el usuario
  Future<void> _deleteUser(dynamic userId) async {
    try {
      // Asegúrate de tener este método implementado en tu ApiService
      bool success = await ApiService.deleteUser(int.parse(userId.toString()));

      if (success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cliente eliminado exitosamente.'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        _loadClients(); // Recargar la lista automáticamente
      } else {
        throw Exception('No se pudo completar la operación en el servidor.');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Gestión de Clientes (MySQL)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F2042),
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadClients,
            tooltip: 'Actualizar lista',
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _clientsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar clientes: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No hay clientes registrados en la base de datos.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final clients = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total de usuarios registrados: ${clients.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F2042),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ListView.separated(
                        itemCount: clients.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final client = clients[index];
                          final bool isAdmin = client['rol'] == 'admin' || client['rol'] == 'administrador';

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: isAdmin
                                      ? const Color(0xFF2563EB)
                                      : const Color(0xFF0F2042),
                                  child: Text(
                                    client['nombre'] != null &&
                                            client['nombre'].isNotEmpty
                                        ? client['nombre'][0].toUpperCase()
                                        : 'U',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              client['nombre'] ?? 'Sin nombre',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Color(0xFF0F2042),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isAdmin
                                                  ? Colors.blue.shade50
                                                  : Colors.grey.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: isAdmin
                                                    ? Colors.blue.shade200
                                                    : Colors.grey.shade300,
                                              ),
                                            ),
                                            child: Text(
                                              client['rol'] ?? 'cliente',
                                              style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w600,
                                                color: isAdmin
                                                    ? Colors.blue.shade700
                                                    : Colors.grey.shade700,
                                                ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Email: ${client['email']}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF64748B),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Teléfono: ${client['telefono'] != null && client['telefono'].toString().isNotEmpty ? client['telefono'] : 'No registrado'}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF94A3B8),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      client['fecha_registro'] != null &&
                                              client['fecha_registro']
                                                  .toString()
                                                  .isNotEmpty
                                          ? client['fecha_registro']
                                              .toString()
                                              .substring(0, 10)
                                          : '',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF94A3B8),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Si es admin muestra un escudo protegido, si es cliente muestra el botón de borrar
                                    isAdmin
                                        ? const Icon(Icons.shield, color: Colors.blue, size: 20)
                                        : IconButton(
                                            constraints: const BoxConstraints(),
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                            tooltip: 'Eliminar cliente',
                                            onPressed: () => _confirmDeleteUser(context, client),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}