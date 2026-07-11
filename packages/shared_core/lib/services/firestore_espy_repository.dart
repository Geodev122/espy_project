import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:rxdart/rxdart.dart';
import '../models/user_model.dart';
import 'espy_repository.dart';

class FirestoreEspyRepository implements EspyRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(region: 'us-central1');

  @override
  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  @override
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).set({...data, 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
  }

  @override
  Stream<List<Map<String, dynamic>>> getAllProviders() {
    return Rx.combineLatest2(
      _db.collection('directory_professionals').snapshots(),
      _db.collection('directory_institutions').snapshots(),
      (QuerySnapshot profs, QuerySnapshot insts) {
        final List<Map<String, dynamic>> all = [];
        all.addAll(profs.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).where((p) => p['isActive'] != false));
        all.addAll(insts.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).where((p) => p['isActive'] != false));
        return all;
      },
    );
  }

  @override
  Stream<List<Map<String, dynamic>>> getSectors() {
    return _db.collection('directory_sectors').snapshots().map((snap) =>
        snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());
  }

  @override
  Stream<List<Map<String, dynamic>>> getCountries() {
    return _db.collection('directory_countries').snapshots().map((snap) =>
        snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());
  }

  @override
  Stream<List<Map<String, dynamic>>> getUserTransactions(String uid) {
    return _db.collection('directory_membership_transactions')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());
  }

  @override
  Future<Map<String, dynamic>> spendTokens({required String userId, required String itemId, required int cost, required String role}) async {
    final result = await _functions.httpsCallable('spendTokens').call({
      'userId': userId,
      'itemId': itemId,
      'cost': cost,
      'role': role,
    });
    return result.data as Map<String, dynamic>;
  }

  @override
  Stream<List<Map<String, dynamic>>> getActiveServices() {
    return _db.collection('directory_services').where('isActive', isEqualTo: true).snapshots().map((snap) =>
        snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());
  }

  @override
  Stream<List<Map<String, dynamic>>> getProfessionalServices(String professionalId) {
    return _db.collection('directory_services')
        .where('professionalId', isEqualTo: professionalId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());
  }

  @override
  Future<void> toggleServiceSlot(String serviceId, bool allocate) async {
    await _db.collection('directory_services').doc(serviceId).update({
      'isAllocated': allocate,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> recordInteraction({required String userId, required String targetId, required String type}) async {
    await _db.collection('directory_interactions').add({
      'userId': userId,
      'targetId': targetId,
      'type': type,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> toggleFavorite(String userId, String professionalId, bool isFavorite) async {
    final favId = '${userId}_$professionalId';
    if (isFavorite) {
      await _db.collection('directory_favorites').doc(favId).set({
        'userId': userId,
        'professionalId': professionalId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      await _db.collection('directory_favorites').doc(favId).delete();
    }
  }

  @override
  Stream<List<String>> getFavoriteIds(String userId) {
    return _db.collection('directory_favorites')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => doc.data()['professionalId'] as String).toList());
  }

  @override
  Stream<List<String>> getContactedIds(String userId) {
    return _db.collection('directory_interactions')
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: 'like')
        .snapshots()
        .map((snap) => snap.docs.map((doc) => doc.data()['targetId'] as String).toList());
  }

  @override
  Stream<List<Map<String, dynamic>>> getCommunityRequests({String? sectionId, bool newestFirst = true, String? userId}) {
    Query query = _db.collection('directory_community_requests');
    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    } else {
      query = query.where('status', isEqualTo: 'active');
      if (sectionId != null && sectionId != 'All') {
        query = query.where('sectionId', isEqualTo: sectionId);
      }
    }
    return query.snapshots().map((snap) {
      final items = snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
      items.sort((a, b) {
        final t1 = (a['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
        final t2 = (b['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
        return newestFirst ? t2.compareTo(t1) : t1.compareTo(t2);
      });
      return items;
    });
  }

  @override
  Future<void> favoriteRequest(String userId, String requestId, bool isFavorite) async {
    final favId = '${userId}_$requestId';
    if (isFavorite) {
      await _db.collection('directory_favorites').doc(favId).set({
        'userId': userId,
        'requestId': requestId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      await _db.collection('directory_favorites').doc(favId).delete();
    }
  }
}
