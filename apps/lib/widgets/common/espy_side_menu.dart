import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/services/user_service.dart';
import '../../screens/profile/edit_profile_screen.dart';
import '../../screens/profile/notifications_screen.dart';
import '../../screens/profile/privacy_vault_screen.dart';
import '../../screens/community/announcements_screen.dart';
import '../../screens/services/broadcast_screen.dart';
import '../../screens/profile/subscription_hub_screen.dart';
import '../../screens/profile/vault_favorites_screen.dart';
import 'package:shared_core/services/sound_service.dart';

class EspySideMenu extends StatelessWidget {
  const EspySideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final authService = Provider.of<AuthService>(context);
    final profile = userService.profile ?? {};
    final String role = profile['role']?.toString().toLowerCase() ?? 'visitor';
    final bool isProOrInst = role == 'professional' || role == 'institution';

    return Container(
      decoration: const BoxDecoration(
        gradient: EspyTheme.lightBlueFlame,
      ),
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
                  _buildMenuItem(context, Icons.person_outline_rounded, 'IDENTITY VAULT', const EditProfileScreen()),
                  _buildMenuItem(context, Icons.favorite_border_rounded, 'FAVORITE BASKET', const VaultFavoritesScreen()),

                  if (isProOrInst) ...[
                    _buildMenuItem(context, Icons.campaign_rounded, 'DISPATCH BROADCAST', const BroadcastScreen()),
                    _buildMenuItem(context, Icons.credit_card_rounded, 'SUBSCRIPTION VAULT', const SubscriptionHubScreen()),
                  ],

                  _buildMenuItem(context, Icons.analytics_outlined, 'NETWORK LOGS', const AnnouncementsScreen()),
                  _buildMenuItem(context, Icons.notifications_none_rounded, 'SIGNAL CENTER', const NotificationsScreen()),
                  _buildMenuItem(context, Icons.shield_rounded, 'PROTOCOL POLICY', const PrivacyVaultScreen()),
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

  Widget _buildHeader(Map<String, dynamic> profile, String role) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: EspyTheme.royalBlue.withValues(alpha: 0.2), width: 3),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20)
              ],
              image: profile['photoUrl'] != null
                  ? DecorationImage(image: CachedNetworkImageProvider(profile['photoUrl']), fit: BoxFit.cover)
                      : null,
            ),
            child: profile['photoUrl'] == null
                ? const Icon(Icons.person_rounded, color: EspyTheme.navyDeep, size: 40)
                : null,
          ),
          const SizedBox(height: 20),
          Text(
            profile['name']?.toString().toUpperCase() ?? role.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep, letterSpacing: 1.5),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            decoration: BoxDecoration(
              color: EspyTheme.royalBlue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: EspyTheme.royalBlue.withValues(alpha: 0.1)),
            ),
            child: Text(
              role.toUpperCase(),
              style: GoogleFonts.cinzel(fontSize: 8, fontWeight: FontWeight.w900, color: EspyTheme.royalBlue, letterSpacing: 2),
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
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            SoundService.playPop();
            Navigator.pop(context); // Close drawer
            Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: EspyTheme.navyDeep.withValues(alpha: 0.6), size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.cinzel(fontSize: 11, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep, letterSpacing: 1),
                  ),
                ),
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
        onPressed: () {
          auth.signOut();
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: EspyTheme.error.withValues(alpha: 0.3)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.power_settings_new_rounded, color: EspyTheme.error, size: 18),
            const SizedBox(width: 12),
            Text(
              'TERMINATE PROTOCOL',
              style: GoogleFonts.cinzel(color: EspyTheme.error, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          'ESPY PROTOCOL V2.3.4',
          style: GoogleFonts.cinzel(color: Colors.white10, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
