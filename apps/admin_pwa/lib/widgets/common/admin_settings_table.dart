import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'admin_edit_master_modal.dart';
import '../../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
    if (data.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: Text('NO DATA AVAILABLE', style: TextStyle(color: Colors.white24, fontSize: 10))),
      );
    }

    // Deduplicate data by ID to prevent crash
    final uniqueData = <Map<String, dynamic>>[];
    final ids = <String>{};
    for (var item in data) {
      if (ids.add(item['id']?.toString() ?? '')) {
        uniqueData.add(item);
      }
    }

    return SizedBox(
      width: double.infinity,
      child: DataTable(
        headingTextStyle: EspyTheme.cinzelStyle.copyWith(fontSize: 9, color: Colors.white24),
        dataTextStyle: EspyTheme.loraStyle.copyWith(fontSize: 13, color: Colors.white70),
        columns: [
          const DataColumn(label: Text('SYSTEM ID')),
          ...columns.map((c) => DataColumn(label: Text(c.toUpperCase()))),
          const DataColumn(label: Text('ACTIONS')),
        ],
        rows: uniqueData.map((item) {
          try {
            return _buildRow(context, ref, item);
          } catch (e) {
            return DataRow(cells: [
              const DataCell(Text('ERR')),
              ...columns.map((_) => const DataCell(Text('ERR'))),
              DataCell(Text(e.toString().substring(0, 10))),
            ]);
          }
        }).toList(),
      ),
    );
  }

  DataRow _buildRow(BuildContext context, WidgetRef ref, Map<String, dynamic> item) {
    return DataRow(
      key: ValueKey(item['id'] ?? DateTime.now().toString()),
      cells: [
        DataCell(Text(item['id']?.toString() ?? '—', style: const TextStyle(fontSize: 9, color: EspyTheme.gold))),
        ...columns.map((c) {
          final key = c.toLowerCase().replaceAll(' ', '_');
          var value = item[key];
          if (value is Timestamp) {
            value = DateFormat('dd MMM yyyy').format(value.toDate());
          }
          return DataCell(
            SizedBox(
              width: 150,
              child: Text(
                value?.toString() ?? '—',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
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
