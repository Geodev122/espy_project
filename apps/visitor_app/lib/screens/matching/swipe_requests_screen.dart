import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import '../../l10n/app_localizations.dart';
import 'package:shared_core/services/auth_service.dart';
import '../../core/theme.dart';
import 'package:shared_core/services/firestore_service.dart';

class SwipeRequestsScreen extends StatefulWidget {
  const SwipeRequestsScreen({super.key});

  @override
  State<SwipeRequestsScreen> createState() => _SwipeRequestsScreenState();
}

class _SwipeRequestsScreenState extends State<SwipeRequestsScreen> {
  final FirestoreService _firestore = FirestoreService();
  final CardSwiperController _controller = CardSwiperController();

  String _selectedFilterSectionId = 'All';
  String _selectedFilterCountry = 'ALL';
  bool _newestFirst = true;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final role = auth.userData?['role'];
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "REQUESTS POOL",
                  style: GoogleFonts.cinzel(fontSize: 12, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep, letterSpacing: 2),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _firestore.getCommunityRequests(sectionId: _selectedFilterSectionId, newestFirst: _newestFirst),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: EspyTheme.gold),
                  );
                }

                List<Map<String, dynamic>> allRequests = snapshot.data ?? [];

                // Local Filtering for Country (since getCommunityRequests only handles status/section)
                if (_selectedFilterCountry != 'ALL') {
                  allRequests = allRequests.where((r) => (r['location'] ?? 'LEBANON').toString().toUpperCase().contains(_selectedFilterCountry)).toList();
                }
                
                // Secondary Sorting
                allRequests.sort((a, b) {
                  final t1 = (a['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
                  final t2 = (b['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
                  return _newestFirst ? t2.compareTo(t1) : t1.compareTo(t2);
                });

                if (allRequests.isEmpty) {
                  return Center(
                    child: Text(
                      l10n.noPendingRequests.toUpperCase(),
                      style: GoogleFonts.cinzel(
                          color: EspyTheme.navyDeep.withValues(alpha: 0.3),
                          fontSize: 12,
                          fontWeight: FontWeight.w900),
                    ),
                  );
                }

                return Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 20, 8, 80),
                            child: CardSwiper(
                              controller: _controller,
                              cardsCount: allRequests.length,
                              numberOfCardsDisplayed: 3,
                              backCardOffset: const Offset(0, 40),
                              padding: EdgeInsets.zero,
                              cardBuilder: (context, index, horizontalThreshold, verticalThreshold) {
                                return _buildRequestCard(allRequests[index]);
                              },
                              onSwipe: (previousIndex, currentIndex, direction) async {
                                final target = allRequests[previousIndex];
                                final userId = _firestore.getCurrentUserId;

                                if (direction == CardSwiperDirection.right) {
                                  _firestore.recordInteraction(
                                    userId: userId,
                                    targetId: target['id'],
                                    type: 'request_match',
                                  );

                                  // WhatsApp Redirection
                                  final userData = auth.userData;
                                  final userName = userData?['fullNameEn'] ?? userData?['name'] ?? "User";
                                  final userRole = (userData?['role'] ?? "Provider").toString().toUpperCase();
                                  final userSector = (userData?['sectorId'] ?? "General Care").toString().toUpperCase();
                                  final appName = l10n.appTitle;

                                  String org = "Hope Network";
                                  if (role == 'institution') {
                                    org = userData?['fullNameEn'] ?? userData?['name'] ?? "Hope Institution";
                                  } else if (role == 'professional') {
                                    org = userData?['specialization'] ?? "Hope Specialist";
                                  }

                                  final reqTitle = target['title'] ?? "Care Request";
                                  final reqId = target['id'] ?? "Unknown";
                                  final targetWhatsapp = target['whatsapp']?.toString().replaceAll(RegExp(r'\D'), '');

                                  if (targetWhatsapp != null && targetWhatsapp.isNotEmpty) {
                                    final msg = "Hello, I am $userName from $org, responding to your help request: '$reqTitle' (ID: $reqId) on $appName. I'm a $userRole in the $userSector sector and I'd like to offer my assistance. How can I best support you?";
                                    final url = "https://wa.me/$targetWhatsapp?text=${Uri.encodeComponent(msg)}";

                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                                    }
                                  }

                                  // Record notification for the visitor (target)
                                  if (target['userId'] != null) {
                                     FirebaseFirestore.instance.collection('directory_notifications').add({
                                       'userId': target['userId'],
                                       'title': l10n.matchInterest.toUpperCase(),
                                       'message': l10n.matchInterestDesc,
                                       'timestamp': FieldValue.serverTimestamp(),
                                     });
                                  }
                                }
                                return true;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: EspyTheme.space8,
                      left: 0,
                      right: 0,
                      child: _buildActionButtons(),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _firestore.getSectors(),
      builder: (context, snapshot) {
        final sectors = snapshot.data ?? [];
        final items = [{'id': 'All', 'name_en': 'All'}, ...sectors];

        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final s = items[index];
                    final sId = s['id'] as String;
                    final isSelected = _selectedFilterSectionId == sId;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedFilterSectionId = sId),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? EspyTheme.royalBlue : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? EspyTheme.royalBlue : Colors.black.withValues(alpha: 0.1)),
                          boxShadow: isSelected ? [BoxShadow(color: EspyTheme.royalBlue.withValues(alpha: 0.2), blurRadius: 10)] : null,
                        ),
                        child: Center(
                          child: Text(
                            (s['name_en'] as String).toUpperCase(),
                            style: GoogleFonts.cinzel(
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                              color: isSelected ? Colors.white : EspyTheme.navyDeep.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              IconButton(
                icon: Icon(_newestFirst ? Icons.south_rounded : Icons.north_rounded, color: EspyTheme.navyDeep, size: 18),
                onPressed: () => setState(() => _newestFirst = !_newestFirst),
                tooltip: _newestFirst ? 'Newest First' : 'Oldest First',
              ),
              const SizedBox(width: 10),
            ],
          ),
        );
      }
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    final bool isEmergency = request['isSOS'] == true;

    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.98),
          borderRadius: BorderRadius.circular(36),
          border: Border.all(
            color: isEmergency ? EspyTheme.error : EspyTheme.gold.withValues(alpha: 0.15),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isEmergency
                ? EspyTheme.error.withValues(alpha: 0.1)
                : EspyTheme.navyDeep.withValues(alpha: 0.08),
              blurRadius: 30,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Artistic Branding Pattern
              Positioned(
                top: -60,
                right: -60,
                child: Icon(
                  isEmergency ? Icons.sos_rounded : Icons.auto_awesome_rounded,
                  size: 280,
                  color: isEmergency ? EspyTheme.error.withValues(alpha: 0.03) : EspyTheme.gold.withValues(alpha: 0.03),
                ),
              ),

              // Gradient Accent
              Positioned(
                top: 0, left: 0, right: 0, height: 6,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: isEmergency ? const LinearGradient(colors: [Colors.redAccent, Colors.red]) : EspyTheme.metallicGold,
                  ),
                ),
              ),

              // Content Layer
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: isEmergency ? EspyTheme.error.withValues(alpha: 0.1) : EspyTheme.gold.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            (request['section'] ?? request['category'] ?? 'CARE').toString().toUpperCase(),
                            style: GoogleFonts.cinzel(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: isEmergency ? EspyTheme.error : EspyTheme.goldDark,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        if (isEmergency)
                          Pulse(
                            infinite: true,
                            child: const Icon(Icons.emergency_rounded, color: EspyTheme.error, size: 24),
                          ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      request['title'] ?? 'Help Request',
                      style: GoogleFonts.cinzel(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: EspyTheme.navyDeep,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 40, height: 3,
                      decoration: BoxDecoration(color: EspyTheme.gold.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Text(
                          request['description'] ?? '',
                          style: GoogleFonts.lora(
                            fontSize: 15,
                            color: EspyTheme.navyDeep.withValues(alpha: 0.7),
                            height: 1.7,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Divider(color: EspyTheme.navyDeep.withValues(alpha: 0.05)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: EspyTheme.platinum, borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.location_on_rounded, color: EspyTheme.gold, size: 20),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "REQUEST COORDINATES",
                                style: GoogleFonts.cinzel(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.black26, letterSpacing: 1),
                              ),
                              Text(
                                request['location'] ?? 'Beirut, Lebanon',
                                style: GoogleFonts.lora(color: EspyTheme.navyDeep, fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final bool filtersActive = _selectedFilterSectionId != 'All' || _selectedFilterCountry != 'ALL';
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            _buildCircleBtn(
              icon: Icons.tune_rounded,
              color: EspyTheme.gold,
              onTap: () => _showFilterModal(l10n),
              isSmall: true,
            ),
            if (filtersActive)
              Positioned(
                top: 4, right: 4,
                child: Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                ),
              ),
          ],
        ),
        const SizedBox(width: 16),
        _buildCircleBtn(
          icon: Icons.close_rounded,
          color: EspyTheme.error,
          onTap: () => _controller.swipe(CardSwiperDirection.left),
        ),
        const SizedBox(width: 16),
        _buildCircleBtn(
          icon: Icons.check_circle_outline_rounded, // Improved to function related
          color: Colors.green,
          onTap: () => _controller.swipe(CardSwiperDirection.right),
          isLarge: true,
        ),
        const SizedBox(width: 16),
        _buildCircleBtn(
          icon: Icons.info_outline_rounded,
          color: EspyTheme.gold,
          onTap: () {},
        ),
      ],
    );
  }

  void _showFilterModal(AppLocalizations l10n) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 48),
          decoration: const BoxDecoration(
            color: EspyTheme.platinum,
            borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(color: EspyTheme.navyDeep.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("REQUEST FILTERS", style: GoogleFonts.cinzel(fontSize: 22, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep, letterSpacing: 2)),
                  IconButton(
                    icon: Icon(_newestFirst ? Icons.south_rounded : Icons.north_rounded, color: EspyTheme.gold),
                    onPressed: () {
                      setModalState(() => _newestFirst = !_newestFirst);
                      setState(() => _newestFirst = !_newestFirst);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Country
              Text("USER LOCATION (COUNTRY)", style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.royalBlue, letterSpacing: 2)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                children: [
                  _filterChip("ALL", _selectedFilterCountry == 'ALL', () {
                    setModalState(() => _selectedFilterCountry = 'ALL');
                    setState(() => _selectedFilterCountry = 'ALL');
                  }),
                  _filterChip("LEBANON", _selectedFilterCountry == 'LEBANON', () {
                    setModalState(() => _selectedFilterCountry = 'LEBANON');
                    setState(() => _selectedFilterCountry = 'LEBANON');
                  }),
                  _filterChip("GLOBAL", _selectedFilterCountry == 'GLOBAL', () {
                    setModalState(() => _selectedFilterCountry = 'GLOBAL');
                    setState(() => _selectedFilterCountry = 'GLOBAL');
                  }),
                ],
              ),
              const SizedBox(height: 24),

              // Sector
              Text("CARE SECTOR", style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.royalBlue, letterSpacing: 2)),
              const SizedBox(height: 12),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: _firestore.getSectors(),
                builder: (context, snapshot) {
                  final sectors = snapshot.data ?? [];
                  return Wrap(
                    spacing: 12, runSpacing: 12,
                    children: [
                      _filterChip("ALL", _selectedFilterSectionId == 'All', () {
                        setModalState(() => _selectedFilterSectionId = 'All');
                        setState(() => _selectedFilterSectionId = 'All');
                      }),
                      ...sectors.map((s) => _filterChip(
                        (isAr ? s['name_ar'] : s['name_en']) ?? s['name_en'] ?? 'OTHER',
                        _selectedFilterSectionId == s['id'],
                        () {
                          setModalState(() => _selectedFilterSectionId = s['id']);
                          setState(() => _selectedFilterSectionId = s['id']);
                        }
                      )),
                    ],
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterChip(String label, bool selected, VoidCallback onSelected) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (v) => onSelected(),
      selectedColor: EspyTheme.gold,
      checkmarkColor: Colors.white,
      labelStyle: GoogleFonts.montserrat(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: selected ? Colors.white : Colors.black54
      ),
      backgroundColor: Colors.black.withValues(alpha: 0.05),
      side: BorderSide.none,
    );
  }

  Widget _buildCircleBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isLarge = false,
    bool isSmall = false,
  }) {
    double size = isLarge ? 64 : (isSmall ? 44 : 54);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: color.withValues(alpha: 0.2), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: isLarge ? 28 : (isSmall ? 18 : 22)),
      ),
    );
  }
}
