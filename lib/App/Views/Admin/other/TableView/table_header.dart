import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masaratapp/App/Views/Admin/Controllers/table_controller.dart';
import '../../../../../Widget/loding_dots.dart';
import '../../../../../utils/utils.dart';
import 'Table.dart';
import 'options/table_options.dart';

class TableSetting extends StatelessWidget {
  // final PlutoGridStateManager stateManager;
  final TableOptions tableOptions;
  const TableSetting({super.key, required this.tableOptions});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TableController>(
      builder: (controller) => Column(
        children: [
          //Title ----------------------
          const SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.visibility_sharp,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("الاعمدة المعروضة"),
              ],
            ),
          ),
          const SizedBox(height: 5),
          const Divider(
            color: Colors.blueGrey,
            height: 1,
            thickness: 1,
          ),
          const SizedBox(height: 5),
          if (controller.postingQuery)
            const TextLodingDot()
          else ...[
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      await controller.postColName(col: "SHOW_DEFAULT", repID: tableOptions.repID, postColumns: tableOptions.tableColumns);
                      await controller.postColSize(repID: tableOptions.repID, postColumns: tableOptions.tableColumns);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding
                    ),
                    child: const Text(
                      "حفظ كـعرض افتراضي",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            //PDF
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      await controller.postColName(col: "PDF_DEFAULT", repID: tableOptions.repID, postColumns: tableOptions.tableColumns);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding
                    ),
                    child: const Text(
                      "حفظ تصدير PDF كـ افتراضي",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      controller.postColName(col: "EXCEL_DEFAULT", repID: tableOptions.repID, postColumns: tableOptions.tableColumns);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding
                    ),
                    child: const Text(
                      "حفظ تصدير Excel كـ افتراضي",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextFormField(
                      textAlignVertical: const TextAlignVertical(y: -0.8),
                      controller: controller.pdfName,
                      decoration: InputDecoration(
                        labelText: "PDF_NAME",
                        prefixIcon: controller.pdfName.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  controller.pdfName.text = "";
                                  controller.update();
                                },
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              )
                            : null,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ]
        ],
      ),
    );
  }
}

