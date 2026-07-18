import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:rxdart/rxdart.dart';
import '../models/user_model.dart';
import '../models/professional_profile.dart';
import '../models/institution_profile.dart';
import '../models/visitor_profile.dart';
import 'espy_repository.dart';

class FirestoreEspyRepository implements EspyRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(region: 'us-central1');

  // ─── 1. Identity & Profiles ──────────────────────────────────────────────

  @override
  Future<UserModel?> getUser(String id) async {
    final doc = await _db.collection<Map<String, dynamic>>('users').doc<Map<String, dynamic>>(id).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    await _db.collection<Map<String, dynamic>>('users').doc<Map<String, dynamic>>(id).set({...data, 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
  }

  @override
  Future<ProfessionalProfile?> getProfessionalProfile(String id) async {
    final doc = await _db.collection<Map<String, dynamic>>('directory_professionals').doc<Map<String, dynamic>>(id).get();
    return doc.exists ? ProfessionalProfile.fromMap(doc.data() as Map<String, dynamic>) : null;
  }

  @override
  Future<InstitutionProfile?> getInstitutionProfile(String id) async {
    final doc = await _db.collection<Map<String, dynamic>>('directory_institutions').doc<Map<String, dynamic>>(id).get();
    return doc.exists ? InstitutionProfile.fromMap(doc.data() as Map<String, dynamic>) : null;
  }

  @override
  Future<VisitorProfile?> getVisitorProfile(String id) async {
    final doc = await _db.collection<Map<String, dynamic>>('directory_visitors').doc<Map<String, dynamic>>(id).get();
    return doc.exists ? VisitorProfile.fromMap(doc.data() as Map<String, dynamic>) : null;
  }

  // ─── 2. Taxonomy & Location ──────────────────────────────────────────────

  @override
  Stream<List<Map<String, dynamic>>> listSectors() {
    return _db.collection<Map<String, dynamic>>('directory_sectors').snapshots().map((snap) =>
        snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());
  }

  @override
  Stream<List<Map<String, dynamic>>> listCategories({String? sectorId}) {
    Query<Map<String, dynamic>> query = _db.collection<Map<String, dynamic>>('directory_categories');
    if (sectorId != null) query = query.where('sectorId', isEqualTo: sectorId);
    return query.snapshots().map((snap) =>
        snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());
  }

  @override
  Stream<List<Map<String, dynamic>>> listCountries() {
    return _db.collection<Map<String, dynamic>>('directory_countries').snapshots().map((snap) =>
        snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());
  }

  @override
  Stream<List<Map<String, dynamic>>> listLocationNodes(String userId) {
     return _db.collection<Map<String, dynamic>>('directory_locations').where('userId', isEqualTo: userId).snapshots().map((snap) =>
        snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());
  }

  // ─── 3. Core Business Logic ──────────────────────────────────────────────

  @override
  Stream<List<Map<String, dynamic>>> listActiveServices({String? categoryId, String? sectorId}) {
    Query<Map<String, dynamic>> query = _db.collection<Map<String, dynamic>>('directory_services').where('isActive', isEqualTo: true);
    if (categoryId != null) query = query.where('categoryId', isEqualTo: categoryId);
    if (sectorId != null) query = query.where('sectorId', isEqualTo: sectorId);

    return query.snapshots().map((snap) =>
        snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());
  }

  @override
  Stream<List<Map<String, dynamic>>> listProfessionalServices(String professionalId) {
    return _db.collection<Map<String, dynamic>>('directory_services')
        .where('professionalId', isEqualTo: professionalId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());
  }

  @override
  Future<void> toggleServiceSlot(String serviceId, bool allocate) async {
    await _db.collection<Map<String, dynamic>>('directory_services').doc<Map<String, dynamic>>(serviceId).update({
      'isAllocated': allocate,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<Map<String, dynamic>>> listCommunityRequests({String? sectorId, bool newestFirst = true, String? userId}) {
    Query<Map<String, dynamic>> query = _db.collection<Map<String, dynamic>>('directory_community_requests');
    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    } else {
      query = query.where('status', isEqualTo: 'active');
      if (sectorId != null && sectorId != 'All') {
        query = query.where('sectorId', isEqualTo: sectorId);
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
  Future<void> createCommunityRequest(Map<String, dynamic> data) async {
     await _db.collection<Map<String, dynamic>>('directory_community_requests').add({
       ...data,
       'createdAt': FieldValue.serverTimestamp(),
       'status': 'active',
     });
  }

  // ─── 4. Ledger & Analytics ───────────────────────────────────────────────

  @override
  Stream<List<Map<String, dynamic>>> listWalletTransactions(String userId) {
    return _db.collection<Map<String, dynamic>>('directory_membership_transactions')
        .where('userId', isEqualTo: userId)
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
  Future<void> recordInteraction({required String userId, required String targetId, required String type}) async {
    await _db.collection<Map<String, dynamic>>('directory_interactions').add({
      'userId': userId,
      'targetId': targetId,
      'type': type,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> toggleFavorite(String userId, String targetId, bool isFavorite) async {
    final favId = '${userId}_$targetId';
    if (isFavorite) {
      await _db.collection<Map<String, dynamic>>('directory_favorites').doc<Map<String, dynamic>>(favId).set({
        'userId': userId,
        'targetId': targetId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      await _db.collection<Map<String, dynamic>>('directory_favorites').doc<Map<String, dynamic>>(favId).delete();
    }
  }

  @override
  Stream<List<String>> listFavoriteIds(String userId) {
    return _db.collection<Map<String, dynamic>>('directory_favorites')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>?;
              return data?['targetId'] as String? ?? '';
            }).where((id) => id.isNotEmpty).toList());
  }

  @override
  Stream<List<String>> listContactedIds(String userId) {
    return _db.collection<Map<String, dynamic>>('directory_interactions')
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: 'like')
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>?;
              return data?['targetId'] as String? ?? '';
            }).where((id) => id.isNotEmpty).toList());
  }

  // ─── 5. Discovery & Helpers ──────────────────────────────────────────────

  @override
  Stream<List<Map<String, dynamic>>> listAllProviders() {
    return Rx.combineLatest2(
      _db.collection<Map<String, dynamic>>('directory_professionals').snapshots(),
      _db.collection<Map<String, dynamic>>('directory_institutions').snapshots(),
      (QuerySnapshot<Map<String, dynamic>> profs, QuerySnapshot<Map<String, dynamic>> insts) {
        final List<Map<String, dynamic>> all = [];
        all.addAll(profs.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).where((p) => p['isActive'] != false));
        all.addAll(insts.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).where((p) => p['isActive'] != false));
        return all;
      },
    );
  }
}
