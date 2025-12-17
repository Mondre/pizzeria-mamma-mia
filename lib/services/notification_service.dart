import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/notification.dart';

class NotificationService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream delle notifiche dell'utente
  Stream<List<AppNotification>> getUserNotificationsStream(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final notifications = snapshot.docs
          .map((doc) => AppNotification.fromFirestore(doc))
          .toList();
      // Ordina manualmente per evitare indici Firestore
      notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return notifications;
    });
  }

  // Conta notifiche non lette
  Stream<int> getUnreadCountStream(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('read', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Crea notifica per ordine accettato
  Future<void> notifyOrderAccepted(String userId, String orderId, String orderNumber) async {
    await _firestore.collection('notifications').add(
      AppNotification(
        id: '',
        userId: userId,
        orderId: orderId,
        type: NotificationType.orderAccepted,
        title: 'Ordine Accettato! 🎉',
        message: 'Il tuo ordine #$orderNumber è stato accettato ed è in preparazione.',
        createdAt: DateTime.now(),
      ).toMap(),
    );
  }

  // Crea notifica per orario confermato/modificato
  Future<void> notifyScheduleChanged(
    String userId,
    String orderId,
    String orderNumber,
    DateTime scheduledTime,
  ) async {
    final timeStr = DateFormat('dd/MM/yyyy HH:mm').format(scheduledTime);
    await _firestore.collection('notifications').add(
      AppNotification(
        id: '',
        userId: userId,
        orderId: orderId,
        type: NotificationType.orderScheduled,
        title: 'Orario Confermato ⏰',
        message: 'Il tuo ordine #$orderNumber sarà pronto per il $timeStr.',
        createdAt: DateTime.now(),
      ).toMap(),
    );
  }

  // Crea notifica per ordine pronto
  Future<void> notifyOrderReady(String userId, String orderId, String orderNumber) async {
    await _firestore.collection('notifications').add(
      AppNotification(
        id: '',
        userId: userId,
        orderId: orderId,
        type: NotificationType.orderReady,
        title: 'Ordine Pronto! 🍕',
        message: 'Il tuo ordine #$orderNumber è pronto per il ritiro/consegna.',
        createdAt: DateTime.now(),
      ).toMap(),
    );
  }

  // Segna come letta
  Future<void> markAsRead(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'read': true,
    });
  }

  // Segna tutte come lette
  Future<void> markAllAsRead(String userId) async {
    final batch = _firestore.batch();
    final snapshot = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('read', isEqualTo: false)
        .get();

    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'read': true});
    }

    await batch.commit();
  }

  // Elimina notifica
  Future<void> deleteNotification(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).delete();
  }
}
