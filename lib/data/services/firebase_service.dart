import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fire_safety_console/core/logger.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  late FirebaseAuth _auth;
  late FirebaseFirestore _firestore;
  late FirebaseStorage _storage;

  FirebaseService._internal() {
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    _storage = FirebaseStorage.instance;
  }

  factory FirebaseService() {
    return _instance;
  }

  // Auth methods
  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Logger.info('User signed up: ${credential.user?.email}',
          tag: 'FirebaseService');
      return credential;
    } on FirebaseAuthException catch (e) {
      Logger.error('Sign up failed: ${e.message}', tag: 'FirebaseService',
          exception: e);
      rethrow;
    }
  }

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Logger.info('User signed in: ${credential.user?.email}',
          tag: 'FirebaseService');
      return credential;
    } on FirebaseAuthException catch (e) {
      Logger.error('Sign in failed: ${e.message}', tag: 'FirebaseService',
          exception: e);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Logger.info('User signed out', tag: 'FirebaseService');
    } catch (e) {
      Logger.error('Sign out failed', tag: 'FirebaseService', exception: e);
      rethrow;
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  // Firestore methods
  Future<void> addDocument(String collection, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).add(data);
      Logger.info('Document added to $collection', tag: 'FirebaseService');
    } catch (e) {
      Logger.error('Failed to add document', tag: 'FirebaseService',
          exception: e);
      rethrow;
    }
  }

  Future<void> updateDocument(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(collection).doc(docId).update(data);
      Logger.info('Document updated in $collection', tag: 'FirebaseService');
    } catch (e) {
      Logger.error('Failed to update document', tag: 'FirebaseService',
          exception: e);
      rethrow;
    }
  }

  Future<void> deleteDocument(String collection, String docId) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
      Logger.info('Document deleted from $collection', tag: 'FirebaseService');
    } catch (e) {
      Logger.error('Failed to delete document', tag: 'FirebaseService',
          exception: e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getDocument(
      String collection, String docId) async {
    try {
      final doc = await _firestore.collection(collection).doc(docId).get();
      return doc.data();
    } catch (e) {
      Logger.error('Failed to get document', tag: 'FirebaseService',
          exception: e);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getCollection(String collection,
      {String? whereField, dynamic whereValue}) async {
    try {
      Query query = _firestore.collection(collection);
      if (whereField != null && whereValue != null) {
        query = query.where(whereField, isEqualTo: whereValue);
      }
      final snapshot = await query.get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      Logger.error('Failed to get collection', tag: 'FirebaseService',
          exception: e);
      rethrow;
    }
  }

  Stream<List<Map<String, dynamic>>> streamCollection(String collection) {
    return _firestore.collection(collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // Storage methods
  Future<String> uploadFile(String path, String filename) async {
    try {
      final ref = _storage.ref().child('uploads/$filename');
      await ref.putFile(File(path));
      final url = await ref.getDownloadURL();
      Logger.info('File uploaded: $filename', tag: 'FirebaseService');
      return url;
    } catch (e) {
      Logger.error('Failed to upload file', tag: 'FirebaseService',
          exception: e);
      rethrow;
    }
  }

  Future<void> deleteFile(String filename) async {
    try {
      await _storage.ref().child('uploads/$filename').delete();
      Logger.info('File deleted: $filename', tag: 'FirebaseService');
    } catch (e) {
      Logger.error('Failed to delete file', tag: 'FirebaseService',
          exception: e);
      rethrow;
    }
  }

  Future<String> getDownloadUrl(String filename) async {
    try {
      final url =
          await _storage.ref().child('uploads/$filename').getDownloadURL();
      return url;
    } catch (e) {
      Logger.error('Failed to get download URL', tag: 'FirebaseService',
          exception: e);
      rethrow;
    }
  }
}
