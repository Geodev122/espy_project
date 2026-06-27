import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../../l10n/app_localizations.dart';
import 'package:shared_core/theme/espy_theme.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/services/firestore_service.dart';
import 'package:shared_core/models/user_model.dart';

class MatchingScreen extends StatefulWidget {
  const MatchingScreen({super.key});

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  final FirestoreService _firestore = FirestoreService();
  final CardSwiperController _controller = CardSwiperController();
  List<Map<String, dynamic>> _displayCards = [];
  int _currentIndex = 0;
  String? _filterSectorId;
  String? _filterPriceTagId;
  String _filterCountry = 'ALL';
  bool _newestFirst = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = Provider.of<AuthService>(context, listen: false);

    return Column(
      children: [
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: _firestore.getAllActiveServices(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(color: EspyTheme.gold));
              }

              List<Map<String, dynamic>> allServices = snapshot.data ?? [];

              // Local Filtering
              List<Map<String, dynamic>> filtered = allServices.where((s) {
                if (_filterSectorId != null && s['sectorId'] != _filterSectorId) return false;
                if (_filterPriceTagId != null && s['priceTagId'] != _filterPriceTagId) return false;
                if (_filterCountry != 'ALL' && (s['countryId'] ?? s['country'] ?? 'LEBANON').toString().toUpperCase() != _filterCountry.toUpperCase()) return false;
                return true;
              }).toList();

              // Sorting
              filtered.sort((a, b) {
                final t1 = (a['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
                final t2 = (b['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
                return _newestFirst ? t2.compareTo(t1) : t1.compareTo(t2);
              });

              _displayCards = [
                {
                  'id': 'info_card',
                  'isInfo': true,
                  'hasResults': filtered.isNotEmpty,
                },
                ...filtered,
                {
                  'id': 'end_card',
                  'isEnd': true,
                },
              ];

              return Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 120),
                          child: CardSwiper(
                            controller: _controller,
                            cardsCount: _displayCards.length,
                            numberOfCardsDisplayed: _displayCards.length > 3 ? 3 : _displayCards.length,
                            backCardOffset: const Offset(0, 40),
                            padding: EdgeInsets.zero,
                            cardBuilder: (context, index, horizontalThreshold,
                                verticalThreshold) {
                              final cardData = _displayCards[index];
                              if (cardData['isInfo'] == true) {
                                return _buildInfoCard(cardData['hasResults']);
                              }
                              if (cardData['isEnd'] == true) {
                                return _buildEndCard();
                              }
                              return _buildSwipeCard(cardData);
                            },
                            onSwipe: (previousIndex, currentIndex, direction) async {
                              setState(() => _currentIndex = currentIndex ?? 0);
                              final target = _displayCards[previousIndex];
                              if (target['isInfo'] == true) return true;
                              if (target['isEnd'] == true) return false;

                              final userId = _firestore.getCurrentUserId;

                              if (direction == CardSwiperDirection.right) {
                                await _firestore.recordInteraction(
                                  userId: userId,
                                  targetId: target['id'],
                                  type: 'like',
                                );

                                final user = auth.userData;
                                final userName = user?.name ?? "User";
                                final userRole = (user?.role.name ?? "Visitor").toUpperCase();
                                final appName = l10n.appTitle;

                                final targetName = target['fullNameEn'] ?? target['name'] ?? "Specialist";
                                final targetWhatsapp = target['whatsapp']?.toString().replaceAll(RegExp(r'\D'), '');

                                if (targetWhatsapp != null && targetWhatsapp.isNotEmpty) {
                                  final msg = "Hello $targetName, I am $userName, a $userRole. I found your professional profile on $appName. Would you be open to discussing a potential care collaboration?";
                                  final url = "https://wa.me/$targetWhatsapp?text=${Uri.encodeComponent(msg)}";

                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                                  }
                                }
                              } else if (direction == CardSwiperDirection.left) {
                                await _firestore.recordInteraction(
                                  userId: userId,
                                  targetId: target['id'],
                                  type: 'dislike',
                                );
                              } else if (direction == CardSwiperDirection.top) {
                                await _firestore.toggleFavorite(userId, target['id'], true);
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Protocol saved to favorites"), behavior: SnackBarBehavior.floating),
                                  );
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
                    bottom: 110,
                    left: 0,
                    right: 0,
                    child: _buildActionButtons(l10n),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEndCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: EspyTheme.navyDeep.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline_rounded, size: 80, color: EspyTheme.success),
          const SizedBox(height: 24),
          Text("PROTOCOL END", style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep)),
          const SizedBox(height: 16),
          Text("You have reviewed all active protocols in this category.", textAlign: TextAlign.center, style: GoogleFonts.lora(fontSize: 14, color: Colors.black45)),
        ],
      ),
    );
  }

  Widget _buildInfoCard(bool hasResults) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: EspyTheme.gold.withValues(alpha: 0.2), width: 2),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20)],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasResults ? Icons.auto_awesome_rounded : Icons.search_off_rounded,
            size: 64,
            color: EspyTheme.gold,
          ),
          const SizedBox(height: 24),
          Text(
            hasResults ? "PROTOCOL GUIDE" : "NO SERVICES FOUND",
            style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep),
          ),
          const SizedBox(height: 16),
          Text(
            hasResults
              ? "• Swipe LEFT to skip\n• Swipe RIGHT to contact via WhatsApp\n• Swipe UP to save to favorites"
              : "Adjust filters to capture more or wait until providers publish more services.",
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(fontSize: 14, color: Colors.black54, height: 1.6),
          ),
          const SizedBox(height: 32),
          Text(
            "SWIPE TO BEGIN",
            style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.gold, letterSpacing: 2),
          ),
        ],
      ),
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
                  Text("MATCH FILTERS", style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep, letterSpacing: 1)),
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
              Text("USER LOCATION", style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.royalBlue, letterSpacing: 1)),
              const SizedBox(height: 12),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: _firestore.getCountries(),
                builder: (context, snapshot) {
                  final countries = snapshot.data ?? [];
                  return Wrap(
                    spacing: 12, runSpacing: 8,
                    children: [
                      _filterChip("ALL", _filterCountry == 'ALL', () {
                        setModalState(() => _filterCountry = 'ALL');
                        setState(() => _filterCountry = 'ALL');
                      }),
                      ...countries.map((c) => _filterChip(
                        c['name_en'].toString().toUpperCase(),
                        _filterCountry == c['id'],
                        () {
                          setModalState(() => _filterCountry = c['id']);
                          setState(() => _filterCountry = c['id']);
                        }
                      )),
                      _filterChip("GLOBAL", _filterCountry == 'GLOBAL', () {
                        setModalState(() => _filterCountry = 'GLOBAL');
                        setState(() => _filterCountry = 'GLOBAL');
                      }),
                    ],
                  );
                }
              ),
              const SizedBox(height: 24),
              Text("CARE SECTOR", style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.royalBlue, letterSpacing: 1)),
              const SizedBox(height: 12),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: _firestore.getSectors(),
                builder: (context, snapshot) {
                  final sectors = snapshot.data ?? [];
                  return Wrap(
                    spacing: 12, runSpacing: 12,
                    children: [
                      _filterChip("ALL", _filterSectorId == null, () {
                        setModalState(() => _filterSectorId = null);
                        setState(() => _filterSectorId = null);
                      }),
                      ...sectors.map((s) => _filterChip(
                        (isAr ? s['name_ar'] : s['name_en']) ?? s['name_en'] ?? 'OTHER',
                        _filterSectorId == s['id'],
                        () {
                          setModalState(() => _filterSectorId = s['id']);
                          setState(() => _filterSectorId = s['id']);
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

  Widget _buildSwipeCard(Map<String, dynamic> prof) {
    final l10n = AppLocalizations.of(context)!;
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: EspyTheme.royalBlue.withValues(alpha: 0.1), width: 1.5),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 30, offset: const Offset(0, 15))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (prof['photoUrl'] != null)
                CachedNetworkImage(
                  imageUrl: prof['photoUrl'],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: EspyTheme.royalBlue)),
                  errorWidget: (context, url, error) => const Icon(Icons.error, color: EspyTheme.royalBlue),
                )
              else
                Container(color: Colors.white10, child: const Icon(Icons.person, size: 120, color: EspyTheme.royalBlue)),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: const [0.0, 0.4, 0.8],
                      colors: [EspyTheme.navyDeep.withValues(alpha: 0.9), EspyTheme.navyDeep.withValues(alpha: 0.2), Colors.transparent],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              prof['fullNameEn'] ?? prof['name'] ?? l10n.professionalLabel,
                              style: GoogleFonts.montserrat(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1),
                            ),
                          ),
                          if (prof['isVerified'] == true)
                            const Icon(Icons.verified, color: EspyTheme.skyBlue, size: 24),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        prof['specialization']?.toString().toUpperCase() ?? l10n.specialist.toUpperCase(),
                        style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w800, color: EspyTheme.gold, letterSpacing: 1),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: EspyTheme.gold, size: 14),
                          const SizedBox(width: 6),
                          Text(prof['location'] ?? 'Lebanon', style: GoogleFonts.lora(color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(AppLocalizations l10n) {
    final bool filtersActive = _filterSectorId != null || _filterPriceTagId != null || _filterCountry != 'ALL';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            _buildCircleBtn(icon: Icons.tune_rounded, color: EspyTheme.gold, onTap: () => _showFilterModal(l10n), isSmall: true),
            if (filtersActive)
              Positioned(top: 4, right: 4, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle))),
          ],
        ),
        const SizedBox(width: 16),
        _buildCircleBtn(icon: Icons.block_rounded, color: EspyTheme.error, onTap: () => _controller.swipe(CardSwiperDirection.left)),
        const SizedBox(width: 16),
        _buildCircleBtn(icon: Icons.chat_bubble_outline_rounded, color: EspyTheme.royalBlue, onTap: () => _controller.swipe(CardSwiperDirection.right), isLarge: true),
        const SizedBox(width: 16),
        _buildCircleBtn(icon: Icons.bookmark_border_rounded, color: EspyTheme.gold, onTap: () => _controller.swipe(CardSwiperDirection.top)),
        const SizedBox(width: 16),
        _buildCircleBtn(icon: Icons.share_rounded, color: EspyTheme.cyan, onTap: _shareCurrentCard, isSmall: true),
      ],
    );
  }

  void _shareCurrentCard() {
    if (_currentIndex < 0 || _currentIndex >= _displayCards.length) return;
    final target = _displayCards[_currentIndex];
    if (target['isInfo'] == true) return;
    final String name = target['fullNameEn'] ?? target['name'] ?? "Specialist";
    final String text = "Check out this verified protocol on Espy: $name\nConnect via: https://hope-bearer-award-support.web.app/#/directory/professional/${target['id']}";
    Share.share(text);
  }

  Widget _buildCircleBtn({required IconData icon, required Color color, required VoidCallback onTap, bool isLarge = false, bool isSmall = false}) {
    double size = isLarge ? 64 : (isSmall ? 44 : 54);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.9),
          border: Border.all(color: color.withValues(alpha: 0.1), width: 2),
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: Icon(icon, color: color, size: isLarge ? 28 : (isSmall ? 18 : 22)),
      ),
    );
  }
}
