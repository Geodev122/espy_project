import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firestore_service.dart';

final tokenPricingStreamProvider = StreamProvider<Map<String, dynamic>>((ref) {
  return ref.watch(firestoreServiceProvider).watchTokenPricing();
});

final countriesFutureProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(firestoreServiceProvider).getCountries();
});

final sectorsFutureProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(firestoreServiceProvider).getSectors();
});

final governoratesFutureProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(firestoreServiceProvider).getGovernorates();
});

final citiesFutureProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(firestoreServiceProvider).getCities();
});

final categoriesFutureProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(firestoreServiceProvider).listCollection('directory_categories');
});

final regionsFutureProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, countryId) {
  if (countryId == 'ALL') return [];
  return ref.watch(firestoreServiceProvider).getGovernorates(countryId: countryId);
});
