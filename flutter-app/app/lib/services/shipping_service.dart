import 'package:app/models/shipping.dart';
import 'api_service.dart';

class ShippingService {
  final ApiService _apiService = ApiService();

  Future<List<Shipping>> getAllShipping() async {
    final data = await _apiService.get('shipping');
    return (data as List).map((json) => Shipping.fromJson(json)).toList();
  }

  Future<Shipping> createShipping(Shipping shipping) async {
    final data = await _apiService.post('shipping', shipping.toJson());
    return Shipping.fromJson(data);
  }
}
