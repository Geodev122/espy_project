import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firestore_service.dart';

final tokenPricingStreamProvider = StreamProvider<Map<String, dynamic>>((ref) {
  return ref.watch(firestoreServiceProvider).watchTokenPricing();
});

final countriesStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(firestoreServiceProvider).watchCountries();
});

final sectorsStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(firestoreServiceProvider).watchSectors();
});

final governoratesStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(firestoreServiceProvider).watchGovernorates();
});

final citiesStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(firestoreServiceProvider).watchCities();
});

final categoriesStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(firestoreServiceProvider).watchCollection('directory_categories');
});

// Legacy compat or specific futures if needed
final countriesFutureProvider = FutureProvider((ref) => ref.watch(countriesStreamProvider.future));
final governoratesFutureProvider = FutureProvider((ref) => ref.watch(governoratesStreamProvider.future));
final citiesFutureProvider = FutureProvider((ref) => ref.watch(citiesStreamProvider.future));
final sectorsFutureProvider = FutureProvider((ref) => ref.watch(sectorsStreamProvider.future));
final categoriesFutureProvider = FutureProvider((ref) => ref.watch(categoriesStreamProvider.future));

final regionsFutureProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, countryId) {
  if (countryId == 'ALL') return [];
  return ref.watch(firestoreServiceProvider).getGovernorates(countryId: countryId);
});
