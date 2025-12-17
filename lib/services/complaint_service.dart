import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/complaint.dart';

class ComplaintService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Crea un nuovo reclamo
  Future<String> createComplaint({
    required String userId,
    required String userName,
    required String userEmail,
    required String orderId,
    required String description,
    List<File>? images,
  }) async {
    try {
      // Upload immagini
      List<String> imageUrls = [];
      if (images != null && images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          final ref = _storage.ref().child(
              'complaints/$userId/${DateTime.now().millisecondsSinceEpoch}_$i.jpg');
          await ref.putFile(images[i]);
          final url = await ref.getDownloadURL();
          imageUrls.add(url);
        }
      }

      // Crea reclamo
      final complaint = Complaint(
        id: '',
        userId: userId,
        userName: userName,
        userEmail: userEmail,
        orderId: orderId,
        description: description,
        imageUrls: imageUrls,
        createdAt: DateTime.now(),
      );

      final docRef = await _firestore.collection('complaints').add(complaint.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Errore durante la creazione del reclamo: $e');
    }
  }

  // Ottieni tutti i reclami di un utente
  Stream<List<Complaint>> getUserComplaints(String userId) {
    return _firestore
        .collection('complaints')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Complaint.fromFirestore(doc)).toList());
  }

  // Ottieni tutti i reclami (per admin)
  Stream<List<Complaint>> getAllComplaints() {
    return _firestore
        .collection('complaints')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Complaint.fromFirestore(doc)).toList());
  }

  // Aggiorna lo stato del reclamo
  Future<void> updateComplaintStatus(String complaintId, String status) async {
    try {
      await _firestore.collection('complaints').doc(complaintId).update({
        'status': status,
      });
    } catch (e) {
      throw Exception('Errore durante l\'aggiornamento dello stato: $e');
    }
  }

  // Aggiungi risposta admin
  Future<void> addAdminResponse(String complaintId, String response) async {
    try {
      await _firestore.collection('complaints').doc(complaintId).update({
        'adminResponse': response,
        'responseDate': Timestamp.now(),
        'status': 'resolved',
      });
    } catch (e) {
      throw Exception('Errore durante l\'aggiunta della risposta: $e');
    }
  }

  // Elimina reclamo
  Future<void> deleteComplaint(String complaintId) async {
    try {
      await _firestore.collection('complaints').doc(complaintId).delete();
    } catch (e) {
      throw Exception('Errore durante l\'eliminazione del reclamo: $e');
    }
  }
}
