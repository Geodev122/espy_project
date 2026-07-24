import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:espy_core/espy_core.dart';
import 'package:espy_app/theme/espy_theme.dart';

import '../admin/dashboard_screen.dart';
import 'community/community_feed_screen.dart';
import 'map/map_explore_screen.dart';
import '../../widgets/common/espy_side_menu.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool get isAr => Localizations.localeOf(context).languageCode == 'ar';

  List<Widget> _getScreens() {
    return [
      const AdminDashboardScreen(),
      const MapExploreScreen(),
      const CommunityFeedScreen(),
    ];
  }

  List<NavItem> _getNavItems() {
    return [
      NavItem(index: 0, icon: Icons.admin_panel_settings_rounded, label: 'ADMIN'),
      NavItem(index: 1, icon: Icons.map_rounded, label: 'EXPLORE'),
      NavItem(index: 2, icon: Icons.campaign_rounded, label: 'COMMUNITY'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final user = auth.userData;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: EspyTheme.gold)));
    }

    final screens = _getScreens();
    final items = _getNavItems();

    return Scaffold(
      key: _scaffoldKey,
      drawer: const EspySideMenu(),
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: _buildCustomHeader(context, user),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: _buildBottomNavLayer(items),
    );
  }

  Widget _buildBottomNavLayer(List<NavItem> items) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 12, left: 24, right: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: EspyTheme.navyDeep.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white10),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: items.map((item) => _buildNavItemWidget(item)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItemWidget(NavItem item) {
    bool isActive = _selectedIndex == item.index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = item.index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.icon, color: isActive ? EspyTheme.gold : Colors.white38, size: 20),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: GoogleFonts.cinzel(fontSize: 7, fontWeight: FontWeight.w900, color: isActive ? EspyTheme.gold : Colors.white38, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context, UserModel user) {
    final localeService = Provider.of<LocaleService>(context);
    final items = _getNavItems();
    final currentLabel = items[_selectedIndex].label;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 10, 20, 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        border: Border(bottom: BorderSide(color: Colors.black.withValues(alpha: 0.05))),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: EspyTheme.platinum,
              child: const Icon(Icons.person_rounded, color: EspyTheme.royalBlue, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentLabel, style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.2, color: EspyTheme.navyDeep)),
                Text(user.name.toUpperCase(), style: GoogleFonts.montserrat(fontSize: 8, fontWeight: FontWeight.w700, color: EspyTheme.gold)),
              ],
            ),
          ),
          _buildLocaleToggle(localeService),
        ],
      ),
    );
  }

  Widget _buildLocaleToggle(LocaleService localeService) {
    return InkWell(
      onTap: () => localeService.toggleLocale(),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: EspyTheme.gold.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          localeService.locale.languageCode.toUpperCase(),
          style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.w900, color: EspyTheme.gold),
        ),
      ),
    );
  }
}

class NavItem {
  final int index;
  final IconData icon;
  final String label;
  NavItem({required this.index, required this.icon, required this.label});
}
