import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import 'package:shared_core/services/firestore_service.dart';
import '../../widgets/common/premium_card.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestore = FirestoreService();

    return Scaffold(
      backgroundColor: EspyTheme.platinum,
      appBar: AppBar(
        title: Text('NETWORK ANNOUNCEMENTS', style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, letterSpacing: 2, color: EspyTheme.cognac)),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: firestore.getAnnouncements(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: EspyTheme.gold));
          }

          final announcements = snapshot.data ?? [];

          if (announcements.isEmpty) {
            return Center(
              child: Text(
                'NO RECENT ANNOUNCEMENTS',
                style: GoogleFonts.cinzel(color: EspyTheme.cognac.withValues(alpha: 0.3), fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              final ann = announcements[index];
              return FadeInUp(
                delay: Duration(milliseconds: index * 100),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: PremiumCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: EspyTheme.gold.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                ann['category']?.toString().toUpperCase() ?? 'GENERAL',
                                style: GoogleFonts.cinzel(fontSize: 9, fontWeight: FontWeight.w900, color: EspyTheme.gold),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'OFFICIAL',
                              style: GoogleFonts.cinzel(fontSize: 8, fontWeight: FontWeight.bold, color: EspyTheme.teal),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          ann['title'] ?? 'Network Update',
                          style: GoogleFonts.cinzel(fontSize: 18, fontWeight: FontWeight.w900, color: EspyTheme.cognac),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          ann['content'] ?? ann['message'] ?? '',
                          style: GoogleFonts.lora(fontSize: 14, color: EspyTheme.cognac.withValues(alpha: 0.7), height: 1.6),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded, size: 12, color: EspyTheme.gold),
                            const SizedBox(width: 8),
                            Text(
                              'PUBLISHED BYCare Node',
                              style: GoogleFonts.lora(fontSize: 11, fontWeight: FontWeight.bold, color: EspyTheme.cognac.withValues(alpha: 0.5)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
