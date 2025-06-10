// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/login_controller.dart';
import '../Models/user_model.dart';
import '../Services/api_db_services.dart';

import '../Variable/global_variable.dart';
// import '../Variable/global_variable.dart';

class UserController extends GetxController {
  late LoginController loginController;

  GlobalVariable globalVariable = GlobalVariable();
  final Services dbServices = Services();

  //--------------------------------------
  String uId = "";
  String uName = "";
  String hasMoreThanRequiredPrivileges = "";
  String hasNoPrivileges = "";
  String appLog = "";

  //--------------------------------
  List<ActPrivModel> actPrivList = [];
  List<CusDataModel> cusDataList = [];
  List<SlsCntrPrivModel> slsCntrPrivList = [];
  List<CstCntrPrivModel> cstCntrPrivList = [];
  List<StWhousesPrivModel> stWhPrivList = [];
  List<BranchPrivModel> branchPrivList = [];
  List<CsClsPrivModel> csClsPrivList = [];

  List<BankPrivModel> bankPrivList = [];

  List<ItemsDataModel> itemsDataList = [];
  late CompData compData;

  //add loading present increased after each async function ******************

  checkPrivileges({required List lst, required String tabel, required bool needOnlyOneRow}) {
    if (lst.length > 1 && needOnlyOneRow) {
      hasMoreThanRequiredPrivileges += "User $uId has privilege for ${lst.length} $tabel Only one required \n";
      appLog += "User $uId has privilege for ${lst.length} $tabel Only one required \n";
      globalVariable.setUserId = globalVariable.getErrorLog + hasMoreThanRequiredPrivileges;
    } else if (lst.isEmpty) {
      hasMoreThanRequiredPrivileges += "User $uId has No privilege On Any $tabel \n";
      appLog += "User $uId has No privilege On Any $tabel \n";
      globalVariable.setUserId = globalVariable.getErrorLog + hasMoreThanRequiredPrivileges;
    }
  }

  Future<void> _getActPrivileges() async {
    var response = await dbServices.createRep(
      sqlStatment: """
      SELECT a.* , (SELECT ACT_NAME FROM ACT_TYPE WHERE ACT_ID = a.ACT_ID) AS ACT_NAME FROM
      (SELECT ACT_ID , CHK FROM USER_JOURNAL 
      WHERE U_ID='$uId' 
      
      AND CHK=1
      ) a
      """,

      //AND ACT_ID IN (53$uId, 57$uId, 58, 59, 60, 61, 77, 99)
    );

    for (var element in response) {
      actPrivList.add(ActPrivModel(actId: element['ACT_ID'], actName: element['ACT_NAME'], chk: element['CHK'] == 1 ? true : false));
    }

    //cheak if there any act not allowed for the user
    List<dynamic> userActIds = [int.parse('53$uId'), int.parse('57$uId'), 58, 59, 60, 61, 77, 99];
    Set<dynamic> presentActIds = actPrivList.map((e) => e.actId).toSet();
    for (var actId in userActIds) {
      if (!presentActIds.contains(actId)) {
        hasNoPrivileges += "User $uId has no privilege on ACT_ID $actId\n";
        appLog += "User $uId has no privilege on ACT_ID $actId\n";
        globalVariable.setErrorLog = globalVariable.getErrorLog + hasNoPrivileges;
      }
    }

    if (actPrivList.isEmpty) {
      hasMoreThanRequiredPrivileges += "User $uId has No privilege On Any ACT  \n";
      appLog += "User $uId has No privilege On Any ACT  \n";
      globalVariable.setUserId = globalVariable.getErrorLog + hasMoreThanRequiredPrivileges;
    }

    // Clipboard.setData(ClipboardData(text: notAllowedIds.join(',')));
    //Old code
    /*
    // Build a map for quick lookup
    final Map<int, dynamic> actMap = {
      for (var e in response) int.parse(e['ACT_ID']): e['CHK'],
    };

    actPrivModel = ActPrivModel(
      a53: actMap[53] ?? 0,
      a57: actMap[57] ?? 0,
      a58: actMap[58] ?? 0,
      a59: actMap[59] ?? 0,
      a60: actMap[60] ?? 0,
      a61: actMap[61] ?? 0,
      a77: actMap[77] ?? 0,
      a99: actMap[99] ?? 0,
    );

    //inefficient code multiple loop.....
    // actPrivModel = ActPrivModel(
    //   a53: response.firstWhere((element) => element['ACT_ID'] == 53)['CHK'],
    //   a57: response.firstWhere((element) => element['ACT_ID'] == 53)['CHK'],
    //   a58: response.firstWhere((element) => element['ACT_ID'] == 53)['CHK'],
    //   a59: response.firstWhere((element) => element['ACT_ID'] == 53)['CHK'],
    //   a60: response.firstWhere((element) => element['ACT_ID'] == 53)['CHK'],
    //   a61: response.firstWhere((element) => element['ACT_ID'] == 53)['CHK'],
    //   a77: response.firstWhere((element) => element['ACT_ID'] == 53)['CHK'],
    //   a99: response.firstWhere((element) => element['ACT_ID'] == 53)['CHK'],
    // );

    */
  }

