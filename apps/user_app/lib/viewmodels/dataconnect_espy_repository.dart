import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_data_connect/firebase_data_connect.dart';
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
      role: models.UserRole.values.byName(user.role.value.name.toLowerCase()),
      isActive: user.isActive,
      walletBalance: user.walletBalance,
      tokensUsed: user.tokensUsed,
      photoUrl: user.photoUrl,
      createdAt: user.createdAt.toDateTime(),
      updatedAt: user.updatedAt.toDateTime(),
    );
  }

  @override
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    final builder = _db.updateUserProfile(id: id);
    if (data.containsKey('name')) builder.name(data['name']);
    if (data.containsKey('photoUrl')) builder.photoUrl(data['photoUrl']);
    if (data.containsKey('phone')) builder.phone(data['phone']);
    if (data.containsKey('whatsapp')) builder.whatsapp(data['whatsapp']);
    await builder.execute();
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
      membershipTier: prof.membershipTier?.value.name.toLowerCase() ?? 'basic',
      serviceSlots: prof.serviceSlots,
      practicePins: prof.practicePins,
      visibilityExpiresAt: prof.visibilityExpiresAt?.toDateTime(),
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
      visibilityExpiresAt: inst.visibilityExpiresAt?.toDateTime(),
    );
  }

  @override
  Future<VisitorProfile?> getVisitorProfile(String id) async {
    final result = await _db.getUser(uid: id).execute();
    final visitor = result.data.user?.visitorProfile_on_user;
    if (visitor == null) return null;
    return VisitorProfile(id: id, interests: (visitor.interests ?? []).whereType<String>().toList());
  }

  // ─── 2. Taxonomy & Location ──────────────────────────────────────────────

  @override
  Stream<List<Map<String, dynamic>>> listSectors() {
    return _db.listSectors().ref().subscribe().map((snap) => 
      snap.data.sectors.map((s) => {
        'id': s.id,
        'nameEn': s.nameEn,
        'nameAr': s.nameAr,
        'iconName': s.iconName,
        'colorHex': s.colorHex,
        'description': s.description,
        'template': s.template != null ? {
           'accentColor': s.template!.accentColor,
           'iconName': s.template!.iconName,
           'visibleFields': s.template!.visibleFields,
        } : null,
      }).toList()
    );
  }

  @override
  Stream<List<Map<String, dynamic>>> listCategories({String? sectorId}) {
    var builder = _db.listCategories();
    if (sectorId != null) builder = builder.sectorId(sectorId);
    
    return builder.ref().subscribe().map((snap) =>
      snap.data.categories.map((c) => {
        'id': c.id,
        'nameEn': c.nameEn,
        'nameAr': c.nameAr,
        'targetRole': c.targetRole.value.name.toLowerCase(),
      }).toList()
    );
  }

  @override
  Stream<List<Map<String, dynamic>>> listCountries() {
    return _db.listCountries().ref().subscribe().map((snap) =>
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
    return _db.listRegions(countryId: countryId).ref().subscribe().map((snap) =>
      snap.data.regions.map((r) => {
        'id': r.id.toString(),
        'nameEn': r.nameEn,
        'nameAr': r.nameAr,
        'regionCode': r.regionCode,
      }).toList()
    );
  }

  @override
  Stream<List<Map<String, dynamic>>> listCities(String regionId) {
    return _db.listCities(regionId: regionId).ref().subscribe().map((snap) =>
      snap.data.cities.map((c) => {
        'id': c.id.toString(),
        'nameEn': c.nameEn,
        'nameAr': c.nameAr,
        'lat': c.lat,
        'lng': c.lng,
      }).toList()
    );
  }

  @override
  Stream<List<Map<String, dynamic>>> listLocationNodes(String userId) {
    return _db.listLocationNodes(userId: userId).ref().subscribe().map((snap) => 
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
    final builder = _db.upsertCountry(
      id: data['id'],
      nameEn: data['nameEn'],
      nameAr: data['nameAr'],
    );
    if (data['isoCode'] != null) builder.isoCode(data['isoCode']);
    if (data['currency'] != null) builder.currency(data['currency']);
    if (data['flagEmoji'] != null) builder.flagEmoji(data['flagEmoji']);
    await builder.execute();
  }

  @override
  Future<void> upsertRegion(Map<String, dynamic> data) async {
    final builder = _db.upsertRegion(
      id: data['id'],
      countryId: data['countryId'],
      nameEn: data['nameEn'],
      nameAr: data['nameAr'],
    );
    if (data['regionCode'] != null) builder.regionCode(data['regionCode']);
    await builder.execute();
  }

  @override
  Future<void> upsertCity(Map<String, dynamic> data) async {
    final builder = _db.upsertCity(
      id: data['id'],
      regionId: data['regionId'],
      nameEn: data['nameEn'],
      nameAr: data['nameAr'],
    );
    if (data['lat'] != null) builder.lat(data['lat']);
    if (data['lng'] != null) builder.lng(data['lng']);
    await builder.execute();
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
    final builder = _db.updateSectorBranding(id: id);
    if (data['iconName'] != null) builder.iconName(data['iconName']);
    if (data['colorHex'] != null) builder.colorHex(data['colorHex']);
    if (data['nameEn'] != null) builder.nameEn(data['nameEn']);
    if (data['nameAr'] != null) builder.nameAr(data['nameAr']);
    await builder.execute();
  }

  @override
  Future<void> upsertServiceTag(Map<String, dynamic> data) async {
    await _db.upsertServiceTag(id: data['id'], nameEn: data['nameEn'], nameAr: data['nameAr']).execute();
  }

  @override
  Future<void> upsertPriceTag(Map<String, dynamic> data) async {
    final builder = _db.upsertPriceTag(id: data['id'], nameEn: data['nameEn'], nameAr: data['nameAr']);
    if (data['category'] != null) builder.category(data['category']);
    await builder.execute();
  }

  @override
  Future<void> upsertPinCategory(Map<String, dynamic> data) async {
    final builder = _db.upsertPinCategory(id: data['id'], nameEn: data['nameEn'], nameAr: data['nameAr']);
    if (data['iconBase'] != null) builder.iconBase(data['iconBase']);
    await builder.execute();
  }

  @override
  Future<void> upsertPresenceTag(Map<String, dynamic> data) async {
    await _db.upsertPresenceTag(id: data['id'], nameEn: data['nameEn'], nameAr: data['nameAr']).execute();
  }

  // ─── 3. Core Business Logic ──────────────────────────────────────────────

  @override
  Stream<List<Map<String, dynamic>>> listActiveServices({String? categoryId, String? sectorId}) {
    var builder = _db.listActiveServices();
    if (categoryId != null) builder = builder.categoryId(categoryId);
    if (sectorId != null) builder = builder.sectorId(sectorId);

    return builder.ref().subscribe().map((snap) =>
      snap.data.services.map((s) => {
        'id': s.id.toString(),
        'titleEn': s.titleEn,
        'price': s.price,
        'imageUrl': s.imageUrl,
        'deliveryMode': s.deliveryMode?.value.name,
        'providerId': s.provider.id,
        'template': s.sector.template != null ? {
           'accentColor': s.sector.template!.accentColor,
           'iconName': s.sector.template!.iconName,
           'visibleFields': s.sector.template!.visibleFields,
        } : null,
      }).toList()
    );
  }

  @override
  Stream<List<Map<String, dynamic>>> listProfessionalServices(String professionalId) {
    return Stream.value([]);
  }

  @override
  Future<void> toggleServiceSlot(String serviceId, bool allocate) async {
    await _db.updateService(id: serviceId).isAllocated(allocate).execute();
  }

  @override
  Stream<List<Map<String, dynamic>>> listCommunityRequests({String? sectorId, bool newestFirst = true, String? userId}) {
    var builder = _db.listServiceRequests();
    if (sectorId != null) builder = builder.sectorId(sectorId);

    return builder.ref().subscribe().map((snap) =>
      snap.data.serviceRequests.map((cr) => {
        'id': cr.id.toString(),
        'descriptionEn': cr.descriptionEn,
        'descriptionAr': cr.descriptionAr,
        'status': cr.status.value.name,
        'userName': cr.user.name,
        'createdAt': cr.createdAt.toDateTime(),
        'sectorId': sectorId,
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
    return _db.getWalletTransactions(userId: userId).ref().subscribe().map((snap) =>
      snap.data.walletTransactions.map((t) => {
        'id': t.id.toString(),
        'type': t.type.value.name,
        'amount': t.amount,
        'description': t.description,
        'createdAt': t.createdAt.toDateTime(),
      }).toList()
    );
  }

  @override
  Future<Map<String, dynamic>> spendTokens({required String userId, required String itemId, required int cost, required String role}) async {
    await _db.spendTokens(
      userId: userId,
      cost: cost,
      ledgerAmount: -cost,
      description: "Purchase: $itemId",
    ).type(sdk.TransactionType.PURCHASE).execute();
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
        .ref().subscribe()
        .map((snap) => snap.data.interactions.map((i) => i.targetId).toList());
  }

  @override
  Stream<List<String>> listContactedIds(String userId) {
    return _db.listInteractions(actorId: userId, type: sdk.InteractionType.CONTACT)
        .ref().subscribe()
        .map((snap) => snap.data.interactions.map((i) => i.targetId).toList());
  }

  @override
  Future<void> upsertProfessionalProfile({required String id, String? fullNameAr, String? specialty, String? specialtyAr, String? bioEn, String? bioAr}) async {
    final builder = _db.upsertProfessionalProfile(id: id);
    if (fullNameAr != null) builder.fullNameAr(fullNameAr);
    if (specialty != null) builder.specialty(specialty);
    if (specialtyAr != null) builder.specialtyAr(specialtyAr);
    if (bioEn != null) builder.bioEn(bioEn);
    if (bioAr != null) builder.bioAr(bioAr);
    await builder.execute();
  }

  @override
  Future<void> upsertInstitutionProfile({required String id, String? nameAr, String? bioEn, String? bioAr, String? registrationNumber}) async {
    final builder = _db.upsertInstitutionProfile(id: id);
    if (nameAr != null) builder.nameAr(nameAr);
    if (bioEn != null) builder.bioEn(bioEn);
    if (bioAr != null) builder.bioAr(bioAr);
    if (registrationNumber != null) builder.registrationNumber(registrationNumber);
    await builder.execute();
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
    return _db.getActiveResourceOrder(userId: userId).ref().subscribe().map((snap) {
      if (snap.data.resourceOrders.isEmpty) return null;
      final o = snap.data.resourceOrders.first;
      return {
        'id': o.id.toString(),
        'pinsCount': o.pinsCount,
        'slotsCount': o.slotsCount,
        'broadcastsCount': o.broadcastsCount,
        'totalCost': o.totalCost,
        'status': o.status.value.name,
      };
    });
  }

  @override
  Future<void> generateRechargeCard({required String code, required int value, int pins = 0, int slots = 0}) async {
    await _db.createRechargeCard(code: code, value: value, pins: pins, slots: slots).execute();
  }

  @override
  Stream<List<Map<String, dynamic>>> listRechargeCards() {
    return _db.listRechargeCards().ref().subscribe().map((snap) =>
      snap.data.rechargeCards.map((c) => {
        'id': c.id,
        'tokenValue': c.tokenValue,
        'status': c.status,
        'redeemedAt': c.redeemedAt?.toDateTime(),
        'redeemedBy': c.redeemedBy?.email,
      }).toList()
    );
  }

  // ─── 5. Admin Operations ─────────────────────────────────────────────────

  @override
  Stream<List<Map<String, dynamic>>> searchUsersAdmin({String? query, String? role, bool? hasProfile, bool? isActive}) {
    var builder = _db.searchUsersAdmin();
    if (query != null) builder = builder.query(query);
    if (role != null) {
       final gqlRole = sdk.UserRole.values.byName(role.toUpperCase());
       builder = builder.role(gqlRole);
    }
    if (hasProfile != null) builder = builder.hasProfile(hasProfile);
    if (isActive != null) builder = builder.isActive(isActive);
    
    return builder.ref().subscribe().map((snap) =>
      snap.data.users.map((u) => {
        'id': u.id,
        'email': u.email,
        'name': u.name,
        'role': u.role.value.name,
        'isActive': u.isActive,
        'hasProfile': u.hasProfile,
        'phone': u.phone,
        'whatsapp': u.whatsapp,
        'createdAt': u.createdAt.toDateTime(),
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
      'role': u.role.value.name,
      'isActive': u.isActive,
      'hasProfile': u.hasProfile,
      'photoUrl': u.photoUrl,
      'phone': u.phone,
      'whatsapp': u.whatsapp,
      'walletBalance': u.walletBalance,
      'adminNotes': u.adminNotes,
      'createdAt': u.createdAt.toDateTime(),
      'updatedAt': u.updatedAt.toDateTime(),
      'transactions': u.walletTransactions_on_user.map((t) => {
        'id': t.id.toString(),
        'amount': t.amount,
        'type': t.type.value.name,
        'description': t.description,
        'createdAt': t.createdAt.toDateTime(),
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
        'membershipTier': p.membershipTier?.value.name,
        'visibilityExpiresAt': p.visibilityExpiresAt?.toDateTime(),
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
        'visibilityExpiresAt': i.visibilityExpiresAt?.toDateTime(),
      };
    }

    return data;
  }

  @override
  Future<void> adminUpdateUser(String id, Map<String, dynamic> data) async {
    final builder = _db.updateUserAdmin(id: id);
    if (data.containsKey('name')) builder.name(data['name']);
    if (data.containsKey('isActive')) builder.isActive(data['isActive']);
    if (data.containsKey('phone')) builder.phone(data['phone']);
    if (data.containsKey('whatsapp')) builder.whatsapp(data['whatsapp']);
    if (data.containsKey('adminNotes')) builder.notes(data['adminNotes']);
    if (data.containsKey('walletBalance')) builder.balance(data['walletBalance']);
    
    if (data.containsKey('role')) {
       final roleStr = data['role'].toString().toUpperCase();
       builder.role(sdk.UserRole.values.byName(roleStr));
    }
    
    await builder.execute();
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
     var builder = _db.listSupportTickets();
     if (status != null) {
        sdk.SupportTicketStatus? gqlStatus;
        if (status.toUpperCase() == 'OPEN') gqlStatus = sdk.SupportTicketStatus.OPEN;
        if (status.toUpperCase() == 'CLOSED') gqlStatus = sdk.SupportTicketStatus.CLOSED;
        if (status.toUpperCase() == 'PENDING') gqlStatus = sdk.SupportTicketStatus.PENDING;
        if (gqlStatus != null) builder = builder.status(gqlStatus);
     }
     return builder.ref().subscribe().map((snap) =>
        snap.data.supportTickets.map((st) => {
          'id': st.id.toString(),
          'subject': st.subject,
          'message': st.message,
          'status': st.status.value.name,
          'userEmail': st.user.email,
          'createdAt': st.createdAt.toDateTime(),
        }).toList()
     );
  }

  @override
  Stream<List<Map<String, dynamic>>> listPendingOrders() {
    return _db.listPendingOrders().ref().subscribe().map((snap) =>
      snap.data.resourceOrders.map((o) => {
        'id': o.id.toString(),
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

  @override
  Stream<List<Map<String, dynamic>>> listServiceModerationQueue({String status = 'PENDING'}) {
    final sdkStatus = sdk.ModerationStatus.values.byName(status.toUpperCase());
    return _db.listServiceModerationQueue().status(sdkStatus).ref().subscribe().map((snap) =>
      snap.data.services.map((s) => {
        'id': s.id.toString(),
        'titleEn': s.titleEn,
        'titleAr': s.titleAr,
        'price': s.price,
        'imageUrl': s.imageUrl,
        'deliveryMode': s.deliveryMode?.value.name,
        'moderationStatus': s.moderationStatus.value.name,
        'flagReason': s.flagReason,
        'categoryName': s.category.nameEn,
        'sectorName': s.sector.nameEn,
        'providerName': s.provider.name,
        'providerEmail': s.provider.email,
        'providerPhoto': s.provider.photoUrl,
        'template': s.sector.template != null ? {
           'accentColor': s.sector.template!.accentColor,
           'iconName': s.sector.template!.iconName,
           'visibleFields': s.sector.template!.visibleFields,
        } : null,
      }).toList()
    );
  }

  @override
  Stream<List<Map<String, dynamic>>> listRequestModerationQueue({String status = 'PENDING'}) {
    final sdkStatus = sdk.ModerationStatus.values.byName(status.toUpperCase());
    return _db.listRequestModerationQueue().status(sdkStatus).ref().subscribe().map((snap) =>
      snap.data.serviceRequests.map((r) => {
        'id': r.id.toString(),
        'descriptionEn': r.descriptionEn,
        'descriptionAr': r.descriptionAr,
        'urgency': r.urgency?.value.name,
        'preferredMode': r.preferredMode?.value.name,
        'status': r.status.value.name,
        'moderationStatus': r.moderationStatus.value.name,
        'flagReason': r.flagReason,
        'createdAt': r.createdAt.toDateTime(),
        'sectorName': r.sector.nameEn,
        'userName': r.user.name,
        'userEmail': r.user.email,
        'template': r.sector.template != null ? {
           'accentColor': r.sector.template!.accentColor,
           'iconName': r.sector.template!.iconName,
           'visibleFields': r.sector.template!.visibleFields,
        } : null,
      }).toList()
    );
  }

  @override
  Future<void> moderateService(String id, String status, {String? reason}) async {
    final sdkStatus = sdk.ModerationStatus.values.byName(status.toUpperCase());
    final builder = _db.moderateService(id: id, status: sdkStatus);
    if (reason != null) builder.reason(reason);
    await builder.execute();
  }

  @override
  Future<void> moderateRequest(String id, String status, {String? reason}) async {
    final sdkStatus = sdk.ModerationStatus.values.byName(status.toUpperCase());
    final builder = _db.moderateRequest(id: id, status: sdkStatus);
    if (reason != null) builder.reason(reason);
    await builder.execute();
  }

  @override
  Future<void> createLocalizedBroadcast({required String title, required String message, String? country, String? region, String? city}) async {
    final builder = _db.createLocalizedBroadcast(
      title: title,
      message: message,
    );
    if (country != null) builder.country(country);
    if (region != null) builder.region(region);
    if (city != null) builder.city(city);
    await builder.execute();
  }

  @override
  Stream<List<Map<String, dynamic>>> listTemplates() {
    return _db.listTemplates().ref().subscribe().map((snap) =>
      snap.data.templates.map((t) => {
        'id': t.id,
        'accentColor': t.accentColor,
        'iconName': t.iconName,
        'visibleFields': t.visibleFields,
        'configJson': t.configJson,
      }).toList()
    );
  }

  @override
  Future<void> upsertTemplate(String id, List<String> visibleFields, {String? configJson, String? accentColor, String? iconName}) async {
    final builder = _db.upsertTemplate(id: id);
    builder.visibleFields(visibleFields);
    if (configJson != null) builder.configJson(configJson);
    if (accentColor != null) builder.accentColor(accentColor);
    if (iconName != null) builder.iconName(iconName);
    await builder.execute();
  }

  // ─── 6. Discovery & Helpers ──────────────────────────────────────────────

  @override
  Stream<Map<String, dynamic>> getSystemStats() {
    return firestore.FirebaseFirestore.instance.collection('metadata').doc('system_stats').snapshots().map((snap) => (snap.data() as Map<String, dynamic>?) ?? {});
  }

  @override
  Future<void> updateCategory(String id, Map<String, dynamic> data) async {
     // TODO: Implement
  }
}
