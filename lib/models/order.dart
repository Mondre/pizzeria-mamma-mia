import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item.dart';
import 'delivery_info.dart';

enum OrderStatus {
  pending,    // In attesa
  accepted,   // Accettato
  preparing,  // In preparazione
  ready,      // Pronto
  delivered,  // Consegnato
  cancelled,  // Annullato
}

class Order {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final String? userAddress;
  final List<CartItem> items;
  final double totalAmount;
  final OrderStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DeliveryInfo? deliveryInfo;
  final DateTime? scheduledTime; // Orario modificato dall'admin

  Order({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    this.userAddress,
    required this.items,
    required this.totalAmount,
    required this.status,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    this.deliveryInfo,
    this.scheduledTime,
  });

  // Crea Order da Firestore
  factory Order.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Order(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userPhone: data['userPhone'] ?? '',
      userAddress: data['userAddress'],
      items: (data['items'] as List<dynamic>)
          .map((item) => CartItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${data['status']}',
        orElse: () => OrderStatus.pending,
      ),
      notes: data['notes'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      deliveryInfo: data['deliveryInfo'] != null
          ? DeliveryInfo.fromMap(data['deliveryInfo'] as Map<String, dynamic>)
          : null,
      scheduledTime: data['scheduledTime'] != null
          ? (data['scheduledTime'] as Timestamp).toDate()
          : null,
    );
  }

  // Converti in Map per Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'userAddress': userAddress,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status.toString().split('.').last,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'deliveryInfo': deliveryInfo?.toMap(),
      'scheduledTime': scheduledTime != null ? Timestamp.fromDate(scheduledTime!) : null,
    };
  }

  Order copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userPhone,
    String? userAddress,
    List<CartItem>? items,
    double? totalAmount,
    OrderStatus? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DeliveryInfo? deliveryInfo,
    DateTime? scheduledTime,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      userAddress: userAddress ?? this.userAddress,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deliveryInfo: deliveryInfo ?? this.deliveryInfo,
      scheduledTime: scheduledTime ?? this.scheduledTime,
    );
  }

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'In attesa';
      case OrderStatus.accepted:
        return 'Accettato';
      case OrderStatus.preparing:
        return 'In preparazione';
      case OrderStatus.ready:
        return 'Pronto';
      case OrderStatus.delivered:
        return 'Consegnato';
      case OrderStatus.cancelled:
        return 'Annullato';
    }
  }

  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}