  Future<void> _getCusData() async {
    //CUSTOMERS columons
    /*
  {
        "CUS_ID": 17,
        "CUS_NAME": "ابو الطيب",
        "CS_CLS_ID": 1,
        "UNTD_ID": null,
        "TEL": null,
        "FAX": null,
        "MOBL": null,
        "ADRS": "السودان ام درمان",
        "OPN_BAL": null,
        "CRNT_BAL": null,
        "ACC_ID": null,
        "MAX_LIMIT": null,
        "MKH_ID": null,
        "REF_NO": null,
        "MR_ID": null,
        "EMAIL": null,
        "PO": null,
        "CUS_NAME_EN": null,
        "STOPED": 0,
        "ID_CARD": null,
        "INSUR_COMP_ID": null,
        "CUS_INSUR_COMP": null,
        "CUS_INSUR_AMNT_VAL": null,
        "CUS_INSUR_AMNT_PR": null,
        "CUS_INSUR_CARD_ID": null,
        "R_DIS_SPH": null,
        "R_DIS_CYL": null,
        "R_DIS_AX": null,
        "R_REA_SPH": null,
        "R_REA_CYL": null,
        "R_REA_AX": null,
        "L_DIS_SPH": null,
        "L_DIS_CYL": null,
        "L_DIS_AX": null,
        "L_REA_SPH": null,
        "L_REA_CYL": null,
        "L_REA_AX": null,
        "GLASS_ADD": null,
        "GLASS_IPD": null,
        "INSUR_CUS_ID": null,
        "SLS_MAN_ID": null,
        "CUS_CON_ID": null,
        "VISIT_CNT": null,
        "LATITUDE": null,
        "LONGITUDE": null,
        "LAST_KASHF_DATE": "2022-10-12T18:35:00",
        "USR_INS": 1,
        "USR_INS_DATE": "2022-10-12T18:34:08",
        "USR_UPD": null,
        "USR_UPD_DATE": null,
        "TAX_NO": "65464654654",
        "VAT_STATUS": 1,
        "PERSON_IN_CHARGE": null,
        "PERSON_IN_CHARGE1": null,
        "MOBL1": null,
        "ID_CARD1": null,
        "CNTRY_ID": null,
        "CUS_VAT": null,
        "REGION": 1,
        "CUR_ID": "01",
        "R_E_B": null,
        "L_E_B": null,
        "SLS_DIS_PR": null,
        "PAY_PRD": null,
        "CITY1": null,
        "ZONE1": null,
        "STREET1": null,
        "CUS_TRADE_NAME": null,
        "PAY_TERM_ID": null,
        "SUB_COUNTRY": null,
        "BUILDING_NUMBER": null,
        "PLOT_IDENTIFICATION": null,
        "STREET2": null,
        "VAT_CODE": null,
        "EXEMPTION_REASON": null,
        "POS": null,
        "CUS_COMMERCIAL_REG": null
    }
    */

    var response = await dbServices.createRep(
      sqlStatment: """
      SELECT *  FROM CUSTOMERS WHERE CS_CLS_ID IN
      (SELECT CS_CLS_ID FROM USER_CUS_GRP WHERE U_ID='$uId' AND CHK = 1 
      )
      """,
    );

    for (var element in response) {
      cusDataList.add(CusDataModel(cusId: element["CUS_ID"], cusName: element["CUS_NAME"], adrs: element["ADRS"] ?? "", mobl: element["MOBL"] ?? "", taxNo: element["TAX_NO"] ?? "", stoped: element["STOPED"] ?? 0, slsManId: element["SLS_MAN_ID"] ?? 0, latitude: element["LATITUDE"] ?? 0.0, longitude: element["LONGITUDE"] ?? 0.0, visitCnt: element["VISIT_CNT"] ?? 0, vatStatus: element['VAT_STATUS'] ?? 1));
    }
    // if(cusDataList.isEmpty){
    //    hasNoPrivileges += "User $uId Has No Privilege On Any Customer";
    //     globalVariable.setErrorLog = globalVariable.getErrorLog + hasNoPrivileges;
    // }
    checkPrivileges(lst: cusDataList, tabel: "Customer", needOnlyOneRow: false);
  }

