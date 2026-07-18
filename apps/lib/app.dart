import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'theme/espy_theme.dart';
import 'viewmodels/auth_service.dart';
import 'viewmodels/user_service.dart';
import 'viewmodels/locale_service.dart';
import 'viewmodels/directory_view_model.dart';
import 'viewmodels/dashboard_view_model.dart';
import 'viewmodels/wallet_view_model.dart';
import 'viewmodels/matching_view_model.dart';
import 'viewmodels/requests_view_model.dart';
import 'viewmodels/services_view_model.dart';
import 'viewmodels/espy_repository.dart';
import 'viewmodels/firestore_service.dart';
import 'viewmodels/storage_service.dart';
import 'viewmodels/whish_pay_service.dart';
import 'views/shared/main_gate.dart';

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
