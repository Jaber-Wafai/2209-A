import 'package:app/models/cart.dart';
import 'api_service.dart';

class CartService {
  final ApiService _apiService = ApiService();

  Future<List<Cart>> getAllCarts() async {
    final data = await _apiService.get('carts');
    return (data as List).map((json) => Cart.fromJson(json)).toList();
  }

  Future<Cart> createCart(Cart cart) async {
    final data = await _apiService.post('carts', cart.toJson());
    return Cart.fromJson(data);
  }
}
