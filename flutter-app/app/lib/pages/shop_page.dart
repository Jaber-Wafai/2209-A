import 'package:app/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:app/models/product.dart';
import 'package:app/services/product_service.dart';
import 'product_details_page.dart';

const Color primaryGreen = Color(0xFF2D6A4F);
const Color darkGreenText = Color(0xFF1B4332);

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Product> _products = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }
Future<void> _fetchProducts() async {
  try {
    final productService = ProductService();
    final fetchedProducts = await productService.getAllProducts();
    print("Fetched products: $fetchedProducts"); // bu satırı ekle
    setState(() {
      _products = fetchedProducts;
      _isLoading = false;
    });
  } catch (e) {
    print("Error loading products: $e");
    setState(() {
      _isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürünler'),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text("Hata: $_error"))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 3 / 4,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(product: _products[index]);
                  },
                ),
    );
  }
}
