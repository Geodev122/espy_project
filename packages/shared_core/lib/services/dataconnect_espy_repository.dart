import 'espy_repository.dart';
import '../models/user_model.dart';

/**
 * Repository implementation for Firebase DataConnect (PostgreSQL)
 * This will use the generated SDK classes once deployed.
 */
class DataConnectEspyRepository implements EspyRepository {
  // final EspyConnector _db = EspyConnector.instance;

  @override
  Future<UserModel?> getUser(String uid) async {
    // final result = await _db.getUser.execute(uid: uid);
    // return result.data != null ? UserModel.fromMap(result.data!.user) : null;
    return null; 
  }

  @override
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    // await _db.updateUserProfile.execute(id: uid, name: data['name']);
  }

  @override
  Stream<List<Map<String, dynamic>>> getAllProviders() {
    // return _db.listProviders.subscribe().map((snap) => snap.data.professionals);
    return Stream.value([]);
  }

  @override
  Stream<List<Map<String, dynamic>>> getSectors() {
    return Stream.value([]);
  }

  @override
  Stream<List<Map<String, dynamic>>> getCountries() {
    return Stream.value([]);
  }

  @override
  Stream<List<Map<String, dynamic>>> getUserTransactions(String uid) {
    // return _db.getUserTransactions.subscribe(uid: uid).map((s) => s.data.transactions);
    return Stream.value([]);
  }

  @override
  Future<Map<String, dynamic>> spendTokens({required String userId, required String itemId, required int cost, required String role}) async {
    // switch(itemId) {
    //   case 'extra_pin': await _db.spendTokensForPin.execute(userId: userId, cost: cost);
    // }
    return {'success': true};
  }

  @override
  Stream<List<Map<String, dynamic>>> getActiveServices() {
    return Stream.value([]);
  }

  @override
  Stream<List<String>> getContactedIds(String userId) {
    return Stream.value([]);
  }

  @override
  Stream<List<String>> getFavoriteIds(String userId) {
    return Stream.value([]);
  }

  @override
  Stream<List<Map<String, dynamic>>> getProfessionalServices(String professionalId) {
    return Stream.value([]);
  }

  @override
  Future<void> toggleServiceSlot(String serviceId, bool allocate) async {
  }

  @override
  Future<void> recordInteraction({required String userId, required String targetId, required String type}) async {
  }

  @override
  Future<void> toggleFavorite(String userId, String professionalId, bool isFavorite) async {
  }

  @override
  Stream<List<Map<String, dynamic>>> getCommunityRequests({String? sectionId, bool newestFirst = true, String? userId}) {
    return Stream.value([]);
  }

  @override
  Future<void> favoriteRequest(String userId, String requestId, bool isFavorite) async {
  }
}
