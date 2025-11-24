import 'package:app/models/wishlist.dart';
import 'api_service.dart';

class WishlistService {
  final ApiService _apiService = ApiService();

  Future<List<Wishlist>> getAllWishlistItems() async {
    final data = await _apiService.get('wishlists');
    return (data as List).map((json) => Wishlist.fromJson(json)).toList();
  }

  Future<Wishlist> createWishlistItem(Wishlist item) async {
    final data = await _apiService.post('wishlists', item.toJson());
    return Wishlist.fromJson(data);
  }
}
