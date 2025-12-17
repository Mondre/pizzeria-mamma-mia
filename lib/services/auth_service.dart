import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Login
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Registrazione
  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? address,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Crea il documento utente in Firestore
      if (credential.user != null) {
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'email': email,
          'name': name,
          'phone': phone,
          'address': address,
          'isAdmin': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      notifyListeners();
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  // Controlla se l'utente è admin
  Future<bool> isAdmin() async {
    if (currentUser == null) return false;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (doc.exists) {
        return doc.data()?['isAdmin'] ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Ottieni dati utente
  Future<UserModel?> getUserData() async {
    if (currentUser == null) return null;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Errore nel caricamento dati utente: $e');
    }
  }

  // Aggiorna profilo utente
  Future<void> updateUserProfile({
    String? name,
    String? phone,
    String? address,
  }) async {
    if (currentUser == null) return;

    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (phone != null) updates['phone'] = phone;
      if (address != null) updates['address'] = address;

      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .update(updates);

      notifyListeners();
    } catch (e) {
      throw Exception('Errore nell\'aggiornamento del profilo: $e');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Gestione errori
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Nessun utente trovato con questa email.';
      case 'wrong-password':
        return 'Password errata.';
      case 'email-already-in-use':
        return 'Email già in uso.';
      case 'weak-password':
        return 'Password troppo debole.';
      case 'invalid-email':
        return 'Email non valida.';
      case 'user-disabled':
        return 'Account disabilitato.';
      default:
        return 'Errore di autenticazione: ${e.message}';
    }
  }
}
