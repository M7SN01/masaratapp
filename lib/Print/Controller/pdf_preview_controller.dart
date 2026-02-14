import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class PreviewController extends GetxController {
  String selectedFont = 'NotoNaskhArabic';

  final List<String> fontNames = [
    'NotoNaskhArabic',
    'Cairo',
    'Amiri',
    'Tajawal',
  ];

  Future<pw.Font> getPdfFontByName(String name) async {
    switch (name) {
      case 'NotoNaskhArabic':
        return await PdfGoogleFonts.notoNaskhArabicRegular();
      case 'Cairo':
        return await PdfGoogleFonts.cairoRegular();
      case 'Amiri':
        return await PdfGoogleFonts.amiriRegular();
      case 'Tajawal':
        return await PdfGoogleFonts.tajawalRegular();
      default:
        return await PdfGoogleFonts.notoNaskhArabicRegular();
    }
  }

  Future<pw.Font> getPdfBoldFontByName(String name) async {
    switch (name) {
      case 'NotoNaskhArabic':
        return await PdfGoogleFonts.notoNaskhArabicBold();
      case 'Cairo':
        return await PdfGoogleFonts.cairoBold();
      case 'Amiri':
        return await PdfGoogleFonts.amiriBold();
      case 'Tajawal':
        return await PdfGoogleFonts.tajawalBold();
      default:
        return await PdfGoogleFonts.notoNaskhArabicBold();
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
