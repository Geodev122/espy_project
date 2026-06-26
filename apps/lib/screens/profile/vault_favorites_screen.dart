import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shared_core/theme/espy_theme.dart';
import 'package:shared_core/services/firestore_service.dart';
import 'package:shared_core/services/auth_service.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/common/premium_card.dart';

class VaultFavoritesScreen extends StatelessWidget {
  const VaultFavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();
    final auth = Provider.of<AuthService>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: EspyTheme.platinum,
      appBar: AppBar(
        title: Text(l10n.vault.toUpperCase() + " FAVORITES"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: auth.user == null
          ? const Center(child: Text('Sign in to view favorites'))
          : StreamBuilder<List<Map<String, dynamic>>>(
              stream: firestore.getUserFavorites(auth.user!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: EspyTheme.gold));
                }

                final favorites = snapshot.data ?? [];

                if (favorites.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border_rounded, size: 64, color: EspyTheme.gold.withValues(alpha: 0.1)),
                        const SizedBox(height: 16),
                        Text(
                          "NO FAVORITES SAVED",
                          style: GoogleFonts.cinzel(color: EspyTheme.navyDeep.withValues(alpha: 0.3), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final fav = favorites[index];
                    final profId = fav['professionalId'];

                    return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance.collection('directory_professionals').doc(profId).snapshots(),
                      builder: (context, profSnap) {
                        if (!profSnap.hasData || !profSnap.data!.exists) {
                          // Try institutions if not professional
                           return StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance.collection('directory_institutions').doc(profId).snapshots(),
                            builder: (context, instSnap) {
                              if (!instSnap.hasData || !instSnap.data!.exists) return const SizedBox.shrink();
                              final inst = instSnap.data!.data() as Map<String, dynamic>;
                              return _buildFavoriteTile(context, firestore, auth.user!.uid, profId, inst, index);
                            },
                          );
                        }
                        final prof = profSnap.data!.data() as Map<String, dynamic>;
                        return _buildFavoriteTile(context, firestore, auth.user!.uid, profId, prof, index);
                      },
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildFavoriteTile(BuildContext context, FirestoreService firestore, String uid, String profId, Map<String, dynamic> data, int index) {
    return FadeInRight(
      delay: Duration(milliseconds: index * 100),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: PremiumCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: data['photoUrl'] != null ? CachedNetworkImageProvider(data['photoUrl']) : null,
                child: data['photoUrl'] == null ? const Icon(Icons.person) : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (data['fullNameEn'] ?? data['name'] ?? 'Provider').toString().toUpperCase(),
                      style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 13, color: EspyTheme.navyDeep),
                    ),
                    Text(
                      data['specialization'] ?? 'Verified Node',
                      style: GoogleFonts.lora(fontSize: 11, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.favorite, color: EspyTheme.error),
                onPressed: () => firestore.toggleFavorite(uid, profId, false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
