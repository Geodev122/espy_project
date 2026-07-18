import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/viewmodels/auth_service.dart';
import 'package:espy_app/viewmodels/user_service.dart';

import 'package:espy_app/views/admin/dashboard_screen.dart';

class EspySideMenu extends StatelessWidget {
  const EspySideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final authService = Provider.of<AuthService>(context);
    final profile = userService.profile ?? {};
    final String role = profile['role']?.toString().toLowerCase() ?? 'visitor';

    return Container(
      decoration: const BoxDecoration(gradient: EspyTheme.lightBlueFlame),
      child: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 8),
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, color: EspyTheme.navyDeep, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            _buildHeader(profile, role),
            const Divider(color: Colors.black12, thickness: 1, indent: 32, endIndent: 32),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                children: [
                  _buildSectionHeader('ADMIN PROTOCOLS'),
                  _buildMenuItem(context, LucideIcons.shield, 'ADMIN CONSOLE', const AdminDashboardScreen()),
                ],
              ),
            ),
            _buildSignOut(authService),
            const SizedBox(height: 40),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8, top: 8),
      child: Text(title, style: GoogleFonts.montserrat(fontSize: 8, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep.withOpacity(0.4), letterSpacing: 1.5)),
    );
  }

  Widget _buildHeader(Map<String, dynamic> profile, String role) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 24),
      child: Row(
        children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: EspyTheme.royalBlue.withOpacity(0.2), width: 2)),
            child: const Icon(Icons.person_rounded, color: EspyTheme.navyDeep, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profile['name']?.toString().toUpperCase() ?? 'ADMIN', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep, letterSpacing: 1)),
                Text(role.toUpperCase(), style: GoogleFonts.montserrat(fontSize: 7, fontWeight: FontWeight.w900, color: EspyTheme.royalBlue, letterSpacing: 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String label, Widget screen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: EspyTheme.navyDeep.withOpacity(0.6), size: 22),
                const SizedBox(width: 16),
                Expanded(child: Text(label, style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w800, color: EspyTheme.navyDeep, letterSpacing: 0.5))),
                const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.black12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignOut(AuthService auth) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      width: double.infinity,
      child: TextButton(
        onPressed: () => auth.signOut(),
        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: EspyTheme.error.withOpacity(0.3)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.power_settings_new_rounded, color: EspyTheme.error, size: 18),
            const SizedBox(width: 12),
            Text('TERMINATE PROTOCOL', style: GoogleFonts.montserrat(color: EspyTheme.error, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text('ESPY ADMIN V1.0', style: GoogleFonts.montserrat(color: Colors.white10, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 8),
      ],
    );
  }
}
