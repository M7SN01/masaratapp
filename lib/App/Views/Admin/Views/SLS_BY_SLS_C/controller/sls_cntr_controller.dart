import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:masaratapp/App/Controllers/user_controller.dart';
import 'package:masaratapp/App/Views/Admin/Views/SLS_BY_SLS_C/controller/table_columns.dart';
import 'package:pluto_grid/pluto_grid.dart';
// import 'package:pluto_grid_plus/pluto_grid_plus.dart';

// import '../../../../Tools/M7SN_Tools.dart';
// import '../../../../login_screen.dart';
// import '../../../TaskBar.dart';
import '../../../../../../Services/api_db_services.dart';
import '../../../../../../Widget/widget.dart';
import '../../../../../../utils/utils.dart';
import '../../../Controllers/table_controller.dart';
import '../../../other/TableView/options/table_options.dart';
// import '../View/cost_view.dart';
// import '../View/full_view.dart';
// import '../View/gain_view.dart';
// import '../View/sls_view.dart';

class SlsCenterController extends GetxController with SetUpTablesColumns {
  UserController userController = Get.find<UserController>();
  bool initial = true;
  bool loadingData = false;
  String fullRepId = "slsRepSlsBySlsCntrFullView";
  String costRepId = "slsRepSlsBySlsCntrCostView";
  String slsRepId = "slsRepSlsBySlsCntrSlsView";
  String gainRepId = "slsRepSlsBySlsCntrGainView";

  List<PlutoRow> monthRows = [];
  List<PlutoRow> slsRows = [];
  List<PlutoRow> gainRows = [];
  List<PlutoRow> costRows = [];

  //
  List<PlutoColumn> monthColumns = [];

  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController mnthDateController = TextEditingController();

  String selectedslsCntr = "";
  List<SearchList> slsCntrOrignalData = [];

  String selectedslsCntrGroupId = "";
  List<SearchList> slsCntrGrpOrignalData = [];

  String selectedSchYearIds = "";
  List<SearchList> schYearOrignalData = [];

  bool showMonthRep = false;

  int currentTab = 0;
  bool optionShow = true;

//Map<String, List<String>> defaultTableSetting = {};
  bool dateSwitcher = true;

  @override
  void onInit() {
    super.onInit();
    // Get.put<TableController>(TableController());
    Get.lazyPut(() => TableController());
    initial = true;

    currentTab = 0;

    // loadingData = true;
    showMonthRep = false;
    dateSwitcher = true;
    monthRows = [];
    gainRows = [];
    slsRows = [];
    costRows = [];

    fromDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    // DateFormat('yyyy-MM-dd').parse(DateTime.now().toString()).toString();
    toDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    mnthDateController.text = "";

    selectedslsCntrGroupId = "";
    // slsCntrGroup = [];
    // slsCntrGroupId = [];
    // selectedslsCntrGroup = "";
    // selectedslsCntrGroupId = "";
    selectedslsCntr = "";
    slsCntrOrignalData = [];
    slsCntrGrpOrignalData = [];
    optionShow = true;

    selectedSchYearIds = "";
    schYearOrignalData = [];

    // defaultTableSetting = {};
    print(userController.slsCntrPrivList.length);
    slsCntrOrignalData = userController.slsCntrPrivList.map((e) => SearchList(id: e.slsCntrID, name: e.slsCntrName, state: false)).toList();
    // slsCntrGrpOrignalData = optionsData.getSlsCenterGRPsData;
    // schYearOrignalData = optionsData.getSchYearsData;

    // }
  }

  @override
  onClose() {
    // if (Get.isRegistered<TableController>()) {
    //   Get.delete<TableController>();
    // }
    // Get.delete<TableController>();
    // Get.delete<SlsCenterController>(force: true);
    // monthColumns = [];

    super.onClose();
  }

  String date = "";

