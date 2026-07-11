import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:espy_app/l10n/app_localizations.dart';
import 'package:shared_core/theme/espy_theme.dart';
import 'package:shared_core/services/firestore_service.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/widgets/common/premium_button.dart';
import 'package:shared_core/widgets/common/premium_card.dart';
import 'package:shared_core/widgets/common/espy_scaffold.dart';

class PrivacyVaultScreen extends StatefulWidget {
  const PrivacyVaultScreen({super.key});

  @override
  State<PrivacyVaultScreen> createState() => _PrivacyVaultScreenState();
}

class _PrivacyVaultScreenState extends State<PrivacyVaultScreen> {
  final _messageController = TextEditingController();
  final _firestore = FirestoreService();
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EspyScaffold(
      useCinematicBackground: true,
      appBar: AppBar(
        title: Text(l10n.privacyVaultTitle.toUpperCase()),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.dataPrivacyProtocol.toUpperCase(),
                style: GoogleFonts.cinzel(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: EspyTheme.gold)),
            const SizedBox(height: 16),
            Text(
              l10n.privacyPolicyDesc,
              style: GoogleFonts.lora(
                  fontSize: 13,
                  height: 1.6,
                  color: Colors.white70),
            ),
            const SizedBox(height: 48),
            Text(l10n.contactAdmin.toUpperCase(),
                style: GoogleFonts.cinzel(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: EspyTheme.gold,
                    letterSpacing: 2)),
            const SizedBox(height: 12),
            PremiumCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  TextField(
                    controller: _messageController,
                    maxLines: 4,
                    style: const TextStyle(color: EspyTheme.navyDeep),
                    decoration: InputDecoration(
                      hintText: l10n.privacyConcernHint,
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 24),
                  PremiumButton(
                    label: _isSending
                        ? l10n.sending.toUpperCase()
                        : l10n.sendMessage.toUpperCase(),
                    fullWidth: true,
                    onPressed: _isSending ? null : _handleSend,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSend() async {
    final l10n = AppLocalizations.of(context)!;
    if (_messageController.text.isEmpty) return;
    
    setState(() => _isSending = true);
    final auth = Provider.of<AuthService>(context, listen: false);
    
    try {
      await _firestore.submitSupportMessage({
        'userId': auth.user!.uid,
        'userEmail': auth.user!.email,
        'message': _messageController.text,
        'type': 'privacy_vault',
      });
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.messageDispatched)));
      _messageController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isSending = false);
    }
  }
}
