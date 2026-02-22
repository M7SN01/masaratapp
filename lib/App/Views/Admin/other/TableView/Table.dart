import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../../../Widget/loding_dots.dart';
import '../../../../../utils/utils.dart';
import 'table_header.dart';

import 'config/pluto_config.dart';
import 'options/table_options.dart';

Widget tableView({required TableOptions tableOPtions}) {
  return tableOPtions.tableRows.isNotEmpty
      ? PlutoGrid(
          // key: Key(repID),
          // mode: PlutoGridMode.readOnly,
          columnGroups: tableOPtions.topTotalcolumnGroups,
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

          createHeader: tableOPtions.isAdmin
              ? (stateManager) {
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
                }
              : null,

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
