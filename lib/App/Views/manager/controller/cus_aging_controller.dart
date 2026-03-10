import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/user_controller.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../../services/api_db_services.dart';
import '../../../../widget/widget.dart';
import '../../../../table_view/controllers/table_controller.dart';
import '../../../../table_view/options/table_options.dart';
import '../../../models/user_model.dart';

class CustomersAgingController extends GetxController {
  UserController userController = Get.find<UserController>();
  bool initial = true;
  bool loadingData = false;
  String fullRepId = "slsRepCustomersAgingFullView";

  List<PlutoRow> rows = [];
  List<PlutoColumn> columns = [];

  final TextEditingController toDateController = TextEditingController();

  SearchList? selectedslsMan;
  List<SearchList> slsManOrignalData = [];

  CusDataModel? selecetdCustomer;
  List<CusDataModel> cusData = [];

  int? selectedAccountYearId;
  String selectedAccountYear = "";
  List<SearchList> accountYearList = [];

  bool optionShow = true;

  @override
  void onInit() {
    super.onInit();
    Get.lazyPut(() => TableController());
    initial = true;

    rows = [];

    toDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

    selectedslsMan = null;
    slsManOrignalData = [];

    optionShow = true;

    slsManOrignalData = userController.slsManDataList.map((e) => SearchList(id: e.slsManId, name: e.slsManName, state: false)).toList();
    cusData = userController.cusDataList;
    //
    accountYearList = userController.accountYearList.map((e) => SearchList(id: e.accYearBrId, name: "${e.accYear}", state: false)).toList();
    print(accountYearList.length);
    selectedAccountYearId = accountYearList.first.id;
    selectedAccountYear = accountYearList.first.name;
  }

  String toDate = "";
  String repDate = "";

  errorCallBack(String errorMessage) {
    showMessage(msg: errorMessage, color: Colors.red);
  }

  clearData() {
    selecetdCustomer = null;
    // rows.clear();
    update();
  }

  getdata() async {
    rows = [];

    loadingData = true;
    optionShow = false;
    update();
    // toDate = "TO_DATE('$toDate', 'DD-MM-YYYY')";
    String monthstmt = """
                  SELECT * FROM TABLE(
                    APP_ACCOUNT.GET_CUSTOMERS_AGING(
                      $selectedAccountYearId, 
                      '${toDateController.text}',
                      ${userController.uId}     
                      ${selecetdCustomer == null ? ", NULL" : ", '${selecetdCustomer!.cusId}'"}
                      ${selectedslsMan == null ? ", NULL" : ", ${selectedslsMan!.id}"}
                    )
                  )
                  """;

    print(monthstmt);
    rows = await getMonthData(sqlStatment: monthstmt, errorCallback: (error) => errorCallBack("$error (month stmt) "));

    loadingData = false;
    update();
  }

  //

  fullViewTableOptions({required List<PlutoColumn> columns}) => TableOptions(
        isAdmin: userController.uIsAdmin,
        isLoadingData: loadingData,
        repID: fullRepId,
        tableRows: rows,
        tableColumns: columns,
        appDefault: userController.appDefault,
        pdfTitle: "اجماليات المناديب ",
        fromToDate: repDate,
        fullScreenTitle: "اجماليات المناديب ",
        columnGroups: ['COUNT=>CUS_ID', 'A180', 'A150', 'A120', 'A90', 'A60', 'A30', 'A0', 'A00', 'BAL', 'AP'],
        onUpdateSetting: (p0) {
          print(p0);
          userController.appDefault = p0;
          update();
        },
      );

  Future<List<PlutoRow>> getMonthData({required String sqlStatment, Function(String error)? errorCallback}) async {
    final services = Services();
    List<dynamic> responeData = await services.createRep(sqlStatment: sqlStatment);

    List<PlutoRow> rows = responeData.map((item) {
      return PlutoRow(cells: {
        'CUS_ID': PlutoCell(value: item['CUS_ID']),
        'CUS_NAME': PlutoCell(value: item['CUS_NAME']),
        'A30': PlutoCell(value: item['A30']),
        'A60': PlutoCell(value: item['A60']),
        'A90': PlutoCell(value: item['A90']),
        'A120': PlutoCell(value: item['A120']),
        'A150': PlutoCell(value: item['A150']),
        'A180': PlutoCell(value: item['A180']),
        'A0': PlutoCell(value: item['A0']),
        'A00': PlutoCell(value: item['A00']),
        'BAL': PlutoCell(value: item['BAL']),
        'AP': PlutoCell(value: item['AP']),
      });
    }).toList();
    return rows;
  }
}
