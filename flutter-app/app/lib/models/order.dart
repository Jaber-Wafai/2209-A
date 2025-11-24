class Order {
  final int id;
  final int userId;
  final DateTime orderDate;
  final double totalPrice;
  final String status;

  Order({
    required this.id,
    required this.userId,
    required this.orderDate,
    required this.totalPrice,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      orderDate: DateTime.parse(json['order_date']),
      totalPrice: json['total_price'].toDouble(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'order_date': orderDate.toIso8601String(),
      'total_price': totalPrice,
      'status': status,
    };
  }
}
