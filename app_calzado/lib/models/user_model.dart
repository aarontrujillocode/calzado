class UserModel {
  final int id;
  final String nombre;
  final String email;
  final String telefono;
  final String fechaNacimiento;
  final String fotoPerfil;
  final int pedidos;
  final int favoritos;
  final String rol; // <--- 1. Propiedad añadida

  UserModel({
    required this.id,
    required this.nombre,
    required this.email,
    this.telefono = '',
    this.fechaNacimiento = '',
    this.fotoPerfil = '',
    this.pedidos = 0,
    this.favoritos = 0,
    this.rol = 'cliente', // <--- 2. Valor por defecto
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      nombre: json['nombre'] ?? '',
      email: json['email'] ?? '',
      telefono: json['telefono'] ?? '',
      fechaNacimiento: json['fecha_nacimiento'] ?? '',
      fotoPerfil: json['foto_perfil'] ?? '',
      pedidos: json['pedidos'] is int
          ? json['pedidos']
          : int.tryParse(json['pedidos'].toString()) ?? 0,
      favoritos: json['favoritos'] is int
          ? json['favoritos']
          : int.tryParse(json['favoritos'].toString()) ?? 0,
      rol: json['rol'] ?? 'cliente', // <--- 3. Mapeo desde el JSON del backend
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'fecha_nacimiento': fechaNacimiento,
      'foto_perfil': fotoPerfil,
      'pedidos': pedidos,
      'favoritos': favoritos,
      'rol': rol, // <--- 4. Incluido para serialización
    };
  }
}