import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';

import 'package:shared_core/theme/espy_theme.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/services/firestore_service.dart';
import 'package:shared_core/widgets/common/premium_card.dart';
import 'package:shared_core/widgets/common/espy_scaffold.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final firestore = FirestoreService();
    final String? userId = auth.user?.uid;
    final l10n = AppLocalizations.of(context)!;

    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(title: Text(l10n.paymentProtocols.toUpperCase()), backgroundColor: Colors.transparent, elevation: 0),
      body: userId == null
          ? Center(child: Text(l10n.authorizedPersonnelOnly))
          : StreamBuilder<List<Map<String, dynamic>>>(
              stream: firestore.getUserTransactions(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: EspyTheme.gold));
                final txs = snapshot.data ?? [];
                if (txs.isEmpty) return Center(child: Text(l10n.noTransactionLogs.toUpperCase(), style: const TextStyle(color: Colors.white24)));

                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: txs.length,
                  itemBuilder: (context, index) {
                    final tx = txs[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: PremiumCard(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("#${tx['id']?.toString().substring(0, 8).toUpperCase()}", style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.gold)),
                            const SizedBox(height: 12),
                            Text("\$${tx['amount']}", style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w900)),
                            Text(tx['status']?.toString().toUpperCase() ?? 'PENDING', style: GoogleFonts.cinzel(fontSize: 8, color: Colors.black38)),
                          ],
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
