import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../Controllers/user_controller.dart';
import '../Models/user_model.dart';
import '../Print/pdf_viewer.dart';
import '../Services/api_db_services.dart';
import '../Widget/widget.dart';
import '../samples/slmaples.dart';
import '../utils/utils.dart';

class CusKshfController extends GetxController {
  // bool isOpenFromCusBal = false;

  //مراجعةالحركات =>المدخلة من قبل المندوب فقط
  //كشف الحساب جميع حركات العميل في النظام
  final Services dbServices = Services();
  late UserController userController;
  PlutoGridStateManager? stateManager;

  late List<PlutoColumn> columns;
  List<PlutoRow> rows = [];

  final TextEditingController toDateController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController mnthDateController = TextEditingController();

  bool dateSwitcher = false;

  //-------------------------
  String? userId;
  String userName = "";
  late CompData compData;

  CusDataModel? selecetdCustomer;
  List<CusDataModel> cusData = [];

  bool isPostingToApi = false;
  bool isPostedBefor = false;

  String fromToDate = "";
  String previousDateBalance = "";

  @override
  void onInit() {
    userController = Get.find<UserController>();
    userId = userController.uId;
    userName = userController.uName;
    cusData = userController.cusDataList;
    compData = userController.compData;

    columns = [
      // PlutoColumn(
      //   title: "رقم الحركة",
      //   field: 'TRHEL',
      //   textAlign: PlutoColumnTextAlign.center,
      //   titleTextAlign: PlutoColumnTextAlign.center,
      //   type: PlutoColumnType.text(),
      //   backgroundColor: primaryColor,
      //   // width: 90,
      //   width: PlutoGridSettings.minColumnWidth,
      //   suppressedAutoSize: true,
      //   titleSpan: autoMultiLineColumn("رقم الحركة"),
      //   enableContextMenu: false,
      //   enableEditingMode: false,
      //   enableColumnDrag: false,
      //   // hide: true,
      // ),
      PlutoColumn(
        title: "نوع الحركة",
        field: 'TYPE',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.text(),
        backgroundColor: primaryColor,
        hide: true,
        suppressedAutoSize: true,
        titleSpan: autoMultiLineColumn("نوع الحركة"),
        enableContextMenu: false,
        enableEditingMode: false,
        enableColumnDrag: false,
      ),
      PlutoColumn(
        title: "اسم الحركة",
        field: 'ACT_TYPE',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.text(),
        backgroundColor: primaryColor,
        // width: 90,
        // width: PlutoGridSettings.minColumnWidth,
        suppressedAutoSize: true,
        titleSpan: autoMultiLineColumn("اسم الحركة"),
        enableContextMenu: false,
        enableEditingMode: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          Color textColor = Colors.black;

          if (rendererContext.row.cells['TRHEL']!.value.toString() == '1') {
            textColor = Colors.black;
          } else {
            textColor = Colors.redAccent;
          }
          return Text(
            rendererContext.cell.value.toString(),
            style: TextStyle(
              color: textColor,
              // fontWeight: FontWeight.bold,
            ),
          );
        },
        footerRenderer: (context) {
          return PlutoAggregateColumnFooter(
            rendererContext: context,
            type: PlutoAggregateColumnType.count,
            alignment: Alignment.center,
            titleSpanBuilder: (p0) => [
              TextSpan(
                text: p0,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "   حركة",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
      PlutoColumn(
        title: "رقم الحركة",
        field: 'ACT_NO',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.number(format: '#########'),
        backgroundColor: primaryColor,
        width: 110,
        // width: PlutoGridSettings.bodyMinWidth,
        suppressedAutoSize: true,
        titleSpan: autoMultiLineColumn("رقم الحركة"),
        enableContextMenu: false,
        enableEditingMode: false,
        enableColumnDrag: false,
        //
        renderer: (rendererContext) => openActDetail(
          accountYear: rendererContext.row.cells['ACCOUNT_SCH']!.value.toString(),
          actType: rendererContext.row.cells['TYPE']!.value.toString(),
          field: rendererContext.row.cells[rendererContext.column.field]!.value.toString(),
        ),
        // hide: true,
        footerRenderer: (context) {
          return isPostingToApi
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : TextButton(
                  onPressed: () {
                    printKshf();
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    backgroundColor: primaryColor,
                  ),
                  child: Icon(
                    Icons.print,
                    color: Colors.white,
                  ),
                );
        },
      ),
      PlutoColumn(
        title: "التاريخ",
        field: 'DATE',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.date(format: "yyyy-MM-dd"),
        backgroundColor: primaryColor,
        suppressedAutoSize: true,
        width: 100,
        titleSpan: autoMultiLineColumn("التاريخ"),
        enableContextMenu: false,
        enableEditingMode: false,
        enableColumnDrag: false,
      ),
      PlutoColumn(
        title: "الوصف",
        field: 'DESC',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.text(),
        backgroundColor: primaryColor,
        // width: 110,
        // width: PlutoGridSettings.minColumnWidth,
        suppressedAutoSize: true,
        titleSpan: autoMultiLineColumn("الوصف"),
        enableContextMenu: false,
        enableEditingMode: false,
        enableColumnDrag: false,
      ),
      PlutoColumn(
        title: "مدين",
        field: 'MD',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.currency(format: '#,###.###'),
        backgroundColor: primaryColor,
        width: 90,
        // width: PlutoGridSettings.minColumnWidth,
        suppressedAutoSize: true,
        titleSpan: autoMultiLineColumn("مدين"),
        enableContextMenu: false,
        enableColumnDrag: false,
        enableEditingMode: false,
        footerRenderer: (rendererContext) {
          return PlutoAggregateColumnFooter(
            rendererContext: rendererContext,
            type: PlutoAggregateColumnType.sum,
            alignment: Alignment.center,
            format: "#,###.##",
            titleSpanBuilder: (p0) => [
              TextSpan(
                text: p0,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
      PlutoColumn(
        title: "دائن",
        field: 'DN',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.currency(format: '#,###.###'),
        backgroundColor: primaryColor,
        width: 90,
        // width: PlutoGridSettings.minColumnWidth,
        suppressedAutoSize: true,
        titleSpan: autoMultiLineColumn("دائن"),
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
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
        // hide: true,
      ),
      PlutoColumn(
        title: "الرصيد",
        field: 'BAL',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.currency(format: '#,###.###'),
        backgroundColor: primaryColor,
        width: 120,
        // width: PlutoGridSettings.minColumnWidth,
        suppressedAutoSize: true,
        titleSpan: autoMultiLineColumn("الرصيد"),
        enableContextMenu: false,
        enableEditingMode: false,
        enableColumnDrag: false,
        // renderer: (rendererContext) {
        //   final currentRow = rendererContext.row;
        //   final previousRow = rendererContext.stateManager.rows.isNotEmpty && rendererContext.rowIdx > 0 ? rendererContext.stateManager.rows[rendererContext.rowIdx - 1] : null;

        //   final currentAMNTDN = currentRow.cells['DN']?.value ?? 0;
        //   final currentAMNTMD = currentRow.cells['MD']?.value ?? 0;
        //   final previousAMNT = previousRow?.cells['BAL']?.value ?? 0;

        //   // Calculate AMNT
        //   final amntValue = previousAMNT + currentAMNTMD - currentAMNTDN;
        //   // debugPrint("$currentAMNTDN + $currentAMNTMD + $previousAMNT = $amntValue");
        //   currentRow.cells['BAL']!.value = amntValue;
        //   rows[rendererContext.rowIdx].cells['BAL']!.value = amntValue;

        //   return Text(formatCurrency(amntValue.toString()));
        // },
      ),
    ];

    //to get injected cusId from customer Balance view
    final args = Get.arguments;
    if (args is Map && args['cusId'] is int) {
      final cusId = args['cusId'] as int;
      selecetdCustomer = cusData.firstWhereOrNull((e) => e.cusId == cusId);
      if (selecetdCustomer != null) {
        getKshfData();
      }
    }

    super.onInit();
  }

  @override
  void onClose() async {
    // await clearData();
    super.onClose();
  }

  clearData() {
    isPostingToApi = false;
    isPostedBefor = false;
    // selecetdCustomer!.previousBalance = null;
    selecetdCustomer = null;
    rows.clear();
    fromToDate = "";
    previousDateBalance = "";
    update();
  }

  Map<String, dynamic> getVariablesData() {
    List<Map<String, dynamic>> tmp = [];

    double ttlDN = 0;
    double ttlMD = 0;
    double ttlBAL = selecetdCustomer!.previousBalance ?? 0.0;

    for (var row in rows) {
      tmp.add({
        "srl": row.sortIdx + 1,
        "ACT_TYPE": row.cells['ACT_TYPE']!.value,
        "ACT_NO": row.cells['ACT_NO']!.value,
        "DATE": row.cells['DATE']!.value,
        "DESC": row.cells['DESC']!.value,
        "DN": row.cells['DN']!.value,
        "MD": row.cells['MD']!.value,
        "BAL": row.cells['BAL']!.value,
      });
      ttlDN += row.cells['DN']!.value;
      ttlMD += row.cells['MD']!.value;
      ttlBAL += row.cells['MD']!.value - row.cells['DN']!.value;
    }
    //last Row---
    tmp.add({
      "srl": "",
      "ACT_TYPE": "عدد الحركات",
      "ACT_NO": "${rows.length}",
      "DATE": "",
      "DESC": "الرصيد الحالي",
      "DN": "",
      "MD": "",
      "BAL": (ttlBAL).toStringAsFixed(2),
    });
    // ttlBAL = ttlMD - ttlDN;
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
      "t_kshf": "كشف حساب",
      "fromToDate": fromToDate,
      "t_ttl_PRV_BAL": "الرصيد السابق",
      "ttl_PRV_BAL": (selecetdCustomer!.previousBalance ?? 0.0).toStringAsFixed(2),

      "t_cus_no": "عميل رقم",
      "cus_no": selecetdCustomer == null ? "" : selecetdCustomer!.cusId.toString(),
      "t_cus_name": "اسم العميل",
      "cus_name": selecetdCustomer == null ? "" : selecetdCustomer!.cusName,
      "t_cus_adrs": "العنوان",
      "cus_adrs": selecetdCustomer == null ? "" : selecetdCustomer!.adrs,
      "t_cus_mobile": "رقم الهاتف",
      "cus_mobile": selecetdCustomer == null ? "" : selecetdCustomer!.mobl,
      "t_cus_tax_no": "الرقم الضريبي",
      "cus_tax_no": selecetdCustomer == null ? "" : selecetdCustomer!.taxNo,
      // "t_inv_desc": "الوصف",
      // "inv_desc": invDescription.text,
      //
      "h_srl": "N.",
      "h_ACT_TYPE": "نوع الحركة",
      "h_ACT_NO": "رقم الحركة",
      "h_DATE": "التاريخ",
      "h_DESC": "الوصف",
      "h_DN": "دائن",
      "h_MD": "مدين",
      "h_BAL": "الرصيد",
      //
      "repeat_element": tmp,
      //
      "t_ttl_DN": "دائن",
      "ttl_DN": ttlDN.toStringAsFixed(2),
      "t_ttl_MD": "مدين",
      "ttl_MD": ttlMD.toStringAsFixed(2),
      "t_ttl_BAL": "الرصيد حسب التاريخ",
      "ttl_BAL": (ttlMD - ttlDN).toStringAsFixed(2),
    };
  }

  void printKshf() {
    if (rows.isEmpty) {
      showMessage(color: secondaryColor, titleMsg: "لايوجد بيانات لطباعتها !", durationMilliseconds: 1000);
    } else {
      PrintSamples ps = PrintSamples(compData: userController.compData);
      Get.to(() => PdfPreviewScreen(
            jsonLayout: ps.getCusKshfSample,
            variables: getVariablesData(),
          ));
    }
  }

  Future<void> getKshfData() async {
    if (selecetdCustomer == null) {
      showMessage(color: secondaryColor, titleMsg: "اختر عميل لعرض الكشف !", durationMilliseconds: 1000);
    } else {
      isPostingToApi = true;
      selecetdCustomer!.previousBalance = null;
      update();
      // await Future.delayed(Duration(seconds: 3));
      try {
        String date = "";
        if (mnthDateController.text.isNotEmpty) {
          date = " AND TO_CHAR(DATE1,'yyyy-mm')='${mnthDateController.text}' ";
          fromToDate = mnthDateController.text;
        } else if (fromDateController.text.isNotEmpty && toDateController.text.isNotEmpty) {
          date = " AND DATE1 BETWEEN TO_DATE('${fromDateController.text}', 'YYYY/MM/DD') AND TO_DATE('${toDateController.text}', 'YYYY/MM/DD') ";
          fromToDate = "${fromDateController.text}  -  ${toDateController.text}";
        } else if (fromDateController.text.isNotEmpty && toDateController.text.isEmpty) {
          date = " AND DATE1 >= TO_DATE('${fromDateController.text}', 'YYYY/MM/DD')  ";
          fromToDate = "${fromDateController.text} >= ";
        }

        List<dynamic> response;
        //get the previousBalance of selected date
        if (date != "") {
          response = await dbServices.createRep(sqlStatment: """ SELECT APP_ACCOUNT.CUS_PRV_BAL(${selecetdCustomer!.cusId},null,
          ${fromDateController.text.isNotEmpty ? " TO_DATE('${fromDateController.text}', 'YYYY/MM/DD')" : " TO_DATE('${mnthDateController.text}-01', 'YYYY/MM/DD')"}
          ,2) CUS_PRV_BAL FROM DUAL""");
          //2 => جميع الحركات مرحل وغير مرحل
          if (response.isNotEmpty) {
            selecetdCustomer!.previousBalance = response[0]["CUS_PRV_BAL"];
          }
        }
        double previousBalance = selecetdCustomer!.previousBalance ?? 0;

        String cond = selecetdCustomer != null || date != "" ? " where 1=1  $date  ${selecetdCustomer != null ? " and cus_id=${selecetdCustomer!.cusId} " : ""}" : "";
        String stmt = "SELECT * FROM APP_ACCOUNT.CUS_HD_CUS_DT_TRANS_YRS $cond    AND CHK_CUS_USR_PRV(CUS_ID,$userId)=1  ";
        //  """
        //           select ACCOUNT_SCH,TRHEL,ACT_NAME,ACT_ID,DATE1,DESCR
        //          ,round(MD,2) MD,round(DN,2)DN
        //           ,CUS_ID,CS_CLS_ID,ACT_TP
        //           from ACC_MULTI.APP_CUS_HD_CUS_DT_TRANS  $cond    AND CHK_CUS_USR_PRV(CUS_ID,$userId)=1
        //           ORDER BY DATE1
        //           """;

        // debugPrint(stmt);

        response = await dbServices.createRep(sqlStatment: stmt);

        isPostingToApi = true;
        update();

        // debugPrint("****************** $response   *************");
        rows.clear();

        for (var element in response) {
          final double dn = (element['DN'] ?? 0).toDouble();
          final double md = (element['MD'] ?? 0).toDouble();
          final double currentBalance = previousBalance + md - dn;
          rows.add(
            PlutoRow(
              cells: {
                "ACCOUNT_SCH": PlutoCell(value: checkNullString(element['ACCOUNT_SCH'].toString())),
                "TRHEL": PlutoCell(value: checkNullString(element['TRHEL'].toString())),
                'ACT_TYPE': PlutoCell(value: checkNullString(element['ACT_NAME'].toString())),
                'TYPE': PlutoCell(value: checkNullString(element['ACT_TP'].toString())),
                'ACT_NO': PlutoCell(value: element['ACT_ID']),
                'DATE': PlutoCell(value: checkNullString(element['DATE1'].toString())),
                'DESC': PlutoCell(value: checkNullString(element['DESCR'].toString())),
                'DN': PlutoCell(value: element['DN']),
                'MD': PlutoCell(value: element['MD']),
                'BAL': PlutoCell(value: currentBalance),
              },
            ),
          );

          previousBalance = currentBalance;
        }
      } catch (e) {
        userController.appLog += "${e.toString()} \n------------------------------------------\n";
        showMessage(color: secondaryColor, titleMsg: "posting error !", titleFontSize: 18, msg: e.toString(), durationMilliseconds: 1000);
      }
      rows;
      isPostingToApi = false;
      update();
    }
  }

  ///---------------------------
  ///

  Map<String, dynamic> getInvoiceVariablesData({required responseHd, required responseDt}) {
    List<Map<String, dynamic>> tmp = [];
    num ttlQty = 0;
    double ttlPrice = 0;
    // double ttlVat = 0;
    // double ttlPriceAftrVat = 0;

    for (var row in responseDt) {
      tmp.add({
        "srl": row['SRL'].toString(),
        "item_id": row['ITEM_ID'].toString(),
        "item_name": row['ITEM_NAME'].toString(),
        "unit": row['UNIT'].toString(),
        "item_qty": row['QTY'].toString(),
        "item_price": row['PRICE'].toString(),
        "item_vat": row['VAT_VAL'].toString(),
        "item_total": row['PRICE_AFTR_VAT'].toString(),
      });
      ttlQty += row['QTY'];
      ttlPrice += row['PRICE'] * row['QTY'];
      // ttlVat += row['PRICE'] * row['QTY'] * 0.15;
      // ttlPriceAftrVat += row['PRICE_AFTR_VAT'];
    }
    double discount = responseHd[0]['DISCNT'];
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
      "inv_type": responseHd[0]['ACT_NAME'].toString(),
      "t_inv_no": "رقم الفاتورة",
      "inv_no": responseHd[0]['ST_ID'].toString(),
      "t_inv_date": "التاريخ",
      "inv_date": responseHd[0]['DATE1'].toString(),
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
      "inv_desc": responseHd[0]['DESCR'].toString(),
      //
      "h_srl": "N.",
      "h_item_id": "رقم الصنف",
      "h_item_name": "اسم الصنف",
      "h_unit": "العبوة",
      "h_item_qty": "الكمية",
      "h_item_price": "السعر",
      "h_item_vat": "الضريبة",
      "h_item_total": "الاجمالي",
      //
      "repeat_element": tmp,
      //
      "t_ttl_qty": "اجمالي الكمية",
      "ttl_qty": ttlQty.toString(),
      "t_ttl_price": "الاجمالي",
      "ttl_price": ttlPrice.toStringAsFixed(2),
      if (discount != 0) ...{
        "t_ttl_dis": "الخصم",
        "ttl_dis": discount.toString(), // responseHd[0]['DISCNT'].toString(),
        "t_ttl_aftr_dis": "بعد الخصم",
        "ttl_aftr_dis": (ttlPrice - discount).toStringAsFixed(2),
      } else ...{
        "t_ttl_dis": "\n",
        "ttl_dis": "\n", // responseHd[0]['DISCNT'].toString(),
        "t_ttl_aftr_dis": "\n",
        "ttl_aftr_dis": "\n",
      },

      "t_ttl_vat": "الضريبة 15%",
      "ttl_vat": responseHd[0]['ADDED_VALUE'].toString(),
      "t_ttl_aftr_vat": "الاجمالي شامل الضريبة",
      "ttl_aftr_vat": responseHd[0]['PUR_TTL'].toString(),
      "qr_data": zatcaQrBase64(
        sellerName: userController.compData.aCompName,
        vatNumber: userController.compData.taxNo,
        invoiceDate: responseHd[0]['USR_INS_DATE'].toString(),
        invoiceTotalWithVat: responseHd[0]['PUR_TTL'],
        vatTotal: responseHd[0]['ADDED_VALUE'],
      ),
    };
  }

//

  Map<String, dynamic> getSanadtVariablesData({required response}) {
    return {
      "a_comp_name": userController.compData.aCompName,
      "a_activity": userController.compData.aActivity,
      "t_commercial_reg": "رقم السجل التجاري",
      "commercial_reg": userController.compData.commercialReg,
      "t_tax_no": "الرقم الضريبي",
      "tax_no": userController.compData.taxNo,
      "t_mobile_no": "رقم الهاتف",
      "mobile_no": userController.compData.tel,
      "e_comp_name": userController.compData.eCompName,
      "e_activity": userController.compData.eActivity,
      "t_amount": "المبلغ",
      "amount": response[0]['AMNT'].toString(),
      "t_sanad_type": "${response[0]['ACT_NAME']}  ( ${response[0]['ACC_HD_ID'].toStringAsFixed(0)} )",
      "t_date": "التاريخ",
      "date": response[0]['DATE1'].toString(),
      "a_t_recive_from": "استلما من المكرم",
      "e_t_recive_from": "Recevied from Mr",
      "cus_name": response[0]['CUS_NAME'].toString(),
      "a_t_amount_words": "مبلغ وقدره",
      "e_t_amount_words": "The Amount",
      "amount_words": response[0]['AMNT'].toString(),
      "a_t_payment_for": "وذلك مقابل",
      "e_t_payment_for": "As Payment for",
      "payment_for": response[0]['DSCR'].toString(),
      "t_user_ins": "مدخل السند",
      "user_ins": response[0]['USER_INS_NAME'].toString(),
    };
  }

  Widget openActDetail({required accountYear, required actType, required field}) {
    if (!['53', '57', '58', '59', '60', '61'].contains(actType)) {
      return Container(
        color: Colors.transparent,
        child: Center(
          child: Text(
            field,
            // style: const TextStyle(color: Colors.blue),
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: () async {
        // print("ActType : $actType");
        // print("field : $field");
        //57,58,59,60,
        if (['58', '59', '60', '61'].contains(actType)) {
          openInvoice(accountYear: accountYear, actType: actType, field: field);
        } else if (['53', '57'].contains(actType)) {
          openSanad(accountYear: accountYear, actType: actType, field: field);
        }
        //53,57
      },
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Text(
            field,
            style: const TextStyle(color: Colors.blue),
          ),
        ),
      ),
    );
  }

  openSanad({required accountYear, required actType, required field}) async {
    // selectedSanadTypeId = item['ACC_TYPE'].toString();
    // selectedSanadType = item['ACT_NAME'].toString();
    // savedSanadId = item['ACC_HD_ID'].toString();
    // selecetdCustomer = controller.cusData.firstWhereOrNull((c) => c.cusId == item['CUS_ID']);
    // date.text = item['DATE1'].toString();
    // amount.text = item['AMNT'].toStringAsFixed(2);
    // description.text = item['DSCR'].toString();
    String stmt = "SELECT * FROM TABLE(APP_ACCOUNT.FN_KSHF_OPN_SND( '$accountYear',$actType,$field ,${selecetdCustomer!.cusId} ))";
    //  """
    //               SELECT a.CUS_ID,get_cus_name_DB(a.CUS_ID) CUS_NAME,a.ACC_TYPE,get_act_name(a.ACC_TYPE) ACT_NAME,a.ACC_HD_ID,round(a.AMNT,2) AMNT , a.DSCR ,
    //                         TO_CHAR(b.DATE1,'yyyy-mm-dd')  DATE1,GET_USER_NAME_DB(b.USR_INS) USER_INS_NAME
    //                         FROM $accountYear.ACC_DT a, $accountYear.ACC_HD b
    //                         WHERE b.ACC_TYPE=a.ACC_TYPE AND b.ACC_HD_ID=a.ACC_HD_ID  AND a.ACC_TYPE=$actType AND a.ACC_HD_ID=$field
    //                         AND a.CUS_ID=${selecetdCustomer!.cusId}
    //               """;
    var response = await dbServices.createRep(sqlStatment: stmt);

    // debugPrint(response.length.toString());
    try {
      response[0]['ACC_TYPE'];
    } catch (e) {
      showMessage(color: secondaryColor, titleMsg: "لايمكن عرض الفاتورة", msg: e.toString(), titleFontSize: 18, durationMilliseconds: 2000);
      return;
    }
//--------------
    if (response.isEmpty) return;

    PrintSamples ps = PrintSamples(compData: compData);
    Get.to(
      () => PdfPreviewScreen(
        // tableHeader: hesders,
        // tableData: data,
        jsonLayout: ps.getSanadSample,
        variables: getSanadtVariablesData(response: response),
      ),
    );
  }

  openInvoice({required accountYear, required actType, required field}) async {
    // int roundDigit = 2;
    String stmt = """SELECT * FROM TABLE(APP_ACCOUNT.GET_ST_HD_SNGL_ACT('$accountYear', $actType, $field))""";

    // """ SELECT ST_TYPE,get_act_name(ST_TYPE) ACT_NAME,ST_ID,TO_CHAR(DATE1, 'YYYY-MM-DD') DATE1,USR_INS_DATE,DESCR,CUS_ID,CUS_NM1,CUS_MOBILE,TAX_NO,NVL(ROUND(DISCNT,2),0)DISCNT,
    //                       ROUND(PUR_TTL,2)PUR_TTL,ROUND(ADDED_VALUE,2)ADDED_VALUE ,ROUND(VAT_PR,2)VAT_PR
    //                       FROM $accountYear.ST_HD
    //                       WHERE ST_TYPE=$actType  AND ST_ID=$id  """;
    // debugPrint(stmt);

    var responseHd = await dbServices.createRep(sqlStatment: stmt);
    debugPrint(responseHd.length.toString());
//--------------
    stmt = """SELECT * FROM TABLE(APP_ACCOUNT.GET_ST_DT_SNGL_ACT('$accountYear', $actType,$field))""";
    // """ SELECT SRL,ITEM_ID,GET_ITEM_NAME_DB(ITEM_ID) ITEM_NAME,UNIT,QTY,ROUND(PRICE,2)PRICE,ROUND(VAT_VAL,2)VAT_VAL ,ROUND(PRICE_AFTR_VAT,2)PRICE_AFTR_VAT
    //                       FROM $accountYear.ST_DT
    //                       WHERE ST_TYPE=$actType  AND ST_ID=$field  """;
    // debugPrint(stmt);

    var responseDt = await dbServices.createRep(sqlStatment: stmt);
    debugPrint(responseDt.length.toString());

    try {
      responseHd[0]['ST_TYPE'];
      responseDt[0]['ST_TYPE'];
    } catch (e) {
      showMessage(color: secondaryColor, titleMsg: "لايمكن عرض الفاتورة", msg: e.toString(), titleFontSize: 18, durationMilliseconds: 2000);
      return;
    }
//--------------
    if (responseHd.isEmpty || responseDt.isEmpty) return;

    // if (isPostedBefor) {
    PrintSamples ps = PrintSamples(compData: userController.compData);
    Get.to(() => PdfPreviewScreen(
          jsonLayout: ps.getSlsInvoiceSample,
          variables: getInvoiceVariablesData(responseHd: responseHd, responseDt: responseDt),
        ));
    // } else {
    //   showMessage(color: secondaryColor, titleMsg: "يرجى حفظ الفاتورة", titleFontSize: 18, durationMilliseconds: 1000);
    // }
  }

  /// ZATCA Phase-1 QR (Simplified Tax Invoice): TLV(Base64) of Tags 1..5.
  String zatcaQrBase64({
    required String sellerName,
    required String vatNumber,
    required String invoiceDate,
    required num invoiceTotalWithVat,
    required num vatTotal,
  }) {
    // ZATCA expects these values as UTF-8 bytes in TLV.
    // final ts = invoiceDate.toUtc().toIso8601String(); // commonly used format
    final total = invoiceTotalWithVat.toStringAsFixed(2);
    final vat = vatTotal.toStringAsFixed(2);

    final bytes = BytesBuilder()
      ..add(_tlv(tag: 1, value: sellerName))
      ..add(_tlv(tag: 2, value: vatNumber))
      ..add(_tlv(tag: 3, value: invoiceDate))
      ..add(_tlv(tag: 4, value: total))
      ..add(_tlv(tag: 5, value: vat));

    return base64Encode(bytes.toBytes());
  }

  /// TLV: [Tag:1 byte][Length:1 byte][Value:UTF8 bytes]
  Uint8List _tlv({required int tag, required String value}) {
    final v = utf8.encode(value);
    if (v.length > 255) {
      throw ArgumentError('TLV value too long for 1-byte length: tag=$tag');
    }
    return Uint8List.fromList([tag, v.length, ...v]);
  }
}

/*

Map<String, dynamic> getTestMap() {
  final controller = Get.find<SanadatController>();
  return containerW(
    // w: 600,
    // h: 400,
    // width: mmToPixel(210),
    height: 328, //mmToPixel(297 / 3),

    padding: [10, 10, 10, 10],
    containerDecorationW: containerDecorationW(
      containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
      radius: 4,
    ),
    child: columnW(
      children: [
        //Comp Header
        sizedBoxW(
          height: 110,
          child: rowW(
            children: [
              //Comp Arabic
              expandedW(
                flex: 1,
                child: columnW(
                  crossAxisAlignment: "center",
                  children: [
                    textW(
                      controller.compData.aCompName,
                      // "شركة مسارات الجمال",
                      fontSize: 18,
                      // textAlign: "center",
                      fontWeight: "bold",
                    ),
                    textW(
                      controller.compData.aActivity,
                      // "لبيع العطور ومستحضرات التجميل",
                      fontSize: 14,
                      // textAlign: "center",
                      fontWeight: "bold",
                    ),
                    // sizedBoxW(height: 2),
                    if (controller.compData.commercialReg.isNotEmpty)
                      rowW(
                        mainAxisAlignment: "center",
                        children: [
                          textW(
                            "رقم السجل التجاري",
                          ),
                          textW(
                            "  :  ",
                          ),
                          textW(
                            controller.compData.commercialReg,
                          ),
                        ],
                      ),
                    // sizedBoxW(height: 2),
                    if (controller.compData.taxNo.isNotEmpty)
                      rowW(
                        mainAxisAlignment: "center",
                        children: [
                          textW(
                            "الرقم الضريبي",
                            fontSize: 14,
                            // fontFamily: "arial",
                          ),
                          textW(
                            "  :  ",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                          textW(
                            controller.compData.taxNo,
                            // "310310589800003",
                            fontSize: 14,
                            // fontFamily: "arial",
                          ),
                        ],
                      ),
                    if (controller.compData.tel.isNotEmpty)
                      rowW(
                        mainAxisAlignment: "center",
                        children: [
                          textW(
                            "رقم الهاتف",
                            fontSize: 14,
                            // fontFamily: "arial",
                          ),
                          textW(
                            "  :  ",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                          textW(
                            controller.compData.tel,
                            // "310310589800003",
                            fontSize: 14,
                            // fontFamily: "arial",
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              //logo
              expandedW(
                flex: 1,
                child: containerW(padding: [0, 0, 0, 10], child: centerW(child: imageW(assetName: "assets/images/mlogo.png"))),
              ),
              //Comp english
              expandedW(
                flex: 1,
                child: columnW(
                  crossAxisAlignment: "center",
                  children: [
                    textW(
                      controller.compData.eCompName,
                      // "MASARAT AL-JAMAL",
                      fontSize: 18,
                      textAlign: "center",
                      fontWeight: "bold",
                    ),
                    textW(
                      controller.compData.eActivity,
                      // "For selling perfumes and cosmetics",
                      fontSize: 12,
                      textAlign: "center",
                      fontWeight: "bold",
                    ),
                    // sizedBoxW(height: 2),
                    if (controller.compData.commercialReg.isNotEmpty)
                      rowW(
                        mainAxisAlignment: "center",
                        children: [
                          textW(
                            controller.compData.commercialReg,
                            // "4030323869",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                          textW(
                            "  :  ",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                          textW(
                            "REG. NO.",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                        ],
                      ),
                    // sizedBoxW(height: 2),
                    if (controller.compData.taxNo.isNotEmpty)
                      rowW(
                        mainAxisAlignment: "center",
                        children: [
                          textW(
                            controller.compData.taxNo,
                            // "310310589800003",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                          textW(
                            "  :  ",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                          textW(
                            "TAX. NO. ",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                        ],
                      ),
                    if (controller.compData.tel.isNotEmpty)
                      rowW(
                        mainAxisAlignment: "center",
                        children: [
                          textW(
                            controller.compData.tel,
                            // "310310589800003",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                          textW(
                            "  :  ",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                          textW(
                            "Mobile No.",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        //header line
        rowW(
          children: [
            expandedW(
              child: containerW(
                containerDecorationW: containerDecorationW(
                  containerDecorationBorderW: containerDecorationBorderW(width: 1),
                ),
              ),
            ),
          ],
        ),
        // rowW(children: [expandedW(child: dashedLineW(dashSpace: 1, dashWidth: 2, height: 1))]),
        // expandedW(child: dashedLineW(dashSpace: 1, dashWidth: 2, height: 1)),
        sizedBoxW(height: 10),
        //type & date  & amount
        rowW(
          children: [
            //amount
            expandedW(
              // flex: 1,
              child: containerW(
                padding: [5, 5, 5, 5],
                // margin: [10, 0, 0, 0],
                containerDecorationW: containerDecorationW(
                  radius: 4,
                  containerDecorationBorderW: containerDecorationBorderW(width: 1),
                ),
                child: rowW(
                  mainAxisAlignment: "center",
                  children: [
                    textW("المبلغ", fontSize: 14),
                    textW("   :   ", fontSize: 14),
                    textW(controller.amount.text, fontSize: 14),
                    sizedBoxW(width: 10),
                    imageSvgW(
                      assetName: "assets/images/rs.svg",
                      height: 18,
                      width: 18,
                    ),
                  ],
                ),
              ),
            ),

            //sanad No
            expandedW(
              flex: 2,
              child: containerW(
                padding: [5, 5, 5, 5],
                margin: [10, 0, 10, 0],
                containerDecorationW: containerDecorationW(
                  radius: 4,
                  containerDecorationBorderW: containerDecorationBorderW(width: 1),
                ),
                child: rowW(
                  mainAxisAlignment: "center",
                  children: [
                    // textW(
                    //   controller.selectedSanadType ?? "",
                    //   fontSize: 14,
                    //   textAlign: "center",
                    //   // fontWeight: "bold",
                    // ),
                    // textW(
                    //   "  رقم  ",
                    //   fontSize: 14,
                    //   textAlign: "center",
                    //   // fontWeight: "bold",
                    // ),
                    textW(
                      controller.savedSanadId.toString(),
                      fontSize: 14,
                      textAlign: "center",
                      // fontWeight: "bold",
                    ),
                  ],
                ),
              ),
            ),

            //Date
            expandedW(
              // flex: 1,
              child: containerW(
                padding: [5, 5, 5, 5],
                // margin: [0, 0, 10, 0],
                containerDecorationW: containerDecorationW(
                  radius: 4,
                  containerDecorationBorderW: containerDecorationBorderW(width: 1),
                ),
                child: rowW(
                  mainAxisAlignment: "center",
                  children: [
                    textW("التاريخ", fontSize: 14),
                    textW("   :   ", fontSize: 14),
                    textW(controller.date.text, fontSize: 14),
                    // sizedBoxW(width: 10),
                  ],
                ),
              ),
            ),
          ],
        ),

        //line Top
        /* rowW(
          children: [
            expandedW(
              child: containerW(
                margin: [0, 8, 0, 0],
                containerDecorationW: containerDecorationW(
                  radius: 8,
                  containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                ),
              ),
            ),
          ],
        ),
        */
        //content
        containerW(
          // height: 300,
          margin: [0, 5, 0, 0],
          padding: [5, 5, 5, 5],
          containerDecorationW: containerDecorationW(
            radius: 8,
            containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
          ),
          child: columnW(
            children: [
              // 1st  row
              rowW(
                children: [
                  expandedW(
                    flex: 1,
                    child: containerW(
                      height: 32,
                      margin: [1, 1, 1, 1],
                      padding: [5, 5, 5, 5],
                      containerDecorationW: containerDecorationW(
                        radius: 4,
                        containerDecorationBorderW: containerDecorationBorderW(width: 1),
                      ),
                      child: textW("إستلمنا من المكرم"),
                    ),
                  ),
                  expandedW(
                    flex: 3,
                    child: containerW(
                      height: 32,
                      margin: [1, 1, 1, 1],
                      padding: [5, 5, 5, 5],
                      containerDecorationW: containerDecorationW(
                        radius: 4,
                        containerDecorationBorderW: containerDecorationBorderW(width: 1),
                      ),
                      child: textW(controller.selecetdCustomer!.cusName),
                    ),
                  ),
                  expandedW(
                    flex: 1,
                    child: containerW(
                      height: 32,
                      margin: [1, 1, 1, 1],
                      padding: [5, 5, 5, 5],
                      containerDecorationW: containerDecorationW(
                        radius: 4,
                        containerDecorationBorderW: containerDecorationBorderW(width: 1),
                      ),
                      child: textW("Recevied from Mr"),
                    ),
                  ),
                ],
              ),

              //2nd row
              rowW(
                children: [
                  expandedW(
                    flex: 1,
                    child: containerW(
                      height: 32,
                      margin: [1, 1, 1, 1],
                      padding: [5, 5, 5, 5],
                      containerDecorationW: containerDecorationW(
                        radius: 4,
                        containerDecorationBorderW: containerDecorationBorderW(width: 1),
                      ),
                      child: textW("مبلغ وقدره"),
                    ),
                  ),
                  expandedW(
                    flex: 3,
                    child: containerW(
                      height: 32,
                      margin: [1, 1, 1, 1],
                      padding: [5, 5, 5, 5],
                      containerDecorationW: containerDecorationW(
                        radius: 4,
                        containerDecorationBorderW: containerDecorationBorderW(width: 1),
                      ),
                      child: textW(convertToArabicWords(double.parse(controller.amount.text))),
                    ),
                  ),
                  expandedW(
                    flex: 1,
                    child: containerW(
                      height: 32,
                      margin: [1, 1, 1, 1],
                      padding: [5, 5, 5, 5],
                      containerDecorationW: containerDecorationW(
                        radius: 4,
                        containerDecorationBorderW: containerDecorationBorderW(width: 1),
                      ),
                      child: textW("The Amount"),
                    ),
                  ),
                ],
              ),

              //3rd row
              rowW(
                children: [
                  expandedW(
                    flex: 1,
                    child: containerW(
                      height: 32,
                      margin: [1, 1, 1, 1],
                      padding: [5, 5, 5, 5],
                      containerDecorationW: containerDecorationW(
                        radius: 4,
                        containerDecorationBorderW: containerDecorationBorderW(width: 1),
                      ),
                      child: textW("وذلك مقابل"),
                    ),
                  ),
                  expandedW(
                    flex: 3,
                    child: containerW(
                      height: 32,
                      margin: [1, 1, 1, 1],
                      padding: [5, 5, 5, 5],
                      containerDecorationW: containerDecorationW(
                        radius: 4,
                        containerDecorationBorderW: containerDecorationBorderW(width: 1),
                      ),
                      child: textW(controller.description.text),
                    ),
                  ),
                  expandedW(
                    flex: 1,
                    child: containerW(
                      height: 32,
                      margin: [1, 1, 1, 1],
                      padding: [5, 5, 5, 5],
                      containerDecorationW: containerDecorationW(
                        radius: 4,
                        containerDecorationBorderW: containerDecorationBorderW(width: 1),
                      ),
                      child: textW("The Amount"),
                    ),
                  ),
                ],
              ),

              //3rd row
              rowW(
                children: [
                  expandedW(
                    child: containerW(
                        height: 32,
                        margin: [1, 1, 1, 1],
                        padding: [5, 5, 5, 5],
                        containerDecorationW: containerDecorationW(
                          color: "#F5F5F5",
                          radius: 4,
                          containerDecorationBorderW: containerDecorationBorderW(width: 1),
                        ),
                        child: rowW(mainAxisAlignment: "center", children: [
                          textW("مدخل السند"),
                          textW("  <=>  "),
                          textW(controller.userName),
                        ])),
                  ),
                ],
              ),
            ],
          ),
        ),
     
      ],
    ),
  );
}


*/
