import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_core/theme/espy_theme.dart';
import 'package:shared_core/viewmodels/dashboard_view_model.dart';
import 'package:shared_core/widgets/common/espy_scaffold.dart';
import 'package:espy_app/l10n/app_localizations.dart';
import '../profile/location_manager_screen.dart';
import '../services/service_manager_screen.dart';
import '../services/broadcast_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DashboardViewModel>(context);
    final l10n = AppLocalizations.of(context)!;

    if (viewModel.profile == null) {
      return const Center(child: CircularProgressIndicator(color: EspyTheme.gold));
    }

    return EspyScaffold(
      useCinematicBackground: false, // Dashboard might prefer clean white/platinum
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildDashboardBox(
                  context,
                  title: 'LOCATION PINs',
                  icon: LucideIcons.mapPin,
                  value: '${viewModel.activePins}',
                  status: 'ACTIVE PINS',
                  buttonLabel: 'MANAGE PINS',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LocationManagerScreen())),
                ),
                _buildDashboardBox(
                  context,
                  title: 'SERVICE SLOTs',
                  icon: LucideIcons.layoutGrid,
                  value: '${viewModel.serviceSlots}',
                  status: 'TOTAL CAPACITY',
                  buttonLabel: 'MANAGE SLOTS',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ServiceManagerScreen())),
                ),
                _buildDashboardBox(
                  context,
                  title: 'BROADCASTs',
                  icon: LucideIcons.radio,
                  value: '${viewModel.broadcastsBought}',
                  status: 'AVAILABLE',
                  buttonLabel: 'NEW BROADCAST',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BroadcastScreen())),
                ),
                _buildVisibilityBox(context, viewModel, l10n),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardBox(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String value,
    required String status,
    required String buttonLabel,
    required VoidCallback onTap,
  }) {
    return FadeInUp(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: EspyTheme.royalBlue, size: 20),
                Text(
                  value,
                  style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep),
                ),
              ],
            ),
            const Spacer(),
            Text(title, style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.w900, color: EspyTheme.gold, letterSpacing: 1)),
            Text(status, style: GoogleFonts.montserrat(fontSize: 8, color: Colors.black38, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: onTap,
                style: TextButton.styleFrom(
                  backgroundColor: EspyTheme.navyDeep.withOpacity(0.05),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  buttonLabel,
                  style: GoogleFonts.montserrat(fontSize: 8, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep, letterSpacing: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisibilityBox(BuildContext context, DashboardViewModel viewModel, AppLocalizations l10n) {
    final daysRemaining = viewModel.visibilityDaysRemaining;
    final bool isExpired = viewModel.isVisibilityExpired;

    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isExpired ? Colors.redAccent.withOpacity(0.05) : EspyTheme.navyDeep,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(LucideIcons.eye, color: isExpired ? Colors.redAccent : EspyTheme.gold, size: 20),
                Text(
                  '$daysRemaining',
                  style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ],
            ),
            const Spacer(),
            Text(l10n.visibility.toUpperCase(), style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.w900, color: isExpired ? Colors.redAccent : EspyTheme.gold, letterSpacing: 1)),
            Text(l10n.daysRemaining.toUpperCase(), style: GoogleFonts.montserrat(fontSize: 8, color: Colors.white38, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: viewModel.isRenewing ? null : () async {
                   final success = await viewModel.quickRenew();
                   if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.visibilityExtended), backgroundColor: EspyTheme.success));
                   }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isExpired ? Colors.redAccent : EspyTheme.gold,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: viewModel.isRenewing 
                  ? const SizedBox(height: 10, width: 10, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                  : Text(
                      'QUICK RENEW',
                      style: GoogleFonts.montserrat(fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
