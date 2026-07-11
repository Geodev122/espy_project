import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:espy_app/l10n/app_localizations.dart';

import 'package:shared_core/theme/espy_theme.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/services/firestore_service.dart';
import 'package:shared_core/widgets/common/espy_scaffold.dart';
import '../auth/auth_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EspyScaffold(
      useCinematicBackground: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              FadeInDown(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ESPY PROTOCOL',
                      style: GoogleFonts.cinzel(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 6,
                        color: EspyTheme.cyan,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.definePresence.toUpperCase(),
                      style: GoogleFonts.cinzel(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    FadeInRight(
                      delay: const Duration(milliseconds: 400),
                      child: _buildRoleCard(
                        context,
                        title: l10n.professional,
                        subtitle: l10n.professionalDesc,
                        icon: Icons.medical_services_rounded,
                        color: EspyTheme.gold,
                        onTap: () => _handleRoleSelection(context, 'professional'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInRight(
                      delay: const Duration(milliseconds: 600),
                      child: _buildRoleCard(
                        context,
                        title: l10n.institution,
                        subtitle: l10n.institutionDesc,
                        icon: Icons.account_balance_rounded,
                        color: EspyTheme.cognac,
                        onTap: () => _handleRoleSelection(context, 'institution'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white.withOpacity(0.05),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: GoogleFonts.lora(fontSize: 13, color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRoleSelection(BuildContext context, String role) async {
     // ... logic
  }
}
