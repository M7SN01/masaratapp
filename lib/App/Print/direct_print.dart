import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'helpers/json_to_pdf_widgets.dart';

Future<void> printJsondirectly({
  Map<String, dynamic>? jsonLayout,
  List<dynamic>? tableHeader,
  List<List<dynamic>>? tableData,
  bool isfromJson = false,
  Map<String, dynamic>? variables,
}) async {
  Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
    final fontData = await rootBundle.load("assets/fonts/Arial.ttf");
    final font = pw.Font.ttf(fontData);
    final pdf = pw.Document(
      //to make font defult for all text in the pdf
      theme: pw.ThemeData.withFont(
        base: font,
        bold: font,
        italic: font,
        boldItalic: font,
      ),
    );
    if (isfromJson) {
      final xWidget = await renderToPdfWidget(jsonLayout ?? {}, variables ?? {});
      pdf.addPage(
        pw.Page(
          // pageFormat: PdfPageFormat(80 * PdfPageFormat.mm, PdfPageFormat.roll80.availableHeight), // or any height,
          textDirection: pw.TextDirection.rtl,
          orientation: pw.PageOrientation.portrait,
          margin: const pw.EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 10),
          build: (context) => xWidget,
        ),
      );
    } else if (tableData != null) {
      pdf.addPage(
        pw.MultiPage(
          maxPages: 1000,
          textDirection: pw.TextDirection.rtl,
          // orientation: landscapeOrientation ? PageOrientation.landscape : PageOrientation.portrait,
          margin: const pw.EdgeInsets.all(10),

          build: (context) {
            return [
              pw.TableHelper.fromTextArray(
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(
                  font: font,
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),

                cellStyle: pw.TextStyle(
                  font: font,
                  fontSize: 10,
                ),
                defaultColumnWidth: const pw.FlexColumnWidth(),
                cellFormat: (index, data) {
                  if (data is num) {
                    final formatter = NumberFormat.currency(locale: 'en_US', symbol: '');
                    return formatter.format(data);
                  }
                  return data.toString();
                },
                headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex('#bdd7ee')),
                cellAlignment: pw.Alignment.centerRight,
                // headerDirection: pw.TextDirection.rtl, //for arabic letter
                headerAlignment: pw.Alignment.centerRight,
                oddRowDecoration: pw.BoxDecoration(color: PdfColor.fromHex('#fce4d7')),
                headers: tableHeader,
                data: tableData,
              )
              // _contentTable(context, headers, data)
            ];
          },
        ),
      );
    } else {
      throw "you must chose json or  pass table data";
    }
    return pdf.save();
  });
}
