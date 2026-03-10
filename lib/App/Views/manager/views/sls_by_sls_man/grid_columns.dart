import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:masaratapp/App/Views/Manager/controller/sls_by_Sls_man_controller.dart';

import 'package:pluto_grid/pluto_grid.dart';

import '../../../../../utils/utils.dart';

class SlsBySlsManColumns {
  // get slsCntrController => Get.find<SlsCenterController>();

  get getColumnsByMonthRep {
    return [
      PlutoColumn(
        title: "SLS_MAN_COL".tr,
        field: 'SLS_MAN_NAME',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.text(),
        backgroundColor: primaryColor,
        suppressedAutoSize: true,
        enableEditingMode: false,
        // footerRenderer: (rendererContext) {
        //   return Center(
        //     child: Text(
        //       "TOTAL_COL_FOOTER".tr,
        //       style: const TextStyle(color: Colors.white),
        //     ),
        //   );
        // },
      ),
      PlutoColumn(
        title: "INV_TTL_COL".tr,
        field: 'INV_TTL',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.currency(format: '#,###.##'),
        backgroundColor: primaryColor,
        suppressedAutoSize: true,
        enableEditingMode: false,
        // footerRenderer: (rendererContext) {
        //   return PlutoAggregateColumnFooter(
        //     rendererContext: rendererContext,
        //     type: PlutoAggregateColumnType.sum,
        //     format: '#,###.##',
        //     alignment: Alignment.center,
        //     titleSpanBuilder: (text) {
        //       return [
        //         TextSpan(text: text, style: const TextStyle(color: Colors.white)),
        //       ];
        //     },
        //   );
        // },
      ),
      PlutoColumn(
        title: "TTL_CST_COL".tr,
        field: 'TTL_CST',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.currency(format: '#,###.###'),
        backgroundColor: primaryColor,
        suppressedAutoSize: true,
        enableEditingMode: false,
        // footerRenderer: (rendererContext) {
        //   return PlutoAggregateColumnFooter(
        //     rendererContext: rendererContext,
        //     type: PlutoAggregateColumnType.sum,
        //     format: '#,###.###',
        //     alignment: Alignment.center,
        //     titleSpanBuilder: (text) {
        //       return [
        //         TextSpan(text: text, style: const TextStyle(color: Colors.white)),
        //       ];
        //     },
        //   );
        // },
      ),
      PlutoColumn(
        title: "GP_COL".tr,
        field: 'GP',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.currency(format: '#,###.###'),
        backgroundColor: primaryColor,
        // width: 110,
        suppressedAutoSize: true,
        enableEditingMode: false,
        // footerRenderer: (rendererContext) {
        //   return PlutoAggregateColumnFooter(
        //     rendererContext: rendererContext,
        //     type: PlutoAggregateColumnType.sum,
        //     format: '#,###.###',
        //     alignment: Alignment.center,
        //     titleSpanBuilder: (text) {
        //       return [
        //         TextSpan(text: text, style: const TextStyle(color: Colors.white)),
        //       ];
        //     },
        //   );
        // },
      ),
      PlutoColumn(
        title: "MDUNIH_COL".tr,
        field: 'MDUNIH',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.currency(format: '#,###.###'),
        backgroundColor: primaryColor,
        // width: 110,
        suppressedAutoSize: true,
        enableEditingMode: false,
        // footerRenderer: (rendererContext) {
        //   return PlutoAggregateColumnFooter(
        //     rendererContext: rendererContext,
        //     type: PlutoAggregateColumnType.sum,
        //     format: '#,###.###',
        //     alignment: Alignment.center,
        //     titleSpanBuilder: (text) {
        //       return [
        //         TextSpan(text: text, style: const TextStyle(color: Colors.white)),
        //       ];
        //     },
        //   );
        // },
      ),
      PlutoColumn(
        title: "T7SIL_COL".tr,
        field: 'T7SIL',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.currency(format: '#,###.###'),
        backgroundColor: primaryColor,
        // width: 110,
        suppressedAutoSize: true,
        enableEditingMode: false,
        // footerRenderer: (rendererContext) {
        //   return PlutoAggregateColumnFooter(
        //     rendererContext: rendererContext,
        //     type: PlutoAggregateColumnType.sum,
        //     format: '#,###.###',
        //     alignment: Alignment.center,
        //     titleSpanBuilder: (text) {
        //       return [
        //         TextSpan(text: text, style: const TextStyle(color: Colors.white)),
        //       ];
        //     },
        //   );
        // },
      ),
    ];
  }

