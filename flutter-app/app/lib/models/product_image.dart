class ProductImage {
  final int id;
  final String imageUrl;
  final bool isPrimary;
  final int productId;

  ProductImage({
    required this.id,
    required this.imageUrl,
    required this.isPrimary,
    required this.productId,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      imageUrl: json['image_url'],
      isPrimary: json['is_primary'],
      productId: json['product_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'is_primary': isPrimary,
      'product_id': productId,
    };
  }
}
