import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../l10n/app_localizations.dart';
import 'package:shared_core/theme/espy_theme.dart';
import 'package:shared_core/services/firestore_service.dart';
import 'package:shared_core/services/auth_service.dart';
import '../../widgets/common/premium_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final firestore = FirestoreService();
    final l10n = AppLocalizations.of(context)!;
    final role = auth.userData?.role.name;

    return Scaffold(
      backgroundColor: EspyTheme.platinum,
      appBar: AppBar(
        title: Text(l10n.networkNotifications.toUpperCase()),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: auth.user == null
          ? const Center(child: Text('Sign in to view notifications'))
          : StreamBuilder<List<Map<String, dynamic>>>(
              stream: firestore.getNotifications(auth.user!.uid, role: role),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: EspyTheme.gold));
                }

                final notifications = snapshot.data ?? [];

                if (notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_none_rounded, size: 64, color: EspyTheme.gold.withValues(alpha: 0.1)),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noNewProtocols.toUpperCase(),
                          style: GoogleFonts.cinzel(color: EspyTheme.gold.withValues(alpha: 0.3), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final n = notifications[index];
                    final isGlobal = n['type'] == 'global' || n['isGlobal'] == true;

                    return FadeInRight(
                      delay: Duration(milliseconds: index * 100),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: PremiumCard(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isGlobal ? EspyTheme.gold.withValues(alpha: 0.1) : EspyTheme.royalBlue.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isGlobal ? Icons.campaign_rounded : Icons.notifications_active_rounded,
                                  color: isGlobal ? EspyTheme.gold : EspyTheme.royalBlue,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          n['title'] ?? 'System Update',
                                          style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 13, color: EspyTheme.navyDeep),
                                        ),
                                        if (isGlobal)
                                          Text(
                                            l10n.global.toUpperCase(),
                                            style: GoogleFonts.cinzel(fontSize: 8, fontWeight: FontWeight.w900, color: EspyTheme.gold, letterSpacing: 1),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      n['message'] ?? n['content'] ?? '',
                                      style: GoogleFonts.lora(fontSize: 12, color: EspyTheme.navyDeep.withValues(alpha: 0.6), height: 1.5),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      l10n.receivedByProtocol.toUpperCase(),
                                      style: GoogleFonts.cinzel(fontSize: 7, fontWeight: FontWeight.bold, color: EspyTheme.navyDeep.withValues(alpha: 0.3), letterSpacing: 1),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
