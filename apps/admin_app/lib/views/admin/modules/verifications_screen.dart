import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../theme/espy_theme.dart';
import '../../../viewmodels/firestore_service.dart';
import '../../../viewmodels/espy_repository.dart';
import '../../../widgets/common/premium_card.dart';
import '../../../widgets/common/espy_scaffold.dart';

class VerificationsScreen extends StatelessWidget {
  const VerificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<EspyRepository>(context);

    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(
        title: Text("PROTOCOL VALIDATIONS", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
        backgroundColor: Colors.white,
        foregroundColor: EspyTheme.navyDeep,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: repo.listAllProviders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          
          final pending = snapshot.data?.where((p) => p['isProfileValidated'] == false || p['isApproved'] == false).toList() ?? [];
          
          if (pending.isEmpty) return const Center(child: Text("NO PENDING VALIDATIONS"));

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: pending.length,
            itemBuilder: (context, index) {
              final p = pending[index];
              final bool needsValidation = p['isProfileValidated'] == false;
              final bool needsApproval = p['isApproved'] == false;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PremiumCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: p['photoUrl'] != null ? NetworkImage(p['photoUrl']) : null,
                          backgroundColor: EspyTheme.platinum,
                          child: p['photoUrl'] == null ? const Icon(Icons.person) : null,
                        ),
                        title: Text(p['name'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${p['role']?.toString().toUpperCase()} • ${p['specialty'] ?? 'No Specialty'}"),
                        trailing: Icon(
                          needsValidation ? LucideIcons.shieldAlert : LucideIcons.checkCircle,
                          color: needsValidation ? EspyTheme.gold : EspyTheme.success,
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (needsValidation)
                              _actionBtn(
                                label: "VALIDATE PROFILE",
                                color: EspyTheme.gold,
                                onTap: () => repo.approveProfessional(p['id'], true, p['role']), // Simplified for now
                              ),
                            if (needsApproval)
                              _actionBtn(
                                label: "APPROVE SEARCH",
                                color: EspyTheme.success,
                                onTap: () => repo.approveProfessional(p['id'], true, p['role']),
                              ),
                          ],
                        ),
                      )
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

  Widget _actionBtn({required String label, required Color color, required VoidCallback onTap}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
    );
  }
}
