import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons_flutter/lucide_icons_flutter.dart';

import '../../l10n/app_localizations.dart';
import 'package:shared_core/theme/espy_theme.dart';
import 'package:shared_core/services/firestore_service.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/services/sound_service.dart';
import 'package:shared_core/models/user_model.dart';
import '../../widgets/common/premium_button.dart';

class MapExploreScreen extends StatefulWidget {
  const MapExploreScreen({super.key});

  @override
  State<MapExploreScreen> createState() => _MapExploreScreenState();
}

class _MapExploreScreenState extends State<MapExploreScreen> {
  final FirestoreService _firestore = FirestoreService();
  final List<Marker> _markers = [];
  final MapController _mapController = MapController();
  StreamSubscription? _profsSubscription;

  double _searchRadiusKm = 10.0; 
  bool _radiusFilterActive = false;
  String? _selectedSectorId;
  String? _selectedCountryId;
  String? _selectedRole; 
  LatLng? _visitorLocation;
  LatLng? _lastBrowsePosition;
  bool _showBrowseButton = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _loadNodeMarkers();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        _visitorLocation = LatLng(position.latitude, position.longitude);
        _lastBrowsePosition = _visitorLocation;
      });
      _mapController.move(
        _visitorLocation ?? const LatLng(33.8938, 35.5018),
        12,
      );
    }
  }

  @override
  void dispose() {
    _profsSubscription?.cancel();
    super.dispose();
  }

  void _loadNodeMarkers() {
    final bool isAr = Localizations.maybeLocaleOf(context)?.languageCode == 'ar';
    _profsSubscription?.cancel();
    
    _profsSubscription = _firestore.getAllProviders().listen((nodes) async {
      if (!mounted) return;

      final List<Marker> newMarkers = [];
      final now = DateTime.now();

      for (var p in nodes) {
        if (_selectedSectorId != null && p['sectorId'] != _selectedSectorId) continue;
        if (_selectedRole != null && p['role'] != _selectedRole) continue;
        if (_selectedCountryId != null && (p['countryId'] ?? p['country'] ?? 'LEBANON').toString().toUpperCase() != _selectedCountryId!.toUpperCase()) continue;
        
        // Account Status Check (Suspension)
        final bool accountActive = (p['isActive'] ?? true) && (p['isApproved'] ?? true);
        if (!accountActive) continue;

        final role = p['role'] ?? 'professional';
        final color = role == 'professional' ? EspyTheme.electricBlue : EspyTheme.gold;

        // 1. Main Hub - Always visible if account is active
        final mainLoc = p['mainLocation'] as Map<String, dynamic>?;
        if (mainLoc != null && mainLoc['lat'] != null) {
          final pos = LatLng(mainLoc['lat'], mainLoc['lng']);
          if (_isWithinRadius(pos)) {
            newMarkers.add(
              Marker(
                point: pos,
                width: 80, height: 80,
                child: _buildProtocolMarker(p, color, isAr, isMain: true),
              ),
            );
          }
        }

        // 2. Secondary Nodes (Element Expiry Check)
        final List secondary = p['secondaryLocations'] ?? [];
        for (var loc in secondary) {
          if (loc['lat'] != null && loc['lng'] != null) {
            // Check Expiry for secondary node
            if (loc['visibilityExpiresAt'] != null) {
              final expiry = loc['visibilityExpiresAt'] is Timestamp 
                  ? (loc['visibilityExpiresAt'] as Timestamp).toDate() 
                  : DateTime.fromMillisecondsSinceEpoch(loc['visibilityExpiresAt'] as int);
              if (expiry.isBefore(now)) continue;
            }

            final pos = LatLng(loc['lat'], loc['lng']);
            if (_isWithinRadius(pos)) {
              newMarkers.add(
                Marker(
                  point: pos,
                  width: 80, height: 80,
                  child: _buildProtocolMarker(p, color, isAr, isMain: false, activity: loc['activity']),
                ),
              );
            }
          }
        }
      }

      setState(() {
        _markers.clear();
        _markers.addAll(newMarkers);
      });
    });
  }

  Widget _buildProtocolMarker(Map<String, dynamic> p, Color color, bool isAr, {required bool isMain, String? activity}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        SoundService.playPop();
        _showMarkerPopup(p, isAr, activity: activity);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Pulse(
            infinite: true,
            child: Container(
              width: isMain ? 45 : 35,
              height: isMain ? 45 : 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.2),
                border: Border.all(color: color.withOpacity(0.1), width: 1),
              ),
            ),
          ),
          Container(
            width: isMain ? 28 : 22,
            height: isMain ? 28 : 22,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: isMain ? 3 : 2),
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.4), blurRadius: 10, spreadRadius: 2)
              ]
            ),
            child: Center(
              child: Icon(
                p['role'] == 'professional' ? Icons.person_rounded : Icons.medical_services_rounded,
                color: Colors.white,
                size: isMain ? 14 : 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMarkerPopup(Map<String, dynamic> p, bool isAr, {String? activity}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: EspyTheme.navyDeep,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: EspyTheme.cyan.withOpacity(0.3))),
        title: Text(
          (isAr ? p['fullNameAr'] : p['fullNameEn']) ?? p['fullNameEn'] ?? p['name'] ?? 'ESPY PIN', 
          style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 18)
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              (isAr ? p['specializationAr'] : p['specializationEn']) ?? p['specialization'] ?? 'Specialist', 
              style: GoogleFonts.lora(color: EspyTheme.electricBlue, fontWeight: FontWeight.bold)
            ),
            if (activity != null && activity.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                "PIN ACTIVITY:",
                style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.gold, letterSpacing: 1),
              ),
              Text(activity, style: GoogleFonts.lora(color: Colors.white70, fontSize: 13)),
            ],
            const SizedBox(height: 12),
            Builder(builder: (context) {
              final Map<String, dynamic>? loc = p['mainLocation'] as Map<String, dynamic>?;
              String cityName = 'GLOBAL';
              if (loc != null) {
                if (isAr) {
                  cityName = (loc['cityNameAr'] ?? loc['cityName'])?.toString() ?? 'GLOBAL';
                } else {
                  cityName = (loc['cityNameEn'] ?? loc['cityName'])?.toString() ?? 'GLOBAL';
                }
              }
              return Text(cityName, style: GoogleFonts.lora(color: Colors.white60));
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isAr ? 'إغلاق' : 'CLOSE', style: const TextStyle(color: Colors.white24)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: EspyTheme.gold),
            child: Text(isAr ? 'عرض الملف' : 'VIEW PROFILE', style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, color: EspyTheme.navyDeep)),
          ),
        ],
      ),
    );
  }

  bool _isWithinRadius(LatLng pos) {
    if (_radiusFilterActive && _searchRadiusKm >= 100) return true; 
    final double effectiveRadius = _radiusFilterActive ? _searchRadiusKm : 10.0;
    final LatLng center = _lastBrowsePosition ?? _visitorLocation ?? const LatLng(33.8938, 35.5018);
    final distance = Geolocator.distanceBetween(center.latitude, center.longitude, pos.latitude, pos.longitude);
    return (distance / 1000) <= effectiveRadius;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = Provider.of<AuthService>(context);
    final user = auth.userData;
    final bool isVisitor = user?.role == UserRole.visitor;
    
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final bool filtersActive = _selectedSectorId != null || _selectedRole != null || _selectedCountryId != null;

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: const LatLng(33.8938, 35.5018),
            initialZoom: 12,
            onPositionChanged: (pos, hasGesture) {
              if (hasGesture && pos.center != null) {
                if (_lastBrowsePosition == null || 
                    Geolocator.distanceBetween(_lastBrowsePosition!.latitude, _lastBrowsePosition!.longitude, pos.center!.latitude, pos.center!.longitude) > 1000) {
                  setState(() => _showBrowseButton = true);
                }
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
              subdomains: const ['a', 'b', 'c', 'd'],
            ),
            MarkerLayer(markers: _markers),
            if (_visitorLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: _visitorLocation!,
                    width: 30, height: 30,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: EspyTheme.navyDeep,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)]
                      ),
                      child: const Icon(Icons.my_location_rounded, color: EspyTheme.cyan, size: 16),
                    ),
                  ),
                ],
              ),
          ],
        ),

        // Redesigned Visibility Bar
        Positioned(
          top: MediaQuery.of(context).padding.top + 80,
          left: 20, right: 20,
          child: Column(
            children: [
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4))],
                    border: Border.all(color: EspyTheme.navyDeep.withOpacity(0.05)),
                  ),
                  child: Row(
                    children: [
                      Icon(LucideIcons.radar, size: 16, color: EspyTheme.royalBlue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          !_radiusFilterActive
                            ? "SCANNING 10KM RADIUS"
                            : (_searchRadiusKm >= 100 ? "GLOBAL VIEW: ALL PINs VISIBLE" : "FILTER: PINs WITHIN ${_searchRadiusKm.toInt()}KM VISIBLE"),
                          style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w800, color: EspyTheme.navyDeep, letterSpacing: 0.5),
                        ),
                      ),
                      if (_radiusFilterActive)
                         const Icon(Icons.check_circle_rounded, size: 14, color: EspyTheme.success),
                    ],
                  ),
                ),
              ),
              if (_showBrowseButton) ...[
                const SizedBox(height: 12),
                FadeInUp(
                  duration: const Duration(milliseconds: 300),
                  child: PremiumButton(
                    label: "BROWSE THIS AREA",
                    size: PremiumButtonSize.small,
                    variant: PremiumButtonVariant.gold,
                    onPressed: () {
                      setState(() {
                        _lastBrowsePosition = _mapController.camera.center;
                        _showBrowseButton = false;
                      });
                      _loadNodeMarkers();
                    },
                  ),
                ),
              ],
            ],
          ),
        ),

        Positioned(
          bottom: 120,
          right: isAr ? null : 20,
          left: isAr ? 20 : null,
          child: Column(
            children: [
              _buildMapControl(
                icon: Icons.my_location_rounded,
                onTap: _determinePosition,
                color: EspyTheme.navyDeep,
                iconColor: EspyTheme.cyan,
              ),
              const SizedBox(height: 12),
              _buildMapControl(
                icon: Icons.tune_rounded,
                onTap: () => _showFilterModal(l10n, isAr),
                color: EspyTheme.navyDeep,
                iconColor: Colors.white,
                showDot: filtersActive,
              ),
              if (!isVisitor && user != null) ...[
                const SizedBox(height: 12),
                _buildMapControl(
                  icon: Icons.hub_rounded,
                  onTap: () => _showMyNodes(user.rawData, isAr),
                  color: EspyTheme.gold,
                  iconColor: Colors.white,
                  isGold: true,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _showMyNodes(Map<String, dynamic> userData, bool isAr) {
    final List<Map<String, dynamic>> nodes = [];
    if (userData['mainLocation'] != null) {
      nodes.add({
        'name': isAr ? 'المركز الرئيسي' : 'MAIN HUB',
        'lat': userData['mainLocation']['lat'],
        'lng': userData['mainLocation']['lng'],
        'city': (isAr ? userData['mainLocation']['cityNameAr'] : userData['mainLocation']['cityNameEn']) ?? userData['mainLocation']['cityName'] ?? 'Lebanon',
        'isMain': true,
      });
    }
    
    final List secondary = userData['secondaryLocations'] ?? [];
    for (var i = 0; i < secondary.length; i++) {
      final loc = secondary[i];
      nodes.add({
        'name': '${isAr ? 'دبوس' : 'PIN'} ${i + 1}',
        'lat': loc['lat'],
        'lng': loc['lng'],
        'city': (isAr ? loc['cityNameAr'] : loc['cityNameEn']) ?? loc['cityName'] ?? 'Secondary',
        'isMain': false,
      });
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: EspyTheme.platinum,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            Text("MY PINS OF PRESENCE", style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep, letterSpacing: 2)),
            const SizedBox(height: 16),
            if (nodes.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(child: Text("NO PINS INITIALIZED", style: GoogleFonts.lora(fontSize: 12, color: Colors.black26, fontStyle: FontStyle.italic))),
              ),
            ...nodes.map((node) => ListTile(
              onTap: () {
                Navigator.pop(context);
                _mapController.move(LatLng(node['lat'], node['lng']), 15);
              },
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: node['isMain'] ? EspyTheme.gold.withOpacity(0.1) : EspyTheme.royalBlue.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(node['isMain'] ? Icons.stars_rounded : Icons.location_on_rounded, color: node['isMain'] ? EspyTheme.gold : EspyTheme.royalBlue, size: 20),
              ),
              title: Text(node['name'], style: GoogleFonts.cinzel(fontSize: 11, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep)),
              subtitle: Text(node['city'], style: GoogleFonts.lora(fontSize: 10, color: Colors.black54)),
              trailing: const Icon(Icons.gps_fixed_rounded, size: 16, color: Colors.black12),
            )).toList(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMapControl({required IconData icon, required VoidCallback onTap, required Color color, required Color iconColor, bool showDot = false, bool isGold = false}) {
    return FadeInRight(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Stack(
          children: [
            Container(
              width: 54, height: 54,
              decoration: BoxDecoration(
                color: isGold ? EspyTheme.gold.withOpacity(0.9) : Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 6))],
                border: Border.all(color: (isGold ? Colors.white : EspyTheme.royalBlue).withOpacity(0.2), width: 1.5),
              ),
              child: Icon(icon, color: isGold ? Colors.white : EspyTheme.navyDeep, size: 24),
            ),
            if (showDot)
              Positioned(top: 4, right: 4, child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle))),
          ],
        ),
      ),
    );
  }

  void _showFilterModal(AppLocalizations l10n, bool isAr) {
    String? tempRole = _selectedRole;
    String? tempSectorId = _selectedSectorId;
    String? tempCountryId = _selectedCountryId;
    double tempRadius = _searchRadiusKm;
    bool tempRadiusActive = _radiusFilterActive;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 48),
          decoration: const BoxDecoration(
            color: EspyTheme.platinum,
            borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 24), decoration: BoxDecoration(color: EspyTheme.navyDeep.withOpacity(0.1), borderRadius: BorderRadius.circular(2)))),
                Text(l10n.mapFilters.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 22, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep, letterSpacing: 2)),
                const SizedBox(height: 32),
                Text("COUNTRY", style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.royalBlue, letterSpacing: 2)),
                const SizedBox(height: 12),
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _firestore.getCountries(),
                  builder: (context, snapshot) {
                    final countries = snapshot.data ?? [];
                    return Wrap(
                      spacing: 12, runSpacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text("ALL"),
                          selected: tempCountryId == null,
                          onSelected: (v) => setModalState(() => tempCountryId = null),
                          selectedColor: EspyTheme.gold,
                        ),
                        ...countries.map((c) => ChoiceChip(
                          label: Text(c['name_en'].toString().toUpperCase()),
                          selected: tempCountryId == c['id'],
                          onSelected: (v) => setModalState(() => tempCountryId = c['id']),
                          selectedColor: EspyTheme.gold,
                        )),
                      ],
                    );
                  }
                ),
                const SizedBox(height: 24),
                Text("USER ROLE", style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.royalBlue, letterSpacing: 2)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  children: [
                    ChoiceChip(
                      label: const Text("ALL"),
                      selected: tempRole == null,
                      onSelected: (v) {
                        setModalState(() => tempRole = null);
                      },
                      selectedColor: EspyTheme.gold,
                      labelStyle: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.bold, color: tempRole == null ? Colors.white : Colors.black54),
                    ),
                    ChoiceChip(
                      label: const Text("PROFESSIONAL"),
                      selected: tempRole == 'professional',
                      onSelected: (v) {
                        setModalState(() => tempRole = 'professional');
                      },
                      selectedColor: EspyTheme.gold,
                      labelStyle: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.bold, color: tempRole == 'professional' ? Colors.white : Colors.black54),
                    ),
                    ChoiceChip(
                      label: const Text("INSTITUTION"),
                      selected: tempRole == 'institution',
                      onSelected: (v) {
                        setModalState(() => tempRole = 'institution');
                      },
                      selectedColor: EspyTheme.gold,
                      labelStyle: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.bold, color: tempRole == 'institution' ? Colors.white : Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(l10n.careSector.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.royalBlue, letterSpacing: 2)),
                const SizedBox(height: 16),
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _firestore.getSectors(),
                  builder: (context, snapshot) {
                    final sectors = snapshot.data ?? [];
                    return Wrap(
                      spacing: 12, runSpacing: 12,
                      alignment: isAr ? WrapAlignment.end : WrapAlignment.start,
                      children: [
                        ChoiceChip(
                          label: Text(l10n.all.toUpperCase()),
                          selected: tempSectorId == null,
                          selectedColor: EspyTheme.royalBlue,
                          checkmarkColor: Colors.white,
                          backgroundColor: Colors.black.withOpacity(0.05),
                          side: BorderSide.none,
                          labelStyle: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: tempSectorId == null ? Colors.white : Colors.black54),
                          onSelected: (val) {
                            setModalState(() => tempSectorId = null);
                          },
                        ),
                        ...sectors.map((s) {
                          final bool isSelected = tempSectorId == s['id'];
                          final String name = (isAr ? s['name_ar'] : s['name_en']) ?? s['name_en'] ?? 'OTHER';
                          return ChoiceChip(
                            label: Text(name.toUpperCase()),
                            selected: isSelected,
                            selectedColor: EspyTheme.royalBlue,
                            checkmarkColor: Colors.white,
                            backgroundColor: Colors.black.withOpacity(0.05),
                            side: BorderSide.none,
                            labelStyle: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: isSelected ? Colors.white : Colors.black54),
                            onSelected: (val) {
                              setModalState(() => tempSectorId = s['id']);
                            },
                          );
                        }),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.distanceThreshold.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.royalBlue, letterSpacing: 2)),
                    Text(tempRadius >= 100 ? "GLOBAL NETWORK" : "${tempRadius.toInt()} KM", style: GoogleFonts.cinzel(fontSize: 12, fontWeight: FontWeight.w900, color: EspyTheme.gold)),
                  ],
                ),
                Slider(
                  value: tempRadius,
                  min: 1, max: 100,
                  activeColor: EspyTheme.gold,
                  inactiveColor: EspyTheme.royalBlue.withOpacity(0.1),
                  onChanged: (val) {
                    setModalState(() { tempRadius = val; tempRadiusActive = true; });
                  },
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setModalState(() {
                            tempRole = null;
                            tempSectorId = null;
                            tempCountryId = null;
                            tempRadius = 10.0;
                            tempRadiusActive = false;
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text("CLEAR ALL", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, color: Colors.redAccent, fontSize: 12, letterSpacing: 1)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: PremiumButton(
                        label: "ACTIVATE",
                        fullWidth: true,
                        onPressed: () {
                          setState(() {
                            _selectedRole = tempRole;
                            _selectedSectorId = tempSectorId;
                            _selectedCountryId = tempCountryId;
                            _searchRadiusKm = tempRadius;
                            _radiusFilterActive = tempRadiusActive;
                          });
                          _loadNodeMarkers();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
