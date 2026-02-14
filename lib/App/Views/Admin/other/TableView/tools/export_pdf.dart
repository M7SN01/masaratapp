import 'package:flutter/foundation.dart';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart';
import 'save_file_mobile.dart' if (dart.library.html) '../Tools/save_file_web.dart' as helper;

Future createPdfFile({pw.Widget? pdfHeader, pw.Widget? pdfFooter, required List<String> tableHeader, required List<List<dynamic>> tableData, String pageTitle = "", String pdfName = "", required bool landscapeOrientation}) async {
  // Create a PDF document
  final pdf = pw.Document();

  // Load the custom font
  final fontData = await rootBundle.load("assets/fonts/Arial.ttf");
  final font = pw.Font.ttf(fontData);
  List<int> p;
  try {
    p = await compute(
      (message) {
        pdf.addPage(
          pw.MultiPage(
            maxPages: 1000,
            textDirection: pw.TextDirection.rtl,
            orientation: landscapeOrientation ? PageOrientation.landscape : PageOrientation.portrait,
            margin: const pw.EdgeInsets.all(10),
            header: (context) {
              if (context.pageNumber == 1) {
                return pdfHeader ?? pw.Container();
              } else {
                return pw.Container();
              }
            },
            footer: (context) {
              // if (context.pageNumber == 1) {
              return pdfFooter ?? pw.Container();
              // } else {
              //   return pw.Container();
              // }
            },
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
        return pdf.save();
      },
      "ExportPDF",
    );
    // Save the PDF file
  } catch (e) {
    p = [];
    // print(e);
  }

  String fileName = pdfName != "" ? "$pdfName.pdf" : "${DateTime.now().hour.toString()}-${DateTime.now().minute.toString()}-${DateTime.now().second.toString()}.pdf";
  //Launch file.
  await helper.FileSaveHelper.saveAndLaunchFile(p, fileName);
}
