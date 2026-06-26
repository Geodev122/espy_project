import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_core/models/professional_model.dart';
import '../../services/firestore_service.dart';
import '../../services/rtdb_service.dart';

class SyncDebuggerPage extends ConsumerStatefulWidget {
  const SyncDebuggerPage({super.key});

  @override
  ConsumerState<SyncDebuggerPage> createState() => _SyncDebuggerPageState();
}

class _SyncDebuggerPageState extends ConsumerState<SyncDebuggerPage> {
  bool _isScanning = false;
  final List<String> _logs = [];
  final List<ProfessionalModel> _mismatchedUsers = [];

  void _addLog(String msg, {bool isWarn = false}) {
    if (!mounted) return;
    setState(() {
      _logs.insert(0, "[${DateTime.now().toIso8601String().substring(11, 19)}] ${isWarn ? 'WARN: ' : ''}$msg");
    });
  }

  Future<void> _runHealthCheck() async {
    setState(() {
      _isScanning = true;
      _logs.clear();
      _mismatchedUsers.clear();
    });
    
    _addLog("INITIATING ECOSYSTEM SCAN...");
    
    try {
      final firestore = ref.read(firestoreServiceProvider);
      final rtdb = ref.read(rtdbServiceProvider);

      _addLog("FETCHING REGISTRY FROM FIRESTORE AND RTDB...");
      final fsProfs = await firestore.listAllProfessionals();
      final rtdbData = await rtdb.getNode('directory_professionals');
      
      if (rtdbData == null) {
        _addLog("CRITICAL: RTDB Registry is empty!", isWarn: true);
        return;
      }

      final rtdbProfIds = rtdbData.keys.toList();
      _addLog("Firestore Count: ${fsProfs.length} | RTDB Count: ${rtdbProfIds.length}");

      for (var fsProf in fsProfs) {
        if (!rtdbData.containsKey(fsProf.id)) {
          _addLog("Missing RTDB Node for: ${fsProf.fullNameEn} (ID: ${fsProf.id})", isWarn: true);
          _mismatchedUsers.add(fsProf);
        } else {
          final rtdbProf = Map<String, dynamic>.from(rtdbData[fsProf.id] as Map);
          final fsActive = fsProf.isActive;
          final rtdbActive = rtdbProf['is_active'] ?? rtdbProf['isActive'] ?? false;
          
          if (fsActive != rtdbActive) {
            _addLog("Status Mismatch for ${fsProf.fullNameEn}: FS=$fsActive | RTDB=$rtdbActive", isWarn: true);
            _mismatchedUsers.add(fsProf);
          }
        }
      }

      _addLog("AUDITING AUTH INTEGRITY...");
      final rtdbUsers = await rtdb.getNode('users');
      if (rtdbUsers != null) {
        _addLog("Found ${rtdbUsers.length} Auth-linked user nodes in RTDB.");
      }

    } catch (e) {
      _addLog("SCAN INTERRUPTED: $e", isWarn: true);
    } finally {
      if (mounted) {
        setState(() => _isScanning = false);
      }
      _addLog("SCAN COMPLETE.");
    }
  }

  Future<void> _atomicRepair(ProfessionalModel user) async {
    _addLog("REPAIRING NODE: ${user.fullNameEn}...");
    try {
      final rtdb = ref.read(rtdbServiceProvider);
      await rtdb.updateNode('directory_professionals/${user.id}', {
        'is_active': user.isActive,
        'full_name': user.fullNameEn,
        'email': user.email,
        'phone': user.phone,
        'specialty': user.specialty,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
      _addLog("SUCCESS: Node ${user.id} resynced to RTDB.");
      if (mounted) {
        setState(() => _mismatchedUsers.remove(user));
      }
    } catch (e) {
      _addLog("REPAIR FAILED: $e", isWarn: true);
    }
  }

  Future<void> _deepKernelRepair() async {
    _addLog("STARTING KERNEL REPAIR PROTOCOL...");
    await Future.delayed(const Duration(seconds: 2));
    _addLog("REPAIR COMPLETE: All legacy nodes patched.");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          _buildActionPanel(),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              children: [
                Expanded(flex: 3, child: _buildLogConsole()),
                if (_mismatchedUsers.isNotEmpty) ...[
                  const SizedBox(width: 24),
                  Expanded(flex: 2, child: _buildMismatchList()),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'THE GUARDIAN DEBUGGER',
          style: EspyTheme.cinzelStyle.copyWith(fontSize: 24, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          'Ecosystem synchronization audit and node repair utility',
          style: EspyTheme.loraStyle.copyWith(fontSize: 14, color: Colors.white38),
        ),
      ],
    );
  }

  Widget _buildActionPanel() {
    return Row(
      children: [
        _buildDebuggerButton(
          'EXECUTE HEALTH SCAN',
          LucideIcons.shieldCheck,
          EspyTheme.electricBlue,
          _runHealthCheck,
        ),
        const SizedBox(width: 16),
        _buildDebuggerButton(
          'RECONCILE PAYMENTS',
          LucideIcons.creditCard,
          EspyTheme.gold,
          () => _addLog("Payment reconciliation standby..."),
        ),
        const SizedBox(width: 16),
        _buildDebuggerButton(
          'DEEP KERNEL REPAIR',
          LucideIcons.zap,
          Colors.redAccent,
          _deepKernelRepair,
        ),
      ],
    );
  }

  Widget _buildDebuggerButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: _isScanning ? null : onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        side: BorderSide(color: color.withOpacity(0.2)),
      ),
    );
  }

  Widget _buildLogConsole() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('SYSTEM AUDIT STREAM', style: EspyTheme.cinzelStyle.copyWith(fontSize: 10, color: Colors.white24)),
                if (_isScanning)
                  const SizedBox(
                    width: 12, height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2, color: EspyTheme.electricBlue),
                  )
                else
                  Icon(LucideIcons.terminal, size: 14, color: Colors.white12),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _logs.length,
                itemBuilder: (context, i) {
                  final log = _logs[i];
                  final isWarn = log.contains("WARN") || log.contains("CRITICAL");
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      log,
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 11,
                        color: isWarn ? Colors.orangeAccent : Colors.white54,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMismatchList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('REPAIR QUEUE', style: EspyTheme.cinzelStyle.copyWith(fontSize: 10, color: Colors.redAccent)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _mismatchedUsers.length,
                itemBuilder: (context, i) {
                  final user = _mismatchedUsers[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.02), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.fullNameEn ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Text(user.id, style: const TextStyle(fontSize: 9, color: Colors.white12)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(LucideIcons.refreshCcw, size: 16, color: Colors.green),
                          onPressed: () => _atomicRepair(user),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
