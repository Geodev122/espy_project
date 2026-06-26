import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme.dart';
import 'package:shared_core/services/firestore_service.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/services/user_service.dart';
import '../../widgets/common/premium_card.dart';
import '../../l10n/app_localizations.dart';
import 'service_listing_wizard.dart';

class ServiceManagerScreen extends StatefulWidget {
  const ServiceManagerScreen({super.key});

  @override
  State<ServiceManagerScreen> createState() => _ServiceManagerScreenState();
}

class _ServiceManagerScreenState extends State<ServiceManagerScreen> {
  final FirestoreService _firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final String profId = userService.userId;
    final l10n = AppLocalizations.of(context)!;
    final userData = userService.profile ?? {};

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: profId.isEmpty
          ? const Center(child: Text('Authorized personnel only.'))
          : StreamBuilder<List<Map<String, dynamic>>>(
              stream: _firestore.getProfessionalServices(profId),
              builder: (context, snapshot) {
                final services = snapshot.data ?? [];
                final totalSlots = (userData['serviceSlots'] as int? ?? (userData['role'] == 'institution' ? 5 : 2));
                final allocatedCount = services.where((s) => s['isAllocated'] == true).length;

                return CustomScrollView(
                  slivers: [
                    _buildSlotOverview(l10n, totalSlots, allocatedCount),
                    _buildActiveList(l10n, services, totalSlots, allocatedCount),
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                );
              },
            ),
      floatingActionButton: FadeInUp(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(color: EspyTheme.gold.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))
            ],
          ),
          child: FloatingActionButton.extended(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ServiceListingWizard())),
            backgroundColor: EspyTheme.gold,
            foregroundColor: Colors.white,
            elevation: 0,
            icon: const Icon(Icons.add_task_rounded, size: 20),
            label: Text(l10n.listNewService.toUpperCase(), style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
      ),
    );
  }

  Widget _buildSlotOverview(AppLocalizations l10n, int total, int used) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                _statNode(l10n.totalSlots.toUpperCase(), total.toString(), EspyTheme.gold),
                const SizedBox(width: 12),
                _statNode(l10n.used.toUpperCase(), used.toString(), EspyTheme.royalBlue),
                const SizedBox(width: 12),
                _statNode(l10n.available.toUpperCase(), (total - used).toString(), EspyTheme.navyDeep.withValues(alpha: 0.3)),
              ],
            ),
            const SizedBox(height: 24),
            Divider(color: EspyTheme.navyDeep.withValues(alpha: 0.05)),
          ],
        ),
      ),
    );
  }

  Widget _statNode(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Text(value, style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.w900, color: color)),
            Text(label, style: GoogleFonts.cinzel(fontSize: 8, fontWeight: FontWeight.bold, color: EspyTheme.navyDeep.withValues(alpha: 0.5))),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveList(AppLocalizations l10n, List<Map<String, dynamic>> services, int totalSlots, int usedSlots) {
    if (services.isEmpty) {
      return SliverToBoxAdapter(child: Center(child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Text(l10n.noActiveListings.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.navyDeep.withValues(alpha: 0.2))),
      )));
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildServiceTile(services[index], totalSlots, usedSlots),
          childCount: services.length,
        ),
      ),
    );
  }

  Widget _buildServiceTile(Map<String, dynamic> service, int totalSlots, int usedSlots) {
    final bool isAllocated = service['isAllocated'] == true;
    final bool canAllocate = usedSlots < totalSlots;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: PremiumCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 80, height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: EspyTheme.navyDeep.withValues(alpha: 0.05),
                image: service['imageUrl'] != null 
                  ? DecorationImage(image: CachedNetworkImageProvider(service['imageUrl']), fit: BoxFit.cover)
                  : null,
              ),
              child: service['imageUrl'] == null 
                ? const Icon(Icons.medical_services_rounded, color: EspyTheme.royalBlue, size: 24)
                : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service['title'] ?? '', style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 11, color: EspyTheme.navyDeep)),
                  const SizedBox(height: 4),
                  if (isAllocated)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: EspyTheme.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text("ACTIVE PROTOCOL", style: GoogleFonts.cinzel(fontSize: 7, fontWeight: FontWeight.bold, color: EspyTheme.success)),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: EspyTheme.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text("HIDDEN - NO SLOT ALLOCATED", style: GoogleFonts.cinzel(fontSize: 7, fontWeight: FontWeight.bold, color: EspyTheme.error)),
                    ),
                ],
              ),
            ),
            Switch(
              value: isAllocated,
              activeColor: EspyTheme.success,
              onChanged: (val) {
                if (val && !canAllocate) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Insufficient slots available. Visit Vault to expand.")));
                  return;
                }
                _firestore.toggleServiceSlot(service['id'], val);
              },
            ),
          ],
        ),
      ),
    );
  }
}
