import 'dart:async';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/viewmodels/auth_service.dart';
import 'package:espy_app/viewmodels/user_service.dart';
import 'package:espy_app/viewmodels/sound_service.dart';
import 'package:espy_app/viewmodels/firestore_service.dart';
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
import 'package:espy_app/widgets/common/premium_button.dart';

import 'package:espy_app/l10n/app_localizations.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> _getScreens(UserRole role, double topPadding) {
    if (role == UserRole.visitor) {
      return [
        const MapExploreScreen(),
        Padding(padding: EdgeInsets.only(top: topPadding), child: const MatchingScreen()),
        Padding(padding: EdgeInsets.only(top: topPadding), child: const CommunityFeedScreen()),
      ];
    }
    return [
      Padding(padding: EdgeInsets.only(top: topPadding), child: const DashboardScreen()),
      const MapExploreScreen(),
      Padding(padding: EdgeInsets.only(top: topPadding), child: const SwipeRequestsScreen()),
      Padding(padding: EdgeInsets.only(top: topPadding), child: const ServiceManagerScreen()),
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
    final double topPadding = MediaQuery.of(context).padding.top + 70;
    final List<Widget> screens = _getScreens(role, topPadding);
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
      bottomNavigationBar: isVisitor ? _buildExclusiveVisitorNav() : _buildProviderNav(items),
    );
  }

  Widget _buildProviderNav(List<NavItem> items) {
    return Container(
      width: double.infinity,
      height: 80,
      color: EspyTheme.navyDeep.withOpacity(0.9),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
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

  Widget _buildExclusiveVisitorNav() {
    return Container(
      width: double.infinity,
      height: 100,
      color: EspyTheme.platinum.withOpacity(0.9),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSOSButton(),
                const SizedBox(width: 24),
                _buildMapMatchToggle(),
                const SizedBox(width: 24),
                _buildRequestAction(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSOSButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        SoundService.playSOS();
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SOSHubScreen()));
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Pulse(
            infinite: true,
            duration: const Duration(seconds: 2),
            child: Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.redAccent.withOpacity(0.1),
              ),
            ),
          ),
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Colors.redAccent, Color(0xFFB71C1C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
            ),
            child: const Icon(Icons.emergency_rounded, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildMapMatchToggle() {
    final bool isMap = _selectedIndex == 0;
    final bool isMatch = _selectedIndex == 1;

    return Container(
      height: 54,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleBtn(0, Icons.map_rounded, isMap),
          const SizedBox(width: 6),
          _buildToggleBtn(1, Icons.favorite_rounded, isMatch),
        ],
      ),
    );
  }

  Widget _buildToggleBtn(int index, IconData icon, bool active) {
    return GestureDetector(
      onTap: () {
        if (!active) {
          HapticFeedback.mediumImpact();
          SoundService.playPop();
          setState(() => _selectedIndex = index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active ? EspyTheme.gold : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          boxShadow: active ? [BoxShadow(color: EspyTheme.gold.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))] : null,
        ),
        child: Icon(
          icon,
          size: 20,
          color: active ? EspyTheme.navyDeep : Colors.white38,
        ),
      ),
    );
  }

  Widget _buildRequestAction() {
    final bool isActive = _selectedIndex == 2;
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        SoundService.playPop();
        setState(() => _selectedIndex = 2);
      },
      child: Container(
        width: 48, height: 48,
        decoration: BoxDecoration(
          color: isActive ? EspyTheme.gold : Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive ? EspyTheme.gold : Colors.white.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: Icon(
          Icons.forum_rounded,
          color: isActive ? EspyTheme.navyDeep : Colors.white70,
          size: 22,
        ),
      ),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, color: isActive ? EspyTheme.gold : Colors.white38, size: 20),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: GoogleFonts.cinzel(fontSize: 7, fontWeight: FontWeight.w900, color: isActive ? EspyTheme.gold : Colors.white38, letterSpacing: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context, UserModel user, UserRole role) {
    final localeService = Provider.of<LocaleService>(context);
    final navItems = _getNavItems(context, role);
    final currentLabel = (_selectedIndex < navItems.length) ? navItems[_selectedIndex].label : 'ESPY';
    final Color bgColor = Theme.of(context).scaffoldBackgroundColor;
    final bool isVisitor = role == UserRole.visitor;

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).padding.top + 70,
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.95),
        border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.08), width: 1.5),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top, 16, 8),
        child: Row(
              children: [
                GestureDetector(
                  onTap: () => _scaffoldKey.currentState?.openDrawer(),
                  child: Hero(
                    tag: 'header-profile-avatar',
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: EspyTheme.royalBlue.withOpacity(0.15), width: 1.5),
                        image: user.photoUrl != null
                            ? DecorationImage(image: CachedNetworkImageProvider(user.photoUrl!), fit: BoxFit.cover)
                            : null,
                      ),
                      child: user.photoUrl == null
                          ? const Icon(Icons.person_rounded, color: EspyTheme.royalBlue, size: 20)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentLabel,
                        style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.5, color: EspyTheme.navyDeep),
                      ),
                      if (user.name != null)
                        Text(
                          user.name!.toUpperCase(),
                          style: GoogleFonts.montserrat(fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: EspyTheme.gold),
                        ),
                    ],
                  ),
                ),
                if (isVisitor)
                  IconButton(
                    icon: const Icon(Icons.campaign_rounded, color: EspyTheme.navyDeep, size: 22),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnnouncementsScreen())),
                    tooltip: 'Broadcasts',
                  ),
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded, color: EspyTheme.navyDeep, size: 22),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
                  tooltip: 'Notifications',
                ),
                const SizedBox(width: 4),
                _buildLocaleToggle(localeService),
              ],
            ),
          ),
    );
  }

  Widget _buildLocaleToggle(LocaleService localeService) {
    return InkWell(
      onTap: () => localeService.toggleLocale(),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: EspyTheme.gold.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: EspyTheme.gold.withOpacity(0.15)),
        ),
        child: Text(
          localeService.locale.languageCode.toUpperCase(),
          style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.w900, color: EspyTheme.gold, letterSpacing: 0.5),
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
