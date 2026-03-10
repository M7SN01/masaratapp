import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../utils/utils.dart';

class TableOptions {
  /*final*/ bool isLoadingData;
  final bool isAdmin;
  /*final*/ String repID;
  /*final*/ List<PlutoRow> tableRows;
  /*final*/ List<PlutoColumn> tableColumns;
  /*final*/ String? pdfTitle;
  String? fromToDate;
  /*final*/ String? fullScreenTitle;
  // double? totalAll;

  final List<String> columnGroups;
  final List<PlutoColumnGroup>? topTotalcolumnGroups;
  /*final*/ String? groupRowByColumnName;
  /*final*/ int pageSize;
  // bool columnPerPageSumVisible = true ;
  /*final*/ bool pagetion;
  /*final*/ bool showColumnFilter;
  /*final*/ bool showTableHeader;
  /*final*/ Widget? title;
  final List<String> defultColShow;
  final List<String> defultColSize;
  /*final*/ final List<String> defultPdf;
  /*final*/ final List<String> defultExcel;
  /*final*/ bool showPdfSumLastRow;
  // pw.Widget? pdfHeader;
  // pw.Widget? pdfFooter;
  // /*final*/ bool fullScreenWithAddedCouumon;
  bool isFullScreenMode;
  final Map<String, dynamic> appDefault;
  final Function(Map<String, dynamic>)? onUpdateSetting;
  // final bool applyAppDefaultOnInit;

  //

  TableOptions({
    required this.isLoadingData,
    required this.isAdmin,
    required this.repID,
    required this.tableRows,
    required List<PlutoColumn> tableColumns,
    this.pdfTitle = "",
    this.fromToDate,
    this.fullScreenTitle,
    this.pagetion = false,
    this.showColumnFilter = false,
    this.showTableHeader = true,
    this.title,
    this.columnGroups = const [],
    this.groupRowByColumnName,
    this.pageSize = 100,
    this.showPdfSumLastRow = true,
    // this.fullScreenWithAddedCouumon = false,
    // this.defultColShow,
    // this.defultColSize,
    // this.defultPdf,
    // this.defultExcel,
    this.isFullScreenMode = false,
    this.appDefault = const {},
    this.onUpdateSetting,
    // this.applyAppDefaultOnInit = true,
  })  : defultColShow = _getDefaultList(appDefault, repID, 'SHOW_DEFAULT'),
        defultColSize = _getDefaultList(appDefault, repID, 'SIZE_DEFAULT'),
        defultPdf = _getDefaultList(appDefault, repID, 'PDF_DEFAULT'),
        defultExcel = _getDefaultList(appDefault, repID, 'EXCEL_DEFAULT'),
        tableColumns = columnsdefualt(
          columns: tableColumns,
          showColList: _getDefaultList(appDefault, repID, 'SHOW_DEFAULT'),
          sizeColList: _getDefaultList(appDefault, repID, 'SIZE_DEFAULT'),
        ),
        topTotalcolumnGroups = columnGroups.isNotEmpty ? createColumnGroup(columnGroups, tableRows) : null;

  // {
  //   _onInit();
  // }

  // void _onInit() {
  //   print("Initialize function running");
  //   defultColShow = appDefault[repID] != null && appDefault[repID]['SHOW_DEFAULT'] != null ? appDefault[repID]['SHOW_DEFAULT'].split(',') : [];
  //   defultColSize = appDefault[repID] != null && appDefault[repID]['SIZE_DEFAULT'] != null ? appDefault[repID]['SIZE_DEFAULT'].split(',') : [];
  //   defultPdf = appDefault[repID] != null && appDefault[repID]['PDF_DEFAULT'] != null ? appDefault[repID]['PDF_DEFAULT'].split(',') : [];
  //   defultExcel = appDefault[repID] != null && appDefault[repID]['EXCEL_DEFAULT'] != null ? appDefault[repID]['EXCEL_DEFAULT'].split(',') : [];
  // }

