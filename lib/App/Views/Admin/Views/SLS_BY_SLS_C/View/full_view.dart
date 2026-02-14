// import 'package:flutter/material.dart';
// import 'package:masaratapp/App/Views/Admin/other/TableView/options/table_options.dart';
// // import 'package:get/get.dart';
// import 'package:pluto_grid/pluto_grid.dart';
// // import '../../../../../../utils/utils.dart';
// import '../../../other/TableView/Table.dart';

// class MonthView extends StatelessWidget {
//   final bool loadingData;
//   final List<PlutoRow> monthRows;
//   final List<PlutoColumn> columns;
//   final String repID;
//   // final //Map<String, List<String>> defaultTableSetting;

//   const MonthView({super.key, required this.loadingData, required this.monthRows, required this.repID, required this.columns
//       // , required this.defaultTableSetting
//       });

//   @override
//   Widget build(BuildContext context) {
//     // monthColumns = columnsdefualt(
//     //   columns: monthColumns,
//     //   showColList: getAppDefault(repID: widget.repID, defType: "SHOW_DEFAULT"), //widget.defaultTableSetting["FULL_SHOW"] ?? [],
//     //   sizeColList: getAppDefault(repID: widget.repID, defType: "SIZE_DEFAULT"), //widget.defaultTableSetting["FULL_SIZE"] ?? [],
//     // );

//     TableOptions x = TableOptions(
//       isLoadingData: loadingData,
//       repID: repID,
//       tableRows: monthRows,
//       tableColumns: columns,
//       pdfTitle: "الربح حسب مراكز البيع",
//       fullScreenTitle: "مراكز البيع",
//       tatalTopTitle: ['INV_TTL', 'TTL_CST', 'GP'],
//     );
//     return tableView(tableOPtions: x);
//   }
// /*
//   Widget openPublicInvRep(PlutoColumnRendererContext rendererContext) {
//     return GestureDetector(
//       onLongPress: () {
//         Navigator.push(context, MaterialPageRoute(builder: (context) {
//           return SlsInvoicesPublic(
//             isOpenfromOtherRep: true,
//             slsCenters: "'${rendererContext.row.cells['SLS_CNTR_ID']!.value.toString().trim()}'",
//             fromDate: fromDateController.text,
//             toDate: toDateController.text,
//             mnthDate: mnthDateController.text,
//             years: selectedSchYearIds,
//           );
//         }));
//       },
//       child: Row(
//         children: [
//           IconButton(
//             icon: const Icon(
//               Icons.forward,
//               color: Colors.greenAccent,
//             ),
//             onPressed: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) {
//                 return slsByPrd.SlsByProducts(
//                   isOpenfromOtherRep: true,
//                   slsCenters: "'${rendererContext.row.cells['SLS_CNTR_ID']!.value.toString().trim()}'",
//                   fromDate: slsByPrd.fromDateController.text,
//                   toDate: slsByPrd.toDateController.text,
//                   mnthDate: slsByPrd.mnthDateController.text,
//                   years: slsByPrd.selectedSchYearIds,
//                 );
//               }));
//             },
//             iconSize: 18,
//             color: Colors.green,
//             padding: const EdgeInsets.all(0),
//           ),
//           Expanded(
//             child: Text(
//               rendererContext.row.cells[rendererContext.column.field]!.value.toString(),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(color: Colors.blue),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// */
// }
