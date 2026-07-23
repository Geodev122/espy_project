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
    final doc = await _db.collection('users').doc(id).get();
    final data = doc.data();
    if (doc.exists && data != null) {
      return UserModel.fromMap(data as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Future<void> createUser(Map<String, dynamic> data) async {
    await _db.collection('users').doc(data['id']).set(data);
  }

  @override
  Future<void> upsertUser(Map<String, dynamic> data) async {
    await _db.collection('users').doc(data['id']).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    await _db.collection('users').doc(id).set({...data, 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
  }

  @override
  Future<void> updateLastActive(String id) async {
    await _db.collection('users').doc(id).update({
      'lastActiveAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<ProfessionalProfile?> getProfessionalProfile(String id) async {
    final doc = await _db.collection('directory_professionals').doc(id).get();
    final data = doc.data();
    return (doc.exists && data != null) ? ProfessionalProfile.fromMap(data as Map<String, dynamic>) : null;
  }

  @override
  Future<InstitutionProfile?> getInstitutionProfile(String id) async {
    final doc = await _db.collection('directory_institutions').doc(id).get();
    final data = doc.data();
    return (doc.exists && data != null) ? InstitutionProfile.fromMap(data as Map<String, dynamic>) : null;
  }

  @override
  Future<VisitorProfile?> getVisitorProfile(String id) async {
    final doc = await _db.collection('directory_visitors').doc(id).get();
    final data = doc.data();
    return (doc.exists && data != null) ? VisitorProfile.fromMap(data as Map<String, dynamic>) : null;
  }

  // ─── 2. Taxonomy & Location ──────────────────────────────────────────────

  @override
  Stream<List<Map<String, dynamic>>> listSectors() {
    return _db.collection('directory_sectors').snapshots().map((snap) =>
        snap.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return <String, dynamic>{'id': doc.id, ...data ?? <String, dynamic>{}};
        }).toList());
  }

  @override
  Stream<List<Map<String, dynamic>>> listCategories({String? sectorId}) {
    Query query = _db.collection('directory_categories');
    if (sectorId != null) query = query.where('sectorId', isEqualTo: sectorId);
    return query.snapshots().map((snap) =>
        snap.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return <String, dynamic>{'id': doc.id, ...data ?? <String, dynamic>{}};
        }).toList());
  }

  @override
  Stream<List<Map<String, dynamic>>> listCountries() {
    return _db.collection('directory_countries').snapshots().map((snap) =>
        snap.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return <String, dynamic>{'id': doc.id, ...data ?? <String, dynamic>{}};
        }).toList());
  }

  @override
  Stream<List<Map<String, dynamic>>> listRegions(String countryId) {
    return _db.collection('directory_regions').where('countryId', isEqualTo: countryId).snapshots().map((snap) =>
        snap.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return <String, dynamic>{'id': doc.id, ...data ?? <String, dynamic>{}};
        }).toList());
  }

  @override
  Stream<List<Map<String, dynamic>>> listCities(String regionId) {
    return _db.collection('directory_cities').where('regionId', isEqualTo: regionId).snapshots().map((snap) =>
        snap.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return <String, dynamic>{'id': doc.id, ...data ?? <String, dynamic>{}};
        }).toList());
  }

  @override
  Stream<List<Map<String, dynamic>>> listLocationNodes(String userId) {
     return _db.collection('directory_locations').where('userId', isEqualTo: userId).snapshots().map((snap) =>
        snap.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return <String, dynamic>{'id': doc.id, ...data ?? <String, dynamic>{}};
        }).toList());
  }

  @override
  Future<void> upsertCountry(Map<String, dynamic> data) async {
    await _db.collection('directory_countries').doc(data['id']).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> upsertRegion(Map<String, dynamic> data) async {
    await _db.collection('directory_regions').add(data);
  }

  @override
  Future<void> upsertCity(Map<String, dynamic> data) async {
    await _db.collection('directory_cities').add(data);
  }

  @override
  Future<void> deleteGeographyEntity(String id, String type) async {
    final col = type == 'country' ? 'directory_countries' : (type == 'region' ? 'directory_regions' : 'directory_cities');
    await _db.collection(col).doc(id).delete();
  }

  @override
  Future<void> updateSectorBranding(String id, Map<String, dynamic> data) async {
    await _db.collection('directory_sectors').doc(id).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> upsertServiceTag(Map<String, dynamic> data) async {
    await _db.collection('directory_service_tags').doc(data['id']).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> upsertPriceTag(Map<String, dynamic> data) async {
    await _db.collection('directory_price_tags').doc(data['id']).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> upsertPinCategory(Map<String, dynamic> data) async {
    await _db.collection('directory_pin_categories').doc(data['id']).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> upsertPresenceTag(Map<String, dynamic> data) async {
    await _db.collection('directory_presence_tags').doc(data['id']).set(data, SetOptions(merge: true));
  }

  // ─── 3. Core Business Logic ──────────────────────────────────────────────

  @override
  Stream<List<Map<String, dynamic>>> listActiveServices({String? categoryId, String? sectorId}) {
    Query query = _db.collection('directory_services').where('isActive', isEqualTo: true).where('moderationStatus', isEqualTo: 'APPROVED');
    if (categoryId != null) query = query.where('categoryId', isEqualTo: categoryId);
    if (sectorId != null) query = query.where('sectorId', isEqualTo: sectorId);

    return query.snapshots().map((snap) =>
        snap.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return <String, dynamic>{'id': doc.id, ...data ?? <String, dynamic>{}};
        }).toList());
  }

  @override
  Stream<List<Map<String, dynamic>>> listProfessionalServices(String professionalId) {
    return _db.collection('directory_services')
        .where('professionalId', isEqualTo: professionalId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return <String, dynamic>{'id': doc.id, ...data ?? <String, dynamic>{}};
        }).toList());
  }

  @override
  Future<void> toggleServiceSlot(String serviceId, bool allocate) async {
    await _db.collection('directory_services').doc(serviceId).update({
      'isAllocated': allocate,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<Map<String, dynamic>>> listCommunityRequests({String? sectorId, bool newestFirst = true, String? userId}) {
    Query query = _db.collection('directory_service_requests').where('moderationStatus', isEqualTo: 'APPROVED');
    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    } else {
      query = query.where('status', isEqualTo: 'active');
      if (sectorId != null && sectorId != 'All') {
        query = query.where('sectorId', isEqualTo: sectorId);
      }
    }
    return query.snapshots().map((snap) {
      final items = snap.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        return <String, dynamic>{'id': doc.id, ...data ?? <String, dynamic>{}};
      }).toList();
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
     await _db.collection('directory_community_requests').add({
       ...data,
       'createdAt': FieldValue.serverTimestamp(),
       'status': 'active',
     });
  }

  @override
  Future<void> createLocationNode(Map<String, dynamic> data) async {
     await _db.collection('directory_locations').add({
       ...data,
       'createdAt': FieldValue.serverTimestamp(),
     });
  }

  @override
  Future<Map<String, List<Map<String, dynamic>>>> listMetadataTags() async {
    final s = await _db.collection('directory_service_tags').get();
    final p = await _db.collection('directory_price_tags').get();
    final c = await _db.collection('directory_pin_categories').get();
    final pr = await _db.collection('directory_presence_tags').get();
    return {
      'serviceTags': s.docs.map((d) => <String, dynamic>{'id': d.id, ...d.data()}).toList(),
      'priceTags': p.docs.map((d) => <String, dynamic>{'id': d.id, ...d.data()}).toList(),
      'pinCategories': c.docs.map((d) => <String, dynamic>{'id': d.id, ...d.data()}).toList(),
      'presenceTags': pr.docs.map((d) => <String, dynamic>{'id': d.id, ...d.data()}).toList(),
    };
  }

  // ─── 4. Ledger & Resource Orders ─────────────────────────────────────────

  @override
  Stream<List<Map<String, dynamic>>> listWalletTransactions(String userId) {
    return _db.collection('directory_membership_transactions')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return <String, dynamic>{'id': doc.id, ...data ?? <String, dynamic>{}};
        }).toList());
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
    await _db.collection('directory_interactions').add({
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
      await _db.collection('directory_favorites').doc(favId).set({
        'userId': userId,
        'targetId': targetId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      await _db.collection('directory_favorites').doc(favId).delete();
    }
  }

  @override
  Stream<List<String>> listFavoriteIds(String userId) {
    return _db.collection('directory_favorites')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
              final data = doc.data();
              return data['targetId'] as String? ?? '';
            }).where((id) => id.isNotEmpty).toList());
  }

  @override
  Stream<List<String>> listContactedIds(String userId) {
    return _db.collection('directory_interactions')
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: 'like')
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
              final data = doc.data();
              return data['targetId'] as String? ?? '';
            }).where((id) => id.isNotEmpty).toList());
  }

  // --- Resource Orders ---

  @override
  Future<void> upsertProfessionalProfile({required String id, String? fullNameAr, String? specialty, String? specialtyAr, String? bioEn, String? bioAr}) async {
    await _db.collection('directory_professionals').doc(id).set({
      'fullNameAr': fullNameAr,
      'specialty': specialty,
      'specialtyAr': specialtyAr,
      'bioEn': bioEn,
      'bioAr': bioAr,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> upsertInstitutionProfile({required String id, String? nameAr, String? bioEn, String? bioAr, String? registrationNumber}) async {
    await _db.collection('directory_institutions').doc(id).set({
      'nameAr': nameAr,
      'bioEn': bioEn,
      'bioAr': bioAr,
      'registrationNumber': registrationNumber,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> createResourceOrder({required String userId, required int pins, required int slots, required int broadcasts, required int total}) async {
    await _db.collection('directory_resource_orders').add({
      'userId': userId,
      'pinsCount': pins,
      'slotsCount': slots,
      'broadcastsCount': broadcasts,
      'totalCost': total,
      'status': 'PENDING',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updateResourceOrder({required String id, required int pins, required int slots, required int broadcasts, required int total}) async {
    await _db.collection('directory_resource_orders').doc(id).update({
      'pinsCount': pins,
      'slotsCount': slots,
      'broadcastsCount': broadcasts,
      'totalCost': total,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<Map<String, dynamic>?> getActiveResourceOrder(String userId) {
    return _db.collection('directory_resource_orders')
        .where('userId', isEqualTo: userId)
        .where('status', whereIn: ['PENDING', 'APPROVED'])
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snap) => snap.docs.isEmpty ? null : <String, dynamic>{'id': snap.docs.first.id, ...snap.docs.first.data() as Map<String, dynamic>});
  }

  // --- Recharge Cards ---

  @override
  Future<void> generateRechargeCard({required String code, required int value, int pins = 0, int slots = 0}) async {
    await _db.collection('recharge_cards').doc(code).set({
      'tokenValue': value,
      'extraPins': pins,
      'extraSlots': slots,
      'status': 'active',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<Map<String, dynamic>>> listRechargeCards() {
    return _db.collection('recharge_cards').snapshots().map((snap) =>
        snap.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return <String, dynamic>{'id': doc.id, ...data ?? <String, dynamic>{}};
        }).toList());
  }

  // ─── 5. Admin Operations ─────────────────────────────────────────────────

  @override
  Stream<List<Map<String, dynamic>>> searchUsersAdmin({String? query, String? role, bool? hasProfile, bool? isActive}) {
    Query q = _db.collection('users');
    if (role != null) q = q.where('role', isEqualTo: role.toLowerCase());
    if (hasProfile != null) q = q.where('hasProfile', isEqualTo: hasProfile);
    if (isActive != null) q = q.where('isActive', isEqualTo: isActive);
    
    return q.orderBy('createdAt', descending: true).snapshots().map((snap) {
      final docs = snap.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        return <String, dynamic>{'id': doc.id, ...data ?? <String, dynamic>{}};
      });
      if (query != null && query.isNotEmpty) {
        final low = query.toLowerCase();
        return docs.where((u) => u['email']?.toString().toLowerCase().contains(low) == true || u['name']?.toString().toLowerCase().contains(low) == true).toList();
      }
      return docs.toList();
    });
  }

  @override
  Future<Map<String, dynamic>> getAuditDetails(String id) async {
    final userDoc = await _db.collection('users').doc(id).get();
    final data = (userDoc.data() as Map<String, dynamic>?) ?? {};
    
    final role = data['role']?.toString().toLowerCase();
    if (role == 'professional') {
      final profDoc = await _db.collection('directory_professionals').doc(id).get();
      data['professionalProfile'] = profDoc.data();
    } else if (role == 'institution') {
      final instDoc = await _db.collection('directory_institutions').doc(id).get();
      data['institutionProfile'] = instDoc.data();
    }
    
    // Transactions
    final txs = await _db.collection('directory_membership_transactions').where('userId', isEqualTo: id).limit(10).get();
    data['transactions'] = txs.docs.map((d) => d.data()).toList();
    
    return data;
  }

  @override
  Future<void> adminUpdateUser(String id, Map<String, dynamic> data) async {
    await _db.collection('users').doc(id).update({...data, 'updatedAt': FieldValue.serverTimestamp()});
  }

  @override
  Future<void> toggleUserActiveStatus(String id, bool isActive) async {
    await _db.collection('users').doc(id).update({'isActive': isActive, 'updatedAt': FieldValue.serverTimestamp()});
  }

  @override
  Future<void> verifyUserDocs(String id, String role, bool isApproved) async {
    final col = role == 'institution' ? 'directory_institutions' : 'directory_professionals';
    final batch = _db.batch();
    batch.update(_db.collection(col).doc(id), {'isApproved': isApproved, 'updatedAt': FieldValue.serverTimestamp()});
    batch.update(_db.collection('users').doc(id), {'isApproved': isApproved, 'updatedAt': FieldValue.serverTimestamp()});
    await batch.commit();
  }

  @override
  Stream<List<Map<String, dynamic>>> listAllProviders() {
    return Rx.combineLatest2(
      _db.collection('directory_professionals').snapshots(),
      _db.collection('directory_institutions').snapshots(),
      (profs, insts) {
        final List<Map<String, dynamic>> all = [];
        all.addAll((profs as QuerySnapshot).docs.map((doc) => <String, dynamic>{'id': doc.id, ...doc.data() as Map<String, dynamic>}).where((p) => p['isActive'] != false));
        all.addAll((insts as QuerySnapshot).docs.map((doc) => <String, dynamic>{'id': doc.id, ...doc.data() as Map<String, dynamic>}).where((p) => p['isActive'] != false));
        return all;
      },
    );
  }

  @override
  Future<void> approveProfessional(String id, bool isApproved, String role) async {
    final col = role == 'institution' ? 'directory_institutions' : 'directory_professionals';
    final batch = _db.batch();
    final timestamp = FieldValue.serverTimestamp();
    final data = {'isApproved': isApproved, 'verificationStatus': isApproved ? 'verified' : 'rejected', 'updatedAt': timestamp};
    batch.update(_db.collection(col).doc(id), data);
    batch.update(_db.collection('users').doc(id), data);
    await batch.commit();
  }

  @override
  Future<void> validateProfile(String id, String role) async {
    final col = role == 'institution' ? 'directory_institutions' : 'directory_professionals';
    await _db.collection(col).doc(id).update({'isProfileValidated': true, 'updatedAt': FieldValue.serverTimestamp()});
    await _db.collection('users').doc(id).update({'isProfileValidated': true, 'updatedAt': FieldValue.serverTimestamp()});
  }

  @override
  Stream<List<Map<String, dynamic>>> listSupportTickets({String? status}) {
    Query query = _db.collection('directory_support_inbox');
    if (status != null) query = query.where('status', isEqualTo: status);
    return query.snapshots().map((snap) =>
        snap.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return <String, dynamic>{'id': doc.id, ...data ?? <String, dynamic>{}};
        }).toList());
  }

  @override
  Stream<List<Map<String, dynamic>>> listPendingOrders() {
    return _db.collection('directory_resource_orders')
        .where('status', isEqualTo: 'PENDING')
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          return <String, dynamic>{'id': doc.id, ...data ?? <String, dynamic>{}};
        }).toList());
  }

  @override
  Future<void> approveResourceOrder(String orderId) async {
    await _db.collection('directory_resource_orders').doc(orderId).update({
      'status': 'APPROVED',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<Map<String, dynamic>>> listServiceModerationQueue({String status = 'PENDING'}) {
    return _db.collection('directory_services')
        .where('moderationStatus', isEqualTo: status)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  @override
  Stream<List<Map<String, dynamic>>> listRequestModerationQueue({String status = 'PENDING'}) {
    return _db.collection('directory_service_requests')
        .where('moderationStatus', isEqualTo: status)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  @override
  Future<void> moderateService(String id, String status, {String? reason}) async {
    await _db.collection('directory_services').doc(id).update({
      'moderationStatus': status,
      'flagReason': reason,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> moderateRequest(String id, String status, {String? reason}) async {
    await _db.collection('directory_service_requests').doc(id).update({
      'moderationStatus': status,
      'flagReason': reason,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> createLocalizedBroadcast({required String title, required String message, String? country, String? region, String? city}) async {
    await _db.collection('directory_broadcasts').add({
      'title': title,
      'message': message,
      'targetCountry': country ?? 'GLOBAL',
      'targetRegion': region,
      'targetCity': city,
      'status': 'queued',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<Map<String, dynamic>>> listTemplates() {
    return _db.collection('directory_templates').snapshots().map((snap) =>
        snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  @override
  Future<void> upsertTemplate(String id, List<String> visibleFields, {String? configJson, String? accentColor, String? iconName}) async {
    await _db.collection('directory_templates').doc(id).set({
      'visibleFields': visibleFields,
      'configJson': configJson,
      'accentColor': accentColor,
      'iconName': iconName,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> updateCategory(String id, Map<String, dynamic> data) async {
    await _db.collection('directory_categories').doc(id).update({...data, 'updatedAt': FieldValue.serverTimestamp()});
  }

  // ─── 6. Discovery & Helpers ──────────────────────────────────────────────

  @override
  Stream<Map<String, dynamic>> getSystemStats() {
    return _db.collection('metadata').doc('system_stats').snapshots().map((snap) => (snap.data() as Map<String, dynamic>?) ?? {});
  }
}
