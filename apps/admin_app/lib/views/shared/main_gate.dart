import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:espy_core/espy_core.dart';
import 'package:espy_app/theme/espy_theme.dart';

import 'app_shell.dart';
import 'onboarding/splash_screen.dart';
import 'onboarding/welcome_screen.dart';
import 'onboarding/suspension_screen.dart';

class MainGate extends StatelessWidget {
  const MainGate({super.key});

  @override
  Widget build(BuildContext context) {
    final debug = DebugService();
    return Consumer<AuthService>(
      builder: (context, auth, _) {
        if (auth.isInitializing || auth.isLoading || auth.isProvisioning) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: EspyTheme.gold),
                  if (auth.isProvisioning || auth.isInitializing) ...[
                    const SizedBox(height: 24),
                    Text(auth.isProvisioning ? "SYNCHRONIZING PROTOCOL..." : "INITIALIZING IDENTITY...", 
                      style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, color: EspyTheme.gold, fontSize: 10, letterSpacing: 2)),
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
          if (auth.isLoading || auth.isProvisioning) {
            return const SplashScreen();
          }
          // If not loading and no data, we are in a "Missing Profile" state
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
                    ElevatedButton(
                      onPressed: () => auth.fetchUserData(),
                      child: const Text("RETRY SYNCHRONIZATION"),
                    ),
                    TextButton(
                      onPressed: () => auth.signOut(),
                      child: const Text("TERMINATE SESSION"),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final user = auth.userData!;
        debug.log('GATE', 'Role: ${user.role}, IsActive: ${user.isActive}');

        // Check for Admin Role or Super Admin Bypass
        final bool isSuperAdmin = ['geo.elnajjar@gmail.com', 'admin@espy.com'].contains(auth.user?.email);
        if (user.role != UserRole.admin && !isSuperAdmin) {
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
