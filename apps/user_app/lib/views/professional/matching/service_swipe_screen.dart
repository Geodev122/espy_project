import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/viewmodels/matching_view_model.dart';
import 'package:espy_app/l10n/app_localizations.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';

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
                    CardSwiper(
                      controller: _controller,
                      cardsCount: viewModel.services.length,
                      numberOfCardsDisplayed: 3,
                      backCardOffset: const Offset(0, 40),
                      cardBuilder: (context, index, _, __) {
                        return _buildServiceCard(viewModel.services[index]);
                      },
                      onSwipe: (previousIndex, currentIndex, direction) async {
                        final target = viewModel.services[previousIndex];
                        if (direction == CardSwiperDirection.right) {
                          await viewModel.recordInteraction(target['id'], 'service_like');
                          // WhatsApp logic...
                        }
                        return true;
                      },
                    ),
                    Positioned(bottom: 20, left: 0, right: 0, child: _buildActionButtons()),
                  ],
                ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 30)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (service['photoUrl'] != null)
              CachedNetworkImage(imageUrl: service['photoUrl'], fit: BoxFit.cover)
            else
              Container(color: Colors.white10, child: const Icon(Icons.medical_services, size: 48, color: EspyTheme.royalBlue)),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [EspyTheme.navyDeep.withValues(alpha: 0.9), Colors.transparent]),
                ),
              ),
            ),
            Positioned(
              bottom: 28, left: 28, right: 28,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(service['title']?.toString().toUpperCase() ?? 'SERVICE', style: GoogleFonts.cinzel(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('\$${service['price'] ?? '0'}', style: GoogleFonts.cinzel(color: EspyTheme.gold, fontWeight: FontWeight.w900, fontSize: 18)),
                ],
              ),
            ),
          ],
        ),
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
