import 'package:app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/shop_page.dart';

const Color primaryGreen = Color(0xFF2D6A4F);
const Color darkGreenText = Color(0xFF1B4332);

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: darkGreenText)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('₺${product.price}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryGreen)),
                    const SizedBox(width: 8),
                    if (product.price != null && product.price! > product.price)
                      Text('₺${product.price}', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 16),
                Text(product.description, style: const TextStyle(fontSize: 16, color: darkGreenText)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Sepete Ekle'),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
