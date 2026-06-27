import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:espy_pro/core/theme.dart';
import 'package:shared_core/services/user_service.dart';
import 'package:espy_pro/widgets/common/location_picker_modal.dart';
import 'package:espy_pro/widgets/common/premium_button.dart';
import 'package:espy_pro/widgets/common/premium_card.dart';
import 'package:espy_pro/screens/profile/token_shop_screen.dart';

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
                  _buildSectionHeader('PRIMARY PIN LOCATION'),
                  PremiumCard(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: EspyTheme.gold),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _mainLocation?['cityName'] ?? 'Primary PIN not set.',
                            style: GoogleFonts.lora(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                        TextButton(
                          onPressed: _openMainLocationPicker,
                          child: Text('UPDATE',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w900,
                                  color: EspyTheme.mahogany,
                                  fontSize: 12)),
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
                          _buildSectionHeader('SECONDARY PINS'),
                          Text('Entitlement: $currentSecondaryCount / $practicePins PINs',
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
                            child: Text('Limit reached. To unlock more specialized presence PINs, please visit your Espy Wallet.',
                              style: GoogleFonts.lora(fontSize: 10, fontStyle: FontStyle.italic)),
                          ),
                        ],
                      ),
                    ),
                  ..._secondaryLocations.asMap().entries.map((entry) {
                    final loc = entry.value;
                    
                    final expiry = loc['visibilityExpiresAt'] != null 
                        ? (loc['visibilityExpiresAt'] is Timestamp 
                            ? (loc['visibilityExpiresAt'] as Timestamp).toDate() 
                            : DateTime.tryParse(loc['visibilityExpiresAt'].toString()))
                        : null;
                        
                    final bool isExpired = expiry != null && expiry.isBefore(DateTime.now());

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        tileColor: isExpired ? Colors.redAccent.withOpacity(0.1) : Colors.white.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        title: Text(loc['cityName'],
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w900, fontSize: 13, color: isExpired ? EspyTheme.error : null, letterSpacing: 0.5)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${loc['activity']} · ${loc['days'].join(", ")}',
                                style: GoogleFonts.lora(fontSize: 10)),
                            if (expiry != null)
                              Text(
                                isExpired ? "EXPIRED: ${DateFormat('dd MMM yy').format(expiry)}" : "Expires: ${DateFormat('dd MMM yy').format(expiry)}",
                                style: GoogleFonts.lora(fontSize: 9, fontWeight: FontWeight.bold, color: isExpired ? EspyTheme.error : Colors.black38),
                              ),
                          ],
                        ),
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
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: EspyTheme.noir,
              letterSpacing: 1)),
    );
  }

  void _showLimitReachedPrompt() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: EspyTheme.platinum,
        title: Text('LIMIT REACHED', style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, letterSpacing: 1)),
        content: const Text('You have utilized all your allocated presence PINs. Please visit your Espy Wallet to purchase additional PINs.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to wallet shop
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TokenShopScreen(initialTab: 1)));
            },
            child: Text('VISIT STORE', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: EspyTheme.gold)),
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
      builder: (_) => const LocationPickerModal(title: 'UPDATE MAIN PIN'),
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
      builder: (_) => const LocationPickerModal(title: 'ADD SECONDARY PIN'),
    );

    if (locationResult != null && mounted) {
      final activityController = TextEditingController();
      List<String> selectedDays = [];

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: EspyTheme.platinum,
          title: Text('PIN DETAILS',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, letterSpacing: 1)),
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
                  style: GoogleFonts.montserrat(
                      fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
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
              child: const Text('ADD PIN'),
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
            const SnackBar(content: Text('PIN positions synchronized.')));
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
