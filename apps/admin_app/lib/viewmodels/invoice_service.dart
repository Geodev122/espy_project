import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class InvoiceService {
  static Future<void> generateAndDownloadA5Invoice(Map<String, dynamic> tx) async {
    final pdf = pw.Document();

    final String invoiceNo = tx['invoiceNumber'] ?? tx['id'].toString().substring(0, 10);
    
    DateTime? date;
    if (tx['createdAt'] != null) {
      if (tx['createdAt'] is DateTime) {
        date = tx['createdAt'];
      } else if (tx['createdAt'] is String) {
        date = DateTime.tryParse(tx['createdAt']);
      } else {
        // Handle Firestore Timestamp or RTDB double
        try {
          date = (tx['createdAt'] as dynamic).toDate();
        } catch (_) {
          try {
            date = DateTime.fromMillisecondsSinceEpoch(tx['createdAt'] as int);
          } catch (__) {}
        }
      }
    }
    date ??= DateTime.now();
    
    final String dateStr = DateFormat('dd MMM yyyy').format(date);
    
    final int vis = tx['visibilityDays'] ?? 0;
    final int pins = tx['practicePins'] ?? 0;
    final int slots = tx['serviceSlots'] ?? 0;
    final int bc = tx['broadcasts'] ?? 0;
    final double amount = double.tryParse(tx['amount']?.toString() ?? '0') ?? 0.0;

    // Load assets if needed (e.g. Logo)
    // final logo = await rootBundle.load('assets/images/espy_icon.png');
    // final logoImage = pw.MemoryImage(logo.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("ESPY PROTOCOL", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                      pw.Text("OFFICIAL FISCAL RECEIPT", style: pw.TextStyle(fontSize: 8, color: PdfColors.grey700, letterSpacing: 1.2)),
                    ],
                  ),
                  pw.Container(
                    width: 40, height: 40,
                    decoration: const pw.BoxDecoration(color: PdfColors.blue900, shape: pw.BoxShape.circle),
                    child: pw.Center(child: pw.Text("E", style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 20))),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Divider(thickness: 1, color: PdfColors.grey300),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("INVOICE REFERENCE:", style: pw.TextStyle(fontSize: 7, color: PdfColors.grey600)),
                      pw.Text("#$invoiceNo", style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text("DATE OF SETTLEMENT:", style: pw.TextStyle(fontSize: 7, color: PdfColors.grey600)),
                      pw.Text(dateStr, style: pw.TextStyle(fontSize: 9)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Text("PROTOCOL EXTENSION BREAKDOWN", style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800)),
              pw.SizedBox(height: 10),
              pw.Table(
                border: const pw.TableBorder(bottom: pw.BorderSide(color: PdfColors.grey200, width: 0.5)),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey400, width: 1))),
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 5), child: pw.Text("DESCRIPTION", style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold))),
                      pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 5), child: pw.Text("UNITS", style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
                    ],
                  ),
                  if (vis > 0)
                    pw.TableRow(children: [
                      pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 8), child: pw.Text("Network Visibility Extension", style: const pw.TextStyle(fontSize: 8))),
                      pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 8), child: pw.Text("$vis Days", style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                    ]),
                  if (slots > 0)
                    pw.TableRow(children: [
                      pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 8), child: pw.Text("Care Protocol Service Slots", style: const pw.TextStyle(fontSize: 8))),
                      pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 8), child: pw.Text("$slots Units", style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                    ]),
                  if (pins > 0)
                    pw.TableRow(children: [
                      pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 8), child: pw.Text("Geographical Presence Nodes (Pins)", style: const pw.TextStyle(fontSize: 8))),
                      pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 8), child: pw.Text("$pins Units", style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                    ]),
                  if (bc > 0)
                    pw.TableRow(children: [
                      pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 8), child: pw.Text("Global Broadcast Credits", style: const pw.TextStyle(fontSize: 8))),
                      pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 8), child: pw.Text("$bc Units", style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center)),
                    ]),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text("TOTAL SETTLEMENT", style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey700)),
                      pw.Text("\$${amount.toStringAsFixed(2)} USD", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                      pw.SizedBox(height: 4),
                      pw.Text("Status: COMPLETED / VERIFIED", style: pw.TextStyle(fontSize: 6, color: PdfColors.green700, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              pw.Spacer(),
              pw.Divider(thickness: 0.5, color: PdfColors.grey300),
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text("Hope Bearer Award Support Suite", style: pw.TextStyle(fontSize: 7, color: PdfColors.grey600, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 2),
                    pw.Text("This is an electronically generated document. No signature required.", style: pw.TextStyle(fontSize: 6, color: PdfColors.grey500, fontStyle: pw.FontStyle.italic)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Invoice_$invoiceNo.pdf',
    );
  }
}
