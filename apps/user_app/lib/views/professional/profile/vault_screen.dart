import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:espy_core/espy_core.dart';
import 'package:espy_app/l10n/app_localizations.dart';
import 'package:espy_app/theme/espy_theme.dart';
import '../../visitor/emergency/sos_hub_screen.dart';
import 'location_manager_screen.dart';
import 'edit_profile_screen.dart';
import 'notifications_screen.dart';
import 'privacy_vault_screen.dart';
import '../../visitor/profile/subscription_hub_screen.dart';
import 'payment_history_screen.dart';

class VaultScreen extends StatelessWidget {
  const VaultScreen({super.key});

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
                _buildVaultStatus(context, profile),
                const SizedBox(height: 32),
                _buildVaultMenu(context, authService),
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

  Widget _buildAppBar(BuildContext context, UserModel profile) {
    final bool isVisitor = profile.role == UserRole.visitor;

    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: !isVisitor, // Visitor uses Drawer from AppShell
      leading: !isVisitor && Navigator.canPop(context) ? IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: EspyTheme.navyDeep, size: 18),
        onPressed: () => Navigator.pop(context),
      ) : null,
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
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: EspyTheme.royalBlue.withValues(alpha: 0.2), width: 3),
                        boxShadow: [
                          BoxShadow(color: EspyTheme.royalBlue.withValues(alpha: 0.1), blurRadius: 20)
                        ],
                        image: profile.photoUrl != null
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(
                                    profile.photoUrl!),
                                fit: BoxFit.cover)
                            : null,
                      ),
                      child: profile.photoUrl == null
                          ? const Icon(Icons.person,
                              color: EspyTheme.navyDeep, size: 45)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profile.name.toUpperCase(),
                    style: GoogleFonts.cinzel(
                      color: EspyTheme.navyDeep,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      color: EspyTheme.royalBlue.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: EspyTheme.royalBlue.withValues(alpha: 0.1)),
                    ),
                    child: Text(
                      isVisitor ? 'VISITOR' : (profile['verificationStatus'] == 'verified' || profile['isApproved'] == true ? 'VERIFIED NODE' : 'PENDING VERIFICATION'),
                      style: GoogleFonts.cinzel(
                        color: EspyTheme.royalBlue,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: EspyTheme.gold.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: EspyTheme.gold.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.favorite_rounded, color: EspyTheme.gold, size: 10),
                        const SizedBox(width: 6),
                        Text(
                          "${profile['favoriteCount'] ?? 0} PROTOCOL FAVS",
                          style: GoogleFonts.cinzel(
                            color: EspyTheme.gold,
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
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

  Widget _buildVaultStatus(BuildContext context, UserModel profile) {
    final bool isVisitor = profile.role == UserRole.visitor;
    final bool isPaid = isVisitor || profile['paymentStatus'] == 'completed' || profile['isPaid'] == true;
    final bool isPendingPro = !isPaid && (profile.role == UserRole.professional || profile.role == UserRole.institution);
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        if (isPendingPro)
          FadeInDown(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: EspyTheme.error.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: EspyTheme.error.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: EspyTheme.error),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.paymentPending.toUpperCase(), style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 12, color: EspyTheme.error)),
                        Text(l10n.profileHiddenDesc, style: GoogleFonts.lora(fontSize: 11, color: Colors.black54)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionHubScreen()));
                    },
                    child: Text(l10n.fundNow.toUpperCase(), style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 10, color: EspyTheme.gold)),
                  ),
                ],
              ),
            ),
          ),
        FadeInUp(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
              border: Border.all(
                color: isPaid ? EspyTheme.success.withValues(alpha: 0.2) : EspyTheme.gold.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ]
            ),
            child: Row(
              children: [
                Icon(isPaid ? Icons.verified_user_rounded : Icons.hourglass_empty_rounded,
                    color: isPaid ? EspyTheme.success : EspyTheme.gold, size: 40),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isPaid ? l10n.identityVerified.toUpperCase() : l10n.pendingActivationShort.toUpperCase(),
                        style: GoogleFonts.cinzel(
                            fontWeight: FontWeight.w900, fontSize: 14, color: EspyTheme.navyDeep),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isPaid
                          ? (isVisitor ? l10n.visitorVerifiedDesc : l10n.identityVerifiedDesc)
                          : l10n.pendingActivationDescShort,
                        style: GoogleFonts.lora(
                            fontSize: 12,
                            color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVaultMenu(BuildContext context, AuthService auth) {
    final role = auth.userData?.role;
    final bool isVisitor = role == UserRole.visitor;
    final localeService = Provider.of<LocaleService>(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        if (isVisitor)
          _buildMenuItem(Icons.contact_phone_rounded, l10n.emergencyAddressBook.toUpperCase(), () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const SOSHubScreen()));
          }),
        _buildMenuItem(Icons.language_rounded, '${l10n.language.toUpperCase()}: ${localeService.locale.languageCode.toUpperCase()}', () {
          localeService.toggleLocale();
        }),
        _buildMenuItem(Icons.map_outlined, l10n.locationSettings.toUpperCase(), () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => LocationManagerScreen()));
        }),
        _buildMenuItem(Icons.credit_card_rounded, l10n.vaultSubscriptions.toUpperCase(), () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const SubscriptionHubScreen()));
        }),
        if (!isVisitor)
          _buildMenuItem(Icons.history_rounded, "PAYMENT PROTOCOLS", () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const PaymentHistoryScreen()));
          }),
        _buildMenuItem(Icons.edit_outlined, l10n.editProfile.toUpperCase(), () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const EditProfileScreen()));
        }),
        _buildMenuItem(
            Icons.notifications_none_rounded, l10n.notifications.toUpperCase(), () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const NotificationsScreen()));
        }),
        _buildMenuItem(Icons.shield_moon_outlined, l10n.privacyVault.toUpperCase(), () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const PrivacyVaultScreen()));
        }),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return FadeInLeft(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))
          ]
        ),
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon,
              color: EspyTheme.navyDeep.withValues(alpha: 0.6), size: 24),
          title: Text(
            label,
            style: GoogleFonts.cinzel(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: EspyTheme.navyDeep,
            ),
          ),
          trailing:
              const Icon(Icons.chevron_right_rounded, size: 20, color: EspyTheme.gold),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildSignOut(BuildContext context, AuthService auth) {
    final l10n = AppLocalizations.of(context)!;
    return FadeInUp(
      child: TextButton(
        onPressed: () => auth.signOut(),
        child: Text(
          l10n.signOutProtocol.toUpperCase(),
          style: GoogleFonts.cinzel(
            color: EspyTheme.error,
            fontWeight: FontWeight.w900,
            fontSize: 11,
            letterSpacing: 2.5,
          ),
        ),
      ),
    );
  }
}
