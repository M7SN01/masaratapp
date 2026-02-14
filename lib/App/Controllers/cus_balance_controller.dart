import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../Controllers/user_controller.dart';
import '../Models/user_model.dart';
import '../../Services/api_db_services.dart';
import '../../Widget/widget.dart';
import '../../utils/utils.dart';

class AmountCompare {
  int id;
  String name;
  AmountCompare({required this.id, required this.name});
}

class CusBalanceController extends GetxController {
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

  String? selectedCsClsName;
  String? selectedCsClsId;

  //
  TextEditingController amount = TextEditingController();

  String selectedCompareName = 'أكبر من';
  int selectedCompareId = 1;

  List<AmountCompare> amountCompareList = [
    // AmountCompare(id: 0, name: 'بدون'),
    AmountCompare(id: 1, name: 'أكبر من'),
    AmountCompare(id: 2, name: 'أصغر من'),
    AmountCompare(id: 3, name: 'يساوي'),
  ];

  List<CsClsPrivModel> csClsList = [];

  @override
  void onInit() {
    userController = Get.find<UserController>();
    userId = userController.uId;
    userName = userController.uName;
    cusData = userController.cusDataList;
    compData = userController.compData;
    csClsList.clear();
    csClsList.add(CsClsPrivModel(cSClsId: 0, cSClsName: "جميع التصنيفات", accId: "", brId: "", curId: ""));
    csClsList.addAll(userController.csClsPrivList);

    columns = [
      PlutoColumn(
        title: "رقم العميل",
        field: 'CUS_ID',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.number(),
        backgroundColor: primaryColor,
        width: PlutoGridSettings.minColumnWidth,
        titleSpan: autoMultiLineColumn("رقم العميل"),
        enableContextMenu: false,
        enableEditingMode: false,
        enableColumnDrag: false,
        renderer: (rendererContext) => openCusKashf(
          cusId: rendererContext.row.cells['CUS_ID']!.value,
        ),
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
                text: "   عميل",
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
        title: "اسم العميل",
        field: 'CUS_NAME',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.text(),
        backgroundColor: primaryColor,
        // width: 90,
        // width: PlutoGridSettings.minColumnWidth,
        suppressedAutoSize: true,
        titleSpan: autoMultiLineColumn("اسم العميل"),
        enableContextMenu: false,
        enableEditingMode: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          return Text(
            rendererContext.cell.value.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                // color: textColor,
                // fontWeight: FontWeight.bold,
                ),
          );
        },
      ),
      PlutoColumn(
        title: "الرصيد",
        field: 'BAL',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.number(format: '###,###.##'),
        backgroundColor: primaryColor,
        width: 120,
        titleSpan: autoMultiLineColumn("الرصيد"),
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
        // footerRenderer: (context) {
        //   return isPostingToApi
        //       ? const Center(child: CircularProgressIndicator(color: Colors.white))
        //       : TextButton(
        //           onPressed: () {
        //             printKshf();
        //           },
        //           style: TextButton.styleFrom(
        //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        //             backgroundColor: primaryColor,
        //           ),
        //           child: Icon(
        //             Icons.print,
        //             color: Colors.white,
        //           ),
        //         );
        // },
      ),
      PlutoColumn(
        title: "التلفون",
        field: 'TEL',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.text(),
        backgroundColor: primaryColor,
        suppressedAutoSize: true,
        width: 110,
        titleSpan: autoMultiLineColumn("التلفون"),
        enableContextMenu: false,
        enableEditingMode: false,
        enableColumnDrag: false,
      ),
      PlutoColumn(
        title: "الجوال",
        field: 'MOBL',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.text(),
        backgroundColor: primaryColor,
        width: 110,
        // width: PlutoGridSettings.minColumnWidth,
        // suppressedAutoSize: true,
        titleSpan: autoMultiLineColumn("الجوال"),
        enableContextMenu: false,
        enableEditingMode: false,
        enableColumnDrag: false,
      ),
      PlutoColumn(
        title: "التصنيف",
        field: 'CLASS_NAME',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.text(),
        backgroundColor: primaryColor,
        // width: 90,
        width: PlutoGridSettings.bodyMinWidth,
        suppressedAutoSize: true,
        titleSpan: autoMultiLineColumn("التصنيف"),
        enableContextMenu: false,
        enableColumnDrag: false,
        enableEditingMode: false,
      ),
    ];

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

    update();
  }

  Future<void> getBalanceData() async {
    isPostingToApi = true;
    update();

    try {
      String frmDate = "";
      String toDate = "";

      String toDdMmYyyy(String yyyyMmDd) {
        final dt = DateTime.parse(yyyyMmDd);
        return DateFormat('dd-MM-yyyy').format(dt);
      }

      if (mnthDateController.text.isNotEmpty) {
        final parts = mnthDateController.text.split('-');
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);

        final first = DateTime(year, month, 1);
        final last = DateTime(year, month + 1, 0);
        // String formatDate(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
        frmDate = DateFormat('dd-MM-yyyy').format(first);
        toDate = DateFormat('dd-MM-yyyy').format(last);
      } else if (fromDateController.text.isNotEmpty && toDateController.text.isNotEmpty) {
        frmDate = toDdMmYyyy(fromDateController.text);
        toDate = toDdMmYyyy(toDateController.text);
      } else if (fromDateController.text.isNotEmpty && toDateController.text.isEmpty) {
        frmDate = toDdMmYyyy(fromDateController.text);
        toDate = toDdMmYyyy("${DateTime.now().year}-12-31");
      } else if (fromDateController.text.isEmpty && toDateController.text.isNotEmpty) {
        frmDate = toDdMmYyyy("${DateTime.now().year}-01-01");
        toDate = toDdMmYyyy(toDateController.text);
      }
      if (frmDate == "" && toDate == "") {
        frmDate = toDdMmYyyy("${DateTime.now().year}-01-01");
        toDate = toDdMmYyyy("${DateTime.now().year}-12-31");
      }
      frmDate = "TO_DATE('$frmDate', 'DD-MM-YYYY')";

      toDate = "TO_DATE('$toDate', 'DD-MM-YYYY')";

      List<dynamic> response;

      String chkCompareCond(int cId) {
        //  WHEN 'GT' THEN CASE WHEN NVL(r.BAL,0) >  p_amount THEN 1 ELSE 0 END
        //     WHEN 'GE' THEN CASE WHEN NVL(r.BAL,0) >= p_amount THEN 1 ELSE 0 END
        //     WHEN 'LT' THEN CASE WHEN NVL(r.BAL,0) <  p_amount THEN 1 ELSE 0 END
        //     WHEN 'LE' THEN CASE WHEN NVL(r.BAL,0) <= p_amount THEN 1 ELSE 0 END
        //     WHEN 'EQ' THEN CASE WHEN NVL(r.BAL,0) =  p_amount THEN 1 ELSE 0 END
        //     WHEN 'NE' THEN CASE WHEN NVL(r.BAL,0) <> p_amount THEN 1 ELSE 0 END
        if (cId == 1) {
          return "'GT'";
        } else if (cId == 2) {
          return "'LT'";
        } else if (cId == 3) {
          return "'EQ'";
        } else {
          return "";
        }
      }

      // String stmt = """
      //             SELECT * FROM (
      //               SELECT CUS_ID,CUS_NAME,ADRS ,SLS_MAN_ID ,
      //               ( SELECT ROUND(SUM(NVL(MD,0)-NVL(DN,0)),2)
      //                 FROM CUS_HD_CUS_DT_TRANS  WHERE CUS_ID=b.CUS_ID
      //                 AND DATE1 BETWEEN $frmDate AND $toDate
      //               ) BAL ,
      //               TEL,GET_CUS_CLS(CS_CLS_ID) CLASS_NAME ,MOBL from CUSTOMERS B WHERE 1=1
      //               ${selecetdCustomer == null ? "" : " AND CUS_ID = ${selecetdCustomer!.cusId} "}
      //               ${selectedCsClsId == null ? "" : " AND CS_CLS_ID=$selectedCsClsId "}
      //               AND CHK_CUS_USR_PRV(b.CUS_ID,$userId)=1
      //             ) WHERE 1=1 ${amount.text.isEmpty ? "" : chkCompareCond(selectedCompareId)}
      //               """;

      String stmt = """
                    SELECT *
                    FROM TABLE(APP_ACCOUNT.FN_GET_CUSTOMERS_BAL(
                    $frmDate,
                    $toDate,          
                      $userId,
                      ${selecetdCustomer?.cusId ?? 'NULL'},
                      ${selectedCsClsId ?? 'NULL'},
                      ${amount.text.isEmpty ? 'NULL' : amount.text},
                      ${amount.text.isEmpty ? 'NULL' : chkCompareCond(selectedCompareId)}
                    ))
                    """;

      response = await dbServices.createRep(sqlStatment: stmt);
      debugPrint(stmt);
      isPostingToApi = true;
      update();

      // debugPrint("****************** $response   *************");
      rows.clear();

      for (var element in response) {
        rows.add(
          PlutoRow(
            cells: {
              "CUS_ID": PlutoCell(value: checkNullString(element['CUS_ID'].toString())),
              "CUS_NAME": PlutoCell(value: checkNullString(element['CUS_NAME'].toString())),
              'BAL': PlutoCell(value: checkNullString(element['BAL'].toString())),
              'TEL': PlutoCell(value: checkNullString(element['TEL'].toString())),
              'MOBL': PlutoCell(value: element['MOBL'].toString()),
              'CLASS_NAME': PlutoCell(value: checkNullString(element['CLASS_NAME'].toString())),
            },
          ),
        );
      }
    } catch (e) {
      userController.appLog += "${e.toString()} \n------------------------------------------\n";
      showMessage(color: secondaryColor, titleMsg: "posting error !", titleFontSize: 18, msg: e.toString(), durationMilliseconds: 1000);
    }
    rows;
    isPostingToApi = false;
    update();
  }

  Widget openCusKashf({required int cusId}) {
    // Keep current selection; don't clear or reload balance.

    return GestureDetector(
      onTap: () async {
        await Get.toNamed(
          '/CustomerKshf',
          arguments: {'cusId': cusId},
        );
      },
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Text(
            cusId.toString(),
            style: const TextStyle(color: Colors.blue),
          ),
        ),
      ),
    );
  }