  checkSearchOption() async {
    //  if (selectedValue == 1) {
    date = "";
    if (!dateSwitcher) {
      if (mnthDateController.text.isNotEmpty) {
        if (selectedSchYearIds != "") {
          final onlyMonth = DateFormat('MM').format(DateTime.parse("${mnthDateController.text}-01"));
          // print(onlyMonth);
          // mnthDateController.text = onlyMonth;
          date = " and to_char(DATE1,'mm')='$onlyMonth' ";
        } else {
          date = " and to_char(DATE1,'yyyy-mm')='${mnthDateController.text}' ";
        }
      }
      showMonthRep = true;
    } else if (fromDateController.text.isNotEmpty && toDateController.text.isNotEmpty) {
      date = " AND DATE1 BETWEEN TO_DATE('${fromDateController.text}', 'YYYY/MM/DD') AND TO_DATE('${toDateController.text}', 'YYYY/MM/DD') ";

      showMonthRep = false;
    } else {
      // all fileds is empty

      showMonthRep = false;
    }
    update();
  }

  errorCallBack(String errorMessage) {
    showMessage(msg: errorMessage, color: Colors.red);
  }

  String buildStatment({required String colName, String conditons = ""}) {
    return """
SELECT
    A.SLS_CNTR_ID,
    B.SLS_CNTR_NAME AS NAME,
    SUM(CASE WHEN TO_CHAR(A.DATE1,'MM') = '01' THEN round(A.$colName,4) ELSE 0 END) AS "01",
    SUM(CASE WHEN TO_CHAR(A.DATE1,'MM') = '02' THEN round(A.$colName,4) ELSE 0 END) AS "02",
    SUM(CASE WHEN TO_CHAR(A.DATE1,'MM') = '03' THEN round(A.$colName,4) ELSE 0 END) AS "03",
    SUM(CASE WHEN TO_CHAR(A.DATE1,'MM') = '04' THEN round(A.$colName,4) ELSE 0 END) AS "04",
    SUM(CASE WHEN TO_CHAR(A.DATE1,'MM') = '05' THEN round(A.$colName,4) ELSE 0 END) AS "05",
    SUM(CASE WHEN TO_CHAR(A.DATE1,'MM') = '06' THEN round(A.$colName,4) ELSE 0 END) AS "06",
    SUM(CASE WHEN TO_CHAR(A.DATE1,'MM') = '07' THEN round(A.$colName,4) ELSE 0 END) AS "07",
    SUM(CASE WHEN TO_CHAR(A.DATE1,'MM') = '08' THEN round(A.$colName,4) ELSE 0 END) AS "08",
    SUM(CASE WHEN TO_CHAR(A.DATE1,'MM') = '09' THEN round(A.$colName,4) ELSE 0 END) AS "09",
    SUM(CASE WHEN TO_CHAR(A.DATE1,'MM') = '10' THEN round(A.$colName,4) ELSE 0 END) AS "10",
    SUM(CASE WHEN TO_CHAR(A.DATE1,'MM') = '11' THEN round(A.$colName,4) ELSE 0 END) AS "11",
    SUM(CASE WHEN TO_CHAR(A.DATE1,'MM') = '12' THEN round(A.$colName,4) ELSE 0 END) AS "12"
FROM SLS_V A 
JOIN SLS_CENTER B
  ON A.SLS_CNTR_ID = B.SLS_CNTR_ID
WHERE 1=1 $conditons
GROUP BY
    A.SLS_CNTR_ID,
    B.SLS_CNTR_NAME
ORDER BY
    A.SLS_CNTR_ID
""";
  }

