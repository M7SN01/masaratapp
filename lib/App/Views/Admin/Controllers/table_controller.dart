import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:masaratapp/App/Controllers/user_controller.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../Print/pdf_viewer.dart';
import '../../../../Services/api_db_services.dart';
import '../../../../Widget/widget.dart';
import '../../../../samples/slmaples.dart';
import '../../../../utils/utils.dart';
import '../other/TableView/tools/export_excel.dart';

class TableController extends GetxController {
  final Services dbServices = Services();
  late UserController userController;
  String uName = "";
  bool postingQuery = false;
  TextEditingController pdfName = TextEditingController();
  TextEditingController addedColumnNameController = TextEditingController();
  Map<String, dynamic> appDefault = {};

  bool isFullScreenMode = false;
  // late PlutoGridStateManager stateManager;
  //

  bool isLoadingPdf = false;
  bool isLoadingExcel = false;
  bool isCanAddColumn = true;

  void setLoadingPdf(bool loading) {
    isLoadingPdf = loading;
    update();
  }

  void setLoadingExcel(bool loading) {
    isLoadingExcel = loading;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    userController = Get.find<UserController>();
    uName = userController.uName;
  }

  @override
  void onClose() {
    // stateManager.dispose();
    super.onClose();
  }

  //--

  postColName({required String col, required String repID, required List<PlutoColumn> postColumns}) async {
    List<String> showedColumns = [];
    // uName
    for (var column in postColumns) {
      if (column.hide == false) {
        showedColumns.add(column.field);
      }
    }

    postingQuery = true;
    update();
    var s = await dbServices.createRep(
      sqlStatment: "select 1 from ORCA.APP_DEFAULT where REP_ID='$repID'",
    );
    if (s.isEmpty) {
      await dbServices.createRep(
        sqlStatment: "INSERT INTO  ORCA.APP_DEFAULT(REP_ID,USER_NAME,$col) VALUES('$repID','$uName','${showedColumns.map((e) => e).join(',')}')",
      );

      // print(appDefault[repID][col]);
      // print("INSERT INTO  ORCA.APP_DEFAULT(REP_ID,USER_NAME,$col) VALUES('$repID','$uName','${showedColumns.map((e) => e).join(',')}')");

      //Local update of app default
      if (appDefault.containsKey(repID)) {
        if (appDefault[repID]!.containsKey(col)) {
          appDefault[repID]![col] = showedColumns.map((e) => e).join(',').toString();
        } else {
          appDefault[repID] = {col: showedColumns.map((e) => e).join(',').toString()};
        }
      } else {
        appDefault[repID] = {col: showedColumns.map((e) => e).join(',').toString()};
      }
      postingQuery = false;
      update();
    } else {
      await dbServices.createRep(
        sqlStatment: "UPDATE ORCA.APP_DEFAULT set $col='${showedColumns.map((e) => e).join(',')}'  WHERE REP_ID='$repID' AND USER_NAME ='$uName' ",
      );

      // print("old    ${showedColumns.map((e) => e).join(',')}");
      // print("new    ${appDefault[repID][col]}");
      // print("UPDATE ORCA.APP_DEFAULT set $col='${showedColumns.map((e) => e).join(',')}'  WHERE REP_ID='$repID' AND uName ='$User_ID' ");

      if (appDefault.containsKey(repID)) {
        if (appDefault[repID]!.containsKey(col)) {
          appDefault[repID]![col] = showedColumns.map((e) => e).join(',').toString();
        } else {
          appDefault[repID] = {col: showedColumns.map((e) => e).join(',').toString()};
        }
      } else {
        appDefault[repID] = {col: showedColumns.map((e) => e).join(',').toString()};
      }
      postingQuery = false;
      update();
    }
  }

