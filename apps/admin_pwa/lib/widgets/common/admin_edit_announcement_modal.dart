import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../services/firestore_service.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminEditAnnouncementModal extends ConsumerStatefulWidget {
  final Map<String, dynamic>? announcement;
  const AdminEditAnnouncementModal({super.key, this.announcement});

  @override
  ConsumerState<AdminEditAnnouncementModal> createState() => _AdminEditAnnouncementModalState();
}

class _AdminEditAnnouncementModalState extends ConsumerState<AdminEditAnnouncementModal> {
  late TextEditingController _titleCtrl;
  late TextEditingController _detailsCtrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.announcement?['title'] ?? '');
    _detailsCtrl = TextEditingController(text: widget.announcement?['details'] ?? '');
  }

  Future<void> _save() async {
    if (_titleCtrl.text.isEmpty) return;

    setState(() => _isSaving = true);
    try {
      final data = {
        'title': _titleCtrl.text,
        'details': _detailsCtrl.text,
        'status': widget.announcement?['status'] ?? 'pending',
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      final firestore = ref.read(firestoreServiceProvider);
      if (widget.announcement == null) {
        await firestore.updateItem('directory_announcements', DateTime.now().millisecondsSinceEpoch.toString(), {
          ...data,
          'created_at': FieldValue.serverTimestamp(),
        });
      } else {
        await firestore.updateItem('directory_announcements', widget.announcement!['id'], data);
      }
      
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF061226),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.announcement == null ? 'DRAFT NETWORK LOG' : 'MODIFY ANNOUNCEMENT',
              style: EspyTheme.cinzelStyle.copyWith(fontSize: 14, color: Colors.white),
            ),
            const SizedBox(height: 24),
            _buildTextField('HEADLINE', _titleCtrl),
            const SizedBox(height: 20),
            _buildTextField('CONTENT / DETAILS', _detailsCtrl, maxLines: 5),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('ABORT')),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _isSaving ? null : _save,
                  icon: _isSaving ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2)) : Icon(LucideIcons.save, size: 16),
                  label: const Text('COMMIT LOG'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EspyTheme.electricBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
          decoration: const InputDecoration(contentPadding: EdgeInsets.all(16)),
        ),
      ],
    );
  }
}
