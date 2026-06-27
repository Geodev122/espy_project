import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';

import '../../core/theme.dart';
import '../../widgets/common/premium_button.dart';
import 'package:shared_core/services/locale_service.dart';
import '../auth/auth_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _showAuthModal(BuildContext context, {String? role, bool isSignUp = false}) async {
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AuthScreen(initialRole: role, isSignUpInitial: isSignUp),
    );
  }

  void _showRoleSelection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          gradient: EspyTheme.backgroundGradient,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        padding: EdgeInsets.fromLTRB(32, 24, 32, MediaQuery.of(context).padding.bottom + 32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 32),
              Text(l10n.selectMission.toUpperCase(), 
                  style: GoogleFonts.montserrat(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1)),
              const SizedBox(height: 32),
              _roleOption(
                icon: Icons.person_search_rounded,
                title: l10n.findHope,
                subtitle: 'Access network directory and signals',
                onTap: () {
                  Navigator.pop(context);
                  _showAuthModal(context, role: 'visitor', isSignUp: true);
                },
              ),
              const SizedBox(height: 16),
              _roleOption(
                icon: Icons.medical_services_rounded,
                title: l10n.registerProfessional,
                subtitle: 'List services and publish broadcasts',
                onTap: () {
                  Navigator.pop(context);
                  _showAuthModal(context, role: 'professional', isSignUp: true);
                },
              ),
              const SizedBox(height: 16),
              _roleOption(
                icon: Icons.account_balance_rounded,
                title: l10n.registerInstitution,
                subtitle: 'Corporate network governance',
                onTap: () {
                  Navigator.pop(context);
                  _showAuthModal(context, role: 'institution', isSignUp: true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleOption({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: EspyTheme.gold.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: EspyTheme.gold, size: 24),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title.toUpperCase(), style: GoogleFonts.montserrat(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: GoogleFonts.montserrat(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: EspyTheme.backgroundGradient),
        child: Stack(
          children: [
            Positioned(
              top: 48,
              right: 24,
              child: Consumer<LocaleService>(
                builder: (context, localeService, _) {
                  return TextButton(
                    onPressed: () => localeService.toggleLocale(),
                    style: TextButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
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
                          Text('ESPY', style: EspyTheme.wordmarkStyle.copyWith(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 12, color: Colors.white, height: 1.0)),
                          const SizedBox(height: 16),
                          Text('HOPE, HEALING, HUMANITY', style: EspyTheme.taglineStyle.copyWith(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 4, color: EspyTheme.textOnDarkMuted)),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    FadeInUp(
                      delay: const Duration(milliseconds: 700),
                      child: Column(
                        children: [
                          PremiumButton(
                            label: l10n.register.toUpperCase(),
                            fullWidth: true,
                            variant: PremiumButtonVariant.gold,
                            icon: Icons.person_add_rounded,
                            onPressed: () => _showAuthModal(context, isSignUp: true),
                          ),
                          const SizedBox(height: 16),
                          PremiumButton(
                            label: l10n.login.toUpperCase(),
                            fullWidth: true,
                            variant: PremiumButtonVariant.platinum,
                            icon: Icons.login_rounded,
                            onPressed: () => _showAuthModal(context, isSignUp: false),
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
      ),
    );
  }
}
