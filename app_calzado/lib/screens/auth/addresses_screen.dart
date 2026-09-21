import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';

class AddressesScreen extends StatefulWidget {
  final UserModel user;

  const AddressesScreen({super.key, required this.user});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  List<dynamic> addresses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() => isLoading = true);
    final list = await ApiService.getAddresses(widget.user.id);
    setState(() {
      addresses = list;
      isLoading = false;
    });
  }

  void _showAddAddressModal() {
    final titleCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final districtCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    bool isPrincipal = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nueva Dirección',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nombre lugar (ej: Casa, Trabajo)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: addressCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Dirección (Calle / Av.)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: districtCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Distrito / Ciudad',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono de contacto',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                    title: const Text('Marcar como dirección principal'),
                    value: isPrincipal,
                    onChanged: (val) => setModalState(() => isPrincipal = val ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F214A),
                      ),
                      onPressed: () async {
                        if (titleCtrl.text.isEmpty || addressCtrl.text.isEmpty) return;
                        final success = await ApiService.addAddress({
                          'usuario_id': widget.user.id,
                          'titulo': titleCtrl.text,
                          'direccion': addressCtrl.text,
                          'distrito': districtCtrl.text,
                          'ciudad': 'Lima',
                          'pais': 'Perú',
                          'codigo_postal': '15037',
                          'telefono': phoneCtrl.text,
                          'es_principal': isPrincipal ? 1 : 0,
                        });
                        if (mounted) {
                          Navigator.pop(context);
                          if (success) _loadAddresses();
                        }
                      },
                      child: const Text('Guardar dirección',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F214A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Mis direcciones',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _showAddAddressModal,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : addresses.isEmpty
              ? const Center(child: Text('No tienes direcciones registradas'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    final item = addresses[index];
                    final bool isPrincipal = item['es_principal'] == true;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (isPrincipal) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade600,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'PRINCIPAL',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                item['titulo'] ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F214A),
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: Icon(Icons.delete_outline, color: Colors.red.shade300, size: 20),
                                onPressed: () async {
                                  final ok = await ApiService.deleteAddress(item['id']);
                                  if (ok) _loadAddresses();
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('${item['direccion']}', style: TextStyle(color: Colors.grey.shade700)),
                          Text('${item['distrito']}, ${item['ciudad']}', style: TextStyle(color: Colors.grey.shade700)),
                          Text('${item['pais']} - ${item['codigo_postal']}', style: TextStyle(color: Colors.grey.shade700)),
                          Text('Tel. ${item['telefono']}', style: TextStyle(color: Colors.grey.shade700)),
                        ],
                      ),
                    );
                  },
                ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F214A),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _showAddAddressModal,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Agregar nueva dirección',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}