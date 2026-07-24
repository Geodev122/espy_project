import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:espy_core/espy_core.dart';
import '../../theme/espy_theme.dart';
import '../common/espy_icon.dart';
import '../common/premium_card.dart';

class AdaptiveSlotCard extends StatelessWidget {
  final dynamic service; // ServiceModel or ServiceRequestModel
  final bool isRequest;
  
  const AdaptiveSlotCard({super.key, required this.service, this.isRequest = false});

  @override
  Widget build(BuildContext context) {
    // Resolve template and data
    final Map<String, dynamic> data = service is ServiceModel ? (service as ServiceModel).toMap() : (service as ServiceRequestModel).toMap();
    
    // Note: Template management is currently handled via dynamic maps in schema join
    final Map<String, dynamic>? template = data['template'] as Map<String, dynamic>?;

    final Color accentColor = Color(int.tryParse(template?['accentColor'] ?? (isRequest ? '0xFFF9A825' : '0xFF1565C0')) ?? 0xFF1565C0);
    final String iconName = template?['iconName'] ?? (isRequest ? 'campaign' : 'medical_services');
    final List visibleFields = template?['visibleFields'] ?? (isRequest ? ['Title', 'Description', 'Location'] : ['Title', 'Price', 'Location']);

    return PremiumCard(
      padding: EdgeInsets.zero,
      accentColor: accentColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background identity
          if (!isRequest && visibleFields.contains('Image') && data['imageUrl'] != null)
            CachedNetworkImage(imageUrl: data['imageUrl'], fit: BoxFit.cover)
          else
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [accentColor.withValues(alpha: 0.2), accentColor.withValues(alpha: 0.05)],
                ),
              ),
              child: Center(child: EspyIcon(iconName: iconName, size: 80, color: accentColor.withValues(alpha: 0.08))),
            ),

          // Cinematic Overlay
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

          // Content Layer
          Positioned(
            bottom: 32, left: 32, right: 32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (visibleFields.contains('Title'))
                  Text(
                    (data['titleEn'] ?? data['descriptionEn'] ?? 'CARE PROTOCOL').toString().toUpperCase(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.cinzel(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1),
                  ),
                
                if (visibleFields.contains('Description') && data['descriptionEn'] != null) ...[
                   const SizedBox(height: 12),
                   Text(
                     data['descriptionEn'],
                     maxLines: 3,
                     overflow: TextOverflow.ellipsis,
                     style: GoogleFonts.lora(fontSize: 13, color: Colors.white70, fontStyle: FontStyle.italic),
                   ),
                ],

                const SizedBox(height: 20),
                Row(
                  children: [
                    if (!isRequest && visibleFields.contains('Price'))
                      _infoBadge("\$${data['price']}", accentColor),
                    if (isRequest && visibleFields.contains('Urgency'))
                      _infoBadge(data['urgency'] ?? "NORMAL", data['urgency'] == 'EMERGENCY' ? EspyTheme.error : EspyTheme.gold),
                    if (visibleFields.contains('Location')) ...[
                      const SizedBox(width: 12),
                      _infoBadge(data['cityNameEn'] ?? "LEBANON", Colors.white24),
                    ],
                  ],
                ),
                
                if (visibleFields.contains('Provider Profile')) ...[
                   const SizedBox(height: 24),
                   Row(
                     children: [
                       CircleAvatar(
                         radius: 12, 
                         backgroundColor: Colors.white12,
                         backgroundImage: data['providerPhoto'] != null ? NetworkImage(data['providerPhoto']) : null,
                         child: data['providerPhoto'] == null ? const Icon(Icons.person, size: 14, color: Colors.white38) : null,
                       ),
                       const SizedBox(width: 12),
                       Text(data['providerName'] ?? data['userName'] ?? 'IDENTIFIED USER', style: GoogleFonts.montserrat(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.bold, letterSpacing: 1)),
                     ],
                   ),
                ],
              ],
            ),
          ),
          
          // Sector Badge
          Positioned(
            top: 32, right: 32,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: accentColor.withValues(alpha: 0.2)),
              ),
              child: Text(
                (data['sectorName'] ?? 'CARE').toString().toUpperCase(),
                style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.w900, color: accentColor, letterSpacing: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(10)),
      child: Text(text.toUpperCase(), style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.white)),
    );
  }
}
