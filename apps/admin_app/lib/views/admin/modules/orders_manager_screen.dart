import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../theme/espy_theme.dart';
import '../../../viewmodels/espy_repository.dart';
import '../../../viewmodels/orders_manager_view_model.dart';
import '../../../widgets/common/premium_card.dart';
import '../../../widgets/common/espy_scaffold.dart';

class OrdersManagerScreen extends StatelessWidget {
  const OrdersManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OrdersManagerViewModel(context.read<EspyRepository>()),
      child: const _OrdersManagerView(),
    );
  }
}

class _OrdersManagerView extends StatelessWidget {
  const _OrdersManagerView();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OrdersManagerViewModel>(context);

    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(
        title: Text("RESOURCE ORDERS", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
        backgroundColor: Colors.white,
        foregroundColor: EspyTheme.navyDeep,
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.pendingOrders.isEmpty
              ? const Center(child: Text("NO PENDING ORDERS"))
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: viewModel.pendingOrders.length,
                  itemBuilder: (context, index) {
                    final o = viewModel.pendingOrders[index];

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
                                onPressed: () => viewModel.approveOrder(o['id']),
                                style: ElevatedButton.styleFrom(backgroundColor: EspyTheme.success, foregroundColor: Colors.white),
                                child: const Text("APPROVE ORDER", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10)),
                              ),
                            )
                          ],
                        ),
                      ),
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
