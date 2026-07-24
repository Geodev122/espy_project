import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'espy_repository.dart';
import '../models/user_model.dart' as models;
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
import '../models/enums.dart';
import 'package:espy_dataconnect_sdk/espy_dataconnect_sdk.dart' as sdk;

/// Repository implementation for Firebase DataConnect (PostgreSQL) with Firestore Fallback
class DataConnectEspyRepository implements EspyRepository {
  final sdk.EspyConnector _db = sdk.EspyConnector.instance;
  final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;

  // ─── 1. Identity & Profiles ──────────────────────────────────────────────

  @override
  Future<models.UserModel?> getUser(String id) async {
    try {
      final result = await _db.getUser(uid: id).execute();
      final user = result.data.user;
      if (user != null) {
        return models.UserModel(
          id: user.id,
          email: user.email,
          name: user.name ?? '',
          role: UserRole.parse(user.role.stringValue),
          isActive: user.isActive,
          hasProfile: user.hasProfile,
          adminNotes: user.adminNotes,
          walletBalance: user.walletBalance,
          tokensUsed: user.tokensUsed,
          photoUrl: user.photoUrl,
          createdAt: user.createdAt.toDateTime(),
          updatedAt: user.updatedAt.toDateTime(),
        );
      }
    } catch (_) {}

    final doc = await _firestore.collection('users').doc(id).get();
    if (doc.exists && doc.data() != null) {
      return models.UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Future<void> createUser(models.UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
    try {
      await _db.createUser(
        id: user.id,
        email: user.email,
        role: sdk.UserRole.values.byName(user.role.toSql()),
      ).name(user.name).execute();
    } catch (_) {}
  }

  @override
  Future<void> upsertUser(models.UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap(), firestore.SetOptions(merge: true));
    try {
      await _db.upsertUser(
        id: user.id,
        email: user.email,
        role: sdk.UserRole.values.byName(user.role.toSql()),
      ).name(user.name).execute();
    } catch (_) {}
  }

  @override
  Future<void> updateUser(String id, models.UserModel user) async {
    await _firestore.collection('users').doc(id).set(user.toMap(), firestore.SetOptions(merge: true));
    try {
      final builder = _db.updateUserProfile(id: id);
      builder.name(user.name);
      if (user.photoUrl != null) builder.photoUrl(user.photoUrl!);
      if (user.phone != null) builder.phone(user.phone!);
      if (user.whatsapp != null) builder.whatsapp(user.whatsapp!);
      await builder.execute();
    } catch (_) {}
  }

  @override
  Future<void> updateLastActive(String id) async {
    await _firestore.collection('users').doc(id).update({'lastActiveAt': firestore.FieldValue.serverTimestamp()});
    try {
      await _db.updateUserLastActive(id: id).execute();
    } catch (_) {}
  }

  @override
  Future<ProfessionalProfile?> getProfessionalProfile(String id) async {
    try {
      final result = await _db.getProfessionalDetails(uid: id).execute();
      final prof = result.data.professionalProfile;
      if (prof != null) {
        return ProfessionalProfile(
          id: prof.id,
          fullNameAr: prof.fullNameAr,
          specialty: prof.specialty,
          specialtyAr: prof.specialtyAr,
          bioEn: prof.bioEn,
          bioAr: prof.bioAr,
          isApproved: prof.isApproved,
          isHonorVerified: prof.isHonorVerified,
          isProfileValidated: prof.isProfileValidated,
          verificationDocUrl: prof.verificationDocUrl,
          membershipTier: MembershipTier.parse(prof.membershipTier?.stringValue),
          serviceSlots: prof.serviceSlots,
          practicePins: prof.practicePins,
          visibilityExpiresAt: prof.visibilityExpiresAt?.toDateTime(),
        );
      }
    } catch (_) {}

    final doc = await _firestore.collection('directory_professionals').doc(id).get();
    return (doc.exists && doc.data() != null) ? ProfessionalProfile.fromMap(doc.data() as Map<String, dynamic>) : null;
  }

  @override
  Future<InstitutionProfile?> getInstitutionProfile(String id) async {
    try {
      final result = await _db.getUser(uid: id).execute();
      final inst = result.data.user?.institutionProfile_on_user;
      if (inst != null) {
        return InstitutionProfile(
          id: id,
          nameAr: inst.nameAr,
          registrationNumber: inst.registrationNumber,
          isApproved: inst.isApproved,
          isProfileValidated: inst.isProfileValidated,
          verificationDocUrl: inst.verificationDocUrl,
          serviceSlots: 0,
          visibilityExpiresAt: inst.visibilityExpiresAt?.toDateTime(),
        );
      }
    } catch (_) {}

    final doc = await _firestore.collection('directory_institutions').doc(id).get();
    return (doc.exists && doc.data() != null) ? InstitutionProfile.fromMap(doc.data() as Map<String, dynamic>) : null;
  }

  @override
  Future<VisitorProfile?> getVisitorProfile(String id) async {
    try {
      final result = await _db.getUser(uid: id).execute();
      final visitor = result.data.user?.visitorProfile_on_user;
      if (visitor != null) {
        return VisitorProfile(id: id, interests: (visitor.interests ?? []).whereType<String>().toList());
      }
    } catch (_) {}

    final doc = await _firestore.collection('directory_visitors').doc(id).get();
    return (doc.exists && doc.data() != null) ? VisitorProfile.fromMap(doc.data() as Map<String, dynamic>) : null;
  }

  // ─── 2. Taxonomy & Location ──────────────────────────────────────────────

  @override
  Stream<List<SectorModel>> listSectors() {
    final dcStream = _db.listSectors().ref().subscribe().map((snap) => 
      snap.data.sectors.map((s) => SectorModel(
        id: s.id,
        nameEn: s.nameEn,
        nameAr: s.nameAr,
        description: s.description,
        iconName: s.iconName,
        colorHex: s.colorHex,
      )).toList()
    ).onErrorReturnWith((e, s) => <SectorModel>[]);

    final fsStream = _firestore.collection('directory_sectors').snapshots().map((snap) =>
      snap.docs.map((doc) => SectorModel.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>})).toList()
    );

