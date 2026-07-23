import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';
import 'package:espy_app/widgets/common/premium_card.dart';
import 'package:espy_app/viewmodels/admin_dashboard_view_model.dart';

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
            
            // Primary Metrics
            Row(
              children: [
                _buildStatCard("TOTAL USERS", viewModel.stats['users'] ?? '0', Icons.people_rounded),
                const SizedBox(width: 16),
                _buildStatCard("ACTIVE SERVICES", viewModel.stats['services'] ?? '0', Icons.medical_services_rounded),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatCard("OPEN REQUESTS", viewModel.stats['communityRequests'] ?? '0', Icons.campaign_rounded),
                const SizedBox(width: 16),
                _buildStatCard("PENDING ORDERS", viewModel.stats['pendingOrders'] ?? '0', Icons.shopping_cart_checkout_rounded),
              ],
            ),

            const SizedBox(height: 32),
            Text("LIVE ACTIVITY STREAM", style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black38, letterSpacing: 1)),
            const SizedBox(height: 16),
            
            // Placeholder for activity feed
            PremiumCard(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.analytics_outlined, color: EspyTheme.platinum, size: 48),
                    const SizedBox(height: 16),
                    Text("SYNCHRONIZING REAL-TIME ANALYTICS...", 
                      style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black26)),
                  ],
                ),
              ),
            ),
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
            Icon(icon, color: EspyTheme.royalBlue, size: 20),
            const SizedBox(height: 12),
            Text(value, style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w900)),
            Text(label, style: GoogleFonts.cinzel(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.black38)),
          ],
        ),
      ),
    );
  }
}
