import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:masaratapp/App/Views/Admin/Controllers/table_controller.dart';
import 'package:pluto_grid/pluto_grid.dart';
// import 'package:manar/Views/VAR_REP/kshf_acc_grp/View/full_view.dart';
// import 'package:manar/login_screen.dart';
// import 'package:manar/Tools/M7SN_Tools.dart';
// import 'package:pluto_grid_plus/pluto_grid_plus.dart';
// import '../../colors/M7SN_Color.dart';
import '../../../../../Widget/loding_dots.dart';
import '../../../../../utils/utils.dart';
// import '../improvedTable/config/pluto_config.dart';
import 'table_header.dart';

import 'config/pluto_config.dart';
import 'options/table_options.dart';

// import '../../colors/M7SN_Color.dart';
/*
// Color _primaryColor = const Color(0xFF337ab7);
Color _oddRowColor = const Color.fromARGB(255, 255, 255, 255); //Color.fromARGB(255, 231, 233, 236);
Color _evenRowColor = const Color(0xfff6f6f6); //Color.fromARGB(255, 221, 230, 222);

PlutoGridConfiguration _configuration = PlutoGridConfiguration(
  localeText: const PlutoGridLocaleText.arabic(),
  // columnSize: const PlutoGridColumnSizeConfig(
  //   resizeMode: PlutoResizeMode.pushAndPull,
  // ),

  scrollbar: PlutoGridScrollbarConfig(
    enableScrollAfterDragEnd: true,
    // dragDevices: Set.identity(),//this stop horzintal scroll
    scrollbarThicknessWhileDragging: BorderSide.strokeAlignOutside,
    draggableScrollbar: PlutoChangeNotifierFilter.enabled,
    scrollbarThickness: 5,
    // scrollbarRadiusWhileDragging: Radius.circular(12),
    // isAlwaysShown: true,
    scrollBarColor: const Color(0XFFB77033),
    scrollbarRadius: const Radius.circular(12),
  ),
  enableMoveHorizontalInEditing: true,
  style: PlutoGridStyleConfig(
    gridPopupBorderRadius: const BorderRadius.all(
      Radius.circular(8),
    ),
    gridBorderRadius: const BorderRadius.all(
      Radius.circular(8),
    ),
    gridBorderColor: Colors.grey,
    oddRowColor: _oddRowColor, // Color.fromARGB(100, 238, 241, 238),
    evenRowColor: _evenRowColor,

    // borderColor: Colors.transparent,

    enableColumnBorderVertical: true,
    enableColumnBorderHorizontal: true,
    enableCellBorderHorizontal: true,
    enableCellBorderVertical: false,
    iconColor: Colors.black, // _primaryColor,
    // gridBackgroundColor: _primaryColor,
    columnTextStyle: const TextStyle(color: Colors.white),

    // filterHeaderColor: primaryColor, ------------------------------------------committed
  ),
);

*/
/*
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

Widget tableView({
  // required BuildContext context,
  // required String key,
  // required bool isLoadingData,
  // required List<PlutoRow> tableRows,
  // required List<PlutoColumn> tableColumn,
  // required String pdfTitle,
  // required String fullScreenTitle,
  // // double? totalAll,
  // List<PlutoColumnGroup>? tatal,
  // String? groupRowByColumnName,
  // int? pageSize,
  // // bool columnPerPageSumVisible = true ,
  // bool pagetion = false,
  // bool showColumnFilter = false,
  // bool showTableHeader = true,
  // Widget? title,
  // required String repID,
  // required List<String> defultPdf,
  // required List<String> defultExcel,
  // bool showPdfSumLastRow = true,
  // pw.Widget? pdfHeader,
  // pw.Widget? pdfFooter,
  // bool fullScreenWithAddedCouumon = false,
  required TableOptions tableOPtions,
}) {
  // final tblCntrol = Get.find<TableController>();

  // List<PlutoColumn> getColumnsWithOutAddedColumn() {
  //   if (!tableOPtions.fullScreenWithAddedCouumon && tableOPtions.isFullScreenMode) {
  //     return tableOPtions.tableColumns.where((element) => element.field != "AddedColumn").toList();
  //   }

  //   return tableOPtions.tableColumns;
  // }
  // if (tableOPtions.isLoadingData && tableOPtions.tableRows.isEmpty) {
  //   Get.delete<TableController>();
  // }

  List<PlutoColumnGroup>? getColumnGroup() {
    if (tableOPtions.tatalTopTitle.isNotEmpty) {
      return createColumnGroup(tableOPtions.tatalTopTitle, tableOPtions.tableRows);
    } else {
      return null;
    }
  }

  return tableOPtions.tableRows.isNotEmpty
      ? PlutoGrid(
          // key: Key(repID),
          // mode: PlutoGridMode.readOnly,
          columnGroups: getColumnGroup(),
          // rowColorCallback: groupRowByColumnName != null
          //     ? (rowColorContext) {
          //         if (rowColorContext.row.type.isGroup) {
          //           return const Color(0XFFf2de00);
          //         } else {
          //           return Colors.transparent;
          //         }
          //       }
          //     : null,
          columns: tableOPtions.tableColumns, //tableColumn, //
          rows: tableOPtions.tableRows,
          onLoaded: (PlutoGridOnLoadedEvent event) {
            //show Filter row
            // event.stateManager.setShowColumnFilter(true);
            // event.stateManager.setColumnSizeConfig(PlutoGridColumnSizeConfig(autoSizeMode: PlutoAutoSizeMode.scale));
            // event.stateManager.setSelectingMode(PlutoGridSelectingMode.none, notify: true);
            // event.stateManager.setColumnSizeConfig(PlutoGridColumnSizeConfig());

            //
            if (tableOPtions.showColumnFilter) {
              event.stateManager.setShowColumnFilter(true);
            }

            if (tableOPtions.groupRowByColumnName != null) {
              // final groupColumnIndex = event.stateManager.columns.indexWhere(
              //   (element) => element.field == tableOPtions.groupRowByColumnName,
              // );

              // if (groupColumnIndex == -1) {
              //   return;
              // }

              event.stateManager.setRowGroup(
                PlutoRowGroupByColumnDelegate(
                  columns: [
                    event.stateManager.columns[tableOPtions.tableColumns.indexWhere((element) => element.field == tableOPtions.groupRowByColumnName)],
                  ],
                  showFirstExpandableIcon: false,
                ),
              );
            }
          },
          onChanged: (PlutoGridOnChangedEvent event) {
            // print(event);
          },
          onRowDoubleTap: (event) {
            // print(event.cell.value);
            Get.dialog(
              // context: context,
              // user must tap button!

              AlertDialog(
                title: Column(children: [
                  Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: event.cell.column.type.isText ? event.cell.value.toString() : formatCurrency(event.cell.value.toString())));
                        },
                        icon: const Icon(Icons.copy),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(
                        event.cell.column.type.isText ? event.cell.value.toString() : formatCurrency(event.cell.value.toString()),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      )),
                    ],
                  ),
                ]),
              ),
            );
          },

          configuration: PlutoConfig.config,
          createFooter: tableOPtions.pagetion
              ? (stateManager) {
                  stateManager.setPageSize(tableOPtions.pageSize, notify: true);
                  return PlutoPagination(stateManager);
                }
              : null,

          createHeader: (stateManager) {
            return Container(
              decoration: BoxDecoration(color: primaryColor, border: const BorderDirectional(bottom: BorderSide(width: 1, color: Colors.white))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  tableOPtions.title ?? SizedBox(),
                  //
                  if (tableOPtions.showTableHeader)
                    tableHeader(
                      tableOptions: tableOPtions.copyWith(
                        isFullScreenMode: tableOPtions.isFullScreenMode,
                      ),
                      // tableOptions: tableOPtions,
                      stateManager: stateManager,
                      // // context: context,
                      // tableRows: tableRows,
                      // pdfTitle: pdfTitle,
                      // fullScreenTitle: fullScreenTitle,
                      // // key: key,
                      // isLoadingData: isLoadingData,
                      // tableColumn: tableColumn,
                      // pageSize: pageSize,
                      // groupRowByColumnName: groupRowByColumnName,
                      // pagetion: pagetion,
                      // tatal: tatal,
                      // repID: repID,
                      // defultPdf: defultPdf,
                      // defultExcel: defultExcel,
                      // showColumnFilter: showColumnFilter,
                      // showPdfSumLastRow: showPdfSumLastRow,
                      // pdfHeader: pdfHeader,
                      // pdfFooter: pdfFooter,
                    )
                ],
              ),
            );
          },

          columnMenuDelegate: _UserColumnMenu(),
        )
      : Center(
          child: tableOPtions.isLoadingData
              ? const TextLodingDot()
              : const SizedBox(
                  child: Text("No Data"),
                ),
        );
}

/*
Edit enoughFrozenColumnsWidth  for frozen with any width
AppData\Local\Pub\Cache\hosted\pub.dev\pluto_grid_plus-8.4.0\lib\src\manager\state\layout_state.dart

@override
  bool enoughFrozenColumnsWidth(double width) {
    return width > (leftFrozenColumnsWidth + rightFrozenColumnsWidth + PlutoGridSettings.bodyMinWidth + PlutoGridSettings.totalShadowLineWidth) || width < (leftFrozenColumnsWidth + rightFrozenColumnsWidth + PlutoGridSettings.bodyMinWidth + PlutoGridSettings.totalShadowLineWidth) || width == (leftFrozenColumnsWidth + rightFrozenColumnsWidth + PlutoGridSettings.bodyMinWidth + PlutoGridSettings.totalShadowLineWidth);
  }

*/