  Future<void> _getSlsCntrPrivileges() async {
    var response = await dbServices.createRep(
      sqlStatment: """
      SELECT a.*,(SELECT SLS_CNTR_NAME FROM SLS_CENTER WHERE SLS_CNTR_ID=a.SLS_CNTR_ID) AS SLS_CNTR_NAME 
      FROM 
      (
      SELECT SLS_CNTR_ID FROM USER_SLS_CENTER  WHERE U_ID='$uId' AND CHK = 1 
      ) a
      """,
    );

    for (var element in response) {
      slsCntrPrivList.add(SlsCntrPrivModel(slsCntrID: element["SLS_CNTR_ID"], slsCntrName: element["SLS_CNTR_NAME"]));
    }
    // if (slsCntrPrivList.length > 1) {
    //   hasMoreThanRequiredPrivileges += "User $uId has privilege for ${slsCntrPrivList.length} Sales center Only one required \n";
    //   globalVariable.setUserId = globalVariable.getErrorLog + hasMoreThanRequiredPrivileges;
    // }else if (slsCntrPrivList.isEmpty ) {
    //   hasNoPrivileges += "User $uId has no privilege on Any Sales Center \n";
    //     globalVariable.setErrorLog = globalVariable.getErrorLog + hasNoPrivileges;
    // }
    checkPrivileges(lst: slsCntrPrivList, tabel: "Sales Center", needOnlyOneRow: true);
  }

  Future<void> _getCstCntrPrivileges() async {
    var response = await dbServices.createRep(
      sqlStatment: """
      SELECT a.*,(SELECT CST_A_NAME FROM COST_CENTERS WHERE CST_ID=a.CST_ID) AS CST_A_NAME 
      FROM 
      (
      SELECT CST_ID FROM USER_CC  WHERE U_ID='$uId' AND CHK = 1 
      ) a
      """,
    );

    for (var element in response) {
      cstCntrPrivList.add(CstCntrPrivModel(cstCntrID: element["CST_ID"], cstCntrName: element["CST_A_NAME"]));
    }
    // if (cstCntrPrivList.length > 1) {
    //   hasMoreThanRequiredPrivileges += "User $uId has privilege for ${cstCntrPrivList.length} Cost center Only one required \n";
    //   globalVariable.setUserId = globalVariable.getErrorLog + hasMoreThanRequiredPrivileges;
    // }else if (cstCntrPrivList.isEmpty) {
    //   hasNoPrivileges += "User $uId has  No privilege On Any Cost center \n";
    //   globalVariable.setUserId = globalVariable.getErrorLog + hasNoPrivileges;
    // }

    checkPrivileges(lst: cstCntrPrivList, tabel: "Cost center", needOnlyOneRow: true);
  }

