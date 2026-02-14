// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:pluto_grid/pluto_grid.dart';
// import '../../../../../utils/utils.dart';
// // import '../../utils/utils.dart';

// class ReportColumnFactory {
//   static List<PlutoColumn> buildBaseWithMonths() {
//     return [
//       _yearColumn(),
//       _dateColumn(),
//       _nameColumn(),
//       ..._monthColumns(),
//     ];
//   }

//   static PlutoColumn _yearColumn() => PlutoColumn(
//         title: "SCH_YEARS".tr,
//         field: 'YR',
//         type: PlutoColumnType.text(),
//         width: 120,
//         backgroundColor: primaryColor,
//         textAlign: PlutoColumnTextAlign.center,
//         titleTextAlign: PlutoColumnTextAlign.center,
//         footerRenderer: (_) => Center(
//           child: Text("YR".tr, style: const TextStyle(color: Colors.white)),
//         ),
//       );

//   static PlutoColumn _dateColumn() => PlutoColumn(
//         title: "PRD_DATE_COL".tr,
//         field: 'PRD_DATE',
//         type: PlutoColumnType.text(),
//         width: 120,
//         backgroundColor: primaryColor,
//         textAlign: PlutoColumnTextAlign.center,
//         titleTextAlign: PlutoColumnTextAlign.center,
//       );

//   static PlutoColumn _nameColumn() => PlutoColumn(
//         title: "SLS_CNTR_NAME_COL".tr,
//         field: 'NAME',
//         type: PlutoColumnType.text(),
//         width: 120,
//         backgroundColor: primaryColor,
//         textAlign: PlutoColumnTextAlign.center,
//         titleTextAlign: PlutoColumnTextAlign.center,
//       );

//   static List<PlutoColumn> _monthColumns() => List.generate(12, (i) {
//         final month = i + 1;
//         return PlutoColumn(
//           title: "${DateFormat.MMMM('AR').format(DateTime(2026, month))} $month",
//           field: month.toString(),
//           type: PlutoColumnType.currency(format: '#,###.##'),
//           width: 110,
//           backgroundColor: primaryColor,
//           textAlign: PlutoColumnTextAlign.center,
//           titleTextAlign: PlutoColumnTextAlign.center,
//           footerRenderer: (ctx) => PlutoAggregateColumnFooter(
//             rendererContext: ctx,
//             type: PlutoAggregateColumnType.sum,
//             format: '#,###.##',
//             alignment: Alignment.center,
//             titleSpanBuilder: (text) => [TextSpan(text: text, style: const TextStyle(color: Colors.white))],
//           ),
//         );
//       });
// }
