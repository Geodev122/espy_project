import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/viewmodels/debug_service.dart';
import 'package:espy_app/viewmodels/auth_service.dart';
import 'package:espy_app/models/user_model.dart' as models;

import 'app_shell.dart';
import 'onboarding/splash_screen.dart';
import 'onboarding/welcome_screen.dart';
import 'onboarding/suspension_screen.dart';

class MainGate extends StatelessWidget {
  const MainGate({super.key});

  @override
  Widget build(BuildContext context) {
    final _debug = DebugService();
    return Consumer<AuthService>(
      builder: (context, auth, _) {
        if (auth.isLoading || auth.isProvisioning) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: EspyTheme.gold),
                  if (auth.isProvisioning) ...[
                    const SizedBox(height: 24),
                    Text("SYNCHRONIZING PROTOCOL...", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, color: EspyTheme.gold, fontSize: 10, letterSpacing: 2)),
                  ],
                ],
              ),
            ),
          );
        }

        if (auth.user == null) {
          return const WelcomeScreen();
        }

        if (auth.userData == null) {
          return const SplashScreen(); 
        }

        final user = auth.userData!;
        _debug.log('GATE', 'Role: ${user.role}, IsActive: ${user.isActive}');

        // Check for Admin Role or Super Admin Bypass
        final bool isSuperAdmin = ['geo.elnajjar@gmail.com', 'admin@espy.com'].contains(auth.user?.email);
        if (user.role != models.UserRole.admin && !isSuperAdmin) {
           return const Scaffold(
             body: Center(child: Text("ACCESS RESTRICTED: ADMINS ONLY")),
           );
        }

        if (!user.isActive) {
          return const SuspensionScreen();
        }

        return const AppShell();
      },
    );
  }
}