  Future<void> _getStWhPrivileges() async {
    var response = await dbServices.createRep(
      sqlStatment: """
      SELECT a.*,(SELECT WH_NAME FROM STWHOUSE WHERE WH_ID=a.WH_ID) AS WH_NAME 
      FROM 
      (
      SELECT WH_ID FROM USER_STWHOUSE  WHERE U_ID='$uId' AND CHK = 1 
      ) a
      """,
    );

    for (var element in response) {
      stWhPrivList.add(StWhousesPrivModel(whID: element["WH_ID"], whName: element["WH_NAME"]));
    }
    // if (stWhPrivList.length > 1) {
    //   hasMoreThanRequiredPrivileges += "User $uId has privilege for ${stWhPrivList.length} WhereHouses Only one required \n";
    //   globalVariable.setUserId = globalVariable.getErrorLog + hasMoreThanRequiredPrivileges;
    // }else if (stWhPrivList.isEmpty) {
    //   hasMoreThanRequiredPrivileges += "User $uId has No privilege On Any WhereHouses \n";
    //   globalVariable.setUserId = globalVariable.getErrorLog + hasMoreThanRequiredPrivileges;
    // }
    checkPrivileges(lst: stWhPrivList, tabel: "WhereHouses", needOnlyOneRow: true);
  }

  Future<void> _getBranchPrivileges() async {
    var response = await dbServices.createRep(
      sqlStatment: """
      SELECT a.*,(SELECT BR_NAME FROM BRANCH WHERE BR_ID=a.BR_ID) AS BR_NAME 
      FROM 
      (
      SELECT BR_ID FROM USER_BRANCH WHERE U_ID='$uId'  
      ) a
      WHERE (SELECT MULTI_BR FROM COMP) =1
      """,
    );

    for (var element in response) {
      branchPrivList.add(BranchPrivModel(brID: element["BR_ID"], brName: element["BR_NAME"]));
    }
    // if (branchPrivList.length > 1) {
    //   errorCopyToClipoard += "User $uId has privilege for ${branchPrivList.length} BRANCHES \n";
    //   globalVariable.setUserId = globalVariable.getErrorLog + errorCopyToClipoard;
    // }
    checkPrivileges(lst: slsCntrPrivList, tabel: "BRANCHES", needOnlyOneRow: true);
  }

  Future<void> _getBankPrivileges() async {
    var response = await dbServices.createRep(
      sqlStatment: """
SELECT * FROM (
      SELECT BANK_ID , ACC_NAME,ACC_ID,BANK_OR_CASH,STOPED,CUR_ID FROM SH_BANKS_DTL 
      WHERE BANK_ID IN (SELECT BANK_ID FROM USER_BANKS WHERE U_ID='$uId' AND CHK=1 )      
      ) a
       WHERE a.ACC_ID IN(SELECT ACC_ID FROM USER_ACCOUNT b WHERE b.U_ID='$uId' AND b.CHK=1 )
      """,
    );

    for (var element in response) {
      bankPrivList.add(BankPrivModel(bankID: element["BANK_ID"], accName: element["ACC_NAME"] ?? "", accID: element["ACC_ID"] ?? "", bankOrCash: element["BANK_OR_CASH"] ?? 0, stoped: element["STOPED"] ?? 0, curId: element['CUR_ID']));
    }
    // if (bankPrivList.length > 1) {
    //   errorCopyToClipoard += "User $uId has privilege for ${bankPrivList.length} BANKS \n";
    //   globalVariable.setUserId = globalVariable.getErrorLog + errorCopyToClipoard;
    // } else if (bankPrivList.isEmpty) {
    //   errorCopyToClipoard += "User $uId has No Privilege On any Bank Or Account \n";
    //   globalVariable.setUserId = globalVariable.getErrorLog + errorCopyToClipoard;
    // }

    checkPrivileges(lst: bankPrivList, tabel: "Bank / Account", needOnlyOneRow: true);
  }

