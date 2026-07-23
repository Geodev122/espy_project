import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../../theme/espy_theme.dart';
import '../../../viewmodels/espy_repository.dart';
import '../../../viewmodels/service_management_view_model.dart';
import '../../../widgets/common/premium_button.dart';
import '../../../widgets/common/premium_card.dart';
import '../../../widgets/common/espy_scaffold.dart';

class ServiceManagementScreen extends StatelessWidget {
  const ServiceManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ServiceManagementViewModel(context.read<EspyRepository>()),
      child: const _ServiceManagementView(),
    );
  }
}

class _ServiceManagementView extends StatefulWidget {
  const _ServiceManagementView();

  @override
  State<_ServiceManagementView> createState() => _ServiceManagementViewState();
}

class _ServiceManagementViewState extends State<_ServiceManagementView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(
        title: Text("SERVICE GOVERNANCE", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
        backgroundColor: Colors.white,
        foregroundColor: EspyTheme.navyDeep,
        bottom: TabBar(
          controller: _tabController,
          labelColor: EspyTheme.royalBlue,
          unselectedLabelColor: Colors.black38,
          indicatorColor: EspyTheme.royalBlue,
          tabs: const [
            Tab(text: "LISTINGS"),
            Tab(text: "REQUESTS"),
            Tab(text: "TEMPLATES"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _ListingModerationPanel(),
          _RequestModerationPanel(),
          _TemplateManagementPanel(),
        ],
      ),
    );
  }
}

class _ListingModerationPanel extends StatelessWidget {
  const _ListingModerationPanel();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ServiceManagementViewModel>(context);
    if (vm.listingQueue.isEmpty) return _buildEmptyState("CLEAN PROTOCOL: No Pending Listings");

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
          child: CardSwiper(
            cardsCount: vm.listingQueue.length,
            cardBuilder: (context, index, _, __) {
              final item = vm.listingQueue[index];
              return _buildModerationCard(
                context,
                title: item['titleEn'] ?? 'SERVICE',
                subtitle: "${item['sectorName']} | ${item['providerName']}",
                description: item['descriptionEn'] ?? '',
                onApprove: () => _showBroadcastCriteriaDialog(context, (scope) => vm.approveService(item['id'], broadcastScope: scope, serviceData: item)),
                onReject: () => _showRejectDialog(context, (reason) => vm.rejectService(item['id'], reason)),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String msg) {
    return Center(child: Text(msg.toUpperCase(), style: GoogleFonts.cinzel(color: Colors.black26, fontSize: 12, fontWeight: FontWeight.bold)));
  }

  Widget _buildModerationCard(BuildContext context, {required String title, required String subtitle, required String description, required VoidCallback onApprove, required VoidCallback onReject}) {
    return PremiumCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle.toUpperCase(), style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w800, color: EspyTheme.gold)),
          const SizedBox(height: 16),
          Text(title, style: GoogleFonts.cinzel(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          Expanded(child: SingleChildScrollView(child: Text(description, style: GoogleFonts.lora(fontSize: 14, color: Colors.black54)))),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(child: PremiumButton(label: "REJECT", variant: PremiumButtonVariant.outline, onPressed: onReject)),
              const SizedBox(width: 16),
              Expanded(child: PremiumButton(label: "APPROVE", variant: PremiumButtonVariant.electric, onPressed: onApprove)),
            ],
          ),
        ],
      ),
    );
  }

  void _showBroadcastCriteriaDialog(BuildContext context, Function(String) onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("BROADCAST SCOPE", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("NO BROADCAST"), 
              subtitle: const Text("Silent approval, no notifications sent.", style: TextStyle(fontSize: 10)),
              onTap: () { onConfirm('NONE'); Navigator.pop(context); }
            ),
            ListTile(
              title: const Text("SAME COUNTRY"), 
              subtitle: const Text("Notify all visitors in this country.", style: TextStyle(fontSize: 10)),
              onTap: () { onConfirm('COUNTRY'); Navigator.pop(context); }
            ),
            ListTile(
              title: const Text("SAME REGION"), 
              subtitle: const Text("Notify visitors in this specific region.", style: TextStyle(fontSize: 10)),
              onTap: () { onConfirm('REGION'); Navigator.pop(context); }
            ),
            ListTile(
              title: const Text("SAME CITY"), 
              subtitle: const Text("Notify visitors in the provider's city.", style: TextStyle(fontSize: 10)),
              onTap: () { onConfirm('CITY'); Navigator.pop(context); }
            ),
          ],
        ),
      ),
    );
  }

  void _showRejectDialog(BuildContext context, Function(String) onConfirm) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("REJECTION PROTOCOL"),
        content: TextField(controller: controller, decoration: const InputDecoration(hintText: "Enter rejection reason...")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(onPressed: () { onConfirm(controller.text); Navigator.pop(context); }, child: const Text("CONFIRM REJECTION")),
        ],
      ),
    );
  }
}

