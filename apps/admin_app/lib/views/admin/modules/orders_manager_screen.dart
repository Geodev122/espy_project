import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../theme/espy_theme.dart';
import '../../../viewmodels/espy_repository.dart';
import '../../../widgets/common/premium_card.dart';
import '../../../widgets/common/espy_scaffold.dart';

class OrdersManagerScreen extends StatelessWidget {
  const OrdersManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<EspyRepository>(context);

    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(
        title: Text("RESOURCE ORDERS", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
        backgroundColor: Colors.white,
        foregroundColor: EspyTheme.navyDeep,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: repo.listPendingOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          
          final orders = snapshot.data ?? [];
          
          if (orders.isEmpty) return const Center(child: Text("NO PENDING ORDERS"));

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final o = orders[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PremiumCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(o['userEmail'] ?? 'Unknown User', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Text("Order ID: ${o['id'].toString().substring(0, 8)}..."),
                        trailing: Text("${o['totalCost']} \$E", style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, color: EspyTheme.gold)),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _infoItem(LucideIcons.mapPin, "${o['pinsCount']} PINS"),
                          _infoItem(LucideIcons.layoutGrid, "${o['slotsCount']} SLOTS"),
                          _infoItem(LucideIcons.megaphone, "${o['broadcastsCount']} BC"),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => repo.approveResourceOrder(o['id']),
                          style: ElevatedButton.styleFrom(backgroundColor: EspyTheme.success, foregroundColor: Colors.white),
                          child: const Text("APPROVE ORDER", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10)),
                        ),
                      )
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

  Widget _infoItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 16, color: EspyTheme.royalBlue),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.montserrat(fontSize: 8, fontWeight: FontWeight.w800)),
      ],
    );
  }
}
