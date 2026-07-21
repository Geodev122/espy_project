import 'espy_repository.dart';
import '../models/user_model.dart';
import '../models/professional_profile.dart';
import '../models/institution_profile.dart';
import '../models/visitor_profile.dart';
import 'package:espy_dataconnect_sdk/espy_dataconnect_sdk.dart';

/**
 * Repository implementation for Firebase DataConnect (PostgreSQL)
 * Uses the auto-generated type-safe SDK for all database operations.
 */
class DataConnectEspyRepository implements EspyRepository {
  final EspyConnector _db = EspyConnector.instance;

  // ─── 1. Identity & Profiles ──────────────────────────────────────────────

  @override
  Future<UserModel?> getUser(String id) async {
    final result = await _db.getUser(uid: id).execute();
    if (result.data.user == null) return null;
    
    final user = result.data.user!;
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name ?? '',
      role: UserRole.values.byName(user.role.name.toLowerCase()),
      isActive: user.isActive,
      walletBalance: user.walletBalance,
      tokensUsed: user.tokensUsed,
      photoUrl: user.photoUrl,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  @override
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    await _db.updateUserProfile(
      id: id,
      name: data['name'],
      photoUrl: data['photoUrl'],
      phone: data['phone'],
      whatsapp: data['whatsapp'],
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
      membershipTier: prof.membershipTier?.name.toLowerCase() ?? 'basic',
      serviceSlots: prof.serviceSlots,
      practicePins: prof.practicePins,
      visibilityExpiresAt: prof.visibilityExpiresAt,
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
      serviceSlots: inst.serviceSlots,
      visibilityExpiresAt: inst.visibilityExpiresAt,
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
        'displayOrder': s.displayOrder,
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
        'targetRole': c.targetRole.name.toLowerCase(),
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
        'isMain': ln.isMain,
      }).toList()
    );
  }

  // ─── 3. Core Business Logic ──────────────────────────────────────────────

  @override
  Stream<List<Map<String, dynamic>>> listActiveServices({String? categoryId, String? sectorId}) {
    return _db.listActiveServices(categoryId: categoryId).subscribe().map((snap) =>
      snap.data.services.map((s) => {
        'id': s.id,
        'titleEn': s.titleEn,
        'price': s.price,
        'imageUrl': s.imageUrl,
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
    return _db.listCommunityRequests(sectorId: sectorId).subscribe().map((snap) =>
      snap.data.communityRequests.map((cr) => {
        'id': cr.id,
        'title': cr.title,
        'description': cr.description,
        'status': cr.status.name,
        'userName': cr.user.name,
        'createdAt': cr.createdAt,
      }).toList()
    );
  }

  @override
  Future<void> createCommunityRequest(Map<String, dynamic> data) async {
    await _db.postCommunityRequest(
      sectorId: data['sectorId'],
      title: data['title'],
      description: data['description'],
    ).execute();
  }

  // ─── 4. Ledger & Resource Orders ─────────────────────────────────────────

  @override
  Stream<List<Map<String, dynamic>>> listWalletTransactions(String userId) {
    return _db.getWalletTransactions(userId: userId).subscribe().map((snap) =>
      snap.data.walletTransactions.map((t) => {
        'id': t.id,
        'type': t.type.name,
        'amount': t.amount,
        'description': t.description,
        'createdAt': t.createdAt,
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
      type: TransactionType.purchase,
    ).execute();
    return {'success': true};
  }

  @override
  Future<void> recordInteraction({required String userId, required String targetId, required String type}) async {
    await _db.recordInteraction(
      targetId: targetId,
      type: InteractionType.values.byName(type.toUpperCase()),
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
    return _db.listInteractions(actorId: userId, type: InteractionType.favorite)
        .subscribe()
        .map((snap) => snap.data.interactions.map((i) => i.targetId).toList());
  }

  @override
  Stream<List<String>> listContactedIds(String userId) {
    return _db.listInteractions(actorId: userId, type: InteractionType.like)
        .subscribe()
        .map((snap) => snap.data.interactions.map((i) => i.targetId).toList());
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
        'status': o.status.name,
      };
    });
  }

  // ─── 5. Admin Operations ─────────────────────────────────────────────────

  @override
  Stream<List<Map<String, dynamic>>> listAllProviders() {
    return Stream.value([]);
  }

  @override
  Future<void> approveProfessional(String id, bool isApproved, String role) async {
    await _db.approveProfessional(id: id, isApproved: isApproved).execute();
  }

  @override
  Stream<List<Map<String, dynamic>>> listSupportTickets({String? status}) {
     SupportTicketStatus? gqlStatus;
     if (status != null) gqlStatus = SupportTicketStatus.values.byName(status.toUpperCase());
     return _db.listSupportTickets(status: gqlStatus).subscribe().map((snap) =>
        snap.data.supportTickets.map((st) => {
          'id': st.id,
          'subject': st.subject,
          'message': st.message,
          'status': st.status.name,
          'userEmail': st.user.email,
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
  Stream<List<Map<String, dynamic>>> getSystemStats() {
    return Stream.value([]);
  }
}
