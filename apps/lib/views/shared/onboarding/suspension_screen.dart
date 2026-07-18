import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_core/theme/espy_theme.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/services/firestore_service.dart';
import 'package:espy_app/l10n/app_localizations.dart';

class SuspensionScreen extends StatefulWidget {
  const SuspensionScreen({super.key});

  @override
  State<SuspensionScreen> createState() => _SuspensionScreenState();
}

class _SuspensionScreenState extends State<SuspensionScreen> {
  final _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    setState(() => _isSending = true);
    final auth = Provider.of<AuthService>(context, listen: false);
    final firestore = FirestoreService();
    try {
      await firestore.submitSupportMessage({
        'userId': auth.user?.uid,
        'email': auth.user?.email,
        'message': _messageController.text.trim(),
        'type': 'suspension_inquiry',
      });
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        _messageController.clear();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.messageDispatched)));
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return EspyScaffold(
      useCinematicBackground: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              const Icon(Icons.shield_rounded, size: 80, color: EspyTheme.error),
              const SizedBox(height: 32),
              Text(l10n.accountSuspended.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
              const SizedBox(height: 16),
              Text(l10n.accessRestricted, textAlign: TextAlign.center, style: GoogleFonts.lora(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 48),
              TextField(
                controller: _messageController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(hintText: l10n.privacyConcernHint, hintStyle: const TextStyle(color: Colors.white38)),
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _isSending ? null : _sendMessage, child: Text(l10n.dispatch.toUpperCase())),
              const SizedBox(height: 32),
              TextButton(onPressed: () => Provider.of<AuthService>(context, listen: false).signOut(), child: Text(l10n.signOutProtocol.toUpperCase(), style: const TextStyle(color: Colors.white38))),
            ],
          ),
        ),
      ),
    );
  }
}
