import 'dart:async';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/viewmodels/auth_service.dart';
import 'package:espy_app/viewmodels/sound_service.dart';
import 'package:espy_app/viewmodels/locale_service.dart';
import 'package:espy_app/models/user_model.dart';

import '../professional/home/dashboard_screen.dart';
import '../professional/matching/matching_screen.dart';
import '../professional/matching/swipe_requests_screen.dart';
import 'community/community_feed_screen.dart';
import 'community/announcements_screen.dart';
import '../professional/profile/notifications_screen.dart';
import 'map/map_explore_screen.dart';
import '../professional/services/service_manager_screen.dart';
import '../visitor/emergency/sos_hub_screen.dart';
import '../../widgets/common/espy_side_menu.dart';

import 'package:espy_app/l10n/app_localizations.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> _getScreens(UserRole role) {
    if (role == UserRole.visitor) {
      return [
        const MapExploreScreen(),
        const MatchingScreen(),
        const CommunityFeedScreen(),
      ];
    }
    return [
      const DashboardScreen(),
      const MapExploreScreen(),
      const SwipeRequestsScreen(),
      const ServiceManagerScreen(),
    ];
  }

  List<NavItem> _getNavItems(BuildContext context, UserRole role) {
    final l10n = AppLocalizations.of(context)!;
    if (role == UserRole.visitor) {
      return [
        NavItem(index: 0, icon: Icons.map_rounded, label: l10n.explore.toUpperCase()),
        NavItem(index: 1, icon: Icons.favorite_rounded, label: l10n.match.toUpperCase()),
        NavItem(index: 2, icon: Icons.forum_rounded, label: l10n.requests.toUpperCase()),
      ];
    }
    return [
      NavItem(index: 0, icon: Icons.dashboard_rounded, label: 'DASHBOARD'),
      NavItem(index: 1, icon: Icons.map_rounded, label: 'EXPLORE'),
      NavItem(index: 2, icon: Icons.swipe_rounded, label: l10n.requests.toUpperCase()),
      NavItem(index: 3, icon: Icons.medical_services_rounded, label: l10n.services.toUpperCase()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final user = auth.userData;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: EspyTheme.gold)));
    }

    final role = user.role;
    final List<Widget> screens = _getScreens(role);
    final List<NavItem> items = _getNavItems(context, role);

    if (_selectedIndex >= screens.length) {
      _selectedIndex = 0;
    }

    final bool isVisitor = role == UserRole.visitor;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const EspySideMenu(),
      extendBody: true,
      backgroundColor: isVisitor ? EspyTheme.platinum : Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: _buildCustomHeader(context, user, role),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: _buildBottomNavLayer(items, isVisitor),
    );
  }

  Widget _buildBottomNavLayer(List<NavItem> items, bool isVisitor) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 12, left: 24, right: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: EspyTheme.navyDeep.withOpacity(0.85),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white10),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20)],
            ),
            child: isVisitor ? _buildExclusiveVisitorRow() : _buildProviderRow(items),
          ),
        ),
      ),
    );
  }

  Widget _buildProviderRow(List<NavItem> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: items.map((item) => _buildNavItemWidget(item)).toList(),
    );
  }

  Widget _buildExclusiveVisitorRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSOSButton(),
        _buildToggleBtn(0, Icons.map_rounded, _selectedIndex == 0),
        _buildToggleBtn(1, Icons.favorite_rounded, _selectedIndex == 1),
        _buildToggleBtn(2, Icons.forum_rounded, _selectedIndex == 2),
      ],
    );
  }

  Widget _buildSOSButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        SoundService.playSOS();
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SOSHubScreen()));
      },
      child: Pulse(
        infinite: true,
        child: Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(colors: [Colors.redAccent, Color(0xFFB71C1C)]),
            boxShadow: [BoxShadow(color: Colors.redAccent.withOpacity(0.4), blurRadius: 8)],
          ),
          child: const Icon(Icons.emergency_rounded, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildToggleBtn(int index, IconData icon, bool active) {
    return IconButton(
      onPressed: () {
        if (!active) {
          HapticFeedback.mediumImpact();
          SoundService.playPop();
          setState(() => _selectedIndex = index);
        }
      },
      icon: Icon(icon, color: active ? EspyTheme.gold : Colors.white38, size: 22),
    );
  }

  Widget _buildNavItemWidget(NavItem item) {
    bool isActive = _selectedIndex == item.index;
    return GestureDetector(
      onTap: () {
        SoundService.playPop();
        setState(() => _selectedIndex = item.index);
      },
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

  Widget _buildCustomHeader(BuildContext context, UserModel user, UserRole role) {
    final localeService = Provider.of<LocaleService>(context);
    final navItems = _getNavItems(context, role);
    final currentLabel = (_selectedIndex < navItems.length) ? navItems[_selectedIndex].label : 'ESPY';
    final Color bgColor = Colors.white;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 10, 20, 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.05))),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: user.photoUrl != null ? CachedNetworkImageProvider(user.photoUrl!) : null,
              backgroundColor: EspyTheme.platinum,
              child: user.photoUrl == null ? const Icon(Icons.person, size: 18, color: EspyTheme.royalBlue) : null,
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
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, size: 20),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
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
          color: EspyTheme.gold.withOpacity(0.1),
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