  postColSize({required String repID, required List<PlutoColumn> postColumns}) async {
    List<String> showedColumnsSize = [];
    // uName
    for (var column in postColumns) {
      showedColumnsSize.add(column.width.toString());
      // print(column.width);
    }
    postingQuery = true;
    update();

    var s = await dbServices.createRep(
      sqlStatment: "select 1 from ORCA.APP_DEFAULT where REP_ID='$repID'",
    );
    if (s.isEmpty) {
      await dbServices.createRep(
        sqlStatment: "INSERT INTO  ORCA.APP_DEFAULT(REP_ID,USER_NAME,SIZE_DEFAULT) VALUES('$repID','$uName','${showedColumnsSize.map((e) => e).join(',')}')",
      );
      // print("INSERT INTO  ORCA.APP_DEFAULT(REP_ID,USER_NAME,SIZE_DEFAULT) VALUES('$repID','$USER_NAME','${showedColumnsSize.map((e) => e).join(',')}')");

      //Local update
      if (appDefault.containsKey(repID)) {
        if (appDefault[repID]!.containsKey("SIZE_DEFAULT")) {
          appDefault[repID]!["SIZE_DEFAULT"] = showedColumnsSize.map((e) => e).join(',').toString();
        } else {
          appDefault[repID] = {"SIZE_DEFAULT": showedColumnsSize.map((e) => e).join(',').toString()};
        }
      } else {
        appDefault[repID] = {"SIZE_DEFAULT": showedColumnsSize.map((e) => e).join(',').toString()};
      }
      // appDefault[repID]["SIZE_DEFAULT"] = showedColumnsSize.map((e) => e).join(',');
      postingQuery = false;
      update();
    } else {
      await dbServices.createRep(
        sqlStatment: "UPDATE ORCA.APP_DEFAULT set SIZE_DEFAULT='${showedColumnsSize.map((e) => e).join(',')}'  WHERE REP_ID='$repID' AND USER_NAME ='$uName' ",
      );
      // print("UPDATE ORCA.APP_DEFAULT set $col='${showedColumns.map((e) => e).join(',')}'  WHERE REP_ID='$repID' AND uName ='$User_ID' ");

      if (appDefault.containsKey(repID)) {
        if (appDefault[repID]!.containsKey("SIZE_DEFAULT")) {
          appDefault[repID]!["SIZE_DEFAULT"] = showedColumnsSize.map((e) => e).join(',').toString();
        } else {
          appDefault[repID] = {"SIZE_DEFAULT": showedColumnsSize.map((e) => e).join(',').toString()};
        }
      } else {
        appDefault[repID] = {"SIZE_DEFAULT": showedColumnsSize.map((e) => e).join(',').toString()};
      }
      // appDefault[widget.repID]["SIZE_DEFAULT"] = showedColumnsSize.map((e) => e).join(',');
      postingQuery = false;
      update();
    }
  }

//
//
  Map<String, dynamic> getVariablesData({required List<PlutoColumn> columns, required List<PlutoRow> rows, String? pdfTitle}) {
    List<Map<String, dynamic>> rowsTmpList = [];
    List<String> headerList = [];
    Map<String, dynamic> fotterMaptotals = {};
    //
    //
    //only header in the appare columns
    for (var column in columns) {
      if (!column.hide) {
        headerList.add(column.title);
        //initilize fotter cells
        if (column.type is PlutoColumnTypeCurrency) {
          fotterMaptotals[column.field] = 0.0;
        } else {
          fotterMaptotals[column.field] = "";
        }
      }
    }

    for (var row in rows) {
      Map<String, dynamic> rowMap = {};
      //only row in the appare columns
      for (var column in columns) {
        if (!column.hide) {
          rowMap[column.field] = row.cells[column.field]?.value;
          if (column.type is PlutoColumnTypeCurrency) {
            fotterMaptotals[column.field] += row.cells[column.field]?.value ?? 0.0;
          }
        }
      }
      rowsTmpList.add(rowMap);
    }
    //last Row---
    rowsTmpList.add(fotterMaptotals.map(
      (key, value) {
        return MapEntry(key, formatCurrency(value.toString()));
      },
    ));
    //

    return {
      "a_comp_name": userController.compData.aCompName,
      "a_activity": userController.compData.aActivity,
      "commercial_reg": userController.compData.commercialReg,
      "tax_no": userController.compData.taxNo,
      "mobile_no": userController.compData.tel,
      "e_comp_name": userController.compData.eCompName,
      "e_activity": userController.compData.eActivity,
      //
      "title": pdfTitle,
      //
      "header_list": headerList,
      "repeat_element": rowsTmpList,
    };
  }

