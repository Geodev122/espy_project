import 'dart:async';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:shared_core/theme/espy_theme.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/services/user_service.dart';
import 'package:shared_core/services/sound_service.dart';
import 'package:shared_core/services/locale_service.dart';
import 'package:shared_core/models/user_model.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'directory/directory_screen.dart';
import 'map/map_explore_screen.dart';
import 'matching/matching_screen.dart';
import 'community/community_feed_screen.dart';
import 'emergency/sos_hub_screen.dart';
import 'services/broadcast_screen.dart';
import 'profile/broadcasts_and_notifications_screen.dart';
import '../widgets/common/espy_side_menu.dart';
import '../widgets/common/premium_button.dart';

import '../../l10n/app_localizations.dart';

import 'package:glassmorphism/glassmorphism.dart';
import 'package:shared_core/services/firestore_service.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  StreamSubscription? _notificationSubscription;

  @override
  void initState() {
    super.initState();
    _initNotificationListener();
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }

  void _initNotificationListener() {
    final auth = Provider.of<AuthService>(context, listen: false);
    final firestore = Provider.of<FirestoreService>(context, listen: false);
    final uid = auth.user?.uid;
    final user = auth.userData;
    if (uid != null) {
      _notificationSubscription = firestore.getNotifications(uid, role: user?.role.name).listen(
        (notifications) {
          final unread = notifications.where((n) => n['isRead'] == false).toList();
          if (unread.isNotEmpty && mounted) {
            _showNotificationPrompt(unread.first);
          }
        },
        onError: (e) => debugPrint('Notification Listener Error: $e'),
      );
    }
  }

  void _showNotificationPrompt(Map<String, dynamic> notification) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: EspyTheme.platinum,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(Icons.auto_awesome_rounded, color: EspyTheme.gold),
            const SizedBox(width: 12),
            Expanded(child: Text(notification['title']?.toString().toUpperCase() ?? 'SYSTEM UPDATE',
              style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 16))),
          ],
        ),
        content: Text(notification['message'] ?? '', style: GoogleFonts.lora(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () {
              final id = notification['id'];
              if (id != null) {
                FirebaseFirestore.instance.collection('directory_notifications').doc(id).update({'isRead': true});
              }
              Navigator.pop(context);
            },
            child: const Text('ACKNOWLEDGE', style: TextStyle(fontWeight: FontWeight.bold, color: EspyTheme.noir)),
          ),
        ],
      ),
    );
  }

  List<Widget> _getScreens(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top + 70;
    return [
      MapExploreScreen(),
      Padding(padding: EdgeInsets.only(top: topPadding), child: MatchingScreen()),
      Padding(padding: EdgeInsets.only(top: topPadding), child: DirectoryScreen()),
      Padding(padding: EdgeInsets.only(top: topPadding), child: CommunityFeedScreen()),
    ];
  }

  List<NavItem> _getNavItems(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      NavItem(index: 0, icon: Icons.map_rounded, label: l10n.explore.toUpperCase()),
      NavItem(index: 1, icon: Icons.favorite_rounded, label: l10n.match.toUpperCase()),
      NavItem(index: 2, icon: LucideIcons.briefcase, label: l10n.services.toUpperCase()),
      NavItem(index: 3, icon: Icons.forum_rounded, label: l10n.requests.toUpperCase()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final user = auth.userData;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: EspyTheme.gold)));
    }

    final List<Widget> screens = _getScreens(context);
    
    if (_selectedIndex >= screens.length) {
      _selectedIndex = 0;
    }

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: EspyTheme.systemUIOverlayDark,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const EspySideMenu(),
        extendBody: true,
        backgroundColor: EspyTheme.platinum,
        body: Stack(
          children: [
            IndexedStack(
              index: _selectedIndex,
              children: screens,
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildCustomHeader(context, user),
            ),
          ],
        ),
        bottomNavigationBar: _buildExclusiveVisitorNav(),
      ),
    );
  }

  Widget _buildExclusiveVisitorNav() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 100,
      borderRadius: 0,
      blur: 15,
      alignment: Alignment.center,
      border: 0,
      linearGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          EspyTheme.platinum.withOpacity(0.1),
          EspyTheme.platinum.withOpacity(0.9),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.05)],
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSOSButton(),
            const SizedBox(width: 16),
            _buildMapMatchToggle(),
            const SizedBox(width: 12),
            _buildServiceAction(),
            const SizedBox(width: 12),
            _buildRequestAction(),
          ],
        ),
      ),
    );
  }

  Widget _buildSOSButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        SoundService.playSOS();
        Navigator.push(context, MaterialPageRoute(builder: (_) => SOSHubScreen()));
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
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleBtn(0, Icons.map_rounded, 'EXPLORE', isMap),
          const SizedBox(width: 4),
          _buildToggleBtn(1, Icons.favorite_rounded, 'MATCH', isMatch),
        ],
      ),
    );
  }

  Widget _buildToggleBtn(int index, IconData icon, String label, bool active) {
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
        curve: Curves.elasticOut,
        padding: EdgeInsets.symmetric(horizontal: active ? 16 : 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? EspyTheme.gold : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: active ? EspyTheme.navyDeep : Colors.white38,
            ),
            if (active) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.cinzel(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: EspyTheme.navyDeep,
                  letterSpacing: 1,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildServiceAction() {
    final bool isActive = _selectedIndex == 2;
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        SoundService.playPop();
        setState(() => _selectedIndex = 2);
      },
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          color: isActive ? EspyTheme.gold : Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive ? EspyTheme.gold : Colors.white.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: Icon(
          LucideIcons.briefcase,
          color: isActive ? EspyTheme.navyDeep : Colors.white70,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildRequestAction() {
    final bool isActive = _selectedIndex == 3;
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        SoundService.playPop();
        setState(() => _selectedIndex = 3);
      },
      child: Container(
        width: 44, height: 44,
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
          size: 18,
        ),
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context, UserModel user) {
    final localeService = Provider.of<LocaleService>(context);
    final userService = Provider.of<UserService>(context);
    final profile = userService.profile ?? {};
    final navItems = _getNavItems(context);
    final currentLabel = (_selectedIndex < navItems.length) ? navItems[_selectedIndex].label : 'ESPY';

    return GlassmorphicContainer(
      width: double.infinity,
      height: MediaQuery.of(context).padding.top + 60,
      borderRadius: 0,
      blur: 20,
      alignment: Alignment.bottomCenter,
      border: 0,
      linearGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          EspyTheme.platinum.withOpacity(0.9),
          EspyTheme.platinum.withOpacity(0.8),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.05)],
      ),
      padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: Hero(
              tag: 'header-profile-avatar',
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: EspyTheme.gold.withOpacity(0.5), width: 2),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                  image: profile['photoUrl'] != null
                      ? DecorationImage(image: CachedNetworkImageProvider(profile['photoUrl']), fit: BoxFit.cover)
                      : null,
                ),
                child: profile['photoUrl'] == null
                    ? const Icon(Icons.person_rounded, color: EspyTheme.royalBlue, size: 20)
                    : null,
              ),
            ),
          ),
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                currentLabel,
                style: GoogleFonts.cinzel(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2, color: EspyTheme.navyDeep),
              ),
              if (profile['name'] != null)
                Text(
                  profile['name'].toString().toUpperCase(),
                  style: GoogleFonts.cinzel(fontSize: 7, fontWeight: FontWeight.bold, letterSpacing: 1, color: EspyTheme.gold),
                ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BroadcastsAndNotificationsScreen())),
            icon: Stack(
              children: [
                const Icon(LucideIcons.megaphone, color: EspyTheme.royalBlue, size: 22),
                Positioned(
                  right: 0, top: 0,
                  child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle)),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => localeService.toggleLocale(),
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: EspyTheme.gold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: EspyTheme.gold.withOpacity(0.2)),
              ),
              child: Text(
                localeService.locale.languageCode.toUpperCase(),
                style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.w900, color: EspyTheme.gold),
              ),
            ),
          ),
        ],
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
