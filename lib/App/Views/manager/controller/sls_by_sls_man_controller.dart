import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/user_controller.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../../services/api_db_services.dart';
import '../../../../widget/widget.dart';
import '../../../../table_view/controllers/table_controller.dart';
import '../../../../table_view/options/table_options.dart';

class SlsBySlsManController extends GetxController {
  UserController userController = Get.find<UserController>();
  bool initial = true;
  bool loadingData = false;
  String fullRepId = "slsRepSlsBySlsManFullView";
  String mdunihRepId = "slsRepSlsBySlsManMdunihView";
  String slsRepId = "slsRepSlsBySlsManSlsView";
  String gainRepId = "slsRepSlsBySlsManGainView";
  String t7silRepId = "slsRepSlsBySlsManT7silView";

  List<PlutoRow> monthRows = [];
  List<PlutoRow> slsRows = [];
  List<PlutoRow> gainRows = [];
  List<PlutoRow> mdunihRows = [];
  List<PlutoRow> t7silRows = [];

  //
  List<PlutoColumn> monthColumns = [];

  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController mnthDateController = TextEditingController();

  String selectedslsMan = "";
  List<SearchList> slsManOrignalData = [];

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
    mdunihRows = [];
    t7silRows = [];

    fromDateController.text = ""; // DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    // DateFormat('yyyy-MM-dd').parse(DateTime.now().toString()).toString();
    toDateController.text = ""; // DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    mnthDateController.text = "";

    selectedslsMan = "";
    slsManOrignalData = [];
    optionShow = true;

    selectedSchYearIds = "";
    schYearOrignalData = [];

    // defaultTableSetting = {};
    // print(userController.slsManDataList.length);
    slsManOrignalData = userController.slsManDataList.map((e) => SearchList(id: e.slsManId, name: e.slsManName, state: false)).toList();
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
    // Get.delete<SlsBySlsManController>(force: true);
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

