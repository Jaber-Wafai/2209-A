class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String? shippingTime;
  final double trendyolPrice;
  final String trendyolUrl;
  final double vatRate;
  final int categoryId;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    this.shippingTime,
    required this.trendyolPrice,
    required this.trendyolUrl,
    required this.vatRate,
    required this.categoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      shippingTime: json['shipping_time']?.toString(),
      trendyolPrice: (json['trendyol_price'] ?? 0).toDouble(),
      trendyolUrl: json['trendyol_url'] ?? '',
      vatRate: (json['vat_rate'] ?? 0).toDouble(),
      categoryId: json['category_id'] ?? 0,
    );
  }

  String? get imageUrl => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'shipping_time': shippingTime,
      'trendyol_price': trendyolPrice,
      'trendyol_url': trendyolUrl,
      'vat_rate': vatRate,
      'category_id': categoryId,
    };
  }
}