  Future<void> _getItemsData() async {
    try {
      var response = await dbServices.createRep(
        sqlStatment: """
      SELECT ITEM_ID,BARCODE,ITEM_NAME,ROUND(PRICE1, 4) PRICE1 ,  ROUND(PRICE_AFTR_VAT,4) PRICE_AFTR_VAT, MAIN_UNIT FROM ITEMS aa  
      """,
      );
      //Curnt_bal
      //,(SELECT CURNT_BAL FROM ITEMS_WHOUSE bb WHERE bb.WH_ID ='${stWhPrivList[0].whID}' AND bb.ITEM_ID=aa.ITEM_ID) CURNT_BAL
      //multi wh
      // SELECT ITEM_ID,BARCODE,ITEM_NAME,PRICE_AFTR_VAT,CURNT_BAL, MAIN_UNIT FROM ITEMS_WHOUSE WHERE WH_ID IN (${stWhPrivList.map((e) => "'${e.whID}'").toList().join(',')})

      final requiredKeys = ["ITEM_ID", "BARCODE", "ITEM_NAME", "MAIN_UNIT", "PRICE1", "PRICE_AFTR_VAT"];
      for (var element in response) {
        // if (element["ITEM_ID"] == null || element["BARCODE"] == null || element["ITEM_NAME"] == null || element["MAIN_UNIT"] == null || element["PRICE1"] == null || element["PRICE_AFTR_VAT"] == null) {
        //   appLog += "the item ( ${element["ITEM_ID"]} ) without ${element["ITEM_ID"] == null ? "ITEM_ID" : ""}${element["BARCODE"] == null ? "BARCODE" : ""}${element["ITEM_NAME"] == null ? "ITEM_NAME" : ""}
        //${element["MAIN_UNIT"] == null ? "MAIN_UNIT" : ""}${element["PRICE1"] == null ? "PRICE1" : ""}${element["PRICE_AFTR_VAT"] == null ? "PRICE_AFTR_VAT" : ""} \n";
        // }

        final missing = requiredKeys.where((k) => element[k] == null || element[k] == 'Null').toList();

        if (missing.isNotEmpty) {
          appLog += "the item (${element["ITEM_ID"]}) without ${missing.join(", ")} \n";
          // print("the item (${element["ITEM_ID"]}) without ${missing.join(", ")} ");
        } else {
          itemsDataList.add(
            ItemsDataModel(
              itemId: element["ITEM_ID"],
              barcode: element["BARCODE"],
              itemName: element["ITEM_NAME"],
              unit: element["MAIN_UNIT"],
              //qty
              price1: element["PRICE1"],
              priceAftrVat: element["PRICE_AFTR_VAT"],
              currentBal: element["CURNT_BAL"],
              //total
            ),
          );
        }

        // if (element["MAIN_UNIT"] == null) {
        //   appLog += "the item ( ${element["ITEM_ID"]} ) without main unit \n";
        // }
      }
    } catch (e) {
      print(e.toString());
      appLog += "${e.toString()} \n";
    }
  }

  Future<void> _getCusClass() async {
    var response = await dbServices.createRep(
      sqlStatment: """
      SELECT *  FROM  CS_CLS WHERE CS_CLS_ID IN
      (SELECT CS_CLS_ID FROM USER_CUS_GRP WHERE U_ID='$uId' AND CHK = 1 
      )
      """,
    );

    for (var element in response) {
      csClsPrivList.add(CsClsPrivModel(cSClsId: element["CS_CLS_ID"], cSClsName: element["CS_CLS_NAME"], accId: element["ACC_ID"], brId: element["BR_ID"], curId: element["CUR_ID"]));
    }

    checkPrivileges(lst: csClsPrivList, tabel: "CS_CLS", needOnlyOneRow: true);
  }

  //select  REP_A_COMP_NAME ,REP_E_COMP_NAME,REP_A_NTUR_WORK , REP_E_NTUR_WORK ,REP_A_ADRS ,REP_E_ADRS,REP_A_TEL,REP_A_FAX  ,TAX_NO ,COMMERCIAL_REG  from comp ;