class _UserColumnMenu implements PlutoColumnMenuDelegate<_UserColumnMenuItem> {
  _UserColumnMenu();
  @override
  List<PopupMenuEntry<_UserColumnMenuItem>> buildMenuItems({
    required PlutoGridStateManager stateManager,
    required PlutoColumn column,
  }) {
    return [
      PopupMenuItem<_UserColumnMenuItem>(
        value: column.frozen.isStart ? _UserColumnMenuItem.unfrozeColumn : _UserColumnMenuItem.frozeColumnStart,
        height: 36,
        enabled: true,
        child: Text(column.frozen.isStart ? 'الغاء التثبيت' : 'تثبيت في لبداية', style: const TextStyle(fontSize: 13)),
      ),
      PopupMenuItem<_UserColumnMenuItem>(
        value: column.frozen.isEnd ? _UserColumnMenuItem.unfrozeColumn : _UserColumnMenuItem.frozeColumnEnd,
        height: 36,
        enabled: true,
        child: Text(column.frozen.isEnd ? 'الغاء التثبيت' : 'تثبيت في النهاية', style: const TextStyle(fontSize: 13)),
      ),
      const PopupMenuItem<_UserColumnMenuItem>(
        value: _UserColumnMenuItem.hideColumn,
        height: 36,
        enabled: true,
        child: Text('اخفاء', style: TextStyle(fontSize: 13)),
      ),
      const PopupMenuItem<_UserColumnMenuItem>(
        value: _UserColumnMenuItem.filterColumn,
        height: 36,
        enabled: true,
        child: Text('فلترة العمود', style: TextStyle(fontSize: 13)),
      ),
    ];
  }

