import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../services/firestore_service.dart';

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
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    final fields = _getFieldsForCollection(widget.collection);
    for (var field in fields) {
      _controllers[field] = TextEditingController(text: widget.item?[field]?.toString() ?? '');
    }
  }

  List<String> _getFieldsForCollection(String col) {
    switch (col) {
      case 'directory_countries':
        return ['name_en', 'name_ar', 'code', 'currency', 'phone_code'];
      case 'directory_governorates':
        return ['name_en', 'name_ar', 'country_id'];
      case 'directory_cities':
        return ['name_en', 'name_ar', 'governorate_id', 'country_id'];
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
              ...fields.map((field) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildTextField(field.replaceAll('_', ' ').toUpperCase(), _controllers[field]!, isRtl: field.contains('_ar')),
              )).toList(),
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
}
