import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:espy_core/espy_core.dart';
import '../../../theme/espy_theme.dart';
import '../../../viewmodels/broadcast_governance_view_model.dart';
import '../../../widgets/common/premium_button.dart';
import '../../../widgets/common/premium_card.dart';
import '../../../widgets/common/espy_scaffold.dart';

class BroadcastGovernanceScreen extends StatelessWidget {
  const BroadcastGovernanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BroadcastGovernanceViewModel(context.read<EspyRepository>()),
      child: const _BroadcastGovernanceView(),
    );
  }
}

class _BroadcastGovernanceView extends StatefulWidget {
  const _BroadcastGovernanceView();

  @override
  State<_BroadcastGovernanceView> createState() => _BroadcastGovernanceViewState();
}

class _BroadcastGovernanceViewState extends State<_BroadcastGovernanceView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _loadData();
      }
    });
    
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    final vm = Provider.of<BroadcastGovernanceViewModel>(context, listen: false);
    final status = _getStatusFromIndex(_tabController.index);
    vm.listenToBroadcastModerationQueue(status: status);
  }

  ModerationStatus _getStatusFromIndex(int index) {
    switch (index) {
      case 0: return ModerationStatus.pending;
      case 1: return ModerationStatus.approved;
      case 2: return ModerationStatus.flagged;
      default: return ModerationStatus.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<BroadcastGovernanceViewModel>(context);

    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(
        title: Text("BROADCAST GOVERNANCE", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
        backgroundColor: Colors.white,
        foregroundColor: EspyTheme.navyDeep,
        bottom: TabBar(
          controller: _tabController,
          labelColor: EspyTheme.royalBlue,
          unselectedLabelColor: Colors.black38,
          indicatorColor: EspyTheme.royalBlue,
          tabs: const [
            Tab(text: "PENDING"),
            Tab(text: "APPROVED"),
            Tab(text: "FLAGGED"),
          ],
        ),
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: vm.broadcasts.length,
              itemBuilder: (context, index) {
                final b = vm.broadcasts[index];
                return _buildBroadcastCard(context, b, vm);
              },
            ),
    );
  }

  Widget _buildBroadcastCard(BuildContext context, BroadcastModel b, BroadcastGovernanceViewModel vm) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: PremiumCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: EspyTheme.gold.withValues(alpha: 0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.podcasts, color: EspyTheme.gold, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(b.title.toUpperCase(), style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 16)),
                        Text("Sent by: ${b.senderName ?? b.senderEmail ?? 'Unknown'}", style: GoogleFonts.lora(fontSize: 12, color: Colors.black45)),
                      ],
                    ),
                  ],
                ),
                _buildStatusBadge(b.moderationStatus),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(),
            ),
            Text(b.message, style: GoogleFonts.lora(fontSize: 14, height: 1.6)),
            const SizedBox(height: 24),
            Row(
              children: [
                _buildDetailChip(Icons.public, b.targetCountry),
                if (b.targetRole != null) ...[
                  const SizedBox(width: 12),
                  _buildDetailChip(Icons.person_pin_outlined, b.targetRole!.name.toUpperCase()),
                ],
                const Spacer(),
                if (b.moderationStatus == ModerationStatus.pending) ...[
                  PremiumButton(
                    label: "REJECT",
                    variant: PremiumButtonVariant.outline,
                    onPressed: () => _showRejectDialog(context, b, vm),
                  ),
                  const SizedBox(width: 12),
                  PremiumButton(
                    label: "APPROVE",
                    onPressed: () => vm.moderateBroadcast(b.id, ModerationStatus.approved),
                  ),
                ],
              ],
            ),
            if (b.flagReason != null && b.flagReason!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8)),
                child: Text("FLAG REASON: ${b.flagReason}", style: GoogleFonts.montserrat(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: EspyTheme.platinum, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: EspyTheme.navyDeep),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w700, color: EspyTheme.navyDeep)),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ModerationStatus status) {
    Color color = Colors.orange;
    if (status == ModerationStatus.approved) color = Colors.green;
    if (status == ModerationStatus.flagged) color = Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4), border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Text(status.name.toUpperCase(), style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.w900, color: color)),
    );
  }

  void _showRejectDialog(BuildContext context, BroadcastModel b, BroadcastGovernanceViewModel vm) {
    final reason = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("REJECT BROADCAST"),
        content: TextField(
          controller: reason,
          decoration: const InputDecoration(hintText: "Reason for rejection"),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
            onPressed: () async {
              await vm.moderateBroadcast(b.id, ModerationStatus.flagged, reason: reason.text);
              if (mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text("CONFIRM REJECTION"),
          ),
        ],
      ),
    );
  }
}
