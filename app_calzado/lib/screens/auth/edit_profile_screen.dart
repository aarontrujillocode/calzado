import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  final Function(UserModel) onProfileUpdated;

  const EditProfileScreen({
    super.key,
    required this.user,
    required this.onProfileUpdated,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;
  bool isLoading = false;

  static const Color darkBlue = Color(0xFF0F2042);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.nombre);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.telefono);
    _dobController = TextEditingController(text: widget.user.fechaNacimiento);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  // MÉTODO PARA ABRIR EL SELECTOR DE FECHAS
  Future<void> _selectDate() async {
    // Intentar parsear la fecha actual del campo si existe, o usar año 2000 por defecto
    DateTime initialDate = DateTime(2000);
    if (_dobController.text.trim().isNotEmpty) {
      try {
        initialDate = DateTime.parse(_dobController.text.trim());
      } catch (_) {}
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: darkBlue,
              onPrimary: Colors.white,
              onSurface: darkBlue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        // Formatear como YYYY-MM-DD
        final String formattedDate =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        _dobController.text = formattedDate;
      });
    }
  }

  Future<void> _saveChanges() async {
    setState(() => isLoading = true);

    final response = await ApiService.updateProfile(
      id: widget.user.id,
      nombre: _nameController.text.trim(),
      email: _emailController.text.trim(),
      telefono: _phoneController.text.trim(),
      fechaNacimiento: _dobController.text.trim(),
    );

    if (!mounted) return;
    setState(() => isLoading = false);

    if (response['status'] == 'success') {
      final updatedUser = UserModel(
        id: widget.user.id,
        nombre: _nameController.text.trim(),
        email: _emailController.text.trim(),
        telefono: _phoneController.text.trim(),
        fechaNacimiento: _dobController.text.trim(),
        fotoPerfil: widget.user.fotoPerfil,
        pedidos: widget.user.pedidos,
        favoritos: widget.user.favoritos,
      );

      widget.onProfileUpdated(updatedUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Perfil actualizado con éxito'),
            backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(response['message'] ?? 'Error al actualizar'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: darkBlue,
        elevation: 0,
        title: const Text('Editar perfil', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFEDF2F7),
              child: Icon(Icons.person, size: 60, color: darkBlue),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                  labelText: 'Nombre completo', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                  labelText: 'Correo electrónico', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                  labelText: 'Teléfono', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            // CAMPO FECHA DE NACIMIENTO CON SELECTOR DE FECHAS
            TextField(
              controller: _dobController,
              readOnly: true,
              onTap: _selectDate,
              decoration: InputDecoration(
                labelText: 'Fecha de nacimiento',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _selectDate,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: darkBlue),
                onPressed: isLoading ? null : _saveChanges,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Guardar cambios',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}