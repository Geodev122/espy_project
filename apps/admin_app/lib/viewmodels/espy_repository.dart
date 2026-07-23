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
  
  // Admin Taxonomy Ops
  Future<void> updateSector(String id, Map<String, dynamic> data);
  Future<void> updateCategory(String id, Map<String, dynamic> data);

  // ─── 3. Core Business Logic ──────────────────────────────────────────────
  Stream<List<Map<String, dynamic>>> listActiveServices({String? categoryId, String? sectorId});
  Stream<List<Map<String, dynamic>>> listProfessionalServices(String professionalId);
  Future<void> toggleServiceSlot(String serviceId, bool allocate);

  Stream<List<Map<String, dynamic>>> listCommunityRequests({String? sectorId, bool newestFirst = true, String? userId});
  Future<void> createCommunityRequest(Map<String, dynamic> data);

  // ─── 4. Ledger & Resource Orders ─────────────────────────────────────────
  Stream<List<Map<String, dynamic>>> listWalletTransactions(String userId);
  Future<Map<String, dynamic>> spendTokens({required String userId, required String itemId, required int cost, required String role});

  Future<void> recordInteraction({required String userId, required String targetId, required String type});
  Future<void> toggleFavorite(String userId, String targetId, bool isFavorite);
  Stream<List<String>> listFavoriteIds(String userId);
  Stream<List<String>> listContactedIds(String userId);

  Future<void> upsertProfessionalProfile({required String id, String? fullNameAr, String? specialty, String? specialtyAr, String? bioEn, String? bioAr});
  Future<void> upsertInstitutionProfile({required String id, String? nameAr, String? bioEn, String? bioAr, String? registrationNumber});

  // --- Resource Orders ---
  Future<void> createResourceOrder({required String userId, required int pins, required int slots, required int broadcasts, required int total});
  Future<void> updateResourceOrder({required String id, required int pins, required int slots, required int broadcasts, required int total});
  Stream<Map<String, dynamic>?> getActiveResourceOrder(String userId);

  // --- Recharge Cards ---
  Future<void> generateRechargeCard({required String code, required int value, int pins = 0, int slots = 0});
  Stream<List<Map<String, dynamic>>> listRechargeCards();

  // ─── 5. Admin Operations ─────────────────────────────────────────────────
  Stream<List<Map<String, dynamic>>> listAllUsers();
  Future<Map<String, dynamic>> getUserDetails(String id);
  Future<void> adminUpdateUser(String id, Map<String, dynamic> data);
  Future<void> toggleUserActiveStatus(String id, bool isActive);
  Future<void> verifyUserDocs(String id, String role, bool isApproved);

  Stream<List<Map<String, dynamic>>> listAllProviders(); 
  Future<void> approveProfessional(String id, bool isApproved, String role);
  Future<void> validateProfile(String id, String role);
  Stream<List<Map<String, dynamic>>> listSupportTickets({String? status});
  Stream<List<Map<String, dynamic>>> listPendingOrders();
  Future<void> approveResourceOrder(String orderId);

  // ─── 6. Discovery & Helpers ──────────────────────────────────────────────
  Stream<Map<String, dynamic>> getSystemStats();
}
