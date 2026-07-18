import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:espy_app/l10n/app_localizations.dart';

import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/viewmodels/firestore_service.dart';
import 'package:espy_app/viewmodels/auth_service.dart';
import 'package:espy_app/widgets/common/premium_button.dart';
import 'package:espy_app/widgets/common/premium_card.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';

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
  String _targetCountry = 'GLOBAL';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = Provider.of<AuthService>(context);
    final user = auth.userData;
    
    final int bought = user?['broadcastsBought'] ?? 0;
    final int used = user?['broadcastsUsed'] ?? 0;
    final int available = bought - used;

    return EspyScaffold(
      useCinematicBackground: true,
      appBar: AppBar(
        title: Text(l10n.nodeBroadcasts.toUpperCase()),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuotaHeader(bought, used, available, l10n),
            const SizedBox(height: 32),
            FadeInDown(
              child: Text(
                l10n.dispatchAnnouncement.toUpperCase(),
                style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 2, color: EspyTheme.gold),
              ),
            ),
            const SizedBox(height: 12),
            FadeInDown(
              delay: const Duration(milliseconds: 200),
              child: Text(
                l10n.broadcastDesc,
                style: GoogleFonts.montserrat(fontSize: 13, color: Colors.white70, height: 1.5, fontWeight: FontWeight.w500),
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
                    Text(l10n.targetAudience.toUpperCase(), style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.gold, letterSpacing: 1)),
                    const SizedBox(height: 12),
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _firestore.getCountries(),
                      builder: (context, snapshot) {
                        final countries = snapshot.data ?? [];
                        return DropdownButtonFormField<String>(
                          value: _targetCountry,
                          dropdownColor: EspyTheme.navyDeep,
                          style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12),
                          items: [
                            const DropdownMenuItem(value: 'GLOBAL', child: Text('GLOBAL')),
                            ...countries.map((c) => DropdownMenuItem(value: c['id'].toString(), child: Text(c['name_en'].toString().toUpperCase()))),
                          ],
                          onChanged: (val) => setState(() => _targetCountry = val!),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.black.withOpacity(0.1),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)
                          ),
                        );
                      }
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _titleController,
                      style: const TextStyle(color: EspyTheme.navyDeep),
                      decoration: InputDecoration(
                        labelText: l10n.broadcastTitle.toUpperCase(),
                        labelStyle: GoogleFonts.montserrat(color: EspyTheme.royalBlue, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _messageController,
                      maxLines: 5,
                      style: const TextStyle(color: EspyTheme.navyDeep),
                      decoration: InputDecoration(
                        labelText: l10n.messageContent.toUpperCase(),
                        labelStyle: GoogleFonts.montserrat(color: EspyTheme.royalBlue, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 48),
                    PremiumButton(
                      label: _isSending ? l10n.dispatching.toUpperCase() : l10n.dispatchBroadcast.toUpperCase(),
                      fullWidth: true,
                      onPressed: (_isSending || available <= 0) ? null : _handleDispatch,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuotaHeader(int bought, int used, int available, AppLocalizations l10n) {
    return PremiumCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          _buildStat(l10n.used.toUpperCase(), bought.toString(), EspyTheme.gold),
          _buildDivider(),
          _buildStat(l10n.used.toUpperCase(), used.toString(), Colors.white54),
          _buildDivider(),
          _buildStat(l10n.available.toUpperCase(), available.toString(), EspyTheme.success),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w900, color: color)),
          Text(label, style: GoogleFonts.montserrat(fontSize: 8, color: Colors.white38, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 30, color: Colors.white10);
  }

  Future<void> _handleDispatch() async {
     // ... logic
  }
}
