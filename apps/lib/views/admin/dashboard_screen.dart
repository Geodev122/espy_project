import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_core/theme/espy_theme.dart';
import 'package:shared_core/widgets/common/espy_scaffold.dart';
import 'package:shared_core/widgets/common/premium_card.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                _buildStatCard("TOTAL USERS", "1,240", Icons.people_rounded),
                const SizedBox(width: 16),
                _buildStatCard("ACTIVE SERVICES", "856", Icons.medical_services_rounded),
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
        _adminTile("PENDING VERIFICATIONS", Icons.verified_user_rounded, () {}),
        _adminTile("SUPPORT INBOX", Icons.support_agent_rounded, () {}),
        _adminTile("SYSTEM ANNOUNCEMENTS", Icons.campaign_rounded, () {}),
        _adminTile("WALLET LEDGER AUDIT", Icons.account_balance_wallet_rounded, () {}),
        _adminTile("TAXONOMY MANAGEMENT", Icons.category_rounded, () {}),
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
