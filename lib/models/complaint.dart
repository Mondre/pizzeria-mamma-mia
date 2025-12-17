import 'package:cloud_firestore/cloud_firestore.dart';

class Complaint {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String orderId;
  final String description;
  final List<String> imageUrls;
  final DateTime createdAt;
  final String status; // 'pending', 'in_review', 'resolved'
  final String? adminResponse;
  final DateTime? responseDate;

  Complaint({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.orderId,
    required this.description,
    required this.imageUrls,
    required this.createdAt,
    this.status = 'pending',
    this.adminResponse,
    this.responseDate,
  });

  factory Complaint.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Complaint(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userEmail: data['userEmail'] ?? '',
      orderId: data['orderId'] ?? '',
      description: data['description'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      status: data['status'] ?? 'pending',
      adminResponse: data['adminResponse'],
      responseDate: data['responseDate'] != null
          ? (data['responseDate'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'orderId': orderId,
      'description': description,
      'imageUrls': imageUrls,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status,
      'adminResponse': adminResponse,
      'responseDate': responseDate != null
          ? Timestamp.fromDate(responseDate!)
          : null,
    };
  }

  Complaint copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userEmail,
    String? orderId,
    String? description,
    List<String>? imageUrls,
    DateTime? createdAt,
    String? status,
    String? adminResponse,
    DateTime? responseDate,
  }) {
    return Complaint(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      orderId: orderId ?? this.orderId,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      adminResponse: adminResponse ?? this.adminResponse,
      responseDate: responseDate ?? this.responseDate,
    );
  }
}