/*
  Map<String, dynamic> getVariablesData() {
    List<Map<String, dynamic>> tmp = [];

    double ttlDN = 0;
    double ttlMD = 0;
    double ttlBAL = selecetdCustomer!.previousBalance ?? 0.0;

    for (var row in rows) {
      tmp.add({
        "srl": row.sortIdx + 1,
        "CUS_ID": row.cells['CUS_ID']!.value,
        "CUS_NAME": row.cells['CUS_NAME']!.value,
        "BAL": row.cells['BAL']!.value,
        "TEL": row.cells['TEL']!.value,
        "MOBL": row.cells['MOBL']!.value,
        "CLASS_NAME": row.cells['CLASS_NAME']!.value,
        // "BAL": row.cells['BAL']!.value,
      });
    }
    //last Row---
    tmp.add({
      "srl": "",
      "CUS_NAME": "عدد الحركات",
      "CUS_ID": "${rows.length}",
      "BAL": "",
      "TEL": "الرصيد الحالي",
      "MOBL": "",
      "CLASS_NAME": "",
      // "BAL": (ttlBAL).toStringAsFixed(2),
    });

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
      // "fromToDate": fromToDate,
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
      "t_sanad_type": "${response[0]['ACT_NAME']}  ( ${response[0]['ACC_HD_ID']} )",
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
*/
/*
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
    String stmt = """
                  SELECT a.CUS_ID,get_cus_name_DB(a.CUS_ID) CUS_NAME,a.ACC_TYPE,get_act_name(a.ACC_TYPE) ACT_NAME,a.ACC_HD_ID,round(a.AMNT,2) AMNT , a.DSCR ,
                            TO_CHAR(b.DATE1,'yyyy-mm-dd')  DATE1,GET_USER_NAME_DB(b.USR_INS) USER_INS_NAME
                            FROM $accountYear.ACC_DT a, $accountYear.ACC_HD b  
                            WHERE b.ACC_TYPE=a.ACC_TYPE AND b.ACC_HD_ID=a.ACC_HD_ID  AND a.ACC_TYPE=$actType AND a.ACC_HD_ID=$field  
                            AND a.CUS_ID=${selecetdCustomer!.cusId}    
                  """;
    var response = await dbServices.createRep(sqlStatment: stmt);

    debugPrint(response.length.toString());
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
    int roundDigit = 2;
    String stmt = """ SELECT ST_TYPE,get_act_name(ST_TYPE) ACT_NAME,ST_ID,TO_CHAR(DATE1, 'YYYY-MM-DD') DATE1,USR_INS_DATE,DESCR,CUS_ID,CUS_NM1,CUS_MOBILE,TAX_NO,NVL(ROUND(DISCNT,$roundDigit),0)DISCNT,
                          ROUND(PUR_TTL,$roundDigit)PUR_TTL,ROUND(ADDED_VALUE,$roundDigit)ADDED_VALUE ,ROUND(VAT_PR,$roundDigit)VAT_PR 
                          FROM $accountYear.ST_HD 
                          WHERE ST_TYPE=$actType  AND ST_ID=$field  """;
    // debugPrint(stmt);

    var responseHd = await dbServices.createRep(sqlStatment: stmt);
    debugPrint(responseHd.length.toString());
//--------------
    stmt = """ SELECT SRL,ITEM_ID,GET_ITEM_NAME_DB(ITEM_ID) ITEM_NAME,UNIT,QTY,ROUND(PRICE,$roundDigit)PRICE,ROUND(VAT_VAL,$roundDigit)VAT_VAL ,ROUND(PRICE_AFTR_VAT,$roundDigit)PRICE_AFTR_VAT
                          FROM $accountYear.ST_DT
                          WHERE ST_TYPE=$actType  AND ST_ID=$field  """;
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
*/
}