  void exportToPDF({required List<PlutoColumn> columns, required List<PlutoRow> rows, String? pdfTitle}) {
    if (rows.isEmpty) {
      showMessage(color: secondaryColor, titleMsg: "لايوجد بيانات لطباعتها !", durationMilliseconds: 1000);
    } else {
      PrintSamples ps = PrintSamples(compData: userController.compData);
      Get.to(() => PdfPreviewScreen(
            jsonLayout: ps.getGenralSample,
            variables: getVariablesData(columns: columns, rows: rows, pdfTitle: pdfTitle),
          ));
    }
  }

  void exportToExcel({required List<PlutoColumn> columns, required List<PlutoRow> rows}) {
    if (rows.isEmpty) {
      showMessage(color: secondaryColor, titleMsg: "لايوجد بيانات لطباعتها !", durationMilliseconds: 1000);
    } else {
      setLoadingExcel(true);

      List<String> headers = [];
      List<String> headersField = [];
      //-----------------------------------------EXCEL Defult Setting---------------------------------------

      List<PlutoColumnToCopy> tempColumn = columns.map((col) => PlutoColumnToCopy(title: col.title, field: col.field, hide: col.hide)).toList();
      // if (defultExcel != []) {
      //   for (var columm in tempColumn) {
      //     if (defultExcel.contains(columm.field) || columm.field == "AddedColumn") {
      //       columm.hide = false;
      //     } else {
      //       columm.hide = true;
      //     }
      //   }
      // }
      //-------------------------------------------------------------------------------------------------
      for (var column in tempColumn) {
        if (!column.hide) {
          headers.add(column.title);
          headersField.add(column.field);
        }
      }

      List<List<dynamic>> rowData = [];

      for (var row in rows) {
        List<dynamic> rowCells = [];
        for (int i = 0; i < headersField.length; i++) {
          String field = headersField[i];
          dynamic cellValue = row.cells[field]?.value ?? ''; // Get cell value if exists, otherwise empty string
          rowCells.add(cellValue);
        }
        rowData.add(rowCells.reversed.toList());
      }

      // to export only the selected rows-----------------------------------------------------------------
      List<PlutoRow> checkedRows = [];
      for (var row in rows) {
        if (row.checked == true) {
          checkedRows.add(row);
        }
      }
      List<PlutoRow> exportedRows = checkedRows.isEmpty ? rows : checkedRows;
      //----------------------------------------------------------------------------------------------

      for (PlutoRow row in exportedRows) {
        if (row.type.isGroup) {
          if (row.type.group.expanded) {
            List<dynamic> rowCells = [];
            for (int i = 0; i < headersField.length; i++) {
              String field = headersField[i];
              dynamic cellValue = row.cells[field]?.value ?? '';
              //  if (cellValue is num) {
              //   columnSums[i] += cellValue;
              // }
              rowCells.add(cellValue);
            }
            rowData.add(rowCells.reversed.toList());
          } else {
            for (PlutoRow row in row.type.group.children) {
              List<dynamic> rowCells = [];
              for (int i = 0; i < headersField.length; i++) {
                String field = headersField[i];
                dynamic cellValue = row.cells[field]?.value ?? '';
                // if (cellValue is num) {
                //   columnSums[i] += cellValue;
                // }
                rowCells.add(cellValue);
              }
              rowData.add(rowCells.reversed.toList());
            }
          }
        } else {
          List<dynamic> rowCells = [];
          for (int i = 0; i < headersField.length; i++) {
            String field = headersField[i];
            dynamic cellValue = row.cells[field]?.value ?? '';
            // if (cellValue is num) {
            //   columnSums[i] += cellValue;
            // }
            rowCells.add(cellValue);
          }
          rowData.add(rowCells.reversed.toList());
        }

        // List<dynamic> rowCells = [];
        // for (int i = 0; i < headersField.length; i++) {
        //   String field = headersField[i];
        //   dynamic cellValue = row.cells[field]?.value ?? ''; // Get cell value if exists, otherwise empty string
        //   if (cellValue is num) {
        //     // Check if the cell value is numeric
        //     columnSums[i] += cellValue;
        //   }
        //   rowCells.add(cellValue);
        // }
        // rowData.add(rowCells.reversed.toList());
        //}
      }

      createExcelFile(headers: headers.reversed.toList(), data: rowData);
      setLoadingExcel(false);
    }
  }