    return Rx.combineLatest2(dcStream, fsStream, (List dc, List fs) => dc.isNotEmpty ? dc : fs).cast<List<SectorModel>>();
  }

  @override
  Stream<List<CategoryModel>> listCategories({String? sectorId}) {
    firestore.Query fsQuery = _firestore.collection('directory_categories');
    if (sectorId != null) fsQuery = fsQuery.where('sectorId', isEqualTo: sectorId);
    return fsQuery.snapshots().map((snap) => snap.docs.map((doc) => CategoryModel.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>})).toList());
  }

  @override
  Stream<List<CountryModel>> listCountries() {
    return _firestore.collection('directory_countries').snapshots().map((snap) => snap.docs.map((doc) => CountryModel.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>})).toList());
  }

  @override
  Stream<List<RegionModel>> listRegions(String countryId) {
    return _firestore.collection('directory_regions').where('countryId', isEqualTo: countryId).snapshots().map((snap) => snap.docs.map((doc) => RegionModel.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>})).toList());
  }

  @override
  Stream<List<CityModel>> listCities(String regionId) {
    return _firestore.collection('directory_cities').where('regionId', isEqualTo: regionId).snapshots().map((snap) => snap.docs.map((doc) => CityModel.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>})).toList());
  }

  @override
  Stream<List<Map<String, dynamic>>> listLocationNodes(String userId) {
    return _firestore.collection('directory_locations').where('userId', isEqualTo: userId).snapshots().map((snap) => snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  @override
  Future<void> upsertCountry(CountryModel country) async {
    await _firestore.collection('directory_countries').doc(country.id).set(country.toMap(), firestore.SetOptions(merge: true));
  }

  @override
  Future<void> upsertRegion(RegionModel region) async {
    await _firestore.collection('directory_regions').doc(region.id).set(region.toMap(), firestore.SetOptions(merge: true));
  }

  @override
  Future<void> upsertCity(CityModel city) async {
    await _firestore.collection('directory_cities').doc(city.id).set(city.toMap(), firestore.SetOptions(merge: true));
  }

  @override
  Future<void> createLocationNode(LocationNodeModel node) async {
    await _firestore.collection('directory_locations').add({...node.toMap(), 'createdAt': firestore.FieldValue.serverTimestamp()});
  }

  @override
  Future<void> deleteGeographyEntity(String id, String type) async {
    final col = type == 'country' ? 'directory_countries' : (type == 'region' ? 'directory_regions' : 'directory_cities');
    await _firestore.collection(col).doc(id).delete();
  }

  @override
  Future<void> updateSectorBranding(String id, SectorModel sector) async {
    await _firestore.collection('directory_sectors').doc(id).set(sector.toMap(), firestore.SetOptions(merge: true));
  }

  @override
  Future<void> upsertServiceTag(Map<String, dynamic> data) async {
    await _firestore.collection('directory_service_tags').doc(data['id']).set(data, firestore.SetOptions(merge: true));
  }

  @override
  Future<void> upsertPriceTag(Map<String, dynamic> data) async {
    await _firestore.collection('directory_price_tags').doc(data['id']).set(data, firestore.SetOptions(merge: true));
  }

  @override
  Future<void> upsertPinCategory(Map<String, dynamic> data) async {
    await _firestore.collection('directory_pin_categories').doc(data['id']).set(data, firestore.SetOptions(merge: true));
  }

  @override
  Future<void> upsertPresenceTag(Map<String, dynamic> data) async {
    await _firestore.collection('directory_presence_tags').doc(data['id']).set(data, firestore.SetOptions(merge: true));
  }

  // ─── 3. Core Business Logic ──────────────────────────────────────────────

  @override
  Stream<List<ServiceModel>> listActiveServices({String? categoryId, String? sectorId}) {
    firestore.Query fsQuery = _firestore.collection('directory_services').where('isActive', isEqualTo: true).where('moderationStatus', isEqualTo: 'APPROVED');
    if (categoryId != null) fsQuery = fsQuery.where('categoryId', isEqualTo: categoryId);
    if (sectorId != null) fsQuery = fsQuery.where('sectorId', isEqualTo: sectorId);
    return fsQuery.snapshots().map((snap) => snap.docs.map((doc) => ServiceModel.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>})).toList());
  }

  @override
  Stream<List<ServiceModel>> listProfessionalServices(String professionalId) {
    return _firestore.collection('directory_services').where('providerId', isEqualTo: professionalId).snapshots().map((snap) => snap.docs.map((doc) => ServiceModel.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>})).toList());
  }

  @override
  Future<void> toggleServiceSlot(String serviceId, bool allocate) async {
    await _firestore.collection('directory_services').doc(serviceId).update({'isAllocated': allocate});
  }

  @override
  Stream<List<ServiceRequestModel>> listCommunityRequests({String? sectorId, bool newestFirst = true, String? userId}) {
    firestore.Query fsQuery = _firestore.collection('directory_service_requests').where('moderationStatus', isEqualTo: 'APPROVED');
    if (userId != null) fsQuery = fsQuery.where('userId', isEqualTo: userId);
    if (sectorId != null) fsQuery = fsQuery.where('sectorId', isEqualTo: sectorId);
    return fsQuery.snapshots().map((snap) => snap.docs.map((doc) => ServiceRequestModel.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>})).toList());
  }

  @override
  Future<void> createCommunityRequest(ServiceRequestModel request) async {
    await _firestore.collection('directory_service_requests').add({...request.toMap(), 'createdAt': firestore.FieldValue.serverTimestamp()});
  }

  @override
  Future<Map<String, List<Map<String, dynamic>>>> listMetadataTags() async {
    final s = await _firestore.collection('directory_service_tags').get();
    final p = await _firestore.collection('directory_price_tags').get();
    final c = await _firestore.collection('directory_pin_categories').get();
    final pr = await _firestore.collection('directory_presence_tags').get();
    return {
      'serviceTags': s.docs.map((d) => <String, dynamic>{'id': d.id, ...d.data()}).toList(),
      'priceTags': p.docs.map((d) => <String, dynamic>{'id': d.id, ...d.data()}).toList(),
      'pinCategories': c.docs.map((d) => <String, dynamic>{'id': d.id, ...d.data()}).toList(),
      'presenceTags': pr.docs.map((d) => <String, dynamic>{'id': d.id, ...d.data()}).toList(),
    };
  }

  // ─── 4. Ledger & Resource Orders ─────────────────────────────────────────

  @override
  Stream<List<WalletTransactionModel>> listWalletTransactions(String userId) {
    return _firestore.collection('directory_membership_transactions').where('userId', isEqualTo: userId).orderBy('createdAt', firestore.QueryDirection.descending).snapshots().map((snap) => snap.docs.map((doc) => WalletTransactionModel.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>})).toList());
  }

  @override
  Future<Map<String, dynamic>> spendTokens({required String userId, required String itemId, required int cost, required String role}) async {
     return {'success': true};
  }

  @override
  Future<void> recordInteraction({required String userId, required String targetId, InteractionType type = InteractionType.view}) async {
    await _firestore.collection('directory_interactions').add({'userId': userId, 'targetId': targetId, 'type': type.name, 'createdAt': firestore.FieldValue.serverTimestamp()});
  }

  @override
  Future<void> toggleFavorite(String userId, String targetId, bool isFavorite) async {
    final id = '${userId}_$targetId';
    if (isFavorite) {
      await _firestore.collection('directory_favorites').doc(id).set({'userId': userId, 'targetId': targetId, 'createdAt': firestore.FieldValue.serverTimestamp()});
    } else {
      await _firestore.collection('directory_favorites').doc(id).delete();
    }
  }

  @override
  Stream<List<String>> listFavoriteIds(String userId) {
    return _firestore.collection('directory_favorites').where('userId', isEqualTo: userId).snapshots().map((snap) => snap.docs.map((d) => d.get('targetId').toString()).toList());
  }

  @override
  Stream<List<String>> listContactedIds(String userId) {
    return _firestore.collection('directory_interactions').where('userId', isEqualTo: userId).where('type', isEqualTo: 'CONTACT').snapshots().map((snap) => snap.docs.map((d) => d.get('targetId').toString()).toList());
  }

  @override
  Future<void> upsertProfessionalProfile(ProfessionalProfile profile) async {
    await _firestore.collection('directory_professionals').doc(profile.id).set(profile.toMap(), firestore.SetOptions(merge: true));
  }

  @override
  Future<void> upsertInstitutionProfile(InstitutionProfile profile) async {
    await _firestore.collection('directory_institutions').doc(profile.id).set(profile.toMap(), firestore.SetOptions(merge: true));
  }

  @override
  Future<void> createResourceOrder(ResourceOrderModel order) async {
    await _firestore.collection('directory_resource_orders').add({
      ...order.toMap(),
      'createdAt': firestore.FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updateResourceOrder(ResourceOrderModel order) async {
    await _firestore.collection('directory_resource_orders').doc(order.id).update({
      ...order.toMap(),
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<ResourceOrderModel?> getActiveResourceOrder(String userId) {
    return _firestore.collection('directory_resource_orders').where('userId', isEqualTo: userId).where('status', isEqualTo: 'PENDING').snapshots().map((snap) => snap.docs.isEmpty ? null : ResourceOrderModel.fromMap({'id': snap.docs.first.id, ...snap.docs.first.data() as Map<String, dynamic>}));
  }

  @override
  Future<void> generateRechargeCard({required String code, required int value, int pins = 0, int slots = 0}) async {
    await _firestore.collection('recharge_cards').doc(code).set({'tokenValue': value, 'pins': pins, 'slots': slots, 'status': 'active'});
  }

  @override
  Stream<List<Map<String, dynamic>>> listRechargeCards() {
    return _firestore.collection('recharge_cards').snapshots().map((snap) => snap.docs.map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>}).toList());
  }

  // ─── 5. Admin Operations ─────────────────────────────────────────────────

  @override
  Stream<List<models.UserModel>> searchUsersAdmin({String? query, UserRole? role, bool? hasProfile, bool? isActive}) {
    firestore.Query q = _firestore.collection('users');
    if (role != null) q = q.where('role', isEqualTo: role.name);
    return q.snapshots().map((snap) => snap.docs.map((d) => models.UserModel.fromMap({'id': d.id, ...d.data() as Map<String, dynamic>})).toList());
  }

  @override
  Future<Map<String, dynamic>> getAuditDetails(String id) async {
    final userDoc = await _firestore.collection('users').doc(id).get();
    return userDoc.data() as Map<String, dynamic>? ?? {};
  }

  @override
  Future<void> adminUpdateUser(String id, models.UserModel user) async {
    await _firestore.collection('users').doc(id).update(user.toMap());
  }

  @override
  Future<void> toggleUserActiveStatus(String id, bool isActive) async {
    await _firestore.collection('users').doc(id).update({'isActive': isActive});
  }

  @override
  Future<void> verifyUserDocs(String id, UserRole role, bool isApproved) async {
    final col = role == UserRole.institution ? 'directory_institutions' : 'directory_professionals';
    await _firestore.collection(col).doc(id).update({'isApproved': isApproved});
  }

  @override
  Stream<List<Map<String, dynamic>>> listAllProviders() {
    return Rx.combineLatest2(
      _firestore.collection('directory_professionals').snapshots(),
      _firestore.collection('directory_institutions').snapshots(),
      (profs, insts) {
        final List<Map<String, dynamic>> all = [];
        all.addAll(profs.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}));
        all.addAll(insts.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}));
        return all;
      },
    );
  }

  @override
  Future<void> approveProfessional(String id, bool isApproved, UserRole role) async {
    final col = role == UserRole.institution ? 'directory_institutions' : 'directory_professionals';
    await _firestore.collection(col).doc(id).update({'isApproved': isApproved});
  }

  @override
  Future<void> validateProfile(String id, UserRole role) async {
    final col = role == UserRole.institution ? 'directory_institutions' : 'directory_professionals';
    await _firestore.collection(col).doc(id).update({'isProfileValidated': true});
  }

  @override
  Stream<List<SupportTicketModel>> listSupportTickets({SupportTicketStatus? status}) {
    firestore.Query q = _firestore.collection('directory_support_inbox');
    if (status != null) q = q.where('status', isEqualTo: status.name);
    return q.snapshots().map((snap) => snap.docs.map((d) => SupportTicketModel.fromMap({'id': d.id, ...d.data() as Map<String, dynamic>})).toList());
  }

  @override
  Stream<List<ResourceOrderModel>> listPendingOrders() {
    return _firestore.collection('directory_resource_orders').where('status', isEqualTo: 'PENDING').snapshots().map((snap) => snap.docs.map((d) => ResourceOrderModel.fromMap({'id': d.id, ...d.data() as Map<String, dynamic>})).toList());
  }

  @override
  Future<void> approveResourceOrder(String orderId) async {
    await _firestore.collection('directory_resource_orders').doc(orderId).update({'status': 'APPROVED'});
  }

  @override
  Stream<List<ServiceModel>> listServiceModerationQueue({ModerationStatus status = ModerationStatus.pending}) {
    return _firestore.collection('directory_services').where('moderationStatus', isEqualTo: status.name).snapshots().map((snap) => snap.docs.map((d) => ServiceModel.fromMap({'id': d.id, ...d.data() as Map<String, dynamic>})).toList());
  }

  @override
  Stream<List<ServiceRequestModel>> listRequestModerationQueue({ModerationStatus status = ModerationStatus.pending}) {
    return _firestore.collection('directory_service_requests').where('moderationStatus', isEqualTo: status.name).snapshots().map((snap) => snap.docs.map((d) => ServiceRequestModel.fromMap({'id': d.id, ...d.data() as Map<String, dynamic>})).toList());
  }

  @override
  Future<void> moderateService(String id, ModerationStatus status, {String? reason}) async {
    await _firestore.collection('directory_services').doc(id).update({'moderationStatus': status.name, 'flagReason': reason});
  }

  @override
  Future<void> moderateRequest(String id, ModerationStatus status, {String? reason}) async {
    await _firestore.collection('directory_service_requests').doc(id).update({'moderationStatus': status.name, 'flagReason': reason});
  }

  @override
  Future<void> createLocalizedBroadcast({required String title, required String message, String? country, String? region, String? city}) async {
    await _firestore.collection('directory_broadcasts').add({'title': title, 'message': message, 'targetCountry': country, 'createdAt': firestore.FieldValue.serverTimestamp()});
  }

  @override
  Stream<List<Map<String, dynamic>>> listTemplates() {
    return _firestore.collection('directory_templates').snapshots().map((snap) => snap.docs.map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>}).toList());
  }

  @override
  Future<void> upsertTemplate(String id, List<String> visibleFields, {String? configJson, String? accentColor, String? iconName}) async {
    await _firestore.collection('directory_templates').doc(id).set({'visibleFields': visibleFields, 'configJson': configJson, 'accentColor': accentColor, 'iconName': iconName}, firestore.SetOptions(merge: true));
  }

  // ─── 6. Discovery & Helpers ──────────────────────────────────────────────

  @override
  Stream<Map<String, dynamic>> getSystemStats() {
    return _firestore.collection('metadata').doc('system_stats').snapshots().map((snap) => (snap.data() as Map<String, dynamic>?) ?? {});
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
     await _firestore.collection('directory_categories').doc(category.id).update(category.toMap());
  }
}
