import 'espy_repository.dart';
import '../models/user_model.dart';
import '../models/professional_profile.dart';
import '../models/institution_profile.dart';
import '../models/visitor_profile.dart';
// Note: This import will be valid after running 'firebase dataconnect:sdk:generate'
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
    
    // Mapping DataConnect Data to local UserModel
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
    // Similar to professional details if a query exists
    return null; 
  }

  @override
  Future<VisitorProfile?> getVisitorProfile(String id) async {
    return null;
  }

  // ─── 2. Taxonomy & Location ──────────────────────────────────────────────

  @override
  Stream<List<Map<String, dynamic>>> listSectors() {
    // Standard query for sectors
    return Stream.value([]);
  }

  @override
  Stream<List<Map<String, dynamic>>> listCategories({String? sectorId}) {
    return Stream.value([]);
  }

  @override
  Stream<List<Map<String, dynamic>>> listCountries() {
    return Stream.value([]);
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
      }).toList()
    );
  }

  @override
  Future<void> createCommunityRequest(Map<String, dynamic> data) async {
    await _db.postCommunityRequest(
      userId: data['userId'],
      sectorId: data['sectorId'],
      title: data['title'],
      description: data['description'],
    ).execute();
  }

  // ─── 4. Ledger & Analytics ───────────────────────────────────────────────

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
    final result = await _db.spendTokens(
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
      actorId: userId,
      targetId: targetId,
      type: InteractionType.values.byName(type.toUpperCase()),
    ).execute();
  }

  @override
  Future<void> toggleFavorite(String userId, String targetId, bool isFavorite) async {
    if (isFavorite) {
      await recordInteraction(userId: userId, targetId: targetId, type: 'FAVORITE');
    }
    // Note: To "un-favorite" in relational schema, we'd delete the interaction record
    // or add a specialized favorite table.
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

  // ─── 5. Discovery & Helpers ──────────────────────────────────────────────

  @override
  Stream<List<Map<String, dynamic>>> listAllProviders() {
    // Implementation for combined view if needed
    return Stream.value([]);
  }
}
