import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'espy_repository.dart';
import '../models/user_model.dart' as models;
import '../models/professional_profile.dart';
import '../models/institution_profile.dart';
import '../models/visitor_profile.dart';
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
          role: models.UserRole.values.byName(user.role.stringValue.toLowerCase()),
          isActive: user.isActive,
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
  Future<void> createUser(Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(data['id']).set(data);
    try {
      await _db.createUser(
        id: data['id'],
        email: data['email'],
        role: sdk.UserRole.values.byName(data['role'].toString().toUpperCase()),
      ).name(data['name']).execute();
    } catch (e) {
      debugPrint("Shadow-write createUser failed: $e");
    }
  }

  @override
  Future<void> upsertUser(Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(data['id']).set(data, firestore.SetOptions(merge: true));
    try {
      await _db.upsertUser(
        id: data['id'],
        email: data['email'],
        role: sdk.UserRole.values.byName(data['role'].toString().toUpperCase()),
      ).name(data['name']).execute();
    } catch (e) {
      debugPrint("Shadow-write upsertUser failed: $e");
    }
  }

  @override
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(id).set({
      ...data,
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    }, firestore.SetOptions(merge: true));

    try {
      final builder = _db.updateUserProfile(id: id);
      if (data.containsKey('name')) builder.name(data['name']);
      if (data.containsKey('photoUrl')) builder.photoUrl(data['photoUrl']);
      if (data.containsKey('phone')) builder.phone(data['phone']);
      if (data.containsKey('whatsapp')) builder.whatsapp(data['whatsapp']);
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
          membershipTier: prof.membershipTier?.stringValue.toLowerCase() ?? 'basic',
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
      final inst = result.data.user?.institutionProfile_on_user;
      if (inst != null) {
        return InstitutionProfile(
          id: id,
          nameAr: inst.nameAr,
          isApproved: inst.isApproved,
          serviceSlots: 0,
          visibilityExpiresAt: inst.visibilityExpiresAt?.toDateTime(),
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
  Stream<List<Map<String, dynamic>>> listSectors() {
    final dcStream = _db.listSectors().ref().subscribe().map((snap) => 
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
    ).onErrorReturnWith((e, s) => []);

    final fsStream = _firestore.collection('directory_sectors').snapshots().map((snap) =>
      snap.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList()
    );

    return Rx.combineLatest2<List<Map<String, dynamic>>, List<Map<String, dynamic>>, List<Map<String, dynamic>>>(
      dcStream, fsStream, (dc, fs) => dc.isNotEmpty ? dc : fs
    ).distinct();
  }

  @override
  Stream<List<Map<String, dynamic>>> listCategories({String? sectorId}) {
    var builder = _db.listCategories();
    if (sectorId != null) builder = builder.sectorId(sectorId);
    
    final fdcStream = builder.ref().subscribe().map((snap) =>
      snap.data.categories.map((c) => {
        'id': c.id,
        'nameEn': c.nameEn,
        'nameAr': c.nameAr,
        'targetRole': c.targetRole.stringValue.toLowerCase(),
      }).toList()
    ).onErrorReturnWith((e, s) => []);

    firestore.Query fsQuery = _firestore.collection('directory_categories');
    if (sectorId != null) fsQuery = fsQuery.where('sectorId', isEqualTo: sectorId);
    final fsStream = fsQuery.snapshots().map((snap) => snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());

    return Rx.combineLatest2<List<Map<String, dynamic>>, List<Map<String, dynamic>>, List<Map<String, dynamic>>>(
      fdcStream, fsStream, (dc, fs) => dc.isNotEmpty ? dc : fs
    ).distinct();
  }

  @override
  Stream<List<Map<String, dynamic>>> listCountries() {
    final fdcStream = _db.listCountries().ref().subscribe().map((snap) =>
      snap.data.countries.map((c) => {
        'id': c.id,
        'nameEn': c.nameEn,
        'nameAr': c.nameAr,
        'flagEmoji': c.flagEmoji,
        'isoCode': c.isoCode,
        'currency': c.currency,
      }).toList()
    ).onErrorReturnWith((e, s) => []);

    final fsStream = _firestore.collection('directory_countries').snapshots().map((snap) =>
      snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList()
    );

    return Rx.combineLatest2<List<Map<String, dynamic>>, List<Map<String, dynamic>>, List<Map<String, dynamic>>>(
      fdcStream, fsStream, (dc, fs) => dc.isNotEmpty ? dc : fs
    ).distinct();
  }

  @override
  Stream<List<Map<String, dynamic>>> listRegions(String countryId) {
    final fdcStream = _db.listRegions(countryId: countryId).ref().subscribe().map((snap) =>
      snap.data.regions.map((r) => {
        'id': r.id.toString(),
        'nameEn': r.nameEn,
        'nameAr': r.nameAr,
        'regionCode': r.regionCode,
      }).toList()
    ).onErrorReturnWith((e, s) => []);

    final fsStream = _firestore.collection('directory_regions').where('countryId', isEqualTo: countryId).snapshots().map((snap) =>
      snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList()
    );

    return Rx.combineLatest2<List<Map<String, dynamic>>, List<Map<String, dynamic>>, List<Map<String, dynamic>>>(
      fdcStream, fsStream, (dc, fs) => dc.isNotEmpty ? dc : fs
    ).distinct();
  }

  @override
  Stream<List<Map<String, dynamic>>> listCities(String regionId) {
    final fdcStream = _db.listCities(regionId: regionId).ref().subscribe().map((snap) =>
      snap.data.cities.map((c) => {
        'id': c.id.toString(),
        'nameEn': c.nameEn,
        'nameAr': c.nameAr,
        'lat': c.lat,
        'lng': c.lng,
      }).toList()
    ).onErrorReturnWith((e, s) => []);

    final fsStream = _firestore.collection('directory_cities').where('regionId', isEqualTo: regionId).snapshots().map((snap) =>
      snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList()
    );

    return Rx.combineLatest2<List<Map<String, dynamic>>, List<Map<String, dynamic>>, List<Map<String, dynamic>>>(
      fdcStream, fsStream, (dc, fs) => dc.isNotEmpty ? dc : fs
    ).distinct();
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
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Future<void> upsertCountry(Map<String, dynamic> data) async {
    await _firestore.collection('directory_countries').doc(data['id']).set(data, firestore.SetOptions(merge: true));
    try {
      final builder = _db.upsertCountry(id: data['id'], nameEn: data['nameEn'], nameAr: data['nameAr']);
      if (data['isoCode'] != null) builder.isoCode(data['isoCode']);
      if (data['currency'] != null) builder.currency(data['currency']);
      if (data['flagEmoji'] != null) builder.flagEmoji(data['flagEmoji']);
      await builder.execute();
    } catch (_) {}
  }

  @override
  Future<void> upsertRegion(Map<String, dynamic> data) async {
    await _firestore.collection('directory_regions').doc(data['id']).set(data, firestore.SetOptions(merge: true));
    try {
      final builder = _db.upsertRegion(id: data['id'], countryId: data['countryId'], nameEn: data['nameEn'], nameAr: data['nameAr']);
      if (data['regionCode'] != null) builder.regionCode(data['regionCode']);
      await builder.execute();
    } catch (_) {}
  }

  @override
  Future<void> upsertCity(Map<String, dynamic> data) async {
    await _firestore.collection('directory_cities').doc(data['id']).set(data, firestore.SetOptions(merge: true));
    try {
      final builder = _db.upsertCity(id: data['id'], regionId: data['regionId'], nameEn: data['nameEn'], nameAr: data['nameAr']);
      if (data['lat'] != null) builder.lat(data['lat']);
      if (data['lng'] != null) builder.lng(data['lng']);
      await builder.execute();
    } catch (_) {}
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
        'deliveryMode': s.deliveryMode?.stringValue,
        'providerId': s.provider.id,
        'template': s.sector.template != null ? {
           'accentColor': s.sector.template!.accentColor,
           'iconName': s.sector.template!.iconName,
           'visibleFields': s.sector.template!.visibleFields,
        } : null,
      }).toList()
    ).onErrorReturnWith((e, s) => []);
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
        'status': cr.status.stringValue,
        'userName': cr.user.name,
        'createdAt': cr.createdAt.toDateTime(),
        'sectorId': sectorId,
      }).toList()
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Future<void> createCommunityRequest(Map<String, dynamic> data) async {
    // PostServiceRequest
  }

  @override
  Future<Map<String, List<Map<String, dynamic>>>> listMetadataTags() async {
    try {
      final result = await _db.listMetadataTags().execute();
      return {
        'serviceTags': result.data.serviceTags.map((t) => {'id': t.id, 'nameEn': t.nameEn, 'nameAr': t.nameAr}).toList(),
        'priceTags': result.data.priceTags.map((t) => {'id': t.id, 'nameEn': t.nameEn, 'nameAr': t.nameAr, 'category': t.category}).toList(),
        'pinCategories': result.data.pinCategories.map((t) => {'id': t.id, 'nameEn': t.nameEn, 'nameAr': t.nameAr, 'iconBase': t.iconBase}).toList(),
        'presenceTags': result.data.presenceTags.map((t) => {'id': t.id, 'nameEn': t.nameEn, 'nameAr': t.nameAr}).toList(),
      };
    } catch (e) {
      debugPrint("DataConnect listMetadataTags failed: $e");
    }

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
  Stream<List<Map<String, dynamic>>> listWalletTransactions(String userId) {
    return _db.getWalletTransactions(userId: userId).ref().subscribe().map((snap) =>
      snap.data.walletTransactions.map((t) => {
        'id': t.id.toString(),
        'type': t.type.stringValue,
        'amount': t.amount,
        'description': t.description,
        'createdAt': t.createdAt.toDateTime(),
      }).toList()
    ).onErrorReturnWith((e, s) => []);
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
        .map((snap) => snap.data.interactions.map((i) => i.targetId).toList())
        .onErrorReturnWith((e, s) => []);
  }

  @override
  Stream<List<String>> listContactedIds(String userId) {
    return _db.listInteractions(actorId: userId, type: sdk.InteractionType.CONTACT)
        .ref().subscribe()
        .map((snap) => snap.data.interactions.map((i) => i.targetId).toList())
        .onErrorReturnWith((e, s) => []);
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
        'status': o.status.stringValue,
      };
    }).onErrorReturnWith((e, s) => null);
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
    ).onErrorReturnWith((e, s) => []);
  }

  // ─── 5. Admin Operations ─────────────────────────────────────────────────

  @override
  Stream<List<Map<String, dynamic>>> searchUsersAdmin({String? query, String? role, bool? hasProfile, bool? isActive}) {
    var dcBuilder = _db.searchUsersAdmin();
    if (query != null) dcBuilder = dcBuilder.query(query);
    if (role != null) {
       final gqlRole = sdk.UserRole.values.byName(role.toUpperCase());
       dcBuilder = dcBuilder.role(gqlRole);
    }
    if (hasProfile != null) dcBuilder = dcBuilder.hasProfile(hasProfile);
    if (isActive != null) dcBuilder = dcBuilder.isActive(isActive);
    
    final fdcStream = dcBuilder.ref().subscribe().map((snap) =>
      snap.data.users.map((u) => {
        'id': u.id,
        'email': u.email,
        'name': u.name,
        'role': u.role.stringValue,
        'isActive': u.isActive,
        'hasProfile': u.hasProfile,
        'phone': u.phone,
        'whatsapp': u.whatsapp,
        'createdAt': u.createdAt.toDateTime(),
      }).toList()
    ).onErrorReturnWith((e, s) => []);

    firestore.Query fsQuery = _firestore.collection('users');
    if (role != null) fsQuery = fsQuery.where('role', isEqualTo: role.toLowerCase());
    if (hasProfile != null) fsQuery = fsQuery.where('hasProfile', isEqualTo: hasProfile);
    if (isActive != null) fsQuery = fsQuery.where('isActive', isEqualTo: isActive);
    
    final fsStream = fsQuery.orderBy('createdAt', descending: true).snapshots().map((snap) {
      final docs = snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>});
      if (query != null && query.isNotEmpty) {
        final low = query.toLowerCase();
        return docs.where((u) => u['email']?.toString().toLowerCase().contains(low) == true || u['name']?.toString().toLowerCase().contains(low) == true).toList();
      }
      return docs.toList();
    });

    return Rx.combineLatest2<List<Map<String, dynamic>>, List<Map<String, dynamic>>, List<Map<String, dynamic>>>(
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
          'transactions': u.walletTransactions_on_user.map((t) => {
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
    final data = (userDoc.data() as Map<String, dynamic>?) ?? {};
    final role = data['role']?.toString().toLowerCase();
    if (role == 'professional') {
      final profDoc = await _firestore.collection('directory_professionals').doc(id).get();
      data['professionalProfile'] = profDoc.data();
    }
    return data;
  }

  @override
  Future<void> adminUpdateUser(String id, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(id).update(data);
    try {
      final builder = _db.updateUserAdmin(id: id);
      if (data.containsKey('name')) builder.name(data['name']);
      if (data.containsKey('isActive')) builder.isActive(data['isActive']);
      if (data.containsKey('phone')) builder.phone(data['phone']);
      if (data.containsKey('whatsapp')) builder.whatsapp(data['whatsapp']);
      if (data.containsKey('adminNotes')) builder.notes(data['adminNotes']);
      if (data.containsKey('walletBalance')) builder.balance(data['walletBalance']);
      if (data.containsKey('role')) builder.role(sdk.UserRole.values.byName(data['role'].toString().toUpperCase()));
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
  Future<void> verifyUserDocs(String id, String role, bool isApproved) async {
    final col = role == 'institution' ? 'directory_institutions' : 'directory_professionals';
    await _firestore.collection(col).doc(id).update({'isApproved': isApproved});
    try {
      if (role == 'institution') {
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
        all.addAll(profs.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).where((p) => p['isActive'] != false));
        all.addAll(insts.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).where((p) => p['isActive'] != false));
        return all;
      },
    );
  }

  @override
  Future<void> approveProfessional(String id, bool isApproved, String role) async {
    final col = role == 'institution' ? 'directory_institutions' : 'directory_professionals';
    await _firestore.collection(col).doc(id).update({'isApproved': isApproved});
    try {
      await _db.approveProfessional(id: id, isApproved: isApproved).execute();
    } catch (_) {}
  }

  @override
  Future<void> validateProfile(String id, String role) async {
    final col = role == 'institution' ? 'directory_institutions' : 'directory_professionals';
    await _firestore.collection(col).doc(id).update({'isProfileValidated': true});
    try {
       if (role == 'institution') {
         await _db.validateInstitutionProfile(id: id).execute();
       } else {
         await _db.validateProfile(id: id).execute();
       }
    } catch (_) {}
  }

  @override
  Stream<List<Map<String, dynamic>>> listSupportTickets({String? status}) {
     final fdcStream = _db.listSupportTickets().ref().subscribe().map((snap) =>
        snap.data.supportTickets.map((st) => {
          'id': st.id.toString(),
          'subject': st.subject,
          'message': st.message,
          'status': st.status.stringValue,
          'userEmail': st.user.email,
          'createdAt': st.createdAt.toDateTime(),
        }).toList()
     ).onErrorReturnWith((e, s) => []);

     firestore.Query fsQuery = _firestore.collection('directory_support_inbox');
     if (status != null) fsQuery = fsQuery.where('status', isEqualTo: status);
     final fsStream = fsQuery.snapshots().map((snap) => snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());

     return Rx.combineLatest2<List<Map<String, dynamic>>, List<Map<String, dynamic>>, List<Map<String, dynamic>>>(
       fdcStream, fsStream, (dc, fs) => dc.isNotEmpty ? dc : fs
     ).distinct();
  }

  @override
  Stream<List<Map<String, dynamic>>> listPendingOrders() {
    final fdcStream = _db.listPendingOrders().ref().subscribe().map((snap) =>
      snap.data.resourceOrders.map((o) => {
        'id': o.id.toString(),
        'pinsCount': o.pinsCount,
        'slotsCount': o.slotsCount,
        'broadcastsCount': o.broadcastsCount,
        'totalCost': o.totalCost,
        'userEmail': o.user.email,
      }).toList()
    ).onErrorReturnWith((e, s) => []);

    final fsStream = _firestore.collection('directory_resource_orders').where('status', isEqualTo: 'PENDING').snapshots().map((snap) =>
      snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList()
    );

    return Rx.combineLatest2<List<Map<String, dynamic>>, List<Map<String, dynamic>>, List<Map<String, dynamic>>>(
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
  Stream<List<Map<String, dynamic>>> listServiceModerationQueue({String status = 'PENDING'}) {
    final sdkStatus = sdk.ModerationStatus.values.byName(status.toUpperCase());
    final fdcStream = _db.listServiceModerationQueue().status(sdkStatus).ref().subscribe().map((snap) =>
      snap.data.services.map((s) => {
        'id': s.id.toString(),
        'titleEn': s.titleEn,
        'price': s.price,
        'imageUrl': s.imageUrl,
        'moderationStatus': s.moderationStatus.stringValue,
        'categoryName': s.category.nameEn,
        'sectorName': s.sector.nameEn,
        'providerName': s.provider.name,
      }).toList()
    ).onErrorReturnWith((e, s) => []);

    final fsStream = _firestore.collection('directory_services').where('moderationStatus', isEqualTo: status).snapshots().map((snap) =>
      snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList()
    );

    return Rx.combineLatest2<List<Map<String, dynamic>>, List<Map<String, dynamic>>, List<Map<String, dynamic>>>(
       fdcStream, fsStream, (dc, fs) => dc.isNotEmpty ? dc : fs
    ).distinct();
  }

  @override
  Stream<List<Map<String, dynamic>>> listRequestModerationQueue({String status = 'PENDING'}) {
    final sdkStatus = sdk.ModerationStatus.values.byName(status.toUpperCase());
    final fdcStream = _db.listRequestModerationQueue().status(sdkStatus).ref().subscribe().map((snap) =>
      snap.data.serviceRequests.map((r) => {
        'id': r.id.toString(),
        'descriptionEn': r.descriptionEn,
        'status': r.status.stringValue,
        'moderationStatus': r.moderationStatus.stringValue,
        'userName': r.user.name,
      }).toList()
    ).onErrorReturnWith((e, s) => []);

    final fsStream = _firestore.collection('directory_service_requests').where('moderationStatus', isEqualTo: status).snapshots().map((snap) =>
      snap.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList()
    );

    return Rx.combineLatest2<List<Map<String, dynamic>>, List<Map<String, dynamic>>, List<Map<String, dynamic>>>(
       fdcStream, fsStream, (dc, fs) => dc.isNotEmpty ? dc : fs
    ).distinct();
  }

  @override
  Future<void> moderateService(String id, String status, {String? reason}) async {
    await _firestore.collection('directory_services').doc(id).update({'moderationStatus': status, 'flagReason': reason});
    try {
      final sdkStatus = sdk.ModerationStatus.values.byName(status.toUpperCase());
      final builder = _db.moderateService(id: id, status: sdkStatus);
      if (reason != null) builder.reason(reason);
      await builder.execute();
    } catch (_) {}
  }

  @override
  Future<void> moderateRequest(String id, String status, {String? reason}) async {
    await _firestore.collection('directory_service_requests').doc(id).update({'moderationStatus': status, 'flagReason': reason});
    try {
      final sdkStatus = sdk.ModerationStatus.values.byName(status.toUpperCase());
      final builder = _db.moderateRequest(id: id, status: sdkStatus);
      if (reason != null) builder.reason(reason);
      await builder.execute();
    } catch (_) {}
  }

  @override
  Future<void> createLocalizedBroadcast({required String title, required String message, String? country, String? region, String? city}) async {
    await _firestore.collection('directory_broadcasts').add({'title': title, 'message': message, 'targetCountry': country, 'createdAt': firestore.FieldValue.serverTimestamp()});
    try {
      final builder = _db.createLocalizedBroadcast(title: title, message: message);
      if (country != null) builder.country(country);
      if (region != null) builder.region(region);
      if (city != null) builder.city(city);
      await builder.execute();
    } catch (_) {}
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
    ).onErrorReturnWith((e, s) => []);
  }

  @override
  Future<void> upsertTemplate(String id, List<String> visibleFields, {String? configJson, String? accentColor, String? iconName}) async {
    await _firestore.collection('directory_templates').doc(id).set({'visibleFields': visibleFields, 'configJson': configJson, 'accentColor': accentColor, 'iconName': iconName}, firestore.SetOptions(merge: true));
    try {
      final builder = _db.upsertTemplate(id: id);
      builder.visibleFields(visibleFields);
      if (configJson != null) builder.configJson(configJson);
      if (accentColor != null) builder.accentColor(accentColor);
      if (iconName != null) builder.iconName(iconName);
      await builder.execute();
    } catch (_) {}
  }

  // ─── 6. Discovery & Helpers ──────────────────────────────────────────────

  @override
  Stream<Map<String, dynamic>> getSystemStats() {
    return _firestore.collection('metadata').doc('system_stats').snapshots().map((snap) => (snap.data() as Map<String, dynamic>?) ?? {});
  }

  @override
  Future<void> updateCategory(String id, Map<String, dynamic> data) async {
     await _firestore.collection('directory_categories').doc(id).update(data);
  }
}
