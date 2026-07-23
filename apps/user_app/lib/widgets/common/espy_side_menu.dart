import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/viewmodels/auth_service.dart';
import 'package:espy_app/viewmodels/wallet_view_model.dart';
import 'package:espy_app/models/user_model.dart';

// User Screens
import '../../views/professional/profile/edit_profile_screen.dart';
import '../../views/professional/profile/location_manager_screen.dart';
import '../../views/professional/profile/vault_favorites_screen.dart';
import '../../views/professional/profile/wallet_screen.dart';
import '../../views/professional/profile/payment_history_screen.dart';
import '../../views/professional/profile/token_shop_screen.dart';

class EspySideMenu extends StatelessWidget {
  const EspySideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final user = auth.userData;
    final bool isProvider = user != null && user.role != UserRole.visitor && user.role != UserRole.admin;

    return Drawer(
      backgroundColor: EspyTheme.navyDeep,
      child: SafeArea(
        child: Column(
          children: [
            _buildProfileHeader(user),
            const Divider(color: Colors.white10, height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                    _buildSectionHeader('CORE PROTOCOLS'),
                    _buildMenuItem(context, LucideIcons.user, 'MY IDENTITY', EditProfileScreen()),
                    if (isProvider)
                      _buildMenuItem(context, LucideIcons.mapPin, 'LOCATION NODES', LocationManagerScreen()),
                    _buildMenuItem(context, Icons.favorite_border_rounded, 'FAVORITE BASKET', VaultFavoritesScreen()),
                    
                    const SizedBox(height: 32),
                    _buildSectionHeader('FINANCIAL & ORDERS'),
                    _buildMenuItem(context, LucideIcons.wallet, 'WALLET', WalletScreen()),
                    _buildMenuItem(context, LucideIcons.shoppingCart, 'MY ORDERS', PaymentHistoryScreen()),
                    
                    if (isProvider) ...[
                      const SizedBox(height: 32),
                      _buildValidationNotice(context, user),
                    ],
                ],
              ),
            ),
            _buildFooter(auth),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserModel? user) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: EspyTheme.gold, width: 2),
              image: user?.photoUrl != null
                  ? DecorationImage(image: CachedNetworkImageProvider(user!.photoUrl!), fit: BoxFit.cover)
                  : null,
            ),
            child: user?.photoUrl == null ? const Icon(Icons.person, color: Colors.white) : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user?.name.toUpperCase() ?? 'IDENTIFYING...', 
                  style: GoogleFonts.cinzel(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
                Text(user?.role.name.toUpperCase() ?? 'PENDING', 
                  style: GoogleFonts.montserrat(color: EspyTheme.gold, fontWeight: FontWeight.w800, fontSize: 8, letterSpacing: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4),
      child: Text(title, style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.white38, letterSpacing: 2)),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String label, Widget screen) {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
      leading: Icon(icon, color: Colors.white70, size: 20),
      title: Text(label, style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 1)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildValidationNotice(BuildContext context, UserModel? user) {
    // Logic for validation notice or recharge button
    final bool isValidated = user != null && (user['isProfileValidated'] == true);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isValidated ? EspyTheme.success.withValues(alpha: 0.3) : EspyTheme.gold.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(isValidated ? LucideIcons.shieldCheck : LucideIcons.shieldAlert, 
            color: isValidated ? EspyTheme.success : EspyTheme.gold, size: 32),
          const SizedBox(height: 12),
          Text(isValidated ? "PROFILE VALIDATED" : "VALIDATION PENDING", 
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 10, color: Colors.white)),
          const SizedBox(height: 4),
          Text(isValidated ? "You can now recharge and activate protocols." : "Admin review in progress. You can edit your order quantities.", 
            textAlign: TextAlign.center, style: GoogleFonts.lora(fontSize: 9, color: Colors.white60)),
          if (isValidated) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => TokenShopScreen(initialTab: 0)));
                },
                style: ElevatedButton.styleFrom(backgroundColor: EspyTheme.gold, foregroundColor: EspyTheme.navyDeep),
                child: const Text("RECHARGE COINS", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter(AuthService auth) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: TextButton.icon(
        onPressed: () => auth.signOut(),
        icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 18),
        label: Text("TERMINATE SESSION", style: GoogleFonts.montserrat(color: Colors.redAccent, fontWeight: FontWeight.w900, fontSize: 10)),
      ),
    );
  }
}
