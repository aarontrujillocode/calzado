import 'package:flutter/material.dart';
import 'package:app_calzado/models/product_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? selectedSize;
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final bool tieneStock = widget.product.stockTotal > 0;
    
    // Convertir la cadena "39, 40, 41" en una lista de tallas
    List<String> tallasDisponibles = widget.product.tallas
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.nombre),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del Producto
            Image.network(
              widget.product.imagen.isNotEmpty 
                  ? widget.product.imagen 
                  : 'https://via.placeholder.com/400',
              height: 280,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categoría y Subcategoría
                  Text(
                    '${widget.product.categoria} • ${widget.product.subcategoria}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  
                  // Nombre y Precio
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.nombre,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        'S/ ${widget.product.precio.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 22, 
                          fontWeight: FontWeight.bold, 
                          color: Color(0xFFFF4B3E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Descripción
                  Text(
                    widget.product.descripcion,
                    style: TextStyle(color: Colors.grey[800], height: 1.4),
                  ),
                  const SizedBox(height: 20),

                  // Selector de Tallas
                  if (tieneStock && tallasDisponibles.isNotEmpty) ...[
                    const Text(
                      'Selecciona tu Talla:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: tallasDisponibles.map((talla) {
                        final bool isSelected = selectedSize == talla;
                        return ChoiceChip(
                          label: Text(talla),
                          selected: isSelected,
                          selectedColor: const Color(0xFFFF4B3E),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (selected) {
                            setState(() {
                              selectedSize = selected ? talla : null;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Indicador de Stock
                  Row(
                    children: [
                      Icon(
                        tieneStock ? Icons.check_circle : Icons.cancel,
                        color: tieneStock ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        tieneStock 
                            ? 'Stock disponible (${widget.product.stockTotal} unidades)' 
                            : 'Producto Agotado',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: tieneStock ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Botón Inferior Fijo para Agregar al Carrito
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: tieneStock
                ? () {
                    if (tallasDisponibles.isNotEmpty && selectedSize == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, selecciona una talla primero.'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }

                    // Aquí conectaremos la lógica del Carrito
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${widget.product.nombre} (Talla $selectedSize) agregado'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                : null, // Deshabilitado si no hay stock
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4B3E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              tieneStock ? 'AGREGAR AL CARRITO' : 'AGOTADO',
              style: const TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold, 
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}