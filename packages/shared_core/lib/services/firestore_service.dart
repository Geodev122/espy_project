// ESPY PROTOCOL - FIRESTORE SERVICE v1.1
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'debug_service.dart';

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
          final sectors = snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList().cast<Map<String, dynamic>>();
          return sectors.where((s) => s['isActive'] == true || s['is_active'] == true).toList().cast<Map<String, dynamic>>()
            ..sort((a, b) => (a['displayOrder'] ?? 999).compareTo(b['displayOrder'] ?? 999));
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
            .toList().cast<Map<String, dynamic>>()
            ..sort((a, b) => (a['displayOrder'] ?? 999).compareTo(b['displayOrder'] ?? 999)));
  }

  Stream<List<Map<String, dynamic>>> getCountries() {
    return _db
        .collection('directory_countries')
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList().cast<Map<String, dynamic>>()
            ..sort((a, b) => (a['name_en'] ?? '').compareTo(b['name_en'] ?? '')));
  }

  Stream<List<Map<String, dynamic>>> getGovernorates({String? countryId}) {
    Query query = _db.collection('directory_governorates');
    if (countryId != null && countryId != 'ALL' && countryId != 'lebanon_all') {
      query = query.where('country_id', isEqualTo: countryId);
    } else {
      // Default to Lebanon if nothing specified and multiple countries exist
      // query = query.where('country_id', isEqualTo: 'lebanon');
    }
    return query.snapshots()
        .map((snap) =>
            snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList().cast<Map<String, dynamic>>()
            ..sort((a, b) => (a['name_en'] ?? '').compareTo(b['name_en'] ?? '')));
  }

  Stream<List<Map<String, dynamic>>> getCities({String? governorateId}) {
    Query query = _db.collection('directory_cities');
    if (governorateId != null && governorateId != 'ALL') {
      query = query.where('governorate_id', isEqualTo: governorateId);
    }
    return query.snapshots()
        .map((snap) =>
            snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList().cast<Map<String, dynamic>>()
            ..sort((a, b) => (a['name_en'] ?? '').compareTo(b['name_en'] ?? '')));
  }

  Stream<List<Map<String, dynamic>>> getServicePricingTags() {
    return _db
        .collection('directory_service_pricing_tags')
        .snapshots()
        .map((snap) => snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList().cast<Map<String, dynamic>>());
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
          final items = snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList().cast<Map<String, dynamic>>();
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

  Stream<List<Map<String, dynamic>>> getAllActiveServices() {
    _debug.log('FIRESTORE', 'Watch: directory_services (Active Join + Expiry)');
    final now = DateTime.now();
    return Rx.combineLatest2(
      _db.collection('directory_services').where('isActive', isEqualTo: true).snapshots()
          .handleError((e) => _debug.log('FIRESTORE', 'Error in active services snap: $e')),
      getAllProviders(),
      (QuerySnapshot serviceSnap, List<Map<String, dynamic>> providers) {
        final providerIds = providers.map((p) => p['id']).toSet();
        return serviceSnap.docs
            .map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return {'id': doc.id, ...data};
            })
            .where((s) {
              // 1. Author must be active/approved
              if (!providerIds.contains(s['professionalId']) && !providerIds.contains(s['institutionId'])) {
                return false;
              }
              
              // 2. Element Expiry Check
              if (s['visibilityExpiresAt'] != null) {
                final expiry = s['visibilityExpiresAt'] is Timestamp 
                    ? (s['visibilityExpiresAt'] as Timestamp).toDate() 
                    : DateTime.tryParse(s['visibilityExpiresAt'].toString());
                if (expiry != null && expiry.isBefore(now)) return false;
              }
              
              return true;
            })
            .toList().cast<Map<String, dynamic>>();
      },
    ).handleError((e) => _debug.log('FIRESTORE', 'Error in combineLatest services: $e'));
  }

  Future<void> recordInteraction({
    required String userId,
    required String targetId,
    required String type, 
  }) async {
    _debug.log('FIRESTORE', 'Interaction: $type on $targetId');
    await _db.collection('directory_interactions').add({
      'userId': userId,
      'targetId': targetId,
      'type': type,
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
        .map((snap) => snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList().cast<Map<String, dynamic>>());
  }

  // ─── 4. Transactions ──────────────────────────────────────────────────────

  Stream<List<Map<String, dynamic>>> getUserTransactions(String userId) {
    _debug.log('FIRESTORE', 'Watch: directory_membership_transactions for $userId');
    return _db
        .collection('directory_membership_transactions')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) {
           final items = snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList().cast<Map<String, dynamic>>();
           items.sort((a, b) {
             final t1 = (a['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
             final t2 = (b['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
             return t2.compareTo(t1);
           });
           return items;
        });
  }

  // ─── 5. Professional Management ───────────────────────────────────────────

  Stream<List<Map<String, dynamic>>> getProfessionalServices(String professionalId) {
    return _db
        .collection('directory_services')
        .where('professionalId', isEqualTo: professionalId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList().cast<Map<String, dynamic>>());
  }

  Future<void> createService(Map<String, dynamic> data) async {
    _debug.log('FIRESTORE', 'Create Service');
    final timestamp = FieldValue.serverTimestamp();
    await _db.collection('directory_services').add({
      ...data,
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
        .map((snap) => snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList().cast<Map<String, dynamic>>());
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
      // Logic for targeting: include global and specific country
    }
    return query.orderBy('createdAt', descending: true).snapshots()
        .map((snap) => snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList().cast<Map<String, dynamic>>());
  }

  Stream<List<Map<String, dynamic>>> getAnnouncements() {
    return _db
        .collection('directory_announcements')
        .where('status', isEqualTo: 'approved')
        .snapshots()
        .map((snap) {
          final items = snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList().cast<Map<String, dynamic>>();
          // Note: Full filtering (isActive author) should ideally be done server-side or here
          // For now, we'll return items, and the UI can check if author is suspended if data is available
          return items;
        });
  }

  // ─── 6. User Profiles ──────────────────────────────────────────────────────

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).set({...data, 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
  }

  Future<void> updateVisitorProfile(String uid, Map<String, dynamic> data) async {
    final timestamp = FieldValue.serverTimestamp();
    final finalData = {
      ...data,
      'uid': uid,
      'isActive': true,
      'isVerified': true, // Default to true as per new algorithm
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
      'isApproved': true, // Default to true as per new visibility algorithm
      'verificationStatus': 'verified',
      'membershipStatus': 'active',
      'serviceSlots': isInstitution ? 5 : 2, // Default slots
      'practicePins': 0, // Extra pins (Main Pin is implicit)
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
      (QuerySnapshot profs, QuerySnapshot insts) {
        final List<Map<String, dynamic>> all = [];
        all.addAll(profs.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).where((p) => p['isActive'] != false));
        all.addAll(insts.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).where((p) => p['isActive'] != false));
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
    return snap.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList().cast<Map<String, dynamic>>();
  }

  Future<void> toggleCommunityRequestStatus(String id, bool isActive) async {
    await _db.collection('directory_community_requests').doc(id).update({'status': isActive ? 'active' : 'pending', 'updatedAt': FieldValue.serverTimestamp()});
  }

  Future<void> updateUser(String id, String role, Map<String, dynamic> data) async {
    final col = role == 'institution' ? 'directory_institutions' : (role == 'professional' ? 'directory_professionals' : 'directory_visitors');
    await _db.collection('users').doc(id).set({...data, 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
    await _db.collection(col).doc(id).set({...data, 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
  }

  Stream<List<Map<String, dynamic>>> watchCommunityRequests() {
    return _db.collection('directory_community_requests').orderBy('createdAt', descending: true).snapshots()
        .map((snap) => snap.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList().cast<Map<String, dynamic>>());
  }

  Future<void> createCommunityRequest(Map<String, dynamic> data) async {
    _debug.log('FIRESTORE', 'Write: community_request');
    final docRef = _db.collection('directory_community_requests').doc();
    final timestamp = FieldValue.serverTimestamp();
    await docRef.set({...data, 'id': docRef.id, 'status': 'pending', 'is_approved': false, 'createdAt': timestamp, 'updatedAt': timestamp});
  }

  Stream<List<Map<String, dynamic>>> getCommunityRequests({String? status = 'active', String? userId, String? sectionId, bool newestFirst = true}) {
    Query query = _db.collection('directory_community_requests');
    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    } else {
      if (status != null) query = query.where('status', isEqualTo: status);
      if (sectionId != null && sectionId != 'All') query = query.where('sectionId', isEqualTo: sectionId);
    }

    return query.snapshots().map((snapshot) {
       final items = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList().cast<Map<String, dynamic>>();
       items.sort((a, b) {
         final t1 = (a['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
         final t2 = (b['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
         return newestFirst ? t2.compareTo(t1) : t1.compareTo(t2);
       });
       return items;
    });
  }
}
