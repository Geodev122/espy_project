import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import 'package:espy_app/l10n/app_localizations.dart';
import 'package:espy_app/viewmodels/auth_service.dart';
import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/viewmodels/requests_view_model.dart';
import 'package:espy_app/widgets/common/premium_button.dart';

class SwipeRequestsScreen extends StatefulWidget {
  const SwipeRequestsScreen({super.key});

  @override
  State<SwipeRequestsScreen> createState() => _SwipeRequestsScreenState();
}

class _SwipeRequestsScreenState extends State<SwipeRequestsScreen> {
  final CardSwiperController _controller = CardSwiperController();
  int _stackKey = 0;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final user = auth.userData;
    final viewModel = Provider.of<RequestsViewModel>(context);
    final l10n = AppLocalizations.of(context)!;

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator(color: EspyTheme.gold));
    }

    if (viewModel.requests.isEmpty) {
      return Center(
        child: Text(
          l10n.noPendingRequests.toUpperCase(),
          style: GoogleFonts.cinzel(color: EspyTheme.navyDeep.withValues(alpha: 0.3), fontSize: 12, fontWeight: FontWeight.w900),
        ),
      );
    }

    final displayCards = [
      ...viewModel.requests,
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
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 180),
                child: CardSwiper(
                  key: ValueKey(_stackKey),
                  controller: _controller,
                  cardsCount: displayCards.length,
                  numberOfCardsDisplayed: displayCards.length > 3 ? 3 : displayCards.length,
                  backCardOffset: const Offset(0, 40),
                  padding: EdgeInsets.zero,
                  cardBuilder: (context, index, _, __) {
                    final data = displayCards[index];
                    if (data['isEnd'] == true) return _buildEndCard(l10n);
                    return _buildRequestCard(data, l10n);
                  },
                  onSwipe: (previousIndex, currentIndex, direction) async {
                    final target = displayCards[previousIndex];
                    if (target['isEnd'] == true) return false;

                    if (direction == CardSwiperDirection.right) {
                      // Logic for recording interaction and launching WhatsApp
                      final userName = user?.name ?? "User";
                      
                      final reqTitle = target['title'] ?? "Care Request";
                      final targetWhatsapp = target['whatsapp']?.toString().replaceAll(RegExp(r'\D'), '');

                      if (targetWhatsapp != null && targetWhatsapp.isNotEmpty) {
                        final msg = "Hello, I am $userName, responding to your request: '$reqTitle' on Espy. I'd like to offer my assistance.";
                        final url = "https://wa.me/$targetWhatsapp?text=${Uri.encodeComponent(msg)}";
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                        }
                      }
                    } else if (direction == CardSwiperDirection.left) {
                      await viewModel.favoriteRequest(target['id'] as String, true);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.protocolSavedFavorites), behavior: SnackBarBehavior.floating),
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
        Positioned(bottom: 130, left: 0, right: 0, child: _buildActionButtons(viewModel, l10n)),
      ],
    );
  }

  Widget _buildEndCard(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: EspyTheme.navyDeep.withValues(alpha: 0.1)),
      ),
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline_rounded, size: 80, color: EspyTheme.success),
          const SizedBox(height: 24),
          Text(l10n.queueCleared.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 22, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep)),
          const SizedBox(height: 16),
          Text(l10n.reviewedAllRequests, textAlign: TextAlign.center, style: GoogleFonts.lora(fontSize: 14, color: Colors.black45)),
          const SizedBox(height: 32),
          PremiumButton(
            label: "RESTART PROTOCOL",
            onPressed: () => setState(() => _stackKey++),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request, AppLocalizations l10n) {
    final bool isEmergency = request['isSOS'] == true;
    final viewModel = Provider.of<RequestsViewModel>(context, listen: false);
    final bool isFavorite = viewModel.favoriteIds.contains(request['id']);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: isEmergency ? EspyTheme.error : EspyTheme.gold.withValues(alpha: 0.15), width: 2),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(color: isEmergency ? EspyTheme.error.withValues(alpha: 0.1) : EspyTheme.gold.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      (request['section'] ?? request['category'] ?? 'CARE').toString().toUpperCase(),
                      style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: isEmergency ? EspyTheme.error : EspyTheme.goldDark, letterSpacing: 2),
                    ),
                  ),
                  if (isFavorite) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.favorite, color: EspyTheme.gold, size: 16),
                  ],
                ],
              ),
              if (isEmergency) const Icon(Icons.emergency_rounded, color: EspyTheme.error, size: 24),
            ],
          ),
          const SizedBox(height: 32),
          Text(request['title'] ?? 'Help Request', style: GoogleFonts.cinzel(fontSize: 26, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep, height: 1.1)),
          const SizedBox(height: 24),
          Expanded(child: SingleChildScrollView(child: Text(request['description'] ?? '', style: GoogleFonts.lora(fontSize: 15, color: EspyTheme.navyDeep.withValues(alpha: 0.7), height: 1.7, fontStyle: FontStyle.italic)))),
          const SizedBox(height: 32),
          Row(
            children: [
              const Icon(Icons.location_on_rounded, color: EspyTheme.gold, size: 20),
              const SizedBox(width: 16),
              Expanded(child: Text(request['location'] ?? 'Beirut, Lebanon', style: GoogleFonts.lora(color: EspyTheme.navyDeep, fontSize: 13, fontWeight: FontWeight.bold))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(RequestsViewModel vm, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCircleBtn(icon: Icons.tune_rounded, color: EspyTheme.gold, onTap: () => _showFilterModal(vm, l10n), isSmall: true),
        const SizedBox(width: 20),
        _buildCircleBtn(icon: Icons.favorite_border_rounded, color: EspyTheme.gold, onTap: () => _controller.swipe(CardSwiperDirection.left)),
        const SizedBox(width: 20),
        _buildCircleBtn(icon: Icons.chat_bubble_outline_rounded, color: Colors.green, onTap: () => _controller.swipe(CardSwiperDirection.right), isLarge: true),
      ],
    );
  }

  void _showFilterModal(RequestsViewModel vm, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(32, 24, 32, 48),
        decoration: const BoxDecoration(color: EspyTheme.platinum, borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.requestFilters.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 22, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep)),
            const SizedBox(height: 32),
            SwitchListTile(
              title: Text(l10n.newestFirst.toUpperCase()),
              value: vm.newestFirst,
              onChanged: (v) {
                Navigator.pop(context);
                vm.toggleSortOrder();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleBtn({required IconData icon, required Color color, required VoidCallback onTap, bool isLarge = false, bool isSmall = false}) {
    double size = isLarge ? 64 : (isSmall ? 44 : 54);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: color.withValues(alpha: 0.2), width: 2)),
        child: Icon(icon, color: color, size: isLarge ? 28 : (isSmall ? 18 : 22)),
      ),
    );
  }
}
