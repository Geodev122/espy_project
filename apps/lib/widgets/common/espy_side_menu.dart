import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:animate_do/animate_do.dart';

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
import '../../screens/profile/token_shop_screen.dart';
import '../../screens/profile/wallet_screen.dart';
import '../../screens/profile/location_manager_screen.dart';
import '../../screens/profile/payment_history_screen.dart';
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
            _buildHeader(context, profile, role, authService),
            const Divider(color: Colors.black12, thickness: 1, indent: 32, endIndent: 32),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                children: [
                  _buildSectionHeader('IDENTITY PROTOCOLS'),
                  _buildMenuItem(context, LucideIcons.user, 'MY IDENTITY', const EditProfileScreen()),
                  _buildMenuItem(context, LucideIcons.mapPin, 'LOCATION NODES', const LocationManagerScreen()),
                  _buildMenuItem(context, Icons.favorite_border_rounded, 'FAVORITE BASKET', const VaultFavoritesScreen()),

                  const SizedBox(height: 16),
                  _buildSectionHeader('FINANCIAL PROTOCOLS'),
                  _buildMenuItem(context, LucideIcons.history, 'PAYMENT LEDGER', const PaymentHistoryScreen()),
                  if (isProOrInst) ...[
                    _buildMenuItem(context, Icons.credit_card_rounded, 'SUBSCRIPTION VAULT', const SubscriptionHubScreen()),
                  ],
                  _buildMenuItem(context, LucideIcons.shieldCheck, 'PRIVACY VAULT', const PrivacyVaultScreen()),

                  const SizedBox(height: 16),
                  _buildSectionHeader('NETWORK SIGNALS'),
                  if (isProOrInst) ...[
                    _buildMenuItem(context, Icons.campaign_rounded, 'DISPATCH BROADCAST', const BroadcastScreen()),
                  ],
                  _buildMenuItem(context, Icons.analytics_outlined, 'NETWORK LOGS', const AnnouncementsScreen()),
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
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 8,
          fontWeight: FontWeight.w900,
          color: EspyTheme.navyDeep.withOpacity(0.4),
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Map<String, dynamic> profile, String role, AuthService auth) {
    final userData = auth.userData;
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 24),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: EspyTheme.royalBlue.withOpacity(0.2), width: 2),
                  image: profile['photoUrl'] != null
                      ? DecorationImage(image: CachedNetworkImageProvider(profile['photoUrl']), fit: BoxFit.cover)
                      : null,
                ),
                child: profile['photoUrl'] == null
                    ? const Icon(Icons.person_rounded, color: EspyTheme.navyDeep, size: 30)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile['name']?.toString().toUpperCase() ?? role.toUpperCase(),
                      style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep, letterSpacing: 1),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      role.toUpperCase(),
                      style: GoogleFonts.montserrat(fontSize: 7, fontWeight: FontWeight.w900, color: EspyTheme.royalBlue, letterSpacing: 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (userData != null) ...[
            const SizedBox(height: 24),
            FadeInDown(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: EspyTheme.premiumCardDecoration.copyWith(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('BALANCE',
                              style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1)),
                            Row(
                              children: [
                                Text('${userData.walletBalance}',
                                  style: GoogleFonts.montserrat(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                                const SizedBox(width: 4),
                                Text('\$E',
                                  style: GoogleFonts.montserrat(color: EspyTheme.gold, fontSize: 14, fontWeight: FontWeight.w900)),
                              ],
                            ),
                          ],
                        ),
                        Icon(LucideIcons.wallet, color: EspyTheme.gold, size: 20),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              SoundService.playPop();
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const TokenShopScreen(initialTab: 0)));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(color: EspyTheme.gold, borderRadius: BorderRadius.circular(10)),
                              alignment: Alignment.center,
                              child: Text('RECHARGE', style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 8, color: EspyTheme.navyDeep)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              SoundService.playPop();
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const TokenShopScreen(initialTab: 1)));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(border: Border.all(color: Colors.white38), borderRadius: BorderRadius.circular(10)),
                              alignment: Alignment.center,
                              child: Text('STORE', style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 8, color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
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
            SoundService.playPop();
            Navigator.pop(context); // Close drawer
            Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: EspyTheme.navyDeep.withOpacity(0.6), size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w800, color: EspyTheme.navyDeep, letterSpacing: 0.5),
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
            side: BorderSide(color: EspyTheme.error.withOpacity(0.3)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.power_settings_new_rounded, color: EspyTheme.error, size: 18),
            const SizedBox(width: 12),
            Text(
              'TERMINATE PROTOCOL',
              style: GoogleFonts.montserrat(color: EspyTheme.error, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1),
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
          style: GoogleFonts.montserrat(color: Colors.white10, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
