import 'package:pluto_grid/pluto_grid.dart';

Map tableDataToListData({required List<PlutoRow> tableRows, required List<PlutoColumn> tableColumns}) {
  List<String> headerNames = [];
  List<String> headersField = [];
  List<List<dynamic>> rowData = [];

  //set columns Name ans Field into lists
  for (var column in tableColumns) {
    //this column ACTION used to delete  or save  dont print
    if (column.field != "ACTION" && column.title != "") {
      headerNames.add(column.title); // اسم الصنف
      headersField.add(column.field); // NAME
    }
  }

  // Calculate the sum of each column with numeric values
  List<double> columnSums = List.filled(headerNames.length, 0.0);

  List<PlutoRow> exportedRows = tableRows;
  for (PlutoRow row in exportedRows) {
    List<dynamic> rowCells = [];
    //convert list of rows  to  bidirectional List  [0][0]
    //and store sum of numric columns by field
    for (int i = 0; i < headersField.length; i++) {
      String field = headersField[i]; // NAME
      dynamic cellValue = row.cells[field]?.value ?? '';
      if (cellValue is num) {
        columnSums[i] += cellValue;
      }
      rowCells.add(cellValue); //add cell to the row
    }
    rowData.add(rowCells.reversed.toList()); //add row to list of rows
  }

  //summition of the numric column in one Row
  List<dynamic> sumRow = [];
  for (int i = 0; i < headerNames.length; i++) {
    if (columnSums[i] == 0) {
      sumRow.add("");
    } else {
      sumRow.add(columnSums[i]);
    }
  }

  //add as last row of the rows
  rowData.add(sumRow.reversed.toList());

  return {
    'tableColumns': headerNames.reversed.toList(),
    'tableRows': rowData,
  };

  // await createPdfFile(
  //   /*pdfHeader: pdfHeader, pdfFooter: pdfFooter, pageTitle: pdfTitle,*/
  //   landscapeOrientation: false,
  //   tableHeader: headerNames.reversed.toList(),
  //   tableData: rowData,
  // );
}
