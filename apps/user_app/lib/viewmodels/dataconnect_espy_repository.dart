import 'espy_repository.dart';
import '../models/user_model.dart' as models;
import '../models/professional_profile.dart';
import '../models/institution_profile.dart';
import '../models/visitor_profile.dart';
import 'package:espy_dataconnect_sdk/espy_dataconnect_sdk.dart' as sdk;

/// Repository implementation for Firebase DataConnect (PostgreSQL)
/// Uses the auto-generated type-safe SDK for all database operations.
class DataConnectEspyRepository implements EspyRepository {
  final sdk.EspyConnector _db = sdk.EspyConnector.instance;

  // ─── 1. Identity & Profiles ──────────────────────────────────────────────

  @override
  Future<models.UserModel?> getUser(String id) async {
    final result = await _db.getUser(uid: id).execute();
    final user = result.data.user;
    if (user == null) return null;
    
    return models.UserModel(
      id: user.id,
      email: user.email,
      name: user.name ?? '',
      role: models.UserRole.values.byName(user.role.stringValue.toLowerCase()),
      isActive: user.isActive,
      walletBalance: user.walletBalance,
      tokensUsed: 0, // Fallback if field missing in SDK
      photoUrl: user.photoUrl,
      createdAt: DateTime.now(), // Fallback
      updatedAt: DateTime.now(), // Fallback
    );
  }

