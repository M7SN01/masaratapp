import 'package:flutter/material.dart';
import '../../Print/direct_print.dart';
import '../pdf_viewer.dart';

class PdfPrintPreviewExample extends StatefulWidget {
  const PdfPrintPreviewExample({super.key});

  @override
  State<PdfPrintPreviewExample> createState() => _PdfPrintPreviewExampleState();
}

double total = 755.0;
double invoiceNumber = 9999.99;

class _PdfPrintPreviewExampleState extends State<PdfPrintPreviewExample> {
  Map<String, dynamic> mapData = {};
  Map<String, String> variables = {};
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        children: [
          ElevatedButton(
            onPressed: () async {
              printJsondirectly(jsonLayout: mapData, variables: {}); // print directly to priniters
            },
            child: const Text("Print directly"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PdfPreviewScreen(
                            jsonLayout: mapData,
                            variables: variables,
                          )));
            },
            child: const Text("Preview PDF"),
          ),
        ],
      ),
    );
  }
}
