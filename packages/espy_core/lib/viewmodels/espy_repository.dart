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

abstract class EspyRepository {
  // ─── 1. Identity & Profiles ──────────────────────────────────────────────
  Future<UserModel?> getUser(String id);
  Future<void> createUser(UserModel user);
  Future<void> upsertUser(UserModel user);
  Future<void> updateUser(String id, UserModel user);
  Future<void> updateLastActive(String id);

  Future<ProfessionalProfile?> getProfessionalProfile(String id);
  Future<InstitutionProfile?> getInstitutionProfile(String id);
  Future<VisitorProfile?> getVisitorProfile(String id);

  // ─── 2. Taxonomy & Location ──────────────────────────────────────────────
  Stream<List<SectorModel>> listSectors();
  Stream<List<CategoryModel>> listCategories({String? sectorId});
  Stream<List<CountryModel>> listCountries();
  Stream<List<RegionModel>> listRegions(String countryId);
  Stream<List<CityModel>> listCities(String regionId);
  Stream<List<Map<String, dynamic>>> listLocationNodes(String userId);
  
  // Admin Geography Ops
  Future<void> upsertCountry(CountryModel country);
  Future<void> upsertRegion(RegionModel region);
  Future<void> upsertCity(CityModel city);
  Future<void> deleteGeographyEntity(String id, String type);

  // Admin Taxonomy Ops
  Future<void> updateSectorBranding(String id, SectorModel sector);
  Future<void> updateCategory(CategoryModel category);
  Future<void> upsertServiceTag(Map<String, dynamic> data);
  Future<void> upsertPriceTag(Map<String, dynamic> data);
  Future<void> upsertPinCategory(Map<String, dynamic> data);
  Future<void> upsertPresenceTag(Map<String, dynamic> data);

  // ─── 3. Core Business Logic ──────────────────────────────────────────────
  Stream<List<ServiceModel>> listActiveServices({String? categoryId, String? sectorId});
  Stream<List<ServiceModel>> listProfessionalServices(String professionalId);
  Future<void> toggleServiceSlot(String serviceId, bool allocate);

  Stream<List<ServiceRequestModel>> listCommunityRequests({String? sectorId, bool newestFirst = true, String? userId});
  Future<void> createCommunityRequest(ServiceRequestModel request);

  Future<void> createLocationNode(LocationNodeModel node);
  
  // Metadata Tags
  Future<Map<String, List<Map<String, dynamic>>>> listMetadataTags();

  // ─── 4. Ledger & Resource Orders ─────────────────────────────────────────
  Stream<List<WalletTransactionModel>> listWalletTransactions(String userId);
  Future<Map<String, dynamic>> spendTokens({required String userId, required String itemId, required int cost, required UserRole role});

  Future<void> recordInteraction({required String userId, required String targetId, required InteractionType type});
  Future<void> toggleFavorite(String userId, String targetId, bool isFavorite);
  Stream<List<String>> listFavoriteIds(String userId);
  Stream<List<String>> listContactedIds(String userId);

  // --- Resource Orders ---
  Future<void> upsertProfessionalProfile(ProfessionalProfile profile);
  Future<void> upsertInstitutionProfile(InstitutionProfile profile);
  Future<void> createResourceOrder(ResourceOrderModel order);
  Future<void> updateResourceOrder(ResourceOrderModel order);
  Stream<ResourceOrderModel?> getActiveResourceOrder(String userId);

  // --- Recharge Cards ---
  Future<void> generateRechargeCard({required String code, required int value, int pins = 0, int slots = 0});
  Stream<List<Map<String, dynamic>>> listRechargeCards();

  // ─── 5. Admin Operations ─────────────────────────────────────────────────
  Stream<List<UserModel>> searchUsersAdmin({String? query, UserRole? role, bool? hasProfile, bool? isActive});
  Future<Map<String, dynamic>> getAuditDetails(String id);
  Future<void> adminUpdateUser(String id, UserModel user);
  Future<void> toggleUserActiveStatus(String id, bool isActive);
  Future<void> verifyUserDocs(String id, UserRole role, bool isApproved);

  Stream<List<Map<String, dynamic>>> listAllProviders(); 
  Future<void> approveProfessional(String id, bool isApproved, UserRole role);
  Future<void> validateProfile(String id, UserRole role);
  Stream<List<SupportTicketModel>> listSupportTickets({SupportTicketStatus? status});
  Stream<List<ResourceOrderModel>> listPendingOrders();
  Future<void> approveResourceOrder(String orderId);

  // --- Service Management & Moderation ---
  Stream<List<ServiceModel>> listServiceModerationQueue({ModerationStatus status = ModerationStatus.pending});
  Stream<List<ServiceRequestModel>> listRequestModerationQueue({ModerationStatus status = ModerationStatus.pending});
  Future<void> moderateService(String id, ModerationStatus status, {String? reason});
  Future<void> moderateRequest(String id, ModerationStatus status, {String? reason});
  Future<void> createLocalizedBroadcast({required String title, required String message, String? country, String? region, String? city});
  
  Stream<List<Map<String, dynamic>>> listTemplates();
  Future<void> upsertTemplate(String id, List<String> visibleFields, {String? configJson, String? accentColor, String? iconName});

  // ─── 6. Discovery & Helpers ──────────────────────────────────────────────
  Stream<Map<String, dynamic>> getSystemStats();

  // ─── 7. Operational Governance ──────────────────────────────────────────
  Stream<List<Map<String, dynamic>>> listSosNumbers({String? countryId, String? sectorId, String? categoryId});
  Future<void> upsertSosNumber(Map<String, dynamic> sosData);
  
  Stream<List<Map<String, dynamic>>> listTokenPackages({UserRole? targetRole, bool? isActive});
  Future<void> upsertTokenPackage(Map<String, dynamic> packageData);
  
  Stream<List<Map<String, dynamic>>> listElementPricing();
  Future<void> updateElementPricing(String id, int tokenCost, {int? validityDays});
  
  Stream<List<Map<String, dynamic>>> listBroadcastModerationQueue({ModerationStatus status = ModerationStatus.pending});
  Future<void> moderateBroadcast(String id, ModerationStatus status, {String? reason});
  
  Future<List<WalletTransactionModel>> getFinanceStats({DateTime? start, DateTime? end});
  Future<void> refundTransaction(String id, String reason);
  
  Future<List<Map<String, dynamic>>> getAnalyticsSnapshots({DateTime? start, DateTime? end});
  Future<void> createAnalyticsSnapshot(Map<String, dynamic> data);
  
  Future<String?> getAppConfig(String key);
  Future<void> updateAppConfig(String key, String value);
  Stream<List<Map<String, dynamic>>> listAppConfigs();

  // Service Metrics
  Future<Map<String, dynamic>?> getServiceMetric(String serviceId);
  Future<void> incrementServiceMetric(String serviceId, {int views = 0, int contacts = 0, int shares = 0});

  // User side broadcasts
  Stream<List<Map<String, dynamic>>> listActiveBroadcasts({String? country, UserRole? role});
}
