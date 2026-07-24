import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'theme/espy_theme.dart';
import 'package:espy_core/espy_core.dart';
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
