import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:espy_core/espy_core.dart';
import '../../../theme/espy_theme.dart';
import '../../../widgets/common/premium_card.dart';
import '../../../widgets/common/espy_scaffold.dart';

class SupportInboxScreen extends StatelessWidget {
  const SupportInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = Provider.of<FirestoreService>(context);

    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(
        title: Text("SUPPORT INBOX", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
        backgroundColor: Colors.white,
        foregroundColor: EspyTheme.navyDeep,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: firestore.listCollection('directory_support_inbox'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          
          final messages = snapshot.data ?? [];
          
          if (messages.isEmpty) return const Center(child: Text("NO MESSAGES"));

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final m = messages[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PremiumCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m['userEmail'] ?? 'Unknown User', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 8),
                      Text(m['message'] ?? '', style: GoogleFonts.lora(fontSize: 13)),
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
