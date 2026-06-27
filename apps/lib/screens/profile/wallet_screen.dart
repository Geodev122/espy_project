import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:espy_pro/l10n/app_localizations.dart';
import 'package:espy_pro/core/theme.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/services/user_service.dart';
import 'package:shared_core/services/locale_service.dart';
import 'package:espy_pro/screens/emergency/sos_hub_screen.dart';
import 'package:espy_pro/screens/profile/location_manager_screen.dart';
import 'package:espy_pro/screens/profile/edit_profile_screen.dart';
import 'package:espy_pro/screens/profile/notifications_screen.dart';
import 'package:espy_pro/screens/profile/privacy_vault_screen.dart';
import 'package:espy_pro/screens/profile/token_shop_screen.dart';
import 'package:espy_pro/screens/profile/payment_history_screen.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final authService = Provider.of<AuthService>(context);
    
    if (userService.isLoading || userService.profile == null) {
       return const Scaffold(body: Center(child: CircularProgressIndicator(color: EspyTheme.gold)));
    }
    
    final profile = userService.profile!;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildAppBar(context, profile),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                _buildWalletCard(context, authService.userData!),
                const SizedBox(height: 32),
                _buildMenuGrid(context, authService),
                const SizedBox(height: 48),
                _buildSignOut(context, authService),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, Map<String, dynamic> profile) {
    final String role = profile['role']?.toString().toLowerCase() ?? 'visitor';
    final bool isVisitor = role == 'visitor';

    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  Hero(
                    tag: 'profile-avatar',
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: EspyTheme.royalBlue.withOpacity(0.2), width: 3),
                        image: profile['photoUrl'] != null
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(
                                    profile['photoUrl']),
                                fit: BoxFit.cover)
                            : null,
                      ),
                      child: profile['photoUrl'] == null
                          ? const Icon(Icons.person,
                              color: EspyTheme.navyDeep, size: 40)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile['name']?.toString().toUpperCase() ?? 'MEMBER',
                    style: GoogleFonts.montserrat(
                      color: EspyTheme.navyDeep,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isVisitor ? 'ESPY VISITOR' : 'CARE PROTOCOL NODE',
                    style: GoogleFonts.montserrat(
                      color: EspyTheme.royalBlue,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard(BuildContext context, dynamic user) {
    return FadeInDown(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: EspyTheme.premiumCardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CURRENT BALANCE', 
                      style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('${user.walletBalance}', 
                          style: GoogleFonts.montserrat(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                        const SizedBox(width: 8),
                        Text('\$E', 
                          style: GoogleFonts.montserrat(color: EspyTheme.gold, fontSize: 24, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(LucideIcons.wallet, color: EspyTheme.gold, size: 28),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const TokenShopScreen(initialTab: 0)));
                    },
                    icon: Icon(LucideIcons.plusCircle, size: 16),
                    label: const Text('RECHARGE'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: EspyTheme.gold,
                      foregroundColor: EspyTheme.navyDeep,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.5),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const TokenShopScreen(initialTab: 1)));
                    },
                    icon: Icon(LucideIcons.shoppingBag, size: 16),
                    label: const Text('STORE'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white38),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.5),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context, AuthService auth) {
    final role = auth.userData?['role'];
    final bool isVisitor = role == 'visitor';
    final localeService = Provider.of<LocaleService>(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildSmallMenuItem(LucideIcons.mapPin, 'NODES', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => LocationManagerScreen()));
            })),
            const SizedBox(width: 16),
            Expanded(child: _buildSmallMenuItem(LucideIcons.user, 'PROFILE', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
            })),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildSmallMenuItem(LucideIcons.history, 'LEDGER', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentHistoryScreen()));
            })),
            const SizedBox(width: 16),
            Expanded(child: _buildSmallMenuItem(LucideIcons.shieldCheck, 'PRIVACY', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyVaultScreen()));
            })),
          ],
        ),
        const SizedBox(height: 16),
        _buildFullMenuItem(LucideIcons.languages, 'LANGUAGE: ${localeService.locale.languageCode.toUpperCase()}', () {
          localeService.toggleLocale();
        }),
        const SizedBox(height: 16),
        _buildFullMenuItem(LucideIcons.bell, 'NOTIFICATIONS', () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
        }),
      ],
    );
  }

  Widget _buildSmallMenuItem(IconData icon, String label, VoidCallback onTap) {
    return FadeInUp(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.black.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: EspyTheme.royalBlue, size: 28),
              const SizedBox(height: 12),
              Text(label, style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep, letterSpacing: 1)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullMenuItem(IconData icon, String label, VoidCallback onTap) {
    return FadeInUp(
      child: ListTile(
        onTap: onTap,
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.black.withOpacity(0.05))),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        leading: Icon(icon, color: EspyTheme.royalBlue, size: 24),
        title: Text(label, style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep, letterSpacing: 1)),
        trailing: const Icon(Icons.chevron_right_rounded, color: EspyTheme.gold),
      ),
    );
  }

  Widget _buildSignOut(BuildContext context, AuthService auth) {
    return FadeInUp(
      child: TextButton(
        onPressed: () => auth.signOut(),
        child: Text(
          'SIGN OUT PROTOCOL',
          style: GoogleFonts.montserrat(
            color: EspyTheme.error,
            fontWeight: FontWeight.w900,
            fontSize: 11,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