  void handleAddColumns(PlutoGridStateManager stateManager) {
    // if (!isAddedColumn) return;

    int columnIndx = 0;
    final PlutoColumn addedColumn = PlutoColumn(
      title: addedColumnNameController.text == "" ? "عمود اضافي" : addedColumnNameController.text,
      field: 'AddedColumn',
      textAlign: PlutoColumnTextAlign.center,
      titleTextAlign: PlutoColumnTextAlign.center,
      backgroundColor: primaryColor,
      type: PlutoColumnType.text(),
      enableEditingMode: true,
      enableSorting: false,
      enableFilterMenuItem: false,
      enableAutoEditing: true,
      enableContextMenu: false,
      titleSpan: TextSpan(
        children: [
          WidgetSpan(
              child: GestureDetector(
            child: Container(
              color: Colors.transparent,
              height: 50,
              child: Center(
                  child: Text(
                addedColumnNameController.text.trim().isNotEmpty ? addedColumnNameController.text : "عمود اضافي",
                style: TextStyle(color: Colors.white),
              )),
            ),
            onTap: () {
              Get.dialog(
                  useSafeArea: true,
                  AlertDialog(
                    insetPadding: const EdgeInsets.all(0),
                    contentPadding: const EdgeInsets.all(0),
                    content: SizedBox(
                      height: 60,
                      width: (Get.width / 4) * 3,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(width: 1, color: Colors.black),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(2),
                        child: TextFormField(
                          textAlignVertical: const TextAlignVertical(y: -0.8),
                          controller: addedColumnNameController,
                          decoration: const InputDecoration(
                            labelText: "اسم العمود",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            addedColumnNameController.text = value;
                            stateManager.columns[columnIndx].title = value;
                          },
                        ),
                      ),
                    ),
                  ));
            },
          )),
        ],
      ),
    );

    stateManager.insertColumns(
      columnIndx, //stateManager.bodyColumns.length
      [addedColumn],
    );

    isCanAddColumn = false;
  }

  void handleRemoveCurrentColumnButton(PlutoGridStateManager stateManager) {
    // final currentColumn = stateManager.currentColumn;
    // stateManager.columns.removeWhere((element) => element.field == "AddedColumn");
    stateManager.removeColumns(stateManager.columns.where((element) => element.field == "AddedColumn").toList());

    isCanAddColumn = true;
  }

//
  //
  TextSpan customMultiLineColumn(List<String> wordInLine) {
    return TextSpan(
      children: [
        WidgetSpan(
          child: Column(
            children: [
              for (int i = 0; i < wordInLine.length; i++)
                Text(
                  wordInLine[i],
                  style: const TextStyle(color: Colors.white),
                ),
            ],
          ),
        ),
      ],
    );
  }

  WidgetSpan autoMultiLineColumn(String title) {
    return WidgetSpan(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

/*
  double getSumOfAllCells1to12(List<PlutoRow> rows) {
    double totalSum = 0;

    // Iterate over each PlutoRow
    for (var row in rows) {
      // Iterate over cells from 1 to 12
      for (int i = 1; i <= 12; i++) {
        // Get the value of the cell
        // print(row.cells[i]!.value);
        var cellValue = row.cells["$i"]!.value; //row.cells[i /*i.toString().padLeft(2, '0')*/]!.value;

        // If cellValue is not null, add it to totalSum
        if (cellValue != null) {
          totalSum += double.parse(cellValue.toString());
        }
      }
    }

    return totalSum;
  }
