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

import 'screens/main_gate.dart';

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
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => LocaleService()),
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
          title: 'Espy Professional',
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
