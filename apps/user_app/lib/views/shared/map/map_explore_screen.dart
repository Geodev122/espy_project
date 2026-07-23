import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:espy_app/l10n/app_localizations.dart';
import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/viewmodels/firestore_service.dart';
import 'package:espy_app/viewmodels/auth_service.dart';
import 'package:espy_app/viewmodels/sound_service.dart';
import 'package:espy_app/viewmodels/directory_view_model.dart';
import 'package:espy_app/models/user_model.dart';
import 'package:espy_app/widgets/common/espy_icon.dart';
import 'package:espy_app/widgets/common/premium_button.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';

class MapExploreScreen extends StatefulWidget {
  const MapExploreScreen({super.key});

  @override
  State<MapExploreScreen> createState() => _MapExploreScreenState();
}

class _MapExploreScreenState extends State<MapExploreScreen> {
  final MapController _mapController = MapController();
  LatLng? _visitorLocation;
  LatLng? _lastBrowsePosition;
  bool _showBrowseButton = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();
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

  List<Marker> _buildMarkers(DirectoryViewModel vm, bool isAr) {
    final List<Marker> newMarkers = [];
    final now = DateTime.now();

    for (var p in vm.providers) {
      if (p['visibilityExpiresAt'] == null) continue;
      
      final expiry = p['visibilityExpiresAt'] is Timestamp 
          ? (p['visibilityExpiresAt'] as Timestamp).toDate() 
          : DateTime.fromMillisecondsSinceEpoch(p['visibilityExpiresAt'] as int);
          
      if (expiry.isBefore(now)) continue;

      final role = p['role']?.toString().toLowerCase() ?? 'professional';
      final Color roleColor = role == 'institution' ? EspyTheme.gold : EspyTheme.royalBlue;

      // Extract sector branding if available
      final String iconName = p['sector']?['iconName'] ?? (role == 'institution' ? 'hospital' : 'person');
      final Color sectorColor = Color(int.tryParse(p['sector']?['colorHex'] ?? '') ?? roleColor.value);

      final mainLoc = p['mainLocation'] as Map<String, dynamic>?;
      if (mainLoc != null && mainLoc['lat'] != null) {
        newMarkers.add(
          Marker(
            point: LatLng(mainLoc['lat'], mainLoc['lng']),
            width: 80, height: 80,
            child: _buildProtocolMarker(p, roleColor, sectorColor, iconName, isAr, isMain: true),
          ),
        );
      }

      final List secondary = p['secondaryLocations'] ?? [];
      for (var loc in secondary) {
        if (loc['lat'] != null && loc['lng'] != null) {
          newMarkers.add(
            Marker(
              point: LatLng(loc['lat'], loc['lng']),
              width: 80, height: 80,
              child: _buildProtocolMarker(p, roleColor, sectorColor, iconName, isAr, isMain: false, activity: loc['activity']),
            ),
          );
        }
      }
    }
    return newMarkers;
  }

