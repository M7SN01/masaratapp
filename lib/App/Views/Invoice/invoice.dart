import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/invoice_controller.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../utils/utils.dart';
import '../../Widget/widget.dart';

class Invoice extends StatelessWidget {
  const Invoice({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InvoiceController>(
      // init: InvoiceController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                if (controller.selectedInvTypeId != null || controller.selecetdCustomer != null) {
                  Get.defaultDialog(
                    radius: 8,
                    title: "هل تريد حذف الفاتورة؟",
                    middleText: "لن تتمكن من استرجاعها لاحقًا",
                    confirm: ElevatedButton(
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
                      onPressed: () {
                        controller.clearInvoiceData();
                        Get.back();
                      },
                      child: Text("موافق"),
                    ),
                    cancel: ElevatedButton(
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("إلغاء"),
                    ),
                  );
                }
              },
              icon: Icon(Icons.delete_forever_rounded, color: secondaryColor),
            ),
          ],
        ),
        body: Card(
          margin: EdgeInsets.all(20),
          elevation: 1,
          // surfaceTintColor: Colors.amberAccent,
          child: Column(
            children: [
              ///heder  inv type , customer
              IntrinsicHeight(
                child: Row(
                  children: [
                    //INv Type
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), border: Border.all(width: 1, color: Colors.deepPurpleAccent, strokeAlign: BorderSide.strokeAlignInside)),
                        height: 60,
                        // margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: dropDownList(
                          initialText: "نوع الفاتورة",
                          iconColor: primaryColor,
                          chosedItem: controller.selectedInvType, // now nullable
                          showedList: controller.act.map((e) => e.actName).toList(),
                          callback: (val) {
                            controller.selectedInvType = val;
                            final selected = controller.act.firstWhere((e) => e.actName == val);
                            print('Selected actId: ${selected.actId}');
                            controller.selectedInvTypeId = selected.actId.toString();
                            controller.update();
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 10),

                    //chose customer
                    Expanded(
                      // flex: 1,
                      child: GestureDetector(
                        child: Container(height: double.infinity, decoration: BoxDecoration(color: controller.selecetdCustomer == null ? primaryColor : secondaryColor, border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(5), shape: BoxShape.rectangle), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.checklist_rounded, color: Colors.white), const SizedBox(width: 10), Text("إختر عميل", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))])),
                        onTap: () {
                          showDialog(
                            useSafeArea: true,
                            context: context,
                            builder: (context) {
                              return SearchListDialog(
                                title: "اختر عميل",
                                originalData: controller.cusData.map((e) => SearchList(id: e.cusId, name: e.cusName)).toList(),
                                onSelected: (selectedItem) {
                                  controller.selecetdCustomer = controller.cusData.firstWhere((e) => e.cusId == selectedItem.id);
                                  // controller.selectedCustomer = selectedItem.name;
                                  // controller.selectedInvCustomerId = selectedItem.name;
                                  controller.update();
                                  Get.back();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // if (controller.selecetdCustomer != null)
              AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  // final isShowing = child.key != const ValueKey('empty');
                  final begin = controller.selecetdCustomer != null ? const Offset(1, 0) : Offset(-1, 0); //in=> on x from 1 to zero 1,1 => 0,0
                  final end = controller.selecetdCustomer != null ? Offset.zero : Offset(0, 0); // out =>  on -x ?????
                  return SlideTransition(position: Tween<Offset>(begin: begin, end: end).animate(animation), child: child);
                },
                //FadeTransition(opacity: animation, child: child),
                child: controller.selecetdCustomer != null
                    ? Card(
                        margin: EdgeInsets.all(4),
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: primaryColor, width: 0.5)),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(height: 5),
                                    Row(children: [Text("اسم العميل :"), SizedBox(width: 10), Text(controller.selecetdCustomer!.cusName)]),
                                    Divider(),
                                    Row(children: [Text("جوال العميل :"), SizedBox(width: 10), Text(controller.selecetdCustomer!.mobl ?? "")]),
                                    Divider(),
                                    Row(children: [Text("العنوان"), SizedBox(width: 10), Text(controller.selecetdCustomer!.adrs ?? "")]),
                                    Divider(),
                                    Row(children: [Text("الرقم الضريبي"), SizedBox(width: 10), Text(controller.selecetdCustomer!.taxNo ?? "")]),
                                    Divider(),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: IconButton(
                                onPressed: () {
                                  // print("ddddddddddddddddddddddddddddd");
                                  controller.selecetdCustomer = null;
                                  controller.update();
                                },
                                icon: Icon(Icons.cancel_rounded, color: secondaryColor, size: 30),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink(key: ValueKey('empty')),
              ),

              Divider(height: 8),
              //add item
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  controller.isPostedBefor
                      ? Text(" ${controller.selectedInvType} ( ${controller.savedInvoiceId} )", style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center)
                      : Expanded(
                          child: TextButton(
                            onPressed: () {
                              if (controller.selectedInvTypeId != null) {
                                controller.searchTextController.text = "";
                                // controller.filteredItems.clear();

                                controller.addNewItems();
                              } else {
                                controller.showInvTypemsg();
                              }
                            },
                            style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), backgroundColor: Colors.deepPurpleAccent),
                            child: Text("اضافة صنف", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                ],
              ),
              Divider(height: 8),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: controller.invDescription,
                        enabled: !controller.isPostedBefor,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          labelText: "الوصف",
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                          border: OutlineInputBorder(gapPadding: 10, borderSide: BorderSide(color: primaryColor, width: 1), borderRadius: BorderRadius.all(Radius.circular(8))),
                        ),
                        cursorColor: primaryColor,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى ادخال الوصف';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),

              Divider(height: 8),
              Expanded(
                flex: 5,
                child:
                    //  controller.rows.isNotEmpty
                    //     ?
                    PlutoGrid(
                  mode: PlutoGridMode.selectWithOneTap,
                  columns: controller.columns,
                  /*
                        [
                      PlutoColumn(
                        title: "",
                        field: 'ACTION',
                        textAlign: PlutoColumnTextAlign.center,
                        titleTextAlign: PlutoColumnTextAlign.center,
                        type: PlutoColumnType.text(),
                        backgroundColor: primaryColor,
                        // suppressedAutoSize: true,
                        // titlePadding: EdgeInsets.all(0),
                        width: 120,
                        titleSpan: WidgetSpan(
                          child: SizedBox(
                            width: 120,
                            child: TextButton(
                              onPressed: () async {
                                await controller.printInvoice();
                              },
                              style: TextButton.styleFrom(
                                maximumSize: Size(Get.width, Get.height),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                backgroundColor: primaryColor,
                              ),
                              child: Icon(
                                Icons.print_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        enableContextMenu: false,
                        enableEditingMode: false,
                        enableColumnDrag: false,
                        // enableAutoEditing: false,
                        enableDropToResize: false,
                        enableFilterMenuItem: false,
                        enableHideColumnMenuItem: false,
                        // enableRowChecked: false,
                        enableSorting: false,
                        // enableRowDrag: false,
                        enableSetColumnsMenuItem: false,
                        frozen: PlutoColumnFrozen.start,
                        renderer: (rendererContext) {
                          // rendererContext.cell.column.cellPadding = EdgeInsets.all(1);
                          // rendererContext.cell.row.cells['ACTION']!.column.backgroundColor = secondaryColor;
                          return TextButton(
                            onPressed: () {
                              rendererContext.stateManager.removeRows([rendererContext.row]);
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              backgroundColor: secondaryColor,
                            ),
                            child: Icon(
                              Icons.clear_rounded,
                              color: Colors.white,
                            ),
                          );
                        },
                        footerRenderer: (context) {
                          // context.stateManager.r cell.column.cellPadding = EdgeInsets.zero;
                          // rendererContext.cell.row.cells['ACTION']!.column.backgroundColor = secondaryColor;
                          return controller.isPostingToApi
                              ? Center(child: CircularProgressIndicator(color: Colors.white))
                              : TextButton(
                                  onPressed: () {
                                    controller.saveInvoice();
                                  },
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    backgroundColor: saveColor,
                                  ),
                                  child: Text(
                                    "حـفـظ",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                );
                        },
                      ),
                      PlutoColumn(
                        title: "الباركود",
                        field: 'BARCODE',
                        textAlign: PlutoColumnTextAlign.center,
                        titleTextAlign: PlutoColumnTextAlign.center,
                        type: PlutoColumnType.text(),
                        backgroundColor: primaryColor,
                        width: 90,
                        suppressedAutoSize: true,
                        titleSpan: autoMultiLineColumn("الباركود"),
                        enableContextMenu: false,
                        enableEditingMode: false,
                        enableColumnDrag: false,
                        hide: true,
                      ),
                      PlutoColumn(
                        title: "رقم الصنف",
                        field: 'ITEM_ID',
                        textAlign: PlutoColumnTextAlign.center,
                        titleTextAlign: PlutoColumnTextAlign.center,
                        type: PlutoColumnType.text(),
                        backgroundColor: primaryColor,
                        suppressedAutoSize: true,
                        width: 100,
                        titleSpan: autoMultiLineColumn("رقم الصنف"),
                        enableContextMenu: false,
                        enableEditingMode: false,
                        enableColumnDrag: false,
                        footerRenderer: (context) {
                          // context.stateManager.r cell.column.cellPadding = EdgeInsets.zero;
                          // rendererContext.cell.row.cells['ACTION']!.column.backgroundColor = secondaryColor;
                          return TextButton(
                            onPressed: () {
                              controller.showInPdf();
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              backgroundColor: controller.isPostedBefor ? saveColor : disabledColor,
                            ),
                            child: Text(
                              "طباعة/عرض",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                      ),
                      PlutoColumn(
                        title: "اسم الصنف",
                        field: 'ITEM_NAME',
                        textAlign: PlutoColumnTextAlign.center,
                        titleTextAlign: PlutoColumnTextAlign.center,
                        type: PlutoColumnType.text(),
                        backgroundColor: primaryColor,
                        // width: 110,
                        suppressedAutoSize: true,
                        titleSpan: autoMultiLineColumn("اسم الصنف"),
                        enableContextMenu: false,
                        enableEditingMode: false,
                        enableColumnDrag: false,
                        footerRenderer: (rendererContext) {
                          return PlutoAggregateColumnFooter(
                            rendererContext: rendererContext,
                            type: PlutoAggregateColumnType.count,
                            alignment: Alignment.center,
                            titleSpanBuilder: (p0) => [
                              // const TextSpan(
                              //   text: ' : ',
                              //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              // ),
                              TextSpan(
                                text: p0,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '   ',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "اصناف",
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        },
                      ),
                      PlutoColumn(
                        title: "الكمية",
                        field: 'QTY',
                        textAlign: PlutoColumnTextAlign.center,
                        titleTextAlign: PlutoColumnTextAlign.center,
                        type: PlutoColumnType.number(),
                        backgroundColor: primaryColor,
                        width: 90,
                        suppressedAutoSize: true,
                        titleSpan: autoMultiLineColumn("الكمية"),
                        enableContextMenu: false,
                        enableColumnDrag: false,
                        enableEditingMode: false,

                        // renderer: (rendererContext) {
                        //   return editqty(rendererContext);
                        // },

                        footerRenderer: (rendererContext) {
                          return PlutoAggregateColumnFooter(
                            rendererContext: rendererContext,
                            type: PlutoAggregateColumnType.sum,
                            alignment: Alignment.center,
                            titleSpanBuilder: (p0) => [
                              TextSpan(
                                //controller.getSumOfAllCellsByFiled(controller.rows, "QTY").toString()
                                text: p0,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        },
                        // hide: true,
                      ),
                      PlutoColumn(
                        title: "العبوة",
                        field: 'UNIT',
                        textAlign: PlutoColumnTextAlign.center,
                        titleTextAlign: PlutoColumnTextAlign.center,
                        type: PlutoColumnType.text(),
                        backgroundColor: primaryColor,
                        width: 90,
                        suppressedAutoSize: true,
                        titleSpan: autoMultiLineColumn("العبوة"),
                        enableContextMenu: false,
                        enableEditingMode: false,
                        enableColumnDrag: false,
                        // hide: true,
                      ),
                      PlutoColumn(
                        title: "السعر",
                        field: 'PRICE',
                        textAlign: PlutoColumnTextAlign.center,
                        titleTextAlign: PlutoColumnTextAlign.center,
                        type: PlutoColumnType.currency(format: '#,###.###'),
                        backgroundColor: primaryColor,
                        width: 120,
                        suppressedAutoSize: true,
                        titleSpan: autoMultiLineColumn("السعر"),
                        enableContextMenu: false,
                        enableEditingMode: false,
                        enableColumnDrag: false,
                        footerRenderer: (rendererContext) {
                          return PlutoAggregateColumnFooter(
                            rendererContext: rendererContext,
                            type: PlutoAggregateColumnType.sum,
                            alignment: Alignment.center,
                            format: "#,###.##",
                            titleSpanBuilder: (p0) => [
                              TextSpan(
                                text: p0,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        },
                      ),
                      PlutoColumn(
                        title: "السعر شامل الضريبة",
                        field: 'PRICE_AFTR_VAT',
                        textAlign: PlutoColumnTextAlign.center,
                        titleTextAlign: PlutoColumnTextAlign.center,
                        type: PlutoColumnType.currency(format: '#,###.###'),
                        backgroundColor: primaryColor,
                        width: 120,
                        suppressedAutoSize: true,
                        titleSpan: autoMultiLineColumn("السعر شامل الضريبة"),
                        enableContextMenu: false,
                        enableEditingMode: false,
                        enableColumnDrag: false,
                        footerRenderer: (rendererContext) {
                          return PlutoAggregateColumnFooter(
                            rendererContext: rendererContext,
                            type: PlutoAggregateColumnType.sum,
                            alignment: Alignment.center,
                            format: "#,###.##",
                            titleSpanBuilder: (p0) => [
                              TextSpan(
                                text: p0,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        },
                      ),
                      /*
      PlutoColumn(
        title: "الخصم",
        field: 'DISCOUNT',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.currency(format: '#,###.###'),
        backgroundColor: primaryColor,
        width: 120,
        suppressedAutoSize: true,
        titleSpan: autoMultiLineColumn("الخصم"),
        enableContextMenu: false,
        enableEditingMode: false,
        enableColumnDrag: false,
        footerRenderer: (rendererContext) {
          return PlutoAggregateColumnFooter(
            rendererContext: rendererContext,
            type: PlutoAggregateColumnType.sum,
            alignment: Alignment.center,
            format: "#,###.##",
            titleSpanBuilder: (p0) => [
              TextSpan(
                text: p0,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          );
        },
      ),
    */
                      PlutoColumn(
                        title: "الاجمالي",
                        field: 'TOTAL',
                        textAlign: PlutoColumnTextAlign.center,
                        titleTextAlign: PlutoColumnTextAlign.center,
                        type: PlutoColumnType.currency(format: '#,###.###'),
                        backgroundColor: primaryColor,
                        width: 120,
                        suppressedAutoSize: true,
                        titleSpan: autoMultiLineColumn("الاجمالي"),
                        enableContextMenu: false,
                        enableEditingMode: false,
                        enableColumnDrag: false,
                        footerRenderer: (rendererContext) {
                          return PlutoAggregateColumnFooter(
                            rendererContext: rendererContext,
                            type: PlutoAggregateColumnType.sum,
                            alignment: Alignment.center,
                            format: "#,###.##",
                            titleSpanBuilder: (p0) => [
                              TextSpan(
                                text: p0,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                    */
                  rows: controller.rows,
                  onLoaded: (PlutoGridOnLoadedEvent event) {
                    controller.stateManager = event.stateManager;

                    // event.stateManager.setRowGroup(
                    //   PlutoRowGroupByColumnDelegate(
                    //     columns: [
                    //       event.stateManager.columns[tableColumn.indexWhere((element) => element.field == groupRowByColumnName)],
                    //     ],
                    //     showFirstExpandableIcon: false,
                    //   ),
                    // );
                  },
                  onChanged: (event) {
                    // controller.update();
                  },
                  onRowSecondaryTap: (event) {
                    print("sssssssssssssssssssssssssssssssss");
                  },
                  onRowDoubleTap: (event) {
                    // print("fffffffffffff00ffffff : ${event.cell.column.field}");
                    if (event.cell.column.field == 'QTY') {
                      int? rowIndex = event.rowIdx;
                      controller.editqty(rowIndex);
                      // event.row.
                    }
                  },
                  onSelected: (event) {
                    print("select .........................");
                    if (event.cell!.column.field == 'QTY') {
                      int? rowIndex = event.rowIdx;
                      if (rowIndex != null) {
                        controller.editqty(rowIndex);
                        // controller.stateManager!.clearCurrentCell();
                        // controller.stateManager!.setCurrentSelectingPosition(notify: false);
                        // event.selectedRows!.;
                      }
                    }
                  },
                  configuration: configuration,
                  // createFooter: (stateManager) {
                  //   stateManager.createFooter;
                  //   return controller.customFooter();
                  // },
                ),
                // : Center(
                //     child: controller.tableLoading
                //         ? Center(child: const CircularProgressIndicator())
                //         : const SizedBox(
                //             child: Text("No Data"),
                //           ),
                //   ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
