import 'package:flutter/material.dart';
import 'package:masaratapp/utils/utils.dart';

import 'save_file_mobile.dart' if (dart.library.html) '../Tools/save_file_web.dart' as helper;
import 'package:excel/excel.dart' as excellib;

Future<void> createExcelFile({required List<String> headers, required List<List<dynamic>> data, String fileName = ""}) async {
  // Create Excel workbook and worksheet
  var excel = excellib.Excel.createExcel();
  var sheet = excel['Sheet1'];

  // Set text direction from right to left for all cells
  // for (var row in sheet.rows) {
  //   for (var cell in row) {
  //     cell.
  //     cellStyle.textDirection = TextDirection.rtl;
  //   }
  // }

  // Write headers
  for (var i = 0; i < headers.length; i++) {
    sheet.cell(excellib.CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: i)).value = excellib.TextCellValue(headers[i]);
    sheet.cell(excellib.CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: i)).cellStyle = excellib.CellStyle(
      bold: true,
      backgroundColorHex: excellib.ExcelColor.fromInt(primaryColor.value),
      fontColorHex: excellib.ExcelColor.fromInt(Colors.white.value),
      horizontalAlign: excellib.HorizontalAlign.Center,
    );
  }

  // Write data
  for (var row = 0; row < data.length; row++) {
    for (var col = 0; col < data[row].length; col++) {
      sheet.cell(excellib.CellIndex.indexByColumnRow(rowIndex: row + 1, columnIndex: col)).value = excellib.TextCellValue(data[row][col].toString());

      sheet.cell(excellib.CellIndex.indexByColumnRow(rowIndex: row + 1, columnIndex: col)).cellStyle = excellib.CellStyle(
        horizontalAlign: excellib.HorizontalAlign.Center,
      );
      sheet.setColumnAutoFit(col);
    }
  }

  // Save Excel file

  List<int>? f = excel.encode();
  if (f != null) await helper.FileSaveHelper.saveAndLaunchFile(f, fileName != "" ? fileName : "${DateTime.now().hour.toString()}-${DateTime.now().minute.toString()}-${DateTime.now().second.toString()}.xlsx");
}
