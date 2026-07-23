import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/viewmodels/espy_repository.dart';

class HierarchicalLocationPicker extends StatefulWidget {
  final Function(Map<String, dynamic> city) onCitySelected;
  const HierarchicalLocationPicker({super.key, required this.onCitySelected});

  @override
  State<HierarchicalLocationPicker> createState() => _HierarchicalLocationPickerState();
}

class _HierarchicalLocationPickerState extends State<HierarchicalLocationPicker> {
  String? _selectedCountryId;
  String? _selectedRegionId;
  Map<String, dynamic>? _selectedCity;

  List<Map<String, dynamic>> _countries = [];
  List<Map<String, dynamic>> _regions = [];
  List<Map<String, dynamic>> _cities = [];

  bool _loadingCountries = true;
  bool _loadingRegions = false;
  bool _loadingCities = false;

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  Future<void> _fetchCountries() async {
    final repo = context.read<EspyRepository>();
    repo.listCountries().first.then((data) {
      if (mounted) setState(() { _countries = data; _loadingCountries = false; });
    });
  }

  final Map<String, List<Map<String, dynamic>>> _regionCache = {};
  final Map<String, List<Map<String, dynamic>>> _cityCache = {};

  Future<void> _fetchRegions(String countryId) async {
    if (_regionCache.containsKey(countryId)) {
      setState(() {
        _regions = _regionCache[countryId]!;
        _selectedRegionId = null;
        _cities = [];
        _selectedCity = null;
      });
      return;
    }

    setState(() { _loadingRegions = true; _regions = []; _selectedRegionId = null; });
    final repo = context.read<EspyRepository>();
    repo.listRegions(countryId).first.then((data) {
      if (mounted) {
        _regionCache[countryId] = data;
        setState(() { _regions = data; _loadingRegions = false; });
      }
    });
  }

  Future<void> _fetchCities(String regionId) async {
    if (_cityCache.containsKey(regionId)) {
      setState(() {
        _cities = _cityCache[regionId]!;
        _selectedCity = null;
      });
      return;
    }

    setState(() { _loadingCities = true; _cities = []; _selectedCity = null; });
    final repo = context.read<EspyRepository>();
    repo.listCities(regionId).first.then((data) {
      if (mounted) {
        _cityCache[regionId] = data;
        setState(() { _cities = data; _loadingCities = false; });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Column(
      crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        _buildLabel(isAr ? "اختر الدولة" : "Select Country"),
        _buildDropdown(
          isAr: isAr,
          items: _countries,
          value: _selectedCountryId,
          hint: isAr ? "اختر الدولة" : "CHOOSE COUNTRY",
          loading: _loadingCountries,
          onChanged: (val) {
            setState(() => _selectedCountryId = val);
            _fetchRegions(val!);
          },
        ),
        if (_selectedCountryId != null) ...[
          const SizedBox(height: 20),
          _buildLabel(isAr ? "اختر المنطقة" : "Select Region"),
          _buildDropdown(
            isAr: isAr,
            items: _regions,
            value: _selectedRegionId,
            hint: isAr ? "اختر المنطقة" : "CHOOSE REGION",
            loading: _loadingRegions,
            onChanged: (val) {
              setState(() => _selectedRegionId = val);
              _fetchCities(val!);
            },
          ),
        ],
        if (_selectedRegionId != null) ...[
          const SizedBox(height: 20),
          _buildLabel(isAr ? "اختر المدينة" : "Select City"),
          _buildDropdown(
            isAr: isAr,
            items: _cities,
            value: _selectedCity?['id'],
            hint: isAr ? "اختر المدينة" : "CHOOSE CITY",
            loading: _loadingCities,
            onChanged: (val) {
              final city = _cities.firstWhere((c) => c['id'] == val);
              setState(() => _selectedCity = city);
              widget.onCitySelected(city);
            },
          ),
        ],
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(text.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 9, fontWeight: FontWeight.bold, color: EspyTheme.gold)),
    );
  }

  Widget _buildDropdown({required bool isAr, required List<Map<String, dynamic>> items, required String? value, required String hint, required bool loading, required Function(String?) onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16)),
      child: loading 
        ? const Padding(padding: EdgeInsets.all(12), child: LinearProgressIndicator(color: EspyTheme.gold))
        : DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              alignment: isAr ? Alignment.centerRight : Alignment.centerLeft,
              dropdownColor: EspyTheme.navyDeep,
              hint: Text(hint, style: const TextStyle(color: Colors.white38, fontSize: 12)),
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: EspyTheme.gold),
              items: items.map((i) {
                final String label = (isAr ? i['nameAr'] : i['nameEn']) ?? i['nameEn'] ?? 'N/A';
                return DropdownMenuItem<String>(
                  value: i['id'],
                  child: Text(label.toUpperCase(), textDirection: isAr ? TextDirection.rtl : TextDirection.ltr),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
    );
  }
}