*/
  double getSumOfAllCellsByFiled(List<PlutoRow> rows, String filed) {
    double totalSum = 0;

    // Iterate over each PlutoRow
    for (var row in rows) {
      var cellValue = row.cells[filed]!.value;
      // If cellValue is not null, add it to totalSum
      if (cellValue != null && cellValue != "") {
        totalSum += double.parse(cellValue.toString());
      }
    }

    return totalSum;
  }

  List<PlutoColumnGroup> createColumnTitleGroup(List<String> ls, {String title = ""}) {
    return [
      PlutoColumnGroup(
        title: "",
        fields: ls,
        backgroundColor: primaryColor,
        titleTextAlign: PlutoColumnTextAlign.right,
        titleSpan: WidgetSpan(
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      )
    ];
  }

  List<PlutoColumnGroup> createColumnGroup(List<String> ls, List<PlutoRow> rows, {String title = ""}) {
    List<PlutoColumnGroup> totals = [];
    for (var element in ls) {
      totals.add(PlutoColumnGroup(
        title: "",
        fields: [element],
        backgroundColor: primaryColor,
        titleTextAlign: PlutoColumnTextAlign.right,
        titleSpan: WidgetSpan(
          child: Text(
            formatCurrency(getSumOfAllCellsByFiled(rows, element).toString()),
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ));
    }
    return totals;
  }

  List<PlutoColumn> columnsdefualt({required List<PlutoColumn> columns, required List<String> showColList, required List<String> sizeColList}) {
    //ReOrder
    if (showColList.isNotEmpty) {
      Map<String, int> fieldOrderMap = {};
      for (int i = 0; i < showColList.length; i++) {
        fieldOrderMap[showColList[i]] = i;
      }
      // Sort columns based on the fieldOrderMap
      // _columns.sort((a, b) => fieldOrderMap[a.field]!.compareTo(fieldOrderMap[b.field]!));
      columns.sort((a, b) {
        // Check if both fields are in the desiredOrder
        bool aInDesiredOrder = fieldOrderMap.containsKey(a.field);
        bool bInDesiredOrder = fieldOrderMap.containsKey(b.field);

        // Both fields are in the desiredOrder
        if (aInDesiredOrder && bInDesiredOrder) {
          return fieldOrderMap[a.field]!.compareTo(fieldOrderMap[b.field]!);
        }
        // Field a is in the desiredOrder, and field b is not
        else if (aInDesiredOrder) {
          return -1; // a should come before b
        }
        // Field b is in the desiredOrder, and field a is not
        else if (bInDesiredOrder) {
          return 1; // b should come before a
        }
        // Both fields are not in the desiredOrder
        else {
          return 0; // maintain original order for those not in desiredOrder
        }
      });
    }

    //Hide
    //  _columns.removeWhere((element) =>  )
    if (showColList.isNotEmpty) {
      for (var element in columns) {
        if (showColList.contains(element.field)) {
          element.hide = false;
        } else {
          element.hide = true;
        }
      }
    }
    //Resize
    if (sizeColList.isNotEmpty) {
      int i = 0;
      for (var element in columns) {
        if (i >= sizeColList.length) {
          //only resize defult showed column
          break;
        }
        try {
          double x = double.parse(sizeColList[i]);
          element.width = x;
        } catch (e) {
          //
        }

        i++;
      }
    }
    return columns;
  }

  String formatTime(String time) {
    try {
      DateTime dateTime = DateTime.parse(time);

      DateFormat timeFormat = DateFormat('hh:mm:ss a');

      String formattedTime = timeFormat.format(dateTime);

      return Get.locale!.languageCode == 'Ar' ? formattedTime : formattedTime.replaceAll('AM', 'ص').replaceAll('PM', 'م');
    } catch (e) {
      return time;
    }
  }
}

class PlutoColumnToCopy {
  String title;
  String field;
  bool hide;
  PlutoColumnToCopy({required this.field, required this.hide, required this.title});
}
