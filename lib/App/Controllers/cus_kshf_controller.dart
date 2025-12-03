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
          response = await dbServices.createRep(sqlStatment: """ SELECT CUS_PRV_BAL(${selecetdCustomer!.cusId},null,
          ${fromDateController.text.isNotEmpty ? " TO_DATE('${fromDateController.text}', 'YYYY/MM/DD')" : " TO_DATE('${mnthDateController.text}-01', 'YYYY/MM/DD')"}
          ,2) CUS_PRV_BAL FROM DUAL""");
          //2 => جميع الحركات مرحل وغير مرحل
          if (response.isNotEmpty) {
            selecetdCustomer!.previousBalance = response[0]["CUS_PRV_BAL"];
          }
        }
        double previousBalance = selecetdCustomer!.previousBalance ?? 0;

        String cond = selecetdCustomer != null || date != "" ? " where 1=1  $date  ${selecetdCustomer != null ? " and cus_id=${selecetdCustomer!.cusId} " : ""}" : "";
        String stmt = """
                SELECT * FROM ( 
                  select TRHEL,(SELECT ACT_NAME FROM ACT_TYPE WHERE ACT_ID =CUS_HD_TYPE) ACT_NAME,CUS_HD_ID,DATE1,DSCR
                  ,round( TTL,2) TTL,STATE,REF,CUS_ID_CST_ID,round(MD,2) MD,round(DN,2)DN  
                  ,CUS_ID,GET_CUS_CLS_ID(CUS_ID) CUS_CLS_ID
                  from cus_hd_cus_dt  $cond  
                ) 
                WHERE  CUS_CLS_ID IN (SELECT CS_CLS_ID FROM USER_CUS_GRP WHERE U_ID='$userId' AND CHK = 1)
                ORDER BY DATE1
                  """;
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
                "TRHEL": PlutoCell(value: checkNullString(element['TRHEL'].toString())),
                'ACT_TYPE': PlutoCell(value: checkNullString(element['ACT_NAME'].toString())),
                'ACT_NO': PlutoCell(value: element['CUS_HD_ID']),
                'DATE': PlutoCell(value: checkNullString(element['DATE1'].toString())),
                'DESC': PlutoCell(value: checkNullString(element['DSCR'].toString())),
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
