// models/credit_card.dart

class CreditCard {
  final String cardHolder;
  final String cardNumber;
  final String expiryDate;
  final String cvv;

  CreditCard({
    required this.cardHolder,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
  });

  Map<String, dynamic> toJson() {
    return {
      'cardHolder': cardHolder,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvv': cvv,
    };
  }
}
