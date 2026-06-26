import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'admin_sidebar.dart';
import '../../core/theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import 'dart:async';

class AdminShell extends ConsumerStatefulWidget {
  final Widget child;
  const AdminShell({super.key, required this.child});

  @override
  ConsumerState<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends ConsumerState<AdminShell> {
  StreamSubscription? _notifSubscription;

  @override
  void initState() {
    super.initState();
    // We delay the listener to ensure Auth state is stable and provider is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initNotificationListener();
    });
  }

  @override
  void dispose() {
    _notifSubscription?.cancel();
    super.dispose();
  }

  void _initNotificationListener() async {
    final isAdmin = await ref.read(isAdminProvider.future);
    if (!isAdmin) return;

    _notifSubscription = FirebaseFirestore.instance
        .collection('directory_notifications')
        .where('target', isEqualTo: 'admin')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .listen((snap) {
          if (!mounted) return;
          for (var change in snap.docChanges) {
            if (change.type == DocumentChangeType.added) {
              final data = change.doc.data();
              if (data != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: EspyTheme.electricBlue,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(20),
                    content: Text('GOVERNANCE ALERT: ${data['title']}'),
                    action: SnackBarAction(
                      label: 'ACKNOWLEDGE',
                      textColor: Colors.white,
                      onPressed: () {
                        change.doc.reference.update({'isRead': true}).catchError((e) {
                          debugPrint('Failed to mark as read: $e');
                        });
                      },
                    ),
                  ),
                );
              }
            }
          }
        }, onError: (e) {
          debugPrint('Governance Listener Error: $e');
          // Silently fail to avoid crashing the UI if it's just a permission issue on startup
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const AdminSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.topCenter,
                        radius: 1.2,
                        colors: [
                          EspyTheme.electricBlue.withOpacity(0.03),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: const Color(0xFF0A192F),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.search, size: 18, color: Colors.white24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'SEARCH PROTOCOLS...',
              style: EspyTheme.cinzelStyle.copyWith(fontSize: 10, color: Colors.white24, letterSpacing: 2),
            ),
          ),
          _buildHeaderAction(LucideIcons.bell),
          const SizedBox(width: 16),
          _buildHeaderAction(LucideIcons.settings),
        ],
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Icon(icon, size: 18, color: Colors.white54),
    );
  }
}
