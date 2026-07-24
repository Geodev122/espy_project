import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:espy_core/espy_core.dart';
import 'package:espy_app/l10n/app_localizations.dart';
import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/widgets/common/premium_button.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';
import '../auth/auth_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Future<void> _navigateToAuth(BuildContext context, {String? role, bool isSignUp = false}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AuthScreen(initialRole: role, isSignUpInitial: isSignUp),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EspyScaffold(
      useCinematicBackground: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned(
            top: 48,
            right: 24,
            child: Consumer<LocaleService>(
              builder: (context, localeService, _) {
                return TextButton(
                  onPressed: () => localeService.toggleLocale(),
                  style: TextButton.styleFrom(backgroundColor: Colors.white.withValues(alpha: 0.1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: Text(localeService.locale.languageCode == 'en' ? 'AR' : 'EN', style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, color: EspyTheme.gold, letterSpacing: 1)),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  const Spacer(),
                  FadeIn(
                    duration: const Duration(milliseconds: 2000),
                    child: Hero(
                      tag: 'espy_icon',
                      child: Image.asset('assets/images/espy_icon.png', width: 160, fit: BoxFit.contain, 
                        errorBuilder: (_, __, ___) => const Icon(Icons.auto_awesome_rounded, size: 100, color: EspyTheme.skyBlue)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    child: Column(
                      children: [
                        Text(l10n.appTitle.toUpperCase(), style: EspyTheme.wordmarkStyle.copyWith(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 12, color: Colors.white, height: 1.0)),
                        const SizedBox(height: 16),
                        Text(l10n.hopeHealingHumanity.toUpperCase(), style: EspyTheme.taglineStyle.copyWith(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 4, color: EspyTheme.textOnDarkMuted)),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                  FadeInUp(
                    delay: const Duration(milliseconds: 700),
                    child: Column(
                      children: [
                        PremiumButton(
                          label: l10n.findHope.toUpperCase(),
                          fullWidth: true,
                          variant: PremiumButtonVariant.cyan,
                          icon: Icons.person_search_rounded,
                          onPressed: () => _navigateToAuth(context, role: 'visitor', isSignUp: true),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: PremiumButton(
                                label: l10n.professional.toUpperCase(),
                                variant: PremiumButtonVariant.gold,
                                icon: Icons.medical_services_rounded,
                                onPressed: () => _navigateToAuth(context, role: 'professional', isSignUp: true),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: PremiumButton(
                                label: l10n.institution.toUpperCase(),
                                variant: PremiumButtonVariant.gold,
                                icon: Icons.account_balance_rounded,
                                onPressed: () => _navigateToAuth(context, role: 'institution', isSignUp: true),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        PremiumButton(
                          label: l10n.login.toUpperCase(),
                          fullWidth: true,
                          variant: PremiumButtonVariant.platinum,
                          icon: Icons.login_rounded,
                          onPressed: () => _navigateToAuth(context, isSignUp: false),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
