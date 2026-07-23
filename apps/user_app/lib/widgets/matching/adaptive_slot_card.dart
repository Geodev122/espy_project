import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/espy_theme.dart';
import '../common/espy_icon.dart';
import '../common/premium_card.dart';

class AdaptiveSlotCard extends StatelessWidget {
  final Map<String, dynamic> service;
  
  const AdaptiveSlotCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final t = service['template'] as Map<String, dynamic>?;
    final Color accentColor = Color(int.tryParse(t?['accentColor'] ?? '0xFF1565C0') ?? 0xFF1565C0);
    final String iconName = t?['iconName'] ?? 'medical_services';
    final List visibleFields = t?['visibleFields'] ?? ['Title', 'Price', 'Location'];

    return PremiumCard(
      padding: EdgeInsets.zero,
      accentColor: accentColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image (Conditional)
          if (visibleFields.contains('Image') && service['imageUrl'] != null)
            CachedNetworkImage(imageUrl: service['imageUrl'], fit: BoxFit.cover)
          else
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [accentColor.withValues(alpha: 0.2), accentColor.withValues(alpha: 0.05)],
                ),
              ),
              child: Center(child: EspyIcon(iconName: iconName, size: 60, color: accentColor.withValues(alpha: 0.1))),
            ),

          // Content Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: const [0.0, 0.6],
                  colors: [EspyTheme.navyDeep.withValues(alpha: 0.95), Colors.transparent],
                ),
              ),
            ),
          ),

          // Data Fields
          Positioned(
            bottom: 32, left: 32, right: 32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (visibleFields.contains('Title'))
                  Text(
                    service['titleEn']?.toString().toUpperCase() ?? 'SERVICE',
                    style: GoogleFonts.cinzel(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (visibleFields.contains('Price'))
                      _infoBadge("\$${service['price']}", accentColor),
                    if (visibleFields.contains('Location')) ...[
                      const SizedBox(width: 12),
                      _infoBadge(service['cityNameEn'] ?? "LEBANON", Colors.white24),
                    ],
                  ],
                ),
                if (visibleFields.contains('Provider Profile')) ...[
                   const SizedBox(height: 20),
                   Row(
                     children: [
                       CircleAvatar(radius: 10, backgroundImage: service['providerPhoto'] != null ? NetworkImage(service['providerPhoto']) : null),
                       const SizedBox(width: 8),
                       Text(service['providerName'] ?? '', style: GoogleFonts.montserrat(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.bold)),
                     ],
                   ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(12)),
      child: Text(text.toUpperCase(), style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white)),
    );
  }
}
