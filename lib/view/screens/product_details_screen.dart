import 'package:ecommerce/model/product_model.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(product.image),
            SizedBox(height: 16),
            Text(product.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('\$${product.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
            // Add more details here
          ],
        ),
      ),
    );
  }
}
