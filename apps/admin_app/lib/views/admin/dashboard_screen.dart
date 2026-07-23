import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';
import 'package:espy_app/widgets/common/premium_card.dart';
import 'package:espy_app/viewmodels/admin_dashboard_view_model.dart';

import 'modules/verifications_screen.dart';
import 'modules/support_inbox_screen.dart';
import 'modules/orders_manager_screen.dart';
import 'modules/recharge_cards_screen.dart';
import 'modules/taxonomy_manager_screen.dart';
import 'modules/users_manager_screen.dart';

import 'modules/seed_manager_page.dart';

import 'modules/service_management_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AdminDashboardViewModel>(context);

    return EspyScaffold(
      useCinematicBackground: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("SYSTEM OVERVIEW", style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.w900, color: EspyTheme.gold, letterSpacing: 2)),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildStatCard("TOTAL USERS", viewModel.stats['users'] ?? '0', Icons.people_rounded),
                const SizedBox(width: 16),
                _buildStatCard("ACTIVE SERVICES", viewModel.stats['services'] ?? '0', Icons.medical_services_rounded),
              ],
            ),
            const SizedBox(height: 32),
            _buildActionList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: PremiumCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, color: EspyTheme.royalBlue, size: 24),
            const SizedBox(height: 12),
            Text(value, style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w900)),
            Text(label, style: GoogleFonts.cinzel(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black38)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionList(BuildContext context) {
    return Column(
      children: [
        _adminTile("USER MANAGEMENT", LucideIcons.users, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const UsersManagerScreen()));
        }),
        _adminTile("PENDING VERIFICATIONS", Icons.verified_user_rounded, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const VerificationsScreen()));
        }),
        _adminTile("RESOURCE ORDERS", Icons.shopping_bag_rounded, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersManagerScreen()));
        }),
        _adminTile("SERVICE MANAGEMENT", Icons.settings_suggest_rounded, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ServiceManagementScreen()));
        }),
        _adminTile("TAXONOMY MANAGEMENT", Icons.category_rounded, () {
           Navigator.push(context, MaterialPageRoute(builder: (_) => const TaxonomyManagerScreen()));
        }),
        _adminTile("SEED DATA", LucideIcons.database, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SeedManagerPage()));
        }),
        _adminTile("SUPPORT INBOX", Icons.support_agent_rounded, () {
           Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportInboxScreen()));
        }),
        _adminTile("SYSTEM ANNOUNCEMENTS", Icons.campaign_rounded, () {}),
      ],
    );
  }

  Widget _adminTile(String label, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: PremiumCard(
        padding: EdgeInsets.zero,
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, color: EspyTheme.navyDeep),
          title: Text(label, style: GoogleFonts.montserrat(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)),
          trailing: const Icon(Icons.chevron_right_rounded, color: EspyTheme.gold),
        ),
      ),
    );
  }
}