  getdata() async {
    monthRows = [];
    gainRows = [];
    slsRows = [];
    costRows = [];
    loadingData = true;
    optionShow = false;

    update();
    // if (Get.isRegistered<TableController>()) {
    //   Get.delete<TableController>();
    // }
    String stmt = "";
    // "SELECT SLS_CNTR_NAME, trunc(sum(GP),2) GP,trunc(sum(TTL_CST),2) TTL_CST,trunc(sum(INV_TTL),2) INV_TTL FROM $selectedSCH.SLS_HD_RVW_V  WHERE 1=1     AND COMP_ID ='$selectedCompId'  AND ACC_CLASS_ID ='C' AND SCRN_CODE='S0104' ";

    await checkSearchOption();

    String whereCond = "";
    whereCond += "$whereCond  ${selectedslsCntr == "" ? "" : " AND A.SLS_CNTR_ID in ( $selectedslsCntr ) "}";
    whereCond += date;
    // whereCond += selectedslsCntrGroupId == "" ? "" : " AND SLS_CNTR_GRP IN ($selectedslsCntrGroupId) ";
    // List<String> schemas = selectedSchYearIds == "" ? [selectedSCH] : selectedSchYearIds.split(',').map((e) => e.replaceAll("'", "").trim()).toList();

    if (!dateSwitcher) {
      //month view
      String monthstmt = """SELECT A.SLS_CNTR_ID,B.SLS_CNTR_NAME , round(SUM(A.PUR_TTL_CST),4) TTL_CST,round(SUM(A.INV_TTL),4) INV_TTL,round(SUM(A.GAIN),4) GP 
              FROM SLS_V A,SLS_CENTER B  
              WHERE   A.SLS_CNTR_ID = B.SLS_CNTR_ID   $whereCond 
              group by   A.SLS_CNTR_ID,B.SLS_CNTR_NAME
              """;

      // print(monthstmt);
      monthRows = await getMonthData(sqlStatment: monthstmt, errorCallback: (error) => errorCallBack("$error (month stmt) "));

      monthRows;
      loadingData = false;
      update();
    } else {
      stmt = buildStatment(colName: 'GAIN', conditons: whereCond);
      debugPrint(stmt);
      gainRows = await getGainData(sqlStatment: stmt, errorCallback: (error) => errorCallBack("$error (SLS Gain) "));
      stmt = buildStatment(colName: 'PUR_TTL_CST', conditons: whereCond);
      costRows = await getCostData(sqlStatment: stmt, errorCallback: (error) => errorCallBack("$error (Cost stmt) "));
      stmt = buildStatment(colName: 'INV_TTL', conditons: whereCond);

      slsRows = await getSlsData(sqlStatment: stmt, errorCallback: (error) => errorCallBack("$error (SLS stmt) "));

      slsRows;
      costRows;
      gainRows;
      loadingData = false;
      update();
    }
  }

  //

  get fullViewTableOptions => TableOptions(
        isLoadingData: loadingData,
        repID: fullRepId,
        tableRows: monthRows,
        tableColumns: getColumnsByMonthRep,

        pdfTitle: "اجماليات مراكز البيع",
        // fullScreenTitle: "اجماليات مراكز البيع",
        tatalTopTitle: ['INV_TTL', 'TTL_CST', 'GP'],
      );

// List<PlutoColumn> getRepColumns() {
//     final columns = buildBaseWithMonths();

//     applyVisibiliyt(columns, fromDateController.text, toDateController.text);
//     return columns;
//   }

  get gainViewTableOptions {
    return TableOptions(
      isLoadingData: loadingData,
      repID: gainRepId,
      tableRows: gainRows,
      tableColumns: getColumnsFromToDateRep,
      pdfTitle: "الربح حسب مراكز البيع",
      fullScreenTitle: "ربح مراكز البيع",
      // tatalTopTitle: ['INV_TTL', 'TTL_CST', 'GP'],
    );
  }

  get slsViewTableOptions {
    return TableOptions(
      isLoadingData: loadingData,
      repID: slsRepId,
      tableRows: slsRows,
      tableColumns: getColumnsFromToDateRep,
      pdfTitle: "مبيعات مراكز البيع",
      fullScreenTitle: "مبيعات مراكز البيع",
      // tatalTopTitle: ['INV_TTL', 'TTL_CST', 'GP'],
    );
  }

