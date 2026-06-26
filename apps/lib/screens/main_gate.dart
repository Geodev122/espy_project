import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_core/services/platform/web_helper.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/models/user_model.dart';

import 'app_shell.dart';
import 'onboarding/splash_screen.dart';
import 'onboarding/welcome_screen.dart';
import 'onboarding/role_selection_screen.dart';
import 'onboarding/payment_result_screen.dart';
import 'onboarding/suspension_screen.dart';
import 'profile/professional_wizard.dart';
import 'profile/institution_wizard.dart';

class MainGate extends StatelessWidget {
  const MainGate({super.key});

  @override
  Widget build(BuildContext context) {
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

        // Check for account suspension
        if (!user.isActive) {
          return const SuspensionScreen();
        }

        // Check if user is fully onboarded
        if (!user.hasProfile) {
          if (user.role == UserRole.pending) {
            return const RoleSelectionScreen();
          } else if (user.role == UserRole.professional) {
            return const ProfessionalWizard();
          } else if (user.role == UserRole.institution) {
            return const InstitutionWizard();
          } else {
            // Pro App shouldn't handle visitor wizard
            return const RoleSelectionScreen();
          }
        }

        // Standard entry point
        return const AppShell();
      },
    );
  }
}
