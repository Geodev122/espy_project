import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:espy_core/espy_core.dart';
import '../../../theme/espy_theme.dart';
import '../../../viewmodels/finance_view_model.dart';
import '../../../widgets/common/premium_button.dart';
import '../../../widgets/common/premium_card.dart';
import '../../../widgets/common/espy_scaffold.dart';

class FinanceManagerScreen extends StatelessWidget {
  const FinanceManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FinanceViewModel(context.read<EspyRepository>()),
      child: const _FinanceManagerView(),
    );
  }
}

class _FinanceManagerView extends StatefulWidget {
  const _FinanceManagerView();

  @override
  State<_FinanceManagerView> createState() => _FinanceManagerViewState();
}

class _FinanceManagerViewState extends State<_FinanceManagerView> {
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    Provider.of<FinanceViewModel>(context, listen: false).loadStats(
      start: _selectedDateRange?.start,
      end: _selectedDateRange?.end,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<FinanceViewModel>(context);

    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(
        title: Text("FINANCE & ECONOMY GOVERNANCE", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
        backgroundColor: Colors.white,
        foregroundColor: EspyTheme.navyDeep,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: _selectDateRange,
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded, color: Colors.green),
            onPressed: vm.exportToExcel,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            // Top Stats
            Row(
              children: [
                Expanded(child: _buildStatCard("TOTAL REVENUE", "\$${vm.totalRevenue.toStringAsFixed(2)}", Icons.monetization_on, Colors.green)),
                const SizedBox(width: 24),
                Expanded(child: _buildStatCard("NET PROFIT", "\$${vm.netProfit.toStringAsFixed(2)}", Icons.account_balance_wallet, EspyTheme.gold)),
                const SizedBox(width: 24),
                Expanded(child: _buildStatCard("TOKENS BURNED", vm.totalTokensSpent.toStringAsFixed(0), Icons.local_fire_department, Colors.orange)),
              ],
            ),
            const SizedBox(height: 32),

            // Middle Section: Charts & Profit Slider
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildRevenueChart(vm)),
                const SizedBox(width: 32),
                Expanded(flex: 1, child: _buildProfitCenter(vm)),
              ],
            ),

            const SizedBox(height: 32),
            
            // Transactions Table
            PremiumCard(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text("RECENT TRANSACTIONS", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 16)),
                  ),
                  const Divider(height: 1),
                  SizedBox(
                    height: 500,
                    child: vm.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildTransactionsTable(vm),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return PremiumCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black38, letterSpacing: 1)),
              Text(value, style: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(FinanceViewModel vm) {
    final data = vm.getDailyRevenueData();
    if (data.isEmpty) return const PremiumCard(padding: EdgeInsets.all(32), child: Center(child: Text("NO REVENUE DATA FOR CHART")));

    return PremiumCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("REVENUE TRENDS", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14, color: EspyTheme.navyDeep)),
          const SizedBox(height: 32),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                    LineChartBarData(
                    spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value['value'].toDouble())).toList(),
                    isCurved: true,
                    color: EspyTheme.royalBlue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true, 
                      gradient: LinearGradient(
                        colors: [EspyTheme.royalBlue.withValues(alpha: 0.3), EspyTheme.royalBlue.withValues(alpha: 0.0)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfitCenter(FinanceViewModel vm) {
    return PremiumCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("PROFIT CENTER", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14, color: EspyTheme.navyDeep)),
          const SizedBox(height: 16),
          Text("Operational Cost: ${(vm.operationalCostPercentage * 100).toInt()}%", style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.bold)),
          Slider(
            value: vm.operationalCostPercentage,
            min: 0, max: 1.0,
            activeColor: EspyTheme.gold,
            onChanged: (val) => vm.updateOpCost(val),
          ),
          const Divider(),
          const SizedBox(height: 8),
          _profitRow("GROSS REVENUE", "\$${vm.totalRevenue.toStringAsFixed(2)}", Colors.black54),
          _profitRow("OPERATIONAL COST", "-\$${(vm.totalRevenue * vm.operationalCostPercentage).toStringAsFixed(2)}", Colors.redAccent),
          const SizedBox(height: 8),
          _profitRow("NET PROFIT", "\$${vm.netProfit.toStringAsFixed(2)}", EspyTheme.success, isBold: true),
        ],
      ),
    );
  }

  Widget _profitRow(String label, String value, Color color, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.montserrat(fontSize: 9, fontWeight: isBold ? FontWeight.w900 : FontWeight.w600, color: Colors.black45)),
          Text(value, style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }

  Widget _buildTransactionsTable(FinanceViewModel vm) {
    if (vm.transactions.isEmpty) {
      return const Center(child: Text("No transactions found for the selected period."));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columnSpacing: 24,
        columns: [
          DataColumn(label: Text("DATE", style: _columnStyle())),
          DataColumn(label: Text("TYPE", style: _columnStyle())),
          DataColumn(label: Text("AMOUNT", style: _columnStyle())),
          DataColumn(label: Text("DESCRIPTION", style: _columnStyle())),
          DataColumn(label: Text("ACTIONS", style: _columnStyle())),
        ],
        rows: vm.transactions.map((t) => DataRow(
          cells: [
            DataCell(Text(DateFormat('MMM dd, HH:mm').format(t.createdAt))),
            DataCell(_buildTypeBadge(t.type)),
            DataCell(Text(t.amount.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: t.amount > 0 ? Colors.green : Colors.red))),
            DataCell(Text(t.description ?? '')),
            DataCell(Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 18, color: Colors.red),
                  onPressed: () => vm.downloadInvoice(t),
                ),
                if (t.type == TransactionType.purchase)
                  IconButton(
                    icon: const Icon(Icons.replay_circle_filled_rounded, size: 18, color: Colors.orange),
                    onPressed: () => _showRefundDialog(context, t, vm),
                  ),
              ],
            )),
          ],
        )).toList(),
      ),
    );
  }

  TextStyle _columnStyle() => GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black45);

  Widget _buildTypeBadge(dynamic type) {
    String label = type.name.toUpperCase();
    Color color = EspyTheme.royalBlue;
    if (label == 'RECHARGE') color = Colors.green;
    if (label == 'PURCHASE') color = Colors.orange;
    if (label == 'REFUND') color = Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color)),
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
    );
    if (picked != null) {
      setState(() => _selectedDateRange = picked);
      _loadData();
    }
  }

  void _showRefundDialog(BuildContext context, WalletTransactionModel t, FinanceViewModel vm) {
    final reason = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("PROCESS REFUND"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Refunding ${t.amount.abs()} tokens for transaction ${t.id.substring(0, 8)}"),
            const SizedBox(height: 16),
            TextField(controller: reason, decoration: const InputDecoration(labelText: "Refund Reason")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
            onPressed: () async {
               await vm.refundTransaction(t.id, reason.text);
               if (mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("REFUND TOKENS"),
          ),
        ],
      ),
    );
  }
}
