import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'helpers/json_to_pdf_widgets.dart';

Future<void> printJsondirectly({
  required Map<String, dynamic> jsonLayout,
  required Map<String, dynamic> variables,
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

    final widgets = await renderToPdfWidgets(jsonLayout, variables);

    pdf.addPage(
      pw.MultiPage(
        maxPages: 1000,
        textDirection: pw.TextDirection.rtl,
        orientation: pw.PageOrientation.portrait,
        margin: const pw.EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
        build: (context) => widgets,
      ),
    );

    return pdf.save();
  });
}
