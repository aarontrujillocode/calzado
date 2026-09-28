import 'package:flutter/material.dart';
import 'package:app_calzado/models/product_model.dart';
import 'package:app_calzado/services/cart_service.dart';

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
    const primaryColor = Color(0xFF0F2042);
    const accentColor = Color(0xFFFF4B3E);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.nombre),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Image.network(
              widget.product.imagen.isNotEmpty
                  ? widget.product.imagen
                  : 'https://via.placeholder.com/400',
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 300,
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image, size: 80, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.nombre,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'S/ ${widget.product.precio.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.product.descripcion,
                    style: const TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                  const SizedBox(height: 24),

                  // Botón para agregar al carrito
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: widget.product.stockTotal > 0
                          ? () {
                              final String tallaElegida = selectedSize ?? 'Unica';
                              CartService.instance.addProduct(
                                widget.product,
                                tallaElegida,
                                cantidad: quantity,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${widget.product.nombre} (Talla: $tallaElegida) agregado al carrito',
                                  ),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          : null,
                      child: Text(
                        widget.product.stockTotal > 0
                            ? 'AGREGAR AL CARRITO'
                            : 'AGOTADO',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}