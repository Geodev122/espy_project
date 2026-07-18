import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:espy_app/l10n/app_localizations.dart';
import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/viewmodels/firestore_service.dart';
import 'package:espy_app/viewmodels/auth_service.dart';
import 'package:espy_app/widgets/common/premium_card.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final firestore = FirestoreService();
    final l10n = AppLocalizations.of(context)!;
    final role = auth.userData?.role.name;

    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(title: Text(l10n.networkNotifications.toUpperCase()), backgroundColor: Colors.transparent, elevation: 0),
      body: auth.user == null
          ? Center(child: Text(l10n.signInViewNotifications))
          : StreamBuilder<List<Map<String, dynamic>>>(
              stream: firestore.getNotifications(auth.user!.uid, role: role),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: EspyTheme.gold));
                final notifications = snapshot.data ?? [];
                if (notifications.isEmpty) return Center(child: Text(l10n.noNewProtocols.toUpperCase(), style: const TextStyle(color: Colors.white24)));

                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final n = notifications[index];
                    return FadeInRight(
                      delay: Duration(milliseconds: index * 100),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: PremiumCard(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(n['title'] ?? 'System Update', style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
                              const SizedBox(height: 8),
                              Text(n['message'] ?? '', style: GoogleFonts.lora(fontSize: 12, color: Colors.black54)),
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
