import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/viewmodels/user_service.dart';
import 'package:espy_app/widgets/common/location_picker_modal.dart';
import 'package:espy_app/widgets/common/premium_button.dart';
import 'package:espy_app/widgets/common/premium_card.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';
import 'package:espy_app/l10n/app_localizations.dart';

class LocationManagerScreen extends StatefulWidget {
  const LocationManagerScreen({super.key});

  @override
  State<LocationManagerScreen> createState() => _LocationManagerScreenState();
}

class _LocationManagerScreenState extends State<LocationManagerScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _mainLocation;
  List<Map<String, dynamic>> _secondaryLocations = [];

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<UserService>(context, listen: false).profile ?? {};
    _mainLocation = profile['mainLocation'];
    final secondary = profile['secondaryLocations'] as List?;
    if (secondary != null) _secondaryLocations = List<Map<String, dynamic>>.from(secondary);
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final profile = userService.profile ?? {};
    final int practicePins = profile['practicePins'] ?? 0;
    final int currentSecondaryCount = _secondaryLocations.length;
    final bool canAddMore = currentSecondaryCount < practicePins;

    final l10n = AppLocalizations.of(context)!;

    return EspyScaffold(
      useCinematicBackground: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(l10n.locationSettings.toUpperCase(), style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.white, fontSize: 13)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(l10n.mainHub.toUpperCase()),
            PremiumCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: EspyTheme.gold),
                  const SizedBox(width: 12),
                  Expanded(child: Text(_mainLocation?['cityName'] ?? l10n.noPinDropped, style: GoogleFonts.lora(fontSize: 14))),
                  TextButton(onPressed: _openMainLocationPicker, child: Text(l10n.update.toUpperCase(), style: const TextStyle(color: EspyTheme.gold))),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _buildSectionHeader('${l10n.secondaryPresenceNodes.toUpperCase()} ($currentSecondaryCount / $practicePins)'),
            ..._secondaryLocations.map((loc) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: PremiumCard(
                padding: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(loc['cityName'] ?? 'Unknown', style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 13)),
                  trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: () => setState(() => _secondaryLocations.remove(loc))),
                ),
              ),
            )),
            const SizedBox(height: 32),
            PremiumButton(
              label: 'ADD SECONDARY PIN',
              variant: PremiumButtonVariant.outline,
              fullWidth: true,
              onPressed: canAddMore ? _openSecondaryLocationPicker : () => _showLimitReachedPrompt(l10n),
            ),
            const SizedBox(height: 48),
            PremiumButton(label: 'SYNCHRONIZE LOCATIONS', isLoading: _isLoading, fullWidth: true, onPressed: _saveLocations),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(padding: const EdgeInsets.only(bottom: 16), child: Text(title, style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.gold, letterSpacing: 2)));
  }

  void _showLimitReachedPrompt(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: EspyTheme.navyDeep,
        title: Text(l10n.limitReached.toUpperCase(), style: const TextStyle(color: Colors.white)),
        content: Text(l10n.visitWalletPurchasePins, style: const TextStyle(color: Colors.white70)),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.ok.toUpperCase()))],
      ),
    );
  }

  Future<void> _openMainLocationPicker() async {
    final result = await showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (_) => const LocationPickerModal(title: 'UPDATE MAIN PIN'));
    if (result != null) setState(() => _mainLocation = result);
  }

  Future<void> _openSecondaryLocationPicker() async {
    final result = await showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (_) => const LocationPickerModal(title: 'ADD PIN'));
    if (result != null) setState(() => _secondaryLocations.add(result));
  }

  Future<void> _saveLocations() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<UserService>(context, listen: false).updateProfile({'mainLocation': _mainLocation, 'secondaryLocations': _secondaryLocations});
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
