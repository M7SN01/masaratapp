import 'package:flutter/material.dart';
import '../helpers/json_to_widgets.dart';

class PdfPrintPreviewExample extends StatefulWidget {
  const PdfPrintPreviewExample({super.key});

  @override
  State<PdfPrintPreviewExample> createState() => _PdfPrintPreviewExampleState();
}

double total = 755.0;
double invoiceNumber = 9999.99;

class _PdfPrintPreviewExampleState extends State<PdfPrintPreviewExample> {
  Map<String, dynamic> mapData = {};

  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            renderWidgetView(mapData), // show on screen
          ],
        ),
      ),
    );
  }
}
