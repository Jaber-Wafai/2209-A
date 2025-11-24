class Cart {
  final int id;
  final int userId;
  final int productId;
  final int quantity;

  Cart({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['user_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
    };
  }
}