  get costViewTableOptions {
    return TableOptions(
      isLoadingData: loadingData,
      repID: costRepId,
      tableRows: costRows,
      tableColumns: getColumnsFromToDateRep,
      pdfTitle: "تكلفة مراكز البيع",
      fullScreenTitle: "تكلفة مراكز البيع",
      // tatalTopTitle: ['INV_TTL', 'TTL_CST', 'GP'],
    );
  }
  //
  //

//----------------------------------------From Server ------------------------------
  Future<List<PlutoRow>> getCostData({required String sqlStatment, Function(String error)? errorCallback}) async {
    final services = Services();
    List<dynamic> responeData = await services.createRep(sqlStatment: sqlStatment);

    List<PlutoRow> rows = responeData.map((item) {
      return PlutoRow(cells: {
        // 'SLS_MAN_ID': PlutoCell(value: item['SLS_MAN_ID']),
        // 'DOC_YYYYMM1': PlutoCell(value: item['DOC_YYYYMM1']),

        // 'YR': PlutoCell(value: item['YR']),
        // 'PRD_DATE': PlutoCell(value: item['PRD_DATE']),
        'SLS_CNTR_ID': PlutoCell(value: item['SLS_CNTR_ID']),
        'NAME': PlutoCell(value: item['NAME'].toString() != "null" ? item['NAME'] : ""),
        for (int i = 1; i <= 12; i++) '$i': PlutoCell(value: item[i.toString().padLeft(2, '0')]),
      });
    }).toList();
    // print("done");
    return rows;
  }

  Future<List<PlutoRow>> getGainData({required String sqlStatment, Function(String error)? errorCallback}) async {
    final services = Services();
    List<dynamic> responeData = await services.createRep(sqlStatment: sqlStatment);

    List<PlutoRow> rows = responeData.map((item) {
      return PlutoRow(cells: {
        // 'SLS_MAN_ID': PlutoCell(value: item['SLS_MAN_ID']),
        // 'DOC_YYYYMM1': PlutoCell(value: item['DOC_YYYYMM1']),
        // 'YR': PlutoCell(value: item['YR']),
        // 'PRD_DATE': PlutoCell(value: item['PRD_DATE']),
        'SLS_CNTR_ID': PlutoCell(value: item['SLS_CNTR_ID']),
        'NAME': PlutoCell(value: item['NAME'].toString() != "null" ? item['NAME'] : ""),
        for (int i = 1; i <= 12; i++) '$i': PlutoCell(value: item[i.toString().padLeft(2, '0')]),
      });
    }).toList();
    // print("done");
    return rows;
  }

  Future<List<PlutoRow>> getSlsData({required String sqlStatment, Function(String error)? errorCallback}) async {
    final services = Services();
    List<dynamic> responeData = await services.createRep(sqlStatment: sqlStatment);

    List<PlutoRow> rows = responeData.map((item) {
      return PlutoRow(cells: {
        // 'SLS_MAN_ID': PlutoCell(value: item['SLS_MAN_ID']),
        // 'DOC_YYYYMM1': PlutoCell(value: item['DOC_YYYYMM1']),
        // 'YR': PlutoCell(value: item['YR']),
        // 'PRD_DATE': PlutoCell(value: item['PRD_DATE']),
        'SLS_CNTR_ID': PlutoCell(value: item['SLS_CNTR_ID']),
        'NAME': PlutoCell(value: item['NAME'].toString() != "null" ? item['NAME'] : ""),
        for (int i = 1; i <= 12; i++) '$i': PlutoCell(value: item[i.toString().padLeft(2, '0')]),
      });
    }).toList();
    // print("done");
    return rows;
  }

  Future<List<PlutoRow>> getMonthData({required String sqlStatment, Function(String error)? errorCallback}) async {
    final services = Services();
    List<dynamic> responeData = await services.createRep(sqlStatment: sqlStatment);

    List<PlutoRow> rows = responeData.map((item) {
      return PlutoRow(cells: {
        // 'YR': PlutoCell(value: item['YR']),
        'SLS_CNTR_ID': PlutoCell(value: item['SLS_CNTR_ID']),
        'SLS_CNTR_NAME': PlutoCell(value: item['SLS_CNTR_NAME']),
        'INV_TTL': PlutoCell(value: item['INV_TTL']),
        'TTL_CST': PlutoCell(value: item['TTL_CST']),
        // 'SLS_CNTR_GRP': PlutoCell(value: item['SLS_CNTR_GRP']),
        // 'TTL_CST': PlutoCell(value: item['TTL_CST']),
        'GP': PlutoCell(value: item['GP']),
      });
    }).toList();
    // print("done");
    return rows;
  }
}
