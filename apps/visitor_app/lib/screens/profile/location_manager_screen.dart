import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import 'package:shared_core/services/user_service.dart';
import '../../widgets/common/location_picker_modal.dart';
import '../../widgets/common/premium_button.dart';
import '../../widgets/common/premium_card.dart';

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
    _loadCurrentProfile();
  }

  void _loadCurrentProfile() {
    final userService = Provider.of<UserService>(context, listen: false);
    final profile = userService.profile ?? {};

    setState(() {
      _mainLocation = profile['mainLocation'];
      final secondary = profile['secondaryLocations'] as List?;
      if (secondary != null) {
        _secondaryLocations = List<Map<String, dynamic>>.from(secondary);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserService>(
      builder: (context, userService, child) {
        final profile = userService.profile ?? {};
        final int practicePins = profile['practicePins'] ?? 0;
        final int currentSecondaryCount = _secondaryLocations.length;
        final bool canAddMore = currentSecondaryCount < practicePins;

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('LOCATION SETTINGS'),
          ),
          body: Container(
            height: double.infinity,
            decoration: const BoxDecoration(gradient: EspyTheme.lightBlueFlame),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('PRIMARY NODE LOCATION'),
                  PremiumCard(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: EspyTheme.gold),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _mainLocation?['cityName'] ?? 'Primary pin not set.',
                            style: GoogleFonts.lora(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                        TextButton(
                          onPressed: _openMainLocationPicker,
                          child: Text('UPDATE',
                              style: GoogleFonts.cinzel(
                                  fontWeight: FontWeight.w900,
                                  color: EspyTheme.mahogany)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader('SECONDARY NODES'),
                          Text('Entitlement: $currentSecondaryCount / $practicePins Pins',
                            style: GoogleFonts.lora(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.gold)),
                        ],
                      ),
                      IconButton(
                        onPressed: canAddMore ? _openSecondaryLocationPicker : _showLimitReachedPrompt,
                        icon: Icon(canAddMore ? Icons.add_location_alt_rounded : Icons.lock_outline_rounded,
                            color: canAddMore ? EspyTheme.teal : Colors.grey),
                      ),
                    ],
                  ),
                  if (!canAddMore && practicePins > 0)
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: EspyTheme.gold.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: EspyTheme.gold.withOpacity(0.1)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, size: 14, color: EspyTheme.gold),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text('Limit reached. To unlock more specialized presence pins, please visit the subscription vault.',
                              style: GoogleFonts.lora(fontSize: 10, fontStyle: FontStyle.italic)),
                          ),
                        ],
                      ),
                    ),
                  ..._secondaryLocations.asMap().entries.map((entry) {
                    final loc = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        tileColor: Colors.white.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        title: Text(loc['cityName'],
                            style: GoogleFonts.cinzel(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                        subtitle: Text(
                            '${loc['activity']} · ${loc['days'].join(", ")}',
                            style: GoogleFonts.lora(fontSize: 10)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.redAccent, size: 18),
                          onPressed: () =>
                              setState(() => _secondaryLocations.removeAt(entry.key)),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 48),
                  PremiumButton(
                    label: 'SYNCHRONIZE LOCATIONS',
                    isLoading: _isLoading,
                    fullWidth: true,
                    onPressed: _saveLocations,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(title,
          style: GoogleFonts.cinzel(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: EspyTheme.noir)),
    );
  }

  void _showLimitReachedPrompt() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: EspyTheme.platinum,
        title: Text('LIMIT REACHED', style: GoogleFonts.cinzel(fontWeight: FontWeight.w900)),
        content: const Text('You have utilized all your allocated presence pins. Please visit the Vault to purchase additional nodes.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to vault logic here or let user go back
            },
            child: Text('VISIT VAULT', style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, color: EspyTheme.gold)),
          ),
        ],
      ),
    );
  }

  Future<void> _openMainLocationPicker() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LocationPickerModal(title: 'UPDATE MAIN NODE'),
    );
    if (result != null) {
      setState(() => _mainLocation = result);
    }
  }

  Future<void> _openSecondaryLocationPicker() async {
    final Map<String, dynamic>? locationResult = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LocationPickerModal(title: 'ADD SECONDARY NODE'),
    );

    if (locationResult != null && mounted) {
      final activityController = TextEditingController();
      List<String> selectedDays = [];

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: EspyTheme.platinum,
          title: Text('NODE DETAILS',
              style: GoogleFonts.cinzel(fontWeight: FontWeight.w900)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: activityController,
                decoration:
                    const InputDecoration(hintText: 'What do you do here?'),
              ),
              const SizedBox(height: 20),
              Text('Presence Days',
                  style: GoogleFonts.cinzel(
                      fontSize: 10, fontWeight: FontWeight.bold)),
              StatefulBuilder(
                builder: (context, setDialogState) => Wrap(
                  spacing: 4,
                  children: ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']
                      .map((day) {
                    bool isSelected = selectedDays.contains(day);
                    return ChoiceChip(
                      label: Text(day, style: const TextStyle(fontSize: 8)),
                      selected: isSelected,
                      onSelected: (selected) {
                        setDialogState(() {
                          if (selected) {
                            selectedDays.add(day);
                          } else {
                            selectedDays.remove(day);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL')),
            TextButton(
              onPressed: () {
                setState(() {
                  _secondaryLocations.add({
                    ...locationResult,
                    'activity': activityController.text,
                    'days': selectedDays,
                  });
                });
                Navigator.pop(context);
              },
              child: const Text('ADD NODE'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _saveLocations() async {
    final userService = Provider.of<UserService>(context, listen: false);
    setState(() => _isLoading = true);

    try {
      await userService.updateProfile({
        'mainLocation': _mainLocation,
        'secondaryLocations': _secondaryLocations,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Node positions synchronized.')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
