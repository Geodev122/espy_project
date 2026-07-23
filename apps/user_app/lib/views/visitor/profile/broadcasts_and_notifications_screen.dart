import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:espy_app/l10n/app_localizations.dart';
import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/viewmodels/firestore_service.dart';
import 'package:espy_app/viewmodels/auth_service.dart';
import 'package:espy_app/widgets/common/premium_card.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';

class BroadcastsAndNotificationsScreen extends StatefulWidget {
  const BroadcastsAndNotificationsScreen({super.key});

  @override
  State<BroadcastsAndNotificationsScreen> createState() => _BroadcastsAndNotificationsScreenState();
}

class _BroadcastsAndNotificationsScreenState extends State<BroadcastsAndNotificationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(
        title: Text(l10n.networkNotifications.toUpperCase(), style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: EspyTheme.royalBlue,
          labelColor: EspyTheme.navyDeep,
          unselectedLabelColor: EspyTheme.navyDeep.withValues(alpha: 0.3),
          tabs: const [
            Tab(text: "ALERTS"),
            Tab(text: "BROADCASTS"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _NotificationsList(),
          _BroadcastsList(),
        ],
      ),
    );
  }
}

class _NotificationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final firestore = FirestoreService();

    if (auth.user == null) return const Center(child: Text('Sign in to view alerts'));

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: firestore.getNotifications(auth.user!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: EspyTheme.gold));
        }
        final items = snapshot.data ?? [];
        if (items.isEmpty) return const _EmptyState(message: "No System Alerts");

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: items.length,
          itemBuilder: (context, index) => FadeInRight(
            delay: Duration(milliseconds: index * 50),
            child: _ItemCard(data: items[index], icon: LucideIcons.bell),
          ),
        );
      },
    );
  }
}

class _BroadcastsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: firestore.getBroadcasts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: EspyTheme.gold));
        }
        final items = snapshot.data ?? [];
        if (items.isEmpty) return const _EmptyState(message: "No Live Broadcasts");

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: items.length,
          itemBuilder: (context, index) => FadeInRight(
            delay: Duration(milliseconds: index * 50),
            child: _ItemCard(data: items[index], icon: LucideIcons.megaphone, isBroadcast: true),
          ),
        );
      },
    );
  }
}

class _ItemCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final IconData icon;
  final bool isBroadcast;

  const _ItemCard({required this.data, required this.icon, this.isBroadcast = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: PremiumCard(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isBroadcast ? EspyTheme.gold.withValues(alpha: 0.1) : EspyTheme.royalBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isBroadcast ? EspyTheme.gold : EspyTheme.royalBlue, size: 20),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['title'] ?? 'Update', style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 13, color: EspyTheme.navyDeep)),
                  const SizedBox(height: 8),
                  Text(data['message'] ?? '', style: GoogleFonts.lora(fontSize: 12, color: EspyTheme.navyDeep.withValues(alpha: 0.7), height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.inbox, size: 48),
            const SizedBox(height: 12),
            Text(message.toUpperCase(), style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
