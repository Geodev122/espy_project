import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_data_connect/firebase_data_connect.dart' as fdc;
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
import 'package:espy_dataconnect_sdk/espy_dataconnect_sdk.dart' as sdk;

/// Repository implementation for Firebase DataConnect (PostgreSQL) with Firestore Fallback
class DataConnectEspyRepository implements EspyRepository {
  final sdk.EspyConnector _db = sdk.EspyConnector.instance;
  final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;

  // ─── 1. Identity & Profiles ──────────────────────────────────────────────

  @override
  Future<UserModel?> getUser(String id) async {
    final result = await _db.getUser(uid: id).execute();
    final u = result.data.user;
    if (u == null) return null;
    return UserModel.fromMap({
      'id': u.id,
      'email': u.email,
      'name': u.name ?? '',
      'role': u.role.stringValue,
      'walletBalance': u.walletBalance,
      'tokensUsed': u.tokensUsed,
      'isActive': u.isActive,
      'hasProfile': u.hasProfile,
      'createdAt': u.createdAt.toDateTime(),
    });
  }

  @override
  Future<void> createUser(UserModel user) async {
    await _db.createUser(
        id: user.id,
        email: user.email,
        role: sdk.UserRole.values.byName(user.role.name.toUpperCase()),
    ).execute();
  }

  @override
  Future<void> upsertUser(UserModel user) async {
    await _db.upsertUser(
        id: user.id,
        email: user.email,
        role: sdk.UserRole.values.byName(user.role.name.toUpperCase()),
    ).execute();
  }

  @override
  Future<void> updateUser(String id, UserModel user) async {
     await _firestore.collection('users').doc(id).update(user.toMap());
  }

  @override
  Future<void> updateLastActive(String id) async {
    await _db.updateUserLastActive(id: id).execute();
  }

  @override
  Future<ProfessionalProfile?> getProfessionalProfile(String id) async {
    final result = await _db.getProfessionalDetails(uid: id).execute();
    final p = result.data.professionalProfile;
    if (p == null) return null;
    return ProfessionalProfile.fromMap({
      'id': p.id,
      'fullNameEn': p.user.name ?? '',
      'fullNameAr': p.fullNameAr ?? '',
      'specialty': p.specialty ?? '',
      'specialtyAr': p.specialtyAr ?? '',
      'bioEn': p.bioEn ?? '',
      'bioAr': p.bioAr ?? '',
      'isApproved': p.isApproved,
      'isHonorVerified': p.isHonorVerified,
      'isProfileValidated': p.isProfileValidated,
      'verificationDocUrl': p.verificationDocUrl,
      'membershipTier': p.membershipTier?.stringValue,
      'serviceSlots': p.serviceSlots,
      'practicePins': p.practicePins,
      'visibilityExpiresAt': p.visibilityExpiresAt?.toDateTime(),
    });
  }

  @override
  Future<InstitutionProfile?> getInstitutionProfile(String id) async {
    return null;
  }

  @override
  Future<VisitorProfile?> getVisitorProfile(String id) async {
    return null;
  }

  // ─── 2. Taxonomy & Location ──────────────────────────────────────────────

