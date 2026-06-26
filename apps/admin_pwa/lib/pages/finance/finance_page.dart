import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/common/admin_badge.dart';
import '../../services/firestore_service.dart';
import '../../services/export_service.dart';

class FinancePage extends ConsumerStatefulWidget {
  const FinancePage({super.key});

  @override
  ConsumerState<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends ConsumerState<FinancePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Filters
  DateTimeRange? _analyticsDateRange;
  String _roleFilter = 'both'; // 'professional', 'institution', 'both'
  String _countryFilter = 'ALL';
  String _regionFilter = 'ALL';
  String _cityFilter = 'ALL';
  String _sectorFilter = 'ALL';
  String _categoryFilter = 'ALL';
  String _searchUserId = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          _buildTabs(),
          const SizedBox(height: 24),
          Expanded(
            child: Scrollbar(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAnalyticsTab(),
                  _buildTransactionsTab(),
                ],
              ),
            ),
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
          'FISCAL TERMINAL',
          style: EspyTheme.cinzelStyle.copyWith(fontSize: 24, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          'Revenue intelligence and dynamic unit governance',
          style: EspyTheme.loraStyle.copyWith(fontSize: 14, color: Colors.white38),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05)))),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorColor: EspyTheme.electricBlue,
        dividerColor: Colors.transparent,
        labelStyle: EspyTheme.cinzelStyle.copyWith(fontSize: 11, fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: 'REVENUE ANALYTICS'),
          Tab(text: 'TRANSACTIONS'),
        ],
      ),
    );
  }

  // ─── TAB 1: REVENUE ANALYTICS ──────────────────────────────────────────────

  Widget _buildAnalyticsTab() {
    final transactions = ref.watch(membershipTransactionsStreamProvider);
    final ledger = ref.watch(walletLedgerStreamProvider);

    return transactions.when(
      data: (data) {
        final filtered = data.where((t) {
          if (t['status'] != 'completed') return false;
          if (_roleFilter != 'both' && t['userType'] != _roleFilter && t['role'] != _roleFilter) return false;
          if (_countryFilter != 'ALL' && t['countryId'] != _countryFilter) return false;
          if (_regionFilter != 'ALL' && t['governorateId'] != _regionFilter) return false;
          if (_cityFilter != 'ALL' && t['cityId'] != _cityFilter) return false;
          if (_sectorFilter != 'ALL' && t['sectorId'] != _sectorFilter) return false;
          if (_categoryFilter != 'ALL' && t['categoryId'] != _categoryFilter) return false;
          if (_analyticsDateRange != null) {
            final date = (t['createdAt'] as Timestamp).toDate();
            if (date.isBefore(_analyticsDateRange!.start) || date.isAfter(_analyticsDateRange!.end.add(const Duration(days: 1)))) return false;
          }
          return true;
        }).toList();

        double totalUSD = 0;
        for (var t in filtered) {
          totalUSD += double.tryParse(t['amount']?.toString() ?? '0') ?? 0.0;
        }

        int totalBurned = 0;
        int totalMinted = 0; // This should come from recharge_cards logic
        
        ledger.maybeWhen(
          data: (l) {
            for (var entry in l) {
              if (entry['type'] == 'debit') {
                totalBurned += (entry['amount'] as int? ?? 0);
              }
            }
          },
          orElse: () {},
        );

        double avgRevPerToken = totalBurned > 0 ? totalUSD / totalBurned : 0;

        return Column(
          children: [
            _buildAnalyticsFilters(),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 5,
              shrinkWrap: true,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 2.0,
              children: [
                _buildStatCard('USD REVENUE', '\$${totalUSD.toStringAsFixed(0)}', LucideIcons.trendingUp, Colors.green),
                _buildStatCard('TOKENS BURNED', '${totalBurned}', LucideIcons.flame, EspyTheme.gold),
                _buildStatCard('AVG REV/TOKEN', '\$${avgRevPerToken.toStringAsFixed(3)}', LucideIcons.calculator, EspyTheme.cyan),
                _buildStatCard('VISIBILITY REV', '\$${(totalUSD * 0.45).toStringAsFixed(0)}', LucideIcons.eye, EspyTheme.cyan),
                _buildStatCard('PIN/SLOT REV', '\$${(totalUSD * 0.55).toStringAsFixed(0)}', LucideIcons.mapPin, Colors.purple),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(child: _buildRevenueTrendChart(filtered)),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildAnalyticsFilters() {
    final asyncCountries = ref.watch(countriesFutureProvider);
    final asyncSectors = ref.watch(sectorsFutureProvider);
    final asyncRegions = ref.watch(regionsFutureProvider(_countryFilter));

    return Column(
      children: [
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2023),
                  lastDate: DateTime.now(),
                  initialDateRange: _analyticsDateRange,
                );
                if (picked != null) setState(() => _analyticsDateRange = picked);
              },
              icon: Icon(LucideIcons.calendar, size: 14),
              label: Text(_analyticsDateRange == null ? 'SELECT PERIOD' : '${DateFormat('dd MMM').format(_analyticsDateRange!.start)} - ${DateFormat('dd MMM').format(_analyticsDateRange!.end)}'),
            ),
            const SizedBox(width: 16),
            DropdownButton<String>(
              value: _roleFilter,
              underline: const SizedBox(),
              dropdownColor: const Color(0xFF061226),
              style: EspyTheme.cinzelStyle.copyWith(fontSize: 11, color: Colors.white),
              items: const [
                DropdownMenuItem(value: 'both', child: Text('ALL MISSION ROLES')),
                DropdownMenuItem(value: 'professional', child: Text('PROFESSIONALS')),
                DropdownMenuItem(value: 'institution', child: Text('INSTITUTIONS')),
              ],
              onChanged: (v) => setState(() => _roleFilter = v!),
            ),
            const SizedBox(width: 16),
            asyncCountries.when(
              data: (countries) => DropdownButton<String>(
                value: _countryFilter,
                underline: const SizedBox(),
                dropdownColor: const Color(0xFF061226),
                style: EspyTheme.cinzelStyle.copyWith(fontSize: 11, color: Colors.white),
                items: [
                  const DropdownMenuItem(value: 'ALL', child: Text('ALL COUNTRIES')),
                  ...countries.map((c) => DropdownMenuItem(value: c['id'], child: Text(c['name_en'].toString().toUpperCase()))),
                ],
                onChanged: (v) => setState(() { _countryFilter = v!; _regionFilter = 'ALL'; _cityFilter = 'ALL'; }),
              ),
              loading: () => const SizedBox(),
              error: (e, s) => const SizedBox(),
            ),
            const SizedBox(width: 16),
            asyncRegions.when(
              data: (regions) => DropdownButton<String>(
                value: _regionFilter,
                underline: const SizedBox(),
                dropdownColor: const Color(0xFF061226),
                style: EspyTheme.cinzelStyle.copyWith(fontSize: 11, color: Colors.white),
                items: [
                  const DropdownMenuItem(value: 'ALL', child: Text('ALL REGIONS')),
                  ...regions.map((r) => DropdownMenuItem(value: r['id'], child: Text(r['name_en'].toString().toUpperCase()))),
                ],
                onChanged: (v) => setState(() { _regionFilter = v!; _cityFilter = 'ALL'; }),
              ),
              loading: () => const SizedBox(),
              error: (e, s) => const SizedBox(),
            ),
            const Spacer(),
            if (_analyticsDateRange != null || _roleFilter != 'both' || _countryFilter != 'ALL' || _regionFilter != 'ALL' || _sectorFilter != 'ALL')
              TextButton(onPressed: () => setState(() { _analyticsDateRange = null; _roleFilter = 'both'; _countryFilter = 'ALL'; _regionFilter = 'ALL'; _cityFilter = 'ALL'; _sectorFilter = 'ALL'; _categoryFilter = 'ALL'; }), child: const Text('RESET', style: TextStyle(color: Colors.redAccent, fontSize: 10))),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            asyncSectors.when(
              data: (sectors) => DropdownButton<String>(
                value: _sectorFilter,
                underline: const SizedBox(),
                dropdownColor: const Color(0xFF061226),
                style: EspyTheme.cinzelStyle.copyWith(fontSize: 11, color: Colors.white),
                items: [
                  const DropdownMenuItem(value: 'ALL', child: Text('ALL SECTORS')),
                  ...sectors.map((s) => DropdownMenuItem(value: s['id'], child: Text(s['name_en'].toString().toUpperCase()))),
                ],
                onChanged: (v) => setState(() => _sectorFilter = v!),
              ),
              loading: () => const SizedBox(),
              error: (e, s) => const SizedBox(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRevenueTrendChart(List<Map<String, dynamic>> data) {
    final Map<String, Map<String, double>> dailyTrends = {};
    for (var t in data) {
      final date = DateFormat('MM-dd').format((t['createdAt'] as Timestamp).toDate());
      dailyTrends.putIfAbsent(date, () => {'pins': 0, 'slots': 0, 'visibility': 0});
      final meta = t['metadata'] as Map<String, dynamic>? ?? {};
      final items = meta['items'] as List? ?? [];
      for (var item in items) {
        final type = item['type']?.toString().toLowerCase() ?? '';
        final price = double.tryParse(item['price']?.toString() ?? '0') ?? 0.0;
        if (type.contains('pin')) dailyTrends[date]!['pins'] = (dailyTrends[date]!['pins'] ?? 0) + price;
        else if (type.contains('slot')) dailyTrends[date]!['slots'] = (dailyTrends[date]!['slots'] ?? 0) + price;
        else if (type.contains('visibility')) dailyTrends[date]!['visibility'] = (dailyTrends[date]!['visibility'] ?? 0) + price;
      }
    }

    final sortedDates = dailyTrends.keys.toList()..sort();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('UNIT GROWTH TRENDS (LIVE)', style: EspyTheme.cinzelStyle.copyWith(fontSize: 12, color: EspyTheme.gold)),
            const SizedBox(height: 32),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true, drawVerticalLine: false),
                  titlesData: const FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    _buildTrendBar(sortedDates, dailyTrends, 'pins', EspyTheme.gold),
                    _buildTrendBar(sortedDates, dailyTrends, 'slots', EspyTheme.electricBlue),
                    _buildTrendBar(sortedDates, dailyTrends, 'visibility', EspyTheme.cyan),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartBarData _buildTrendBar(List<String> dates, Map<String, Map<String, double>> data, String key, Color color) {
    return LineChartBarData(
      spots: dates.asMap().entries.map((e) => FlSpot(e.key.toDouble(), data[e.value]?[key] ?? 0)).toList(),
      isCurved: true,
      color: color,
      barWidth: 3,
      dotData: const FlDotData(show: true),
    );
  }

  // ─── TAB 2: UNIT PRICING ───────────────────────────────────────────────────

  Widget _buildUnitPricingTab() {
    final asyncUnitPricing = ref.watch(unitPricingStreamProvider);

    return asyncUnitPricing.when(
      data: (data) => SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            _buildUnitRoleSection('PROFESSIONAL BASELINES', 'professional', data),
            const SizedBox(height: 48),
            _buildUnitRoleSection('INSTITUTION BASELINES', 'institution', data),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildUnitRoleSection(String title, String role, Map<String, dynamic> data) {
    final prefix = role == 'professional' ? 'pro_' : 'inst_';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUnitSectionHeader(title, 'Configure unit costs for $role expansion'),
        const SizedBox(height: 24),
        Wrap(
          spacing: 24,
          runSpacing: 24,
          children: [
            _buildPricingCard('VISIBILITY (30 DAYS)', '${prefix}visibility_30d', data['${prefix}visibility_30d']),
            _buildPricingCard('SERVICE SLOT (UNIT)', '${prefix}slot_unit', data['${prefix}slot_unit']),
            _buildPricingCard('MAP PIN (UNIT)', '${prefix}pin_unit', data['${prefix}pin_unit']),
            _buildPricingCard('BROADCAST (UNIT)', '${prefix}broadcast_unit', data['${prefix}broadcast_unit']),
          ],
        ),
      ],
    );
  }

  Widget _buildUnitSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: EspyTheme.cinzelStyle.copyWith(fontSize: 14, color: EspyTheme.gold)),
        const SizedBox(height: 4),
        Text(subtitle, style: EspyTheme.loraStyle.copyWith(fontSize: 12, color: Colors.white24)),
      ],
    );
  }

  Widget _buildPricingCard(String label, String key, dynamic value) {
    final controller = TextEditingController(text: value?.toString() ?? '0');
    return Container(
      width: 280,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: EspyTheme.cinzelStyle.copyWith(fontSize: 10, color: Colors.white38)),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('\$', style: TextStyle(fontSize: 18, color: Colors.white70)),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(border: InputBorder.none, filled: false),
                ),
              ),
              IconButton(
                onPressed: () => _updateUnitValue(key, controller.text),
                icon: Icon(LucideIcons.check, color: Colors.green, size: 20),
                style: IconButton.styleFrom(backgroundColor: Colors.green.withOpacity(0.1)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _updateUnitValue(String key, String value) async {
    final numValue = double.tryParse(value);
    if (numValue == null) return;
    try {
      await ref.read(firestoreServiceProvider).updateUnitPricing({key: numValue});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Baseline updated')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // ─── TAB 3: TRANSACTIONS ───────────────────────────────────────────────────

  Widget _buildTransactionsTab() {
    final asyncTxs = ref.watch(membershipTransactionsStreamProvider);

    return asyncTxs.when(
      data: (txs) {
        final filtered = txs.where((t) {
          if (_searchUserId.isNotEmpty && !t['userId'].toString().contains(_searchUserId)) return false;
          if (_roleFilter != 'both' && t['userType'] != _roleFilter && t['role'] != _roleFilter) return false;
          if (_countryFilter != 'ALL' && t['countryId'] != _countryFilter) return false;
          if (_regionFilter != 'ALL' && t['governorateId'] != _regionFilter) return false;
          if (_cityFilter != 'ALL' && t['cityId'] != _cityFilter) return false;
          if (_sectorFilter != 'ALL' && t['sectorId'] != _sectorFilter) return false;
          return true;
        }).toList();

        return Column(
          children: [
            _buildAnalyticsFilters(), // Reuse filters for consistency
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _searchUserId = v),
                      decoration: InputDecoration(hintText: 'SEARCH BY USER ID...', prefixIcon: Icon(LucideIcons.search, size: 14)),
                    ),
                  ),
                  const SizedBox(width: 24),
                  ElevatedButton.icon(
                    onPressed: () => _exportTransactions(filtered),
                    icon: Icon(LucideIcons.download, size: 16),
                    label: const Text('EXPORT LOG'),
                    style: ElevatedButton.styleFrom(backgroundColor: EspyTheme.electricBlue, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(child: _buildTransactionTable(filtered)),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildTransactionTable(List<Map<String, dynamic>> txs) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingTextStyle: EspyTheme.cinzelStyle.copyWith(fontSize: 10, color: EspyTheme.gold),
            dataTextStyle: EspyTheme.loraStyle.copyWith(fontSize: 13, color: Colors.white70),
            columnSpacing: 24,
            columns: const [
              DataColumn(label: Text('INVOICE')),
              DataColumn(label: Text('USER ID')),
              DataColumn(label: Text('ORDER DETAILS')),
              DataColumn(label: Text('TOTAL')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('DATE')),
              DataColumn(label: Text('ACTIONS')),
            ],
            rows: txs.map((tx) => _buildTransactionRow(tx)).toList(),
          ),
        ),
      ),
    );
  }

  DataRow _buildTransactionRow(Map<String, dynamic> tx) {
    final status = tx['status'] ?? 'pending';
    final invoice = tx['invoiceNumber'] ?? tx['id'].toString().substring(0, 10);
    
    // Extract Order Details
    final int vis = tx['visibilityDays'] ?? 0;
    final int pins = tx['practicePins'] ?? 0;
    final int slots = tx['serviceSlots'] ?? 0;
    final int bc = tx['broadcasts'] ?? 0;

    String details = '';
    if (vis > 0) details += '$vis Days Vis • ';
    if (pins > 0) details += '$pins Pins • ';
    if (slots > 0) details += '$slots Slots • ';
    if (bc > 0) details += '$bc BC';
    if (details.isEmpty) details = tx['packageName'] ?? 'Unit Top-up';

    return DataRow(
      cells: [
        DataCell(Text('#$invoice', style: const TextStyle(fontWeight: FontWeight.bold, color: EspyTheme.gold, fontSize: 11))),
        DataCell(Text(tx['userId']?.toString().substring(0, 8) ?? '—')),
        DataCell(Text(details, style: const TextStyle(fontSize: 11, color: Colors.white38))),
        DataCell(Text('\$${tx['amount']}', style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(AdminBadge(variant: status == 'completed' ? 'emerald' : (status == 'pending' ? 'gold' : 'danger'), children: Text(status.toUpperCase()))),
        DataCell(Text(tx['createdAt'] != null ? DateFormat('dd MMM HH:mm').format((tx['createdAt'] as Timestamp).toDate()) : '—')),
        DataCell(
          Row(
            children: [
              if (status == 'pending')
                IconButton(
                  icon: Icon(LucideIcons.checkCircle, size: 16, color: Colors.green),
                  onPressed: () => _updateTransactionStatus(tx['id'], 'completed'),
                ),
              IconButton(
                icon: Icon(LucideIcons.trash2, size: 16, color: Colors.redAccent),
                onPressed: () => _deleteTransaction(tx['id']),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _updateTransactionStatus(String id, String status) async {
    try {
      await ref.read(firestoreServiceProvider).updateItem('directory_membership_transactions', id, {'status': status});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaction validated')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _deleteTransaction(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF061226),
        title: const Text('PURGE LOG'),
        content: const Text('Permanently remove this transaction record?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('CANCEL')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent), child: const Text('DELETE')),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(firestoreServiceProvider).deleteItem('directory_membership_transactions', id);
    }
  }

  Future<void> _exportTransactions(List<Map<String, dynamic>> txs) async {
    final headers = ['ID', 'User ID', 'Amount', 'Status', 'Date'];
    final rows = txs.map((t) => [
      t['id'], 
      t['userId'], 
      t['amount'], 
      t['status'], 
      t['createdAt'] != null ? (t['createdAt'] as Timestamp).toDate().toString() : ''
    ]).toList();
    await ExportService.exportToExcel('Transactions_${DateFormat('yyyyMMdd').format(DateTime.now())}', headers, rows);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaction log exported')));
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: EspyTheme.cinzelStyle.copyWith(fontSize: 10, color: Colors.white38)),
                Icon(icon, size: 14, color: color.withOpacity(0.5)),
              ],
            ),
            const Spacer(),
            Text(value, style: EspyTheme.cinzelStyle.copyWith(fontSize: 24, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

final countriesFutureProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(firestoreServiceProvider).getCountries();
});

final sectorsFutureProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(firestoreServiceProvider).getSectors();
});

final regionsFutureProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, countryId) {
  if (countryId == 'ALL') return [];
  return ref.watch(firestoreServiceProvider).getGovernorates(countryId: countryId);
});

final interactionsStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(firestoreServiceProvider).watchInteractions();
});

final unitPricingStreamProvider = StreamProvider<Map<String, dynamic>>((ref) {
  return ref.watch(firestoreServiceProvider).watchUnitPricing();
});

final membershipTransactionsStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(firestoreServiceProvider).watchMembershipTransactions();
});

final walletLedgerStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(firestoreServiceProvider).watchWalletLedger();
});

