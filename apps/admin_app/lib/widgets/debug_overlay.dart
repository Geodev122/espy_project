import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../viewmodels/debug_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DebugOverlay extends StatefulWidget {
  final Widget child;
  const DebugOverlay({super.key, required this.child});

  @override
  State<DebugOverlay> createState() => _DebugOverlayState();
}

class _DebugOverlayState extends State<DebugOverlay> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (kDebugMode)
          Positioned(
            right: 10,
            bottom: 100,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.redAccent.withValues(alpha: 0.5),
              onPressed: () => setState(() => _isVisible = !_isVisible),
              child: const Icon(Icons.bug_report, size: 20),
            ),
          ),
        if (_isVisible)
          Material(
            color: Colors.black.withValues(alpha: 0.85),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(child: _buildLogList()),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('SYNC DEBUG CONSOLE', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, letterSpacing: 2)),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.delete_sweep, color: Colors.white54),
                onPressed: () => DebugService().clear(),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => setState(() => _isVisible = false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogList() {
    return Consumer<DebugService>(
      builder: (context, debug, _) {
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: debug.logs.length,
          separatorBuilder: (_, __) => const Divider(color: Colors.white10),
          itemBuilder: (context, index) {
            final log = debug.logs[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      DateFormat('HH:mm:ss').format(log.timestamp),
                      style: const TextStyle(color: Colors.white38, fontSize: 10, fontFamily: 'monospace'),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(color: _getCategoryColor(log.category), borderRadius: BorderRadius.circular(4)),
                      child: Text(log.category, style: const TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(log.message, style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'monospace')),
                if (log.data != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      log.data.toString(),
                      style: const TextStyle(color: Colors.green, fontSize: 11, fontFamily: 'monospace'),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Color _getCategoryColor(String cat) {
    if (cat.contains('AUTH')) return Colors.blueAccent;
    if (cat.contains('FIRESTORE')) return Colors.orangeAccent;
    if (cat.contains('WHISH')) return Colors.purpleAccent;
    return Colors.grey;
  }
}
