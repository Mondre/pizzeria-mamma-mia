import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order.dart' as models;
import '../models/cart_item.dart';
import '../models/delivery_info.dart';
import 'notification_service.dart';

class OrderService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService _notificationService;
  List<models.Order> _orders = [];
  bool _isLoading = false;

  OrderService(this._notificationService);

  List<models.Order> get orders => _orders;
  bool get isLoading => _isLoading;

  // Stream di tutti gli ordini (per admin)
  Stream<List<models.Order>> getAllOrdersStream() {
    return _firestore
        .collection('orders')
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs
          .map((doc) => models.Order.fromFirestore(doc))
          .toList();
      // Ordina manualmente per evitare indici Firestore
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    });
  }

  // Stream degli ordini dell'utente
  Stream<List<models.Order>> getUserOrdersStream(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs
          .map((doc) => models.Order.fromFirestore(doc))
          .toList();
      // Ordina manualmente per evitare indici Firestore
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    });
  }

  // Stream ordini in tempo reale per stato (per admin)
  Stream<List<models.Order>> getOrdersByStatusStream(models.OrderStatus status) {
    return _firestore
        .collection('orders')
        .where('status', isEqualTo: status.toString().split('.').last)
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs
          .map((doc) => models.Order.fromFirestore(doc))
          .toList();
      // Ordina manualmente per evitare indici Firestore
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    });
  }

  // Crea nuovo ordine con delivery info
  Future<String> createOrderWithDelivery({
    required String userId,
    required String userName,
    required String userPhone,
    String? userAddress,
    required List<CartItem> items,
    required double totalAmount,
    String? notes,
    required DeliveryInfo deliveryInfo,
  }) async {
    try {
      final order = models.Order(
        id: '',
        userId: userId,
        userName: userName,
        userPhone: userPhone,
        userAddress: userAddress,
        items: items,
        totalAmount: totalAmount,
        status: models.OrderStatus.pending,
        notes: notes,
        createdAt: DateTime.now(),
        deliveryInfo: deliveryInfo,
      );

      final docRef = await _firestore.collection('orders').add(order.toMap());
      notifyListeners();
      return docRef.id;
    } catch (e) {
      throw Exception('Errore nella creazione dell\'ordine: $e');
    }
  }

  // Crea nuovo ordine (metodo legacy, mantienilo per compatibilità)
  Future<String> createOrder({
    required String userId,
    required String userName,
    required String userPhone,
    String? userAddress,
    required List<CartItem> items,
    String? notes,
  }) async {
    try {
      final totalAmount = items.fold<double>(
        0,
        (sum, item) => sum + item.totalPrice,
      );

      final order = models.Order(
        id: '',
        userId: userId,
        userName: userName,
        userPhone: userPhone,
        userAddress: userAddress,
        items: items,
        totalAmount: totalAmount,
        status: models.OrderStatus.pending,
        notes: notes,
        createdAt: DateTime.now(),
      );

      final docRef = await _firestore.collection('orders').add(order.toMap());
      notifyListeners();
      return docRef.id;
    } catch (e) {
      throw Exception('Errore nella creazione dell\'ordine: $e');
    }
  }

  // Aggiorna stato ordine (admin)
  Future<void> updateOrderStatus(String orderId, models.OrderStatus status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status.toString().split('.').last,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      // Invia notifica se lo stato è "accettato"
      if (status == models.OrderStatus.accepted) {
        final orderDoc = await _firestore.collection('orders').doc(orderId).get();
        if (orderDoc.exists) {
          final order = models.Order.fromFirestore(orderDoc);
          await _notificationService.notifyOrderAccepted(
            order.userId,
            orderId,
            orderId.substring(0, 8),
          );
        }
      }
      
      notifyListeners();
    } catch (e) {
      throw Exception('Errore nell\'aggiornamento dello stato: $e');
    }
  }

  // Aggiorna orario schedulato (admin)
  Future<void> updateScheduledTime(String orderId, DateTime scheduledTime) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'scheduledTime': Timestamp.fromDate(scheduledTime),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      // Invia notifica al cliente
      final orderDoc = await _firestore.collection('orders').doc(orderId).get();
      if (orderDoc.exists) {
        final order = models.Order.fromFirestore(orderDoc);
        await _notificationService.notifyScheduleChanged(
          order.userId,
          orderId,
          orderId.substring(0, 8),
          scheduledTime,
        );
      }
      
      notifyListeners();
    } catch (e) {
      throw Exception('Errore nell\'aggiornamento dell\'orario: $e');
    }
  }

  // Aggiorna ordine (admin)
  Future<void> updateOrder(models.Order order) async {
    try {
      await _firestore.collection('orders').doc(order.id).update({
        ...order.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      notifyListeners();
    } catch (e) {
      throw Exception('Errore nell\'aggiornamento dell\'ordine: $e');
    }
  }

  // Elimina ordine (admin)
  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();
      notifyListeners();
    } catch (e) {
      throw Exception('Errore nell\'eliminazione dell\'ordine: $e');
    }
  }

  // Carica ordini utente
  Future<void> loadUserOrders(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _orders = snapshot.docs.map((doc) => models.Order.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Errore nel caricamento degli ordini: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Carica tutti gli ordini (admin)
  Future<void> loadAllOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      _orders = snapshot.docs.map((doc) => models.Order.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Errore nel caricamento degli ordini: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Ottieni ordine per ID
  Future<models.Order?> getOrderById(String orderId) async {
    try {
      final doc = await _firestore.collection('orders').doc(orderId).get();
      if (doc.exists) {
        return models.Order.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Errore nel caricamento dell\'ordine: $e');
    }
  }

  // Statistiche ordini per admin
  Future<Map<String, dynamic>> getOrderStatistics() async {
    try {
      final snapshot = await _firestore.collection('orders').get();
      final orders = snapshot.docs.map((doc) => models.Order.fromFirestore(doc)).toList();

      final totalOrders = orders.length;
      final totalRevenue = orders
          .where((o) => o.status != models.OrderStatus.cancelled)
          .fold<double>(0, (sum, order) => sum + order.totalAmount);

      final pendingOrders = orders.where((o) => o.status == models.OrderStatus.pending).length;
      final completedOrders = orders.where((o) => o.status == models.OrderStatus.delivered).length;

      return {
        'totalOrders': totalOrders,
        'totalRevenue': totalRevenue,
        'pendingOrders': pendingOrders,
        'completedOrders': completedOrders,
      };
    } catch (e) {
      throw Exception('Errore nel calcolo delle statistiche: $e');
    }
  }
}
