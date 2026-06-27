import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:shared_core/theme/espy_theme.dart';
import 'package:shared_core/services/user_service.dart';
import 'package:shared_core/services/auth_service.dart';
import '../../l10n/app_localizations.dart';
import '../profile/location_manager_screen.dart';
import '../services/service_manager_screen.dart';
import '../services/broadcast_screen.dart';
import '../profile/token_shop_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final user = userService.profile;
    final l10n = AppLocalizations.of(context)!;

    if (user == null) {
      return const Center(child: CircularProgressIndicator(color: EspyTheme.gold));
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              child: Text(
                'PROTOCOL DASHBOARD',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: EspyTheme.navyDeep,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            FadeInDown(
              delay: const Duration(milliseconds: 100),
              child: Text(
                'LIVE MISSION STATUS',
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  color: EspyTheme.navyDeep.withOpacity(0.5),
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 32),
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
                  value: '${(user['secondaryLocations'] as List? ?? []).length + 1}',
                  status: 'ACTIVE PINS',
                  buttonLabel: 'MANAGE PINS',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LocationManagerScreen())),
                ),
                _buildDashboardBox(
                  context,
                  title: 'SERVICE SLOTs',
                  icon: LucideIcons.layoutGrid,
                  value: '${user['serviceSlots'] ?? 0}',
                  status: 'TOTAL CAPACITY',
                  buttonLabel: 'MANAGE SLOTS',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ServiceManagerScreen())),
                ),
                _buildDashboardBox(
                  context,
                  title: 'BROADCASTs',
                  icon: LucideIcons.radio,
                  value: '${user['broadcastsBought'] ?? 0}',
                  status: 'AVAILABLE',
                  buttonLabel: 'NEW BROADCAST',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BroadcastScreen())),
                ),
                _buildVisibilityBox(context, user, l10n),
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

  Future<void> _handleQuickRenew(BuildContext context) async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final firestore = FirebaseFirestore.instance;

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator(color: EspyTheme.gold)),
      );

      // Fetch pricing
      final pricingDoc = await firestore.collection('directory_settings').doc('token_pricing').get();
      final pricing = pricingDoc.data() ?? {};
      final cost = pricing['renew_visibility'] ?? 500;

      final result = await FirebaseFunctions.instanceFor(region: 'us-central1').httpsCallable('spendTokens').call({
        'userId': auth.user!.uid,
        'itemId': 'renew_visibility',
        'cost': cost,
        'role': auth.userData?.role.name ?? 'professional',
      });

      if (context.mounted) Navigator.pop(context);

      if (result.data != null && result.data['success'] == true) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('VISIBILITY EXTENDED BY 30 DAYS'), backgroundColor: EspyTheme.success));
        }
        await auth.fetchUserData();
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Renewal Error: $e')));
      }
    }
  }

  Widget _buildVisibilityBox(BuildContext context, Map<String, dynamic> user, AppLocalizations l10n) {
    final expiry = user['visibilityExpiresAt'] != null
        ? (user['visibilityExpiresAt'] is Timestamp
            ? (user['visibilityExpiresAt'] as Timestamp).toDate()
            : DateTime.tryParse(user['visibilityExpiresAt'].toString()))
        : null;

    final daysRemaining = expiry != null ? expiry.difference(DateTime.now()).inDays : 0;
    final bool isExpired = daysRemaining <= 0;

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
                  '${daysRemaining < 0 ? 0 : daysRemaining}',
                  style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ],
            ),
            const Spacer(),
            Text('VISIBILITY', style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.w900, color: isExpired ? Colors.redAccent : EspyTheme.gold, letterSpacing: 1)),
            Text('DAYS REMAINING', style: GoogleFonts.montserrat(fontSize: 8, color: Colors.white38, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _handleQuickRenew(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isExpired ? Colors.redAccent : EspyTheme.gold,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
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
