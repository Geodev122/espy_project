import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme.dart';
import 'package:shared_core/services/firestore_service.dart';
import 'package:shared_core/services/auth_service.dart';
import '../../widgets/common/premium_button.dart';
import '../../widgets/common/premium_card.dart';

class BroadcastScreen extends StatefulWidget {
  const BroadcastScreen({super.key});

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _firestore = FirestoreService();
  bool _isSending = false;
  String _targetCountry = 'LEBANON';

  final List<String> _countries = ['GLOBAL', 'LEBANON', 'SYRIA', 'JORDAN', 'CYPRUS', 'UAE'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = Provider.of<AuthService>(context);
    final userData = auth.userData;
    final int bought = userData?['broadcastsBought'] ?? 0;
    final int used = userData?['broadcastsUsed'] ?? 0;
    final int available = bought - used;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(l10n.nodeBroadcasts.toUpperCase()),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(gradient: EspyTheme.lightBlueFlame),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQuotaHeader(bought, used, available),
              const SizedBox(height: 32),
              FadeInDown(
                child: Text(
                  l10n.dispatchAnnouncement.toUpperCase(),
                  style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 4, color: EspyTheme.royalBlue),
                ),
              ),
              const SizedBox(height: 12),
              FadeInDown(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  l10n.broadcastDesc,
                  style: GoogleFonts.lora(fontSize: 14, color: EspyTheme.navyDeep.withOpacity(0.6), height: 1.6),
                ),
              ),
              const SizedBox(height: 40),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: PremiumCard(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.targetAudience.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.gold, letterSpacing: 2)),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: _targetCountry,
                        dropdownColor: EspyTheme.platinum,
                        style: GoogleFonts.cinzel(color: EspyTheme.navyDeep, fontWeight: FontWeight.w900, fontSize: 12),
                        items: _countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (val) => setState(() => _targetCountry = val!),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: EspyTheme.navyDeep.withOpacity(0.03),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _titleController,
                        style: const TextStyle(color: EspyTheme.navyDeep),
                        decoration: InputDecoration(
                          labelText: l10n.broadcastTitle.toUpperCase(),
                          labelStyle: GoogleFonts.cinzel(color: EspyTheme.royalBlue, fontSize: 10, fontWeight: FontWeight.bold),
                          hintText: 'e.g. Free Health Clinic Opening',
                          hintStyle: TextStyle(color: EspyTheme.navyDeep.withOpacity(0.2))
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _messageController,
                        maxLines: 5,
                        style: const TextStyle(color: EspyTheme.navyDeep),
                        decoration: InputDecoration(
                          labelText: l10n.messageContent.toUpperCase(),
                          labelStyle: GoogleFonts.cinzel(color: EspyTheme.royalBlue, fontSize: 10, fontWeight: FontWeight.bold),
                          hintText: 'Detailed announcement for the community...',
                          hintStyle: TextStyle(color: EspyTheme.navyDeep.withOpacity(0.2))
                        ),
                      ),
                      const SizedBox(height: 48),
                      PremiumButton(
                        label: _isSending ? l10n.dispatching.toUpperCase() : l10n.dispatchBroadcast.toUpperCase(),
                        fullWidth: true,
                        onPressed: (_isSending || available <= 0) ? null : _handleDispatch,
                      ),
                      if (available <= 0)
                         Padding(
                           padding: const EdgeInsets.only(top: 16),
                           child: Center(child: Text('INSUFFICIENT BROADCAST CREDITS', style: GoogleFonts.cinzel(fontSize: 10, color: EspyTheme.error, fontWeight: FontWeight.bold))),
                         ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuotaHeader(int bought, int used, int available) {
    return PremiumCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          _buildStat('BOUGHT', bought.toString(), EspyTheme.gold),
          _buildDivider(),
          _buildStat('USED', used.toString(), EspyTheme.navyDeep),
          _buildDivider(),
          _buildStat('AVAILABLE', available.toString(), EspyTheme.success),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: GoogleFonts.cinzel(fontSize: 20, fontWeight: FontWeight.w900, color: color)),
          Text(label, style: GoogleFonts.cinzel(fontSize: 8, color: EspyTheme.navyDeep.withOpacity(0.4), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 30, color: Colors.black12);
  }

  Future<void> _handleDispatch() async {
    final l10n = AppLocalizations.of(context)!;
    if (_titleController.text.isEmpty || _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.pleaseFillAllFields)));
      return;
    }

    setState(() => _isSending = true);
    try {
      final uid = _firestore.getCurrentUserId;
      
      // Atomic transaction to use a broadcast credit
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final userDoc = await transaction.get(FirebaseFirestore.instance.collection('users').doc(uid));
        final data = userDoc.data() as Map<String, dynamic>;
        final used = data['broadcastsUsed'] ?? 0;
        transaction.update(userDoc.reference, {'broadcastsUsed': used + 1});
      });

      await _firestore.createBroadcast({
        'title': _titleController.text,
        'message': _messageController.text,
        'targetCountry': _targetCountry,
        'senderId': uid,
        'uid': uid,
        'status': 'queued',
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.broadcastQueued)));
      _titleController.clear();
      _messageController.clear();
      // Refresh user data to update quota
      await Provider.of<AuthService>(context, listen: false).fetchUserData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dispatch Error: $e')));
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }
}
