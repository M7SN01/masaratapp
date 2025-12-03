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

class ActKshfController extends GetxController {
  final Services dbServices = Services();
  late UserController userController;
  PlutoGridStateManager? stateManager;

  late List<PlutoColumn> columns;
  List<PlutoRow> rows = [];
  List<ActPrivModel> acts = [];
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
    acts = userController.actPrivList.where((e) => [int.parse("53${userController.uId}"), int.parse("57${userController.uId}")].contains(e.actId)).toList();

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
        field: 'ACT_TYPE',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.text(),
        backgroundColor: primaryColor,
        // width: 90,
        // width: PlutoGridSettings.minColumnWidth,
        suppressedAutoSize: true,
        titleSpan: autoMultiLineColumn("نوع الحركة"),
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
        type: PlutoColumnType.number(),
        backgroundColor: primaryColor,
        // width: 90,
        width: PlutoGridSettings.minColumnWidth,
        suppressedAutoSize: true,
        titleSpan: autoMultiLineColumn("رقم الحركة"),
        enableContextMenu: false,
        enableEditingMode: false,
        enableColumnDrag: false,
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
        title: "المبلغ",
        field: 'TTL',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.currency(format: '#,###.###'),
        backgroundColor: primaryColor,
        width: 90,
        // width: PlutoGridSettings.minColumnWidth,
        suppressedAutoSize: true,
        titleSpan: autoMultiLineColumn("المبلغ"),
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
        title: "العميل",
        field: 'CUS_NAME',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.text(),
        backgroundColor: primaryColor,
        width: 120,
        // width: PlutoGridSettings.minColumnWidth,
        suppressedAutoSize: true,
        titleSpan: autoMultiLineColumn("العميل"),
        enableContextMenu: false,
        enableEditingMode: false,
        enableColumnDrag: false,
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
    fromToDate = "";
    previousDateBalance = "";
    update();
  }

  Map<String, dynamic> getVariablesData() {
    List<Map<String, dynamic>> tmp = [];

    double ttl = 0;

    for (var row in rows) {
      tmp.add({
        "srl": row.sortIdx + 1,
        "ACT_TYPE": row.cells['ACT_TYPE']!.value,
        "ACT_NO": row.cells['ACT_NO']!.value,
        "DATE": row.cells['DATE']!.value,
        "DESC": row.cells['DESC']!.value,
        "TTL": row.cells['TTL']!.value,
      });

      ttl += row.cells['TTL']!.value;
    }
    //last Row---
    tmp.add({
      "srl": "",
      "ACT_TYPE": "عدد الحركات",
      "ACT_NO": "${rows.length}",
      "DATE": "",
      "DESC": "الاجمالي",
      "TTL": (ttl).toStringAsFixed(2),
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
      "t_mragah": "مراجعة حركات العملاء", //t_kshf
      "fromToDate": fromToDate,

      "cus_no": selecetdCustomer == null ? "" : selecetdCustomer!.cusId.toString(),
      "cus_name": selecetdCustomer == null ? "" : selecetdCustomer!.cusName,

      "h_srl": "N.",
      "h_ACT_TYPE": "نوع الحركة",
      "h_ACT_NO": "رقم الحركة",
      "h_DATE": "التاريخ",
      "h_DESC": "الوصف",
      "h_TTL": "الرصيد",

      "repeat_element": tmp,
      // "ttl_ttl": (ttl).toStringAsFixed(2),
    };
  }

  void printKshf() {
    if (rows.isEmpty) {
      showMessage(color: secondaryColor, titleMsg: "لايوجد بيانات لطباعتها !", durationMilliseconds: 1000);
    } else {
      PrintSamples ps = PrintSamples(compData: userController.compData);
      Get.to(() => PdfPreviewScreen(
            jsonLayout: ps.getActKshfSample,
            variables: getVariablesData(),
          ));
    }
  }

  Future<void> getKshfData() async {
    isPostingToApi = true;
    update();

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
      String actIds = acts.map((act) => "'${act.actId}'").join(',');
      String cond = " where CUS_HD_TYPE IN ($actIds)  $date  ${selecetdCustomer != null ? " and cus_id=${selecetdCustomer!.cusId} " : ""}";

      String stmt = """
                SELECT * FROM ( 
                  select TRHEL,(SELECT ACT_NAME FROM ACT_TYPE WHERE ACT_ID =CUS_HD_TYPE) ACT_NAME,CUS_HD_ID,DATE1,DSCR
                  ,round( TTL,2) TTL,STATE,REF,CUS_ID_CST_ID,round(MD,2) MD,round(DN,2)DN  
                  ,CUS_ID,GET_CUS_CLS_ID(CUS_ID) CUS_CLS_ID,GET_CUS_NAME_DB(CUS_ID) CUS_NAME
                  from cus_hd_cus_dt  $cond  
                ) 
                WHERE  CUS_CLS_ID IN (SELECT CS_CLS_ID FROM USER_CUS_GRP WHERE U_ID='$userId' AND CHK = 1)
                ORDER BY DATE1
                  """;
      // debugPrint(stmt);

      response = await dbServices.createRep(sqlStatment: stmt);

      rows.clear();

      for (var element in response) {
        rows.add(
          PlutoRow(
            cells: {
              "TRHEL": PlutoCell(value: checkNullString(element['TRHEL'].toString())),
              'ACT_TYPE': PlutoCell(value: checkNullString(element['ACT_NAME'].toString())),
              'ACT_NO': PlutoCell(value: element['CUS_HD_ID']),
              'DATE': PlutoCell(value: checkNullString(element['DATE1'].toString())),
              'DESC': PlutoCell(value: checkNullString(element['DSCR'].toString())),
              'TTL': PlutoCell(value: element['TTL']),
              'CUS_NAME': PlutoCell(value: element['CUS_NAME']),
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
    // }
  }
}
