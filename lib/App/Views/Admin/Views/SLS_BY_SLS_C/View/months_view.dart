// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:pluto_grid/pluto_grid.dart';

// import '../../../../../../utils/utils.dart';
// import '../../../other/TableView/Table.dart';

// // import 'month_visibility.dart';
// // import 'report_columns.dart';
// // import 'tt.dart';

// void applyVisibiliyt(List<PlutoColumn> columns, String from, String to) {
//   int? fromMonth;
//   int? toMonth;

//   if (from.isNotEmpty && to.isNotEmpty) {
//     fromMonth = DateFormat('yyyy-MM-dd').parse(from).month;
//     toMonth = DateFormat('yyyy-MM-dd').parse(to).month;
//   }

//   for (final col in columns) {
//     if (!_isMonth(col.field)) continue;

//     final m = int.parse(col.field);

//     if (fromMonth != null) {
//       col.hide = m < fromMonth || m > toMonth!;
//     } else {
//       col.hide = m > DateTime.now().month;
//     }
//   }
// }

// bool _isMonth(String f) => int.tryParse(f) != null;
// //------------------------------------
// List<PlutoColumn> buildBaseWithMonths() {
//   return [
//     // _yearColumn(),
//     // _dateColumn(),
//     _nameColumn(),
//     ..._monthColumns(),
//   ];
// }

// PlutoColumn _yearColumn() => PlutoColumn(
//       title: "SCH_YEARS".tr,
//       field: 'YR',
//       type: PlutoColumnType.text(),
//       width: 120,
//       backgroundColor: primaryColor,
//       textAlign: PlutoColumnTextAlign.center,
//       titleTextAlign: PlutoColumnTextAlign.center,
//       footerRenderer: (_) => Center(
//         child: Text("YR".tr, style: const TextStyle(color: Colors.white)),
//       ),
//     );

// PlutoColumn _dateColumn() => PlutoColumn(
//       title: "PRD_DATE_COL".tr,
//       field: 'PRD_DATE',
//       type: PlutoColumnType.text(),
//       width: 120,
//       backgroundColor: primaryColor,
//       textAlign: PlutoColumnTextAlign.center,
//       titleTextAlign: PlutoColumnTextAlign.center,
//     );

// PlutoColumn _nameColumn() => PlutoColumn(
//       title: "SLS_CNTR_NAME_COL".tr,
//       field: 'NAME',
//       type: PlutoColumnType.text(),
//       width: 120,
//       backgroundColor: primaryColor,
//       textAlign: PlutoColumnTextAlign.center,
//       titleTextAlign: PlutoColumnTextAlign.center,
//     );

// List<PlutoColumn> _monthColumns() => List.generate(12, (i) {
//       final month = i + 1;
//       return PlutoColumn(
//         title: "${DateFormat.MMMM('AR').format(DateTime(2026, month))} $month",
//         field: month.toString(),
//         type: PlutoColumnType.currency(format: '#,###.##'),
//         width: 110,
//         backgroundColor: primaryColor,
//         textAlign: PlutoColumnTextAlign.center,
//         titleTextAlign: PlutoColumnTextAlign.center,
//         footerRenderer: (ctx) => PlutoAggregateColumnFooter(
//           rendererContext: ctx,
//           type: PlutoAggregateColumnType.sum,
//           format: '#,###.##',
//           alignment: Alignment.center,
//           titleSpanBuilder: (text) => [TextSpan(text: text, style: const TextStyle(color: Colors.white))],
//         ),
//       );
//     });

// //---------------------------------
// List<PlutoColumnGroup> totalGroupBuilder(List<PlutoRow> rows) {
//   return [
//     PlutoColumnGroup(
//       title: "",
//       fields: List.generate(12, (i) => (i + 1).toString()),
//       backgroundColor: primaryColor,
//       titleSpan: WidgetSpan(
//         child: Text(
//           formatCurrency(getSumOfAllCells1to12(rows).toString()),
//           style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ),
//     )
//   ];
// }

// //----------------------------------
// //----------------------------------
// class ReportTableView extends StatelessWidget {
//   final bool loading;
//   final List<PlutoRow> rows;
//   final String from;
//   final String to;
//   final String repID;
//   final String title;

//   const ReportTableView({
//     super.key,
//     required this.loading,
//     required this.rows,
//     required this.from,
//     required this.to,
//     required this.repID,
//     required this.title,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final columns = buildBaseWithMonths();

//     applyVisibiliyt(columns, from, to);

//     return tableView(
//       pagetion: false,
//       // context: context,
//       // key: title,
//       repID: repID,
//       defultPdf: const [],
//       defultExcel: const [],
//       isLoadingData: loading,
//       tableRows: rows,
//       tableColumn: columns,
//       tatal: totalGroupBuilder(rows),
//       pdfTitle: title,
//       fullScreenTitle: title,
//     );
//   }
// }
