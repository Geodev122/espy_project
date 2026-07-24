import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import 'package:espy_core/espy_core.dart';
import 'package:espy_app/l10n/app_localizations.dart';
import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/widgets/common/premium_card.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';
import 'service_listing_wizard.dart';

class ServiceManagerScreen extends StatefulWidget {
  const ServiceManagerScreen({super.key});

  @override
  State<ServiceManagerScreen> createState() => _ServiceManagerScreenState();
}

class _ServiceManagerScreenState extends State<ServiceManagerScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ServicesViewModel>(context);
    final userService = Provider.of<UserService>(context);
    final l10n = AppLocalizations.of(context)!;
    final profile = userService.profile;
    final bool canPop = Navigator.canPop(context);

    return EspyScaffold(
      useCinematicBackground: false,
      appBar: canPop ? AppBar(
        title: Text(l10n.services.toUpperCase(), style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
        backgroundColor: Colors.white,
        foregroundColor: EspyTheme.navyDeep,
        elevation: 0,
      ) : null,
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator(color: EspyTheme.gold))
          : CustomScrollView(
              slivers: [
                if (profile != null) _buildSlotOverview(l10n, profile, viewModel),
                _buildActiveList(l10n, viewModel, profile),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
      floatingActionButton: FadeInUp(
        child: FloatingActionButton.extended(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ServiceListingWizard())),
          backgroundColor: EspyTheme.gold,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add_task_rounded, size: 20),
          label: Text(l10n.listNewService.toUpperCase(), style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 11)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Widget _buildSlotOverview(AppLocalizations l10n, dynamic userData, ServicesViewModel vm) {
    final total = (userData['serviceSlots'] as int? ?? (userData.role == UserRole.institution ? 5 : 2));
    final used = vm.professionalServices.where((s) => s.isAllocated).length;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            _statNode(l10n.totalSlots.toUpperCase(), total.toString(), EspyTheme.gold),
            const SizedBox(width: 12),
            _statNode(l10n.used.toUpperCase(), used.toString(), EspyTheme.royalBlue),
            const SizedBox(width: 12),
            _statNode(l10n.available.toUpperCase(), (total - used).toString(), EspyTheme.navyDeep.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }

  Widget _statNode(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Text(value, style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.w900, color: color)),
            Text(label, style: GoogleFonts.cinzel(fontSize: 8, fontWeight: FontWeight.bold, color: EspyTheme.navyDeep.withValues(alpha: 0.5))),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveList(AppLocalizations l10n, ServicesViewModel vm, dynamic userData) {
    if (vm.professionalServices.isEmpty) {
      return SliverToBoxAdapter(child: Center(child: Text(l10n.noActiveListings.toUpperCase())));
    }

    final totalSlots = (userData?['serviceSlots'] as int? ?? (userData?.role == UserRole.institution ? 5 : 2));
    final usedSlots = vm.professionalServices.where((s) => s.isAllocated).length;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildServiceTile(vm.professionalServices[index], totalSlots, usedSlots, vm),
          childCount: vm.professionalServices.length,
        ),
      ),
    );
  }

  Widget _buildServiceTile(ServiceModel service, int totalSlots, int usedSlots, ServicesViewModel vm) {
    final bool isAllocated = service.isAllocated;
    final bool canAllocate = usedSlots < totalSlots;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: PremiumCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.titleEn.toUpperCase(), style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 11, color: EspyTheme.navyDeep)),
                  const SizedBox(height: 4),
                  Text(isAllocated ? "ACTIVE" : "INACTIVE", style: GoogleFonts.cinzel(fontSize: 7, fontWeight: FontWeight.bold, color: isAllocated ? EspyTheme.success : EspyTheme.error)),
                ],
              ),
            ),
            Switch(
              value: isAllocated,
              activeThumbColor: EspyTheme.success,
              onChanged: (val) {
                if (val && !canAllocate) return;
                vm.toggleServiceSlot(service.id, val);
              },
            ),
          ],
        ),
      ),
    );
  }
}
