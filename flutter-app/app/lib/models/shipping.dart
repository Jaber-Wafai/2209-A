class Shipping {
  final int id;
  final int orderId;
  final String address;
  final String city;
  final String postalCode;
  final String country;
  final String status;

  Shipping({
    required this.id,
    required this.orderId,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.status,
  });

  factory Shipping.fromJson(Map<String, dynamic> json) {
    return Shipping(
      id: json['id'],
      orderId: json['order_id'],
      address: json['address'],
      city: json['city'],
      postalCode: json['postal_code'],
      country: json['country'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'address': address,
      'city': city,
      'postal_code': postalCode,
      'country': country,
      'status': status,
    };
  }
}
