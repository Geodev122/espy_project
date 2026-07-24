import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:espy_core/espy_core.dart';
import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/l10n/app_localizations.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';
import 'package:espy_app/widgets/matching/adaptive_slot_card.dart';

class ServiceSwipeScreen extends StatefulWidget {
  const ServiceSwipeScreen({super.key});

  @override
  State<ServiceSwipeScreen> createState() => _ServiceSwipeScreenState();
}

class _ServiceSwipeScreenState extends State<ServiceSwipeScreen> {
  final CardSwiperController _controller = CardSwiperController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MatchingViewModel>(context);
    final l10n = AppLocalizations.of(context)!;

    return EspyScaffold(
      useCinematicBackground: false,
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator(color: EspyTheme.gold))
          : viewModel.services.isEmpty
              ? Center(child: Text(l10n.noActiveServicesFound.toUpperCase(), style: GoogleFonts.cinzel(color: EspyTheme.navyDeep.withValues(alpha: 0.3), fontWeight: FontWeight.w900)))
              : Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 20, 8, 160),
                      child: CardSwiper(
                        controller: _controller,
                        cardsCount: viewModel.services.length,
                        numberOfCardsDisplayed: viewModel.services.length > 3 ? 3 : viewModel.services.length,
                        backCardOffset: const Offset(0, 40),
                        cardBuilder: (context, index, _, __) {
                          return AdaptiveSlotCard(service: viewModel.services[index]);
                        },
                        onSwipe: (previousIndex, _, direction) async {
                          final target = viewModel.services[previousIndex];
                          if (direction == CardSwiperDirection.right) {
                            await viewModel.recordInteraction(target.id, InteractionType.like);
                            // Connect logic...
                          }
                          return true;
                        },
                      ),
                    ),
                    Positioned(bottom: 20, left: 0, right: 0, child: _buildActionButtons()),
                  ],
                ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCircleBtn(icon: Icons.close, color: EspyTheme.error, onTap: () => _controller.swipe(CardSwiperDirection.left)),
        const SizedBox(width: 24),
        _buildCircleBtn(icon: Icons.favorite, color: EspyTheme.royalBlue, onTap: () => _controller.swipe(CardSwiperDirection.right), isLarge: true),
      ],
    );
  }

  Widget _buildCircleBtn({required IconData icon, required Color color, required VoidCallback onTap, bool isLarge = false}) {
    double size = isLarge ? 72 : 56;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)]),
        child: Icon(icon, color: color, size: isLarge ? 32 : 24),
      ),
    );
  }
}
