import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../services/auth_service.dart';

class AdminSidebar extends ConsumerWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;
    final user = ref.watch(authStateProvider).value;

    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: Color(0xFF061226),
        border: Border(right: BorderSide(color: Colors.white10)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildNavItem(context, 'OVERVIEW', LucideIcons.layoutDashboard, '/', location == '/'),
                _buildSectionHeader('DIRECTORY'),
                _buildNavItem(context, 'REGISTRY', LucideIcons.users, '/registry', location == '/registry'),
                _buildSectionHeader('FISCAL'),
                _buildNavItem(context, 'FINANCE', LucideIcons.trendingUp, '/finance', location == '/finance'),
                _buildSectionHeader('COMMUNICATIONS'),
                _buildNavItem(context, 'SIGNAL HUB', LucideIcons.globe, '/comms', location == '/comms'),
                _buildSectionHeader('INFRASTRUCTURE'),
                _buildNavItem(context, 'SYSTEM', LucideIcons.database, '/system', location == '/system'),
                _buildNavItem(context, 'SOS COMMAND', LucideIcons.phoneCall, '/sos', location == '/sos'),
              ],
            ),
          ),
          _buildFooter(context, ref, user),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: EspyTheme.electricBlue,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(color: EspyTheme.electricBlue.withOpacity(0.4), blurRadius: 20)
              ],
            ),
            child: const Center(child: Text('E', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20))),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ESPY', style: EspyTheme.cinzelStyle.copyWith(fontSize: 14, color: Colors.white, letterSpacing: 4)),
              Text('BLUE FLAME', style: EspyTheme.cinzelStyle.copyWith(fontSize: 8, color: EspyTheme.cyan, letterSpacing: 2)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Text(
        title,
        style: EspyTheme.cinzelStyle.copyWith(fontSize: 9, color: Colors.white24, letterSpacing: 2),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String label, IconData icon, String path, bool active) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.go(path),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            border: active ? const Border(left: BorderSide(color: EspyTheme.electricBlue, width: 4)) : null,
            gradient: active ? LinearGradient(colors: [EspyTheme.electricBlue.withOpacity(0.1), Colors.transparent]) : null,
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: active ? EspyTheme.electricBlue : Colors.white54),
              const SizedBox(width: 16),
              Text(
                label,
                style: EspyTheme.cinzelStyle.copyWith(
                  fontSize: 11,
                  color: active ? Colors.white : Colors.white54,
                  fontWeight: active ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, WidgetRef ref, dynamic user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05)))),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white10,
            backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
            child: user?.photoURL == null ? Icon(LucideIcons.user, size: 16, color: Colors.white54) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user?.displayName?.split(' ').first.toUpperCase() ?? 'ADMIN', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                const Text('Governance Mode', style: TextStyle(color: Colors.white38, fontSize: 9)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => ref.read(authServiceProvider).signOut(),
            icon: Icon(LucideIcons.logOut, size: 16, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}
