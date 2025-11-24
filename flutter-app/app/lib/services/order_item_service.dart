import 'package:app/models/order_item.dart';
import 'api_service.dart';

class OrderItemService {
  final ApiService _apiService = ApiService();

  Future<List<OrderItem>> getAllOrderItems() async {
    final data = await _apiService.get('order-items');
    return (data as List).map((json) => OrderItem.fromJson(json)).toList();
  }

  Future<OrderItem> createOrderItem(OrderItem item) async {
    final data = await _apiService.post('order-items', item.toJson());
    return OrderItem.fromJson(data);
  }
}
