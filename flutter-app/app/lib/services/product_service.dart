import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  final String baseUrl =
      "http://192.168.1.161:8080/api/products"; // Change if needed

  Future<List<Product>> getAllProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception("Failed to fetch products");
    }
  }
}
