class Payment {
  final int id;
  final int orderId;
  final String method;
  final String status;
  final DateTime paymentDate;

  Payment({
    required this.id,
    required this.orderId,
    required this.method,
    required this.status,
    required this.paymentDate,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      orderId: json['order_id'],
      method: json['method'],
      status: json['status'],
      paymentDate: DateTime.parse(json['payment_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'method': method,
      'status': status,
      'payment_date': paymentDate.toIso8601String(),
    };
  }
}
