import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import 'package:shared_core/models/professional_model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/firestore_service.dart';

class AdminDocModal extends ConsumerWidget {
  final ProfessionalModel user;
  const AdminDocModal({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 100, vertical: 40),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF061226),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: EspyTheme.gold.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 40)
          ],
        ),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _buildContent(),
            ),
            _buildFooter(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Icon(LucideIcons.fileSearch, color: EspyTheme.gold),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('IDENTITY REVIEW', style: EspyTheme.cinzelStyle.copyWith(fontSize: 14, color: Colors.white)),
                Text('Verifying credentials for ${user.fullNameEn}', style: EspyTheme.loraStyle.copyWith(fontSize: 11, color: Colors.white38)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(LucideIcons.x, color: Colors.white24),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (user.proofUrl == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.fileX, size: 64, color: Colors.white12),
            const SizedBox(height: 16),
            Text('NO DOCUMENT UPLOADED', style: EspyTheme.cinzelStyle.copyWith(fontSize: 10, color: Colors.white38)),
          ],
        ),
      );
    }

    final isPdf = user.proofUrl!.toLowerCase().contains('.pdf');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: isPdf 
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.fileText, size: 64, color: EspyTheme.electricBlue),
                  const SizedBox(height: 16),
                  const Text('PDF DOCUMENT DETECTED', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => _launchUrl(user.proofUrl!),
                    child: const Text('OPEN IN NEW TAB'),
                  ),
                ],
              ),
            )
          : Image.network(
              user.proofUrl!,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Center(child: Text('Image Load Failed')),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
            ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Widget _buildFooter(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CLOSE', style: EspyTheme.cinzelStyle.copyWith(fontSize: 10, color: Colors.white38)),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(firestoreServiceProvider).approveProfessional(user.id, true, user.role);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green.withOpacity(0.3), foregroundColor: Colors.green),
            child: const Text('APPROVE NODE'),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              ref.read(firestoreServiceProvider).approveProfessional(user.id, false, user.role);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.withOpacity(0.3), foregroundColor: Colors.redAccent),
            child: const Text('REJECT'),
          ),
        ],
      ),
    );
  }
}