class _RequestModerationPanel extends StatelessWidget {
  const _RequestModerationPanel();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ServiceManagementViewModel>(context);
    if (vm.requestQueue.isEmpty) return Center(child: Text("NO PENDING REQUESTS", style: GoogleFonts.cinzel(color: Colors.black26)));

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
      child: CardSwiper(
        cardsCount: vm.requestQueue.length,
        cardBuilder: (context, index, _, __) {
          final item = vm.requestQueue[index];
          return PremiumCard(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${item['sectorName']} | ${item['userName']}".toUpperCase(), style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w800, color: EspyTheme.royalBlue)),
                const SizedBox(height: 24),
                Expanded(child: SingleChildScrollView(child: Text(item['descriptionEn'] ?? '', style: GoogleFonts.lora(fontSize: 16)))),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(child: PremiumButton(label: "FLAG", variant: PremiumButtonVariant.outline, onPressed: () => vm.rejectRequest(item['id'], "Flagged by Admin"))),
                    const SizedBox(width: 16),
                    Expanded(child: PremiumButton(label: "VERIFY", variant: PremiumButtonVariant.electric, onPressed: () => vm.approveRequest(item['id']))),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TemplateManagementPanel extends StatelessWidget {
  const _TemplateManagementPanel();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ServiceManagementViewModel>(context);
    final repo = context.read<EspyRepository>();

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: repo.listSectors(),
      builder: (context, snapshot) {
        final sectors = snapshot.data ?? [];
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildSpecialTemplateTile(context, vm, "VISITOR REQUESTS", "GLOBAL_VISITOR_REQUEST"),
            const Divider(height: 48),
            Text("SECTOR TEMPLATES", style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.gold, letterSpacing: 2)),
            const SizedBox(height: 16),
            ...sectors.map((s) {
              final t = s['template'] as Map<String, dynamic>?;
              return PremiumCard(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Container(
                     width: 12, height: 12,
                     decoration: BoxDecoration(
                       color: Color(int.tryParse(t?['accentColor'] ?? '0xFF1565C0') ?? 0xFF1565C0),
                       shape: BoxShape.circle,
                     ),
                  ),
                  title: Text(s['nameEn'].toString().toUpperCase(), style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text("Identity: ${t?['iconName'] ?? 'Standard'}", style: const TextStyle(fontSize: 10)),
                  trailing: IconButton(
                    icon: const Icon(Icons.palette_outlined, color: EspyTheme.gold),
                    onPressed: () => _showTemplateEditor(context, s['id'], s['nameEn'], t, vm),
                  ),
                ),
              );
            }),
          ],
        );
      }
    );
  }

  Widget _buildSpecialTemplateTile(BuildContext context, ServiceManagementViewModel vm, String label, String templateId) {
    // Find the template in the viewmodel's list
    final t = vm.templates.firstWhere((element) => element['id'] == templateId, orElse: () => <String, dynamic>{});
    
    return PremiumCard(
      accentColor: EspyTheme.gold,
      child: ListTile(
        title: Text(label, style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
        subtitle: const Text("Governs visitor Care Requests visualization", style: TextStyle(fontSize: 10)),
        trailing: IconButton(
          icon: const Icon(Icons.settings_suggest_rounded, color: EspyTheme.gold),
          onPressed: () => _showTemplateEditor(context, templateId, label, t, vm),
        ),
      ),
    );
  }

  void _showTemplateEditor(BuildContext context, String id, String label, Map<String, dynamic>? current, ServiceManagementViewModel vm) {
    final List<String> fields = ['Title', 'Price', 'Location', 'Tags', 'Image', 'Provider Profile', 'Urgency', 'Description'];
    
    List<String> selected = List<String>.from(current?['visibleFields'] ?? ['Title', 'Location']);
    final colorController = TextEditingController(text: current?['accentColor'] ?? '0xFF1565C0');
    final iconController = TextEditingController(text: current?['iconName'] ?? 'medical_services');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: Text("IDENTITY: $label"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: colorController, decoration: const InputDecoration(labelText: "ACCENT COLOR (HEX)")),
                const SizedBox(height: 12),
                TextField(controller: iconController, decoration: const InputDecoration(labelText: "ICON NAME (LUCIDE)")),
                const SizedBox(height: 24),
                Text("VISIBLE DATA FIELDS", style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black38)),
                const SizedBox(height: 12),
                ...fields.map((f) => CheckboxListTile(
                  title: Text(f, style: const TextStyle(fontSize: 12)),
                  value: selected.contains(f),
                  onChanged: (val) {
                    setModalState(() {
                      if (val == true) selected.add(f); else selected.remove(f);
                    });
                  },
                  dense: true,
                )).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
            ElevatedButton(onPressed: () { 
              vm.updateTemplate(
                categoryId: id, 
                visibleFields: selected,
                accentColor: colorController.text,
                iconName: iconController.text,
              ); 
              Navigator.pop(context); 
            }, child: const Text("SAVE IDENTITY")),
          ],
        ),
      ),
    );
  }
}
