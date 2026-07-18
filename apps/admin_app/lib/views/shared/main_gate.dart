import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:espy_app/viewmodels/platform/web_helper.dart';
import 'package:espy_app/viewmodels/auth_service.dart';
import 'package:espy_app/models/user_model.dart';

import 'app_shell.dart';
import 'onboarding/splash_screen.dart';
import 'onboarding/welcome_screen.dart';
import 'onboarding/suspension_screen.dart';

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

        if (auth.userData == null) {
          return const SplashScreen(); 
        }

        final user = auth.userData!;

        // Check for Admin Role
        if (user.role != UserRole.admin) {
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
