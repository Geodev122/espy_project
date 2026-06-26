import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

class ExportService {
  static Future<void> exportToExcel(String fileName, List<String> headers, List<List<dynamic>> rows) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    // Add Headers
    for (var i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).value = TextCellValue(headers[i]);
    }

    // Add Rows
    for (var r = 0; r < rows.length; r++) {
      for (var c = 0; c < rows[r].length; c++) {
        final val = rows[r][c];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r + 1)).value = val == null ? null : TextCellValue(val.toString());
      }
    }

    final bytes = excel.encode();
    if (bytes == null) return;

    if (kIsWeb) {
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', '$fileName.xlsx')
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName.xlsx');
      await file.writeAsBytes(bytes);
    }
  }
}
