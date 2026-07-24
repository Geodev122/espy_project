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
    } catch (e) {
      debugPrint("DataConnect getUser failed: $e");
    }

    try {
      final doc = await _firestore.collection('users').doc(id).get();
      if (doc.exists && doc.data() != null) {
        return models.UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint("Firestore Fallback getUser failed: $e");
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
    } catch (e) {
      debugPrint("Shadow-write createUser failed: $e");
    }
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
    } catch (e) {
      debugPrint("Shadow-write upsertUser failed: $e");
    }
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
    } catch (e) {
      debugPrint("Shadow-write updateUser failed: $e");
    }
  }

  @override
  Future<void> updateLastActive(String id) async {
    await _firestore.collection('users').doc(id).update({
      'lastActiveAt': firestore.FieldValue.serverTimestamp(),
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    });
    try {
      await _db.updateUserLastActive(id: id).execute();
    } catch (e) {
      debugPrint("Shadow-write updateLastActive failed: $e");
    }
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
    final data = doc.data() as Map<String, dynamic>?;
    return (doc.exists && data != null) ? ProfessionalProfile.fromMap(data) : null;
  }

  @override
  Future<InstitutionProfile?> getInstitutionProfile(String id) async {
    try {
      final result = await _db.getUser(uid: id).execute();
      final instData = result.data.user?.institutionProfile_on_user;
      if (instData != null) {
        return InstitutionProfile(
          id: id,
          nameAr: instData.nameAr,
          registrationNumber: instData.registrationNumber,
          isApproved: instData.isApproved,
          isProfileValidated: instData.isProfileValidated,
          verificationDocUrl: instData.verificationDocUrl,
          serviceSlots: 0,
          visibilityExpiresAt: instData.visibilityExpiresAt?.toDateTime(),
        );
      }
    } catch (_) {}

    final doc = await _firestore.collection('directory_institutions').doc(id).get();
    final data = doc.data() as Map<String, dynamic>?;
    return (doc.exists && data != null) ? InstitutionProfile.fromMap(data) : null;
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
    final data = doc.data() as Map<String, dynamic>?;
    return (doc.exists && data != null) ? VisitorProfile.fromMap(data) : null;
  }

  // ─── 2. Taxonomy & Location ──────────────────────────────────────────────

  @override
  Stream<List<SectorModel>> listSectors() {
    final fdcStream = _db.listSectors().ref().subscribe().map((snap) => 
      snap.data.sectors.map((s) => SectorModel(
        id: s.id,
        nameEn: s.nameEn,
        nameAr: s.nameAr,
        description: s.description,
        iconName: s.iconName,
        colorHex: s.colorHex,
        isActive: true,
      )).toList()
    ).onErrorReturnWith((e, s) => <SectorModel>[]);

    final fsStream = _firestore.collection('directory_sectors').snapshots().map((snap) =>
      snap.docs.map((doc) => SectorModel.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>})).toList()
    );

    return Rx.combineLatest2<List<SectorModel>, List<SectorModel>, List<SectorModel>>(
      fdcStream, fsStream, (dc, fs) => dc.isNotEmpty ? dc : fs
    ).distinct();
  }

  @override
  Stream<List<CategoryModel>> listCategories({String? sectorId}) {
    var builder = _db.listCategories();
    if (sectorId != null) builder = builder.sectorId(sectorId);
    
    final fdcStream = builder.ref().subscribe().map((snap) =>
      snap.data.categories.map((c) => CategoryModel(
        id: c.id,
        sectorId: c.sector.id,
        nameEn: c.nameEn,
        nameAr: c.nameAr,
        targetRole: UserRole.parse(c.targetRole.stringValue).name,
      )).toList()
    ).onErrorReturnWith((e, s) => <CategoryModel>[]);

    firestore.Query fsQuery = _firestore.collection('directory_categories');
    if (sectorId != null) fsQuery = fsQuery.where('sectorId', isEqualTo: sectorId);
    final fsStream = fsQuery.snapshots().map((snap) => snap.docs.map((doc) => CategoryModel.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>})).toList());

    return Rx.combineLatest2<List<CategoryModel>, List<CategoryModel>, List<CategoryModel>>(
      fdcStream, fsStream, (dc, fs) => dc.isNotEmpty ? dc : fs
    ).distinct();
  }

  @override
  Stream<List<CountryModel>> listCountries() {
    final fdcStream = _db.listCountries().ref().subscribe().map((snap) =>
      snap.data.countries.map((c) => CountryModel(
        id: c.id,
        nameEn: c.nameEn,
        nameAr: c.nameAr,
        flagEmoji: c.flagEmoji,
        isoCode: c.isoCode,
        currency: c.currency,
      )).toList()
    ).onErrorReturnWith((e, s) => <CountryModel>[]);

    final fsStream = _firestore.collection('directory_countries').snapshots().map((snap) =>
      snap.docs.map((doc) => CountryModel.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>})).toList()
    );

    return Rx.combineLatest2<List<CountryModel>, List<CountryModel>, List<CountryModel>>(
      fdcStream, fsStream, (dc, fs) => dc.isNotEmpty ? dc : fs
    ).distinct();
  }

  @override
  Stream<List<RegionModel>> listRegions(String countryId) {
    final fdcStream = _db.listRegions(countryId: countryId).ref().subscribe().map((snap) =>
      snap.data.regions.map((r) => RegionModel(
        id: r.id.toString(),
        countryId: r.country.id,
        nameEn: r.nameEn,
        nameAr: r.nameAr,
        regionCode: r.regionCode,
      )).toList()
    ).onErrorReturnWith((e, s) => <RegionModel>[]);

    final fsStream = _firestore.collection('directory_regions').where('countryId', isEqualTo: countryId).snapshots().map((snap) =>
      snap.docs.map((doc) => RegionModel.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>})).toList()
    );

    return Rx.combineLatest2<List<RegionModel>, List<RegionModel>, List<RegionModel>>(
      fdcStream, fsStream, (dc, fs) => dc.isNotEmpty ? dc : fs
    ).distinct();
  }

  @override
  Stream<List<CityModel>> listCities(String regionId) {
    final fdcStream = _db.listCities(regionId: regionId).ref().subscribe().map((snap) =>
      snap.data.cities.map((c) => CityModel(
        id: c.id.toString(),
        regionId: c.region.id,
        nameEn: c.nameEn,
        nameAr: c.nameAr,
        lat: c.lat,
        lng: c.lng,
      )).toList()
    ).onErrorReturnWith((e, s) => <CityModel>[]);

    final fsStream = _firestore.collection('directory_cities').where('regionId', isEqualTo: regionId).snapshots().map((snap) =>
      snap.docs.map((doc) => CityModel.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>})).toList()
    );

    return Rx.combineLatest2<List<CityModel>, List<CityModel>, List<CityModel>>(
      fdcStream, fsStream, (dc, fs) => dc.isNotEmpty ? dc : fs
    ).distinct();
  }

  @override
  Stream<List<Map<String, dynamic>>> listLocationNodes(String userId) {
    return _db.listLocationNodes(userId: userId).ref().subscribe().map((snap) => 
      snap.data.locationNodes.map((ln) => <String, dynamic>{
        'id': ln.id,
        'label': ln.label,
        'lat': ln.lat,
        'lng': ln.lng,
        'cityNameEn': ln.city.nameEn,
        'isMain': ln.isMain,
      }).toList()
    ).onErrorReturnWith((e, s) => <Map<String, dynamic>>[]);
  }

  @override
  Future<void> upsertCountry(CountryModel country) async {
    await _firestore.collection('directory_countries').doc(country.id).set(country.toMap(), firestore.SetOptions(merge: true));
    try {
      final builder = _db.upsertCountry(id: country.id, nameEn: country.nameEn, nameAr: country.nameAr ?? country.nameEn);
      if (country.isoCode != null) builder.isoCode(country.isoCode!);
      if (country.currency != null) builder.currency(country.currency!);
      if (country.flagEmoji != null) builder.flagEmoji(country.flagEmoji!);
      await builder.execute();
    } catch (_) {}
  }

  @override
  Future<void> upsertRegion(RegionModel region) async {
    await _firestore.collection('directory_regions').doc(region.id).set(region.toMap(), firestore.SetOptions(merge: true));
    try {
      final builder = _db.upsertRegion(id: region.id, countryId: region.countryId, nameEn: region.nameEn, nameAr: region.nameAr ?? region.nameEn);
      if (region.regionCode != null) builder.regionCode(region.regionCode!);
      await builder.execute();
    } catch (_) {}
  }

  @override
  Future<void> upsertCity(CityModel city) async {
    await _firestore.collection('directory_cities').doc(city.id).set(city.toMap(), firestore.SetOptions(merge: true));
    try {
      final builder = _db.upsertCity(id: city.id, regionId: city.regionId, nameEn: city.nameEn, nameAr: city.nameAr ?? city.nameEn);
      if (city.lat != null) builder.lat(city.lat!);
      if (city.lng != null) builder.lng(city.lng!);
      await builder.execute();
    } catch (_) {}
  }

  @override
  Future<void> createLocationNode(LocationNodeModel node) async {
    await _db.createLocationNode(
      cityId: node.cityId,
      label: node.label ?? 'Main',
      lat: node.lat,
      lng: node.lng,
      isMain: node.isMain,
    ).execute();
  }

  @override
  Future<void> deleteGeographyEntity(String id, String type) async {
    await _db.deleteGeographyEntity(id: id).execute();
  }

  @override
  Future<void> updateSectorBranding(String id, SectorModel sector) async {
    final builder = _db.updateSectorBranding(id: id);
    if (sector.iconName != null) builder.iconName(sector.iconName!);
    if (sector.colorHex != null) builder.colorHex(sector.colorHex!);
    builder.nameEn(sector.nameEn);
    if (sector.nameAr != null) builder.nameAr(sector.nameAr!);
    await builder.execute();
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
     await _firestore.collection('directory_categories').doc(category.id).update(category.toMap());
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
  Stream<List<ServiceModel>> listActiveServices({String? categoryId, String? sectorId}) {
    var builder = _db.listActiveServices();
    if (categoryId != null) builder = builder.categoryId(categoryId);
    if (sectorId != null) builder = builder.sectorId(sectorId);

    return builder.ref().subscribe().map((snap) =>
      snap.data.services.map((s) => ServiceModel(
        id: s.id.toString(),
        providerId: s.provider.id,
        categoryId: s.category.id,
        sectorId: s.sector.id,
        titleEn: s.titleEn,
        titleAr: s.titleAr,
        price: s.price ?? 0,
        imageUrl: s.imageUrl,
        deliveryMode: DeliveryMode.parse(s.deliveryMode?.stringValue).name,
        moderationStatus: ModerationStatus.parse(s.moderationStatus.stringValue).name,
        flagReason: s.flagReason,
        createdAt: DateTime.now(), // Fallback
        updatedAt: DateTime.now(),
      )).toList()
    ).onErrorReturnWith((e, s) => <ServiceModel>[]);
  }

  @override
  Stream<List<ServiceModel>> listProfessionalServices(String professionalId) {
    return _firestore.collection('directory_services')
        .where('providerId', isEqualTo: professionalId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => ServiceModel.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>})).toList());
  }

  @override
  Future<void> toggleServiceSlot(String serviceId, bool allocate) async {
    await _db.updateService(id: serviceId).isAllocated(allocate).execute();
  }

  @override
  Stream<List<ServiceRequestModel>> listCommunityRequests({String? sectorId, bool newestFirst = true, String? userId}) {
    var builder = _db.listServiceRequests();
    if (sectorId != null) builder = builder.sectorId(sectorId);

    return builder.ref().subscribe().map((snap) =>
      snap.data.serviceRequests.map((cr) => ServiceRequestModel(
        id: cr.id.toString(),
        userId: cr.user.id,
        sectorId: cr.sector.id,
        descriptionEn: cr.descriptionEn,
        descriptionAr: cr.descriptionAr,
        urgency: UrgencyLevel.parse(cr.urgency?.stringValue).name,
        preferredMode: DeliveryMode.parse(cr.preferredMode?.stringValue).name,
        status: CommunityRequestStatus.parse(cr.status.stringValue).name,
        moderationStatus: 'APPROVED',
        createdAt: cr.createdAt.toDateTime(),
        userName: cr.user.name,
      )).toList()
    ).onErrorReturnWith((e, s) => <ServiceRequestModel>[]);
  }

  @override
  Future<void> createCommunityRequest(ServiceRequestModel request) async {
    // PostServiceRequest
  }

  @override
  Future<Map<String, List<Map<String, dynamic>>>> listMetadataTags() async {
    try {
      final result = await _db.listMetadataTags().execute();
      return {
        'serviceTags': result.data.serviceTags.map((t) => <String, dynamic>{'id': t.id, 'nameEn': t.nameEn, 'nameAr': t.nameAr}).toList(),
        'priceTags': result.data.priceTags.map((t) => <String, dynamic>{'id': t.id, 'nameEn': t.nameEn, 'nameAr': t.nameAr, 'category': t.category}).toList(),
        'pinCategories': result.data.pinCategories.map((t) => <String, dynamic>{'id': t.id, 'nameEn': t.nameEn, 'nameAr': t.nameAr, 'iconBase': t.iconBase}).toList(),
        'presenceTags': result.data.presenceTags.map((t) => <String, dynamic>{'id': t.id, 'nameEn': t.nameEn, 'nameAr': t.nameAr}).toList(),
      };
    } catch (e) {
      debugPrint("DataConnect listMetadataTags failed: $e");
    }

    final s = await _firestore.collection('directory_service_tags').get();
    final p = await _firestore.collection('directory_price_tags').get();
    final c = await _firestore.collection('directory_pin_categories').get();
    final pr = await _firestore.collection('directory_presence_tags').get();
    return {
      'serviceTags': s.docs.map((d) => <String, dynamic>{'id': d.id, ...(d.data() as Map<String, dynamic>? ?? {})}).toList(),
      'priceTags': p.docs.map((d) => <String, dynamic>{'id': d.id, ...(d.data() as Map<String, dynamic>? ?? {})}).toList(),
      'pinCategories': c.docs.map((d) => <String, dynamic>{'id': d.id, ...(d.data() as Map<String, dynamic>? ?? {})}).toList(),
      'presenceTags': pr.docs.map((d) => <String, dynamic>{'id': d.id, ...(d.data() as Map<String, dynamic>? ?? {})}).toList(),
    };
  }

  // ─── 4. Ledger & Resource Orders ─────────────────────────────────────────

  @override
  Stream<List<WalletTransactionModel>> listWalletTransactions(String userId) {
    return _db.getWalletTransactions(userId: userId).ref().subscribe().map((snap) =>
      snap.data.walletTransactions.map((t) => WalletTransactionModel(
        id: t.id.toString(),
        userId: userId,
        amount: t.amount,
        type: TransactionType.parse(t.type.stringValue).name,
        description: t.description,
        createdAt: t.createdAt.toDateTime(),
      )).toList()
    ).onErrorReturnWith((e, s) => <WalletTransactionModel>[]);
  }

  @override
  Future<Map<String, dynamic>> spendTokens({required String userId, required String itemId, required int cost, required UserRole role}) async {
    await _db.spendTokens(
      userId: userId,
      cost: cost,
      ledgerAmount: -cost,
      description: "Purchase: $itemId",
    ).type(sdk.TransactionType.PURCHASE).execute();
    return {'success': true};
  }

  @override
  Future<void> recordInteraction({required String userId, required String targetId, required InteractionType type}) async {
    await _db.recordInteraction(
      targetId: targetId,
      type: sdk.InteractionType.values.byName(type.toSql()),
    ).execute();
  }

  @override
  Future<void> toggleFavorite(String userId, String targetId, bool isFavorite) async {
    if (isFavorite) {
      await recordInteraction(userId: userId, targetId: targetId, type: InteractionType.favorite);
    }
  }

  @override
  Stream<List<String>> listFavoriteIds(String userId) {
    return _db.listInteractions(actorId: userId, type: sdk.InteractionType.FAVORITE)
        .ref().subscribe()
        .map((snap) => snap.data.interactions.map((i) => i.targetId).toList())
        .onErrorReturnWith((e, s) => <String>[]);
  }

  @override
  Stream<List<String>> listContactedIds(String userId) {
    return _db.listInteractions(actorId: userId, type: sdk.InteractionType.CONTACT)
        .ref().subscribe()
        .map((snap) => snap.data.interactions.map((i) => i.targetId).toList())
        .onErrorReturnWith((e, s) => <String>[]);
  }

  @override
  Future<void> upsertProfessionalProfile(ProfessionalProfile profile) async {
    final builder = _db.upsertProfessionalProfile(id: profile.id);
    if (profile.fullNameAr != null) builder.fullNameAr(profile.fullNameAr!);
    if (profile.specialty != null) builder.specialty(profile.specialty!);
    if (profile.specialtyAr != null) builder.specialtyAr(profile.specialtyAr!);
    if (profile.bioEn != null) builder.bioEn(profile.bioEn!);
    if (profile.bioAr != null) builder.bioAr(profile.bioAr!);
    await builder.execute();
  }

  @override
  Future<void> upsertInstitutionProfile(InstitutionProfile profile) async {
    final builder = _db.upsertInstitutionProfile(id: profile.id);
    if (profile.nameAr != null) builder.nameAr(profile.nameAr!);
    if (profile.bioEn != null) builder.bioEn(profile.bioEn!);
    if (profile.bioAr != null) builder.bioAr(profile.bioAr!);
    if (profile.registrationNumber != null) builder.registrationNumber(profile.registrationNumber!);
    await builder.execute();
  }

  @override
  Future<void> createResourceOrder(ResourceOrderModel order) async {
    await _db.createResourceOrder(pins: order.pinsCount, slots: order.slotsCount, broadcasts: order.broadcastsCount, total: order.totalCost).execute();
  }

  @override
  Future<void> updateResourceOrder(ResourceOrderModel order) async {
    await _db.updateResourceOrder(id: order.id, pins: order.pinsCount, slots: order.slotsCount, broadcasts: order.broadcastsCount, total: order.totalCost).execute();
  }

  @override
  Stream<ResourceOrderModel?> getActiveResourceOrder(String userId) {
    return _db.getActiveResourceOrder(userId: userId).ref().subscribe().map((snap) {
      if (snap.data.resourceOrders.isEmpty) return null;
      final o = snap.data.resourceOrders.first;
      return ResourceOrderModel(
        id: o.id.toString(),
        userId: userId,
        pinsCount: o.pinsCount,
        slotsCount: o.slotsCount,
        broadcastsCount: o.broadcastsCount,
        totalCost: o.totalCost,
        status: OrderStatus.parse(o.status.stringValue).name.toUpperCase(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }).onErrorReturnWith((e, s) => null);
  }

  @override
  Future<void> generateRechargeCard({required String code, required int value, int pins = 0, int slots = 0}) async {
    await _db.createRechargeCard(code: code, value: value, pins: pins, slots: slots).execute();
  }

  @override
  Stream<List<Map<String, dynamic>>> listRechargeCards() {
    return _db.listRechargeCards().ref().subscribe().map((snap) =>
      snap.data.rechargeCards.map((c) => <String, dynamic>{
        'id': c.id,
        'tokenValue': c.tokenValue,
        'status': c.status,
        'redeemedAt': c.redeemedAt?.toDateTime(),
        'redeemedBy': c.redeemedBy?.email,
      }).toList()
    ).onErrorReturnWith((e, s) => <Map<String, dynamic>>[]);
  }

  // ─── 5. Admin Operations ─────────────────────────────────────────────────

  @override
  Stream<List<models.UserModel>> searchUsersAdmin({String? query, UserRole? role, bool? hasProfile, bool? isActive}) {
    var dcBuilder = _db.searchUsersAdmin();
    if (query != null) dcBuilder = dcBuilder.query(query);
    if (role != null) {
       dcBuilder = dcBuilder.role(sdk.UserRole.values.byName(role.toSql()));
    }
    if (hasProfile != null) dcBuilder = dcBuilder.hasProfile(hasProfile);
    if (isActive != null) dcBuilder = dcBuilder.isActive(isActive);
    
    final fdcStream = dcBuilder.ref().subscribe().map((snap) =>
      snap.data.users.map((u) => models.UserModel(
        id: u.id,
        email: u.email,
        name: u.name ?? '',
        role: UserRole.parse(u.role.stringValue),
        isActive: u.isActive,
        hasProfile: u.hasProfile,
        phone: u.phone,
        whatsapp: u.whatsapp,
        createdAt: u.createdAt.toDateTime(),
        updatedAt: u.createdAt.toDateTime(),
      )).toList()
    ).onErrorReturnWith((e, s) => <models.UserModel>[]);

    firestore.Query fsQuery = _firestore.collection('users');
    if (role != null) fsQuery = fsQuery.where('role', isEqualTo: role.name);
    if (hasProfile != null) fsQuery = fsQuery.where('hasProfile', isEqualTo: hasProfile);
    if (isActive != null) fsQuery = fsQuery.where('isActive', isEqualTo: isActive);
    
    final fsStream = fsQuery.orderBy('createdAt', firestore.QueryDirection.descending).snapshots().map((snap) {
      final docs = snap.docs.map((doc) => models.UserModel.fromMap({'id': doc.id, ...doc.data() as Map<String, dynamic>}));
      if (query != null && query.isNotEmpty) {
        final low = query.toLowerCase();
        return docs.where((u) => u.email.toLowerCase().contains(low) || u.name.toLowerCase().contains(low)).toList();
      }
      return docs.toList();
    });

    return Rx.combineLatest2<List<models.UserModel>, List<models.UserModel>, List<models.UserModel>>(
      fdcStream, fsStream, (dc, fs) => dc.isNotEmpty ? dc : fs
    ).distinct();
  }

  @override
  Future<Map<String, dynamic>> getAuditDetails(String id) async {
    try {
      final result = await _db.getAuditDetails(id: id).execute();
      final u = result.data.user;
      if (u != null) {
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
          'createdAt': u.createdAt.toDateTime(),
          'updatedAt': u.updatedAt.toDateTime(),
          'transactions': u.walletTransactions_on_user.map((t) => <String, dynamic>{
            'id': t.id.toString(),
            'amount': t.amount,
            'type': t.type.stringValue,
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
            'membershipTier': p.membershipTier?.stringValue,
            'visibilityExpiresAt': p.visibilityExpiresAt?.toDateTime(),
          };
        }
        return data;
      }
    } catch (_) {}

    final userDoc = await _firestore.collection('users').doc(id).get();
    final data = (userDoc.data() as Map<String, dynamic>? ?? {});
    final role = data['role']?.toString().toLowerCase();
    if (role == 'professional') {
      final profDoc = await _firestore.collection('directory_professionals').doc(id).get();
      data['professionalProfile'] = profDoc.data();
    }
    return data;
  }

  @override
  Future<void> adminUpdateUser(String id, models.UserModel user) async {
    await _firestore.collection('users').doc(id).update(user.toMap());
    try {
      final builder = _db.updateUserAdmin(id: id);
      builder.name(user.name);
      builder.isActive(user.isActive);
      if (user.phone != null) builder.phone(user.phone!);
      if (user.whatsapp != null) builder.whatsapp(user.whatsapp!);
      if (user.adminNotes != null) builder.notes(user.adminNotes!);
      builder.balance(user.walletBalance);
      builder.role(sdk.UserRole.values.byName(user.role.toSql()));
      await builder.execute();
    } catch (_) {}
  }

  @override
  Future<void> toggleUserActiveStatus(String id, bool isActive) async {
    await _firestore.collection('users').doc(id).update({'isActive': isActive});
    try {
      await _db.toggleUserActiveStatus(id: id, isActive: isActive).execute();
    } catch (_) {}
  }

  @override
  Future<void> verifyUserDocs(String id, UserRole role, bool isApproved) async {
    final col = role == UserRole.institution ? 'directory_institutions' : 'directory_professionals';
    await _firestore.collection(col).doc(id).update({'isApproved': isApproved});
    try {
      if (role == UserRole.institution) {
        await _db.verifyUserInstitution(id: id, isApproved: isApproved).execute();
      } else {
        await _db.verifyUserProfessional(id: id, isApproved: isApproved).execute();
      }
    } catch (_) {}
  }

  @override
  Stream<List<Map<String, dynamic>>> listAllProviders() {
    return Rx.combineLatest2(
      _firestore.collection('directory_professionals').snapshots(),
      _firestore.collection('directory_institutions').snapshots(),
      (profs, insts) {
        final List<Map<String, dynamic>> all = [];
        all.addAll(profs.docs.map((doc) => <String, dynamic>{'id': doc.id, ...(doc.data() as Map<String, dynamic>? ?? {})}).where((p) => p['isActive'] != false));
        all.addAll(insts.docs.map((doc) => <String, dynamic>{'id': doc.id, ...(doc.data() as Map<String, dynamic>? ?? {})}).where((p) => p['isActive'] != false));
        return all;
      },
    );
  }

  @override
  Future<void> approveProfessional(String id, bool isApproved, UserRole role) async {
    final col = role == UserRole.institution ? 'directory_institutions' : 'directory_professionals';
    await _firestore.collection(col).doc(id).update({'isApproved': isApproved});
    try {
      await _db.approveProfessional(id: id, isApproved: isApproved).execute();
    } catch (_) {}
  }

  @override
  Future<void> validateProfile(String id, UserRole role) async {
    final col = role == UserRole.institution ? 'directory_institutions' : 'directory_professionals';
    await _firestore.collection(col).doc(id).update({'isProfileValidated': true});
    try {
       if (role == UserRole.institution) {
         await _db.validateInstitutionProfile(id: id).execute();
       } else {
         await _db.validateProfile(id: id).execute();
       }
    } catch (_) {}
  }

  @override
  Stream<List<SupportTicketModel>> listSupportTickets({SupportTicketStatus? status}) {
     final fdcStream = _db.listSupportTickets().ref().subscribe().map((snap) =>
        snap.data.supportTickets.map((st) => SupportTicketModel(
          id: st.id.toString(),
          userId: st.user.id, 
          subject: st.subject,
          message: st.message,
          status: SupportTicketStatus.parse(st.status.stringValue).name.toUpperCase(),
          userEmail: st.user.email,
          createdAt: st.createdAt.toDateTime(),
        )).toList()
     ).onErrorReturnWith((e, s) => <SupportTicketModel>[]);

     firestore.Query fsQuery = _firestore.collection('directory_support_inbox');
     if (status != null) fsQuery = fsQuery.where('status', isEqualTo: status.name.toUpperCase());
     final fsStream = fsQuery.snapshots().map((snap) => snap.docs.map((doc) => SupportTicketModel.fromMap({'id': doc.id, ...(doc.data() as Map<String, dynamic>? ?? {})})).toList());

     return Rx.combineLatest2<List<SupportTicketModel>, List<SupportTicketModel>, List<SupportTicketModel>>(
       fdcStream, fsStream, (dc, fs) => dc.isNotEmpty ? dc : fs
     ).distinct();
  }

  @override
  Stream<List<ResourceOrderModel>> listPendingOrders() {
    final fdcStream = _db.listPendingOrders().ref().subscribe().map((snap) =>
      snap.data.resourceOrders.map((o) => ResourceOrderModel(
        id: o.id.toString(),
        userId: o.user.id,
        pinsCount: o.pinsCount,
        slotsCount: o.slotsCount,
        broadcastsCount: o.broadcastsCount,
        totalCost: o.totalCost,
        status: OrderStatus.parse(o.status.stringValue).name.toUpperCase(),
        userEmail: o.user.email,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      )).toList()
    ).onErrorReturnWith((e, s) => <ResourceOrderModel>[]);

    final fsStream = _firestore.collection('directory_resource_orders').where('status', isEqualTo: 'PENDING').snapshots().map((snap) =>
      snap.docs.map((doc) => ResourceOrderModel.fromMap({'id': doc.id, ...(doc.data() as Map<String, dynamic>? ?? {})})).toList()
    );

    return Rx.combineLatest2<List<ResourceOrderModel>, List<ResourceOrderModel>, List<ResourceOrderModel>>(
       fdcStream, fsStream, (dc, fs) => dc.isNotEmpty ? dc : fs
    ).distinct();
  }

  @override
  Future<void> approveResourceOrder(String orderId) async {
    await _firestore.collection('directory_resource_orders').doc(orderId).update({'status': 'APPROVED'});
    try {
      await _db.approveResourceOrder(id: orderId).execute();
    } catch (_) {}
  }

  @override
  Stream<List<ServiceModel>> listServiceModerationQueue({ModerationStatus status = ModerationStatus.pending}) {
    final sdkStatus = sdk.ModerationStatus.values.byName(status.toSql());
    final fdcStream = _db.listServiceModerationQueue().status(sdkStatus).ref().subscribe().map((snap) =>
      snap.data.services.map((s) => ServiceModel(
        id: s.id.toString(),
        providerId: s.provider.id,
        categoryId: s.category.id,
        sectorId: s.sector.id,
        titleEn: s.titleEn,
        price: s.price ?? 0,
        imageUrl: s.imageUrl,
        moderationStatus: ModerationStatus.parse(s.moderationStatus.stringValue).name.toUpperCase(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      )).toList()
    ).onErrorReturnWith((e, s) => <ServiceModel>[]);

    final fsStream = _firestore.collection('directory_services').where('moderationStatus', isEqualTo: status.name.toUpperCase()).snapshots().map((snap) =>
      snap.docs.map((doc) => ServiceModel.fromMap({'id': doc.id, ...(doc.data() as Map<String, dynamic>? ?? {})})).toList()
    );

    return Rx.combineLatest2<List<ServiceModel>, List<ServiceModel>, List<ServiceModel>>(
       fdcStream, fsStream, (dc, fs) => dc.isNotEmpty ? dc : fs
    ).distinct();
  }

  @override
  Stream<List<ServiceRequestModel>> listRequestModerationQueue({ModerationStatus status = ModerationStatus.pending}) {
    final sdkStatus = sdk.ModerationStatus.values.byName(status.toSql());
    final fdcStream = _db.listRequestModerationQueue().status(sdkStatus).ref().subscribe().map((snap) =>
      snap.data.serviceRequests.map((r) => ServiceRequestModel(
        id: r.id.toString(),
        userId: r.user.id,
        sectorId: r.sector.id,
        descriptionEn: r.descriptionEn,
        status: CommunityRequestStatus.parse(r.status.stringValue).name.toUpperCase(),
        moderationStatus: ModerationStatus.parse(r.moderationStatus.stringValue).name.toUpperCase(),
        createdAt: r.createdAt.toDateTime(),
        userName: r.user.name,
      )).toList()
    ).onErrorReturnWith((e, s) => <ServiceRequestModel>[]);

    final fsStream = _firestore.collection('directory_service_requests').where('moderationStatus', isEqualTo: status.name.toUpperCase()).snapshots().map((snap) =>
      snap.docs.map((doc) => ServiceRequestModel.fromMap({'id': doc.id, ...(doc.data() as Map<String, dynamic>? ?? {})})).toList()
    );

    return Rx.combineLatest2<List<ServiceRequestModel>, List<ServiceRequestModel>, List<ServiceRequestModel>>(
       fdcStream, fsStream, (dc, fs) => dc.isNotEmpty ? dc : fs
    ).distinct();
  }

  @override
  Future<void> moderateService(String id, ModerationStatus status, {String? reason}) async {
    await _firestore.collection('directory_services').doc(id).update({'moderationStatus': status.name.toUpperCase(), 'flagReason': reason});
    try {
      final sdkStatus = sdk.ModerationStatus.values.byName(status.toSql());
      final builder = _db.moderateService(id: id, status: sdkStatus);
      if (reason != null) builder.reason(reason);
      await builder.execute();
    } catch (_) {}
  }

  @override
  Future<void> moderateRequest(String id, ModerationStatus status, {String? reason}) async {
    await _firestore.collection('directory_service_requests').doc(id).update({'moderationStatus': status.name.toUpperCase(), 'flagReason': reason});
    try {
      final sdkStatus = sdk.ModerationStatus.values.byName(status.toSql());
      final builder = _db.moderateRequest(id: id, status: sdkStatus);
      if (reason != null) builder.reason(reason);
      await builder.execute();
    } catch (_) {}
  }

  @override
  Future<void> createLocalizedBroadcast({required String title, required String message, String? country, String? region, String? city}) async {
    await _firestore.collection('directory_broadcasts').add({
      'title': title,
      'message': message,
      'targetCountry': country ?? 'GLOBAL',
      'targetRegion': region,
      'targetCity': city,
      'status': 'queued',
      'createdAt': firestore.FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<Map<String, dynamic>>> listTemplates() {
    return _db.listTemplates().ref().subscribe().map((snap) =>
      snap.data.templates.map((t) => <String, dynamic>{
        'id': t.id,
        'accentColor': t.accentColor,
        'iconName': t.iconName,
        'visibleFields': t.visibleFields,
      }).toList()
    ).onErrorReturnWith((e, s) => <Map<String, dynamic>>[]);
  }

  @override
  Future<void> upsertTemplate(String id, List<String> visibleFields, {String? configJson, String? accentColor, String? iconName}) async {
    await _firestore.collection('directory_templates').doc(id).set({
      'visibleFields': visibleFields,
      'configJson': configJson,
      'accentColor': accentColor,
      'iconName': iconName,
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    }, firestore.SetOptions(merge: true));
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
     await _firestore.collection('directory_categories').doc(category.id).update(category.toMap());
  }

  // ─── 6. Discovery & Helpers ──────────────────────────────────────────────

  @override
  Stream<Map<String, dynamic>> getSystemStats() {
    return _firestore.collection('metadata').doc('system_stats').snapshots().map((snap) => (snap.data() as Map<String, dynamic>? ?? {}));
  }
}
