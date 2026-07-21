import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import 'app.dart';
import 'viewmodels/auth_service.dart';
import 'utils/firebase_config.dart';
import 'viewmodels/firestore_service.dart';
import 'viewmodels/user_service.dart';
import 'viewmodels/storage_service.dart';
import 'viewmodels/whish_pay_service.dart';
import 'viewmodels/locale_service.dart';
import 'viewmodels/directory_view_model.dart';
import 'viewmodels/admin_dashboard_view_model.dart';
import 'viewmodels/dashboard_view_model.dart';
import 'viewmodels/wallet_view_model.dart';
import 'viewmodels/matching_view_model.dart';
import 'viewmodels/requests_view_model.dart';
import 'viewmodels/services_view_model.dart';
import 'viewmodels/espy_repository.dart';
import 'viewmodels/firestore_espy_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Platform Error: $error');
    return true;
  };

  try {
    await Firebase.initializeApp(
      options: FirebaseConfig.currentPlatform,
    );

    try {
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
    } catch (e) {
      debugPrint('Firestore Settings Error: $e');
    }
  } catch (e) {
    debugPrint('Firebase Initialization Error: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        Provider<EspyRepository>(create: (_) => FirestoreEspyRepository()),
        ChangeNotifierProxyProvider<EspyRepository, AuthService>(
          create: (context) => AuthService(context.read<EspyRepository>()),
          update: (context, repo, previous) => AuthService(repo),
        ),
        ChangeNotifierProxyProvider<EspyRepository, UserService>(
          create: (context) => UserService(context.read<EspyRepository>()),
          update: (context, repo, previous) => UserService(repo),
        ),
        ChangeNotifierProvider(create: (_) => LocaleService()),
        ChangeNotifierProxyProvider<EspyRepository, DirectoryViewModel>(
          create: (context) => DirectoryViewModel(context.read<EspyRepository>()),
          update: (context, repo, previous) => DirectoryViewModel(repo),
        ),
        ChangeNotifierProxyProvider<EspyRepository, AdminDashboardViewModel>(
          create: (context) => AdminDashboardViewModel(context.read<EspyRepository>()),
          update: (context, repo, previous) => AdminDashboardViewModel(repo),
        ),
        ChangeNotifierProxyProvider2<AuthService, EspyRepository, DashboardViewModel>(
          create: (context) => DashboardViewModel(context.read<AuthService>(), context.read<EspyRepository>()),
          update: (context, auth, repo, previous) => DashboardViewModel(auth, repo),
        ),
        ChangeNotifierProxyProvider2<AuthService, EspyRepository, WalletViewModel>(
          create: (context) => WalletViewModel(context.read<AuthService>(), context.read<EspyRepository>()),
          update: (context, auth, repo, previous) => WalletViewModel(auth, repo),
        ),
        ChangeNotifierProxyProvider2<EspyRepository, AuthService, MatchingViewModel>(
          create: (context) => MatchingViewModel(context.read<EspyRepository>(), context.read<AuthService>()),
          update: (context, repo, auth, previous) => MatchingViewModel(repo, auth),
        ),
        ChangeNotifierProxyProvider2<EspyRepository, AuthService, RequestsViewModel>(
          create: (context) => RequestsViewModel(context.read<EspyRepository>(), context.read<AuthService>()),
          update: (context, repo, auth, previous) => RequestsViewModel(repo, auth),
        ),
        ChangeNotifierProxyProvider2<EspyRepository, AuthService, ServicesViewModel>(
          create: (context) => ServicesViewModel(context.read<EspyRepository>(), context.read<AuthService>()),
          update: (context, repo, auth, previous) => ServicesViewModel(repo, auth),
        ),
        Provider(create: (_) => FirestoreService()),
        Provider(create: (_) => StorageService()),
        Provider(create: (_) => WhishPayService()),
      ],
      child: const EspyApp(),
    ),
  );
}