  @override
  Stream<List<SectorModel>> listSectors() {
    return _db.listSectors().ref().subscribe().map((snap) =>
      snap.data.sectors.map((s) => SectorModel.fromMap({
        'id': s.id,
        'name_en': s.nameEn,
        'name_ar': s.nameAr ?? '',
        'colorHex': s.colorHex ?? '',
        'iconName': s.iconName ?? '',
      })).toList()
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Stream<List<CategoryModel>> listCategories({String? sectorId}) {
    return _db.listCategories().ref().subscribe().map((snap) =>
      snap.data.categories
      .where((c) => sectorId == null || c.sector.id == sectorId)
      .map((c) => CategoryModel.fromMap({
        'id': c.id,
        'sectorId': c.sector.id,
        'name_en': c.nameEn,
        'name_ar': c.nameAr ?? '',
      })).toList()
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Stream<List<CountryModel>> listCountries() {
    return _db.listCountries().ref().subscribe().map((snap) =>
      snap.data.countries.map((c) => CountryModel.fromMap({
        'id': c.id,
        'name_en': c.nameEn,
        'name_ar': c.nameAr ?? '',
      })).toList()
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Stream<List<RegionModel>> listRegions(String countryId) {
    return _db.listRegions(countryId: countryId).ref().subscribe().map((snap) =>
      snap.data.regions.map((r) => RegionModel.fromMap({
        'id': r.id,
        'countryId': countryId,
        'name_en': r.nameEn,
        'name_ar': r.nameAr ?? '',
      })).toList()
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Stream<List<CityModel>> listCities(String regionId) {
    return _db.listCities(regionId: regionId).ref().subscribe().map((snap) =>
      snap.data.cities.map((c) => CityModel.fromMap({
        'id': c.id,
        'regionId': regionId,
        'name_en': c.nameEn,
        'name_ar': c.nameAr ?? '',
      })).toList()
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Stream<List<Map<String, dynamic>>> listLocationNodes(String userId) {
    return _db.listLocationNodes(userId: userId).ref().subscribe().map((snap) =>
      snap.data.locationNodes.map((n) => {
        'id': n.id,
        'label': n.label,
        'lat': n.lat,
        'lng': n.lng,
        'isMain': n.isMain,
      }).toList()
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Future<void> upsertCountry(CountryModel country) async {
    await _db.upsertCountry(id: country.id, nameEn: country.nameEn, nameAr: country.nameAr).execute();
  }

  @override
  Future<void> upsertRegion(RegionModel region) async {
    await _db.upsertRegion(id: region.id, countryId: region.countryId, nameEn: region.nameEn, nameAr: region.nameAr).execute();
  }

  @override
  Future<void> upsertCity(CityModel city) async {
    await _db.upsertCity(id: city.id, regionId: city.regionId, nameEn: city.nameEn, nameAr: city.nameAr).execute();
  }

  @override
  Future<void> deleteGeographyEntity(String id, String type) async {
    await _db.deleteGeographyEntity(id: id).execute();
  }

  @override
  Future<void> updateSectorBranding(String id, SectorModel sector) async {
    await _db.updateSectorBranding(id: id).execute();
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
     await _firestore.collection('directory_categories').doc(category.id).update(category.toMap());
  }

  @override
  Future<void> upsertServiceTag(Map<String, dynamic> data) async {
    await _db.upsertServiceTag(id: data['id'], nameEn: data['nameEn'] ?? '', nameAr: data['nameAr'] ?? '').execute();
  }

  @override
  Future<void> upsertPriceTag(Map<String, dynamic> data) async {
    await _db.upsertPriceTag(id: data['id'], nameEn: data['nameEn'] ?? '', nameAr: data['nameAr'] ?? '').execute();
  }

  @override
  Future<void> upsertPinCategory(Map<String, dynamic> data) async {
    await _db.upsertPinCategory(id: data['id'], nameEn: data['nameEn'] ?? '', nameAr: data['nameAr'] ?? '').execute();
  }

  @override
  Future<void> upsertPresenceTag(Map<String, dynamic> data) async {
    await _db.upsertPresenceTag(id: data['id'], nameEn: data['nameEn'] ?? '', nameAr: data['nameAr'] ?? '').execute();
  }

  // ─── 3. Core Business Logic ──────────────────────────────────────────────

  @override
  Stream<List<ServiceModel>> listActiveServices({String? categoryId, String? sectorId}) {
    return _db.listActiveServices().ref().subscribe().map((snap) =>
      snap.data.services
      .where((s) => categoryId == null || s.category.id == categoryId)
      .where((s) => sectorId == null || s.sector.id == sectorId)
      .map((s) => ServiceModel.fromMap({
        'id': s.id,
        'titleEn': s.titleEn,
        'price': s.price,
      })).toList()
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Stream<List<ServiceModel>> listProfessionalServices(String professionalId) {
     return const Stream.empty();
  }

  @override
  Future<void> toggleServiceSlot(String serviceId, bool allocate) async {
  }

  @override
  Stream<List<ServiceRequestModel>> listCommunityRequests({String? sectorId, bool newestFirst = true, String? userId}) {
    return _db.listServiceRequests().ref().subscribe().map((snap) =>
      snap.data.serviceRequests
      .where((r) => sectorId == null || r.sector.id == sectorId)
      .where((r) => userId == null || r.user.id == userId)
      .map((r) => ServiceRequestModel.fromMap({
        'id': r.id,
        'descriptionEn': r.descriptionEn,
        'createdAt': r.createdAt.toDateTime(),
      })).toList()
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Future<void> createCommunityRequest(ServiceRequestModel request) async {
    await _db.postServiceRequest(sectorId: request.sectorId, descriptionEn: request.descriptionEn).execute();
  }

  @override
  Future<void> createLocationNode(LocationNodeModel node) async {
    await _db.createLocationNode(
      cityId: node.cityId,
      label: node.label,
      lat: node.lat,
      lng: node.lng,
      isMain: node.isMain,
    ).execute();
  }

  @override
  Future<Map<String, List<Map<String, dynamic>>>> listMetadataTags() async {
    final result = await _db.listMetadataTags().execute();
    return {
      'service': result.data.serviceTags.map((t) => {'id': t.id, 'nameEn': t.nameEn}).toList(),
      'price': result.data.priceTags.map((t) => {'id': t.id, 'nameEn': t.nameEn}).toList(),
    };
  }

  // ─── 4. Ledger & Resource Orders ─────────────────────────────────────────

  @override
  Stream<List<WalletTransactionModel>> listWalletTransactions(String userId) {
    return _db.getWalletTransactions(userId: userId).ref().subscribe().map((snap) =>
      snap.data.walletTransactions.map((t) => WalletTransactionModel(
        id: t.id,
        userId: userId,
        amount: t.amount,
        type: TransactionType.parse(t.type.stringValue),
        description: t.description,
        createdAt: t.createdAt.toDateTime(),
      )).toList()
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Future<Map<String, dynamic>> spendTokens({required String userId, required String itemId, required int cost, required UserRole role}) async {
    final result = await _db.spendTokens(
      userId: userId,
      cost: cost,
      ledgerAmount: -cost,
      description: "Service Purchase: $itemId",
    ).execute();
    return {'success': result.data.walletTransaction_insert != null};
  }

  @override
  Future<void> recordInteraction({required String userId, required String targetId, required InteractionType type}) async {
    await _db.recordInteraction(
      targetId: targetId,
      type: sdk.InteractionType.values.byName(type.name.toUpperCase()),
    ).execute();
  }

  @override
  Future<void> toggleFavorite(String userId, String targetId, bool isFavorite) async {
  }

  @override
  Stream<List<String>> listFavoriteIds(String userId) {
    return _db.listFavoriteIds(actorId: userId).ref().subscribe().map((snap) =>
      snap.data.interactions.map((i) => i.targetId).toList()
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Stream<List<String>> listContactedIds(String userId) {
    return _db.listContactedIds(actorId: userId).ref().subscribe().map((snap) =>
      snap.data.interactions.map((i) => i.targetId).toList()
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Future<void> upsertProfessionalProfile(ProfessionalProfile profile) async {
    await _db.upsertProfessionalProfile(id: profile.id).execute();
  }

  @override
  Future<void> upsertInstitutionProfile(InstitutionProfile profile) async {
    await _db.upsertInstitutionProfile(id: profile.id).execute();
  }

  @override
  Future<void> createResourceOrder(ResourceOrderModel order) async {
    await _db.createResourceOrder(
      pins: order.pinsCount,
      slots: order.slotsCount,
      broadcasts: order.broadcastsCount,
      total: order.totalCost,
    ).execute();
  }

  @override
  Future<void> updateResourceOrder(ResourceOrderModel order) async {
    await _db.updateResourceOrder(
      id: order.id,
      pins: order.pinsCount,
      slots: order.slotsCount,
      broadcasts: order.broadcastsCount,
      total: order.totalCost,
    ).execute();
  }

  @override
  Stream<ResourceOrderModel?> getActiveResourceOrder(String userId) {
    return _db.getActiveResourceOrder(userId: userId).ref().subscribe().map((snap) {
      final o = snap.data.resourceOrders.firstOrNull;
      if (o == null) return null;
      return ResourceOrderModel.fromMap({
        'id': o.id,
        'userId': userId,
        'pinsCount': o.pinsCount,
        'slotsCount': o.slotsCount,
        'broadcastsCount': o.broadcastsCount,
        'totalCost': o.totalCost,
        'status': o.status.stringValue,
        'createdAt': o.createdAt.toDateTime(),
      });
    }).onErrorReturnWith((e, s) => null);
  }

  @override
  Future<void> generateRechargeCard({required String code, required int value, int pins = 0, int slots = 0}) async {
    await _db.createRechargeCard(code: code, value: value, pins: pins, slots: slots).execute();
  }

  @override
  Stream<List<Map<String, dynamic>>> listRechargeCards() {
    return _db.listRechargeCards().ref().subscribe().map((snap) =>
      snap.data.rechargeCards.map((c) => {'id': c.id, 'code': c.id, 'value': c.tokenValue}).toList()
    ).onErrorReturnWith((e, s) => []);
  }

  // ─── 5. Admin Operations ─────────────────────────────────────────────────

  @override
  Stream<List<UserModel>> searchUsersAdmin({String? query, UserRole? role, bool? hasProfile, bool? isActive}) {
    return _db.searchUsersAdmin().ref().subscribe().map((snap) =>
      snap.data.users
      .where((u) => role == null || u.role.stringValue == role.name.toUpperCase())
      .where((u) => isActive == null || u.isActive == isActive)
      .map((u) => UserModel.fromMap({
        'id': u.id,
        'email': u.email,
        'name': u.name ?? '',
        'role': u.role.stringValue,
      })).toList()
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Future<Map<String, dynamic>> getAuditDetails(String id) async {
    final result = await _db.getAuditDetails(id: id).execute();
    final u = result.data.user;
    return {'logs': u?.walletTransactions_on_user.map((l) => {'action': l.description}).toList() ?? []};
  }

  @override
  Future<void> adminUpdateUser(String id, UserModel user) async {
    await _db.updateUserAdmin(id: id).execute();
  }

  @override
  Future<void> toggleUserActiveStatus(String id, bool isActive) async {
    await _db.toggleUserActiveStatus(id: id, isActive: isActive).execute();
  }

  @override
  Future<void> verifyUserDocs(String id, UserRole role, bool isApproved) async {
    if (role == UserRole.professional) {
      await _db.verifyUserProfessional(id: id, isApproved: isApproved).execute();
    } else {
      await _db.verifyUserInstitution(id: id, isApproved: isApproved).execute();
    }
  }

  @override
  Stream<List<Map<String, dynamic>>> listAllProviders() {
    return const Stream.empty();
  }

  @override
  Future<void> approveProfessional(String id, bool isApproved, UserRole role) async {
    await _db.approveProfessional(id: id, isApproved: isApproved).execute();
  }

  @override
  Future<void> validateProfile(String id, UserRole role) async {
    if (role == UserRole.professional) {
      await _db.validateProfile(id: id).execute();
    } else {
      await _db.validateInstitutionProfile(id: id).execute();
    }
  }

  @override
  Stream<List<SupportTicketModel>> listSupportTickets({SupportTicketStatus? status}) {
    return _db.listSupportTickets().ref().subscribe().map((snap) =>
      snap.data.supportTickets
      .where((t) => status == null || t.status.stringValue == status.name.toUpperCase())
      .map((t) => SupportTicketModel.fromMap({
        'id': t.id,
        'title': t.subject,
      })).toList()
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Stream<List<ResourceOrderModel>> listPendingOrders() {
    return _db.listPendingOrders().ref().subscribe().map((snap) =>
      snap.data.resourceOrders.map((o) => ResourceOrderModel.fromMap({
        'id': o.id,
        'totalCost': o.totalCost,
      })).toList()
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Future<void> approveResourceOrder(String orderId) async {
    await _db.approveResourceOrder(id: orderId).execute();
  }

  // --- Service Management & Moderation ---
  @override
  Stream<List<ServiceModel>> listServiceModerationQueue({ModerationStatus status = ModerationStatus.pending}) {
    final sdkStatus = sdk.ModerationStatus.values.byName(status.name.toUpperCase());
    return _db.listServiceModerationQueue().ref().subscribe().map((snap) =>
      snap.data.services
      .where((s) => s.moderationStatus.stringValue == sdkStatus.name)
      .map((s) => ServiceModel.fromMap({
        'id': s.id,
        'titleEn': s.titleEn,
      })).toList()
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Stream<List<ServiceRequestModel>> listRequestModerationQueue({ModerationStatus status = ModerationStatus.pending}) {
    final sdkStatus = sdk.ModerationStatus.values.byName(status.name.toUpperCase());
    return _db.listRequestModerationQueue().ref().subscribe().map((snap) =>
      snap.data.serviceRequests
      .where((r) => r.moderationStatus.stringValue == sdkStatus.name)
      .map((r) => ServiceRequestModel.fromMap({
        'id': r.id,
        'descriptionEn': r.descriptionEn,
      })).toList()
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Future<void> moderateService(String id, ModerationStatus status, {String? reason}) async {
    await _db.moderateService(id: id, status: sdk.ModerationStatus.values.byName(status.name.toUpperCase())).execute();
  }

  @override
  Future<void> moderateRequest(String id, ModerationStatus status, {String? reason}) async {
    await _db.moderateRequest(id: id, status: sdk.ModerationStatus.values.byName(status.name.toUpperCase())).execute();
  }

  @override
  Future<void> createLocalizedBroadcast({required String title, required String message, String? country, String? region, String? city}) async {
    await _db.createLocalizedBroadcast(title: title, message: message).execute();
  }
  
  @override
  Stream<List<Map<String, dynamic>>> listTemplates() {
    return _db.listTemplates().ref().subscribe().map((snap) =>
      snap.data.templates.map((t) => {'id': t.id}).toList()
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Future<void> upsertTemplate(String id, List<String> visibleFields, {String? configJson, String? accentColor, String? iconName}) async {
    await _db.upsertTemplate(id: id).execute();
  }

  @override
  Stream<Map<String, dynamic>> getSystemStats() {
    return const Stream.empty();
  }

  // ─── 7. Operational Governance ──────────────────────────────────────────
  @override
  Stream<List<Map<String, dynamic>>> listSosNumbers({String? countryId, String? sectorId, String? categoryId}) {
    return _db.listSosNumbers().ref().subscribe().map((snap) =>
      snap.data.sosNumbers
      .where((n) => countryId == null || n.country.id == countryId)
      .map((n) => {'id': n.id, 'number': n.number}).toList()
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Future<void> upsertSosNumber(Map<String, dynamic> sosData) async {
    await _db.upsertSosNumber(
      countryId: sosData['countryId'],
      labelEn: sosData['labelEn'],
      number: sosData['number'],
      isActive: sosData['isActive'],
    ).execute();
  }
  
  @override
  Stream<List<Map<String, dynamic>>> listTokenPackages({UserRole? targetRole, bool? isActive}) {
    final builder = _db.listTokenPackages();
    return builder.ref().subscribe().map((snap) =>
      snap.data.tokenPackages
      .where((p) => targetRole == null || p.targetRole.stringValue == targetRole.name.toUpperCase())
      .where((p) => isActive == null || p.isActive == isActive)
      .map((p) => {
        'id': p.id,
        'nameEn': p.nameEn,
        'tokenCount': p.tokenCount,
        'price': p.price,
        'isActive': p.isActive,
      }).toList()
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Future<void> upsertTokenPackage(Map<String, dynamic> data) async {
    await _db.upsertTokenPackage(
      id: data['id'],
      nameEn: data['nameEn'],
      tokenCount: data['tokenCount'],
      price: data['price'].toDouble(),
      targetRole: sdk.UserRole.values.byName(UserRole.parse(data['targetRole']).name.toUpperCase()),
      isActive: data['isActive'],
    ).execute();
  }
  
  @override
  Stream<List<Map<String, dynamic>>> listElementPricing() {
    return _db.listElementPricing().ref().subscribe().map((snap) =>
      snap.data.elementPricings.map((e) => {
        'id': e.id,
        'tokenCost': e.tokenCost,
      }).toList()
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Future<void> updateElementPricing(String id, int tokenCost, {int? validityDays}) async {
    await _db.updateElementPricing(id: id, tokenCost: tokenCost).execute();
  }
  
  @override
  Stream<List<Map<String, dynamic>>> listBroadcastModerationQueue({ModerationStatus status = ModerationStatus.pending}) {
    final sdkStatus = sdk.ModerationStatus.values.byName(status.name.toUpperCase());
    return _db.listBroadcastModerationQueue().ref().subscribe().map((snap) =>
      snap.data.broadcasts
      .where((b) => b.moderationStatus.stringValue == sdkStatus.name)
      .map((b) => {'id': b.id, 'title': b.title}).toList()
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Future<void> moderateBroadcast(String id, ModerationStatus status, {String? reason}) async {
    final sdkStatus = sdk.ModerationStatus.values.byName(status.name.toUpperCase());
    await _db.moderateBroadcast(id: id, status: sdkStatus).execute();
  }

  @override
  Future<List<WalletTransactionModel>> getFinanceStats({DateTime? start, DateTime? end}) async {
    final builder = _db.getFinanceStats();
    if (start != null) builder.start(fdc.Timestamp.fromDateTime(start));
    if (end != null) builder.end(fdc.Timestamp.fromDateTime(end));

    final result = await builder.execute();
    return result.data.walletTransactions.map((t) => WalletTransactionModel(
      id: t.id.toString(),
      userId: t.user.id,
      amount: t.amount,
      type: TransactionType.parse(t.type.stringValue),
      description: t.description,
      createdAt: t.createdAt.toDateTime(),
    )).toList();
  }

  @override
  Future<void> refundTransaction(String id, String reason) async {
    await _db.refundTransaction(id: id, reason: reason).execute();
  }
  
  @override
  Future<List<Map<String, dynamic>>> getAnalyticsSnapshots({DateTime? start, DateTime? end}) async {
    final builder = _db.getAnalyticsSnapshots();
    if (start != null) builder.start(start);
    if (end != null) builder.end(end);
    
    final result = await builder.execute();
    return result.data.analyticsSnapshots.map((s) => {
      'id': s.id.toString(),
      'date': s.date,
      'totalUsers': s.totalUsers,
      'totalRevenue': s.totalRevenue,
      'tokensBurned': s.tokensBurned,
      'activeRequests': s.activeRequests,
      'topSectorId': s.topSectorId,
    }).toList();
  }

  @override
  Future<void> createAnalyticsSnapshot(Map<String, dynamic> data) async {
    await _db.createAnalyticsSnapshot(
      date: data['date'],
      totalUsers: data['totalUsers'],
      totalRevenue: data['totalRevenue'].toDouble(),
      tokensBurned: data['tokensBurned'],
      activeRequests: data['activeRequests'],
    ).topSectorId(data['topSectorId']).execute();
  }
  
  @override
  Future<String?> getAppConfig(String key) async {
    final result = await _db.getAppConfig(key: key).execute();
    return result.data.appConfig?.value;
  }

  @override
  Future<void> updateAppConfig(String key, String value) async {
    await _db.updateAppConfig(key: key, value: value).execute();
  }

  @override
  Stream<List<Map<String, dynamic>>> listAppConfigs() {
    return _db.listAppConfigs().ref().subscribe().map((snap) =>
      snap.data.appConfigs.map((c) => {'key': c.key, 'value': c.value}).toList()
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Future<Map<String, dynamic>?> getServiceMetric(String serviceId) async {
    final result = await _db.getServiceMetric(serviceId: serviceId).execute();
    final m = result.data.serviceMetric;
    if (m == null) return null;
    return {
      'views': m.views,
      'contacts': m.contacts,
      'shares': m.shares,
      'updatedAt': m.updatedAt.toDateTime(),
    };
  }

  @override
  Future<void> incrementServiceMetric(String serviceId, {int views = 0, int contacts = 0, int shares = 0}) async {
    await _db.incrementServiceMetric(serviceId: serviceId)
      .views(views)
      .contacts(contacts)
      .shares(shares)
      .execute();
  }

  @override
  Stream<List<Map<String, dynamic>>> listActiveBroadcasts({String? country, UserRole? role}) {
    return _db.listActiveBroadcasts().ref().subscribe().map((snap) =>
      snap.data.broadcasts
      .where((b) => country == null || b.targetCountry == country || b.targetCountry == 'GLOBAL')
      .map((b) => {
        'id': b.id,
        'title': b.title,
        'message': b.message,
      }).toList()
    ).onErrorReturnWith((e, s) => []);
  }
}
