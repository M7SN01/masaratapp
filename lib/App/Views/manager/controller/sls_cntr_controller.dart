import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/user_controller.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../../services/api_db_services.dart';
import '../../../../widget/widget.dart';
import '../../../../table_view/controllers/table_controller.dart';
import '../../../../table_view/options/table_options.dart';

class SlsCenterController extends GetxController {
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

  String frmDate = "";
  String toDate = "";
  String repDate = "";
  String toDdMmYyyy(String yyyyMmDd) {
    final dt = DateTime.parse(yyyyMmDd);
    return DateFormat('dd-MM-yyyy').format(dt);
  }

  checkSearchOption() {
    frmDate = "";
    toDate = "";
    if (!dateSwitcher) {
      if (mnthDateController.text.isNotEmpty) {
        final parts = mnthDateController.text.split('-');
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);

        final first = DateTime(year, month, 1);
        final last = DateTime(year, month + 1, 0);
        // String formatDate(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
        frmDate = DateFormat('dd-MM-yyyy').format(first);
        toDate = DateFormat('dd-MM-yyyy').format(last);
        repDate = mnthDateController.text;
      }
      showMonthRep = true;
    } else {
      if (fromDateController.text.isNotEmpty && toDateController.text.isNotEmpty) {
        frmDate = toDdMmYyyy(fromDateController.text);
        toDate = toDdMmYyyy(toDateController.text);
        repDate = "من تاريخ ${fromDateController.text} إلى تاريخ ${toDateController.text}";
      } else if (fromDateController.text.isNotEmpty && toDateController.text.isEmpty) {
        frmDate = toDdMmYyyy(fromDateController.text);
        toDate = toDdMmYyyy("${DateTime.now().year}-12-31");
        repDate = "من تاريخ ${fromDateController.text} ";
      } else if (fromDateController.text.isEmpty && toDateController.text.isNotEmpty) {
        frmDate = toDdMmYyyy("${DateTime.now().year}-01-01");
        toDate = toDdMmYyyy(toDateController.text);
        repDate = " إلى تاريخ ${toDateController.text}";
      }
      showMonthRep = false;
    }

    if (frmDate == "" && toDate == "") {
      frmDate = toDdMmYyyy("${DateTime.now().year}-01-01");
      toDate = toDdMmYyyy("${DateTime.now().year}-12-31");
    }

    frmDate = "TO_DATE('$frmDate', 'DD-MM-YYYY')";
    toDate = "TO_DATE('$toDate', 'DD-MM-YYYY')";

    update();
  }

  errorCallBack(String errorMessage) {
    showMessage(msg: errorMessage, color: Colors.red);
  }

