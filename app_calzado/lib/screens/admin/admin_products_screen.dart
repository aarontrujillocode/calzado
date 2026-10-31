import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../services/api_service.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      _productsFuture = ApiService.getProducts();
    });
  }

  // Diálogo para Agregar o Editar Producto
  void _showProductDialog(BuildContext context, {Product? productToEdit}) {
    final _formKey = GlobalKey<FormState>();
    final bool isEditing = productToEdit != null;

    final TextEditingController _nombreController =
        TextEditingController(text: isEditing ? productToEdit.nombre : '');
    final TextEditingController _descripcionController =
        TextEditingController(text: isEditing ? productToEdit.descripcion : '');
    final TextEditingController _precioController =
        TextEditingController(text: isEditing ? productToEdit.precio.toString() : '');
    final TextEditingController _imagenController =
        TextEditingController(text: isEditing ? productToEdit.imagen : '');
    final TextEditingController _stockController =
        TextEditingController(text: isEditing ? productToEdit.stockTotal.toString() : '10');
    final TextEditingController _tallasController =
        TextEditingController(text: isEditing ? productToEdit.tallas : '40,41,42');

    String _categoriaSeleccionada =
        isEditing ? productToEdit.categoria : 'Hombres';
    String _subcategoriaSeleccionada =
        isEditing ? productToEdit.subcategoria : 'Zapatillas';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(
                isEditing ? 'Editar Producto' : 'Agregar Nuevo Producto',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F2042),
                ),
              ),
              content: SizedBox(
                width: 450,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _nombreController,
                          decoration: const InputDecoration(labelText: 'Nombre del calzado'),
                          validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _descripcionController,
                          decoration: const InputDecoration(labelText: 'Descripción'),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _precioController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Precio (S/)'),
                          validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _imagenController,
                          decoration: const InputDecoration(labelText: 'URL de la imagen (Ej. Unsplash)'),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: _categoriaSeleccionada,
                          decoration: const InputDecoration(labelText: 'Categoría'),
                          items: ['Hombres', 'Mujeres', 'Infantil']
                              .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                              .toList(),
                          onChanged: (value) {
                            setStateDialog(() {
                              _categoriaSeleccionada = value!;
                              if (_categoriaSeleccionada == 'Hombres') _subcategoriaSeleccionada = 'Zapatillas';
                              if (_categoriaSeleccionada == 'Mujeres') _subcategoriaSeleccionada = 'Tacos';
                              if (_categoriaSeleccionada == 'Infantil') _subcategoriaSeleccionada = 'Zapatillas';
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _stockController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Stock Total'),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _tallasController,
                          decoration: const InputDecoration(labelText: 'Tallas separadas por coma (Ej. 38,39,40)'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Map<String, dynamic> productData = {
                        if (isEditing) 'id': productToEdit.id,
                        'nombre': _nombreController.text,
                        'descripcion': _descripcionController.text,
                        'precio': double.tryParse(_precioController.text) ?? 0.0,
                        'imagen': _imagenController.text,
                        'categoria': _categoriaSeleccionada,
                        'subcategoria': _subcategoriaSeleccionada,
                        'stock_total': int.tryParse(_stockController.text) ?? 10,
                        'tallas': _tallasController.text,
                        'subcategoria_id': _categoriaSeleccionada == 'Hombres' ? 1 : (_categoriaSeleccionada == 'Mujeres' ? 4 : 7),
                      };

                      bool exito = isEditing
                          ? await ApiService.updateProduct(productData)
                          : await ApiService.addProduct(productData);

                      Navigator.pop(context);

                      if (exito) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isEditing ? '¡Producto actualizado con éxito!' : '¡Producto agregado con éxito!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        _loadProducts();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error al guardar en la base de datos'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: Text(isEditing ? 'Actualizar' : 'Guardar Producto', style: const TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Confirmar y eliminar producto
  void _confirmDelete(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Producto'),
        content: Text('¿Estás seguro de eliminar "${product.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              bool exito = await ApiService.deleteProduct(product.id);
              if (exito) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Producto eliminado correctamente'), backgroundColor: Colors.green),
                );
                _loadProducts();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error al eliminar producto'), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Gestión de Productos (MySQL)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F2042),
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProducts,
            tooltip: 'Actualizar lista',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showProductDialog(context),
        backgroundColor: const Color(0xFF2563EB),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Agregar Producto', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar productos: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No hay productos registrados en la base de datos.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final products = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total de productos en catálogo: ${products.length}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F2042),
                  ),
                ),
                const SizedBox(height: 16),
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
                        itemCount: products.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade200,
                                image: product.imagen.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(product.imagen),
                                        fit: BoxFit.cover,
                                        onError: (_, __) {},
                                      )
                                    : null,
                              ),
                              child: product.imagen.isEmpty
                                  ? const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),
                            title: Text(
                              product.nombre,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0xFF0F2042),
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'Categoría: ${product.categoria} (${product.subcategoria}) • Tallas: ${product.tallas}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'S/ ${product.precio.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Color(0xFF2563EB),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: product.stockTotal > 0
                                            ? Colors.green.shade50
                                            : Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'Stock: ${product.stockTotal}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: product.stockTotal > 0
                                              ? Colors.green.shade700
                                              : Colors.red.shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                // --- MENÚ DE OPCIONES (EDITAR / ELIMINAR) ---
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert, color: Color(0xFF0F2042)),
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      _showProductDialog(context, productToEdit: product);
                                    } else if (value == 'delete') {
                                      _confirmDelete(context, product);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, color: Colors.blue, size: 18),
                                          SizedBox(width: 8),
                                          Text('Editar'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, color: Colors.red, size: 18),
                                          SizedBox(width: 8),
                                          Text('Eliminar'),
                                        ],
                                      ),
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