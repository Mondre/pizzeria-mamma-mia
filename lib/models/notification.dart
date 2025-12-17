import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  orderAccepted,
  orderScheduled,
  orderReady,
  orderDelivered,
}

class AppNotification {
  final String id;
  final String userId;
  final String orderId;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool read;

  AppNotification({
    required this.id,
    required this.userId,
    required this.orderId,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    this.read = false,
  });

  factory AppNotification.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppNotification(
      id: doc.id,
      userId: data['userId'] ?? '',
      orderId: data['orderId'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => NotificationType.orderAccepted,
      ),
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      read: data['read'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'orderId': orderId,
      'type': type.name,
      'title': title,
      'message': message,
      'createdAt': Timestamp.fromDate(createdAt),
      'read': read,
    };
  }
}
