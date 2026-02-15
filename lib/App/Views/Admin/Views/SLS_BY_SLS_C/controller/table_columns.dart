import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:masaratapp/App/Views/Admin/Views/SLS_BY_SLS_C/controller/sls_cntr_controller.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../../../utils/utils.dart';

mixin SetUpTablesColumns on GetxController {
  get slsCntrController => Get.find<SlsCenterController>();

  get getColumnsByMonthRep {
    return slsCntrController.monthColumns = [
      /*
        PlutoColumn(
          title: "SCH_YEARS".tr,
          field: 'YR',
          textAlign: PlutoColumnTextAlign.center,
          titleTextAlign: PlutoColumnTextAlign.center,
          type: PlutoColumnType.text(),
          backgroundColor: primaryColor,
          suppressedAutoSize: true,
          width: 120,
          footerRenderer: (rendererContext) {
            return Center(
              child: Text(
                "YR".tr,
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
          // minWidth: 80,
        ),
       
       */
      PlutoColumn(
        title: "SLS_CNTR_NAME_COL".tr,
        field: 'SLS_CNTR_NAME',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.text(),
        backgroundColor: primaryColor,
        suppressedAutoSize: true,
        // width: 120,
        footerRenderer: (rendererContext) {
          return Center(
            child: Text(
              "TOTAL_COL_FOOTER".tr,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
        // minWidth: 80,
        // renderer: (rendererContext) => openPublicInvRep(rendererContext),
      ),
      PlutoColumn(
        title: "INV_TTL_COL".tr,
        field: 'INV_TTL',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.currency(format: '#,###.##'),
        backgroundColor: primaryColor,
        // width: 110,
        suppressedAutoSize: true,
        footerRenderer: (rendererContext) {
          return PlutoAggregateColumnFooter(
            rendererContext: rendererContext,
            type: PlutoAggregateColumnType.sum,
            format: '#,###.##',
            alignment: Alignment.center,
            titleSpanBuilder: (text) {
              return [
                // const TextSpan(
                //   text: 'إجمالي',
                //   style: TextStyle(color: Colors.red),
                // ),
                // const TextSpan(text: ' : '),
                TextSpan(text: text, style: const TextStyle(color: Colors.white)),
              ];
            },
          );
        },
      ),
      PlutoColumn(
        title: "TTL_CST_COL".tr,
        field: 'TTL_CST',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.currency(format: '#,###.###'),
        backgroundColor: primaryColor,
        // width: 110,
        suppressedAutoSize: true,

        footerRenderer: (rendererContext) {
          return PlutoAggregateColumnFooter(
            rendererContext: rendererContext,
            type: PlutoAggregateColumnType.sum,
            format: '#,###.###',
            alignment: Alignment.center,
            titleSpanBuilder: (text) {
              return [
                // const TextSpan(
                //   text: 'إجمالي',
                //   style: TextStyle(
                //     color: Colors.red,
                //   ),
                // ),
                // const TextSpan(text: ' : '),
                TextSpan(text: text, style: const TextStyle(color: Colors.white)),
              ];
            },
          );
        },
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

        footerRenderer: (rendererContext) {
          return PlutoAggregateColumnFooter(
            rendererContext: rendererContext,
            type: PlutoAggregateColumnType.sum,
            format: '#,###.###',
            alignment: Alignment.center,
            titleSpanBuilder: (text) {
              return [
                // const TextSpan(
                //   text: 'إجمالي',
                //   style: TextStyle(color: Colors.red),
                // ),
                // const TextSpan(text: ' : '),
                TextSpan(text: text, style: const TextStyle(color: Colors.white)),
              ];
            },
          );
        },
      ),
    ];
  }

  get getColumnsFromToDateRep {
    final columns = buildBaseWithMonths();

    applyVisibiliyt(columns, slsCntrController.fromDateController.text, slsCntrController.toDateController.text);

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
  ];
}

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

PlutoColumn _nameColumn() => PlutoColumn(
      title: "SLS_CNTR_NAME_COL".tr,
      field: 'NAME',
      type: PlutoColumnType.text(),
      width: 120,
      backgroundColor: primaryColor,
      textAlign: PlutoColumnTextAlign.center,
      titleTextAlign: PlutoColumnTextAlign.center,
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
