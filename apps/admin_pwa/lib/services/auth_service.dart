import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/services/auth_service.dart' as shared;

final authServiceProvider = Provider<shared.AuthService>((ref) => shared.AuthService());

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

final isAdminProvider = FutureProvider<bool>((ref) async {
  try {
    return await ref.read(authServiceProvider).checkIsAdmin();
  } catch (e) {
    debugPrint('isAdmin check failed: $e');
    return false;
  }
});
