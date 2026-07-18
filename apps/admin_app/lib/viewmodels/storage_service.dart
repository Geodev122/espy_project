import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProfileImage({
    required String userId,
    required File file,
  }) async {
    try {
      final ref = _storage.ref().child('users/$userId/profile.jpg');
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Storage Upload Error: $e');
      rethrow;
    }
  }

  Future<String> uploadProfileImageWeb({
    required String userId,
    required Uint8List bytes,
  }) async {
    try {
      final ref = _storage.ref().child('users/$userId/profile.jpg');
      final uploadTask = await ref.putData(
        bytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Storage Web Upload Error: $e');
      rethrow;
    }
  }

  Future<String> uploadIdentityProof({
    required String userId,
    required File file,
    required String fileName,
  }) async {
    try {
      final ref = _storage.ref().child('users/$userId/identity_proof_$fileName');
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Storage Proof Upload Error: $e');
      rethrow;
    }
  }

  Future<String> uploadIdentityProofWeb({
    required String userId,
    required Uint8List bytes,
    required String fileName,
  }) async {
    try {
      final ref = _storage.ref().child('users/$userId/identity_proof_$fileName');
      final uploadTask = await ref.putData(bytes);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Storage Web Proof Upload Error: $e');
      rethrow;
    }
  }

  Future<String> uploadServiceImage({
    required String? userId,
    required File file,
  }) async {
    if (userId == null) throw Exception('User ID is required for upload');
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('directory_services/$userId/$fileName');
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Storage Service Upload Error: $e');
      rethrow;
    }
  }

  Future<String> uploadServiceImageWeb({
    required String? userId,
    required Uint8List bytes,
  }) async {
    if (userId == null) throw Exception('User ID is required for upload');
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('directory_services/$userId/$fileName');
      final uploadTask = await ref.putData(
        bytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Storage Service Web Upload Error: $e');
      rethrow;
    }
  }
}
