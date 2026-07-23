import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:espy_app/viewmodels/debug_service.dart';
import 'package:espy_app/viewmodels/platform/web_helper.dart';
import 'package:espy_app/viewmodels/auth_service.dart';
import 'package:espy_app/models/user_model.dart';

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
        if (auth.isLoading) {
          return const SplashScreen();
        }

        if (auth.user == null) {
          return const WelcomeScreen();
        }

        // Handle WhishPay Return (PWA)
        if (kIsWeb) {
          final url = WebHelper.currentUrl;
          if (url.contains('payment/return')) {
            // Robust parameter extraction for hash-routing
            final String cleanUrl = url.replaceFirst('/#/', '/');
            final uri = Uri.parse(cleanUrl);
            final status = uri.queryParameters['status'] ?? 'pending';
            return PaymentResultScreen(status: status);
          }
        }

        // Check if user data is still being fetched after auth state changed
        if (auth.userData == null) {
          return const SplashScreen(); 
        }

        final user = auth.userData!;
        _debug.log('GATE', 'Role: ${user.role}, HasProfile: ${user.hasProfile}');

        // Check for account suspension
        if (!user.isActive) {
          return const SuspensionScreen();
        }

        // Check if user is fully onboarded
        if (!user.hasProfile) {
          final role = user.role;
          if (role == UserRole.pending) {
            return const RoleSelectionScreen();
          } else if (role == UserRole.professional) {
            return const ProfessionalWizard();
          } else if (role == UserRole.institution) {
            return const InstitutionWizard();
          } else if (role == UserRole.visitor) {
            return const VisitorWizard();
          } else {
            return const RoleSelectionScreen();
          }
        }

        // Standard entry point
        return const AppShell();
      },
    );
  }
}
