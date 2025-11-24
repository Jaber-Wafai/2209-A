import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  final String baseUrl = "http://localhost:8080/api/products"; // gerektiğinde değiştir

  Future<List<Product>> getAllProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }
}
