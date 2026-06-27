import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';

import '../../core/theme.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/services/firestore_service.dart';
import '../../widgets/common/cinematic_background.dart';
import '../auth/auth_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: CinematicBackground(
        child: Stack(
          children: [
            SafeArea(
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
                          const SizedBox(height: 12),
                          Container(
                            width: 60,
                            height: 3,
                            decoration: BoxDecoration(
                              gradient: EspyTheme.flameBlue,
                              borderRadius: BorderRadius.circular(2),
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
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
          ),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  icon,
                  size: 120,
                  color: color.withOpacity(0.05),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: color.withOpacity(0.3)),
                      ),
                      child: Icon(icon, color: color, size: 32),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title.toUpperCase(),
                            style: GoogleFonts.cinzel(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: EspyTheme.platinum,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: GoogleFonts.lora(
                              fontSize: 13,
                              color: EspyTheme.platinum.withOpacity(0.7),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: color.withOpacity(0.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRoleSelection(BuildContext context, String role) async {
    final auth = Provider.of<AuthService>(context, listen: false);

    if (auth.user == null) {
      final success = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const AuthScreen(),
      );

      if (success != true) return;
    }

    // Now user is guaranteed to be logged in. 
    // CRITICAL: Check if this email/UID already has a definitive role assigned.
    String? existingRole;

    if (auth.userData == null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(auth.user!.uid).get();
      existingRole = userDoc.data()?['role'];
    } else {
      existingRole = auth.userData?['role'];
    }

    // If the user has a profile or a non-pending role, block re-registration
    if (existingRole != null && existingRole != 'pending') {
      if (!context.mounted) return;
      _showAccountExistsDialog(context, existingRole);
      return;
    }

    // Proceed with role assignment
    final firestore = FirestoreService();
    try {
      await firestore.updateUserProfile(auth.user!.uid, {
        'role': role,
      });

      // If they were treated as a visitor (default for pending), 
      // we remove them from visitor management if they are now a provider.
      if (role == 'professional' || role == 'institution') {
        await FirebaseFirestore.instance.collection('directory_visitors').doc(auth.user!.uid).delete().catchError((e) => null);
      }
      
      // Refresh auth state to trigger MainGate rebuild
      await auth.fetchUserData();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showAccountExistsDialog(BuildContext context, String role) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: EspyTheme.platinum,
        title: Text(l10n.accountExists.toUpperCase(), style: GoogleFonts.cinzel(fontWeight: FontWeight.w900)),
        content: Text(
          '${l10n.emailAlreadyRegistered(role.toUpperCase())} ${l10n.roleLimitInfo}',
          style: GoogleFonts.lora(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: Text(l10n.goToDashboard.toUpperCase(), style: GoogleFonts.cinzel(color: EspyTheme.gold, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