Widget tableHeader({required TableOptions tableOptions}) {
  return GetBuilder<TableController>(
    init: TableController(),
    builder: (controller) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //show
            IconButton(
              icon: const Icon(
                Icons.visibility_sharp,
                color: Colors.white,
              ),
              onPressed: () {
                controller.stateManager.showSetColumnsPopup(Get.context!);
              },
            ),

            //Add column
            controller.isCanAddColumn
                ? IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: controller.handleAddColumns,
                  )
                : IconButton(
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                    onPressed: controller.handleRemoveCurrentColumnButton,
                  ),

            //PDF
            controller.isLoadingPdf
                ? const SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ))
                : IconButton(
                    onPressed: () => controller.exportToPDF(columns: tableOptions.tableColumns, rows: tableOptions.tableRows, pdfTitle: tableOptions.pdfTitle)
                    /*
                          () async {
                            //
                            int columnCount = 0;
                            int maxRowCount = 2000;
                            int maxcolumnCount = 15;
                            bool landscapeOrientation = false;

                            loadingProvider.setLoadingPdf(true);
                            stateManager.updateVisibilityLayout(notify: true);
                            // stateManager.updateVisibilityLayout(notify: true);
                            stateManager.notifyListeners();
                            // print(loadingProvider.isLoading);
                            // await Future.delayed(Duration(seconds: 3));
                            List<String> headers = [];
                            List<String> headersField = [];
                            //-----------------------------------------PDF Defult Setting---------------------------------------
                            List<PlutoColumnToCopy> tempColumn = stateManager.columns.map((col) => PlutoColumnToCopy(title: col.title, field: col.field, hide: col.hide)).toList();
                            if (defultPdf.isNotEmpty) {
                              for (var columm in tempColumn) {
                                if (defultPdf.contains(columm.field) || columm.field == "AddedColumn") {
                                  columm.hide = false;
                                } else {
                                  columm.hide = true;
                                }
                              }
                            }
                            //-------------------------------------------------------------------------------------------------
                            for (var column in tempColumn) {
                              if (!column.hide) {
                                columnCount++;
                                if (columnCount <= maxcolumnCount) {
                                  headers.add(column.title);
                                  headersField.add(column.field);
                                }
                              }
                            }

                            // print(columnCount);
                            //LANDSCAPE ORAINTAIONS
                            if (columnCount > 10) {
                              landscapeOrientation = true;
                            }
                            // print("$columnCount , $maxcolumnCount");
                            //max Column to Export to PDF
                            if (columnCount >= maxcolumnCount) {
                              showMessage(
                                msg: """عدد الاعمدة اكثر من 15 \nيتم تصدير 15 اعمدة فقط""",
                                color: Colors.red,
                              );
                            }

                            List<List<dynamic>> rowData = [];
                            // Calculate the sum of each column with numeric values
                            List<double> columnSums = List.filled(headers.length, 0.0);

                            // to print only the selected rows-----------------------------------------------------------------
                            List<PlutoRow> checkedRows = [];
                            for (var row in tableRows) {
                              if (row.checked == true) {
                                checkedRows.add(row);
                              }
                            }
                            List<PlutoRow> exportedRows = checkedRows.isEmpty ? tableRows : checkedRows;
                            //----------------------------------------------------------------------------------------------
                            int rowCount = 0;
                            for (PlutoRow row in exportedRows) {
                              if (row.type.isGroup) {
                                if (row.type.group.expanded) {
                                  List<dynamic> rowCells = [];
                                  rowCount++;
                                  for (int i = 0; i < headersField.length; i++) {
                                    String field = headersField[i];
                                    dynamic cellValue = row.cells[field]?.value ?? '';
                                    if (cellValue is num) {
                                      columnSums[i] += cellValue;
                                    }
                                    rowCells.add(cellValue);
                                  }
                                  rowData.add(rowCells.reversed.toList());
                                } else {
                                  for (PlutoRow row in row.type.group.children) {
                                    List<dynamic> rowCells = [];
                                    rowCount++;
                                    for (int i = 0; i < headersField.length; i++) {
                                      String field = headersField[i];
                                      dynamic cellValue = row.cells[field]?.value ?? '';
                                      if (cellValue is num) {
                                        columnSums[i] += cellValue;
                                      }
                                      rowCells.add(cellValue);
                                    }
                                    rowData.add(rowCells.reversed.toList());
                                  }
                                }
                              } else {
                                List<dynamic> rowCells = [];
                                rowCount++;
                                for (int i = 0; i < headersField.length; i++) {
                                  String field = headersField[i];
                                  dynamic cellValue = row.cells[field]?.value ?? '';
                                  if (cellValue is num) {
                                    columnSums[i] += cellValue;
                                  }
                                  rowCells.add(cellValue);
                                }
                                rowData.add(rowCells.reversed.toList());
                              }

                              if (rowCount >= maxRowCount) {
                                showMessage(msg: "عدد الصفوف اكثر من 2000\nيتم تصدير 2000 صف فقط", color: Colors.red);
                                break;
                              }
                            }
                            // print(rowData.length);
                            // Add the row containing column sums to the table data
                            if (showPdfSumLastRow) {
                              List<dynamic> sumRow = [];
                              for (int i = 0; i < headers.length; i++) {
                                if (columnSums[i] == 0) {
                                  sumRow.add("");
                                } else {
                                  sumRow.add(columnSums[i]);
                                }
                              }
                              rowData.add(sumRow.reversed.toList());
                            }

                            await createPdfFile(pdfHeader: pdfHeader, pdfFooter: pdfFooter, pageTitle: pdfTitle, landscapeOrientation: landscapeOrientation, tableHeader: headers.reversed.toList(), tableData: rowData, pdfName: controller.pdfName.text);
                            loadingProvider.setLoadingPdf(false);
                          },
                          */
                    ,
                    icon: const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.white,
                    ),
                  ),

            //Excel
            controller.isLoadingExcel
                ? const SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ))
                : IconButton(
                    onPressed: () => controller.exportToExcel(columns: tableOptions.tableColumns, rows: tableOptions.tableRows),
                    icon: Stack(
                      children: [
                        const Icon(
                          Icons.grid_on_rounded,
                          color: Colors.white,
                        ),
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: Container(
                            color: Colors.white,
                            child: Icon(
                              Icons.clear,
                              color: primaryColor,
                              size: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

            //fullScreen
            IconButton(
              onPressed: () {
                if (tableOptions.isFullScreenMode) {
                  tableOptions.isFullScreenMode = false;
                  controller.update();
                  Get.back();
                } else {
                  tableOptions.isFullScreenMode = true;

                  Get.to(
                    () => ShowTableFullSreccn(
                      title: Text(tableOptions.fullScreenTitle ?? ""),
                      child: tableView(tableOPtions: tableOptions),
                    ),
                  );
                }
              },
              icon: Icon(
                tableOptions.isFullScreenMode ? Icons.fullscreen_exit : Icons.fullscreen,
                color: Colors.white,
              ),
            ),

            //TableSetting
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                Get.dialog(
                  useSafeArea: true,
                  AlertDialog(
                    insetPadding: const EdgeInsets.all(0),
                    contentPadding: const EdgeInsets.all(0),
                    content: SizedBox(
                      height: 400,
                      width: (Get.width / 4) * 3,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(width: 1, color: Colors.black),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: TableSetting(
                          tableOptions: tableOptions,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    ),
  );
}
