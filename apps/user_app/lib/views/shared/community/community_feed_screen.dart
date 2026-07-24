import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import 'package:espy_core/espy_core.dart';
import 'package:espy_app/l10n/app_localizations.dart';
import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/widgets/common/premium_button.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';

class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> with SingleTickerProviderStateMixin {
  final FirestoreService _firestore = FirestoreService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EspyScaffold(
      useCinematicBackground: false,
      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: EspyTheme.royalBlue,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 3,
                    labelColor: EspyTheme.navyDeep,
                    unselectedLabelColor: EspyTheme.navyDeep.withValues(alpha: 0.3),
                    labelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1),
                    tabs: [
                      Tab(text: l10n.communityFeed.toUpperCase()),
                      Tab(text: l10n.myRequests.toUpperCase()),
                    ],
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                CustomScrollView(slivers: [_buildFeedList(l10n, onlyMine: false)]),
                CustomScrollView(slivers: [_buildFeedList(l10n, onlyMine: true)]),
              ],
            ),
          ),
          Positioned(
            bottom: 110, 
            right: 24,
            child: FadeInUp(
              child: FloatingActionButton(
                onPressed: () => _showPostRequestDialog(l10n),
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                foregroundColor: EspyTheme.navyDeep,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: EspyTheme.royalBlue.withValues(alpha: 0.1)),
                ),
                child: const Icon(Icons.settings_suggest_rounded, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPostRequestDialog(AppLocalizations l10n) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    String? selectedSectionId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24, right: 24, top: 24,
        ),
        decoration: const BoxDecoration(
          color: EspyTheme.platinum,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.postCareRequest.toUpperCase(),
                style: GoogleFonts.cinzel(fontSize: 20, fontWeight: FontWeight.w900, color: EspyTheme.noir),
              ),
              const SizedBox(height: 24),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: _firestore.getSectors(),
                builder: (context, snapshot) {
                  final sectors = snapshot.data ?? [];
                  return StatefulBuilder(
                    builder: (context, setModalState) => Column(
                      children: [
                        DropdownButtonFormField<String>(
                          initialValue: selectedSectionId,
                          dropdownColor: EspyTheme.platinum,
                          decoration: InputDecoration(
                            labelText: l10n.sector.toUpperCase(),
                            labelStyle: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          items: sectors.map((s) => DropdownMenuItem(
                            value: s['id'] as String, 
                            child: Text(s['name_en']?.toString().toUpperCase() ?? 'OTHER', style: GoogleFonts.montserrat(fontSize: 11, fontWeight: FontWeight.w700))
                          )).toList(),
                          onChanged: (v) => setModalState(() => selectedSectionId = v),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(hintText: 'Title'),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: descController,
                          maxLines: 3,
                          decoration: const InputDecoration(hintText: 'Description'),
                        ),
                        const SizedBox(height: 24),
                        PremiumButton(
                          label: l10n.submitProtocolRequest.toUpperCase(),
                          fullWidth: true,
                          onPressed: () async {
                            if (titleController.text.isNotEmpty && selectedSectionId != null) {
                              final auth = Provider.of<AuthService>(context, listen: false);
                              final uid = _firestore.getCurrentUserId;
                              final user = auth.userData;

                              final request = ServiceRequestModel(
                                id: '', 
                                userId: uid,
                                sectorId: selectedSectionId!,
                                descriptionEn: "${titleController.text}: ${descController.text}",
                                urgency: UrgencyLevel.medium,
                                preferredMode: DeliveryMode.face_to_face,
                                status: CommunityRequestStatus.active,
                                moderationStatus: ModerationStatus.pending,
                                createdAt: DateTime.now(),
                                userName: user?.name,
                              );

                              await _firestore.createCommunityRequest(request);

                              if (mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.requestPublished)));
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedList(AppLocalizations l10n, {bool onlyMine = false}) {
    final uid = _firestore.getCurrentUserId;
    return StreamBuilder<List<ServiceRequestModel>>(
      stream: onlyMine
          ? _firestore.getCommunityRequests(userId: uid)
          : _firestore.getCommunityRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: EspyTheme.gold)));
        }

        final requests = snapshot.data ?? [];

        if (requests.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Text(
                onlyMine ? l10n.noOwnRequests.toUpperCase() : l10n.noActiveRequests.toUpperCase(),
                style: GoogleFonts.cinzel(color: EspyTheme.noir.withValues(alpha: 0.3)),
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => FadeInUp(
                  delay: Duration(milliseconds: index * 100),
                  child: _buildRequestCard(l10n, requests[index]),
                ),
              childCount: requests.length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildRequestCard(AppLocalizations l10n, ServiceRequestModel request) {
    final auth = Provider.of<AuthService>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: EspyTheme.royalBlue.withValues(alpha: 0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10))]
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: EspyTheme.royalBlue.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: EspyTheme.royalBlue.withValues(alpha: 0.1)),
                  ),
                  child: Text(
                    (request.sectorName ?? 'CARE').toString().toUpperCase(),
                    style: GoogleFonts.montserrat(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: EspyTheme.royalBlue,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Spacer(),
                Text(l10n.active.toUpperCase(), style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.w900, color: EspyTheme.success, letterSpacing: 1.5)),
              ],
            ),
            const SizedBox(height: 20),
            Text(request.descriptionEn.split(':').first, style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep, height: 1.2)),
            const SizedBox(height: 12),
            Text(request.descriptionEn.contains(':') ? request.descriptionEn.split(':').last.trim() : request.descriptionEn, style: GoogleFonts.montserrat(fontSize: 13, color: EspyTheme.navyDeep.withValues(alpha: 0.6), height: 1.5, fontWeight: FontWeight.w500)),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: EspyTheme.gold),
                const SizedBox(width: 6),
                Text('Lebanon', style: GoogleFonts.montserrat(fontSize: 11, color: EspyTheme.navyDeep.withValues(alpha: 0.4), fontWeight: FontWeight.bold)),
                const Spacer(),
                if (request.userId != _firestore.getCurrentUserId)
                  PremiumButton(
                    label: l10n.respond.toUpperCase(),
                    size: PremiumButtonSize.small,
                    onPressed: () async {
                      await _firestore.recordInteraction(
                        userId: _firestore.getCurrentUserId,
                        targetId: request.id,
                        type: InteractionType.contact,
                      );

                      final user = auth.userData;
                      final userName = user?.name ?? "User";
                      final userRole = (user?.role.name ?? "Visitor").toUpperCase();
                      
                      final reqTitle = request.descriptionEn.split(':').first;
                      final targetWhatsapp = user?.whatsapp?.toString().replaceAll(RegExp(r'\D'), ''); // Note: this should be requester's whatsapp

                      if (targetWhatsapp != null && targetWhatsapp.isNotEmpty) {
                        final msg = "Hello, I am $userName, a $userRole. I am responding to your Espy request: '$reqTitle'. How can I assist you?";
                        final url = "https://wa.me/$targetWhatsapp?text=${Uri.encodeComponent(msg)}";
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                        }
                      }

                      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.responseLogged)));
                    },
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(border: Border.all(color: EspyTheme.navyDeep.withValues(alpha: 0.1)), borderRadius: BorderRadius.circular(12)),
                    child: Text(l10n.myPost.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 9, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep.withValues(alpha: 0.4), letterSpacing: 1.5)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
