import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/services/firestore_service.dart';
import '../../widgets/common/premium_button.dart';

class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> with SingleTickerProviderStateMixin {
  final FirestoreService _firestore = FirestoreService();
  late TabController _tabController;

  final String _selectedFilterSectionId = 'All';
  final bool _newestFirst = true;

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
    return Stack(
      children: [
        NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            _buildSliverAppBar(l10n),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: EspyTheme.royalBlue,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 3,
                  labelColor: EspyTheme.navyDeep,
                  unselectedLabelColor: EspyTheme.navyDeep.withOpacity(0.3),
                  labelStyle: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1.5),
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
          bottom: 120, // Moved higher to clear the glass bottom bar
          right: 24,
          child: FadeInUp(
            child: FloatingActionButton(
              onPressed: () => _showPostRequestDialog(l10n),
              backgroundColor: EspyTheme.navyDeep.withOpacity(0.9),
              foregroundColor: EspyTheme.gold,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: EspyTheme.gold.withOpacity(0.2)),
              ),
              child: const Icon(Icons.add_comment_rounded, size: 28),
            ),
          ),
        ),
      ],
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
          left: 24,
          right: 24,
          top: 24,
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
                style: GoogleFonts.cinzel(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: EspyTheme.noir,
                ),
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
                            labelStyle: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          items: sectors.map((s) => DropdownMenuItem(
                            value: s['id'] as String, 
                            child: Text(s['name_en']?.toString().toUpperCase() ?? 'OTHER', style: GoogleFonts.cinzel(fontSize: 12))
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
                              final navigator = Navigator.of(context);
                              final messenger = ScaffoldMessenger.of(context);
                              final uid = _firestore.getCurrentUserId;

                              final sector = sectors.firstWhere((s) => s['id'] == selectedSectionId);
                              final userData = auth.userData;

                              await _firestore.createCommunityRequest({
                                'title': titleController.text,
                                'description': descController.text,
                                'sectionId': selectedSectionId,
                                'section': sector['name_en'],
                                'category_id': selectedSectionId, // Match sectionId for filtering
                                'category_name': sector['name_en'], // For admin dashboard display
                                'userId': uid,
                                'requester_id': uid,
                                'requester_name': userData?['fullNameEn'] ?? userData?['name'] ?? "User",
                                'whatsapp': userData?['whatsapp'],
                                'whatsapp_number': userData?['whatsapp'], // For admin dashboard
                                'countryId': userData?['countryId'] ?? 'LEBANON',
                                'governorateId': userData?['governorateId'] ?? 'BEIRUT',
                                'cityId': userData?['cityId'] ?? 'BEIRUT',
                                'location': userData?['location'] ?? 'Beirut, Lebanon',
                                'city_name': userData?['cityName'] ?? 'Beirut', // For admin dashboard
                                'governorate_name': userData?['governorateName'] ?? 'Beirut', // For admin dashboard
                              });

                              navigator.pop();
                              messenger.showSnackBar(
                                SnackBar(content: Text(l10n.requestPublished)),
                              );
                            } else if (selectedSectionId == null) {
                               ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please select a sector')),
                              );
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

  Widget _buildSliverAppBar(AppLocalizations l10n) {
    return const SliverToBoxAdapter(child: SizedBox(height: 10)); // Removed redundant app bar
  }



  Widget _buildFeedList(AppLocalizations l10n, {bool onlyMine = false}) {
    final uid = _firestore.getCurrentUserId;
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: onlyMine
          ? _firestore.getCommunityRequests(userId: uid, newestFirst: _newestFirst)
          : _firestore.getCommunityRequests(sectionId: _selectedFilterSectionId, newestFirst: _newestFirst),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverFillRemaining(
            child:
                Center(child: CircularProgressIndicator(color: EspyTheme.gold)),
          );
        }

        final requests = snapshot.data ?? [];

        if (requests.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Text(
                onlyMine ? l10n.noOwnRequests.toUpperCase() : l10n.noActiveRequests.toUpperCase(),
                style: GoogleFonts.cinzel(
                    color: EspyTheme.noir.withOpacity(0.3)),
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return FadeInUp(
                  delay: Duration(milliseconds: index * 100),
                  child: _buildRequestCard(l10n, requests[index]),
                );
              },
              childCount: requests.length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildRequestCard(AppLocalizations l10n, Map<String, dynamic> request) {
    final auth = Provider.of<AuthService>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: EspyTheme.royalBlue.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: EspyTheme.royalBlue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: EspyTheme.royalBlue.withOpacity(0.1)),
                  ),
                  child: Text(
                    (request['section'] ?? request['category'] ?? 'CARE').toString().toUpperCase(),
                    style: GoogleFonts.cinzel(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: EspyTheme.royalBlue,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  l10n.active.toUpperCase(),
                  style: GoogleFonts.cinzel(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: EspyTheme.success,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              request['title'] ?? 'Care Request',
              style: GoogleFonts.cinzel(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: EspyTheme.navyDeep,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              request['description'] ?? '',
              style: GoogleFonts.lora(
                fontSize: 13,
                color: EspyTheme.navyDeep.withOpacity(0.6),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 14, color: EspyTheme.gold),
                const SizedBox(width: 6),
                Text(
                  request['location'] ?? 'Lebanon',
                  style: GoogleFonts.lora(
                      fontSize: 11,
                      color: EspyTheme.navyDeep.withOpacity(0.4),
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (request['userId'] != _firestore.getCurrentUserId)
                  PremiumButton(
                    label: l10n.respond.toUpperCase(),
                    size: PremiumButtonSize.small,
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      await _firestore.recordInteraction(
                        userId: _firestore.getCurrentUserId,
                        targetId: request['id'],
                        type: 'respond',
                      );

                      // WhatsApp Redirection
                      final userData = auth.userData;
                      final userName = userData?['fullNameEn'] ?? userData?['name'] ?? "User";
                      final userRole = (userData?['role'] ?? "Visitor").toString().toUpperCase();
                      final userSector = (userData?['sectorId'] ?? "General Care").toString().toUpperCase();

                      final reqTitle = request['title'] ?? "Care Request";
                      final reqId = request['id'] ?? "Unknown";
                      final targetWhatsapp = request['whatsapp']?.toString().replaceAll(RegExp(r'\D'), '');

                      if (targetWhatsapp != null && targetWhatsapp.isNotEmpty) {
                        final msg = "Hello, I am $userName, a $userRole in the $userSector sector. I am responding to your Espy request: '$reqTitle' (ID: $reqId). How can I assist you today?";
                        final url = "https://wa.me/$targetWhatsapp?text=${Uri.encodeComponent(msg)}";

                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                        }
                      }

                      messenger.showSnackBar(
                        SnackBar(content: Text(l10n.responseLogged)),
                      );
                    },
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: EspyTheme.navyDeep.withOpacity(0.1)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      l10n.myPost.toUpperCase(),
                      style: GoogleFonts.cinzel(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: EspyTheme.navyDeep.withOpacity(0.4),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
