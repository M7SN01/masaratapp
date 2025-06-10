import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../Controllers/user_controller.dart';
import '../Models/user_model.dart';
import '../Services/api_db_services.dart';
import '../Widget/widget.dart';
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

  String? selectedSanadType;
  String? selectedSanadTypeId;
  List<ActPrivModel> sanadatAct = [];
  CusDataModel? selecetdCustomer;
  List<CusDataModel> cusData = [];

  bool isPostingToApi = false;
  bool isPostedBefor = false;
  String? savedSanadId;

  TextEditingController date = TextEditingController();
  TextEditingController amount = TextEditingController();

  @override
  void onInit() {
    userController = Get.find<UserController>();
    userId = userController.uId;
    userName = userController.uName;
    sanadatAct = userController.actPrivList.where((e) => [int.parse("53${userController.uId}"), int.parse("57${userController.uId}")].contains(e.actId)).toList();
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
        renderer: (rendererContext) {
          final currentRow = rendererContext.row;
          final previousRow = rendererContext.stateManager.rows.isNotEmpty && rendererContext.rowIdx > 0 ? rendererContext.stateManager.rows[rendererContext.rowIdx - 1] : null;

          final currentAMNTDN = currentRow.cells['DN']?.value ?? 0;
          final currentAMNTMD = currentRow.cells['MD']?.value ?? 0;
          final previousAMNT = previousRow?.cells['BAL']?.value ?? 0;

          // Calculate AMNT
          final amntValue = previousAMNT + currentAMNTMD - currentAMNTDN;
          // print("$currentAMNTDN + $currentAMNTMD + $previousAMNT = $amntValue");
          currentRow.cells['BAL']!.value = amntValue;

          return Text(formatCurrency(amntValue.toString()));
        },
      ),
    ];

    super.onInit();
  }

  clearSanadData() {
    isPostingToApi = false;
    isPostedBefor = false;
    savedSanadId = null;
    selecetdCustomer = null;
    selectedSanadTypeId = null;
    selectedSanadType = null;
    amount.clear();

    date.clear();

    update();
  }

  Future<void> getKshfData() async {
    isPostingToApi = true;
    update();
    // await Future.delayed(Duration(seconds: 3));
    try {
      String date = "";
      if (mnthDateController.text.isNotEmpty) {
        date = " AND TO_CHAR(DATE1,'yyyy-mm')='${mnthDateController.text}' ";
      } else if (fromDateController.text.isNotEmpty && toDateController.text.isNotEmpty) {
        date = " AND DATE1 BETWEEN TO_DATE('${fromDateController.text}', 'YYYY/MM/DD') AND TO_DATE('${toDateController.text}', 'YYYY/MM/DD') ";
      }
      String cond = selecetdCustomer != null || date != "" ? " where 1=1  $date  ${selecetdCustomer != null ? " and cus_id=${selecetdCustomer!.cusId} " : ""}" : "";
      String stmt = """
                SELECT * FROM ( 
                  select TRHEL,(SELECT ACT_NAME FROM ACT_TYPE WHERE ACT_ID =CUS_HD_TYPE) ACT_NAME,CUS_HD_ID,DATE1,DSCR
                  ,round( TTL,2) TTL,STATE,REF,CUS_ID_CST_ID,round(MD,2) MD,round(DN,2)DN  
                  ,CUS_ID,GET_CUS_CLS_ID(CUS_ID) CUS_CLS_ID
                  from cus_hd_cus_dt  $cond  
                ) 
                WHERE  CUS_CLS_ID IN (SELECT CS_CLS_ID FROM USER_CUS_GRP WHERE U_ID='$userId' AND CHK = 1)
                  """;
      // debugPrint(stmt);

      var response = await dbServices.createRep(sqlStatment: stmt);

      isPostingToApi = true;
      update();

      // print("****************** $response   *************");
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
              'DN': PlutoCell(value: element['DN']),
              'MD': PlutoCell(value: element['MD']),
              'BAL': PlutoCell(value: ""), //calculated in column renderer
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
