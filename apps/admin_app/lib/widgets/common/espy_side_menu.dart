import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/viewmodels/auth_service.dart';
import 'package:espy_app/viewmodels/wallet_view_model.dart';
import 'package:espy_app/models/user_model.dart';

// Admin Screens (Conditional import or dynamic navigation)
import '../../views/admin/modules/verifications_screen.dart';
import '../../views/admin/modules/orders_manager_screen.dart';
import '../../views/admin/modules/support_inbox_screen.dart';

class EspySideMenu extends StatelessWidget {
  const EspySideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final user = auth.userData;

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
                    _buildSectionHeader('ADMINISTRATIVE'),
                    _buildMenuItem(context, LucideIcons.shieldCheck, 'VALIDATIONS', VerificationsScreen()),
                    _buildMenuItem(context, LucideIcons.shoppingBag, 'RESOURCES', OrdersManagerScreen()),
                    _buildMenuItem(context, LucideIcons.inbox, 'SUPPORT', SupportInboxScreen()),
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
