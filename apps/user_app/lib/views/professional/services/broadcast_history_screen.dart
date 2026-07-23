import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/viewmodels/auth_service.dart';
import 'package:espy_app/widgets/common/premium_card.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';
import 'package:espy_app/l10n/app_localizations.dart';

class BroadcastHistoryScreen extends StatelessWidget {
  const BroadcastHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final uid = auth.user?.uid;
    final l10n = AppLocalizations.of(context)!;

    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(
        title: Text(l10n.broadcastHistory.toUpperCase(), style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
      ),
      body: uid == null
          ? Center(child: Text(l10n.signInViewNotifications))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('directory_broadcasts')
                  .where('senderId', isEqualTo: uid)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: EspyTheme.gold));
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.history_rounded, size: 64, color: Colors.white10),
                        const SizedBox(height: 16),
                        Text(l10n.noBroadcastsSent.toUpperCase(), style: GoogleFonts.cinzel(color: Colors.white24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final date = (data['createdAt'] as Timestamp?)?.toDate();

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: PremiumCard(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  date != null ? DateFormat('dd MMM yyyy • HH:mm').format(date) : 'N/A',
                                  style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.bold, color: EspyTheme.gold),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: EspyTheme.royalBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    "${data['targetAudience'] ?? 'ALL'}",
                                    style: GoogleFonts.cinzel(fontSize: 8, fontWeight: FontWeight.w900, color: EspyTheme.royalBlue),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(data['message'] ?? '', style: GoogleFonts.lora(fontSize: 14, color: EspyTheme.navyDeep)),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Icon(Icons.people_outline_rounded, size: 14, color: Colors.black38),
                                const SizedBox(width: 8),
                                Text(
                                  "${data['reachCount'] ?? 0} USERS REACHED",
                                  style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black38),
                                ),
                              ],
                            ),
                          ],
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
