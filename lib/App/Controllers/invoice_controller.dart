import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:masaratapp/App/samples/slmaples.dart';
import '../Controllers/user_controller.dart';
import '../Widget/widget.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../Models/user_model.dart';
import '../Print/direct_print.dart';
import '../Print/helpers/table_to_data_list.dart';
import '../Print/pdf_viewer.dart';
import '../Services/api_db_services.dart';
import '../utils/utils.dart';

class InvoiceController extends GetxController {
  late UserController userController;
  PlutoGridStateManager? stateManager;
  final Services dbServices = Services();

  String? selectedInvType;
  String? selectedInvTypeId;
  List<ActPrivModel> act = [];
  CusDataModel? selecetdCustomer;
  List<CusDataModel> cusData = [];

  List<ItemsDataModel> itemsData = [];
  //------------------dt

  bool isPostingToApi = false;
  bool isPostedBefor = false;

  TextEditingController searchTextController = TextEditingController();

  late List<PlutoColumn> columns;
  List<PlutoRow> rows = [];

  String savedInvoiceId = "";
  String savedInvoiceDate = "";
  TextEditingController invDescription = TextEditingController();

  @override
  void onInit() {
    userController = Get.find<UserController>();
    //int.parse("53${userController.uId}"), int.parse("57${userController.uId}"),
    act = userController.actPrivList.where((e) => [58, 59, 60, 61, 77, 99].contains(e.actId)).toList();
    cusData = userController.cusDataList;
    itemsData = userController.itemsDataList;

    columns = [
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
                await printInvoiceDirectly();
              },
              style: TextButton.styleFrom(maximumSize: Size(Get.width, Get.height), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), backgroundColor: primaryColor),
              child: Icon(isPostedBefor ? Icons.print_rounded : Icons.print_disabled_rounded, color: isPostedBefor ? Colors.white : disabledColor),
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
              removeRowByIndex(rendererContext.rowIdx);
            },
            style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), backgroundColor: secondaryColor),
            child: const Icon(Icons.clear_rounded, color: Colors.white),
          );
        },
        footerRenderer: (context) {
          return isPostingToApi
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : TextButton(
                  onPressed: () {
                    saveInvoice();
                  },
                  style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), backgroundColor: rows.isNotEmpty ? saveColor : disabledColor),
                  child: const Text("حـفـظ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                );
        },
      ),
      PlutoColumn(title: "الباركود", field: 'BARCODE', textAlign: PlutoColumnTextAlign.center, titleTextAlign: PlutoColumnTextAlign.center, type: PlutoColumnType.text(), backgroundColor: primaryColor, width: 90, suppressedAutoSize: true, titleSpan: autoMultiLineColumn("الباركود"), enableContextMenu: false, enableEditingMode: false, enableColumnDrag: false, hide: true),
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
              showInvoiceInPdfPreviewer();
            },
            style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), backgroundColor: isPostedBefor ? saveColor : disabledColor),
            child: const Text("طباعة/عرض", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
              TextSpan(text: p0, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const TextSpan(text: '   ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const TextSpan(text: "اصناف", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
          return PlutoAggregateColumnFooter(rendererContext: rendererContext, type: PlutoAggregateColumnType.sum, alignment: Alignment.center, format: "#,###.##", titleSpanBuilder: (p0) => [TextSpan(text: p0, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]);
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
          return PlutoAggregateColumnFooter(rendererContext: rendererContext, type: PlutoAggregateColumnType.sum, alignment: Alignment.center, format: "#,###.##", titleSpanBuilder: (p0) => [TextSpan(text: p0, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]);
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
          return PlutoAggregateColumnFooter(rendererContext: rendererContext, type: PlutoAggregateColumnType.sum, alignment: Alignment.center, format: "#,###.##", titleSpanBuilder: (p0) => [TextSpan(text: p0, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]);
        },
      ),
    ];

    super.onInit();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  showInvTypemsg() {
    showMessage(color: secondaryColor, titleMsg: "يرجئ تحديد نوع الفاتورة ", titleFontSize: 18, durationMilliseconds: 1000);
  }

  addPlutoRow(ItemsDataModel item) {
    bool exists = rows.any((row) => row.cells['ITEM_ID']?.value == item.itemId);
    if (item.qty == 0) {
      showMessage(color: secondaryColor, titleMsg: "الرجاء ادخال الكمية", titleFontSize: 18, durationMilliseconds: 1000);
    } else if (exists) {
      showMessage(color: secondaryColor, titleMsg: "الصنف مضاف بالفعل", titleFontSize: 16, msg: item.itemName, msgFontSize: 16, durationMilliseconds: 1000);
    } else {
      stateManager?.appendRows([
        PlutoRow(
          cells: {
            'ACTION': PlutoCell(value: ""),
            'BARCODE': PlutoCell(value: item.barcode.toString()),
            'ITEM_ID': PlutoCell(value: item.itemId.toString()),
            'ITEM_NAME': PlutoCell(value: item.itemName.toString()),
            'UNIT': PlutoCell(value: item.unit.toString()),
            'QTY': PlutoCell(value: item.qty),
            'PRICE': PlutoCell(value: (item.price1) /*  * (item.qty)   */),
            'PRICE_AFTR_VAT': PlutoCell(value: (item.priceAftrVat /* * item.qty  */)),
            /* 'DISCOUNT': PlutoCell(value: 0),*/
            'TOTAL': PlutoCell(value: (item.priceAftrVat * item.qty) /* - item.discount*/),
          },
        ),
      ]);
      showMessage(color: primaryColor, titleMsg: "تم اضافة الصنف", titleFontSize: 16, msg: item.itemName, msgFontSize: 16, durationMilliseconds: 1000);
      update();
    }
  }

  List<ItemsDataModel> filteredItems = [];

  void filterSearch(String query) {
    if (query.isEmpty) {
      final results = itemsData.where((item) => item.qty > 0).toList();
      results.sort((a, b) => (b.qty).compareTo(a.qty));
      filteredItems = results;
    } else {
      final results = itemsData.where((item) => item.itemName.toLowerCase().contains(query.toLowerCase())).toList();
      results.sort((a, b) => (b.qty).compareTo(a.qty));
      filteredItems = results;
    }
    update(); // Update the UI
  }

  TextEditingController qtytextController = TextEditingController();
  editqty(int index) {
    qtytextController.text = rows[index].cells['QTY']!.value.toStringAsFixed();
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Change this value for your desired radius
        ),
        title: SizedBox(
          // width: 200,
          child: Column(children: [const Text("إدخل الكمية", textAlign: TextAlign.center), const Divider(), Text(rows[index].cells['ITEM_NAME']!.value.toString(), textAlign: TextAlign.center)]),
        ),
        titlePadding: const EdgeInsets.all(10),
        contentPadding: const EdgeInsets.all(10),
        actionsPadding: const EdgeInsets.all(10),
        content: TextFormField(
          controller: qtytextController,

          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          textAlignVertical: const TextAlignVertical(y: -0.8),
          decoration: const InputDecoration(border: OutlineInputBorder(gapPadding: 4, borderSide: BorderSide(width: 2, color: Colors.grey), borderRadius: BorderRadius.all(Radius.circular(4)))),
          //    onChanged: controller.filterSearch,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    // stateManager!.rows[index].cells
                    rows[index].cells['QTY']!.value = int.parse(qtytextController.text);
                    rows[index].cells['PRICE']!.value = rows[index].cells['QTY']!.value /*   * rows[index].cells['PRICE']!.value */;
                    rows[index].cells['PRICE_AFTR_VAT']!.value = rows[index].cells['QTY']!.value /*   * rows[index].cells['PRICE_AFTR_VAT']!.value  */;
                    rows[index].cells['TOTAL']!.value = (rows[index].cells['QTY']!.value * rows[index].cells['PRICE_AFTR_VAT']!.value) /* - rows[index].cells['DISCOUNT']!.value*/;
                    update();
                    Get.back();
                  },
                  style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), backgroundColor: Colors.greenAccent, textStyle: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                  child: const Text("حفظ"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  FocusNode fn = FocusNode();
  addNewItems() {
    if (isPostedBefor) {
      //محفوظة مسبقا
      showMessage(color: secondaryColor, titleMsg: "الفاتورة محفوظة مسبقا", titleFontSize: 18, durationMilliseconds: 1000);
    } else {
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          title: Container(
            height: 100,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]),
            child: Column(
              children: [
                const Text("اضافة اصناف للفاتورة"),
                const Divider(),
                SizedBox(
                  height: 45,
                  child: GetBuilder<InvoiceController>(
                    builder: (controller) => TextFormField(
                      focusNode: controller.fn,
                      controller: controller.searchTextController,
                      keyboardType: TextInputType.text,
                      textAlignVertical: const TextAlignVertical(y: -0.4),
                      decoration: InputDecoration(labelText: "search".tr, labelStyle: const TextStyle(fontWeight: FontWeight.bold), suffixIcon: const Icon(Icons.search, color: primaryColor), border: const OutlineInputBorder(gapPadding: 4, borderSide: BorderSide.none)),
                      // onTapOutside: (event) {
                      //   print("outside *****************************");
                      //   fn.unfocus();
                      // },
                      onChanged: controller.filterSearch,
                    ),
                  ),
                ),
              ],
            ),
          ),
          titlePadding: const EdgeInsets.only(top: 10, right: 10, left: 10),
          contentPadding: const EdgeInsets.all(10),
          actionsPadding: const EdgeInsets.all(10),
          content: Container(
            height: 400,
            width: 300,
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
            child: GetBuilder<InvoiceController>(
              builder: (controller) => ListView.builder(
                shrinkWrap: true,
                itemCount: controller.filteredItems.length,
                itemBuilder: (context, index) {
                  ItemsDataModel item = controller.filteredItems[index];
                  // final TextEditingController xx=TextEditingController();
                  bool exists = rows.any((row) => row.cells['ITEM_ID']?.value == item.itemId);

                  return Card(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(width: 0.08)),
                    // color: Colors.white,
                    elevation: 1,
                    child: ListTile(
                      key: ValueKey(item.itemId),
                      title: exists
                          ? Row(
                              children: [
                                Expanded(flex: 2, child: Center(child: Text(item.itemName, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)))),
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    child: Text("${item.qty}  - ${item.unit}", style: const TextStyle(fontWeight: FontWeight.bold, color: secondaryColor), textAlign: TextAlign.center),
                                    onTap: () {
                                      item.qty = 0;
                                      rows.removeWhere((row) => row.cells['ITEM_ID']?.value == item.itemId);
                                      update();
                                    },
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Center(child: Text(item.itemName, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)))),
                                SizedBox(
                                  height: 50,
                                  width: 70,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    //  textAlignVertical: const TextAlignVertical(y: -0.8),
                                    decoration: const InputDecoration(border: OutlineInputBorder(gapPadding: 4, borderSide: BorderSide(width: 0.5, color: primaryColor))),
                                    maxLength: 4,
                                    buildCounter: (context, {required currentLength, required isFocused, required maxLength}) => null,

                                    textAlign: TextAlign.center,
                                    onTap: () {
                                      print("ontap -------------------------------");
                                      //to change to number keyboard for qty input
                                      fn.unfocus();
                                    },
                                    onChanged: (value) {
                                      // print("----------------------------- : ${item.qty}");

                                      item.qty = int.tryParse(value) ?? 0;

                                      // print("+++++++++++++++++++++++++++++ : ${item.qty}");
                                      update();
                                    },
                                  ),
                                ),
                              ],
                            ),
                      onTap: () {
                        // print("============================ : ${item.qty}");

                        controller.addPlutoRow(item);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), backgroundColor: secondaryColor),
                    child: const Text("خروج", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  removeRowByIndex(int rowIdx) {
    if (isPostedBefor) {
      //محفوظة مسبقا
      showMessage(color: secondaryColor, titleMsg: "الفاتورة محفوظة مسبقا", titleFontSize: 18, durationMilliseconds: 1000);
    } else {
      rows.removeAt(rowIdx);
      // rendererContext.stateManager.removeRows([rendererContext.row]);
      update();
    }
  }

  /*
  Widget customFooter() {
    return Container(
      height: 50,
      width: 100,
      color: primaryColor,
    );
  }
*/
  TextEditingController cusName = TextEditingController();
  TextEditingController cusMobil = TextEditingController();
  TextEditingController cusArds = TextEditingController();
  TextEditingController cusTaxNo = TextEditingController();

  Map<String, dynamic> getVariablesData() {
    List<Map<String, dynamic>> tmp = [];
    num ttlQty = 0;
    double ttlPrice = 0;
    double ttlVat = 0;
    double ttlPriceAftrVat = 0;

    for (var row in rows) {
      tmp.add({
        "srl": row.sortIdx + 1,
        "item_id": row.cells['ITEM_ID']!.value,
        "item_name": row.cells['ITEM_NAME']!.value,
        "unit": row.cells['UNIT']!.value,
        "item_qty": row.cells['QTY']!.value,
        "item_price": row.cells['PRICE']!.value,
        "item_vat": row.cells['PRICE_AFTR_VAT']!.value,
        "item_total": row.cells['TOTAL']!.value,
      });
      ttlQty += row.cells['QTY']!.value;
      ttlPrice += row.cells['PRICE']!.value * row.cells['QTY']!.value;
      ttlVat += row.cells['PRICE']!.value * row.cells['QTY']!.value * 0.15;
      ttlPriceAftrVat += row.cells['TOTAL']!.value;
    }
    //repeat_element
    // variables = {...controller.variables, "repeat_element": tmp};
    return {
      "a_comp_name": userController.compData.aCompName,
      "a_activity": userController.compData.aActivity,
      "commercial_reg": userController.compData.commercialReg,
      "tax_no": userController.compData.taxNo,
      "mobile_no": userController.compData.tel,
      "e_comp_name": userController.compData.eCompName,
      "e_activity": userController.compData.eActivity,
      //
      "t_inv_type": "نوع الفاتورة",
      "inv_type": selectedInvType,
      "t_inv_no": "رقم الفاتورة",
      "inv_no": savedInvoiceId,
      "t_inv_date": "التاريخ",
      "inv_date": savedInvoiceDate,
      "t_cus_no": "عميل رقم",
      "cus_no": selecetdCustomer!.cusId.toString(),
      "t_cus_name": "اسم العميل",
      "cus_name": selecetdCustomer!.cusName,
      "t_cus_adrs": "العنوان",
      "cus_adrs": selecetdCustomer!.adrs,
      "t_cus_mobile": "رقم الهاتف",
      "cus_mobile": selecetdCustomer!.mobl,
      "t_cus_tax_no": "الرقم الضريبي",
      "cus_tax_no": selecetdCustomer!.taxNo,
      "t_inv_desc": "الوصف",
      "inv_desc": invDescription.text,
      //
      "h_srl": "N.",
      "h_item_id": "رقم الصنف",
      "h_item_name": "اسم الصنف",
      "h_unit": "العبوة",
      "h_item_qty": "الكمية",
      "h_item_price": "السعر",
      "h_item_vat": "س.ش.ض",
      "h_item_total": "الاجمالي",
      //
      "repeat_element": tmp,
      //
      "t_ttl_qty": "اجمالي الكمية",
      "ttl_qty": ttlQty.toString(),
      "t_ttl_price": "الاجمالي",
      "ttl_price": ttlPrice.toStringAsFixed(2),
      "t_ttl_vat": "الضريبة 15%",
      "ttl_vat": ttlVat.toStringAsFixed(2),
      "t_ttl_aftr_vat": "الاجمالي شامل الضريبة",
      "ttl_aftr_vat": ttlPriceAftrVat.toStringAsFixed(2),
    };
  }

  Future<void> printInvoiceDirectly() async {
    // isPostingToApi = false;
    // update();  //only for stop loading   ... for test only
    // print("Waite while printing ..............");
    if (isPostedBefor) {
      //execute
      Map x = tableDataToListData(tableRows: rows, tableColumns: columns);

      List<String> headers = x['tableColumns'];
      List<List<dynamic>> data = x["tableRows"];
      await printJsondirectly(tableHeader: headers, tableData: data, isfromJson: false);
    } else {
      showMessage(color: secondaryColor, titleMsg: "يرجى حفظ الفاتورة", titleFontSize: 18, durationMilliseconds: 1000);
    }
  }

  showInvoiceInPdfPreviewer() {
    if (isPostedBefor) {
      // Map x = tableDataToListData(tableRows: rows, tableColumns: columns);
      // List<String> hesders = x['tableColumns'];
      // List<List<dynamic>> data = x["tableRows"];
      //Get.to(() => PdfPreviewScreen(tableHeader: hesders, tableData: data, variables: const {}));
      PrintSamples ps = PrintSamples(compData: userController.compData);
      Get.to(() => PdfPreviewScreen(
            jsonLayout: ps.getSlsShowSample,
            variables: getVariablesData(),
          ));
    } else {
      showMessage(color: secondaryColor, titleMsg: "يرجى حفظ الفاتورة", titleFontSize: 18, durationMilliseconds: 1000);
    }
  }

  saveInvoice() async {
    // isPostedBefor = false;
    // update();
    if (isPostedBefor) {
      //محفوظة مسبقا
      showMessage(color: secondaryColor, titleMsg: "الفاتورة محفوظة مسبقا", titleFontSize: 18, durationMilliseconds: 1000);
    } else if (rows.isNotEmpty) {
      if (selecetdCustomer == null) {
        // print("No customer +++++++++++++++++");
        await addUnSavedCustomerInfo();
      } else {
        // print("There is a customer +++++++++++++++++");
        await postInvoiceToServer();
      }
    } else {
      showMessage(color: secondaryColor, titleMsg: "يرجى اضافة اصناف الى الفاتورة ", titleFontSize: 18, durationMilliseconds: 1000);
    }
  }

  addUnSavedCustomerInfo() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Change this value for your desired radius
        ),
        title: const Text("ادخل بيانات العميل", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        titlePadding: const EdgeInsets.all(10),
        contentPadding: const EdgeInsets.all(10),
        actionsPadding: const EdgeInsets.all(10),
        content: SizedBox(
          // height: 400,
          // width: 300,
          child: Card(
            margin: const EdgeInsets.all(4),
            elevation: 1,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: primaryColor, width: 0.5)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: cusName,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      textAlignVertical: const TextAlignVertical(y: -0.8),
                      decoration: const InputDecoration(labelText: "اسم العميل", labelStyle: TextStyle(fontWeight: FontWeight.bold), border: OutlineInputBorder(gapPadding: 4, borderSide: BorderSide())),
                      //    onChanged: controller.filterSearch,
                    ),
                    const Divider(),
                    TextFormField(
                      controller: cusMobil,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textAlign: TextAlign.center,
                      textAlignVertical: const TextAlignVertical(y: -0.8),
                      decoration: const InputDecoration(labelText: "جوال العميل", labelStyle: TextStyle(fontWeight: FontWeight.bold), border: OutlineInputBorder(gapPadding: 4, borderSide: BorderSide())),
                      //    onChanged: controller.filterSearch,
                    ),
                    const Divider(),
                    TextFormField(
                      controller: cusArds,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      textAlignVertical: const TextAlignVertical(y: -0.8),
                      decoration: const InputDecoration(labelText: "العنوان", labelStyle: TextStyle(fontWeight: FontWeight.bold), border: OutlineInputBorder(gapPadding: 4, borderSide: BorderSide())),
                      //    onChanged: controller.filterSearch,
                    ),
                    const Divider(),
                    TextFormField(
                      controller: cusTaxNo,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textAlign: TextAlign.center,
                      textAlignVertical: const TextAlignVertical(y: -0.8),
                      decoration: const InputDecoration(labelText: "الرقم الضريبي", labelStyle: TextStyle(fontWeight: FontWeight.bold), border: OutlineInputBorder(gapPadding: 4, borderSide: BorderSide())),
                      //    onChanged: controller.filterSearch,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    if (cusName.text.isEmpty) {
                      showMessage(color: secondaryColor, titleMsg: "ادخل اسم العميل", titleFontSize: 18, durationMilliseconds: 1000);
                    } else if (cusMobil.text.isEmpty) {
                      showMessage(color: secondaryColor, titleMsg: "ادخل رقم هاتف العميل", titleFontSize: 18, durationMilliseconds: 1000);
                    } else {
                      selecetdCustomer = CusDataModel(cusId: 0, cusName: cusName.text, mobl: cusMobil.text, adrs: cusArds.text, taxNo: cusTaxNo.text, isNewCus: true);
                      // print(DateFormat('MM/dd/yyyy HH:mm:ss').format(DateTime.now()));
                      update();
                      Get.back();
                    }
                  },
                  style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), backgroundColor: saveColor, textStyle: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  child: const Text("حفظ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // String userName = ""; //temp  get it after login
  // int userId = 1;
  Future<void> postInvoiceToServer() async {
    isPostingToApi = true;
    update();
    try {
      double vat = double.parse(rows.fold(0.0, (sum, item) => sum + (item.cells['PRICE_AFTR_VAT']!.value - item.cells['PRICE']!.value)).toStringAsFixed(2));
      double total = double.parse(rows.fold(0.0, (sum, item) => sum + item.cells['TOTAL']!.value).toStringAsFixed(2));

      final StringBuffer vatDetails = StringBuffer();
      // String barcode0;
      // String itemId0;
      // String unit0;
      // int qty0;
      // double price0;
      // double vat0;
      // double priceAftrVat0;

      for (PlutoRow row in rows) {
        final barcode0 = row.cells['BARCODE']!.value;
        final itemId0 = row.cells['ITEM_ID']!.value;
        final unit0 = row.cells['UNIT']!.value;
        final qty0 = row.cells['QTY']!.value;
        final price0 = row.cells['PRICE']!.value;
        final vat0 = double.parse((row.cells['PRICE_AFTR_VAT']!.value - row.cells['PRICE']!.value).toStringAsFixed(2));
        final priceAftrVat0 = row.cells['PRICE_AFTR_VAT']!.value;

        //  vatDetails += "INSERT INTO SLS_SHOW_DT (R_TP	R_ID,	BARCODE	,ITEM_ID	,UNIT	,QTY	,PRICE	,DISCNT	,HWMNY,SRL,VAT_IN	,IT_VAT	,VAT_VAL,PRICE_AFTR_VAT) VALUES('$selectedInvTypeId',last_serial,$barcode0,$itemId0,$unit0,$qty0,$price0,0,1,${row.sortIdx}, 1 , 15 , $vat0,$priceAftrVat0);";
        vatDetails.writeln(
          "INSERT INTO SLS_SHOW_DT "
          "(R_TP, R_ID, BARCODE, ITEM_ID, UNIT, QTY, PRICE, DISCNT, HWMNY, SRL, VAT_IN, IT_VAT, VAT_VAL, PRICE_AFTR_VAT) "
          "VALUES ('$selectedInvTypeId', last_serial, '$barcode0', '$itemId0', '$unit0', $qty0, $price0, 0, 1, ${row.sortIdx + 1}, 1, 15, $vat0, $priceAftrVat0);",
        );
      }

      // print("start posting-------------------------");
      String stmt = """
        DECLARE
          last_serial NUMBER;
        BEGIN
          
          --get last recorde R_ID and incress for the new insert
          --
          SELECT MAX(R_ID) INTO last_serial
          FROM SLS_SHOW_HD
          WHERE R_TP = '$selectedInvTypeId';
           
          last_serial := last_serial + 1;

          -- Inserting The Header
          INSERT INTO SLS_SHOW_HD 
          (
          R_TP ,R_ID,DATE1${selecetdCustomer!.isNewCus ? " " : " ,CUS_ID "}
          ,PUR_TTL,DSCR,CUS_NM,CUS_NM1,CUS_MOBILE,USR_INS,USR_INS_DATE,VAT_STATUS,VAT_PR,VAT,PRICE_TYPE,TAX_NO,SAVE_NO 
          )
          VALUES (
          '$selectedInvTypeId',last_serial,TO_DATE('${DateFormat('MM/dd/yyyy HH:mm:ss').format(DateTime.now())}', 'MM/DD/YYYY HH24:MI:SS') 
          ${selecetdCustomer!.isNewCus ? " " : " ,${selecetdCustomer!.cusId} "} 
          ,$total
          ,'$selectedInvType - ${userController.uName}','${selecetdCustomer!.cusName}','${selecetdCustomer!.adrs}','${selecetdCustomer!.mobl}'
          ,${userController.uId},TO_DATE('${DateFormat('MM/dd/yyyy HH:mm:ss').format(DateTime.now())}', 'MM/DD/YYYY HH24:MI:SS') 
          ,${selecetdCustomer!.vatStatus},${selecetdCustomer!.vatPr}
          ,$vat
          ,1
          ,'${selecetdCustomer!.taxNo}'
          ,1
          );

          --Inserting the detail
          $vatDetails
          
          COMMIT;
        END;
        """;

      // print(vatDetails);
      // debugPrint(vatDetails.toString(), wrapWidth: 1024);
      // print(stmt);
      var response = await dbServices.createRep(sqlStatment: stmt);
      // print("****************** $response   *************");
      //
      isPostingToApi = false;
      if (response.isEmpty) {
        isPostedBefor = true;

        response = await dbServices.createRep(sqlStatment: "SELECT MAX(R_ID) R_ID  FROM SLS_SHOW_HD WHERE USR_INS=${userController.uId}");

        // print("****************** ${response[0]['R_ID']}   *************");
        savedInvoiceId = response[0]['R_ID'].toStringAsFixed(0);
        savedInvoiceDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        showMessage(color: saveColor, titleMsg: "تم الحفظ", titleFontSize: 18, durationMilliseconds: 1000);
      }
    } catch (e) {
      isPostingToApi = false;
      isPostedBefor = false;
      userController.appLog += "${e.toString()} \n------------------------------------------\n";
      showMessage(color: secondaryColor, titleMsg: "posting error !", titleFontSize: 18, msg: e.toString(), durationMilliseconds: 1000);
    }

    update();
  }

  clearInvoiceData() {
    isPostingToApi = false;
    isPostedBefor = false;
    rows.clear();
    selecetdCustomer = null;
    selectedInvTypeId = null;
    selectedInvType = null;
    savedInvoiceId = "";
    invDescription.clear();

    update();
  }

  //
}
