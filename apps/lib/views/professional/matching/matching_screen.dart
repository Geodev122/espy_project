import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import 'package:espy_app/l10n/app_localizations.dart';
import 'package:shared_core/theme/espy_theme.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/services/firestore_service.dart';
import 'package:shared_core/viewmodels/matching_view_model.dart';
import 'package:shared_core/widgets/common/premium_button.dart';

class MatchingScreen extends StatefulWidget {
  const MatchingScreen({super.key});

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  final CardSwiperController _controller = CardSwiperController();
  int _stackKey = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = Provider.of<AuthService>(context, listen: false);
    final viewModel = Provider.of<MatchingViewModel>(context);

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator(color: EspyTheme.gold));
    }

    final displayCards = [
      {
        'id': 'info_card',
        'isInfo': true,
        'hasResults': viewModel.services.isNotEmpty,
      },
      ...viewModel.services,
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
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 180),
                child: CardSwiper(
                  key: ValueKey(_stackKey),
                  controller: _controller,
                  cardsCount: displayCards.length,
                  numberOfCardsDisplayed: displayCards.length > 3 ? 3 : displayCards.length,
                  backCardOffset: const Offset(0, 40),
                  padding: EdgeInsets.zero,
                  cardBuilder: (context, index, horizontalThreshold, verticalThreshold) {
                    final cardData = displayCards[index];
                    if (cardData['isInfo'] == true) return _buildInfoCard(cardData['hasResults'] as bool);
                    if (cardData['isEnd'] == true) return _buildEndCard();
                    return _buildSwipeCard(cardData);
                  },
                  onSwipe: (previousIndex, currentIndex, direction) async {
                    final target = displayCards[previousIndex];
                    if (target['isInfo'] == true || target['isEnd'] == true) return true;

                    if (direction == CardSwiperDirection.right) {
                      await viewModel.recordInteraction(target['id'] as String, 'like');

                      final userData = auth.userData;
                      final userName = userData?.name ?? "User";
                      final userRole = (userData?.role.name ?? "visitor").toUpperCase();
                      
                      final targetName = target['fullNameEn'] ?? target['name'] ?? "Specialist";
                      final targetWhatsapp = target['whatsapp']?.toString().replaceAll(RegExp(r'\D'), '');

                      if (targetWhatsapp != null && targetWhatsapp.isNotEmpty) {
                        final msg = "Hello $targetName, I am $userName, a $userRole. I found your professional profile on Espy. Would you be open to discussing a potential care collaboration?";
                        final url = "https://wa.me/$targetWhatsapp?text=${Uri.encodeComponent(msg)}";
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                        }
                      }
                    } else if (direction == CardSwiperDirection.left) {
                      await viewModel.toggleFavorite(target['id'] as String, true);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Protocol saved to Vault Favorites"), behavior: SnackBarBehavior.floating),
                        );
                      }
                    } else if (direction == CardSwiperDirection.top) {
                      await viewModel.recordInteraction(target['id'] as String, 'skip');
                    }
                    return true;
                  },
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 140, left: 0, right: 0,
          child: _buildActionButtons(l10n, viewModel),
        ),
      ],
    );
  }

  Widget _buildEndCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: EspyTheme.gold.withOpacity(0.2), width: 2),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline_rounded, size: 80, color: EspyTheme.success),
          const SizedBox(height: 24),
          Text("PROTOCOL SCAN COMPLETE", style: GoogleFonts.cinzel(fontSize: 20, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep)),
          const SizedBox(height: 16),
          Text("You have reviewed all active protocols.", textAlign: TextAlign.center, style: GoogleFonts.lora(fontSize: 14, color: Colors.black45)),
          const SizedBox(height: 32),
          PremiumButton(
            label: "RESTART PROTOCOL",
            onPressed: () => setState(() => _stackKey++),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(bool hasResults) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: EspyTheme.gold.withOpacity(0.2), width: 2),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(hasResults ? Icons.auto_awesome_rounded : Icons.search_off_rounded, size: 64, color: EspyTheme.gold),
          const SizedBox(height: 24),
          Text(hasResults ? "PROTOCOL GUIDE" : "NO SERVICES FOUND", style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep)),
          const SizedBox(height: 16),
          Text(
            hasResults
              ? "• Swipe LEFT to skip\n• Swipe RIGHT to contact\n• Swipe UP to favorite"
              : "Adjust filters to capture more services.",
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(fontSize: 14, color: Colors.black54, height: 1.6),
          ),
          const SizedBox(height: 32),
          Text("SWIPE TO BEGIN", style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.gold, letterSpacing: 2)),
        ],
      ),
    );
  }

  Widget _buildSwipeCard(Map<String, dynamic> prof) {
    final viewModel = Provider.of<MatchingViewModel>(context, listen: false);
    final bool isFavorite = viewModel.favoriteIds.contains(prof['id']);
    final bool isContacted = viewModel.contactedIds.contains(prof['id']);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 30, offset: const Offset(0, 15))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (prof['photoUrl'] != null)
              CachedNetworkImage(imageUrl: prof['photoUrl'], fit: BoxFit.cover)
            else
              Container(color: Colors.white10, child: const Icon(Icons.person, size: 120, color: EspyTheme.royalBlue)),

            Positioned(
              top: 20, left: 20,
              child: Row(
                children: [
                  if (isFavorite) _buildBadge("FAVORITE", EspyTheme.gold, Icons.favorite),
                  if (isContacted) _buildBadge("CONTACTED", EspyTheme.success, Icons.check_circle),
                ],
              ),
            ),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: const [0.0, 0.4],
                    colors: [EspyTheme.navyDeep.withOpacity(0.9), Colors.transparent],
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
                    Text(prof['fullNameEn'] ?? prof['name'] ?? 'SPECIALIST', style: GoogleFonts.montserrat(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1)),
                    const SizedBox(height: 8),
                    Text(prof['specialization']?.toString().toUpperCase() ?? 'CARE PROVIDER', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w800, color: EspyTheme.gold, letterSpacing: 1)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 10),
          const SizedBox(width: 4),
          Text(label, style: GoogleFonts.montserrat(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(AppLocalizations l10n, MatchingViewModel vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCircleBtn(icon: Icons.block_rounded, color: EspyTheme.error, onTap: () => _controller.swipe(CardSwiperDirection.left)),
        const SizedBox(width: 16),
        _buildCircleBtn(icon: Icons.chat_bubble_outline_rounded, color: EspyTheme.royalBlue, onTap: () => _controller.swipe(CardSwiperDirection.right), isLarge: true),
        const SizedBox(width: 16),
        _buildCircleBtn(icon: Icons.bookmark_border_rounded, color: EspyTheme.gold, onTap: () => _controller.swipe(CardSwiperDirection.top)),
      ],
    );
  }

  Widget _buildCircleBtn({required IconData icon, required Color color, required VoidCallback onTap, bool isLarge = false}) {
    double size = isLarge ? 64 : 54;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)]),
        child: Icon(icon, color: color, size: isLarge ? 28 : 22),
      ),
    );
  }
}
