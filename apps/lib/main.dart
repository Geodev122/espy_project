import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import 'core/theme.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/services/firebase_config.dart';
import 'package:shared_core/services/firestore_service.dart';
import 'package:shared_core/services/user_service.dart';
import 'package:shared_core/services/storage_service.dart';
import 'package:shared_core/services/whish_pay_service.dart';
import 'package:shared_core/services/locale_service.dart';
import 'package:shared_core/services/directory_view_model.dart';
import 'package:shared_core/viewmodels/dashboard_view_model.dart';
import 'package:shared_core/viewmodels/wallet_view_model.dart';
import 'package:shared_core/viewmodels/matching_view_model.dart';
import 'package:shared_core/viewmodels/requests_view_model.dart';
import 'package:shared_core/viewmodels/services_view_model.dart';
import 'package:shared_core/services/espy_repository.dart';
import 'package:shared_core/services/firestore_espy_repository.dart';

import 'views/shared/main_gate.dart';

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
        Provider<EspyRepository>(create: (_) => FirestoreEspyRepository()),
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

class EspyApp extends StatelessWidget {
  const EspyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleService>(
      builder: (context, localeService, _) {
        return MaterialApp(
          title: 'Espy',
          debugShowCheckedModeBanner: false,
          theme: EspyTheme.metallicTheme,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), 
            Locale('ar', ''),
          ],
          locale: localeService.locale,
          home: const MainGate(),
        );
      },
    );
  }
}
