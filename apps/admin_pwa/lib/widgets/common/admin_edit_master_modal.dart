import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../services/firestore_service.dart';
import '../../pages/system/system_page.dart';

class AdminEditMasterModal extends ConsumerStatefulWidget {
  final String collection;
  final Map<String, dynamic>? item;
  final String title;

  const AdminEditMasterModal({
    super.key,
    required this.collection,
    this.item,
    required this.title,
  });

  @override
  ConsumerState<AdminEditMasterModal> createState() => _AdminEditMasterModalState();
}

class _AdminEditMasterModalState extends ConsumerState<AdminEditMasterModal> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String?> _selectedIds = {};
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    final fields = _getFieldsForCollection(widget.collection);
    for (var field in fields) {
      if (field.endsWith('_id')) {
        _selectedIds[field] = widget.item?[field]?.toString();
      } else {
        _controllers[field] = TextEditingController(text: widget.item?[field]?.toString() ?? '');
      }
    }
  }

  List<String> _getFieldsForCollection(String col) {
    switch (col) {
      case 'directory_countries':
        return ['name_en', 'name_ar', 'code', 'currency', 'phone_code'];
      case 'directory_governorates':
        return ['name_en', 'name_ar', 'country_id'];
      case 'directory_cities':
        return ['name_en', 'name_ar', 'country_id', 'governorate_id'];
      case 'emergency_hotlines':
        return ['label_en', 'label_ar', 'number', 'country_id'];
      default:
        return ['name_en', 'name_ar'];
    }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final data = <String, dynamic>{'isActive': true};
      _controllers.forEach((key, ctrl) {
        data[key] = ctrl.text;
      });
      _selectedIds.forEach((key, val) {
        data[key] = val;
      });
      
      final id = widget.item?['id'] ?? DateTime.now().millisecondsSinceEpoch.toString();
      await ref.read(firestoreServiceProvider).updateItem(widget.collection, id, data);
      
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fields = _getFieldsForCollection(widget.collection);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF061226),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title.toUpperCase(), style: EspyTheme.cinzelStyle.copyWith(fontSize: 14, color: Colors.white)),
              const SizedBox(height: 24),
              ...fields.map((field) {
                if (field.endsWith('_id')) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildIdSelector(field),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildTextField(field.replaceAll('_', ' ').toUpperCase(), _controllers[field]!, isRtl: field.contains('_ar')),
                );
              }).toList(),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    style: ElevatedButton.styleFrom(backgroundColor: EspyTheme.electricBlue, foregroundColor: Colors.white),
                    child: _isSaving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('SAVE ANCHOR'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, {bool isRtl = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white24)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          textAlign: isRtl ? TextAlign.right : TextAlign.left,
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
        ),
      ],
    );
  }

  Widget _buildIdSelector(String field) {
    final label = field.replaceAll('_id', '').toUpperCase();
    AsyncValue<List<Map<String, dynamic>>> provider;

    if (field == 'country_id') {
      provider = ref.watch(countriesFutureProvider);
    } else if (field == 'governorate_id') {
      // For city, we might want to filter governorates by selected country
      final countryId = _selectedIds['country_id'];
      if (countryId == null) {
        return Text('Select Country first', style: TextStyle(color: Colors.redAccent, fontSize: 10));
      }
      provider = ref.watch(governoratesFutureProvider); // Ideally filtered, but let's see
    } else {
      return Text('Unknown ID field: $field');
    }

    return provider.when(
      data: (items) {
        // Filter governorates by country if needed
        var filteredItems = items;
        if (field == 'governorate_id' && _selectedIds['country_id'] != null) {
          filteredItems = items.where((i) => i['country_id'] == _selectedIds['country_id']).toList();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white24)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedIds[field],
              dropdownColor: const Color(0xFF061226),
              style: const TextStyle(color: Colors.white, fontSize: 12),
              items: filteredItems.map((i) => DropdownMenuItem(
                value: i['id'].toString(),
                child: Text(i['name_en'] ?? i['label_en'] ?? 'Unnamed'),
              )).toList(),
              onChanged: (v) {
                setState(() {
                  _selectedIds[field] = v;
                  if (field == 'country_id') {
                    _selectedIds['governorate_id'] = null; // Reset governorate when country changes
                  }
                });
              },
              decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16)),
            ),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, s) => Text('Error loading $label'),
    );
  }
}
