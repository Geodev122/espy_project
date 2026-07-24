import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/viewmodels/debug_service.dart';
import 'package:espy_app/viewmodels/platform/web_helper.dart';
import 'package:espy_app/viewmodels/auth_service.dart';
import 'package:espy_app/models/user_model.dart';
import 'package:espy_app/models/enums.dart';

import 'app_shell.dart';
import 'onboarding/splash_screen.dart';
import 'onboarding/welcome_screen.dart';
import 'onboarding/role_selection_screen.dart';
import 'onboarding/payment_result_screen.dart';
import 'onboarding/suspension_screen.dart';
import '../professional/profile/professional_wizard.dart';
import '../professional/profile/institution_wizard.dart';
import '../visitor/profile/visitor_wizard.dart';

class MainGate extends StatelessWidget {
  const MainGate({super.key});

  @override
  Widget build(BuildContext context) {
    final _debug = DebugService();
    return Consumer<AuthService>(
      builder: (context, auth, _) {
        if (auth.isInitializing || auth.isLoading || auth.isProvisioning) {
          return const SplashScreen();
        }

        if (auth.user == null) {
          return const WelcomeScreen();
        }

        // Handle WhishPay Return (PWA)
        if (kIsWeb) {
          final url = WebHelper.currentUrl;
          if (url.contains('payment/return')) {
            final String cleanUrl = url.replaceFirst('/#/', '/');
            final uri = Uri.parse(cleanUrl);
            final status = uri.queryParameters['status'] ?? 'pending';
            return PaymentResultScreen(status: status);
          }
        }

        if (auth.userData == null) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.account_circle_outlined, size: 64, color: EspyTheme.gold),
                    const SizedBox(height: 24),
                    Text("PROFILE NOT FOUND", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 18)),
                    const SizedBox(height: 12),
                    const Text("Your account is authenticated but no protocol profile exists.", textAlign: TextAlign.center),
                    const SizedBox(height: 32),
                    ElevatedButton(onPressed: () => auth.fetchUserData(), child: const Text("RETRY SYNC")),
                    TextButton(onPressed: () => auth.signOut(), child: const Text("SIGN OUT")),
                  ],
                ),
              ),
            ),
          );
        }

        final user = auth.userData!;
        _debug.log('GATE', 'Role: ${user.role}, HasProfile: ${user.hasProfile}');

        if (!user.isActive) {
          return const SuspensionScreen();
        }

        if (!user.hasProfile) {
          final role = user.role;
          if (role == UserRole.pending) return const RoleSelectionScreen();
          if (role == UserRole.professional) return const ProfessionalWizard();
          if (role == UserRole.institution) return const InstitutionWizard();
          if (role == UserRole.visitor) return const VisitorWizard();
          return const RoleSelectionScreen();
        }

        return const AppShell();
      },
    );
  }
}
