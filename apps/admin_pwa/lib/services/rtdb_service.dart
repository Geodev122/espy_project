import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rtdbServiceProvider = Provider((ref) => RealtimeDatabaseService());

class RealtimeDatabaseService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  Stream<Map<String, dynamic>> watchAllProfessionals() {
    return _db.ref('directory_professionals').onValue.map((event) {
      final data = event.snapshot.value as Map?;
      if (data == null) return {};
      return Map<String, dynamic>.from(data);
    });
  }

  Stream<Map<String, dynamic>> watchAllUsers() {
    return _db.ref('users').onValue.map((event) {
      final data = event.snapshot.value as Map?;
      if (data == null) return {};
      return Map<String, dynamic>.from(data);
    });
  }

  Future<void> updateNode(String path, Map<String, dynamic> data) async {
    await _db.ref(path).update(data);
  }

  Future<void> setNode(String path, dynamic data) async {
    await _db.ref(path).set(data);
  }

  Future<void> deleteNode(String path) async {
    await _db.ref(path).remove();
  }

  Future<Map<String, dynamic>?> getNode(String path) async {
    final snap = await _db.ref(path).get();
    if (snap.exists) {
      return Map<String, dynamic>.from(snap.value as Map);
    }
    return null;
  }
}
