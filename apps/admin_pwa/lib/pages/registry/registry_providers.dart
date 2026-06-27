import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/firestore_service.dart';
import 'package:shared_core/models/professional_model.dart';
import 'package:shared_core/models/service_model.dart';
import 'package:shared_core/models/visitor_model.dart';

import 'package:rxdart/rxdart.dart';

final professionalsStreamProvider = StreamProvider<List<ProfessionalModel>>((ref) {
  return ref.watch(firestoreServiceProvider).watchAllProfessionals();
});

final institutionsStreamProvider = StreamProvider<List<ProfessionalModel>>((ref) {
  return ref.watch(firestoreServiceProvider).watchAllInstitutions();
});

final servicesStreamProvider = StreamProvider<List<ServiceModel>>((ref) {
  return ref.watch(firestoreServiceProvider).watchAllServices();
});

final visitorsStreamProvider = StreamProvider<List<VisitorModel>>((ref) {
  return ref.watch(firestoreServiceProvider).watchAllVisitors();
});

final communityRequestsStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(firestoreServiceProvider).watchCommunityRequests();
});
