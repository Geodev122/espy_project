import '../models/user_model.dart';

abstract class EspyRepository {
  // Identity
  Future<UserModel?> getUser(String uid);
  Future<void> updateUser(String uid, Map<String, dynamic> data);

  // Discovery
  Stream<List<Map<String, dynamic>>> getAllProviders();
  Stream<List<Map<String, dynamic>>> getSectors();
  Stream<List<Map<String, dynamic>>> getCountries();

  // Transactions
  Stream<List<Map<String, dynamic>>> getUserTransactions(String uid);
  Future<Map<String, dynamic>> spendTokens({required String userId, required String itemId, required int cost, required String role});

  // Services
  Stream<List<Map<String, dynamic>>> getActiveServices();
  Stream<List<Map<String, dynamic>>> getProfessionalServices(String professionalId);
  Future<void> toggleServiceSlot(String serviceId, bool allocate);

  // Interactions & Favorites
  Future<void> recordInteraction({required String userId, required String targetId, required String type});
  Future<void> toggleFavorite(String userId, String professionalId, bool isFavorite);
  Stream<List<String>> getFavoriteIds(String userId);
  Stream<List<String>> getContactedIds(String userId);

  // Community Requests
  Stream<List<Map<String, dynamic>>> getCommunityRequests({String? sectionId, bool newestFirst = true, String? userId});
  Future<void> favoriteRequest(String userId, String requestId, bool isFavorite);
}