  Widget _buildProtocolMarker(Map<String, dynamic> p, Color roleColor, Color sectorColor, String iconName, bool isAr, {required bool isMain, String? activity}) {
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
                color: roleColor.withValues(alpha: 0.2),
                border: Border.all(color: roleColor.withValues(alpha: 0.1), width: 1),
              ),
            ),
          ),
          Container(
            width: isMain ? 28 : 22,
            height: isMain ? 28 : 22,
            decoration: BoxDecoration(
              color: sectorColor,
              shape: BoxShape.circle,
              border: Border.all(color: roleColor, width: isMain ? 3 : 2),
              boxShadow: [
                BoxShadow(color: roleColor.withValues(alpha: 0.4), blurRadius: 10, spreadRadius: 2)
              ]
            ),
            child: Center(
              child: EspyIcon(
                iconName: iconName,
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
    // Check if we should show a cluster list or a single profile
    final directoryVM = Provider.of<DirectoryViewModel>(context, listen: false);
    final cityId = p['mainLocation']?['cityId'] ?? p['cityId'];
    
    // Find all providers in this city
    final providersInCity = directoryVM.providers.where((prov) {
      final loc = prov['mainLocation'] as Map<String, dynamic>?;
      return loc != null && loc['cityId'] == cityId;
    }).toList();

    if (providersInCity.length > 1) {
      _showCityClusterList(providersInCity, isAr);
    } else {
      _showSingleProfilePopup(p, isAr, activity: activity);
    }
  }

  void _showCityClusterList(List<Map<String, dynamic>> providers, bool isAr) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(color: EspyTheme.platinum, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("CITY PROTOCOL SUMMARY", style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep, letterSpacing: 2)),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: providers.length,
                itemBuilder: (context, index) {
                  final p = providers[index];
                  return ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _showSingleProfilePopup(p, isAr);
                    },
                    leading: CircleAvatar(backgroundImage: p['photoUrl'] != null ? NetworkImage(p['photoUrl']) : null),
                    title: Text(p['name'] ?? 'Specialist', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text(p['specialization'] ?? 'Care Provider', style: const TextStyle(fontSize: 10)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSingleProfilePopup(Map<String, dynamic> p, bool isAr, {String? activity}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: EspyTheme.navyDeep,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: EspyTheme.cyan.withValues(alpha: 0.3))),
        title: Text(
          (isAr ? p['fullNameAr'] : p['fullNameEn']) ?? p['fullNameEn'] ?? p['name'] ?? 'ESPY NODE', 
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
                "NODE ACTIVITY:",
                style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.gold, letterSpacing: 1),
              ),
              Text(activity, style: GoogleFonts.lora(color: Colors.white70, fontSize: 13)),
            ],
            const SizedBox(height: 12),
            Builder(builder: (context) {
              final Map<String, dynamic>? loc = p['mainLocation'] as Map<String, dynamic>?;
              String cityName = isAr ? 'لبنان' : 'Lebanon';
              if (loc != null) {
                // Hierarchical v7 support
                final city = loc['city'] as Map<String, dynamic>?;
                if (city != null) {
                  cityName = (isAr ? city['nameAr'] : city['nameEn']) ?? city['nameEn'] ?? cityName;
                } else {
                  // Fallback to old flat model if exists
                  cityName = (isAr ? (loc['cityNameAr'] ?? loc['cityName']) : (loc['cityNameEn'] ?? loc['cityName']))?.toString() ?? cityName;
                }
              }
              return Text(cityName.toUpperCase(), style: GoogleFonts.lora(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.bold));
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = Provider.of<AuthService>(context);
    final directoryVM = Provider.of<DirectoryViewModel>(context);
    final user = auth.userData;
    final bool isVisitor = user?.role == UserRole.visitor;
    
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final bool filtersActive = directoryVM.selectedSectorId != null || directoryVM.selectedRole != null;

    return EspyScaffold(
      useCinematicBackground: false, 
      extendBodyBehindAppBar: true,
      body: Stack(
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
              MarkerLayer(markers: _buildMarkers(directoryVM, isAr)),
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
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 4))],
                      border: Border.all(color: EspyTheme.navyDeep.withValues(alpha: 0.05)),
                    ),
                    child: Row(
                      children: [
                        Icon(LucideIcons.radar, size: 16, color: EspyTheme.royalBlue),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            !directoryVM.radiusFilterActive
                              ? "SCANNING 10KM RADIUS"
                              : (directoryVM.searchRadiusKm >= 100 ? "GLOBAL VIEW: ALL PINs VISIBLE" : "FILTER: PINs WITHIN ${directoryVM.searchRadiusKm.toInt()}KM VISIBLE"),
                            style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w800, color: EspyTheme.navyDeep, letterSpacing: 0.5),
                          ),
                        ),
                        if (directoryVM.radiusFilterActive)
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
                        directoryVM.setFilters(userLocation: _lastBrowsePosition, radiusActive: true);
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
                  onTap: () => _showFilterModal(l10n, isAr, directoryVM),
                  color: EspyTheme.navyDeep,
                  iconColor: Colors.white,
                  showDot: filtersActive,
                ),
                if (!isVisitor && user != null) ...[
                  const SizedBox(height: 12),
                  _buildMapControl(
                    icon: Icons.hub_rounded,
                    onTap: () => _showMyNodes(user.rawData, isAr, l10n),
                    color: EspyTheme.gold,
                    iconColor: Colors.white,
                    isGold: true,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMyNodes(Map<String, dynamic> userData, bool isAr, AppLocalizations l10n) {
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
        'name': '${isAr ? 'عقدة' : 'NODE'} ${i + 1}',
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
            Text(l10n.myNodesOfPresence.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep, letterSpacing: 2)),
            const SizedBox(height: 16),
            if (nodes.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(child: Text(l10n.noNodesInitialized.toUpperCase(), style: GoogleFonts.lora(fontSize: 12, color: Colors.black26, fontStyle: FontStyle.italic))),
              ),
            ...nodes.map((node) => ListTile(
              onTap: () {
                Navigator.pop(context);
                _mapController.move(LatLng(node['lat'], node['lng']), 15);
              },
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: node['isMain'] ? EspyTheme.gold.withValues(alpha: 0.1) : EspyTheme.royalBlue.withValues(alpha: 0.1), shape: BoxShape.circle),
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
                color: isGold ? EspyTheme.gold.withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 6))],
                border: Border.all(color: (isGold ? Colors.white : EspyTheme.royalBlue).withValues(alpha: 0.2), width: 1.5),
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

  void _showFilterModal(AppLocalizations l10n, bool isAr, DirectoryViewModel vm) {
    String? tempRole = vm.selectedRole;
    String? tempSectorId = vm.selectedSectorId;
    String? tempCountryId = vm.selectedCountryId;
    double tempRadius = vm.searchRadiusKm;
    bool tempRadiusActive = vm.radiusFilterActive;

    final FirestoreService firestore = FirestoreService();

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
                Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 24), decoration: BoxDecoration(color: EspyTheme.navyDeep.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(2)))),
                Text(l10n.mapFilters.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 22, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep, letterSpacing: 2)),
                const SizedBox(height: 32),
                Text(l10n.country.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.royalBlue, letterSpacing: 2)),
                const SizedBox(height: 12),
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: firestore.getCountries(),
                  builder: (context, snapshot) {
                    final countries = snapshot.data ?? [];
                    return Wrap(
                      spacing: 12, runSpacing: 8,
                      children: [
                        ChoiceChip(
                          label: Text(l10n.all.toUpperCase()),
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
                Text(l10n.userRole.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.royalBlue, letterSpacing: 2)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  children: [
                    ChoiceChip(
                      label: Text(l10n.all.toUpperCase()),
                      selected: tempRole == null,
                      onSelected: (v) {
                        setModalState(() => tempRole = null);
                      },
                      selectedColor: EspyTheme.gold,
                      labelStyle: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.bold, color: tempRole == null ? Colors.white : Colors.black54),
                    ),
                    ChoiceChip(
                      label: Text(l10n.professional.toUpperCase()),
                      selected: tempRole == 'professional',
                      onSelected: (v) {
                        setModalState(() => tempRole = 'professional');
                      },
                      selectedColor: EspyTheme.gold,
                      labelStyle: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.bold, color: tempRole == 'professional' ? Colors.white : Colors.black54),
                    ),
                    ChoiceChip(
                      label: Text(l10n.institution.toUpperCase()),
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
                  stream: firestore.getSectors(),
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
                          backgroundColor: Colors.black.withValues(alpha: 0.05),
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
                            backgroundColor: Colors.black.withValues(alpha: 0.05),
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
                  inactiveColor: EspyTheme.royalBlue.withValues(alpha: 0.1),
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
                            tempRadius = 10.0;
                            tempRadiusActive = false;
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(l10n.clearAll.toUpperCase(), style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, color: Colors.redAccent, fontSize: 12, letterSpacing: 1)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: PremiumButton(
                        label: l10n.acknowledge.toUpperCase(),
                        fullWidth: true,
                        onPressed: () {
                          vm.setFilters(
                            role: tempRole ?? 'ALL',
                            sectorId: tempSectorId ?? 'ALL',
                            countryId: tempCountryId ?? 'ALL',
                            radius: tempRadius,
                            radiusActive: tempRadiusActive,
                          );
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
