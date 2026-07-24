import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/viewmodels/espy_repository.dart';
import 'package:espy_app/models/country_model.dart';
import 'package:espy_app/models/region_model.dart';
import 'package:espy_app/models/city_model.dart';

class HierarchicalLocationPicker extends StatefulWidget {
  final Function(CityModel city) onCitySelected;
  const HierarchicalLocationPicker({super.key, required this.onCitySelected});

  @override
  State<HierarchicalLocationPicker> createState() => _HierarchicalLocationPickerState();
}

class _HierarchicalLocationPickerState extends State<HierarchicalLocationPicker> {
  String? _selectedCountryId;
  String? _selectedRegionId;
  CityModel? _selectedCity;

  List<CountryModel> _countries = [];
  List<RegionModel> _regions = [];
  List<CityModel> _cities = [];

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

  Future<void> _fetchRegions(String countryId) async {
    setState(() { _loadingRegions = true; _regions = []; _selectedRegionId = null; });
    final repo = context.read<EspyRepository>();
    repo.listRegions(countryId).first.then((data) {
      if (mounted) setState(() { _regions = data; _loadingRegions = false; });
    });
  }

  Future<void> _fetchCities(String regionId) async {
    setState(() { _loadingCities = true; _cities = []; _selectedCity = null; });
    final repo = context.read<EspyRepository>();
    repo.listCities(regionId).first.then((data) {
      if (mounted) setState(() { _cities = data; _loadingCities = false; });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Select Country"),
        _buildDropdown(
          items: _countries.map((c) => {'id': c.id, 'name': c.nameEn}).toList(),
          value: _selectedCountryId,
          hint: "CHOOSE COUNTRY",
          loading: _loadingCountries,
          onChanged: (val) {
            setState(() => _selectedCountryId = val);
            _fetchRegions(val!);
          },
        ),
        if (_selectedCountryId != null) ...[
          const SizedBox(height: 20),
          _buildLabel("Select Region"),
          _buildDropdown(
            items: _regions.map((r) => {'id': r.id, 'name': r.nameEn}).toList(),
            value: _selectedRegionId,
            hint: "CHOOSE REGION",
            loading: _loadingRegions,
            onChanged: (val) {
              setState(() => _selectedRegionId = val);
              _fetchCities(val!);
            },
          ),
        ],
        if (_selectedRegionId != null) ...[
          const SizedBox(height: 20),
          _buildLabel("Select City"),
          _buildDropdown(
            items: _cities.map((c) => {'id': c.id, 'name': c.nameEn}).toList(),
            value: _selectedCity?.id,
            hint: "CHOOSE CITY",
            loading: _loadingCities,
            onChanged: (val) {
              final city = _cities.firstWhere((c) => c.id == val);
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

  Widget _buildDropdown({required List<Map<String, dynamic>> items, required String? value, required String hint, required bool loading, required Function(String?) onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16)),
      child: loading 
        ? const Padding(padding: EdgeInsets.all(12), child: LinearProgressIndicator(color: EspyTheme.gold))
        : DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: EspyTheme.navyDeep,
              hint: Text(hint, style: const TextStyle(color: Colors.white38, fontSize: 12)),
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: EspyTheme.gold),
              items: items.map((i) => DropdownMenuItem<String>(
                value: i['id'],
                child: Text(i['name'].toString().toUpperCase()),
              )).toList(),
              onChanged: onChanged,
            ),
          ),
    );
  }
}
