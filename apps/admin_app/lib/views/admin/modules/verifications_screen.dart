import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../theme/espy_theme.dart';
import '../../../viewmodels/firestore_service.dart';
import '../../../widgets/common/premium_card.dart';
import '../../../widgets/common/espy_scaffold.dart';

class VerificationsScreen extends StatelessWidget {
  const VerificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = Provider.of<FirestoreService>(context);

    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(
        title: Text("PENDING VERIFICATIONS", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
        backgroundColor: Colors.white,
        foregroundColor: EspyTheme.navyDeep,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: firestore.getAllProviders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          
          final pending = snapshot.data?.where((p) => p['isApproved'] == false).toList() ?? [];
          
          if (pending.isEmpty) return const Center(child: Text("NO PENDING VERIFICATIONS"));

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: pending.length,
            itemBuilder: (context, index) {
              final p = pending[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PremiumCard(
                  padding: const EdgeInsets.all(16),
                  child: ListTile(
                    title: Text(p['name'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(p['role']?.toString().toUpperCase() ?? 'PROFESSIONAL'),
                    trailing: ElevatedButton(
                      onPressed: () => firestore.approveProfessional(p['id'], true, p['role']),
                      style: ElevatedButton.styleFrom(backgroundColor: EspyTheme.success, foregroundColor: Colors.white),
                      child: const Text("APPROVE"),
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
