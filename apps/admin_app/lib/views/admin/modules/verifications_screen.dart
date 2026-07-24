import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:espy_core/espy_core.dart';
import '../../../theme/espy_theme.dart';
import '../../../viewmodels/verifications_view_model.dart';
import '../../../widgets/common/premium_card.dart';
import '../../../widgets/common/espy_scaffold.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
                      padding: const EdgeInsets.only(bottom: 24),
                      child: PremiumCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: p['photoUrl'] != null ? CachedNetworkImageProvider(p['photoUrl']) : null,
                                  backgroundColor: EspyTheme.platinum,
                                  child: p['photoUrl'] == null ? const Icon(Icons.person, size: 30) : null,
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(p['name'] ?? 'Unknown', style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 16)),
                                      Text("${p['role']?.toString().toUpperCase()} • ${p['specialty'] ?? 'No Specialty'}", style: GoogleFonts.lora(fontSize: 12, color: Colors.black45)),
                                      const SizedBox(height: 8),
                                      if (p['verificationDocUrl'] != null)
                                        TextButton.icon(
                                          onPressed: () => _showDocumentViewer(context, p['verificationDocUrl']),
                                          icon: const Icon(Icons.description_outlined, size: 16),
                                          label: const Text("VIEW VERIFICATION DOCS", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                        ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(color: needsValidation ? Colors.orange.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                                  child: Text(needsValidation ? "PENDING VALIDATION" : "VALIDATED", style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: needsValidation ? Colors.orange : Colors.green)),
                                ),
                              ],
                            ),
                            const Divider(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => _showRejectionDialog(context, p, viewModel),
                                  child: const Text("REJECT", style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.w900)),
                                ),
                                const SizedBox(width: 16),
                                if (needsValidation)
                                  _actionBtn(
                                    label: "VALIDATE PROFILE",
                                    color: EspyTheme.gold,
                                    onTap: () => viewModel.validateProfile(p['id'], p['role']),
                                  ),
                                if (needsApproval) ...[
                                  const SizedBox(width: 12),
                                  _actionBtn(
                                    label: "APPROVE SEARCH",
                                    color: EspyTheme.success,
                                    onTap: () => viewModel.approveSearch(p['id'], p['role']),
                                  ),
                                ],
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _showDocumentViewer(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 800, height: 600,
          decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              AppBar(
                title: const Text("VERIFICATION DOCUMENT", style: TextStyle(color: Colors.white, fontSize: 12)),
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
                actions: [
                   IconButton(icon: const Icon(Icons.download, color: Colors.white), onPressed: () {}),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: CachedNetworkImage(
                    imageUrl: url,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Center(child: Text("COULD NOT LOAD IMAGE", style: TextStyle(color: Colors.white24))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRejectionDialog(BuildContext context, Map<String, dynamic> p, VerificationsViewModel vm) {
    final reason = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("REJECT ${p['name']?.toUpperCase()}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Provide a reason for rejection. This will be sent to the user.", style: TextStyle(fontSize: 12)),
            const SizedBox(height: 16),
            TextField(controller: reason, maxLines: 3, decoration: const InputDecoration(hintText: "e.g. License expired, blurry document...")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
            onPressed: () {
               // Logic to notify user and mark as rejected
               Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("CONFIRM REJECTION"),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn({required String label, required Color color, required VoidCallback onTap}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
    );
  }
}