  List<PlutoColumn> getColumnsFromToDateRep({fromDateController, toDateController}) {
    final columns = buildBaseWithMonths();

    applyVisibiliyt(columns, fromDateController.text, toDateController.text);

    return columns;
  }
}

//----------------------------------------SetUp Columns ------------------------------

void applyVisibiliyt(List<PlutoColumn> columns, String from, String to) {
  int? fromMonth;
  int? toMonth;

  if (from.isNotEmpty && to.isNotEmpty) {
    fromMonth = DateFormat('yyyy-MM-dd').parse(from).month;
    toMonth = DateFormat('yyyy-MM-dd').parse(to).month;
  }

  for (final col in columns) {
    if (!_isMonth(col.field)) continue;

    final m = int.parse(col.field);

    if (fromMonth != null) {
      col.hide = m < fromMonth || m > toMonth!;
    } else {
      col.hide = m > DateTime.now().month;
    }
  }
}

bool _isMonth(String f) => int.tryParse(f) != null;
//------------------------------------
List<PlutoColumn> buildBaseWithMonths() {
  return [
    // _yearColumn(),
    // _dateColumn(),
    _nameColumn(),
    ..._monthColumns(),
    _totalColumn(),
  ];
}

/*
PlutoColumn _yearColumn() => PlutoColumn(
      title: "SCH_YEARS".tr,
      field: 'YR',
      type: PlutoColumnType.text(),
      width: 120,
      backgroundColor: primaryColor,
      textAlign: PlutoColumnTextAlign.center,
      titleTextAlign: PlutoColumnTextAlign.center,
      footerRenderer: (_) => Center(
        child: Text("YR".tr, style: const TextStyle(color: Colors.white)),
      ),
    );

PlutoColumn _dateColumn() => PlutoColumn(
      title: "PRD_DATE_COL".tr,
      field: 'PRD_DATE',
      type: PlutoColumnType.text(),
      width: 120,
      backgroundColor: primaryColor,
      textAlign: PlutoColumnTextAlign.center,
      titleTextAlign: PlutoColumnTextAlign.center,
    );
*/
PlutoColumn _nameColumn() => PlutoColumn(
      title: "SLS_MAN_COL".tr,
      field: 'SLS_MAN_NAME',
      type: PlutoColumnType.text(),
      width: 120,
      backgroundColor: primaryColor,
      textAlign: PlutoColumnTextAlign.center,
      titleTextAlign: PlutoColumnTextAlign.center,
    );

PlutoColumn _totalColumn() => PlutoColumn(
      title: "TOTAL_COL".tr,
      field: 'TOTAL',
      textAlign: PlutoColumnTextAlign.center,
      titleTextAlign: PlutoColumnTextAlign.center,
      type: PlutoColumnType.currency(format: '#,###.##'),
      // hide: i > DateTime.now().month,
      backgroundColor: primaryColor,
      width: 110,
      footerRenderer: (rendererContext) {
        return PlutoAggregateColumnFooter(
          rendererContext: rendererContext,
          type: PlutoAggregateColumnType.sum,
          format: '#,###.##',
          alignment: Alignment.center,
          titleSpanBuilder: (text) {
            return [
              TextSpan(text: text, style: const TextStyle(color: Colors.white)),
            ];
          },
        );
      },
    );

List<PlutoColumn> _monthColumns() => List.generate(12, (i) {
      final month = i + 1;
      return PlutoColumn(
        title: "${DateFormat.MMMM('AR').format(DateTime(2026, month))} $month",
        field: month.toString(),
        type: PlutoColumnType.currency(format: '#,###.##'),
        width: 110,
        backgroundColor: primaryColor,
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        footerRenderer: (ctx) => PlutoAggregateColumnFooter(
          rendererContext: ctx,
          type: PlutoAggregateColumnType.sum,
          format: '#,###.##',
          alignment: Alignment.center,
          titleSpanBuilder: (text) => [TextSpan(text: text, style: const TextStyle(color: Colors.white))],
        ),
      );
    });