/*
  String buildStatment({required String colName}) {
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
WHERE 1=1 
 ${selectedslsCntr == "" ? "" : " AND A.SLS_CNTR_ID in ( $selectedslsCntr ) "}  
  AND A.DATE1 BETWEEN $frmDate AND $toDate
GROUP BY
    A.SLS_CNTR_ID,
    B.SLS_CNTR_NAME
ORDER BY
    A.SLS_CNTR_ID
""";
  }
*/
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

    checkSearchOption();

    if (!dateSwitcher) {
      //month view
      // String monthstmt = """SELECT A.SLS_CNTR_ID,B.SLS_CNTR_NAME , round(SUM(A.PUR_TTL_CST),4) TTL_CST,round(SUM(A.INV_TTL),4) INV_TTL,round(SUM(A.GAIN),4) GP
      //         FROM SLS_V A,SLS_CENTER B
      //         WHERE   A.SLS_CNTR_ID = B.SLS_CNTR_ID
      //         ${selectedslsCntr == "" ? "" : " AND A.SLS_CNTR_ID in ( $selectedslsCntr ) "}
      //         AND A.DATE1 BETWEEN $frmDate AND $toDate
      //         group by   A.SLS_CNTR_ID,B.SLS_CNTR_NAME
      //         """;

      /*

SELECT A.SLS_CNTR_ID,B.SLS_CNTR_NAME , round(SUM(A.PUR_TTL_CST),4) TTL_CST,round(SUM(A.INV_TTL),4) INV_TTL,round(SUM(A.GAIN),4) GP ,GET_CUS_CLS( GET_CUS_CLS_ID(A.CUS_ID))
              FROM SLS_V A,SLS_CENTER B  
              WHERE   A.SLS_CNTR_ID = B.SLS_CNTR_ID  AND A.CUS_ID IS NOT NULL  
              group by   A.SLS_CNTR_ID,B.SLS_CNTR_NAME,GET_CUS_CLS_ID(A.CUS_ID);
              */

      /*
 
select A.* ,
( SELECT ROUND(SUM(NVL(t.MD,0) - NVL(t.DN,0)), 2) FROM CUS_HD_CUS_DT_TRANS t  WHERE t.CS_CLS_ID = A.CLS_ID ) AS MDUNIH,
( SELECT ROUND(SUM(NVL(T.AMNT_MD,0)), 2) FROM ACC_HD_ACC_DT T  WHERE T.BANK_ID = A.SLS_MAN_BANK_ID  
AND T.DATE1 BETWEEN TO_DATE('12/01/2025 00:00:00', 'MM/DD/YYYY HH24:MI:SS') AND TO_DATE('12/31/2025 00:00:00', 'MM/DD/YYYY HH24:MI:SS')) AS T7SIL
from (
SELECT A.SLS_CNTR_ID,a.sls_man_id , a.sls_man_name,  (SELECT B.BANK_ID FROM USER1 B WHERE B.SLS_MAN_ID=A.SLS_MAN_ID) SLS_MAN_BANK_ID,
round(SUM(A.PUR_TTL_CST),4) TTL_CST,round(SUM(A.INV_TTL),4) INV_TTL58 ,round(SUM(A.GAIN),4) GP , GET_CUS_CLS_ID(A.CUS_ID) CLS_ID
              FROM SLS_V A
              WHERE   A.CUS_ID IS NOT NULL  AND A.SLS_MAN_ID IS NOT NULL
               AND A.DATE1 BETWEEN TO_DATE('12/01/2025 00:00:00', 'MM/DD/YYYY HH24:MI:SS') AND TO_DATE('12/31/2025 00:00:00', 'MM/DD/YYYY HH24:MI:SS')
              group by   A.SLS_CNTR_ID,a.sls_man_id , a.sls_man_name, GET_CUS_CLS_ID(A.CUS_ID)
              ) A order by  3 desc ;
              */

      String monthstmt = """
                        SELECT * FROM TABLE(APP_ACCOUNT.GET_SLS_CNTR_FULL_REP(
                          $frmDate,
                          $toDate
                          ${selectedslsCntr == "" ? ", NULL" : ", '$selectedslsCntr'"}
                        ))
                        """;

      // print(monthstmt);
      monthRows = await getMonthData(sqlStatment: monthstmt, errorCallback: (error) => errorCallBack("$error (month stmt) "));

      monthRows;
      loadingData = false;
      update();
    } else {
      // stmt = buildStatment(colName: 'GAIN');
      stmt = """
              SELECT * FROM TABLE(APP_ACCOUNT.GET_SLS_CNTR_MONTHLY_REP(
                $frmDate,
                $toDate,
                'GAIN'
                ${selectedslsCntr == "" ? ", NULL" : ", '$selectedslsCntr'"}
              ))
              """;
      debugPrint(stmt);
      gainRows = await getGainData(sqlStatment: stmt, errorCallback: (error) => errorCallBack("$error (SLS Gain) "));
      // stmt = buildStatment(colName: 'PUR_TTL_CST');
      stmt = """
            SELECT * FROM TABLE(APP_ACCOUNT.GET_SLS_CNTR_MONTHLY_REP(
              $frmDate,
              $toDate,
              'PUR_TTL_CST'
              ${selectedslsCntr == "" ? ", NULL" : ", '$selectedslsCntr'"}
            ))
            """;
      costRows = await getCostData(sqlStatment: stmt, errorCallback: (error) => errorCallBack("$error (Cost stmt) "));
      // stmt = buildStatment(colName: 'INV_TTL');
      stmt = """
              SELECT * FROM TABLE(APP_ACCOUNT.GET_SLS_CNTR_MONTHLY_REP(
                $frmDate,
                $toDate,
                'INV_TTL'
                ${selectedslsCntr == "" ? ", NULL" : ", '$selectedslsCntr'"}
              ))
              """;
      slsRows = await getSlsData(sqlStatment: stmt, errorCallback: (error) => errorCallBack("$error (SLS stmt) "));

      slsRows;
      costRows;
      gainRows;
      loadingData = false;
      update();
    }
  }

  //

  fullViewTableOptions({required List<PlutoColumn> columns}) => TableOptions(
        isAdmin: userController.uIsAdmin,
        isLoadingData: loadingData,
        repID: fullRepId,
        tableRows: monthRows,
        tableColumns: columns,
        appDefault: userController.appDefault,
        fromToDate: repDate,
        pdfTitle: "اجماليات مراكز البيع",
        // fullScreenTitle: "اجماليات مراكز البيع",
        columnGroups: ['INV_TTL', 'TTL_CST', 'GP'],
        onUpdateSetting: (p0) {
          print(p0);
          userController.appDefault = p0;
          update();
        },
      );

  gainViewTableOptions({required List<PlutoColumn> columns}) {
    print("----------------------------------------- ");
    return TableOptions(
      isAdmin: userController.uIsAdmin,
      isLoadingData: loadingData,
      repID: gainRepId,
      tableRows: gainRows,
      tableColumns: columns,
      fromToDate: repDate,
      pdfTitle: "الربح حسب مراكز البيع",
      fullScreenTitle: "ربح مراكز البيع",
      onUpdateSetting: (p0) {
        print(p0);
      },
      // tatalTopTitle: ['INV_TTL', 'TTL_CST', 'GP'],
    );
  }

  slsViewTableOptions({required List<PlutoColumn> columns}) {
    return TableOptions(
      isAdmin: userController.uIsAdmin,
      isLoadingData: loadingData,
      repID: slsRepId,
      tableRows: slsRows,
      tableColumns: columns,
      fromToDate: repDate,
      pdfTitle: "مبيعات مراكز البيع",
      fullScreenTitle: "مبيعات مراكز البيع",
      onUpdateSetting: (p0) {
        print(p0);
      },
      // tatalTopTitle: ['INV_TTL', 'TTL_CST', 'GP'],
    );
  }

  costViewTableOptions({required List<PlutoColumn> columns}) {
    return TableOptions(
      isAdmin: userController.uIsAdmin,
      isLoadingData: loadingData,
      repID: costRepId,
      tableRows: costRows,
      tableColumns: columns,
      fromToDate: repDate,
      pdfTitle: "تكلفة مراكز البيع",
      fullScreenTitle: "تكلفة مراكز البيع",
      onUpdateSetting: (p0) {
        print(p0);
      },
      // tatalTopTitle: ['INV_TTL', 'TTL_CST', 'GP'],
    );
  }

