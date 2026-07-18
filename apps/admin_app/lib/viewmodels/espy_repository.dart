import '../models/user_model.dart';
import '../models/professional_profile.dart';
import '../models/institution_profile.dart';
import '../models/visitor_profile.dart';

abstract class EspyRepository {
  // ─── 1. Identity & Profiles ──────────────────────────────────────────────
  Future<UserModel?> getUser(String id);
  Future<void> updateUser(String id, Map<String, dynamic> data);

  Future<ProfessionalProfile?> getProfessionalProfile(String id);
  Future<InstitutionProfile?> getInstitutionProfile(String id);
  Future<VisitorProfile?> getVisitorProfile(String id);

  // ─── 2. Taxonomy & Location ──────────────────────────────────────────────
  Stream<List<Map<String, dynamic>>> listSectors();
  Stream<List<Map<String, dynamic>>> listCategories({String? sectorId});
  Stream<List<Map<String, dynamic>>> listCountries();
  Stream<List<Map<String, dynamic>>> listLocationNodes(String userId);

  // ─── 3. Core Business Logic ──────────────────────────────────────────────
  Stream<List<Map<String, dynamic>>> listActiveServices({String? categoryId, String? sectorId});
  Stream<List<Map<String, dynamic>>> listProfessionalServices(String professionalId);
  Future<void> toggleServiceSlot(String serviceId, bool allocate);

  Stream<List<Map<String, dynamic>>> listCommunityRequests({String? sectorId, bool newestFirst = true, String? userId});
  Future<void> createCommunityRequest(Map<String, dynamic> data);

  // ─── 4. Ledger & Analytics ───────────────────────────────────────────────
  Stream<List<Map<String, dynamic>>> listWalletTransactions(String userId);
  Future<Map<String, dynamic>> spendTokens({required String userId, required String itemId, required int cost, required String role});

  Future<void> recordInteraction({required String userId, required String targetId, required String type});
  Future<void> toggleFavorite(String userId, String targetId, bool isFavorite);
  Stream<List<String>> listFavoriteIds(String userId);
  Stream<List<String>> listContactedIds(String userId);

  // ─── 5. Discovery & Helpers ──────────────────────────────────────────────
  Stream<List<Map<String, dynamic>>> listAllProviders(); // Combines Pros & Insts
}
