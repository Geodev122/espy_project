import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../theme/espy_theme.dart';
import '../../../viewmodels/espy_repository.dart';
import '../../../viewmodels/verifications_view_model.dart';
import '../../../widgets/common/premium_card.dart';
import '../../../widgets/common/espy_scaffold.dart';

class VerificationsScreen extends StatelessWidget {
  const VerificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VerificationsViewModel(context.read<EspyRepository>()),
      child: const _VerificationsView(),
    );
  }
}

class _VerificationsView extends StatelessWidget {
  const _VerificationsView();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<VerificationsViewModel>(context);

    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(
        title: Text("PROTOCOL VALIDATIONS", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
        backgroundColor: Colors.white,
        foregroundColor: EspyTheme.navyDeep,
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.pendingProviders.isEmpty
              ? const Center(child: Text("NO PENDING VALIDATIONS"))
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: viewModel.pendingProviders.length,
                  itemBuilder: (context, index) {
                    final p = viewModel.pendingProviders[index];
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
                                      onTap: () => viewModel.validateProfile(p['id'], p['role']),
                                    ),
                                  if (needsApproval)
                                    _actionBtn(
                                      label: "APPROVE SEARCH",
                                      color: EspyTheme.success,
                                      onTap: () => viewModel.approveSearch(p['id'], p['role']),
                                    ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
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