  Future<void> _getCompData() async {
    var response = await dbServices.createRep(
      sqlStatment: """
      select  REP_A_COMP_NAME ,REP_E_COMP_NAME,REP_A_NTUR_WORK , REP_E_NTUR_WORK ,REP_A_ADRS ,REP_E_ADRS,REP_A_TEL,REP_A_FAX  
      ,TAX_NO ,COMMERCIAL_REG  from comp
      """,
    );

    for (var element in response) {
      compData = CompData(aCompName: element["REP_A_COMP_NAME"] ?? "", eCompName: element["REP_E_COMP_NAME"] ?? "", aActivity: element["REP_A_NTUR_WORK"] ?? "", eActivity: element["REP_E_NTUR_WORK"] ?? "", aAddress: element["REP_A_ADRS"] ?? "", eAddress: element['REP_E_ADRS'] ?? "", tel: element["REP_A_TEL"] ?? "", fax: element["REP_A_FAX"] ?? "", taxNo: element["TAX_NO"] ?? "", commercialReg: element['COMMERCIAL_REG'] ?? "");
    }
  }

  /*
SELECT  USER_CUS_GRP
  */

  //select  CASH_SLS_ACC , B_CASH_SLS_ACC,CRDT_SLS_ACC,B_CRDT_SLS_ACC  , DISC_SLS_ACC  , NET_ACC , CASH_ACC , BANK_ACC , ADDED_VALUE_ACC,HLL_ACC  from sls_center;

  Future<void> getAllPrivileges() async {
    //******************************************************* */
    //not currect method
    //best way to get the privileges as needed for each screen
    //******************************************************* */
    try {
      appLog += "START -------- GET_ACT_PRIVILEGES-------- \n";
      print("START -------- GET_ACT_PRIVILEGES--------");
      await _getActPrivileges();
      //
      appLog += "START -------- GET_SALES_Center_PRIVILEGES--------\n";
      print("START -------- GET_SALES_Center_PRIVILEGES--------");
      await _getSlsCntrPrivileges();
      //
      appLog += "START -------- GET_COST_Center_PRIVILEGES--------\n";
      print("START -------- GET_COST_Center_PRIVILEGES--------");
      await _getCstCntrPrivileges();
      //
      appLog += "START -------- GET_WHEREHOUSES_PRIVILEGES--------\n";
      print("START -------- GET_WHEREHOUSES_PRIVILEGES--------");
      await _getStWhPrivileges();
      //
      appLog += "START -------- GET_BRANCH_PRIVILEGES--------\n";
      print("START -------- GET_BRANCH_PRIVILEGES--------");
      await _getBranchPrivileges();
      //
      appLog += "START -------- GET_BANK_PRIVILEGES--------\n";
      print("START -------- GET_BANK_PRIVILEGES--------");
      await _getBankPrivileges();
      //
      appLog += "START -------- GET_ITEMS_DATA--------\n";
      print("START -------- GET_ITEMS_DATA---------");
      await _getItemsData();
      //
      appLog += "START -------- GET_CS_CLS_DATA--------\n";
      print("START -------- GET_CS_CLS_DATA---------");
      await _getCusClass();
      //
      appLog += "START -------- COMP_DATA--------\n";
      print("START -------- COMP_DATA---------");
      await _getCompData();
      //.
      // .
      appLog += "START -------- GET_CUSTOMERS_DATA--------\n";
      print("START -------- GET_CUSTOMERS_DATA--------");
      await _getCusData();
      // print("END ************************************");
      // debugPrint("************************************\n************************************\n************************************\n $appLog", wrapWidth: 1024);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void onInit() {
    loginController = Get.find<LoginController>();
    uId = loginController.logedInuserId ?? "";
    uName = loginController.logedInuserName ?? "";
    // print("XXXXXXXXXXXX   $uId   XXXXXXXXXXXX");
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
