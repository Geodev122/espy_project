import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import 'premium_button.dart';
import 'package:shared_core/services/sound_service.dart';
import 'package:shared_core/services/firestore_service.dart';

class LocationPickerModal extends StatefulWidget {
  final String title;
  const LocationPickerModal({super.key, required this.title});

  @override
  State<LocationPickerModal> createState() => _LocationPickerModalState();
}

class _LocationPickerModalState extends State<LocationPickerModal> {
  final FirestoreService _firestore = FirestoreService();
  LatLng _currentCenter = const LatLng(33.8938, 35.5018); // Default Beirut
  String _extractedCity = "Identify your exact PIN...";
  bool _isResolving = false;
  final MapController _mapController = MapController();

  String? _selectedCountryId;
  String? _selectedGovernorateId;
  String? _selectedCityId;

  Future<void> _onPositionChanged(MapCamera position, bool hasGesture) async {
    if (!hasGesture) return;
    setState(() {
      _currentCenter = position.center;
      _isResolving = true;
    });
  }

  Future<void> _resolveLocation() async {
    if (kIsWeb) {
      setState(() {
        _extractedCity = "Pin: ${_currentCenter.latitude.toStringAsFixed(4)}, ${_currentCenter.longitude.toStringAsFixed(4)}";
        _isResolving = false;
      });
      return;
    }
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentCenter.latitude,
        _currentCenter.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        setState(() {
          _extractedCity = "${p.locality ?? p.subAdministrativeArea ?? 'Selected Point'}, ${p.administrativeArea ?? ''}";
          _isResolving = false;
        });
      }
    } catch (e) {
      setState(() {
        _extractedCity = "Custom Node Position";
        _isResolving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: const BoxDecoration(
        color: EspyTheme.navy,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Text(widget.title.toUpperCase(),
              style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white, letterSpacing: 2)),
          ),
          
          // Selection Hierarchy
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildCountrySelector()),
                    const SizedBox(width: 12),
                    Expanded(child: _buildGovernorateSelector()),
                  ],
                ),
                const SizedBox(height: 12),
                _buildCitySelector(),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _currentCenter,
                      initialZoom: 14,
                      onPositionChanged: _onPositionChanged,
                      onMapEvent: (event) {
                         if (event is MapEventMoveEnd) {
                           _resolveLocation();
                         }
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager_labels_under/{z}/{x}/{y}{r}.png',
                        subdomains: const ['a', 'b', 'c', 'd'],
                      ),
                    ],
                  ),

                  // Center Marker Overlay
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 45),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: EspyTheme.navy,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: EspyTheme.electricBlue, width: 1.5),
                              boxShadow: [BoxShadow(color: EspyTheme.electricBlue.withOpacity(0.3), blurRadius: 10)]
                            ),
                            child: Text('PICK PIN', style: GoogleFonts.cinzel(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.white)),
                          ),
                          const Icon(Icons.location_on_rounded, size: 50, color: EspyTheme.electricBlue),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Controls
                  Positioned(
                    bottom: 32,
                    left: 24,
                    right: 24,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          decoration: BoxDecoration(
                            color: EspyTheme.navy,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white12),
                            boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 25, offset: Offset(0, 10))],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.radar_rounded, color: EspyTheme.cyan, size: 20),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  _isResolving ? "SYNCHRONIZING..." : _extractedCity.toUpperCase(),
                                  style: GoogleFonts.cinzel(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        PremiumButton(
                          label: 'AUTHENTICATE PIN POSITION',
                          variant: PremiumButtonVariant.electric,
                          fullWidth: true,
                          isLoading: _isResolving,
                          onPressed: () {
                            if (_selectedCountryId == null || _selectedGovernorateId == null || _selectedCityId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please specify Country, Region, and City')));
                              return;
                            }
                            HapticFeedback.heavyImpact();
                            SoundService.playClick();
                            Navigator.pop(context, {
                              'lat': _currentCenter.latitude,
                              'lng': _currentCenter.longitude,
                              'cityName': _extractedCity,
                              'countryId': _selectedCountryId,
                              'governorateId': _selectedGovernorateId,
                              'cityId': _selectedCityId,
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  // Map Zoom Tools
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Column(
                      children: [
                        _buildMapTool(Icons.add_rounded, () => _mapController.move(_mapController.camera.center, _mapController.camera.zoom + 1)),
                        const SizedBox(height: 8),
                        _buildMapTool(Icons.remove_rounded, () => _mapController.move(_mapController.camera.center, _mapController.camera.zoom - 1)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountrySelector() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _firestore.getCountries(),
      builder: (context, snapshot) {
        final countries = snapshot.data ?? [];
        return DropdownButtonFormField<String>(
          value: _selectedCountryId,
          hint: Text('COUNTRY', style: GoogleFonts.cinzel(fontSize: 10, color: Colors.white38)),
          dropdownColor: EspyTheme.navy,
          style: GoogleFonts.cinzel(fontSize: 11, color: Colors.white),
          items: countries.map((c) => DropdownMenuItem(value: c['id'].toString(), child: Text(c['name_en'].toString().toUpperCase()))).toList(),
          onChanged: (v) => setState(() { _selectedCountryId = v; _selectedGovernorateId = null; _selectedCityId = null; }),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        );
      },
    );
  }

  Widget _buildGovernorateSelector() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _firestore.getGovernorates(countryId: _selectedCountryId),
      builder: (context, snapshot) {
        final items = snapshot.data ?? [];
        return DropdownButtonFormField<String>(
          value: _selectedGovernorateId,
          hint: Text('REGION', style: GoogleFonts.cinzel(fontSize: 10, color: Colors.white38)),
          dropdownColor: EspyTheme.navy,
          style: GoogleFonts.cinzel(fontSize: 11, color: Colors.white),
          items: items.map((c) => DropdownMenuItem(value: c['id'].toString(), child: Text(c['name_en'].toString().toUpperCase()))).toList(),
          onChanged: (v) => setState(() { _selectedGovernorateId = v; _selectedCityId = null; }),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        );
      },
    );
  }

  Widget _buildCitySelector() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _firestore.getCities(governorateId: _selectedGovernorateId),
      builder: (context, snapshot) {
        final items = snapshot.data ?? [];
        return DropdownButtonFormField<String>(
          value: _selectedCityId,
          hint: Text('CITY', style: GoogleFonts.cinzel(fontSize: 10, color: Colors.white38)),
          dropdownColor: EspyTheme.navy,
          style: GoogleFonts.cinzel(fontSize: 11, color: Colors.white),
          items: items.map((c) => DropdownMenuItem(value: c['id'].toString(), child: Text(c['name_en'].toString().toUpperCase()))).toList(),
          onChanged: (v) => setState(() => _selectedCityId = v),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        );
      },
    );
  }

  Widget _buildMapTool(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: EspyTheme.navy,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Icon(icon, color: Colors.white70, size: 24),
      ),
    );
  }
}
