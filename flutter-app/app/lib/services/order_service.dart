import 'package:app/models/order.dart';
import 'api_service.dart';

class OrderService {
  final ApiService _apiService = ApiService();

  Future<List<Order>> getAllOrders() async {
    final data = await _apiService.get('orders');
    return (data as List).map((json) => Order.fromJson(json)).toList();
  }

  Future<Order> createOrder(Order order) async {
    final data = await _apiService.post('orders', order.toJson());
    return Order.fromJson(data);
  }
}