//----------------------------------------From Server ------------------------------
  Future<List<PlutoRow>> getCostData({required String sqlStatment, Function(String error)? errorCallback}) async {
    final services = Services();
    List<dynamic> responeData = await services.createRep(sqlStatment: sqlStatment);

    List<PlutoRow> rows = responeData.map((item) {
      double rowttl = 0;
      PlutoCell plutoCell(int i) {
        rowttl += item[i.toString().padLeft(2, '0')].toString() == "null" ? 0 : item[i.toString().padLeft(2, '0')];
        return PlutoCell(value: item[i.toString().padLeft(2, '0')]);
      }

      return PlutoRow(cells: {
        // 'SLS_MAN_ID': PlutoCell(value: item['SLS_MAN_ID']),
        // 'DOC_YYYYMM1': PlutoCell(value: item['DOC_YYYYMM1']),

        // 'YR': PlutoCell(value: item['YR']),
        // 'PRD_DATE': PlutoCell(value: item['PRD_DATE']),
        'SLS_CNTR_ID': PlutoCell(value: item['SLS_CNTR_ID']),
        'NAME': PlutoCell(value: item['NAME'].toString() != "null" ? item['NAME'] : ""),
        for (int i = 1; i <= 12; i++) '$i': plutoCell(i),
        'TOTAL': PlutoCell(value: rowttl),
      });
    }).toList();
    // print("done");
    return rows;
  }

  Future<List<PlutoRow>> getGainData({required String sqlStatment, Function(String error)? errorCallback}) async {
    final services = Services();
    List<dynamic> responeData = await services.createRep(sqlStatment: sqlStatment);

    List<PlutoRow> rows = responeData.map((item) {
      double rowttl = 0;
      PlutoCell plutoCell(int i) {
        rowttl += item[i.toString().padLeft(2, '0')].toString() == "null" ? 0 : item[i.toString().padLeft(2, '0')];
        return PlutoCell(value: item[i.toString().padLeft(2, '0')]);
      }

      return PlutoRow(cells: {
        // 'SLS_MAN_ID': PlutoCell(value: item['SLS_MAN_ID']),
        // 'DOC_YYYYMM1': PlutoCell(value: item['DOC_YYYYMM1']),
        // 'YR': PlutoCell(value: item['YR']),
        // 'PRD_DATE': PlutoCell(value: item['PRD_DATE']),
        'SLS_CNTR_ID': PlutoCell(value: item['SLS_CNTR_ID']),
        'NAME': PlutoCell(value: item['NAME'].toString() != "null" ? item['NAME'] : ""),
        // for (int i = 1; i <= 12; i++) '$i': PlutoCell(value: item[i.toString().padLeft(2, '0')]),
        for (int i = 1; i <= 12; i++) '$i': plutoCell(i),
        'TOTAL': PlutoCell(value: rowttl),
      });
    }).toList();
    // print("done");
    return rows;
  }

  Future<List<PlutoRow>> getSlsData({required String sqlStatment, Function(String error)? errorCallback}) async {
    final services = Services();
    List<dynamic> responeData = await services.createRep(sqlStatment: sqlStatment);

    List<PlutoRow> rows = responeData.map((item) {
      double rowttl = 0;
      PlutoCell plutoCell(int i) {
        rowttl += item[i.toString().padLeft(2, '0')].toString() == "null" ? 0 : item[i.toString().padLeft(2, '0')];
        return PlutoCell(value: item[i.toString().padLeft(2, '0')]);
      }

      return PlutoRow(cells: {
        // 'SLS_MAN_ID': PlutoCell(value: item['SLS_MAN_ID']),
        // 'DOC_YYYYMM1': PlutoCell(value: item['DOC_YYYYMM1']),
        // 'YR': PlutoCell(value: item['YR']),
        // 'PRD_DATE': PlutoCell(value: item['PRD_DATE']),
        'SLS_CNTR_ID': PlutoCell(value: item['SLS_CNTR_ID']),
        'NAME': PlutoCell(value: item['NAME'].toString() != "null" ? item['NAME'] : ""),
        // for (int i = 1; i <= 12; i++) '$i': PlutoCell(value: item[i.toString().padLeft(2, '0')]),
        for (int i = 1; i <= 12; i++) '$i': plutoCell(i),
        'TOTAL': PlutoCell(value: rowttl),
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