  TableOptions copyWith({
    bool? isLoadingData,
    String? repID,
    bool? isAdmin,
    List<PlutoRow>? tableRows,
    List<PlutoColumn>? tableColumns,
    String? pdfTitle,
    String? fromToDate,
    String? fullScreenTitle,
    List<String>? columnGroups,
    String? groupRowByColumnName,
    int? pageSize,
    bool? pagetion,
    bool? showColumnFilter,
    bool? showTableHeader,
    Widget? title,
    // List<String>? defultColShow,
    // List<String>? defultColSize,
    // List<String>? defultPdf,
    // List<String>? defultExcel,
    bool? showPdfSumLastRow,
    // bool? fullScreenWithAddedCouumon,
    bool? isFullScreenMode,
    Map<String, dynamic>? appDefault,
    final Function(Map<String, dynamic>)? onUpdateSetting,
  }) {
    return TableOptions(
      isLoadingData: isLoadingData ?? this.isLoadingData,
      isAdmin: this.isAdmin,
      repID: repID ?? this.repID,
      tableRows: tableRows != null ? List<PlutoRow>.from(tableRows) : List<PlutoRow>.from(this.tableRows),
      tableColumns: tableColumns != null ? List<PlutoColumn>.from(tableColumns) : List<PlutoColumn>.from(this.tableColumns),
      pdfTitle: pdfTitle ?? this.pdfTitle,
      fromToDate: fromToDate ?? this.fromToDate,
      fullScreenTitle: fullScreenTitle ?? this.fullScreenTitle,
      columnGroups: columnGroups ?? List<String>.from(this.columnGroups),
      groupRowByColumnName: groupRowByColumnName ?? this.groupRowByColumnName,
      pageSize: pageSize ?? this.pageSize,
      pagetion: pagetion ?? this.pagetion,
      showColumnFilter: showColumnFilter ?? this.showColumnFilter,
      showTableHeader: showTableHeader ?? this.showTableHeader,
      title: title ?? this.title,
      // defultColShow: defultColShow ?? List<String>.from(this.defultColShow),
      // defultColSize: defultColSize ?? List<String>.from(this.defultColSize),
      // defultPdf: defultPdf ?? List<String>.from(this.defultPdf),
      // defultExcel: defultExcel ?? List<String>.from(this.defultExcel),
      showPdfSumLastRow: showPdfSumLastRow ?? this.showPdfSumLastRow,
      // fullScreenWithAddedCouumon: fullScreenWithAddedCouumon ?? this.fullScreenWithAddedCouumon,
      isFullScreenMode: isFullScreenMode ?? this.isFullScreenMode,
      appDefault: appDefault ?? this.appDefault,
      onUpdateSetting: onUpdateSetting ?? this.onUpdateSetting,
      // applyAppDefaultOnInit: false,
    );
  }
}

List<String> _getDefaultList(Map<String, dynamic> appDefault, String repID, String key) {
  final raw = appDefault[repID]?[key];
  if (raw is! String || raw.trim().isEmpty) {
    return <String>[];
  }

  return raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
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

// List<PlutoColumnGroup>? getColumnGroup() {
//   if (tableOPtions.columnGroups.isNotEmpty) {
//     return createColumnGroup(tableOPtions.columnGroups, tableOPtions.tableRows);
//   } else {
//     return null;
//   }
// }

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
    if (element.contains('COUNT=>')) {
      totals.add(PlutoColumnGroup(
        title: "",
        fields: [element.replaceAll('COUNT=>', '')],
        backgroundColor: primaryColor,
        titleTextAlign: PlutoColumnTextAlign.right,
        titleSpan: WidgetSpan(
          child: Text(
            " عدد : ${rows.length}",
            //  getSumOfAllCellsByFiled(rows, element).toString(),
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ));
    } else {
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
  }
  return totals;
}
