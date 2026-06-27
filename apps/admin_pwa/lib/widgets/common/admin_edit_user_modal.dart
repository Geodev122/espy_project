import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import 'package:shared_core/models/professional_model.dart';
import '../../services/firestore_service.dart';
import '../../providers/system_providers.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AdminEditUserModal extends ConsumerStatefulWidget {
  final ProfessionalModel user;
  const AdminEditUserModal({super.key, required this.user});

  @override
  ConsumerState<AdminEditUserModal> createState() => _AdminEditUserModalState();
}

class _AdminEditUserModalState extends ConsumerState<AdminEditUserModal> {
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _bioCtrl;
  late bool _isActive;
  String? _selectedCountryId;
  String? _selectedGovId;
  String? _selectedCityId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user.fullNameEn ?? widget.user.name);
    _emailCtrl = TextEditingController(text: widget.user.email);
    _phoneCtrl = TextEditingController(text: widget.user.phone);
    _bioCtrl = TextEditingController(text: widget.user.bioEn);
    _isActive = widget.user.isActive;
    _selectedCountryId = widget.user.countryId ?? 'lebanon';
    _selectedGovId = widget.user.governorateId;
    _selectedCityId = widget.user.cityId;
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final data = {
        'fullNameEn': _nameCtrl.text,
        'email': _emailCtrl.text,
        'phone': _phoneCtrl.text,
        'bioEn': _bioCtrl.text,
        'isActive': _isActive,
        'countryId': _selectedCountryId,
        'governorateId': _selectedGovId,
        'cityId': _selectedCityId,
      };
      
      await ref.read(firestoreServiceProvider).updateUser(widget.user.id, widget.user.role, data);
      
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 700,
        decoration: BoxDecoration(
          color: const Color(0xFF061226),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('CORE IDENTITY'),
                    const SizedBox(height: 16),
                    _buildTextField('FULL NAME', _nameCtrl),
                    const SizedBox(height: 24),
                    _buildSectionTitle('GEOGRAPHICAL ANCHORS'),
                    const SizedBox(height: 16),
                    _buildAnchorSelectors(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('COMMUNICATION'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('EMAIL ADDRESS', _emailCtrl)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField('WHATSAPP / PHONE', _phoneCtrl)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('PROFESSIONAL NARRATIVE'),
                    const SizedBox(height: 16),
                    _buildTextField('BIOGRAPHY (EN)', _bioCtrl, maxLines: 4),
                    const SizedBox(height: 24),
                    _buildSectionTitle('GOVERNANCE STATUS'),
                    const SizedBox(height: 16),
                    _buildStatusToggle(),
                  ],
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnchorSelectors() {
    final asyncCountries = ref.watch(countriesFutureProvider);
    final asyncGovs = ref.watch(governoratesFutureProvider);
    final asyncCities = ref.watch(citiesFutureProvider);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: asyncCountries.when(
                data: (list) => _buildDropdown('COUNTRY', _selectedCountryId, list, (v) => setState(() {
                  _selectedCountryId = v;
                  _selectedGovId = null;
                  _selectedCityId = null;
                })),
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('Error'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: asyncGovs.when(
                data: (list) {
                  final filtered = list.where((g) => g['country_id'] == _selectedCountryId).toList();
                  return _buildDropdown('GOVERNORATE', _selectedGovId, filtered, (v) => setState(() {
                    _selectedGovId = v;
                    _selectedCityId = null;
                  }));
                },
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('Error'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        asyncCities.when(
          data: (list) {
            final filtered = list.where((c) => c['governorate_id'] == _selectedGovId).toList();
            return _buildDropdown('CITY', _selectedCityId, filtered, (v) => setState(() => _selectedCityId = v));
          },
          loading: () => const LinearProgressIndicator(),
          error: (_, __) => const Text('Error'),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String? value, List<Map<String, dynamic>> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white24)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: items.any((i) => i['id'] == value) ? value : null,
          dropdownColor: const Color(0xFF061226),
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            fillColor: Colors.white.withOpacity(0.02),
          ),
          items: items.map((i) => DropdownMenuItem(value: i['id'].toString(), child: Text(i['name_en'] ?? 'Unnamed'))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
      child: Row(
        children: [
          Icon(LucideIcons.user, color: EspyTheme.gold),
          const SizedBox(width: 16),
          Text(
            'MODIFY IDENTITY: ${widget.user.id.length > 8 ? widget.user.id.substring(0, 8) : widget.user.id}',
            style: EspyTheme.cinzelStyle.copyWith(fontSize: 14, color: Colors.white),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(LucideIcons.x, color: Colors.white24),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: EspyTheme.cinzelStyle.copyWith(fontSize: 10, color: EspyTheme.gold, letterSpacing: 2),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white24)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            fillColor: Colors.white.withOpacity(0.02),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ACTIVE VISIBILITY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text('Determines if PIN is searchable in network', style: TextStyle(color: Colors.white24, fontSize: 11)),
            ],
          ),
          Switch(
            value: _isActive,
            activeColor: Colors.green,
            onChanged: (v) => setState(() => _isActive = v),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ABORT'),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: _isSaving ? null : _save,
            icon: _isSaving ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2)) : Icon(LucideIcons.save, size: 16),
            label: const Text('COMMIT CHANGES'),
            style: ElevatedButton.styleFrom(
              backgroundColor: EspyTheme.electricBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            ),
          ),
        ],
      ),
    );
  }
}