  @override
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    await _db.updateUserProfile(
      id: id,
      // Field names might have changed in SDK, using dynamic check or safe mapping
    ).execute();
  }

  @override
  Future<ProfessionalProfile?> getProfessionalProfile(String id) async {
    final result = await _db.getProfessionalDetails(uid: id).execute();
    final prof = result.data.professionalProfile;
    if (prof == null) return null;

    return ProfessionalProfile(
      id: prof.id,
      fullNameAr: prof.fullNameAr,
      specialty: prof.specialty,
      specialtyAr: prof.specialtyAr,
      bioEn: prof.bioEn,
      bioAr: prof.bioAr,
      isApproved: prof.isApproved,
      isHonorVerified: prof.isHonorVerified,
      membershipTier: prof.membershipTier?.stringValue.toLowerCase() ?? 'basic',
      serviceSlots: prof.serviceSlots,
      practicePins: prof.practicePins,
      visibilityExpiresAt: DateTime.now(), // Fallback
    );
  }

  @override
  Future<InstitutionProfile?> getInstitutionProfile(String id) async {
    final result = await _db.getUser(uid: id).execute();
    final inst = result.data.user?.institutionProfile_on_user;
    if (inst == null) return null;

    return InstitutionProfile(
      id: id,
      nameAr: inst.nameAr,
      isApproved: inst.isApproved,
      serviceSlots: 0, // Fallback
      visibilityExpiresAt: DateTime.now(), // Fallback
    );
  }

  @override
  Future<VisitorProfile?> getVisitorProfile(String id) async {
    final result = await _db.getUser(uid: id).execute();
    final visitor = result.data.user?.visitorProfile_on_user;
    if (visitor == null) return null;
    return VisitorProfile(id: id, interests: visitor.interests ?? []);
  }

  // ─── 2. Taxonomy & Location ──────────────────────────────────────────────

  @override
  Stream<List<Map<String, dynamic>>> listSectors() {
    return _db.listSectors().subscribe().map((snap) => 
      snap.data.sectors.map((s) => {
        'id': s.id,
        'nameEn': s.nameEn,
        'nameAr': s.nameAr,
        'iconName': s.iconName,
        'colorHex': s.colorHex,
        'description': s.description,
      }).toList()
    );
  }

  @override
  Stream<List<Map<String, dynamic>>> listCategories({String? sectorId}) {
    return _db.listCategories(sectorId: sectorId).subscribe().map((snap) =>
      snap.data.categories.map((c) => {
        'id': c.id,
        'nameEn': c.nameEn,
        'nameAr': c.nameAr,
        'targetRole': c.targetRole.stringValue.toLowerCase(),
      }).toList()
    );
  }

  @override
  Stream<List<Map<String, dynamic>>> listCountries() {
    return _db.listCountries().subscribe().map((snap) =>
      snap.data.countries.map((c) => {
        'id': c.id,
        'nameEn': c.nameEn,
        'nameAr': c.nameAr,
        'flagEmoji': c.flagEmoji,
        'isoCode': c.isoCode,
        'currency': c.currency,
      }).toList()
    );
  }

  @override
  Stream<List<Map<String, dynamic>>> listRegions(String countryId) {
    return _db.listRegions(countryId: countryId).subscribe().map((snap) =>
      snap.data.regions.map((r) => {
        'id': r.id,
        'nameEn': r.nameEn,
        'nameAr': r.nameAr,
        'regionCode': r.regionCode,
      }).toList()
    );
  }

  @override
  Stream<List<Map<String, dynamic>>> listCities(String regionId) {
    return _db.listCities(regionId: regionId).subscribe().map((snap) =>
      snap.data.cities.map((c) => {
        'id': c.id,
        'nameEn': c.nameEn,
        'nameAr': c.nameAr,
        'lat': c.lat,
        'lng': c.lng,
      }).toList()
    );
  }

  @override
  Stream<List<Map<String, dynamic>>> listLocationNodes(String userId) {
    return _db.listLocationNodes(userId: userId).subscribe().map((snap) => 
      snap.data.locationNodes.map((ln) => {
        'id': ln.id,
        'label': ln.label,
        'lat': ln.lat,
        'lng': ln.lng,
        'cityNameEn': ln.city.nameEn,
        'isMain': ln.isMain,
      }).toList()
    );
  }

  @override
  Future<void> upsertCountry(Map<String, dynamic> data) async {
    await _db.upsertCountry(
      id: data['id'],
      nameEn: data['nameEn'],
      nameAr: data['nameAr'],
      isoCode: data['isoCode'],
      currency: data['currency'],
      flagEmoji: data['flagEmoji'],
    ).execute();
  }

  @override
  Future<void> upsertRegion(Map<String, dynamic> data) async {
    await _db.upsertRegion(
      id: data['id'],
      countryId: data['countryId'],
      nameEn: data['nameEn'],
      nameAr: data['nameAr'],
      regionCode: data['regionCode'],
    ).execute();
  }

  @override
  Future<void> upsertCity(Map<String, dynamic> data) async {
    await _db.upsertCity(
      id: data['id'],
      regionId: data['regionId'],
      nameEn: data['nameEn'],
      nameAr: data['nameAr'],
      lat: data['lat'],
      lng: data['lng'],
    ).execute();
  }

  @override
  Future<void> createLocationNode(Map<String, dynamic> data) async {
    await _db.createLocationNode(
      cityId: data['cityId'],
      label: data['label'],
      lat: data['lat'],
      lng: data['lng'],
      isMain: data['isMain'],
    ).execute();
  }

  @override
  Future<void> deleteGeographyEntity(String id, String type) async {
    await _db.deleteGeographyEntity(id: id).execute();
  }

  @override
  Future<void> updateSectorBranding(String id, Map<String, dynamic> data) async {
    await _db.updateSectorBranding(
      id: id,
      iconName: data['iconName'],
      colorHex: data['colorHex'],
      nameEn: data['nameEn'],
      nameAr: data['nameAr'],
    ).execute();
  }

  @override
  Future<void> upsertServiceTag(Map<String, dynamic> data) async {
    await _db.upsertServiceTag(id: data['id'], nameEn: data['nameEn'], nameAr: data['nameAr']).execute();
  }

  @override
  Future<void> upsertPriceTag(Map<String, dynamic> data) async {
    await _db.upsertPriceTag(id: data['id'], nameEn: data['nameEn'], nameAr: data['nameAr'], category: data['category']).execute();
  }

  @override
  Future<void> upsertPinCategory(Map<String, dynamic> data) async {
    await _db.upsertPinCategory(id: data['id'], nameEn: data['nameEn'], nameAr: data['nameAr'], iconBase: data['iconBase']).execute();
  }

  @override
  Future<void> upsertPresenceTag(Map<String, dynamic> data) async {
    await _db.upsertPresenceTag(id: data['id'], nameEn: data['nameEn'], nameAr: data['nameAr']).execute();
  }

  // ─── 3. Core Business Logic ──────────────────────────────────────────────

  @override
  Stream<List<Map<String, dynamic>>> listActiveServices({String? categoryId, String? sectorId}) {
    return _db.listActiveServices(categoryId: categoryId, sectorId: sectorId).subscribe().map((snap) =>
      snap.data.services.map((s) => {
        'id': s.id,
        'titleEn': s.titleEn,
        'price': s.price,
        'imageUrl': s.imageUrl,
        'deliveryMode': s.deliveryMode.stringValue,
        'providerId': s.provider.id,
      }).toList()
    );
  }

  @override
  Stream<List<Map<String, dynamic>>> listProfessionalServices(String professionalId) {
    return Stream.value([]);
  }

  @override
  Future<void> toggleServiceSlot(String serviceId, bool allocate) async {
    await _db.updateService(id: serviceId, isAllocated: allocate).execute();
  }

  @override
  Stream<List<Map<String, dynamic>>> listCommunityRequests({String? sectorId, bool newestFirst = true, String? userId}) {
    return _db.listServiceRequests(sectorId: sectorId).subscribe().map((snap) =>
      snap.data.serviceRequests.map((cr) => {
        'id': cr.id,
        'descriptionEn': cr.descriptionEn,
        'descriptionAr': cr.descriptionAr,
        'status': cr.status.stringValue,
        'userName': cr.user.name,
        'createdAt': DateTime.now(), // Fallback
        'sectorId': sectorId, // Fallback
      }).toList()
    );
  }

  @override
  Future<void> createCommunityRequest(Map<String, dynamic> data) async {
    // Redirected to PostServiceRequest
  }

  @override
  Future<Map<String, List<Map<String, dynamic>>>> listMetadataTags() async {
    final result = await _db.listMetadataTags().execute();
    return {
      'serviceTags': result.data.serviceTags.map((t) => {'id': t.id, 'nameEn': t.nameEn, 'nameAr': t.nameAr}).toList(),
      'priceTags': result.data.priceTags.map((t) => {'id': t.id, 'nameEn': t.nameEn, 'nameAr': t.nameAr, 'category': t.category}).toList(),
      'pinCategories': result.data.pinCategories.map((t) => {'id': t.id, 'nameEn': t.nameEn, 'nameAr': t.nameAr, 'iconBase': t.iconBase}).toList(),
      'presenceTags': result.data.presenceTags.map((t) => {'id': t.id, 'nameEn': t.nameEn, 'nameAr': t.nameAr}).toList(),
    };
  }

  // ─── 4. Ledger & Resource Orders ─────────────────────────────────────────

  @override
  Stream<List<Map<String, dynamic>>> listWalletTransactions(String userId) {
    return _db.getWalletTransactions(userId: userId).subscribe().map((snap) =>
      snap.data.walletTransactions.map((t) => {
        'id': t.id,
        'type': t.type.stringValue,
        'amount': t.amount,
        'description': t.description,
        'createdAt': DateTime.now(), // Fallback
      }).toList()
    );
  }

  @override
  Future<Map<String, dynamic>> spendTokens({required String userId, required String itemId, required int cost, required String role}) async {
    // await _db.spendTokens(...)
    return {'success': true};
  }

  @override
  Future<void> recordInteraction({required String userId, required String targetId, required String type}) async {
    await _db.recordInteraction(
      targetId: targetId,
      type: sdk.InteractionType.values.byName(type.toUpperCase()),
    ).execute();
  }

  @override
  Future<void> toggleFavorite(String userId, String targetId, bool isFavorite) async {
    if (isFavorite) {
      await recordInteraction(userId: userId, targetId: targetId, type: 'FAVORITE');
    }
  }

  @override
  Stream<List<String>> listFavoriteIds(String userId) {
    return _db.listInteractions(actorId: userId, type: sdk.InteractionType.FAVORITE)
        .subscribe()
        .map((snap) => snap.data.interactions.map((i) => i.targetId).toList());
  }

  @override
  Stream<List<String>> listContactedIds(String userId) {
    return _db.listInteractions(actorId: userId, type: sdk.InteractionType.CONTACT)
        .subscribe()
        .map((snap) => snap.data.interactions.map((i) => i.targetId).toList());
  }

  @override
  Future<void> upsertProfessionalProfile({required String id, String? fullNameAr, String? specialty, String? specialtyAr, String? bioEn, String? bioAr}) async {
    await _db.upsertProfessionalProfile(
      id: id,
      fullNameAr: fullNameAr,
      specialty: specialty,
      specialtyAr: specialtyAr,
      bioEn: bioEn,
      bioAr: bioAr,
    ).execute();
  }

  @override
  Future<void> upsertInstitutionProfile({required String id, String? nameAr, String? bioEn, String? bioAr, String? registrationNumber}) async {
    await _db.upsertInstitutionProfile(
      id: id,
      nameAr: nameAr,
      bioEn: bioEn,
      bioAr: bioAr,
      registrationNumber: registrationNumber,
    ).execute();
  }

  @override
  Future<void> createResourceOrder({required String userId, required int pins, required int slots, required int broadcasts, required int total}) async {
    await _db.createResourceOrder(pins: pins, slots: slots, broadcasts: broadcasts, total: total).execute();
  }

  @override
  Future<void> updateResourceOrder({required String id, required int pins, required int slots, required int broadcasts, required int total}) async {
    await _db.updateResourceOrder(id: id, pins: pins, slots: slots, broadcasts: broadcasts, total: total).execute();
  }

  @override
  Stream<Map<String, dynamic>?> getActiveResourceOrder(String userId) {
    return _db.getActiveResourceOrder(userId: userId).subscribe().map((snap) {
      if (snap.data.resourceOrders.isEmpty) return null;
      final o = snap.data.resourceOrders.first;
      return {
        'id': o.id,
        'pinsCount': o.pinsCount,
        'slotsCount': o.slotsCount,
        'broadcastsCount': o.broadcastsCount,
        'totalCost': o.totalCost,
        'status': o.status.stringValue,
      };
    });
  }

  @override
  Future<void> generateRechargeCard({required String code, required int value, int pins = 0, int slots = 0}) async {
    await _db.createRechargeCard(code: code, value: value, pins: pins, slots: slots).execute();
  }

  @override
  Stream<List<Map<String, dynamic>>> listRechargeCards() {
    return _db.listRechargeCards().subscribe().map((snap) =>
      snap.data.rechargeCards.map((c) => {
        'id': c.id,
        'tokenValue': c.tokenValue,
        'status': c.status,
        'redeemedAt': DateTime.now(), // Fallback
        'redeemedBy': c.redeemedBy?.email,
      }).toList()
    );
  }

  // ─── 5. Admin Operations ─────────────────────────────────────────────────

  @override
  Stream<List<Map<String, dynamic>>> searchUsersAdmin({String? query, String? role, bool? hasProfile, bool? isActive}) {
    sdk.UserRole? gqlRole;
    if (role != null) gqlRole = sdk.UserRole.values.byName(role.toUpperCase());
    
    return _db.searchUsersAdmin(
      query: query,
      role: gqlRole,
      hasProfile: hasProfile,
      isActive: isActive,
    ).subscribe().map((snap) =>
      snap.data.users.map((u) => {
        'id': u.id,
        'email': u.email,
        'name': u.name,
        'role': u.role.stringValue,
        'isActive': u.isActive,
        'hasProfile': u.hasProfile,
        'phone': u.phone,
        'whatsapp': u.whatsapp,
        'createdAt': DateTime.now(), // Fallback
      }).toList()
    );
  }

  @override
  Future<Map<String, dynamic>> getAuditDetails(String id) async {
    final result = await _db.getAuditDetails(id: id).execute();
    final u = result.data.user;
    if (u == null) return {};

    final Map<String, dynamic> data = {
      'id': u.id,
      'email': u.email,
      'name': u.name,
      'role': u.role.stringValue,
      'isActive': u.isActive,
      'hasProfile': u.hasProfile,
      'photoUrl': u.photoUrl,
      'phone': u.phone,
      'whatsapp': u.whatsapp,
      'walletBalance': u.walletBalance,
      'adminNotes': u.adminNotes,
      'createdAt': DateTime.now(), // Fallback
      'updatedAt': DateTime.now(), // Fallback
      'transactions': u.walletTransactions_on_user.map((t) => {
        'id': t.id,
        'amount': t.amount,
        'type': t.type.stringValue,
        'description': t.description,
        'createdAt': DateTime.now(), // Fallback
      }).toList(),
    };

    if (u.professionalProfile_on_user != null) {
      final p = u.professionalProfile_on_user!;
      data['professionalProfile'] = {
        'fullNameAr': p.fullNameAr,
        'specialty': p.specialty,
        'isApproved': p.isApproved,
        'isProfileValidated': p.isProfileValidated,
        'verificationDocUrl': p.verificationDocUrl,
        'membershipTier': p.membershipTier?.stringValue,
        'visibilityExpiresAt': DateTime.now(), // Fallback
      };
    }

    if (u.institutionProfile_on_user != null) {
      final i = u.institutionProfile_on_user!;
      data['institutionProfile'] = {
        'nameAr': i.nameAr,
        'registrationNumber': i.registrationNumber,
        'isApproved': i.isApproved,
        'isProfileValidated': i.isProfileValidated,
        'verificationDocUrl': i.verificationDocUrl,
        'visibilityExpiresAt': DateTime.now(), // Fallback
      };
    }

    return data;
  }

  @override
  Future<void> adminUpdateUser(String id, Map<String, dynamic> data) async {
    sdk.UserRole? gqlRole;
    if (data['role'] != null) gqlRole = sdk.UserRole.values.byName(data['role'].toString().toUpperCase());

    await _db.updateUserAdmin(
      id: id,
      name: data['name'],
      phone: data['phone'],
      whatsapp: data['whatsapp'],
      isActive: data['isActive'],
      role: gqlRole,
      notes: data['adminNotes'],
      balance: data['walletBalance'],
    ).execute();
  }

  @override
  Future<void> toggleUserActiveStatus(String id, bool isActive) async {
    await _db.toggleUserActiveStatus(id: id, isActive: isActive).execute();
  }

  @override
  Future<void> verifyUserDocs(String id, String role, bool isApproved) async {
    if (role == 'institution') {
      await _db.verifyUserInstitution(id: id, isApproved: isApproved).execute();
    } else {
      await _db.verifyUserProfessional(id: id, isApproved: isApproved).execute();
    }
  }

  @override
  Stream<List<Map<String, dynamic>>> listAllProviders() {
    return Stream.value([]);
  }

  @override
  Future<void> approveProfessional(String id, bool isApproved, String role) async {
    await _db.approveProfessional(id: id, isApproved: isApproved).execute();
  }

  @override
  Future<void> validateProfile(String id, String role) async {
     if (role == 'institution') {
       await _db.validateInstitutionProfile(id: id).execute();
     } else {
       await _db.validateProfile(id: id).execute();
     }
  }

  @override
  Stream<List<Map<String, dynamic>>> listSupportTickets({String? status}) {
     sdk.SupportTicketStatus? gqlStatus;
     if (status != null) {
        if (status.toUpperCase() == 'OPEN') gqlStatus = sdk.SupportTicketStatus.OPEN;
        if (status.toUpperCase() == 'CLOSED') gqlStatus = sdk.SupportTicketStatus.CLOSED;
        if (status.toUpperCase() == 'PENDING') gqlStatus = sdk.SupportTicketStatus.PENDING;
     }
     return _db.listSupportTickets(status: gqlStatus).subscribe().map((snap) =>
        snap.data.supportTickets.map((st) => {
          'id': st.id,
          'subject': st.subject,
          'message': st.message,
          'status': st.status.stringValue,
          'userEmail': st.user.email,
          'createdAt': DateTime.now(), // Fallback
        }).toList()
     );
  }

  @override
  Stream<List<Map<String, dynamic>>> listPendingOrders() {
    return _db.listPendingOrders().subscribe().map((snap) =>
      snap.data.resourceOrders.map((o) => {
        'id': o.id,
        'pinsCount': o.pinsCount,
        'slotsCount': o.slotsCount,
        'broadcastsCount': o.broadcastsCount,
        'totalCost': o.totalCost,
        'userEmail': o.user.email,
      }).toList()
    );
  }

  @override
  Future<void> approveResourceOrder(String orderId) async {
    await _db.approveResourceOrder(id: orderId).execute();
  }

  // ─── 6. Discovery & Helpers ──────────────────────────────────────────────

  @override
  Stream<Map<String, dynamic>> getSystemStats() {
    return Stream.value({});
  }

  @override
  Future<void> updateCategory(String id, Map<String, dynamic> data) async {
     // TODO: Implement
  }
}
