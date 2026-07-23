import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/viewmodels/firestore_service.dart';
import 'package:espy_app/widgets/common/premium_card.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';
import 'package:espy_app/l10n/app_localizations.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestore = FirestoreService();
    final l10n = AppLocalizations.of(context)!;

    return EspyScaffold(
      useCinematicBackground: true,
      appBar: AppBar(
        title: Text(l10n.networkAnnouncements.toUpperCase(), style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
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
                l10n.noNewProtocols.toUpperCase(),
                style: GoogleFonts.cinzel(color: Colors.white24, fontWeight: FontWeight.bold),
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
                          style: GoogleFonts.cinzel(fontSize: 18, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          ann['content'] ?? ann['message'] ?? '',
                          style: GoogleFonts.lora(fontSize: 14, color: EspyTheme.navyDeep.withValues(alpha: 0.7), height: 1.6),
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
