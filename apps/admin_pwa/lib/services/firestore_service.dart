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

  Stream<List<Map<String, dynamic>>> watchCountries() {
    return _db.collection('directory_countries')
        .snapshots()
        .map((snap) => snap.docs.map((doc) => {...(doc.data() as Map<String, dynamic>), 'id': doc.id}).toList()
        ..sort((a, b) => (a['name_en'] ?? '').toString().compareTo(b['name_en'] ?? '')));
  }

  Stream<List<Map<String, dynamic>>> watchGovernorates({String? countryId}) {
    Query query = _db.collection('directory_governorates');
    if (countryId != null && countryId != 'ALL') {
      query = query.where('country_id', isEqualTo: countryId);
    }
    return query.snapshots()
        .map((snap) => snap.docs.map((doc) => {...(doc.data() as Map<String, dynamic>), 'id': doc.id}).toList()
        ..sort((a, b) => (a['name_en'] ?? '').toString().compareTo(b['name_en'] ?? '')));
  }

  Stream<List<Map<String, dynamic>>> watchCities({String? governorateId}) {
    Query query = _db.collection('directory_cities');
    if (governorateId != null && governorateId != 'ALL') {
      query = query.where('governorate_id', isEqualTo: governorateId);
    }
    return query.snapshots()
        .map((snap) => snap.docs.map((doc) => {...(doc.data() as Map<String, dynamic>), 'id': doc.id}).toList()
        ..sort((a, b) => (a['name_en'] ?? '').toString().compareTo(b['name_en'] ?? '')));
  }

  Stream<List<Map<String, dynamic>>> watchSectors() {
    return _db.collection('directory_sectors')
        .snapshots()
        .map((snap) => snap.docs.map((doc) => {...(doc.data() as Map<String, dynamic>), 'id': doc.id}).toList());
  }

  Stream<List<Map<String, dynamic>>> watchCollection(String collection) {
    return _db.collection(collection)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => {...(doc.data() as Map<String, dynamic>), 'id': doc.id}).toList());
  }

  Future<List<Map<String, dynamic>>> getCountries() async {
    final snap = await _db.collection('directory_countries').get();
    return snap.docs.map((doc) => {...(doc.data() as Map<String, dynamic>), 'id': doc.id}).toList();
  }

  Future<List<Map<String, dynamic>>> getGovernorates({String? countryId}) async {
    Query query = _db.collection('directory_governorates');
    if (countryId != null && countryId != 'ALL') {
      query = query.where('country_id', isEqualTo: countryId);
    }
    final snap = await query.get();
    return snap.docs.map((doc) => {...(doc.data() as Map<String, dynamic>), 'id': doc.id}).toList();
  }

  Future<List<Map<String, dynamic>>> getCities({String? governorateId}) async {
    Query query = _db.collection('directory_cities');
    if (governorateId != null && governorateId != 'ALL') {
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

  String _toSlug(String name) {
    return name.trim().toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');
  }

  String _normalizeAnchorName(String name) {
    String n = name.toLowerCase().trim();
    if (n.startsWith('el ')) n = n.substring(3);
    if (n.startsWith('al ')) n = n.substring(3);
    if (n.startsWith('the ')) n = n.substring(4);
    return _toSlug(n);
  }

  Future<void> syncAndCleanAnchors() async {
    final timestamp = FieldValue.serverTimestamp();
    
    // 1. Canonical Lebanese Governorates (Validated from master list)
    final Map<String, Map<String, String>> canonicalGovs = {
      'akkar': {'en': 'Akkar', 'ar': 'عكار'},
      'baalbek_hermel': {'en': 'Baalbek-El Hermel', 'ar': 'بعلبك - الهرمل'},
      'beirut': {'en': 'Beirut', 'ar': 'بيروت'},
      'bekaa': {'en': 'Bekaa', 'ar': 'البقاع'},
      'nabatieh': {'en': 'El Nabatieh', 'ar': 'النبطية'},
      'mount_lebanon': {'en': 'Mount Lebanon', 'ar': 'جبل لبنان'},
      'north': {'en': 'North', 'ar': 'الشمال'},
      'south': {'en': 'South', 'ar': 'الجنوب'},
    };

    // 2. Setup Roots
    await _db.collection('directory_anchors').doc('global').set({
      'name_en': 'Global Ecosystem',
      'type': 'root',
      'isActive': true,
      'updatedAt': timestamp,
    }, SetOptions(merge: true));

    await _db.collection('directory_countries').doc('lebanon').set({
      'name_en': 'Lebanon',
      'name_ar': 'لبنان',
      'id': 'lebanon',
      'parent_anchor_id': 'global',
      'isActive': true,
      'updatedAt': timestamp,
    }, SetOptions(merge: true));

    // 3. Process Governorates (Regions)
    final govMap = <String, String>{}; // Old ID/Name -> New Canonical Slug
    final govSnap = await _db.collection('directory_governorates').get();
    
    // Seed canonical governorates
    for (var entry in canonicalGovs.entries) {
      final slug = 'lebanon-${entry.key}';
      await _db.collection('directory_governorates').doc(slug).set({
        'id': slug,
        'name_en': entry.value['en'],
        'name_ar': entry.value['ar'],
        'country_id': 'lebanon',
        'parent_id': 'lebanon',
        'isActive': true,
        'updatedAt': timestamp,
      }, SetOptions(merge: true));
    }

    // Build the mapping from existing data to canonical
    for (var doc in govSnap.docs) {
      final data = doc.data();
      final name = (data['name_en'] ?? data['name'] ?? doc.id).toString().toLowerCase();
      
      String targetKey = 'unknown';
      if (name.contains('akkar')) targetKey = 'akkar';
      else if (name.contains('baalbek') || name.contains('hermel')) targetKey = 'baalbek_hermel';
      else if (name.contains('beirut') || name.contains('bayrouth')) targetKey = 'beirut';
      else if (name.contains('bekaa') || name.contains('biqaa')) targetKey = 'bekaa';
      else if (name.contains('nabatie') || name.contains('nabatiy')) targetKey = 'nabatieh';
      else if (name.contains('mount') || name.contains('jabal')) targetKey = 'mount_lebanon';
      else if (name.contains('north') || name.contains('chimal')) targetKey = 'north';
      else if (name.contains('south') || name.contains('janoub')) targetKey = 'south';

      final targetSlug = 'lebanon-$targetKey';
      govMap[doc.id] = targetSlug;
      govMap[name] = targetSlug; // Also map by name for city linking
      
      // Delete redundant old doc
      if (doc.id != targetSlug) {
        await doc.reference.delete();
      }
    }

    // 4. Process Cities (Aggressive Deduplication)
    final citySnap = await _db.collection('directory_cities').get();
    final cityMap = <String, String>{};
    
    for (var doc in citySnap.docs) {
      final data = doc.data();
      final nameEn = (data['name_en'] ?? data['name'] ?? '').toString();
      if (nameEn.isEmpty) {
        await doc.reference.delete();
        continue;
      }

      final normalizedCityName = _normalizeAnchorName(nameEn);
      
      // Resolve Governorate
      final rawGov = (data['governorate_id'] ?? data['governorate'] ?? data['region'] ?? 'beirut').toString().toLowerCase();
      String targetGovSlug = 'lebanon-beirut';
      
      if (rawGov.contains('akkar')) targetGovSlug = 'lebanon-akkar';
      else if (rawGov.contains('baalbek')) targetGovSlug = 'lebanon-baalbek_hermel';
      else if (rawGov.contains('bekaa')) targetGovSlug = 'lebanon-bekaa';
      else if (rawGov.contains('nabati')) targetGovSlug = 'lebanon-nabatieh';
      else if (rawGov.contains('mount') || rawGov.contains('jabal')) targetGovSlug = 'lebanon-mount_lebanon';
      else if (rawGov.contains('north')) targetGovSlug = 'lebanon-north';
      else if (rawGov.contains('south')) targetGovSlug = 'lebanon-south';
      else if (govMap.containsKey(rawGov)) targetGovSlug = govMap[rawGov]!;

      final finalCityId = '$targetGovSlug-$normalizedCityName';
      cityMap[doc.id] = finalCityId;

      // Update/Create canonical city doc
      await _db.collection('directory_cities').doc(finalCityId).set({
        ...data,
        'id': finalCityId,
        'country_id': 'lebanon',
        'governorate_id': targetGovSlug,
        'updatedAt': timestamp,
      }, SetOptions(merge: true));

      if (doc.id != finalCityId) {
        await doc.reference.delete();
      }
    }

    // 5. Global re-anchoring of all data nodes
    await _reanchorNodes({'lebanon': 'lebanon'}, govMap, cityMap);
    
    _debug.log('FIRESTORE', 'Database core cleaned and reorganized.');
  }

  Future<void> _reanchorNodes(Map<String, String> cMap, Map<String, String> gMap, Map<String, String> cityMap) async {
    final collections = [
      'users', 
      'directory_professionals', 
      'directory_institutions', 
      'directory_visitors',
      'directory_services',
      'directory_membership_transactions',
      'directory_community_requests'
    ];

    for (var col in collections) {
      final snap = await _db.collection(col).get();
      final batch = _db.batch();
      int count = 0;

      for (var doc in snap.docs) {
        final data = doc.data();
        final updates = <String, dynamic>{};
        
        final cId = data['countryId']?.toString() ?? data['country_id']?.toString();
        final gId = data['governorateId']?.toString() ?? data['governorate_id']?.toString();
        final ctId = data['cityId']?.toString() ?? data['city_id']?.toString();

        if (cId != null && cMap.containsKey(cId)) updates['countryId'] = cMap[cId];
        if (gId != null && gMap.containsKey(gId)) updates['governorateId'] = gMap[gId];
        if (ctId != null && cityMap.containsKey(ctId)) updates['cityId'] = cityMap[ctId];

        // Also re-anchor mainLocation map if it exists
        if (data['mainLocation'] != null && data['mainLocation'] is Map) {
          final loc = Map<String, dynamic>.from(data['mainLocation']);
          bool locChanged = false;
          
          final lcId = loc['countryId']?.toString();
          final lgId = loc['governorateId']?.toString();
          final lctId = loc['cityId']?.toString();

          if (lcId != null && cMap.containsKey(lcId)) { loc['countryId'] = cMap[lcId]; locChanged = true; }
          if (lgId != null && gMap.containsKey(lgId)) { loc['governorateId'] = gMap[lgId]; locChanged = true; }
          if (lctId != null && cityMap.containsKey(lctId)) { loc['cityId'] = cityMap[lctId]; locChanged = true; }
          
          if (locChanged) updates['mainLocation'] = loc;
        }

        // Also re-anchor secondaryLocations list if it exists
        if (data['secondaryLocations'] != null && data['secondaryLocations'] is List) {
          final list = List.from(data['secondaryLocations']);
          bool listChanged = false;
          for (int i = 0; i < list.length; i++) {
            if (list[i] is Map) {
              final loc = Map<String, dynamic>.from(list[i]);
              bool locChanged = false;
              
              final lcId = loc['countryId']?.toString();
              final lgId = loc['governorateId']?.toString();
              final lctId = loc['cityId']?.toString();

              if (lcId != null && cMap.containsKey(lcId)) { loc['countryId'] = cMap[lcId]; locChanged = true; }
              if (lgId != null && gMap.containsKey(lgId)) { loc['governorateId'] = gMap[lgId]; locChanged = true; }
              if (lctId != null && cityMap.containsKey(lctId)) { loc['cityId'] = cityMap[lctId]; locChanged = true; }
              
              if (locChanged) {
                list[i] = loc;
                listChanged = true;
              }
            }
          }
          if (listChanged) updates['secondaryLocations'] = list;
        }

        if (updates.isNotEmpty) {
          batch.update(doc.reference, updates);
          count++;
          if (count >= 400) {
            await batch.commit();
            count = 0;
          }
        }
      }
      if (count > 0) await batch.commit();
    }
  }

  Future<void> setupGlobalAnchors() async {
    await syncAndCleanAnchors();
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