  @override
  void onSelected({
    required BuildContext context,
    required PlutoGridStateManager stateManager,
    required PlutoColumn column,
    required bool mounted,
    required _UserColumnMenuItem? selected,
  }) {
    switch (selected) {
      case _UserColumnMenuItem.frozeColumnStart:
        // if (column.frozen.isFrozen) {
        stateManager.toggleFrozenColumn(column, PlutoColumnFrozen.none);
        // } else {
        stateManager.toggleFrozenColumn(column, PlutoColumnFrozen.start);
        // }
        break;
      case _UserColumnMenuItem.frozeColumnEnd:
        // if (column.frozen.isStart) {
        stateManager.toggleFrozenColumn(column, PlutoColumnFrozen.none);
        // } else {
        stateManager.toggleFrozenColumn(column, PlutoColumnFrozen.end);
        // }
        break;
      case _UserColumnMenuItem.unfrozeColumn:
        stateManager.toggleFrozenColumn(column, PlutoColumnFrozen.none);
        break;

      case _UserColumnMenuItem.hideColumn:
        stateManager.hideColumn(notify: true, column, true);

      case _UserColumnMenuItem.filterColumn:
        stateManager.setColumnSizeConfig(PlutoGridColumnSizeConfig(autoSizeMode: PlutoAutoSizeMode.scale));

        stateManager.showFilterPopup(
          context,
          calledColumn: PlutoColumn(
            title: column.title,
            field: column.field,
            type: column.type,
            backgroundColor: primaryColor,
          ),
          //   onClosed: () {
          //      // stateManager.setColumnSizeConfig(PlutoGridColumnSizeConfig(autoSizeMode: PlutoAutoSizeMode.none));
          // stateManager.setConfiguration(_configuration);
          // // stateManager.updateVisibilityLayout();
          // print("Colsed");
          //   },
        );

        break;

      case null:
        break;
    }
  }
}

enum _UserColumnMenuItem {
  frozeColumnStart,
  frozeColumnEnd,
  unfrozeColumn,
  hideColumn,
  filterColumn,
}

class ShowTableFullSreccn extends StatelessWidget {
  final Widget child;
  final AppBar? title;
  const ShowTableFullSreccn({super.key, required this.child, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: title,
      body: SafeArea(
        bottom: true,
        top: true,
        child: child,
      ),
    );
  }
}
