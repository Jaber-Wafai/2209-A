import 'package:app/models/product_image.dart';
import 'api_service.dart';

class ProductImageService {
  final ApiService _apiService = ApiService();

  Future<List<ProductImage>> getAllProductImages() async {
    final data = await _apiService.get('product-images');
    return (data as List).map((json) => ProductImage.fromJson(json)).toList();
  }

  Future<ProductImage> createProductImage(ProductImage image) async {
    final data = await _apiService.post('product-images', image.toJson());
    return ProductImage.fromJson(data);
  }
}
