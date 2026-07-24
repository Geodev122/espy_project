import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:rxdart/rxdart.dart';
import 'espy_repository.dart';
import '../models/enums.dart';
import '../models/user_model.dart';
import '../models/professional_profile.dart';
import '../models/institution_profile.dart';
import '../models/visitor_profile.dart';
import '../models/sector_model.dart';
import '../models/category_model.dart';
import '../models/country_model.dart';
import '../models/region_model.dart';
import '../models/city_model.dart';
import '../models/service_model.dart';
import '../models/wallet_transaction.dart';
import '../models/resource_order.dart';
import '../models/service_request.dart';
import '../models/support_ticket.dart';
import '../models/location_node.dart';

class FirestoreEspyRepository implements EspyRepository {
  final firestore.FirebaseFirestore _db = firestore.FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(region: 'us-central1');

  // ─── 1. Identity & Profiles ──────────────────────────────────────────────

  @override
  Future<UserModel?> getUser(String id) async {
    final doc = await _db.collection('users').doc(id).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  @override
  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.id).set(user.toMap());
  }

  @override
  Future<void> upsertUser(UserModel user) async {
    await _db.collection('users').doc(user.id).set(user.toMap(), firestore.SetOptions(merge: true));
  }

  @override
  Future<void> updateUser(String id, UserModel user) async {
    await _db.collection('users').doc(id).update(user.toMap());
  }

  @override
  Future<void> updateLastActive(String id) async {
    await _db.collection('users').doc(id).update({'lastActiveAt': firestore.FieldValue.serverTimestamp()});
  }

  @override
  Future<ProfessionalProfile?> getProfessionalProfile(String id) async {
    final doc = await _db.collection('directory_professionals').doc(id).get();
    if (!doc.exists) return null;
    return ProfessionalProfile.fromMap(doc.data() as Map<String, dynamic>);
  }

  @override
  Future<InstitutionProfile?> getInstitutionProfile(String id) async {
    final doc = await _db.collection('directory_institutions').doc(id).get();
    if (!doc.exists) return null;
    return InstitutionProfile.fromMap(doc.data() as Map<String, dynamic>);
  }

  @override
  Future<VisitorProfile?> getVisitorProfile(String id) async {
    final doc = await _db.collection('directory_visitors').doc(id).get();
    if (!doc.exists) return null;
    return VisitorProfile.fromMap(doc.data() as Map<String, dynamic>);
  }

  // ─── 2. Taxonomy & Location ──────────────────────────────────────────────

  @override
  Stream<List<SectorModel>> listSectors() {
    return _db.collection('directory_sectors').snapshots().map((snap) =>
        snap.docs.map((doc) => SectorModel.fromMap({...doc.data() as Map<String, dynamic>, 'id': doc.id})).toList());
  }

  @override
  Stream<List<CategoryModel>> listCategories({String? sectorId}) {
    firestore.Query query = _db.collection('directory_categories');
    if (sectorId != null) query = query.where('sectorId', isEqualTo: sectorId);
    return query.snapshots().map((snap) =>
        snap.docs.map((doc) => CategoryModel.fromMap({...doc.data() as Map<String, dynamic>, 'id': doc.id})).toList());
  }

  @override
  Stream<List<CountryModel>> listCountries() {
    return _db.collection('directory_countries').snapshots().map((snap) =>
        snap.docs.map((doc) => CountryModel.fromMap({...doc.data() as Map<String, dynamic>, 'id': doc.id})).toList());
  }

  @override
  Stream<List<RegionModel>> listRegions(String countryId) {
    return _db.collection('directory_regions').where('countryId', isEqualTo: countryId).snapshots().map((snap) =>
        snap.docs.map((doc) => RegionModel.fromMap({...doc.data() as Map<String, dynamic>, 'id': doc.id})).toList());
  }

  @override
  Stream<List<CityModel>> listCities(String regionId) {
    return _db.collection('directory_cities').where('regionId', isEqualTo: regionId).snapshots().map((snap) =>
        snap.docs.map((doc) => CityModel.fromMap({...doc.data() as Map<String, dynamic>, 'id': doc.id})).toList());
  }

  @override
  Stream<List<Map<String, dynamic>>> listLocationNodes(String userId) {
    return _db.collection('directory_location_nodes').where('userId', isEqualTo: userId).snapshots().map((snap) =>
        snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());
  }

  @override
  Future<void> upsertCountry(CountryModel country) async {
    await _db.collection('directory_countries').doc(country.id).set(country.toMap(), firestore.SetOptions(merge: true));
  }

  @override
  Future<void> upsertRegion(RegionModel region) async {
    await _db.collection('directory_regions').doc(region.id).set(region.toMap(), firestore.SetOptions(merge: true));
  }

  @override
  Future<void> upsertCity(CityModel city) async {
    await _db.collection('directory_cities').doc(city.id).set(city.toMap(), firestore.SetOptions(merge: true));
  }

  @override
  Future<void> deleteGeographyEntity(String id, String type) async {
    final col = type == 'country' ? 'directory_countries' : (type == 'region' ? 'directory_regions' : 'directory_cities');
    await _db.collection(col).doc(id).delete();
  }

  @override
  Future<void> updateSectorBranding(String id, SectorModel sector) async {
    await _db.collection('directory_sectors').doc(id).set(sector.toMap(), firestore.SetOptions(merge: true));
  }

  @override
  Future<void> upsertServiceTag(Map<String, dynamic> data) async {
    await _db.collection('directory_service_tags').doc(data['id']).set(data, firestore.SetOptions(merge: true));
  }

  @override
  Future<void> upsertPriceTag(Map<String, dynamic> data) async {
    await _db.collection('directory_price_tags').doc(data['id']).set(data, firestore.SetOptions(merge: true));
  }

  @override
  Future<void> upsertPinCategory(Map<String, dynamic> data) async {
    await _db.collection('directory_pin_categories').doc(data['id']).set(data, firestore.SetOptions(merge: true));
  }

  @override
  Future<void> upsertPresenceTag(Map<String, dynamic> data) async {
    await _db.collection('directory_presence_tags').doc(data['id']).set(data, firestore.SetOptions(merge: true));
  }

  // ─── 3. Core Business Logic ──────────────────────────────────────────────

  @override
  Stream<List<ServiceModel>> listActiveServices({String? categoryId, String? sectorId}) {
    firestore.Query query = _db.collection('directory_services').where('moderationStatus', isEqualTo: 'APPROVED');
    if (categoryId != null) query = query.where('categoryId', isEqualTo: categoryId);
    if (sectorId != null) query = query.where('sectorId', isEqualTo: sectorId);
    return query.snapshots().map((snap) =>
        snap.docs.map((doc) => ServiceModel.fromMap({...doc.data() as Map<String, dynamic>, 'id': doc.id})).toList());
  }

  @override
  Stream<List<ServiceModel>> listProfessionalServices(String professionalId) {
    return _db.collection('directory_services').where('professionalId', isEqualTo: professionalId).snapshots().map((snap) =>
        snap.docs.map((doc) => ServiceModel.fromMap({...doc.data() as Map<String, dynamic>, 'id': doc.id})).toList());
  }

  @override
  Future<void> toggleServiceSlot(String serviceId, bool allocate) async {
    await _db.collection('directory_services').doc(serviceId).update({'isAllocated': allocate, 'updatedAt': firestore.FieldValue.serverTimestamp()});
  }

  @override
  Stream<List<ServiceRequestModel>> listCommunityRequests({String? sectorId, bool newestFirst = true, String? userId}) {
    firestore.Query query = _db.collection('directory_service_requests').where('moderationStatus', isEqualTo: 'APPROVED');
    if (sectorId != null) query = query.where('sectorId', isEqualTo: sectorId);
    if (userId != null) query = query.where('userId', isEqualTo: userId);
    query = query.orderBy('createdAt', descending: newestFirst);
    return query.snapshots().map((snap) =>
        snap.docs.map((doc) => ServiceRequestModel.fromMap({...doc.data() as Map<String, dynamic>, 'id': doc.id})).toList());
  }

  @override
  Future<void> createCommunityRequest(ServiceRequestModel request) async {
    await _db.collection('directory_service_requests').add({...request.toMap(), 'createdAt': firestore.FieldValue.serverTimestamp()});
  }

  @override
  Future<void> createLocationNode(LocationNodeModel node) async {
    await _db.collection('directory_location_nodes').add({...node.toMap(), 'createdAt': firestore.FieldValue.serverTimestamp()});
  }

  @override
  Future<Map<String, List<Map<String, dynamic>>>> listMetadataTags() async {
    final tags = await Future.wait([
      _db.collection('directory_service_tags').get(),
      _db.collection('directory_price_tags').get(),
      _db.collection('directory_pin_categories').get(),
      _db.collection('directory_presence_tags').get(),
    ]);
    return {
      'service': tags[0].docs.map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>}).toList(),
      'price': tags[1].docs.map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>}).toList(),
      'pin': tags[2].docs.map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>}).toList(),
      'presence': tags[3].docs.map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>}).toList(),
    };
  }

  // ─── 4. Ledger & Resource Orders ─────────────────────────────────────────

  @override
  Stream<List<WalletTransactionModel>> listWalletTransactions(String userId) {
    return _db.collection('wallet_transactions').where('userId', isEqualTo: userId).orderBy('createdAt', descending: true).snapshots().map((snap) =>
        snap.docs.map((doc) => WalletTransactionModel.fromMap({...doc.data() as Map<String, dynamic>, 'id': doc.id})).toList());
  }

  @override
  Future<Map<String, dynamic>> spendTokens({required String userId, required String itemId, required int cost, required UserRole role}) async {
    try {
      final resp = await _functions.httpsCallable('spendTokens').call({
        'userId': userId,
        'itemId': itemId,
        'cost': cost,
        'role': role.name,
      });
      return Map<String, dynamic>.from(resp.data);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  @override
  Future<void> recordInteraction({required String userId, required String targetId, required InteractionType type}) async {
    await _db.collection('directory_interactions').add({
      'userId': userId,
      'targetId': targetId,
      'type': type.name,
      'createdAt': firestore.FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> toggleFavorite(String userId, String targetId, bool isFavorite) async {
    if (isFavorite) {
      await _db.collection('directory_favorites').doc('${userId}_$targetId').set({
        'userId': userId,
        'targetId': targetId,
        'createdAt': firestore.FieldValue.serverTimestamp(),
      });
    } else {
      await _db.collection('directory_favorites').doc('${userId}_$targetId').delete();
    }
  }

  @override
  Stream<List<String>> listFavoriteIds(String userId) {
    return _db.collection('directory_favorites').where('userId', isEqualTo: userId).snapshots().map((snap) =>
        snap.docs.map((doc) => doc.get('targetId').toString()).toList());
  }

  @override
  Stream<List<String>> listContactedIds(String userId) {
    return _db.collection('directory_interactions').where('userId', isEqualTo: userId).where('type', isEqualTo: 'contact').snapshots().map((snap) =>
        snap.docs.map((doc) => doc.get('targetId').toString()).toList());
  }

  @override
  Future<void> upsertProfessionalProfile(ProfessionalProfile profile) async {
    await _db.collection('directory_professionals').doc(profile.id).set(profile.toMap(), firestore.SetOptions(merge: true));
  }

  @override
  Future<void> upsertInstitutionProfile(InstitutionProfile profile) async {
    await _db.collection('directory_institutions').doc(profile.id).set(profile.toMap(), firestore.SetOptions(merge: true));
  }

  @override
  Future<void> createResourceOrder(ResourceOrderModel order) async {
    await _db.collection('directory_resource_orders').add({...order.toMap(), 'createdAt': firestore.FieldValue.serverTimestamp()});
  }

  @override
  Future<void> updateResourceOrder(ResourceOrderModel order) async {
    await _db.collection('directory_resource_orders').doc(order.id).update({...order.toMap(), 'updatedAt': firestore.FieldValue.serverTimestamp()});
  }

  @override
  Stream<ResourceOrderModel?> getActiveResourceOrder(String userId) {
    return _db.collection('directory_resource_orders')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'APPROVED')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snap) => snap.docs.isEmpty ? null : ResourceOrderModel.fromMap({...snap.docs.first.data() as Map<String, dynamic>, 'id': snap.docs.first.id}));
  }

  @override
  Future<void> generateRechargeCard({required String code, required int value, int pins = 0, int slots = 0}) async {
    await _db.collection('directory_recharge_cards').add({
      'code': code,
      'value': value,
      'pins': pins,
      'slots': slots,
      'isUsed': false,
      'createdAt': firestore.FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<Map<String, dynamic>>> listRechargeCards() {
    return _db.collection('directory_recharge_cards').orderBy('createdAt', descending: true).snapshots().map((snap) =>
        snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());
  }

  // ─── 5. Admin Operations ─────────────────────────────────────────────────

  @override
  Stream<List<UserModel>> searchUsersAdmin({String? query, UserRole? role, bool? hasProfile, bool? isActive}) {
    firestore.Query q = _db.collection('users');
    if (role != null) q = q.where('role', isEqualTo: role.name);
    if (isActive != null) q = q.where('isActive', isEqualTo: isActive);
    return q.snapshots().map((snap) =>
        snap.docs.map((doc) => UserModel.fromMap({...doc.data() as Map<String, dynamic>, 'id': doc.id})).toList());
  }

  @override
  Future<Map<String, dynamic>> getAuditDetails(String id) async {
    final logs = await _db.collection('audit_logs').where('targetId', isEqualTo: id).orderBy('createdAt', descending: true).get();
    return {'logs': logs.docs.map((d) => d.data()).toList()};
  }

  @override
  Future<void> adminUpdateUser(String id, UserModel user) async {
    await _db.collection('users').doc(id).update(user.toMap());
  }

  @override
  Future<void> toggleUserActiveStatus(String id, bool isActive) async {
    await _db.collection('users').doc(id).update({'isActive': isActive});
  }

  @override
  Future<void> verifyUserDocs(String id, UserRole role, bool isApproved) async {
    final col = role == UserRole.institution ? 'directory_institutions' : 'directory_professionals';
    await _db.collection(col).doc(id).update({'isApproved': isApproved, 'updatedAt': firestore.FieldValue.serverTimestamp()});
  }

  @override
  Stream<List<Map<String, dynamic>>> listAllProviders() {
    return Rx.combineLatest2(
      _db.collection('directory_professionals').snapshots(),
      _db.collection('directory_institutions').snapshots(),
      (snap1, snap2) => [
        ...snap1.docs.map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>}),
        ...snap2.docs.map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>}),
      ]
    );
  }

  @override
  Future<void> approveProfessional(String id, bool isApproved, UserRole role) async {
    final col = role == UserRole.institution ? 'directory_institutions' : 'directory_professionals';
    final batch = _db.batch();
    final timestamp = firestore.FieldValue.serverTimestamp();
    final data = {'isApproved': isApproved, 'verificationStatus': isApproved ? 'verified' : 'rejected', 'updatedAt': timestamp};
    batch.update(_db.collection(col).doc(id), data);
    batch.update(_db.collection('users').doc(id), data);
    await batch.commit();
  }

  @override
  Future<void> validateProfile(String id, UserRole role) async {
    final col = role == UserRole.institution ? 'directory_institutions' : 'directory_professionals';
    await _db.collection(col).doc(id).update({'isProfileValidated': true, 'updatedAt': firestore.FieldValue.serverTimestamp()});
    await _db.collection('users').doc(id).update({'isProfileValidated': true, 'updatedAt': firestore.FieldValue.serverTimestamp()});
  }

  @override
  Stream<List<SupportTicketModel>> listSupportTickets({SupportTicketStatus? status}) {
    firestore.Query query = _db.collection('directory_support_inbox');
    if (status != null) query = query.where('status', isEqualTo: status.name);
    return query.snapshots().map((snap) =>
        snap.docs.map((doc) => SupportTicketModel.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>})).toList());
  }

  @override
  Stream<List<ResourceOrderModel>> listPendingOrders() {
    return _db.collection('directory_resource_orders')
        .where('status', isEqualTo: 'PENDING')
        .snapshots()
        .map((snap) => snap.docs.map((doc) => ResourceOrderModel.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>})).toList());
  }

  @override
  Future<void> approveResourceOrder(String orderId) async {
    await _db.collection('directory_resource_orders').doc(orderId).update({
      'status': 'APPROVED',
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<ServiceModel>> listServiceModerationQueue({ModerationStatus status = ModerationStatus.pending}) {
    return _db.collection('directory_services')
        .where('moderationStatus', isEqualTo: status.name)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => ServiceModel.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>})).toList());
  }

  @override
  Stream<List<ServiceRequestModel>> listRequestModerationQueue({ModerationStatus status = ModerationStatus.pending}) {
    return _db.collection('directory_service_requests')
        .where('moderationStatus', isEqualTo: status.name)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => ServiceRequestModel.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>})).toList());
  }

  @override
  Future<void> moderateService(String id, ModerationStatus status, {String? reason}) async {
    await _db.collection('directory_services').doc(id).update({
      'moderationStatus': status.name,
      'flagReason': reason,
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> moderateRequest(String id, ModerationStatus status, {String? reason}) async {
    await _db.collection('directory_service_requests').doc(id).update({
      'moderationStatus': status.name,
      'flagReason': reason,
      'updatedAt': firestore.FieldValue.serverTimestamp(),
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
      'moderationStatus': 'PENDING',
      'createdAt': firestore.FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<Map<String, dynamic>>> listTemplates() {
    return _db.collection('directory_templates').snapshots().map((snap) =>
        snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());
  }

  @override
  Future<void> upsertTemplate(String id, List<String> visibleFields, {String? configJson, String? accentColor, String? iconName}) async {
    await _db.collection('directory_templates').doc(id).set({
      'visibleFields': visibleFields,
      'configJson': configJson,
      'accentColor': accentColor,
      'iconName': iconName,
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    }, firestore.SetOptions(merge: true));
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    await _db.collection('directory_categories').doc(category.id).update({...category.toMap(), 'updatedAt': firestore.FieldValue.serverTimestamp()});
  }

  @override
  Stream<Map<String, dynamic>> getSystemStats() {
    return _db.collection('metadata').doc('system_stats').snapshots().map((snap) => snap.data() ?? {});
  }

  // ─── 7. Operational Governance ──────────────────────────────────────────

  @override
  Stream<List<Map<String, dynamic>>> listSosNumbers({String? countryId, String? sectorId, String? categoryId}) {
    firestore.Query query = _db.collection('directory_sos_numbers');
    if (countryId != null) query = query.where('countryId', isEqualTo: countryId);
    if (sectorId != null) query = query.where('sectorId', isEqualTo: sectorId);
    if (categoryId != null) query = query.where('categoryId', isEqualTo: categoryId);
    return query.snapshots().map((snap) => snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());
  }

  @override
  Future<void> upsertSosNumber(Map<String, dynamic> sosData) async {
    final id = sosData['id'] ?? _db.collection('directory_sos_numbers').doc().id;
    await _db.collection('directory_sos_numbers').doc(id).set(sosData, firestore.SetOptions(merge: true));
  }

  @override
  Stream<List<Map<String, dynamic>>> listTokenPackages({UserRole? targetRole, bool? isActive}) {
    firestore.Query query = _db.collection('directory_token_packages');
    if (targetRole != null) query = query.where('targetRole', isEqualTo: targetRole.name.toUpperCase());
    if (isActive != null) query = query.where('isActive', isEqualTo: isActive);
    return query.snapshots().map((snap) => snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());
  }

  @override
  Future<void> upsertTokenPackage(Map<String, dynamic> packageData) async {
    await _db.collection('directory_token_packages').doc(packageData['id']).set(packageData, firestore.SetOptions(merge: true));
  }

  @override
  Stream<List<Map<String, dynamic>>> listElementPricing() {
    return _db.collection('directory_element_pricing').snapshots().map((snap) =>
        snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());
  }

  @override
  Future<void> updateElementPricing(String id, int tokenCost, {int? validityDays}) async {
    await _db.collection('directory_element_pricing').doc(id).set({
      'tokenCost': tokenCost,
      'validityDays': validityDays,
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    }, firestore.SetOptions(merge: true));
  }

  @override
  Stream<List<Map<String, dynamic>>> listBroadcastModerationQueue({ModerationStatus status = ModerationStatus.pending}) {
    return _db.collection('directory_broadcasts')
        .where('moderationStatus', isEqualTo: status.name.toUpperCase())
        .snapshots()
        .map((snap) => snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());
  }

  @override
  Future<void> moderateBroadcast(String id, ModerationStatus status, {String? reason}) async {
    await _db.collection('directory_broadcasts').doc(id).update({
      'moderationStatus': status.name.toUpperCase(),
      'moderationReason': reason,
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<WalletTransactionModel>> getFinanceStats({DateTime? start, DateTime? end}) async {
    firestore.Query query = _db.collection('wallet_transactions');
    if (start != null) query = query.where('createdAt', isGreaterThanOrEqualTo: start);
    if (end != null) query = query.where('createdAt', isLessThanOrEqualTo: end);
    final snap = await query.get();
    return snap.docs.map((doc) => WalletTransactionModel.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>})).toList();
  }

  @override
  Future<void> refundTransaction(String id, String reason) async {
    await _db.collection('wallet_transactions').doc(id).update({
      'isRefunded': true,
      'refundReason': reason,
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getAnalyticsSnapshots({DateTime? start, DateTime? end}) async {
    firestore.Query query = _db.collection('analytics_snapshots');
    if (start != null) query = query.where('date', isGreaterThanOrEqualTo: start);
    if (end != null) query = query.where('date', isLessThanOrEqualTo: end);
    final snap = await query.get();
    return snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
  }

  @override
  Future<void> createAnalyticsSnapshot(Map<String, dynamic> data) async {
    await _db.collection('analytics_snapshots').add({...data, 'createdAt': firestore.FieldValue.serverTimestamp()});
  }

  @override
  Future<String?> getAppConfig(String key) async {
    final doc = await _db.collection('directory_app_config').doc(key).get();
    return doc.data()?['value']?.toString();
  }

  @override
  Future<void> updateAppConfig(String key, String value) async {
    await _db.collection('directory_app_config').doc(key).set({
      'value': value,
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    }, firestore.SetOptions(merge: true));
  }

  @override
  Stream<List<Map<String, dynamic>>> listAppConfigs() {
    return _db.collection('directory_app_config').snapshots().map((snap) =>
      snap.docs.map((doc) => {'key': doc.id, 'value': doc.get('value')}).toList()
    );
  }

  @override
  Future<Map<String, dynamic>?> getServiceMetric(String serviceId) async {
    final doc = await _db.collection('directory_service_metrics').doc(serviceId).get();
    return doc.data() as Map<String, dynamic>?;
  }

  @override
  Future<void> incrementServiceMetric(String serviceId, {int views = 0, int contacts = 0, int shares = 0}) async {
    await _db.collection('directory_service_metrics').doc(serviceId).set({
      'views': firestore.FieldValue.increment(views),
      'contacts': firestore.FieldValue.increment(contacts),
      'shares': firestore.FieldValue.increment(shares),
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    }, firestore.SetOptions(merge: true));
  }

  @override
  Stream<List<Map<String, dynamic>>> listActiveBroadcasts({String? country, UserRole? role}) {
    firestore.Query query = _db.collection('directory_broadcasts').where('moderationStatus', isEqualTo: 'APPROVED');
    if (country != null) query = query.where('targetCountry', whereIn: [country, 'GLOBAL']);
    return query.snapshots().map((snap) =>
        snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());
  }
}
