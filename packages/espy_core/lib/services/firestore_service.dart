// ESPY PROTOCOL - FIRESTORE SERVICE v1.2
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'debug_service.dart';
import '../models/user_model.dart';
import '../models/service_model.dart';
import '../models/service_request.dart';
import '../models/enums.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DebugService _debug = DebugService();

  String get getCurrentUserId => _auth.currentUser?.uid ?? '';

  // ─── 1. Metadata ───────────────────────────────────────────────────────────

  Stream<List<Map<String, dynamic>>> getSectors() {
    _debug.log('FIRESTORE', 'Watch: directory_sectors');
    return _db
        .collection('directory_sectors')
        .snapshots()
        .map((snap) {
          final sectors = snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
          return sectors.where((s) => s['isActive'] == true || s['is_active'] == true).toList()
            ..sort((a, b) => (a['displayOrder'] as num? ?? 999).compareTo(b['displayOrder'] as num? ?? 999));
        });
  }

  Stream<List<Map<String, dynamic>>> getCategories(String type) {
    _debug.log('FIRESTORE', 'Watch: directory_categories ($type)');
    return _db
        .collection('directory_categories')
        .where('type', isEqualTo: type)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) {
              final data = doc.data();
              return {
                'id': doc.id, 
                ...data,
                'parent_id': data['parentSectorId'] ?? data['parent_id'] ?? data['parentCategoryId']
              };
            })
            .where((c) => c['isActive'] == true || c['is_active'] == true)
            .toList()
            ..sort((a, b) => (a['displayOrder'] as num? ?? 999).compareTo(b['displayOrder'] as num? ?? 999)));
  }

  Stream<List<Map<String, dynamic>>> getCountries() {
    return _db
        .collection('directory_countries')
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => {'id': doc.id, ...doc.data()})
            .toList()
            ..sort((a, b) => (a['name_en'] as String? ?? '').compareTo(b['name_en'] as String? ?? '')));
  }

  Stream<List<Map<String, dynamic>>> getGovernorates({String? countryId}) {
    Query query = _db.collection('directory_governorates');
    if (countryId != null && countryId != 'ALL') {
      query = query.where('country_id', isEqualTo: countryId);
    }
    return query.snapshots()
        .map((snap) =>
            snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList()
            ..sort((a, b) => (a['name_en'] as String? ?? '').compareTo(b['name_en'] as String? ?? '')));
  }

  Stream<List<Map<String, dynamic>>> getCities({String? governorateId}) {
    Query query = _db.collection('directory_cities');
    if (governorateId != null && governorateId != 'ALL') {
      query = query.where('governorate_id', isEqualTo: governorateId);
    }
    return query.snapshots()
        .map((snap) =>
            snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList()
            ..sort((a, b) => (a['name_en'] as String? ?? '').compareTo(b['name_en'] as String? ?? '')));
  }

  Stream<List<Map<String, dynamic>>> getServicePricingTags() {
    return _db
        .collection('directory_service_pricing_tags')
        .snapshots()
        .map((snap) => snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  // ─── 2. User & Roles ──────────────────────────────────────────────────────

  Stream<List<Map<String, dynamic>>> getNotifications(String userId, {String? role}) {
    _debug.log('FIRESTORE', 'Watch: directory_notifications for $userId');
    List<String> targets = [userId, 'all'];
    if (role != null) targets.add(role);
    
    return _db
        .collection('directory_notifications')
        .where('target', whereIn: targets)
        .snapshots()
        .handleError((e) => _debug.log('FIRESTORE', 'Error in notifications: $e'))
        .map((snap) {
          final items = snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
          items.sort((a, b) {
            final t1 = (a['timestamp'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
            final t2 = (b['timestamp'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
            return t2.compareTo(t1);
          });
          return items;
        });
  }

  Future<void> sendInAppNotification({
    required String userId,
    required String title,
    required String message,
    required String type,
    String? actionUrl,
    Map<String, dynamic>? clusterData,
  }) async {
    _debug.log('FIRESTORE', 'Send Notification: $userId');
    await _db.collection('directory_notifications').add({
      'target': userId,
      'title': title,
      'message': message,
      'type': type,
      'actionUrl': actionUrl,
      'clusterData': clusterData,
      'isRead': false,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> submitSupportMessage(Map<String, dynamic> data) async {
    _debug.log('FIRESTORE', 'Write: directory_support_inbox');
    await _db.collection('directory_support_inbox').add({
      ...data,
      'status': 'unread',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // ─── 3. Matching & Services ───────────────────────────────────────────────

  Stream<List<ServiceModel>> getAllActiveServices() {
    _debug.log('FIRESTORE', 'Watch: directory_services (Active Join + Expiry)');
    final now = DateTime.now();
    return Rx.combineLatest2(
      _db.collection('directory_services').where('isActive', isEqualTo: true).snapshots()
          .handleError((e) => _debug.log('FIRESTORE', 'Error in active services snap: $e')),
      getAllProviders(),
      (serviceSnap, providers) {
        final serviceDocs = (serviceSnap as QuerySnapshot).docs;
        final providerIds = (providers as List).map((p) => p['id']).toSet();
        return serviceDocs
            .map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return ServiceModel.fromMap({'id': doc.id, ...data});
            })
            .where((s) {
              // 1. Author must be active/approved
              if (!providerIds.contains(s.providerId)) {
                return false;
              }
              
              // 2. Element Expiry Check
              if (s.visibilityExpiresAt != null && s.visibilityExpiresAt!.isBefore(now)) return false;
              
              return true;
            })
            .toList();
      },
    ).handleError((e) => _debug.log('FIRESTORE', 'Error in combineLatest services: $e'));
  }

  Future<void> recordInteraction({
    required String userId,
    required String targetId,
    required InteractionType type, 
  }) async {
    _debug.log('FIRESTORE', 'Interaction: ${type.name} on $targetId');
    await _db.collection('directory_interactions').add({
      'userId': userId,
      'targetId': targetId,
      'type': type.name,
      'timestamp': FieldValue.serverTimestamp(),
      'platform': 'flutter',
    });
  }

  Future<void> toggleFavorite(String userId, String professionalId, bool isFavorite) async {
    _debug.log('FIRESTORE', 'Favorite: $professionalId -> $isFavorite');
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

  Stream<List<Map<String, dynamic>>> getUserFavorites(String userId) {
    return _db
        .collection('directory_favorites')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  // ─── 4. Transactions ──────────────────────────────────────────────────────

  Stream<List<Map<String, dynamic>>> getUserTransactions(String userId) {
    _debug.log('FIRESTORE', 'Watch: directory_membership_transactions for $userId');
    return _db
        .collection('directory_membership_transactions')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) {
           final items = snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
           items.sort((a, b) {
             final t1 = (a['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
             final t2 = (b['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
             return t2.compareTo(t1);
           });
           return items;
        });
  }

  // ─── 5. Professional Management ───────────────────────────────────────────

  Stream<List<ServiceModel>> getProfessionalServices(String professionalId) {
    return _db
        .collection('directory_services')
        .where('providerId', isEqualTo: professionalId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => ServiceModel.fromMap({'id': doc.id, ...doc.data()})).toList());
  }

  Future<void> createService(ServiceModel service) async {
    _debug.log('FIRESTORE', 'Create Service');
    final timestamp = FieldValue.serverTimestamp();
    await _db.collection('directory_services').add({
      ...service.toMap(),
      'isActive': true,
      'createdAt': timestamp,
      'updatedAt': timestamp,
    });
  }

  Future<void> toggleServiceSlot(String serviceId, bool allocate) async {
    await _db.collection('directory_services').doc(serviceId).update({
      'isAllocated': allocate,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> getUserSlots(String userId) {
    return _db
        .collection('directory_slots')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  Future<void> createBroadcast(Map<String, dynamic> data) async {
    await _db.collection('directory_broadcasts').add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> getBroadcasts({String? country}) {
    Query query = _db.collection('directory_broadcasts');
    if (country != null && country != 'GLOBAL') {
      // TODO: Implement country targeting logic
    }
    return query.orderBy('createdAt', descending: true).snapshots()
        .map((snap) => snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());
  }

  Stream<List<Map<String, dynamic>>> getAnnouncements() {
    return _db
        .collection('directory_announcements')
        .where('status', isEqualTo: 'approved')
        .snapshots()
        .map((snap) {
          final items = snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
          return items;
        });
  }

  // ─── 6. User Profiles ──────────────────────────────────────────────────────

  Future<void> updateUserProfile(String uid, UserModel user) async {
    await _db.collection('users').doc(uid).set({...user.toMap(), 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
  }

  Future<void> updateVisitorProfile(String uid, Map<String, dynamic> data) async {
    final timestamp = FieldValue.serverTimestamp();
    final finalData = {
      ...data,
      'uid': uid,
      'isActive': true, 
      'isVerified': true,
      'countryId': data['countryId'] ?? 'lebanon',
      'last_active': timestamp,
      'updatedAt': timestamp
    };
    await _db.collection('users').doc(uid).set(finalData, SetOptions(merge: true));
    await _db.collection('directory_visitors').doc(uid).set(finalData, SetOptions(merge: true));
  }

  Future<void> createProfessionalProfile(String uid, Map<String, dynamic> data) async {
    final timestamp = FieldValue.serverTimestamp();
    final isInstitution = (data['role'] ?? '') == 'institution';
    final collection = isInstitution ? 'directory_institutions' : 'directory_professionals';
    
    final finalData = {
      ...data,
      'hasProfile': true,
      'uid': uid,
      'isActive': true, 
      'isApproved': true,
      'verificationStatus': 'verified',
      'membershipStatus': 'active',
      'serviceSlots': isInstitution ? 5 : 2,
      'practicePins': 0,
      'broadcastsBought': 0,
      'countryId': data['mainLocation']?['countryId'] ?? data['countryId'],
      'governorateId': data['mainLocation']?['governorateId'] ?? data['governorateId'],
      'createdAt': timestamp,
      'updatedAt': timestamp
    };

    await _db.collection('users').doc(uid).set(finalData, SetOptions(merge: true));
    await _db.collection(collection).doc(uid).set(finalData, SetOptions(merge: true));
  }

  Stream<List<Map<String, dynamic>>> getAllProviders() {
    return Rx.combineLatest2(
      _db.collection('directory_professionals').snapshots()
          .handleError((e) => _debug.log('FIRESTORE', 'Error in professionals snap: $e')),
      _db.collection('directory_institutions').snapshots()
          .handleError((e) => _debug.log('FIRESTORE', 'Error in institutions snap: $e')),
      (profs, insts) {
        final List<Map<String, dynamic>> all = [];
        all.addAll((profs as QuerySnapshot).docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).where((p) => p['isActive'] != false));
        all.addAll((insts as QuerySnapshot).docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).where((p) => p['isActive'] != false));
        return all;
      },
    ).handleError((e) => _debug.log('FIRESTORE', 'Error in combineLatest providers: $e'));
  }

  // ─── 7. Admin Ops ─────────────────────────────────────────────────────────

  Future<void> approveProfessional(String id, bool isApproved, String role) async {
    final col = role == 'institution' ? 'directory_institutions' : 'directory_professionals';
    final batch = _db.batch();
    final timestamp = FieldValue.serverTimestamp();
    final data = {'isApproved': isApproved, 'verificationStatus': isApproved ? 'verified' : 'rejected', 'updatedAt': timestamp};
    batch.update(_db.collection(col).doc(id), data);
    batch.update(_db.collection('users').doc(id), data);
    await batch.commit();
  }

  Future<void> toggleHonorBadge(String id, bool current, String role) async {
    final col = role == 'institution' ? 'directory_institutions' : 'directory_professionals';
    await _db.collection(col).doc(id).update({'isHonorVerified': !current, 'updatedAt': FieldValue.serverTimestamp()});
    await _db.collection('users').doc(id).update({'isHonorVerified': !current, 'updatedAt': FieldValue.serverTimestamp()});
  }

  Future<void> deleteItem(String collection, String id) async {
    await _db.collection(collection).doc(id).delete();
  }

  Future<List<Map<String, dynamic>>> listCollection(String collection) async {
    final snap = await _db.collection(collection).get();
    return snap.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
  }

  Future<void> toggleCommunityRequestStatus(String id, bool isActive) async {
    await _db.collection('directory_community_requests').doc(id).update({'status': isActive ? 'active' : 'pending', 'updatedAt': FieldValue.serverTimestamp()});
  }

  Future<void> updateUser(String id, UserRole role, UserModel user) async {
    final col = role == UserRole.institution ? 'directory_institutions' : (role == UserRole.professional ? 'directory_professionals' : 'directory_visitors');
    await _db.collection('users').doc(id).set({...user.toMap(), 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
    await _db.collection(col).doc(id).set({...user.toMap(), 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
  }

  Stream<List<Map<String, dynamic>>> watchCommunityRequests() {
    return _db.collection('directory_community_requests').orderBy('createdAt', descending: true).snapshots()
        .map((snap) => snap.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList());
  }

  Future<void> createCommunityRequest(ServiceRequestModel request) async {
    _debug.log('FIRESTORE', 'Write: community_request');
    final docRef = _db.collection('directory_service_requests').doc();
    final timestamp = FieldValue.serverTimestamp();
    await docRef.set({
      ...request.toMap(),
      'id': docRef.id,
      'moderationStatus': 'PENDING',
      'createdAt': timestamp,
      'updatedAt': timestamp
    });
  }

  Stream<List<ServiceRequestModel>> getCommunityRequests({CommunityRequestStatus? status = CommunityRequestStatus.active, String? userId, String? sectionId, bool newestFirst = true}) {
    Query query = _db.collection('directory_service_requests');
    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    } else {
      if (status != null) query = query.where('status', isEqualTo: status.name);
      if (sectionId != null && sectionId != 'All') query = query.where('sectorId', isEqualTo: sectionId);
    }

    return query.snapshots().map((snapshot) {
       final items = snapshot.docs.map((doc) => ServiceRequestModel.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>})).toList();
       items.sort((a, b) {
         final t1 = a.createdAt.millisecondsSinceEpoch;
         final t2 = b.createdAt.millisecondsSinceEpoch;
         return newestFirst ? t2.compareTo(t1) : t1.compareTo(t2);
       });
       return items;
    });
  }
}
