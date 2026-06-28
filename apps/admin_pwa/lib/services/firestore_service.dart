import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/models/professional_model.dart';
import 'package:shared_core/models/service_model.dart';
import 'package:shared_core/models/visitor_model.dart';

final firestoreServiceProvider = Provider((ref) => FirestoreService());

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Professionals ──────────────────────────────────────────────────────────
  
  Stream<List<ProfessionalModel>> watchAllProfessionals() {
    return _db.collection('directory_professionals')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => ProfessionalModel.fromJson({...doc.data(), 'id': doc.id})).toList());
  }

  Future<List<ProfessionalModel>> listAllProfessionals() async {
    final snap = await _db.collection('directory_professionals')
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map((doc) => ProfessionalModel.fromJson({...doc.data(), 'id': doc.id})).toList();
  }

  // ── Institutions ───────────────────────────────────────────────────────────
  
  Stream<List<ProfessionalModel>> watchAllInstitutions() {
    return _db.collection('directory_institutions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => ProfessionalModel.fromJson({...doc.data(), 'id': doc.id})).toList());
  }

  // ── Services ──────────────────────────────────────────────────────────────
  
  Stream<List<ServiceModel>> watchAllServices() {
    return _db.collection('directory_services')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => ServiceModel.fromJson({...doc.data(), 'id': doc.id})).toList());
  }

  // ── Visitors ───────────────────────────────────────────────────────────────
  
  Stream<List<VisitorModel>> watchAllVisitors() {
    return _db.collection('directory_visitors')
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => VisitorModel.fromJson({...doc.data(), 'id': doc.id})).toList());
  }

  // ── Analytics & Transactions ──────────────────────────────────────────────

  Stream<List<Map<String, dynamic>>> watchInteractions() {
    return _db.collection('directory_interactions')
        .orderBy('timestamp', descending: true)
        .limit(1000)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => {...(doc.data() as Map<String, dynamic>), 'id': doc.id}).toList());
  }

  Stream<List<Map<String, dynamic>>> watchMembershipTransactions() {
    return _db.collection('directory_membership_transactions')
        .orderBy('createdAt', descending: true)
        .limit(1000)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => {...(doc.data() as Map<String, dynamic>), 'id': doc.id}).toList());
  }

  Stream<List<Map<String, dynamic>>> watchLogs() {
    return _db.collection('directory_admin_logs')
        .orderBy('timestamp', descending: true)
        .limit(1000)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => {...(doc.data() as Map<String, dynamic>), 'id': doc.id}).toList());
  }

  Stream<List<Map<String, dynamic>>> watchWalletLedger() {
    return _db.collection('wallet_ledger')
        .orderBy('timestamp', descending: true)
        .limit(1000)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => {...(doc.data() as Map<String, dynamic>), 'id': doc.id}).toList());
  }

  // ── Comms Hub ─────────────────────────────────────────────────────────────

  Stream<List<Map<String, dynamic>>> watchUserBroadcasts() {
    return _db.collection('directory_broadcasts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => {...(doc.data() as Map<String, dynamic>), 'id': doc.id}).toList());
  }

  Future<void> updateBroadcastStatus(String id, String status, {String? adminNotes}) async {
    await _db.collection('directory_broadcasts').doc(id).update({
      'status': status,
      'adminNotes': adminNotes,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> watchAdminNotifications() {
    // Increased limit for history visibility
    return _db.collection('directory_notifications')
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => {...(doc.data() as Map<String, dynamic>), 'id': doc.id}).toList());
  }

  Stream<List<Map<String, dynamic>>> watchAnnouncements() {
    return _db.collection('directory_announcements')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => {...(doc.data() as Map<String, dynamic>), 'id': doc.id}).toList());
  }

  Stream<List<Map<String, dynamic>>> watchSupportInbox() {
    return _db.collection('directory_support_inbox')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => {...(doc.data() as Map<String, dynamic>), 'id': doc.id}).toList());
  }

  Future<void> updateSupportMessageStatus(String id, String status) async {
    await _db.collection('directory_support_inbox').doc(id).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
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

  Stream<List<Map<String, dynamic>>> watchCommunityRequests() {
    return _db.collection('directory_community_requests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => {...(doc.data() as Map<String, dynamic>), 'id': doc.id}).toList());
  }

  Future<void> approveCommunityRequest(String id, bool isApproved) async {
    final batch = _db.batch();
    final timestamp = FieldValue.serverTimestamp();
    
    batch.update(_db.collection('directory_community_requests').doc(id), {
      'is_approved': isApproved,
      'status': isApproved ? 'active' : 'rejected',
      'updatedAt': timestamp,
    });

    // Audit Log
    batch.set(_db.collection('directory_admin_logs').doc(), {
      'action': isApproved ? 'COMMUNITY_REQUEST_APPROVED' : 'COMMUNITY_REQUEST_REJECTED',
      'entityId': id,
      'entityType': 'community_request',
      'timestamp': timestamp,
    });

    await batch.commit();
  }

  Future<void> toggleCommunityRequestStatus(String id, bool isActive) async {
    await _db.collection('directory_community_requests').doc(id).update({
      'status': isActive ? 'active' : 'pending',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ── SOS & Emergency ───────────────────────────────────────────────────────

  Stream<List<Map<String, dynamic>>> watchEmergencySections() {
    return _db.collection('directory_settings')
        .doc('app_config')
        .snapshots()
        .map((snap) {
          if (snap.exists && snap.data()!.containsKey('emergency_sections')) {
            return List<Map<String, dynamic>>.from(snap.data()!['emergency_sections']);
          }
          return [];
        });
  }

  Future<void> updateEmergencySections(List<Map<String, dynamic>> sections) async {
    await _db.collection('directory_settings').doc('app_config').set({
      'emergency_sections': sections,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ── Shared Ops ────────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> listCollection(String collection) async {
    final snap = await _db.collection(collection).get();
    return snap.docs.map((doc) => {...(doc.data() as Map<String, dynamic>), 'id': doc.id}).toList();
  }

  Future<void> updateItem(String collection, String id, Map<String, dynamic> data) async {
    await _db.collection(collection).doc(id).set(
      {...data, 'updatedAt': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
  }

  Future<void> updateUser(String id, String role, Map<String, dynamic> data) async {
    final batch = _db.batch();
    final timestamp = FieldValue.serverTimestamp();
    
    final finalData = {...data, 'updatedAt': timestamp};
    
    batch.set(_db.collection('users').doc(id), finalData, SetOptions(merge: true));
    
    final col = role == 'institution' ? 'directory_institutions' : 
                (role == 'professional' ? 'directory_professionals' : 'directory_visitors');
    batch.set(_db.collection(col).doc(id), finalData, SetOptions(merge: true));

    // Audit Log
    final logRef = _db.collection('directory_admin_logs').doc();
    batch.set(logRef, {
      'action': 'USER_UPDATE',
      'entityId': id,
      'entityType': 'user',
      'details': 'Admin modified parameters for $id',
      'timestamp': timestamp,
    });
    
    await batch.commit();
  }

  Future<void> deleteItem(String collection, String id) async {
    await _db.collection(collection).doc(id).delete();
  }

  Future<void> approveProfessional(String id, bool isApproved, String role) async {
    final col = role == 'institution' ? 'directory_institutions' : 'directory_professionals';
    final batch = _db.batch();
    final timestamp = FieldValue.serverTimestamp();
    
    final data = {
      'isApproved': isApproved,
      'verificationStatus': isApproved ? 'verified' : 'rejected',
      'updatedAt': timestamp,
    };

    batch.update(_db.collection(col).doc(id), data);
    batch.update(_db.collection('users').doc(id), data);

    // Audit Log
    final logRef = _db.collection('directory_admin_logs').doc();
    batch.set(logRef, {
      'action': isApproved ? 'NODE_APPROVED' : 'NODE_REJECTED',
      'entityId': id,
      'entityType': 'node',
      'timestamp': timestamp,
    });
    
    await batch.commit();
  }

  Future<void> toggleHonorBadge(String id, bool current, String role) async {
    final col = role == 'institution' ? 'directory_institutions' : 'directory_professionals';
    final batch = _db.batch();
    final timestamp = FieldValue.serverTimestamp();
    
    final data = {
      'isHonorVerified': !current,
      'updatedAt': timestamp,
    };

    batch.update(_db.collection(col).doc(id), data);
    batch.update(_db.collection('users').doc(id), data);
    
    await batch.commit();
  }

  // ── Metadata ───────────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getCountries() async {
    final snap = await _db.collection('directory_countries').orderBy('name_en').get();
    return snap.docs.map((doc) => {...(doc.data() as Map<String, dynamic>), 'id': doc.id}).toList();
  }

  Future<List<Map<String, dynamic>>> getGovernorates({String? countryId}) async {
    Query query = _db.collection('directory_governorates').orderBy('name_en');
    if (countryId != null) {
      query = query.where('country_id', isEqualTo: countryId);
    }
    final snap = await query.get();
    return snap.docs.map((doc) => {...(doc.data() as Map<String, dynamic>), 'id': doc.id}).toList();
  }

  Future<List<Map<String, dynamic>>> getCities({String? governorateId}) async {
    Query query = _db.collection('directory_cities').orderBy('name_en');
    if (governorateId != null) {
      query = query.where('governorate_id', isEqualTo: governorateId);
    }
    final snap = await query.get();
    return snap.docs.map((doc) => {...(doc.data() as Map<String, dynamic>), 'id': doc.id}).toList();
  }

  Stream<Map<String, dynamic>> watchUnitPricing() {
    return _db.collection('directory_settings')
        .doc('unit_pricing')
        .snapshots()
        .map((snap) => snap.exists ? snap.data()! : {});
  }

  Future<void> updateUnitPricing(Map<String, dynamic> data) async {
    await _db.collection('directory_settings').doc('unit_pricing').set(
      {...data, 'updatedAt': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
  }

  Future<List<Map<String, dynamic>>> getSectors() async {
    final snap = await _db.collection('directory_sectors').get();
    return snap.docs.map((doc) => {...(doc.data() as Map<String, dynamic>), 'id': doc.id}).toList();
  }

  // ── Anchor Management & Migration ──────────────────────────────────────────

  Future<void> setupGlobalAnchors() async {
    final timestamp = FieldValue.serverTimestamp();

    // 1. Ensure Top-Level "Global" Anchor exists
    final globalRef = _db.collection('directory_anchors').doc('global');
    await globalRef.set({
      'name_en': 'Global Ecosystem',
      'name_ar': 'النظام العالمي',
      'type': 'root',
      'isActive': true,
      'updatedAt': timestamp,
    }, SetOptions(merge: true));

    // 2. Ensure Lebanon exists and is anchored to Global
    final lebanonRef = _db.collection('directory_countries').doc('lebanon');
    await lebanonRef.set({
      'name_en': 'Lebanon',
      'name_ar': 'لبنان',
      'code': 'LB',
      'currency': 'LBP',
      'phone_code': '+961',
      'parent_anchor_id': 'global', // Hierarchy Level 1
      'isActive': true,
      'updatedAt': timestamp,
    }, SetOptions(merge: true));

    // Helper for large batching
    Future<void> runBatchedDeletes(List<DocumentReference> refs) async {
      if (refs.isEmpty) return;
      var batch = _db.batch();
      int count = 0;
      for (var ref in refs) {
        batch.delete(ref);
        count++;
        if (count >= 400) {
          await batch.commit();
          batch = _db.batch();
          count = 0;
        }
      }
      if (count > 0) await batch.commit();
    }

    Future<void> runBatchedUpdates(List<DocumentReference> refs, Map<String, dynamic> data) async {
      if (refs.isEmpty) return;
      var batch = _db.batch();
      int count = 0;
      for (var ref in refs) {
        batch.update(ref, data);
        count++;
        if (count >= 400) {
          await batch.commit();
          batch = _db.batch();
          count = 0;
        }
      }
      if (count > 0) await batch.commit();
    }

    // 3. Audit Regions (Governorates) -> Anchor to Lebanon
    final govSnap = await _db.collection('directory_governorates').get();
    final seenGovs = <String>{};
    final govDeletes = <DocumentReference>[];
    final govUpdateRefs = <DocumentReference>[];

    for (var doc in govSnap.docs) {
      final data = doc.data();
      final nameEn = (data['name_en']?.toString() ?? data['name']?.toString() ?? data['label_en']?.toString() ?? '').trim().toLowerCase();
      
      if (nameEn.isEmpty || seenGovs.contains(nameEn)) {
        govDeletes.add(doc.reference);
      } else {
        seenGovs.add(nameEn);
        // All current regions must be anchored to Lebanon
        govUpdateRefs.add(doc.reference);
      }
    }
    await runBatchedDeletes(govDeletes);
    await runBatchedUpdates(govUpdateRefs, {
      'country_id': 'lebanon', 
      'parent_id': 'lebanon', // Explicit hierarchy
      'updatedAt': timestamp
    });

    // 4. Audit Cities -> Anchor to Regions
    final citySnap = await _db.collection('directory_cities').get();
    final seenCities = <String>{};
    final cityDeletes = <DocumentReference>[];
    final cityUpdateRefs = <DocumentReference>[];

    for (var doc in citySnap.docs) {
      final data = doc.data();
      final nameEn = (data['name_en']?.toString() ?? data['name']?.toString() ?? data['label_en']?.toString() ?? '').trim().toLowerCase();
      final govId = data['governorate_id'] ?? data['gov_id'] ?? data['region_id'];
      
      final compositeKey = '$nameEn-$govId';
      if (nameEn.isEmpty || govId == null || seenCities.contains(compositeKey)) {
        cityDeletes.add(doc.reference);
      } else {
        seenCities.add(compositeKey);
        // Ensure city is correctly anchored to its region and parent country
        cityUpdateRefs.add(doc.reference);
      }
    }
    await runBatchedDeletes(cityDeletes);
    // Note: We don't force a single region, we just ensure the country link is Lebanon
    await runBatchedUpdates(cityUpdateRefs, {'country_id': 'lebanon', 'updatedAt': timestamp});

    // 5. Ensure all other countries are anchored to Global
    final countriesSnap = await _db.collection('directory_countries').get();
    final countryUpdateRefs = <DocumentReference>[];
    for (var doc in countriesSnap.docs) {
      if (doc.id != 'lebanon') {
        countryUpdateRefs.add(doc.reference);
      }
    }
    await runBatchedUpdates(countryUpdateRefs, {'parent_anchor_id': 'global', 'updatedAt': timestamp});
  }

  // ── Token System ──────────────────────────────────────────────────────────

  Stream<Map<String, dynamic>> watchTokenPricing() {
    return _db.collection('directory_settings')
        .doc('token_pricing')
        .snapshots()
        .map((snap) => snap.exists ? snap.data()! : {});
  }

  Future<void> updateTokenPricing(Map<String, dynamic> data) async {
    await _db.collection('directory_settings').doc('token_pricing').set(
      {...data, 'updatedAt': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
  }

  Stream<Map<String, dynamic>> watchTokenAnalytics() {
    return _db.collection('directory_settings').doc('token_analytics').snapshots().map((snap) => snap.exists ? snap.data()! : {});
  }

  Future<void> updateTokenAnalytics(Map<String, dynamic> data) async {
    await _db.collection('directory_settings').doc('token_analytics').set(
      {...data, 'updatedAt': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
  }

  Future<void> mintRechargeCards({
    required String batchLabel,
    required int count,
    required int tokenValue,
    required String targetRole,
    int extraPins = 0,
    int extraSlots = 0,
    int broadcasts = 0,
  }) async {
    final batch = _db.batch();
    final timestamp = FieldValue.serverTimestamp();

    for (int i = 0; i < count; i++) {
      // Generate a simple unique 12-digit code
      final code = 'ESPY-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}-${(1000 + i).toString()}';
      final ref = _db.collection('recharge_cards').doc(code);
      
      batch.set(ref, {
        'code': code,
        'batchLabel': batchLabel,
        'tokenValue': tokenValue,
        'extraPins': extraPins,
        'extraSlots': extraSlots,
        'broadcasts': broadcasts,
        'targetRole': targetRole,
        'status': 'active',
        'createdAt': timestamp,
      });
    }

    // Audit Log
    batch.set(_db.collection('directory_admin_logs').doc(), {
      'action': 'CARDS_MINTED',
      'details': 'Generated $count cards ($tokenValue \$E, $extraPins PINs, $extraSlots SLOTs) for $targetRole ($batchLabel)',
      'timestamp': timestamp,
    });

    await batch.commit();
  }
}
