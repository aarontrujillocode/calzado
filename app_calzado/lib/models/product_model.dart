class Product {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagen;
  final String subcategoria;
  final String categoria;
  final int stockTotal;
  final String tallas;

  Product({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagen,
    required this.subcategoria,
    required this.categoria,
    required this.stockTotal,
    required this.tallas,
  });

  // Getter auxiliar para evitar errores de compilación si se busca product.marca
  String get marca => subcategoria;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] is int ? json['id'] : int.parse(json['id']?.toString() ?? '0'),
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      precio: double.tryParse(json['precio']?.toString() ?? '0.0') ?? 0.0,
      imagen: json['imagen']?.toString() ?? '',
      subcategoria: json['subcategoria']?.toString() ?? '',
      categoria: json['categoria']?.toString() ?? '',
      stockTotal: int.tryParse(json['stock_total']?.toString() ?? '0') ?? 0,
      tallas: json['tallas']?.toString() ?? '',
    );
  }
}