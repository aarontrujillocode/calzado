import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';

class AdminSettingsScreen extends StatefulWidget {
  final UserModel? adminUser;

  const AdminSettingsScreen({super.key, this.adminUser});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _storeNameController;
  late TextEditingController _currencyController;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.adminUser?.nombre ?? 'Administrador');
    _emailController = TextEditingController(text: widget.adminUser?.email ?? 'admin@stepup.com');
    _storeNameController = TextEditingController(text: 'StepUp Calzado Store');
    _currencyController = TextEditingController(text: 'S/ (Soles Peruanos)');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _storeNameController.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  void _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulamos un breve retraso de guardado o llamada a API
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() => _isLoading = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Configuración guardada exitosamente!'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Configuración del Sistema',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F2042),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sección 1: Perfil del Administrador
              const Text(
                'Perfil del Administrador',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F2042)),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Administrador',
                        prefixIcon: Icon(Icons.person, color: Color(0xFF2563EB)),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value!.isEmpty ? 'El nombre es obligatorio' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Correo Electrónico',
                        prefixIcon: Icon(Icons.email, color: Color(0xFF2563EB)),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value!.isEmpty ? 'El correo es obligatorio' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Sección 2: Configuración General de la Tienda
              const Text(
                'Parámetros de la Tienda',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F2042)),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _storeNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre Comercial de la Tienda',
                        prefixIcon: Icon(Icons.store, color: Color(0xFF2563EB)),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _currencyController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Moneda del Sistema',
                        prefixIcon: Icon(Icons.monetization_on, color: Color(0xFF10B981)),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Sección 3: Estado de Conexión Backend / MySQL
              const Text(
                'Estado del Servidor y Base de Datos',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F2042)),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.cloud_done, color: Color(0xFF10B981), size: 24),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Conectado a MySQL (calzado_store_v2)',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F2042)),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'API PHP activa en http://127.0.0.1/calzado/api.php',
                            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Botón de Guardar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _isLoading ? null : _saveSettings,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Guardar Cambios',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
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