  checkSearchOption() async {
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
  String buildStatment({required String colName, required String subQuery, String conditons = ""}) {
    return """
SELECT
    S.SLS_MAN_ID,
    S.SLS_MAN_NAME,
    SUM(CASE WHEN TO_CHAR(S.DATE1,'MM')='01' THEN S.$colName ELSE 0 END) "01",
    SUM(CASE WHEN TO_CHAR(S.DATE1,'MM')='02' THEN S.$colName ELSE 0 END) "02",
    SUM(CASE WHEN TO_CHAR(S.DATE1,'MM')='03' THEN S.$colName ELSE 0 END) "03",
    SUM(CASE WHEN TO_CHAR(S.DATE1,'MM')='04' THEN S.$colName ELSE 0 END) "04",
    SUM(CASE WHEN TO_CHAR(S.DATE1,'MM')='05' THEN S.$colName ELSE 0 END) "05",
    SUM(CASE WHEN TO_CHAR(S.DATE1,'MM')='06' THEN S.$colName ELSE 0 END) "06",
    SUM(CASE WHEN TO_CHAR(S.DATE1,'MM')='07' THEN S.$colName ELSE 0 END) "07",
    SUM(CASE WHEN TO_CHAR(S.DATE1,'MM')='08' THEN S.$colName ELSE 0 END) "08",
    SUM(CASE WHEN TO_CHAR(S.DATE1,'MM')='09' THEN S.$colName ELSE 0 END) "09",
    SUM(CASE WHEN TO_CHAR(S.DATE1,'MM')='10' THEN S.$colName ELSE 0 END) "10",
    SUM(CASE WHEN TO_CHAR(S.DATE1,'MM')='11' THEN S.$colName ELSE 0 END) "11",
    SUM(CASE WHEN TO_CHAR(S.DATE1,'MM')='12' THEN S.$colName ELSE 0 END) "12"
FROM (
    $subQuery
) S
GROUP BY  S.SLS_MAN_ID,S.SLS_MAN_NAME
ORDER BY  S.SLS_MAN_ID
""";
  }
*/
  getdata() async {
    monthRows = [];
    gainRows = [];
    slsRows = [];
    mdunihRows = [];
    t7silRows = [];
    loadingData = true;
    optionShow = false;

    checkSearchOption();

    String stmt = "";

    if (!dateSwitcher) {
      showMonthRep = true;
      //month view
      //   String monthstmt = """
      // select A.* ,
      //   ( SELECT ROUND(SUM(NVL(t.MD,0) - NVL(t.DN,0)), 4) FROM CUS_HD_CUS_DT_TRANS t  WHERE t.CS_CLS_ID = A.CLS_ID ) AS MDUNIH,
      //   ( SELECT ROUND(SUM(NVL(T.AMNT_MD,0)), 4) FROM ACC_HD_ACC_DT T  WHERE T.BANK_ID = A.SLS_MAN_BANK_ID  ) AS T7SIL
      // from (
      //   SELECT A.SLS_CNTR_ID,a.sls_man_id , a.sls_man_name,  (SELECT B.BANK_ID FROM USER1 B WHERE B.SLS_MAN_ID=A.SLS_MAN_ID) SLS_MAN_BANK_ID,
      //     round(SUM(A.PUR_TTL_CST),4) TTL_CST,round(SUM(A.INV_TTL),4) INV_TTL ,round(SUM(A.GAIN),4) GP , GET_CUS_CLS_ID(A.CUS_ID) CLS_ID
      //   FROM SLS_V A
      //   WHERE   A.CUS_ID IS NOT NULL  AND A.SLS_MAN_ID IS NOT NULL
      //   ${selectedslsMan == "" ? "" : " AND A.SLS_MAN_ID IN ( $selectedslsMan ) "}
      //   AND A.DATE1 BETWEEN $frmDate AND $toDate
      //   group by   A.SLS_CNTR_ID,a.sls_man_id , a.sls_man_name, GET_CUS_CLS_ID(A.CUS_ID)
      //   ) A
      // """;

      String monthstmt = """
                  SELECT * 
                  FROM TABLE(APP_ACCOUNT.GET_SLS_MAN_FULL_REP(
                    $frmDate,
                    $toDate
                    ${selectedslsMan == "" ? ", NULL" : ", '$selectedslsMan'"}
                  ))
                  """;

      // print(monthstmt);
      monthRows = await getMonthData(sqlStatment: monthstmt, errorCallback: (error) => errorCallBack("$error (month stmt) "));
      monthRows;
      loadingData = false;
      update();
    } else {
      // stmt = buildStatment(colName: "MDUNIH", subQuery: """
      // SELECT S.SLS_MAN_ID, S.SLS_MAN_NAME, TRUNC(S.DATE1) DATE1, ROUND(SUM(NVL(T.MD,0)-NVL(T.DN,0)),4) MDUNIH
      //     FROM SLS_V S
      //     JOIN CUS_HD_CUS_DT_TRANS T  ON T.CS_CLS_ID = GET_CUS_CLS_ID(S.CUS_ID) AND TRUNC(T.DATE1)=TRUNC(S.DATE1)
      //     WHERE S.CUS_ID IS NOT NULL  AND S.SLS_MAN_ID IS NOT NULL
      //     ${selectedslsMan == "" ? "" : " AND S.SLS_MAN_ID IN ( $selectedslsMan ) "}
      //     AND S.DATE1 BETWEEN $frmDate AND $toDate
      //     GROUP BY  S.SLS_MAN_ID,S.SLS_MAN_NAME,TRUNC(S.DATE1)
      // """);

      stmt = """
            SELECT * FROM TABLE(APP_ACCOUNT.GET_SLS_MAN_MDUNIH_REP(
              $frmDate,
              $toDate
              ${selectedslsMan == "" ? ", NULL" : ", '$selectedslsMan'"}
            ))
            """;

      mdunihRows = await getSumByMonthData(sqlStatment: stmt, errorCallback: (error) => errorCallBack("$error (SLS MDUNIH) "));

//-------------------------
      // stmt = buildStatment(colName: "T7SIL", subQuery: """
      //  SELECT S.SLS_MAN_ID,  S.SLS_MAN_NAME, TRUNC(S.DATE1) DATE1, ROUND(SUM(NVL(V.AMNT_MD,0)),4) T7SIL
      //     FROM SLS_V S
      //     JOIN USER1 U ON U.SLS_MAN_ID = S.SLS_MAN_ID
      //     JOIN ACC_HD_ACC_DT V  ON V.BANK_ID = U.BANK_ID  AND TRUNC(V.DATE1)=TRUNC(S.DATE1)
      //     WHERE S.CUS_ID IS NOT NULL  AND S.SLS_MAN_ID IS NOT NULL
      //     ${selectedslsMan == "" ? "" : " AND S.SLS_MAN_ID IN ( $selectedslsMan ) "}
      //     AND S.DATE1 BETWEEN $frmDate AND $toDate
      //     GROUP BY S.SLS_MAN_ID,S.SLS_MAN_NAME, TRUNC(S.DATE1)
      // """);
      stmt = """
            SELECT * FROM TABLE(APP_ACCOUNT.GET_SLS_MAN_T7SIL_REP(
              $frmDate,
              $toDate
              ${selectedslsMan == "" ? ", NULL" : ", '$selectedslsMan'"}
            ))
            """;

      t7silRows = await getSumByMonthData(sqlStatment: stmt, errorCallback: (error) => errorCallBack("$error (SLS T7SIL) "));
//-------------------------
      // stmt = buildStatment(colName: "INV_TTL", subQuery: """
      // SELECT SLS_MAN_ID, SLS_MAN_NAME, TRUNC(DATE1) DATE1, ROUND(SUM(INV_TTL),4) INV_TTL
      //     FROM SLS_V
      //     WHERE CUS_ID IS NOT NULL  AND SLS_MAN_ID IS NOT NULL
      //     ${selectedslsMan == "" ? "" : " AND SLS_MAN_ID IN ( $selectedslsMan ) "}
      //     AND DATE1 BETWEEN $frmDate AND $toDate
      //     GROUP BY  SLS_MAN_ID,  SLS_MAN_NAME, TRUNC(DATE1)
      // """);

      stmt = """
            SELECT * FROM TABLE(APP_ACCOUNT.GET_SLS_MAN_SLSTTL_REP(
              $frmDate,
              $toDate
              ${selectedslsMan == "" ? ", NULL" : ", '$selectedslsMan'"}
            ))
            """;

      slsRows = await getSumByMonthData(sqlStatment: stmt, errorCallback: (error) => errorCallBack("$error (SLS stmt) "));
//-------------------------
      // stmt = buildStatment(colName: "GP", subQuery: """
      // SELECT SLS_MAN_ID, SLS_MAN_NAME,TRUNC(DATE1) DATE1,ROUND(SUM(GAIN),4) GP
      //   FROM SLS_V
      //   WHERE CUS_ID IS NOT NULL  AND SLS_MAN_ID IS NOT NULL
      //   ${selectedslsMan == "" ? "" : " AND SLS_MAN_ID IN ( $selectedslsMan ) "}
      //     AND DATE1 BETWEEN $frmDate AND $toDate
      //   GROUP BY SLS_MAN_ID, SLS_MAN_NAME,TRUNC(DATE1)
      // """);

      stmt = """
            SELECT * FROM TABLE(APP_ACCOUNT.GET_SLS_MAN_SLSGP_REP(
              $frmDate,
              $toDate
              ${selectedslsMan == "" ? ", NULL" : ", '$selectedslsMan'"}
            ))
            """;
      // printLongString(stmt);
      gainRows = await getSumByMonthData(sqlStatment: stmt, errorCallback: (error) => errorCallBack("$error (SLS Gain) "));
//-------------------------

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
        pdfTitle: "اجماليات المناديب ",
        fromToDate: repDate,
        fullScreenTitle: "اجماليات المناديب ",
        columnGroups: ['INV_TTL', 'TTL_CST', 'GP', 'MDUNIH', 'T7SIL'],
        onUpdateSetting: (p0) {
          print(p0);
          userController.appDefault = p0;
          update();
        },
      );

  gainViewTableOptions({required List<PlutoColumn> columns}) {
    return TableOptions(
      isAdmin: userController.uIsAdmin,
      isLoadingData: loadingData,
      repID: gainRepId,
      tableRows: gainRows,
      tableColumns: columns,
      pdfTitle: "الربح حسب المناديب",
      fromToDate: repDate,
      fullScreenTitle: "ربح المناديب",
      onUpdateSetting: (p0) {
        print(p0);
      },
    );
  }

  slsViewTableOptions({required List<PlutoColumn> columns}) {
    return TableOptions(
      isAdmin: userController.uIsAdmin,
      isLoadingData: loadingData,
      repID: slsRepId,
      tableRows: slsRows,
      tableColumns: columns,
      pdfTitle: "مبيعات المناديب",
      fromToDate: repDate,
      fullScreenTitle: "مبيعات المناديب",
      onUpdateSetting: (p0) {
        print(p0);
      },
    );
  }

  mdunihViewTableOptions({required List<PlutoColumn> columns}) {
    return TableOptions(
      isAdmin: userController.uIsAdmin,
      isLoadingData: loadingData,
      repID: mdunihRepId,
      tableRows: mdunihRows,
      tableColumns: columns,
      pdfTitle: "مديونية المناديب",
      fromToDate: repDate,
      fullScreenTitle: "مديونية المناديب",
      onUpdateSetting: (p0) {
        print(p0);
      },
    );
  }

  t7silViewTableOptions({required List<PlutoColumn> columns}) {
    return TableOptions(
      isAdmin: userController.uIsAdmin,
      isLoadingData: loadingData,
      repID: t7silRepId,
      tableRows: t7silRows,
      tableColumns: columns,
      pdfTitle: "تحصيلات المناديب",
      fromToDate: repDate,
      fullScreenTitle: "تحصيلات المناديب",
      onUpdateSetting: (p0) {
        print(p0);
      },
    );
  }

//----------------------------------------From Server ------------------------------
/*
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
*/
  Future<List<PlutoRow>> getSumByMonthData({required String sqlStatment, Function(String error)? errorCallback}) async {
    final services = Services();
    List<dynamic> responeData = await services.createRep(sqlStatment: sqlStatment);

    List<PlutoRow> rows = responeData.map((item) {
      double row_ttl = 0;
      PlutoCell plutoCell(int i) {
        row_ttl += item[i.toString().padLeft(2, '0')].toString() == "null" ? 0 : item[i.toString().padLeft(2, '0')];
        return PlutoCell(value: item[i.toString().padLeft(2, '0')]);
      }

      return PlutoRow(cells: {
        // 'SLS_MAN_ID': PlutoCell(value: item['SLS_MAN_ID']),
        'SLS_MAN_NAME': PlutoCell(value: item['SLS_MAN_NAME']),
        for (int i = 1; i <= 12; i++) '$i': plutoCell(i) /*PlutoCell(value: item[i.toString().padLeft(2, '0')])*/,
        'TOTAL': PlutoCell(value: row_ttl),
      });
    }).toList();
    // print("done");
    return rows;
  }

/*
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
*/
  Future<List<PlutoRow>> getMonthData({required String sqlStatment, Function(String error)? errorCallback}) async {
    final services = Services();
    List<dynamic> responeData = await services.createRep(sqlStatment: sqlStatment);

    List<PlutoRow> rows = responeData.map((item) {
      return PlutoRow(cells: {
        // 'YR': PlutoCell(value: item['YR']),
        'SLS_CNTR_ID': PlutoCell(value: item['SLS_CNTR_ID']),
        // 'SLS_CNTR_NAME': PlutoCell(value: item['SLS_CNTR_NAME']),
        'SLS_MAN_NAME': PlutoCell(value: item['SLS_MAN_NAME']),
        'INV_TTL': PlutoCell(value: item['INV_TTL']),
        'TTL_CST': PlutoCell(value: item['TTL_CST']),
        'GP': PlutoCell(value: item['GP']),
        'MDUNIH': PlutoCell(value: item['MDUNIH']),
        'T7SIL': PlutoCell(value: item['T7SIL']),
      });
    }).toList();
    return rows;
  }
}
