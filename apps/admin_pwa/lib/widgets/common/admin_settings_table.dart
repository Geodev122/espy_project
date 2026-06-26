import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'admin_edit_master_modal.dart';
import '../../services/firestore_service.dart';

class AdminSettingsTable extends ConsumerWidget {
  final String title;
  final String collection;
  final List<String> columns;
  final List<Map<String, dynamic>> data;

  const AdminSettingsTable({
    super.key,
    required this.title,
    required this.collection,
    required this.columns,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          _buildTable(context, ref),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title.toUpperCase(), style: EspyTheme.cinzelStyle.copyWith(fontSize: 11, color: EspyTheme.gold)),
          IconButton(
            onPressed: () => showDialog(context: context, builder: (_) => AdminEditMasterModal(collection: collection, title: 'NEW $title')),
            icon: _buildIconButton(LucideIcons.plus, EspyTheme.electricBlue.withOpacity(0.1), EspyTheme.electricBlue),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: DataTable(
        headingTextStyle: EspyTheme.cinzelStyle.copyWith(fontSize: 9, color: Colors.white24),
        dataTextStyle: EspyTheme.loraStyle.copyWith(fontSize: 13, color: Colors.white70),
        columns: [
          ...columns.map((c) => DataColumn(label: Text(c.toUpperCase()))),
          const DataColumn(label: Text('ACTIONS')),
        ],
        rows: data.map((item) => _buildRow(context, ref, item)).toList(),
      ),
    );
  }

  DataRow _buildRow(BuildContext context, WidgetRef ref, Map<String, dynamic> item) {
    return DataRow(
      cells: [
        ...columns.map((c) {
          final key = c.toLowerCase().replaceAll(' ', '_');
          return DataCell(Text(item[key]?.toString() ?? '—'));
        }),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: Icon(LucideIcons.edit, size: 14, color: Colors.white24),
                onPressed: () => showDialog(context: context, builder: (_) => AdminEditMasterModal(collection: collection, item: item, title: 'EDIT $title')),
              ),
              IconButton(
                icon: Icon(LucideIcons.trash2, size: 14, color: Colors.redAccent),
                onPressed: () => _delete(context, ref, item['id']),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF061226),
        title: const Text('CONFIRM DELETE'),
        content: const Text('Permanently remove this master data entry?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('CANCEL')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent), child: const Text('DELETE')),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(firestoreServiceProvider).deleteItem(collection, id);
    }
  }

  Widget _buildIconButton(IconData icon, Color bg, Color iconColor) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, size: 14, color: iconColor),
    );
  }
}
