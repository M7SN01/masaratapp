import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:intl/intl.dart';
import '../../../App/Controllers/visit_map_controller.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../Services/api_db_services.dart';
// import '../Widget/widget.dart';
import '../utils/utils.dart';
import 'login_controller.dart';
import 'user_controller.dart';

class VisitPlanController extends GetxController {
  final Services dbServices = Services();

  late UserController userController;
  late LoginController loginController;
  late VisitMapController visitMapController;
  String? userId;
  String? userName;
  bool isGettingFromApi = true;

  PlutoGridStateManager? stateManager;

  late List<PlutoColumn> columns;
  List<PlutoRow> rows = [];

  List<CusVisitModel> customersInVisitPlan = [];

  @override
  void onInit() async {
    debugPrint("Start -----------------------");
    userController = Get.find<UserController>();
    loginController = Get.find<LoginController>();
    visitMapController = Get.find<VisitMapController>();
    userId = loginController.logedInuserId;
    userName = loginController.logedInuserName;
    await getCusVisitPlan();
    await fillTableRows();

    columns = [
      /*
      PlutoColumn(
        title: "زيارة",
        field: 'ACTION',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.text(),
        backgroundColor: primaryColor,
        // suppressedAutoSize: true,
        // titlePadding: EdgeInsets.all(0),
        width: 80,
        // titleSpan: WidgetSpan(
        //   child: SizedBox(
        //     width: 80,
        //     child: TextButton(
        //       onPressed: () {
        //         // printInvoiceDirectly();
        //       },
        //       style: TextButton.styleFrom(maximumSize: Size(Get.width, Get.height), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), backgroundColor: primaryColor),
        //       child: Text("data"),
        //       // child: GetBuilder<InvoiceController>(builder: (controller) => Icon(isPostedBefor ? Icons.print_rounded : Icons.print_disabled_rounded, color: isPostedBefor ? Colors.white : disabledColor)),
        //     ),
        //   ),
        // ),
        enableContextMenu: false,
        enableEditingMode: false,
        enableColumnDrag: false,
        // enableAutoEditing: false,
        enableDropToResize: false,
        enableFilterMenuItem: true,
        enableHideColumnMenuItem: false,

        // enableRowChecked: false,
        enableSorting: false,
        // enableRowDrag: false,
        enableSetColumnsMenuItem: false,

        frozen: PlutoColumnFrozen.start,
        renderer: (rendererContext) {
          // rendererContext.cell.column.cellPadding = EdgeInsets.all(1);
          // rendererContext.cell.row.cells['ACTION']!.column.backgroundColor = secondaryColor;
          bool isNotVisited = rendererContext.cell.row.cells['VISIT_DATE']!.value.toString() == "";
          String cusName = rendererContext.cell.row.cells['CUS_NAME']!.value.toString();
          int cusIdRowCell = int.parse(rendererContext.cell.row.cells['CUS_ID']!.value.toString());
          return TextButton(
            onPressed: () {
              if (isNotVisited) {
                visitMapController.selecetdCustomer = visitMapController.cusData.firstWhere((cus) => cus.cusId == cusIdRowCell);
                Get.back();
              } else {
                showMessage(color: saveColor, titleMsg: "تمت زيارة  \n $cusName", durationMilliseconds: 2000);
              }
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              backgroundColor: isNotVisited ? null : saveColor,
            ),
            child: Icon(isNotVisited ? Icons.pin_drop_sharp : Icons.check, color: isNotVisited ? secondaryColor : Colors.white),
          );
        },
        // footerRenderer: (context) {
        // return isPostingToApi
        //     ? const Center(child: CircularProgressIndicator(color: Colors.white))
        //     : TextButton(
        //         onPressed: () {
        //           saveInvoice();
        //         },
        //         style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), backgroundColor: rows.isNotEmpty && !isPostedBefor ? saveColor : disabledColor),
        //         child: const Text("حـفـظ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        //       );
        // },
      ),
     
     */
      PlutoColumn(
        title: "رقم العميل",
        field: 'CUS_ID',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.text(),
        backgroundColor: primaryColor,
        width: 90,
        suppressedAutoSize: true,
        titleSpan: autoMultiLineColumn("رقم العميل"),
        enableContextMenu: false,
        enableEditingMode: false,
        enableColumnDrag: false,
        // hide: true,
      ),
      PlutoColumn(
        title: "اسم العميل",
        field: 'CUS_NAME',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.text(),
        backgroundColor: primaryColor,
        suppressedAutoSize: true,
        // width: 100,
        titleSpan: autoMultiLineColumn("اسم العميل"),
        enableContextMenu: false,
        enableEditingMode: false,
        enableColumnDrag: false,
        // footerRenderer: (context) {
        //   // context.stateManager.r cell.column.cellPadding = EdgeInsets.zero;
        //   // rendererContext.cell.row.cells['ACTION']!.column.backgroundColor = secondaryColor;
        //   return TextButton(
        //     onPressed: () {
        //       // showInvoiceInPdfPreviewer();
        //     },
        //     // style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), backgroundColor: isPostedBefor ? saveColor : disabledColor),
        //     child: const Text("طباعة/عرض", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        //   );
        // },
      ),
      PlutoColumn(
        title: "المندوب",
        field: 'SLS_MAN_NAME',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.text(),
        backgroundColor: primaryColor,
        // hide: false,
        suppressedAutoSize: true,
        titleSpan: autoMultiLineColumn("المندوب"),
        enableContextMenu: true,
        enableEditingMode: false,
        enableColumnDrag: false,
        // footerRenderer: (rendererContext) {
        //   return PlutoAggregateColumnFooter(
        //     rendererContext: rendererContext,
        //     type: PlutoAggregateColumnType.count,
        //     alignment: Alignment.center,
        //     titleSpanBuilder: (p0) => [
        //       // const TextSpan(
        //       //   text: ' : ',
        //       //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        //       // ),
        //       TextSpan(text: p0, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        //       const TextSpan(text: '   ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        //       const TextSpan(text: "اصناف", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        //     ],
        //   );
        // },
      ),
      PlutoColumn(
        title: "زيارة",
        field: 'VISIT_DATE',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.date(format: "yyyy-MM-dd hh:mm:ss a"),

        backgroundColor: primaryColor,
        // width: 90,
        suppressedAutoSize: true,
        titleSpan: autoMultiLineColumn("زيارة"),
        enableContextMenu: false,
        enableColumnDrag: false,
        enableEditingMode: false,

        renderer: (rendererContext) {
          // rendererContext.cell.column.cellPadding = EdgeInsets.all(1);
          // rendererContext.cell.row.cells['ACTION']!.column.backgroundColor = secondaryColor;
          String visitDate = rendererContext.cell.row.cells['VISIT_DATE']!.value.toString();
          // String cusName = rendererContext.cell.row.cells['CUS_NAME']!.value.toString();
          int cusIdRowCell = int.parse(rendererContext.cell.row.cells['CUS_ID']!.value.toString());
          if (visitDate == "") {
            return TextButton(
              onPressed: () {
                // if (isNotVisited) {
                // int cusId= visitMapController.cusData.firstWhere((cus) => cus.cusId == cusIdRowCell);
                visitMapController.onSelectCustomer(cusIdRowCell);

                //  Get.back(); implemented inside the function onSelectCustomer()
                // } else {
                //   showMessage(color: saveColor, titleMsg: "تمت زيارة  \n $cusName", durationMilliseconds: 2000);
                // }
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                // backgroundColor: isNotVisited ? null : saveColor,
              ),
              child: Icon(Icons.pin_drop_sharp, color: secondaryColor),
              //  child: Icon(isNotVisited ? Icons.pin_drop_sharp : Icons.check, color: isNotVisited ? secondaryColor : Colors.white),
            );
          } else {
            // print(visitDate);
            // String formattedDate = DateFormat('yyyy-MM-dd hh:mm:ss a').format(DateTime.parse(visitDate));
            return Text(
              visitDate.replaceAll('AM', 'ص').replaceAll('PM', 'م'),
              textAlign: TextAlign.center,
              // style: const TextStyle(color: Colors.white),
              // maxLines: 2,
              overflow: TextOverflow.ellipsis,
            );
          }
        },
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
    ];

    isGettingFromApi = false;
    update();
    super.onInit();
  }

  Future<void> getCusVisitPlan() async {
    //dont add this condition => SLS_MAN_ID=$uId
    //we get all customers in spcific day after that only show customers
    //who the Login user has prmission on them
    //becouse no CS_CLS_ID  in CUS_SLS_MAN
    String statment = """
      SELECT a.CUS_ID,(SELECT CUS_NAME FROM CUSTOMERS WHERE CUS_ID=a.CUS_ID )CUS_NAME,
      a.SLS_MAN_ID,(SELECT SLS_MAN_NAME FROM SLS_MAN WHERE SLS_MAN_ID = a.SLS_MAN_ID) SLS_MAN_NAME , 
      (SELECT VISIT_DATE FROM CUSTOMERS_VISIT WHERE  CUS_ID=a.CUS_ID AND TRUNC(VISIT_DATE) = TRUNC(SYSDATE)  ) VISIT_DATE 
      FROM CUS_SLS_MAN a WHERE   DAY1=TO_CHAR(SYSDATE, 'D')
      """;

    //(SELECT VISIT_DATE FROM CUSTOMERS_VISIT WHERE  CUS_ID=a.CUS_ID
    //AND SLS_MAN_ID=a.SLS_MAN_ID  --make it only when specific salse man visit his customer  by customer group
    //AND TRUNC(VISIT_DATE) = TRUNC(SYSDATE)  ) VISIT_DATE

    try {
      var response = await dbServices.createRep(
        sqlStatment: statment,
      );
      customersInVisitPlan.clear();
      for (var element in response) {
        customersInVisitPlan.add(CusVisitModel(
          cusId: element['CUS_ID'],
          cusName: element['CUS_NAME'],
          slsManId: element['SLS_MAN_ID'],
          slsManName: element['SLS_MAN_NAME'],
          visitDate: element['VISIT_DATE'] ?? "",
        ));
      }
    } catch (e) {
      userController.errorLog += "$statment \n ERROR: => getCusVisitPlan {{=($e)=}}  \n";
    }
  }

  fillTableRows() {
    final tmpList = customersInVisitPlan.where((cus) => userController.cusDataList.any((visit) => visit.cusId == cus.cusId));
    rows.clear();
    for (var customer in tmpList) {
      rows.add(
        PlutoRow(
          cells: {
            'ACTION': PlutoCell(value: ""),
            'CUS_ID': PlutoCell(value: customer.cusId.toString()),
            'CUS_NAME': PlutoCell(value: customer.cusName.toString()),
            'SLS_MAN_ID': PlutoCell(value: customer.slsManId.toString()),
            'SLS_MAN_NAME': PlutoCell(value: customer.slsManName.toString()),
            'VISIT_DATE': PlutoCell(value: customer.visitDate ?? "".toString()), //?? 0
          },
        ),
      );
    }
  }
}

class CusVisitModel {
  int cusId;
  String cusName;
  int slsManId;
  String slsManName;
  String? visitDate;
  CusVisitModel({required this.cusId, required this.cusName, required this.slsManId, required this.slsManName, this.visitDate});
}
