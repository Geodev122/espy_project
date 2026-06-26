import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';

import 'package:shared_core/theme/espy_theme.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/services/firestore_service.dart';
import '../../widgets/common/premium_card.dart';
import 'package:shared_core/services/invoice_service.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  bool _ascending = false;
  String _selectedMonth = 'ALL';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final firestore = FirestoreService();
    final String? userId = auth.user?.uid;

    return Scaffold(
      backgroundColor: EspyTheme.platinum,
      appBar: AppBar(
        title: const Text("PAYMENT PROTOCOLS"),
        elevation: 0,
        actions: [
          _buildMonthFilter(),
          IconButton(
            icon: Icon(_ascending ? Icons.north_rounded : Icons.south_rounded, size: 18),
            onPressed: () => setState(() => _ascending = !_ascending),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: userId == null
          ? const Center(child: Text("Authorized personnel only."))
          : Container(
              decoration: const BoxDecoration(gradient: EspyTheme.lightBlueFlame),
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: firestore.getUserTransactions(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: EspyTheme.gold));
                  }

                  List<Map<String, dynamic>> txs = snapshot.data ?? [];

                  if (_selectedMonth != 'ALL') {
                     txs = txs.where((t) {
                       final date = t['createdAt'] != null ? (t['createdAt'] is Timestamp ? (t['createdAt'] as Timestamp).toDate() : DateTime.tryParse(t['createdAt'].toString())) : null;
                       if (date == null) return false;
                       return DateFormat('MMM').format(date).toUpperCase() == _selectedMonth;
                     }).toList();
                  }

                  txs.sort((a, b) {
                    final da = (a['createdAt'] != null ? (a['createdAt'] is Timestamp ? (a['createdAt'] as Timestamp).toDate() : DateTime.tryParse(a['createdAt'].toString())) : null) ?? DateTime(0);
                    final db = (b['createdAt'] != null ? (b['createdAt'] is Timestamp ? (b['createdAt'] as Timestamp).toDate() : DateTime.tryParse(b['createdAt'].toString())) : null) ?? DateTime(0);
                    return _ascending ? da.compareTo(db) : db.compareTo(da);
                  });

                  if (txs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long_rounded, size: 64, color: EspyTheme.navyDeep.withValues(alpha: 0.1)),
                          const SizedBox(height: 16),
                          Text(
                            "NO TRANSACTION LOGS",
                            style: GoogleFonts.cinzel(color: EspyTheme.navyDeep.withValues(alpha: 0.3), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: txs.length,
                    itemBuilder: (context, index) {
                      final tx = txs[index];
                      final bool isCompleted = tx['status'] == 'completed';
                      final bool isFailed = tx['status'] == 'failed' || tx['status'] == 'rejected';
                      
                      final invoice = tx['invoiceNumber'] ?? tx['id']?.toString().substring(0, 10) ?? 'N/A';
                      final date = tx['createdAt'] != null ? (tx['createdAt'] is Timestamp ? (tx['createdAt'] as Timestamp).toDate() : DateTime.tryParse(tx['createdAt'].toString())) : null;
                      final dateStr = date != null ? DateFormat('dd MMM yyyy HH:mm').format(date) : 'N/A';

                      final int vis = tx['visibilityDays'] ?? 0;
                      final int pins = tx['practicePins'] ?? 0;
                      final int slots = tx['serviceSlots'] ?? 0;
                      
                      List<String> parts = [];
                      if (vis > 0) parts.add("$vis DAYS VISIBILITY");
                      if (pins > 0) parts.add("$pins EXTRA PINS");
                      if (slots > 0) parts.add("$slots EXTRA SLOTS");
                      final details = parts.isEmpty ? (tx['packageName'] ?? 'Unit Top-up') : parts.join(' • ');

                      return FadeInUp(
                        delay: Duration(milliseconds: index * 100),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: PremiumCard(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("INVOICE #$invoice", style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.gold)),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: (isCompleted ? EspyTheme.success : (isFailed ? EspyTheme.error : EspyTheme.warning)).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        tx['status']?.toString().toUpperCase() ?? 'PENDING',
                                        style: GoogleFonts.cinzel(fontSize: 8, fontWeight: FontWeight.w900, color: isCompleted ? EspyTheme.success : (isFailed ? EspyTheme.error : EspyTheme.gold)),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  details.toString().toUpperCase(),
                                  style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w700, color: EspyTheme.navyDeep),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dateStr,
                                  style: GoogleFonts.lora(fontSize: 10, color: Colors.black38, fontStyle: FontStyle.italic),
                                ),
                                const Divider(height: 32, color: Colors.black12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("TOTAL PROTOCOL COST", style: GoogleFonts.cinzel(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black26)),
                                    Text("\$${tx['amount']}", style: GoogleFonts.cinzel(fontSize: 18, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep)),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: isCompleted ? () => _generateAndDownloadInvoice(tx) : null,
                                    icon: const Icon(Icons.picture_as_pdf_rounded, size: 16),
                                    label: Text("GENERATE INVOICE", style: GoogleFonts.cinzel(fontSize: 9, fontWeight: FontWeight.bold)),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: EspyTheme.royalBlue,
                                      side: const BorderSide(color: EspyTheme.royalBlue),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
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
            ),
    );
  }

  Widget _buildMonthFilter() {
    final months = ['ALL', 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _selectedMonth,
        items: months.map((m) => DropdownMenuItem(value: m, child: Text(m, style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold)))).toList(),
        onChanged: (v) => setState(() => _selectedMonth = v!),
        dropdownColor: EspyTheme.platinum,
      ),
    );
  }

  Future<void> _generateAndDownloadInvoice(Map<String, dynamic> tx) async {
     await InvoiceService.generateAndDownloadA5Invoice(tx);
  }
}
