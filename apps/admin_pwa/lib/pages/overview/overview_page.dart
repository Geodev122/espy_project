import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../registry/registry_providers.dart';
import '../finance/finance_page.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OverviewPage extends ConsumerWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProfs = ref.watch(professionalsStreamProvider);
    final asyncInsts = ref.watch(institutionsStreamProvider);
    final asyncVisitors = ref.watch(visitorsStreamProvider);
    final asyncTransactions = ref.watch(membershipTransactionsStreamProvider);
    final asyncRequests = ref.watch(communityRequestsStreamProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 48),
          _buildStatsGrid(asyncProfs, asyncInsts, asyncVisitors, asyncTransactions),
          const SizedBox(height: 48),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildRevenueTrendChart(asyncTransactions),
                    const SizedBox(height: 24),
                    _buildActivityFeed(asyncTransactions, asyncRequests),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildQuickActions(context),
                    const SizedBox(height: 24),
                    _buildEcosystemHealthCard(asyncProfs, asyncInsts),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CENTRAL GOVERNANCE HUB',
          style: EspyTheme.cinzelStyle.copyWith(fontSize: 24, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          'Command center for Espy network synchronization and fiscal oversight',
          style: EspyTheme.loraStyle.copyWith(fontSize: 14, color: Colors.white38),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(
    AsyncValue<List<dynamic>> profs,
    AsyncValue<List<dynamic>> insts,
    AsyncValue<List<dynamic>> visitors,
    AsyncValue<List<Map<String, dynamic>>> transactions,
  ) {
    final revenue = transactions.maybeWhen(
      data: (d) => d.where((t) => t['status'] == 'completed').fold(0.0, (sum, t) => sum + (double.tryParse(t['amount']?.toString() ?? '0') ?? 0.0)),
      orElse: () => 0.0,
    );

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      childAspectRatio: 2.2,
      children: [
        _buildStatCard('PROFESSIONALS', profs.maybeWhen(data: (d) => d.length.toString(), orElse: () => '...'), LucideIcons.users, EspyTheme.gold),
        _buildStatCard('INSTITUTIONS', insts.maybeWhen(data: (d) => d.length.toString(), orElse: () => '...'), LucideIcons.building, EspyTheme.cyan),
        _buildStatCard('TOTAL REVENUE', '\$${revenue.toStringAsFixed(0)}', LucideIcons.trendingUp, EspyTheme.electricBlue),
        _buildStatCard('NETWORK PINS', visitors.maybeWhen(data: (d) => d.length.toString(), orElse: () => '...'), LucideIcons.globe, Colors.green),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: EspyTheme.cinzelStyle.copyWith(fontSize: 9, color: Colors.white38)),
                Text(value, style: EspyTheme.cinzelStyle.copyWith(fontSize: 24, color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueTrendChart(AsyncValue<List<Map<String, dynamic>>> transactions) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('FISCAL PERFORMANCE TREND', style: EspyTheme.cinzelStyle.copyWith(fontSize: 12, color: EspyTheme.gold)),
            const SizedBox(height: 32),
            SizedBox(
              height: 200,
              child: transactions.when(
                data: (data) {
                  final Map<String, double> dailyRev = {};
                  final filtered = data.where((t) => t['status'] == 'completed').toList();
                  for (var t in filtered) {
                    final ts = t['createdAt'] as Timestamp?;
                    if (ts == null) continue;
                    
                    final date = DateFormat('MM-dd').format(ts.toDate());
                    dailyRev[date] = (dailyRev[date] ?? 0) + (double.tryParse(t['amount']?.toString() ?? '0') ?? 0.0);
                  }
                  final sortedDates = dailyRev.keys.toList()..sort();
                  final spots = sortedDates.asMap().entries.map((e) => FlSpot(e.key.toDouble(), dailyRev[e.value]!)).toList();

                  return LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots.isEmpty ? [const FlSpot(0, 0)] : spots,
                          isCurved: true,
                          color: EspyTheme.electricBlue,
                          barWidth: 4,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [EspyTheme.electricBlue.withOpacity(0.2), Colors.transparent],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityFeed(AsyncValue<List<Map<String, dynamic>>> transactions, AsyncValue<List<Map<String, dynamic>>> requests) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('SYSTEM ACTIVITY STREAM', style: EspyTheme.cinzelStyle.copyWith(fontSize: 12, color: EspyTheme.gold)),
                Icon(LucideIcons.radio, size: 14, color: EspyTheme.cyan),
              ],
            ),
            const SizedBox(height: 24),
            transactions.when(
              data: (txData) => requests.when(
                data: (reqData) {
                  final combined = [
                    ...txData.where((t) => t['createdAt'] != null).map((t) => {'type': 'tx', 'data': t, 'ts': t['createdAt']}),
                    ...reqData.where((r) => r['createdAt'] != null).map((r) => {'type': 'req', 'data': r, 'ts': r['createdAt']}),
                  ];
                  combined.sort((a, b) => (b['ts'] as Timestamp).compareTo(a['ts'] as Timestamp));

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: combined.length > 8 ? 8 : combined.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, i) {
                      final item = combined[i];
                      return _buildActivityItem(item);
                    },
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, s) => Text('Error: $e'),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, s) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> item) {
    final type = item['type'];
    final data = item['data'];
    final bool isTx = type == 'tx';

    return Row(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: (isTx ? EspyTheme.electricBlue : EspyTheme.gold).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(isTx ? LucideIcons.creditCard : LucideIcons.messageSquare, size: 14, color: isTx ? EspyTheme.electricBlue : EspyTheme.gold),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isTx ? 'Transaction: \$${data['amount']} - ${data['status'].toString().toUpperCase()}' : 'Community Request: ${data['title']}',
                style: const TextStyle(fontSize: 13, color: Colors.white70),
              ),
              Text(
                DateFormat('dd MMM HH:mm').format((data['createdAt'] as Timestamp).toDate()),
                style: const TextStyle(fontSize: 9, color: Colors.white12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        _buildActionBtn(context, 'MINT RECHARGE CODES', LucideIcons.ticket, EspyTheme.gold, '/system'),
        const SizedBox(height: 16),
        _buildActionBtn(context, 'CONFIGURE PRICING', LucideIcons.tag, EspyTheme.cyan, '/system'),
        const SizedBox(height: 16),
        _buildActionBtn(context, 'INITIATE BROADCAST', LucideIcons.send, EspyTheme.electricBlue, '/comms'),
        const SizedBox(height: 16),
        _buildActionBtn(context, 'REVENUE INTELLIGENCE', LucideIcons.barChart4, EspyTheme.gold, '/finance'),
        const SizedBox(height: 16),
        _buildActionBtn(context, 'ECOSYSTEM REGISTRY', LucideIcons.database, EspyTheme.cyan, '/registry'),
        const SizedBox(height: 16),
        _buildActionBtn(context, 'SOS COMMAND', LucideIcons.alertTriangle, Colors.redAccent, '/sos'),
      ],
    );
  }

  Widget _buildActionBtn(BuildContext context, String label, IconData icon, Color color, String route) {
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 16),
            Text(label, style: EspyTheme.cinzelStyle.copyWith(fontSize: 11, color: color)),
            const Spacer(),
            Icon(LucideIcons.chevronRight, color: color.withOpacity(0.3), size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildEcosystemHealthCard(AsyncValue<List<dynamic>> profs, AsyncValue<List<dynamic>> insts) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ECOSYSTEM INTEGRITY', style: EspyTheme.cinzelStyle.copyWith(fontSize: 10, color: Colors.white24)),
            const SizedBox(height: 20),
            _buildHealthRow('VALIDATED PROS', profs.maybeWhen(data: (d) => d.where((u) => u.isApproved).length / (d.isEmpty ? 1 : d.length), orElse: () => 0.0)),
            const SizedBox(height: 12),
            _buildHealthRow('VALIDATED INSTS', insts.maybeWhen(data: (d) => d.where((u) => u.isApproved).length / (d.isEmpty ? 1 : d.length), orElse: () => 0.0)),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthRow(String label, double percent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 9, color: Colors.white38)),
            Text('${(percent * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 9, color: EspyTheme.cyan)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percent,
          backgroundColor: Colors.white10,
          color: EspyTheme.cyan,
          minHeight: 2,
        ),
      ],
    );
  }
}
