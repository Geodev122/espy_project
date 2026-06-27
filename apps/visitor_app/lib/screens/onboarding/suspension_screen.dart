import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/services/firestore_service.dart';

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
        _messageController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Protocol request dispatched. Support will respond shortly.'))
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to dispatch: $e'))
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EspyTheme.navy,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shield_rounded, size: 80, color: EspyTheme.error),
                const SizedBox(height: 32),
                Text(
                  'ACCOUNT SUSPENDED',
                  style: GoogleFonts.cinzel(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your access to the Espy network has been restricted by the administrative board. If you believe this is an error, please contact support.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lora(color: Colors.white70, fontSize: 14, height: 1.6),
                ),
                const SizedBox(height: 48),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'CONTACT COMMAND CENTER',
                        style: GoogleFonts.cinzel(fontSize: 12, fontWeight: FontWeight.bold, color: EspyTheme.gold, letterSpacing: 2),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _messageController,
                        maxLines: 3,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Describe your inquiry...',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                          fillColor: Colors.black.withOpacity(0.2),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSending ? null : _sendMessage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: EspyTheme.gold,
                            foregroundColor: EspyTheme.navyDeep,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _isSending 
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: EspyTheme.navyDeep))
                            : const Text('DISPATCH MESSAGE'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                TextButton(
                  onPressed: () => Provider.of<AuthService>(context, listen: false).signOut(),
                  child: Text('TERMINATE SESSION', style: GoogleFonts.cinzel(color: Colors.white38, fontSize: 10, letterSpacing: 2)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
