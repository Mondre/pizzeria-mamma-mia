enum DeliveryType {
  delivery,
  pickup,
}

enum PaymentMethod {
  cash,
  card,
}

class DeliveryInfo {
  final DeliveryType type;
  final String? address; // Richiesto solo per consegna
  final PaymentMethod paymentMethod;
  final DateTime desiredTime;
  final String lastName;
  final String phoneNumber;

  DeliveryInfo({
    required this.type,
    this.address,
    required this.paymentMethod,
    required this.desiredTime,
    required this.lastName,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'address': address,
      'paymentMethod': paymentMethod.name,
      'desiredTime': desiredTime.toIso8601String(),
      'lastName': lastName,
      'phoneNumber': phoneNumber,
    };
  }

  factory DeliveryInfo.fromMap(Map<String, dynamic> map) {
    return DeliveryInfo(
      type: DeliveryType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => DeliveryType.pickup,
      ),
      address: map['address'],
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == map['paymentMethod'],
        orElse: () => PaymentMethod.cash,
      ),
      desiredTime: DateTime.parse(map['desiredTime']),
      lastName: map['lastName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }

  String getTypeLabel() {
    return type == DeliveryType.delivery ? 'Consegna' : 'Ritiro al banco';
  }

  String getPaymentLabel() {
    return paymentMethod == PaymentMethod.cash ? 'Contanti' : 'Carta';
  }
}
