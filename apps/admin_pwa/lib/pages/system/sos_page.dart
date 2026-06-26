import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../services/firestore_service.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SOSPage extends ConsumerStatefulWidget {
  const SOSPage({super.key});

  @override
  ConsumerState<SOSPage> createState() => _SOSPageState();
}

class _SOSPageState extends ConsumerState<SOSPage> {
  @override
  Widget build(BuildContext context) {
    final asyncSections = ref.watch(emergencySectionsStreamProvider);

    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          Expanded(
            child: asyncSections.when(
              data: (sections) => _buildSectionsList(sections),
              loading: () => const Center(child: CircularProgressIndicator(color: EspyTheme.electricBlue)),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SOS EMERGENCY COMMAND',
              style: EspyTheme.cinzelStyle.copyWith(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Configure baseline emergency lines and agency contacts',
              style: EspyTheme.loraStyle.copyWith(fontSize: 14, color: Colors.white38),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _addSection(),
          icon: Icon(LucideIcons.plus, size: 16),
          label: const Text('ADD NEW CATEGORY'),
          style: ElevatedButton.styleFrom(
            backgroundColor: EspyTheme.electricBlue.withOpacity(0.1),
            foregroundColor: EspyTheme.electricBlue,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            side: const BorderSide(color: EspyTheme.electricBlue),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionsList(List<Map<String, dynamic>> sections) {
    if (sections.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.phoneOff, size: 64, color: Colors.white10),
            const SizedBox(height: 16),
            Text('NO EMERGENCY CHANNELS CONFIGURED', style: EspyTheme.cinzelStyle.copyWith(color: Colors.white24)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: sections.length,
      itemBuilder: (context, i) {
        final section = sections[i];
        return _buildSectionCard(section, i, sections);
      },
    );
  }

  Widget _buildSectionCard(Map<String, dynamic> section, int index, List<Map<String, dynamic>> allSections) {
    final List numbers = section['numbers'] ?? [];

    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    (section['name_en'] ?? 'UNTITLED CATEGORY').toUpperCase(),
                    style: EspyTheme.cinzelStyle.copyWith(fontSize: 12, color: EspyTheme.gold),
                  ),
                ),
                IconButton(
                  icon: Icon(LucideIcons.edit, size: 16, color: Colors.white24),
                  onPressed: () => _editSection(section, index, allSections),
                ),
                IconButton(
                  icon: Icon(LucideIcons.trash2, size: 16, color: Colors.redAccent),
                  onPressed: () => _deleteSection(index, allSections),
                ),
              ],
            ),
            Divider(color: Colors.white.withOpacity(0.05), height: 32),
            ...numbers.asMap().entries.map((e) {
              final nIdx = e.key;
              final n = Map<String, dynamic>.from(e.value);
              return _buildNumberRow(n, nIdx, index, allSections);
            }),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => _addNumber(index, allSections),
              icon: Icon(LucideIcons.plus, size: 14),
              label: const Text('ADD AGENCY LINE', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberRow(Map<String, dynamic> number, int nIdx, int sIdx, List<Map<String, dynamic>> allSections) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(LucideIcons.phone, size: 14, color: EspyTheme.cyan),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(number['label_en'] ?? 'Agency', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(number['number'] ?? '—', style: const TextStyle(color: Colors.white38, fontSize: 11)),
                ],
              ),
            ),
            IconButton(
              icon: Icon(LucideIcons.edit, size: 14, color: Colors.white24),
              onPressed: () => _editNumber(number, nIdx, sIdx, allSections),
            ),
            IconButton(
              icon: Icon(LucideIcons.trash2, size: 14, color: Colors.redAccent.withOpacity(0.5)),
              onPressed: () => _deleteNumber(nIdx, sIdx, allSections),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addSection() async {
    final TextEditingController nameEn = TextEditingController();
    final TextEditingController nameAr = TextEditingController();

    final result = await _showEditDialog('INITIALIZE CATEGORY', nameEn, nameAr);
    if (result == true) {
      final asyncSections = ref.read(emergencySectionsStreamProvider);
      final current = List<Map<String, dynamic>>.from(asyncSections.value ?? []);
      current.add({
        'name_en': nameEn.text,
        'name_ar': nameAr.text,
        'numbers': [],
      });
      await _saveSections(current);
    }
  }

  Future<void> _editSection(Map<String, dynamic> section, int index, List<Map<String, dynamic>> allSections) async {
    final TextEditingController nameEn = TextEditingController(text: section['name_en']);
    final TextEditingController nameAr = TextEditingController(text: section['name_ar']);

    final result = await _showEditDialog('MODIFY CATEGORY', nameEn, nameAr);
    if (result == true) {
      final current = List<Map<String, dynamic>>.from(allSections);
      current[index] = {
        ...current[index],
        'name_en': nameEn.text,
        'name_ar': nameAr.text,
      };
      await _saveSections(current);
    }
  }

  Future<void> _deleteSection(int index, List<Map<String, dynamic>> allSections) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF061226),
        title: const Text('PURGE CATEGORY'),
        content: const Text('Are you sure? All numbers in this category will be lost.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('CANCEL')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent), child: const Text('DELETE')),
        ],
      ),
    );

    if (confirm == true) {
      final current = List<Map<String, dynamic>>.from(allSections);
      current.removeAt(index);
      await _saveSections(current);
    }
  }

  Future<void> _addNumber(int sIdx, List<Map<String, dynamic>> allSections) async {
    final TextEditingController labelEn = TextEditingController();
    final TextEditingController labelAr = TextEditingController();
    final TextEditingController number = TextEditingController();

    final result = await _showNumberDialog('DEPLOY AGENCY LINE', labelEn, labelAr, number);
    if (result == true) {
      final current = List<Map<String, dynamic>>.from(allSections);
      final List numbers = List.from(current[sIdx]['numbers'] ?? []);
      numbers.add({
        'label_en': labelEn.text,
        'label_ar': labelAr.text,
        'number': number.text,
      });
      current[sIdx]['numbers'] = numbers;
      await _saveSections(current);
    }
  }

  Future<void> _editNumber(Map<String, dynamic> n, int nIdx, int sIdx, List<Map<String, dynamic>> allSections) async {
    final TextEditingController labelEn = TextEditingController(text: n['label_en']);
    final TextEditingController labelAr = TextEditingController(text: n['label_ar']);
    final TextEditingController number = TextEditingController(text: n['number']);

    final result = await _showNumberDialog('MODIFY AGENCY LINE', labelEn, labelAr, number);
    if (result == true) {
      final current = List<Map<String, dynamic>>.from(allSections);
      final List numbers = List.from(current[sIdx]['numbers'] ?? []);
      numbers[nIdx] = {
        'label_en': labelEn.text,
        'label_ar': labelAr.text,
        'number': number.text,
      };
      current[sIdx]['numbers'] = numbers;
      await _saveSections(current);
    }
  }

  Future<void> _deleteNumber(int nIdx, int sIdx, List<Map<String, dynamic>> allSections) async {
    final current = List<Map<String, dynamic>>.from(allSections);
    final List numbers = List.from(current[sIdx]['numbers'] ?? []);
    numbers.removeAt(nIdx);
    current[sIdx]['numbers'] = numbers;
    await _saveSections(current);
  }

  Future<bool?> _showEditDialog(String title, TextEditingController en, TextEditingController ar) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF061226),
        title: Text(title, style: EspyTheme.cinzelStyle.copyWith(fontSize: 14)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: en, decoration: const InputDecoration(labelText: 'NAME (EN)')),
            const SizedBox(height: 16),
            TextField(controller: ar, textAlign: TextAlign.right, decoration: const InputDecoration(labelText: 'الاسم (العربية)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('CANCEL')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('SAVE')),
        ],
      ),
    );
  }

  Future<bool?> _showNumberDialog(String title, TextEditingController en, TextEditingController ar, TextEditingController num) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF061226),
        title: Text(title, style: EspyTheme.cinzelStyle.copyWith(fontSize: 14)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: en, decoration: const InputDecoration(labelText: 'AGENCY LABEL (EN)')),
            const SizedBox(height: 16),
            TextField(controller: ar, textAlign: TextAlign.right, decoration: const InputDecoration(labelText: 'الاسم (العربية)')),
            const SizedBox(height: 16),
            TextField(controller: num, decoration: const InputDecoration(labelText: 'EMERGENCY NUMBER')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('CANCEL')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('SAVE')),
        ],
      ),
    );
  }

  Future<void> _saveSections(List<Map<String, dynamic>> data) async {
    try {
      await ref.read(firestoreServiceProvider).updateEmergencySections(data);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ecosystem SOS Baselined')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
    }
  }
}

final emergencySectionsStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(firestoreServiceProvider).watchEmergencySections();
});
