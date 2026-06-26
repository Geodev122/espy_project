import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/services/firestore_service.dart';

class ServiceSwipeScreen extends StatefulWidget {
  const ServiceSwipeScreen({super.key});

  @override
  State<ServiceSwipeScreen> createState() => _ServiceSwipeScreenState();
}

class _ServiceSwipeScreenState extends State<ServiceSwipeScreen> {
  final FirestoreService _firestore = FirestoreService();
  final CardSwiperController _controller = CardSwiperController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestore.getAllActiveServices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: EspyTheme.gold));
          }

          final services = snapshot.data ?? [];

          if (services.isEmpty) {
            return Center(
              child: Text(
                'NO ACTIVE SERVICES FOUND',
                style: GoogleFonts.cinzel(color: EspyTheme.navyDeep.withValues(alpha: 0.3), fontSize: 12, fontWeight: FontWeight.w900),
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
                        key: ValueKey(services.length),
                        controller: _controller,
                        cardsCount: services.length,
                        numberOfCardsDisplayed: 3,
                        backCardOffset: const Offset(0, 40),
                        padding: EdgeInsets.zero,
                        cardBuilder: (context, index, horizontalThreshold, verticalThreshold) {
                          if (index >= services.length) return const SizedBox.shrink();
                          return _buildServiceCard(services[index]);
                        },
                        onSwipe: (previousIndex, currentIndex, direction) async {
                          final target = services[previousIndex];
                          final userId = _firestore.getCurrentUserId;

                          if (direction == CardSwiperDirection.right) {
                            _firestore.recordInteraction(
                              userId: userId,
                              targetId: target['id'],
                              type: 'service_like',
                            );

                            // WhatsApp Redirection
                            final userData = auth.userData;
                            final userName = userData?['fullNameEn'] ?? userData?['name'] ?? "User";
                            final userRole = (userData?['role'] ?? "Visitor").toString().toUpperCase();

                            final serviceName = target['name'] ?? "Care Service";
                            final targetWhatsapp = target['whatsapp']?.toString().replaceAll(RegExp(r'\D'), '');

                            if (targetWhatsapp != null && targetWhatsapp.isNotEmpty) {
                              final msg = "Hello, I am $userName, a $userRole. I am interested in your service: '$serviceName' (ID: ${target['id']}). I would like to learn more about the care protocol and availability. Can we connect?";
                              final url = "https://wa.me/$targetWhatsapp?text=${Uri.encodeComponent(msg)}";

                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                              }
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
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 30, offset: const Offset(0, 15))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image Layer
            if (service['imageUrl'] != null || service['photoUrl'] != null)
              CachedNetworkImage(
                imageUrl: service['imageUrl'] ?? service['photoUrl'],
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: Colors.white10, child: const Center(child: CircularProgressIndicator(color: EspyTheme.royalBlue))),
                errorWidget: (_, __, ___) => Container(color: Colors.white10, child: const Icon(Icons.medical_services, color: EspyTheme.royalBlue, size: 48)),
              )
            else
              Container(color: Colors.white10, child: const Icon(Icons.medical_services, size: 120, color: EspyTheme.royalBlue)),

            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: const [0.0, 0.4, 0.8],
                    colors: [
                      EspyTheme.navyDeep.withValues(alpha: 0.9),
                      EspyTheme.navyDeep.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Content Layer
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service['name']?.toString().toUpperCase() ?? 'SERVICE LISTING',
                                style: GoogleFonts.cinzel(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1, letterSpacing: 1),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.verified, color: EspyTheme.skyBlue, size: 16),
                                  const SizedBox(width: 6),
                                  Text(
                                    'VERIFIED PROTOCOL',
                                    style: GoogleFonts.cinzel(fontSize: 9, fontWeight: FontWeight.bold, color: EspyTheme.gold, letterSpacing: 1.5),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: EspyTheme.gold.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: EspyTheme.gold.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            '\$${service['price'] ?? '0'}',
                            style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        service['category']?.toString().toUpperCase() ?? 'CARE',
                        style: GoogleFonts.cinzel(fontSize: 9, fontWeight: FontWeight.w900, color: EspyTheme.gold, letterSpacing: 1),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      service['description'] ?? 'No description provided.',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lora(fontSize: 13, color: Colors.white.withValues(alpha: 0.7), height: 1.5),
                    ),
                  ],
                ),
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
        _buildCircleBtn(icon: Icons.close_rounded, color: EspyTheme.error, onTap: () => _controller.swipe(CardSwiperDirection.left)),
        const SizedBox(width: 24),
        _buildCircleBtn(icon: Icons.favorite_rounded, color: EspyTheme.royalBlue, onTap: () => _controller.swipe(CardSwiperDirection.right), isLarge: true),
        const SizedBox(width: 24),
        _buildCircleBtn(icon: Icons.info_outline_rounded, color: EspyTheme.gold, onTap: () {}),
      ],
    );
  }

  Widget _buildCircleBtn({required IconData icon, required Color color, required VoidCallback onTap, bool isLarge = false}) {
    double size = isLarge ? 72 : 56;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: color.withValues(alpha: 0.1), width: 2),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 8)),
          ],
        ),
        child: Icon(icon, color: color, size: isLarge ? 32 : 24),
      ),
    );
  }
}
