import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/models/category.dart';
import 'api_service.dart';

class CategoryService {
  final String baseUrl = ApiService.baseUrl;

  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));

    if (response.statusCode == 200) {
      List jsonList = json.decode(response.body);
      return jsonList.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load categories");
    }
  }

  Future<Category> addCategory(Category category) async {
    final response = await http.post(
      Uri.parse('$baseUrl/categories'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(category.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Category.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add category');
    }
  }
}
