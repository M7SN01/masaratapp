// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/login_controller.dart';
import '../Models/user_model.dart';
import '../Services/api_db_services.dart';
import '../Services/sqflite_services.dart';
// import '../Widget/widget.dart';
// import '../utils/utils.dart';

// import '../Variable/global_variable.dart';
// import '../Variable/global_variable.dart';

class UserController extends GetxController {
  // late LoginController loginController;

  // GlobalVariable globalVariable = GlobalVariable();
  final Services dbServices = Services();
  SqlDb sqldb = SqlDb();
  //--------------------------------------
  String uId = "";
  String uName = "";
  String uPass = "";
  String hasMoreThanRequiredPrivileges = "";
  String hasNoPrivileges = "";
  String appLog = "";

  String lastSyncDate = "";
  bool isOfflineMode = false;

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
      // globalVariable.setUserId = globalVariable.getErrorLog + hasMoreThanRequiredPrivileges;
    } else if (lst.isEmpty) {
      hasMoreThanRequiredPrivileges += "User $uId has No privilege On Any $tabel \n";
      appLog += "User $uId has No privilege On Any $tabel \n";
      // globalVariable.setUserId = globalVariable.getErrorLog + hasMoreThanRequiredPrivileges;
    }
  }

  Future<void> _getActPrivileges() async {
    try {
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

      actPrivList.clear();
      for (var element in response) {
        actPrivList.add(ActPrivModel(
          actId: element['ACT_ID'],
          actName: element['ACT_NAME'], /* chk: element['CHK'] == 1 ? true : false*/
        ));
      }

      //cheak if there any act not allowed for the user
      List<dynamic> userActIds = [int.parse('53$uId'), int.parse('57$uId'), 58, 59, 60, 61, 77, 99];
      Set<dynamic> presentActIds = actPrivList.map((e) => e.actId).toSet();
      for (var actId in userActIds) {
        if (!presentActIds.contains(actId)) {
          hasNoPrivileges += "User $uId has no privilege on ACT_ID $actId\n";
          appLog += "User $uId has no privilege on ACT_ID $actId\n";
          // globalVariable.setErrorLog = globalVariable.getErrorLog + hasNoPrivileges;
        }
      }

      if (actPrivList.isEmpty) {
        hasMoreThanRequiredPrivileges += "User $uId has No privilege On Any ACT  \n";
        appLog += "User $uId has No privilege On Any ACT  \n";
        // globalVariable.setUserId = globalVariable.getErrorLog + hasMoreThanRequiredPrivileges;
      }
    } catch (e) {
      appLog += "ERROR: => get Act Privileges {{=($e)=}}  \n";
    }
  }

  Future<void> _getCusData() async {
    try {
      var response = await dbServices.createRep(
        sqlStatment: """
      SELECT *  FROM CUSTOMERS WHERE CS_CLS_ID IN
      (SELECT CS_CLS_ID FROM USER_CUS_GRP WHERE U_ID='$uId' AND CHK = 1 
      )
      """,
        // where  1  = CHK_CUS_USR_PRV (CUS_ID ,${uId} )
      );

      cusDataList.clear();
      for (var element in response) {
        cusDataList.add(
          CusDataModel(
            cusId: element["CUS_ID"],
            cusName: element["CUS_NAME"],
            adrs: element["ADRS"] ?? "",
            mobl: element["MOBL"] ?? "",
            taxNo: element["TAX_NO"] ?? "",
            stoped: element["STOPED"] ?? 0,
            slsManId: element["SLS_MAN_ID"] ?? 0,
            latitude: element["LATITUDE"] ?? 0.0,
            longitude: element["LONGITUDE"] ?? 0.0,
            visitCnt: element["VISIT_CNT"] ?? 0,
            vatStatus: element['VAT_STATUS'] ?? 1,
          ),
        );
      }

      checkPrivileges(lst: cusDataList, tabel: "Customer", needOnlyOneRow: false);
    } catch (e) {
      appLog += "ERROR: => get Cus Data {{=($e)=}}  \n";
    }
  }

  Future<void> _getSlsCntrPrivileges() async {
    try {
      var response = await dbServices.createRep(
        sqlStatment: """
      SELECT a.*,(SELECT SLS_CNTR_NAME FROM SLS_CENTER WHERE SLS_CNTR_ID=a.SLS_CNTR_ID) AS SLS_CNTR_NAME 
      FROM 
      (
      SELECT SLS_CNTR_ID FROM USER_SLS_CENTER  WHERE U_ID='$uId' AND CHK = 1 
      ) a
      """,
      );

      slsCntrPrivList.clear();
      for (var element in response) {
        slsCntrPrivList.add(
          SlsCntrPrivModel(
            slsCntrID: element["SLS_CNTR_ID"],
            slsCntrName: element["SLS_CNTR_NAME"],
          ),
        );
      }

      checkPrivileges(lst: slsCntrPrivList, tabel: "Sales Center", needOnlyOneRow: true);
    } catch (e) {
      appLog += "ERROR: => get Sls Cntr Privileges {{=($e)=}}  \n";
    }
  }

  Future<void> _getCstCntrPrivileges() async {
    try {
      var response = await dbServices.createRep(
        sqlStatment: """
      SELECT a.*,(SELECT CST_A_NAME FROM COST_CENTERS WHERE CST_ID=a.CST_ID) AS CST_A_NAME 
      FROM 
      (
      SELECT CST_ID FROM USER_CC  WHERE U_ID='$uId' AND CHK = 1 
      ) a
      """,
      );
      cstCntrPrivList.clear();
      for (var element in response) {
        cstCntrPrivList.add(
          CstCntrPrivModel(
            cstCntrID: element["CST_ID"],
            cstCntrName: element["CST_A_NAME"],
          ),
        );
      }

      checkPrivileges(lst: cstCntrPrivList, tabel: "Cost center", needOnlyOneRow: true);
    } catch (e) {
      appLog += "ERROR: => get cost Cntr Privileges {{=($e)=}}  \n";
    }
  }

  Future<void> _getStWhPrivileges() async {
    try {
      var response = await dbServices.createRep(
        sqlStatment: """
      SELECT a.*,(SELECT WH_NAME FROM STWHOUSE WHERE WH_ID=a.WH_ID) AS WH_NAME 
      FROM 
      (
      SELECT WH_ID FROM USER_STWHOUSE  WHERE U_ID='$uId' AND CHK = 1 
      ) a
      """,
      );

      stWhPrivList.clear();
      for (var element in response) {
        stWhPrivList.add(
          StWhousesPrivModel(
            whID: element["WH_ID"],
            whName: element["WH_NAME"],
          ),
        );
      }

      checkPrivileges(lst: stWhPrivList, tabel: "WhereHouses", needOnlyOneRow: true);
    } catch (e) {
      appLog += "ERROR: => get StWhouse Privileges {{=($e)=}}  \n";
    }
  }

  Future<void> _getBranchPrivileges() async {
    try {
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

      branchPrivList.clear();
      for (var element in response) {
        branchPrivList.add(BranchPrivModel(brID: element["BR_ID"], brName: element["BR_NAME"]));
      }

      checkPrivileges(lst: slsCntrPrivList, tabel: "BRANCHES", needOnlyOneRow: true);
    } catch (e) {
      appLog += "ERROR: => get Branch Privileges {{=($e)=}}  \n";
    }
  }

  Future<void> _getBankPrivileges() async {
    try {
      var response = await dbServices.createRep(
        sqlStatment: """
      SELECT * FROM (
      SELECT BANK_ID , ACC_NAME,ACC_ID,BANK_OR_CASH,STOPED,CUR_ID FROM SH_BANKS_DTL 
      WHERE BANK_ID IN (SELECT BANK_ID FROM USER_BANKS WHERE U_ID='$uId' AND CHK=1 )      
      ) a
       WHERE a.ACC_ID IN(SELECT ACC_ID FROM USER_ACCOUNT b WHERE b.U_ID='$uId' AND b.CHK=1 )
      """,
      );

      bankPrivList.clear();
      for (var element in response) {
        bankPrivList.add(
          BankPrivModel(
            bankID: element["BANK_ID"],
            accName: element["ACC_NAME"] ?? "",
            accID: element["ACC_ID"] ?? "",
            bankOrCash: element["BANK_OR_CASH"] ?? 0,
            stoped: element["STOPED"] ?? 0,
            curId: element['CUR_ID'],
          ),
        );
      }

      checkPrivileges(lst: bankPrivList, tabel: "Bank / Account", needOnlyOneRow: true);
    } catch (e) {
      appLog += "ERROR: => get Bank Privileges {{=($e)=}}  \n";
    }
  }

  Future<void> _getItemsData() async {
    try {
      var response = await dbServices.createRep(
        sqlStatment: """
      SELECT ITEM_ID,BARCODE,ITEM_NAME,ROUND(PRICE1, 4) PRICE1 ,  ROUND(PRICE_AFTR_VAT,4) PRICE_AFTR_VAT, MAIN_UNIT FROM ITEMS aa  
     
      """,
        // WHERE ROWNUM <1000
      );
      //Curnt_bal
      //,(SELECT CURNT_BAL FROM ITEMS_WHOUSE bb WHERE bb.WH_ID ='${stWhPrivList[0].whID}' AND bb.ITEM_ID=aa.ITEM_ID) CURNT_BAL
      //multi wh
      // SELECT ITEM_ID,BARCODE,ITEM_NAME,PRICE_AFTR_VAT,CURNT_BAL, MAIN_UNIT FROM ITEMS_WHOUSE WHERE WH_ID IN (${stWhPrivList.map((e) => "'${e.whID}'").toList().join(',')})

      final requiredKeys = ["ITEM_ID", "BARCODE", "ITEM_NAME", "MAIN_UNIT", "PRICE1", "PRICE_AFTR_VAT"];
      itemsDataList.clear();
      for (var element in response) {
        final missing = requiredKeys.where((k) => element[k] == null || element[k] == 'Null').toList();

        if (missing.isNotEmpty) {
          appLog += "the item (${element["ITEM_ID"]}) without ${missing.join(", ")} \n";
          // debugPrint("the item (${element["ITEM_ID"]}) without ${missing.join(", ")} ");
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
      }
    } catch (e) {
      debugPrint(e.toString());
      appLog += "ERROR: => get Items Privileges {{=($e)=}}  \n";
    }
  }

  Future<void> _getCusClass() async {
    try {
      var response = await dbServices.createRep(
        sqlStatment: """
      SELECT *  FROM  CS_CLS WHERE CS_CLS_ID IN
      (SELECT CS_CLS_ID FROM USER_CUS_GRP WHERE U_ID='$uId' AND CHK = 1 
      )
      """,
      );
      csClsPrivList.clear();
      for (var element in response) {
        csClsPrivList.add(CsClsPrivModel(
          cSClsId: element["CS_CLS_ID"],
          cSClsName: element["CS_CLS_NAME"],
          accId: element["ACC_ID"],
          brId: element["BR_ID"].toString() == "null" ? "" : element["BR_ID"].toString(),
          curId: element["CUR_ID"],
        ));
      }

      checkPrivileges(lst: csClsPrivList, tabel: "CS_CLS", needOnlyOneRow: true);
    } catch (e) {
      appLog += "ERROR: => get Customer Class Privileges {{=($e)=}}  \n";
    }
  }

  //select  REP_A_COMP_NAME ,REP_E_COMP_NAME,REP_A_NTUR_WORK , REP_E_NTUR_WORK ,REP_A_ADRS ,REP_E_ADRS,REP_A_TEL,REP_A_FAX  ,TAX_NO ,COMMERCIAL_REG  from comp ;

  Future<void> _getCompData() async {
    try {
      var response = await dbServices.createRep(
        sqlStatment: """
      select  REP_A_COMP_NAME ,REP_E_COMP_NAME,REP_A_NTUR_WORK , REP_E_NTUR_WORK ,REP_A_ADRS ,REP_E_ADRS,REP_A_TEL,REP_A_FAX  
      ,TAX_NO ,COMMERCIAL_REG  from comp
      """,
      );

      for (var element in response) {
        compData = CompData(
          aCompName: element["REP_A_COMP_NAME"] ?? "",
          eCompName: element["REP_E_COMP_NAME"] ?? "",
          aActivity: element["REP_A_NTUR_WORK"] ?? "",
          eActivity: element["REP_E_NTUR_WORK"] ?? "",
          aAddress: element["REP_A_ADRS"] ?? "",
          eAddress: element['REP_E_ADRS'] ?? "",
          tel: element["REP_A_TEL"] ?? "",
          fax: element["REP_A_FAX"] ?? "",
          taxNo: element["TAX_NO"] ?? "",
          commercialReg: element['COMMERCIAL_REG'] ?? "",
        );
      }
    } catch (e) {
      appLog += "ERROR: => get Comp  Data {{=($e)=}}  \n";
    }
  }

  Future<void> getAllPrivileges() async {
    //******************************************************* */
    //not currect method
    //best way to get the privileges as needed for each screen
    //******************************************************* */

    appLog += "START -------- GET_ACT_PRIVILEGES-------- \n";
    debugPrint("START -------- GET_ACT_PRIVILEGES--------");
    await _getActPrivileges();
    //
    appLog += "START -------- GET_SALES_Center_PRIVILEGES--------\n";
    debugPrint("START -------- GET_SALES_Center_PRIVILEGES--------");
    await _getSlsCntrPrivileges();
    //
    appLog += "START -------- GET_COST_Center_PRIVILEGES--------\n";
    debugPrint("START -------- GET_COST_Center_PRIVILEGES--------");
    await _getCstCntrPrivileges();
    //
    appLog += "START -------- GET_WHEREHOUSES_PRIVILEGES--------\n";
    debugPrint("START -------- GET_WHEREHOUSES_PRIVILEGES--------");
    await _getStWhPrivileges();
    //
    appLog += "START -------- GET_BRANCH_PRIVILEGES--------\n";
    debugPrint("START -------- GET_BRANCH_PRIVILEGES--------");
    await _getBranchPrivileges();
    //
    appLog += "START -------- GET_BANK_PRIVILEGES--------\n";
    debugPrint("START -------- GET_BANK_PRIVILEGES--------");
    await _getBankPrivileges();
    //
    appLog += "START -------- GET_ITEMS_DATA--------\n";
    debugPrint("START -------- GET_ITEMS_DATA---------");
    await _getItemsData();
    //
    appLog += "START -------- GET_CS_CLS_DATA--------\n";
    debugPrint("START -------- GET_CS_CLS_DATA---------");
    await _getCusClass();
    //
    appLog += "START -------- COMP_DATA--------\n";
    debugPrint("START -------- COMP_DATA---------");
    await _getCompData();
    //.
    // .
    appLog += "START -------- GET_CUSTOMERS_DATA--------\n";
    debugPrint("START -------- GET_CUSTOMERS_DATA--------");
    await _getCusData();
    // debugPrint("END ************************************");
    // debugPrint("************************************\n************************************\n************************************\n $appLog", wrapWidth: 1024);
  }

  @override
  void onInit() {
    LoginController loginController = Get.find<LoginController>();
    uId = loginController.logedInuserId ?? "";
    uName = loginController.logedInuserName ?? "";
    uPass = loginController.logedInPassword ?? "";
    isOfflineMode = loginController.isOfflineMode;
    // debugPrint("XXXXXXXXXXXX   $uId   XXXXXXXXXXXX");
    super.onInit();
  }
}


//OLD Offilne methodes

/*

//-------------------------OFFLINE MODE ----------------
//-------------------------OFFLINE MODE ----------------
//-------------------------OFFLINE MODE ----------------
//-------------------------OFFLINE MODE ----------------
//-------------------------OFFLINE MODE ----------------
//-------------------------OFFLINE MODE ----------------

  // double loadingProgress = 0.0;
  // bool isLoading = false;

//---------------------------SET OFFLINE DATA----------------------------------
/*
  Future<ReturnedResponse> deleteOldOfflineDataTable({required String tableName}) async {
    try {
      await sqldb.deleteTable(tableName: tableName);
      return ReturnedResponse.done;
    } catch (e) {
      debugPrint(e.toString());
      showMessage(
        color: secondaryColor,
        titleMsg: "Failed to delete $tableName Table !",
        msg: e.toString(),
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return ReturnedResponse.error;
    }
  }

  Future<ReturnedResponse> _setOfflineActPrivileges() async {
    //delete all the old date
    ReturnedResponse result = await deleteOldOfflineDataTable(tableName: "ACT_TYPE");
    if (result == ReturnedResponse.error) {
      return ReturnedResponse.error; //stop the process if error
    }
    //insert all new data
    try {
      actPrivList;
      for (var act in actPrivList) {
        await sqldb.insertData("INSERT INTO ACT_TYPE(ACT_ID,ACT_NAME) VALUES(${act.actId},'${act.actName}')");
      }
      return ReturnedResponse.done;
    } catch (e) {
      debugPrint(e.toString());
      showMessage(
        color: secondaryColor,
        titleMsg: "Failed to insert data to ACT_TYPE Table !",
        msg: e.toString(),
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return ReturnedResponse.error;
    }
  }

  Future<ReturnedResponse> _setOfflineUserData() async {
    //delete all the old date
    ReturnedResponse result = await deleteOldOfflineDataTable(tableName: "USER");
    if (result == ReturnedResponse.error) {
      return ReturnedResponse.error; //stop the process if error
    }
    //insert all new data
    try {
      await sqldb.insertData("INSERT INTO USER(U_ID,U_NAME,U_P) VALUES('$uId','$uName','$uPass')");

      return ReturnedResponse.done;
    } catch (e) {
      debugPrint(e.toString());
      showMessage(
        color: secondaryColor,
        titleMsg: "Failed to insert data to ACT_TYPE Table !",
        msg: e.toString(),
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return ReturnedResponse.error;
    }
  }

  Future<ReturnedResponse> _setOfflineCusData() async {
    //delete all the old date
    ReturnedResponse result = await deleteOldOfflineDataTable(tableName: "CUSTOMERS");
    if (result == ReturnedResponse.error) {
      return ReturnedResponse.error; //stop the process if error
    }
    //insert all new data
    try {
      for (var cus in cusDataList) {
        await sqldb.insertData("""INSERT INTO 
        CUSTOMERS(CUS_ID,CUS_NAME ,ADRS ,MOBL ,TAX_NO ,STOPED ,SLS_MAN_ID ,LATITUDE ,LONGITUDE ,VISIT_CNT ,VAT_STATUS 
      ) VALUES(${cus.cusId},'${cus.cusName}','${cus.adrs}','${cus.mobl}','${cus.taxNo}',${cus.stoped},${cus.slsManId},
                ${cus.latitude},${cus.longitude},${cus.visitCnt},${cus.vatStatus}
      )
      """);
      }
      return ReturnedResponse.done;
    } catch (e) {
      debugPrint(e.toString());
      showMessage(
        color: secondaryColor,
        titleMsg: "Failed to insert data to CUSTOMERS Table !",
        msg: e.toString(),
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return ReturnedResponse.error;
    }
  }

  Future<ReturnedResponse> _setSlsCntrPrivileges() async {
    //delete all the old date
    ReturnedResponse result = await deleteOldOfflineDataTable(tableName: "SLS_CENTER");
    if (result == ReturnedResponse.error) {
      return ReturnedResponse.error; //stop the process if error
    }
    //insert all new data
    try {
      for (var slsCntr in slsCntrPrivList) {
        await sqldb.insertData("INSERT INTO SLS_CENTER(SLS_CNTR_ID,SLS_CNTR_NAME) VALUES(${slsCntr.slsCntrID},'${slsCntr.slsCntrName}')");
      }
      return ReturnedResponse.done;
    } catch (e) {
      debugPrint(e.toString());
      showMessage(
        color: secondaryColor,
        titleMsg: "Failed to insert data to SLS_CENTER Table !",
        msg: e.toString(),
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return ReturnedResponse.error;
    }
  }

  Future<ReturnedResponse> _setCstPrivileges() async {
    //delete all the old date
    ReturnedResponse result = await deleteOldOfflineDataTable(tableName: "COST_CENTERS");
    if (result == ReturnedResponse.error) {
      return ReturnedResponse.error; //stop the process if error
    }
    //insert all new data
    try {
      for (var cst in cstCntrPrivList) {
        await sqldb.insertData("INSERT INTO COST_CENTERS(CST_ID,CST_A_NAME) VALUES(${cst.cstCntrID},'${cst.cstCntrName}')");
      }
      return ReturnedResponse.done;
    } catch (e) {
      debugPrint(e.toString());
      showMessage(
        color: secondaryColor,
        titleMsg: "Failed to insert data to COST_CENTERS Table !",
        msg: e.toString(),
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return ReturnedResponse.error;
    }
  }

  Future<ReturnedResponse> _setstwhousePrivileges() async {
    //delete all the old date
    ReturnedResponse result = await deleteOldOfflineDataTable(tableName: "STWHOUSE");
    if (result == ReturnedResponse.error) {
      return ReturnedResponse.error; //stop the process if error
    }
    //insert all new data
    try {
      for (var stWh in stWhPrivList) {
        await sqldb.insertData("INSERT INTO STWHOUSE(WH_ID,WH_NAME) VALUES(${stWh.whID},'${stWh.whName}')");
      }
      return ReturnedResponse.done;
    } catch (e) {
      debugPrint(e.toString());
      showMessage(
        color: secondaryColor,
        titleMsg: "Failed to insert data to STWHOUSE Table !",
        msg: e.toString(),
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return ReturnedResponse.error;
    }
  }

  Future<ReturnedResponse> _setBranchPrivileges() async {
    //delete all the old date
    ReturnedResponse result = await deleteOldOfflineDataTable(tableName: "BRANCH");
    if (result == ReturnedResponse.error) {
      return ReturnedResponse.error; //stop the process if error
    }
    //insert all new data
    try {
      for (var branch in branchPrivList) {
        await sqldb.insertData("INSERT INTO BRANCH(BR_ID,BR_NAME) VALUES(${branch.brID},'${branch.brName}')");
      }
      return ReturnedResponse.done;
    } catch (e) {
      debugPrint(e.toString());
      showMessage(
        color: secondaryColor,
        titleMsg: "Failed to insert data to BRANCH Table !",
        msg: e.toString(),
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return ReturnedResponse.error;
    }
  }

  Future<ReturnedResponse> _setBankPrivileges() async {
    //delete all the old date
    ReturnedResponse result = await deleteOldOfflineDataTable(tableName: "SH_BANKS_DTL");
    if (result == ReturnedResponse.error) {
      return ReturnedResponse.error; //stop the process if error
    }
    //insert all new data
    try {
      for (var bank in bankPrivList) {
        await sqldb.insertData(
          "INSERT INTO SH_BANKS_DTL(BANK_ID,ACC_NAME,ACC_ID,BANK_OR_CASH,STOPED,CUR_ID) VALUES('${bank.bankID}','${bank.accName}','${bank.accID}',${bank.bankOrCash},${bank.stoped},'${bank.curId}')",
        );
      }
      return ReturnedResponse.done;
    } catch (e) {
      debugPrint(e.toString());
      showMessage(
        color: secondaryColor,
        titleMsg: "Failed to insert data to SH_BANKS_DTL Table !",
        msg: e.toString(),
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return ReturnedResponse.error;
    }
  }

  Future<ReturnedResponse> _setItemsData() async {
    //delete all the old date
    ReturnedResponse result = await deleteOldOfflineDataTable(tableName: "ITEMS");
    if (result == ReturnedResponse.error) {
      return ReturnedResponse.error; //stop the process if error
    }
    //insert all new data
    try {
      for (var item in itemsDataList) {
        await sqldb.insertData(
          "INSERT INTO ITEMS(ITEM_ID,BARCODE,ITEM_NAME,MAIN_UNIT,PRICE1,PRICE_AFTR_VAT,CURNT_BAL) VALUES('${item.itemId}','${item.barcode}','${item.itemName}','${item.unit}',${item.price1},${item.priceAftrVat},${item.currentBal})",
        );
      }
      return ReturnedResponse.done;
    } catch (e) {
      debugPrint(e.toString());
      showMessage(
        color: secondaryColor,
        titleMsg: "Failed to insert data to ITEMS Table !",
        msg: e.toString(),
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return ReturnedResponse.error;
    }
  }

  Future<ReturnedResponse> _setCsClsPrivileges() async {
    //delete all the old date
    ReturnedResponse result = await deleteOldOfflineDataTable(tableName: "CS_CLS");
    if (result == ReturnedResponse.error) {
      return ReturnedResponse.error; //stop the process if error
    }
    //insert all new data
    try {
      for (var csCls in csClsPrivList) {
        await sqldb.insertData("INSERT INTO CS_CLS(CS_CLS_ID,CS_CLS_NAME,ACC_ID,BR_ID,CUR_ID) VALUES(${csCls.cSClsId},'${csCls.cSClsName}','${csCls.accId}','${csCls.brId}','${csCls.curId}')");
      }
      return ReturnedResponse.done;
    } catch (e) {
      debugPrint(e.toString());
      showMessage(
        color: secondaryColor,
        titleMsg: "Failed to insert data to CS_CLS Table !",
        msg: e.toString(),
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return ReturnedResponse.error;
    }
  }

  Future<ReturnedResponse> _setCompData() async {
    //delete all the old date
    ReturnedResponse result = await deleteOldOfflineDataTable(tableName: "COMP");
    if (result == ReturnedResponse.error) {
      return ReturnedResponse.error; //stop the process if error
    }
    //insert all new data
    try {
      await sqldb.insertData(
        "INSERT INTO COMP(REP_A_COMP_NAME,REP_E_COMP_NAME,REP_A_NTUR_WORK,REP_E_NTUR_WORK,REP_A_ADRS,REP_E_ADRS,REP_A_TEL,REP_A_FAX,TAX_NO,COMMERCIAL_REG) VALUES('${compData.aCompName}','${compData.eCompName}','${compData.aActivity}','${compData.eActivity}','${compData.aAddress}','${compData.eAddress}','${compData.tel}','${compData.fax}','${compData.taxNo}','${compData.commercialReg}')",
      );
      return ReturnedResponse.done;
    } catch (e) {
      debugPrint(e.toString());
      showMessage(
        color: secondaryColor,
        titleMsg: "Failed to insert data to COMP Table !",
        msg: e.toString(),
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return ReturnedResponse.error;
    }
  }

  Future<ReturnedResponse> _updateLastSyncDate() async {
    try {
      await sqldb.updateData("UPDATE COMP SET HAS_OFFLINE_DATA = 1, LAST_OFFLINE_SYNC = '${DateTime.now().toIso8601String()}' ");
      return ReturnedResponse.done;
    } catch (e) {
      debugPrint(e.toString());
      showMessage(
        color: secondaryColor,
        titleMsg: "Failed to update last sync date !",
        msg: e.toString(),
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return ReturnedResponse.error;
    }
  }

  Future<void> setNewOfflineData() async {
    // ReturnedResponse result;
    // result = await _setOfflineActPrivileges();
    // if (result == ReturnedResponse.done) result = await _setOfflineCusData();
    // if (result == ReturnedResponse.done) result = await _setSlsCntrPrivileges();
    // if (result == ReturnedResponse.done) result = await _setCstPrivileges();
    // if (result == ReturnedResponse.done) result = await _setstwhousePrivileges();
    // if (result == ReturnedResponse.done) result = await _setBranchPrivileges();
    // if (result == ReturnedResponse.done) result = await _setBankPrivileges();
    // if (result == ReturnedResponse.done) result = await _setItemsData();
    // if (result == ReturnedResponse.done) result = await _setCsClsPrivileges();
    // if (result == ReturnedResponse.done) result = await _setCompData();
    // if (result == ReturnedResponse.done) result = await _updateLastSyncDate();

    isLoading = true;
    loadingProgress = 0.0;
    update();

    final List<Future<ReturnedResponse> Function()> tasks = [
      _setOfflineUserData,
      _setOfflineActPrivileges,
      _setOfflineCusData,
      _setSlsCntrPrivileges,
      _setCstPrivileges,
      _setstwhousePrivileges,
      _setBranchPrivileges,
      _setBankPrivileges,
      _setItemsData,
      _setCsClsPrivileges,
      _setCompData,
      _updateLastSyncDate,
    ];

    int total = tasks.length;
    for (int i = 0; i < total; i++) {
      final result = await tasks[i]();
      // print(i);
      if (result != ReturnedResponse.done) break;

      // Animate progress even if task takes time
      for (int p = 1; p <= 5; p++) {
        await Future.delayed(Duration(milliseconds: 50));
        loadingProgress = ((i + p / 5) / total).clamp(0.0, 1.0);
        update();
      }
    }

    isLoading = false;
    update();
  }

//---------------------------END SET OFFLINE DATA----------------------------------
//******************************************************************************
//---------------------------GET OFFLINE DATA----------------------------------

  Future<ReturnedResponse> _getOfflineActPrivileges() async {
    var result = await sqldb.readData("SELECT * FROM ACT_TYPE");
    if (result.isEmpty) {
      showMessage(
        color: secondaryColor,
        titleMsg: "No data found in ACT_TYPE Table !",
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return ReturnedResponse.error;
    } else {
      actPrivList.clear();
      for (var act in result) {
        actPrivList.add(ActPrivModel(actId: act['ACT_ID'], actName: act['ACT_NAME']));
      }
      return ReturnedResponse.done;
    }
  }

  Future<ReturnedResponse> _getOfflineCusData() async {
    var result = await sqldb.readData("SELECT * FROM CUSTOMERS");
    if (result.isEmpty) {
      showMessage(
        color: secondaryColor,
        titleMsg: "No data found in CUSTOMERS Table !",
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return ReturnedResponse.error;
    } else {
      cusDataList.clear();
      for (var cus in result) {
        cusDataList.add(
          CusDataModel(
            cusId: cus['CUS_ID'],
            cusName: cus['CUS_NAME'],
            adrs: cus['ADRS'],
            mobl: cus['MOBL'],
            taxNo: cus['TAX_NO'],
            stoped: cus['STOPED'] ?? 0,
            slsManId: cus['SLS_MAN_ID'] ?? 0,
            latitude: cus['LATITUDE'] ?? 0.0,
            longitude: cus['LONGITUDE'] ?? 0.0,
            visitCnt: cus['VISIT_CNT'] ?? 0,
            vatStatus: cus['VAT_STATUS'] ?? 1,
          ),
        );
      }
      return ReturnedResponse.done;
    }
  }

  Future<ReturnedResponse> _getOfflineSlsCntrPrivileges() async {
    var result = await sqldb.readData("SELECT * FROM SLS_CENTER");
    if (result.isEmpty) {
      showMessage(
        color: secondaryColor,
        titleMsg: "No data found in SLS_CENTER Table !",
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return ReturnedResponse.error;
    } else {
      slsCntrPrivList.clear();
      for (var slsCntr in result) {
        slsCntrPrivList.add(SlsCntrPrivModel(slsCntrID: slsCntr['SLS_CNTR_ID'], slsCntrName: slsCntr['SLS_CNTR_NAME']));
      }
      return ReturnedResponse.done;
    }
  }

  Future<ReturnedResponse> _getOfflineCstPrivileges() async {
    var result = await sqldb.readData("SELECT * FROM COST_CENTERS");
    if (result.isEmpty) {
      showMessage(
        color: secondaryColor,
        titleMsg: "No data found in COST_CENTERS Table !",
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return ReturnedResponse.error;
    } else {
      cstCntrPrivList.clear();
      for (var cst in result) {
        cstCntrPrivList.add(CstCntrPrivModel(cstCntrID: cst['CST_ID'], cstCntrName: cst['CST_A_NAME']));
      }
      return ReturnedResponse.done;
    }
  }

  Future<ReturnedResponse> _getOfflinestwhousePrivileges() async {
    var result = await sqldb.readData("SELECT * FROM STWHOUSE");
    if (result.isEmpty) {
      showMessage(
        color: secondaryColor,
        titleMsg: "No data found in STWHOUSE Table !",
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return ReturnedResponse.error;
    } else {
      stWhPrivList.clear();
      for (var stWh in result) {
        stWhPrivList.add(StWhousesPrivModel(whID: stWh['WH_ID'], whName: stWh['WH_NAME']));
      }
      return ReturnedResponse.done;
    }
  }

  Future<ReturnedResponse> _getOfflineBranchPrivileges() async {
    var result = await sqldb.readData("SELECT * FROM BRANCH");
    if (result.isEmpty) {
      showMessage(
        color: secondaryColor,
        titleMsg: "No data found in BRANCH Table !",
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return ReturnedResponse.error;
    } else {
      branchPrivList.clear();
      for (var branch in result) {
        branchPrivList.add(BranchPrivModel(brID: branch['BR_ID'], brName: branch['BR_NAME']));
      }
      return ReturnedResponse.done;
    }
  }

  Future<ReturnedResponse> _getOfflineBankPrivileges() async {
    var result = await sqldb.readData("SELECT * FROM SH_BANKS_DTL");
    if (result.isEmpty) {
      showMessage(
        color: secondaryColor,
        titleMsg: "No data found in SH_BANKS_DTL Table !",
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return ReturnedResponse.error;
    } else {
      bankPrivList.clear();
      for (var bank in result) {
        bankPrivList.add(
          BankPrivModel(
            bankID: bank['BANK_ID'],
            accName: bank['ACC_NAME'] ?? "",
            accID: bank['ACC_ID'] ?? "",
            bankOrCash: bank['BANK_OR_CASH'] ?? 0,
            stoped: bank['STOPED'] ?? 0,
            curId: bank['CUR_ID'] ?? "",
          ),
        );
      }
      return ReturnedResponse.done;
    }
  }

  Future<ReturnedResponse> _getOfflineItemsData() async {
    var result = await sqldb.readData("SELECT * FROM ITEMS");
    if (result.isEmpty) {
      showMessage(
        color: secondaryColor,
        titleMsg: "No data found in ITEMS Table !",
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return ReturnedResponse.error;
    } else {
      itemsDataList.clear();
      for (var item in result) {
        itemsDataList.add(
          ItemsDataModel(
            itemId: item['ITEM_ID'],
            barcode: item['BARCODE'] ?? "",
            itemName: item['ITEM_NAME'] ?? "",
            unit: item['MAIN_UNIT'] ?? "",
            price1: item['PRICE1'],
            priceAftrVat: item['PRICE_AFTR_VAT'],
            currentBal: item['CURNT_BAL'],
          ),
        );
      }
      return ReturnedResponse.done;
    }
  }

  Future<ReturnedResponse> _getOfflineCsClsPrivileges() async {
    var result = await sqldb.readData("SELECT * FROM CS_CLS");
    if (result.isEmpty) {
      showMessage(
        color: secondaryColor,
        titleMsg: "No data found in CS_CLS Table !",
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return ReturnedResponse.error;
    } else {
      csClsPrivList.clear();
      for (var csCls in result) {
        csClsPrivList.add(
          CsClsPrivModel(
            cSClsId: csCls['CS_CLS_ID'],
            cSClsName: csCls['CS_CLS_NAME'] ?? "",
            accId: csCls['ACC_ID'] ?? "",
            brId: csCls['BR_ID'] ?? "",
            curId: csCls['CUR_ID'] ?? "",
          ),
        );
      }
      return ReturnedResponse.done;
    }
  }

  Future<ReturnedResponse> _getOfflineCompData() async {
    var result = await sqldb.readData("SELECT * FROM COMP");
    if (result.isEmpty) {
      showMessage(
        color: secondaryColor,
        titleMsg: "No data found in COMP Table !",
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return ReturnedResponse.error;
    } else {
      compData = CompData(
        aCompName: result[0]['REP_A_COMP_NAME'] ?? "",
        eCompName: result[0]['REP_E_COMP_NAME'] ?? "",
        aActivity: result[0]['REP_A_NTUR_WORK'] ?? "",
        eActivity: result[0]['REP_E_NTUR_WORK'] ?? "",
        aAddress: result[0]['REP_A_ADRS'] ?? "",
        eAddress: result[0]['REP_E_ADRS'] ?? "",
        tel: result[0]['REP_A_TEL'] ?? "",
        fax: result[0]['REP_A_FAX'] ?? "",
        taxNo: result[0]['TAX_NO'] ?? "",
        commercialReg: result[0]['COMMERCIAL_REG'] ?? "",
      );
      return ReturnedResponse.done;
    }
  }

/*
  Future<ReturnedResponse> getLastSyncDate() async {
    var result = await sqldb.readData("SELECT LAST_OFFLINE_SYNC FROM COMP WHERE HAS_OFFLINE_DATA = 1");
    if (result.isEmpty) {
      showMessage(
        color: secondaryColor,
        titleMsg: "No data found in USER Table !",
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return ReturnedResponse.error;
    } else {
      lastSyncDate = result[0]['LAST_OFFLINE_SYNC'];
      return ReturnedResponse.done;
    }
  }
*/
/*
  Future<void> getAllOfflineData() async {
    ReturnedResponse result;
    //
    appLog += "START -------- GET_ACT_PRIVILEGES-------- \n";
    debugPrint("START -------- GET_ACT_PRIVILEGES--------");
    result = await _getOfflineActPrivileges();
    //
    appLog += "START -------- GET_SALES_Center_PRIVILEGES--------\n";
    debugPrint("START -------- GET_SALES_Center_PRIVILEGES--------");
    if (result == ReturnedResponse.done) result = await _getOfflineSlsCntrPrivileges();
    //
    appLog += "START -------- GET_COST_Center_PRIVILEGES--------\n";
    debugPrint("START -------- GET_COST_Center_PRIVILEGES--------");
    if (result == ReturnedResponse.done) result = await _getOfflineCstPrivileges();
    //
    appLog += "START -------- GET_WHEREHOUSES_PRIVILEGES--------\n";
    debugPrint("START -------- GET_WHEREHOUSES_PRIVILEGES--------");
    if (result == ReturnedResponse.done) result = await _getOfflinestwhousePrivileges();
    //
    appLog += "START -------- GET_BRANCH_PRIVILEGES--------\n";
    debugPrint("START -------- GET_BRANCH_PRIVILEGES--------");
    if (result == ReturnedResponse.done) result = await _getOfflineBranchPrivileges();
    //
    appLog += "START -------- GET_BANK_PRIVILEGES--------\n";
    debugPrint("START -------- GET_BANK_PRIVILEGES--------");
    if (result == ReturnedResponse.done) result = await _getOfflineBankPrivileges();
    //
    appLog += "START -------- GET_ITEMS_DATA--------\n";
    debugPrint("START -------- GET_ITEMS_DATA---------");
    if (result == ReturnedResponse.done) result = await _getOfflineItemsData();
    //
    appLog += "START -------- GET_CS_CLS_DATA--------\n";
    debugPrint("START -------- GET_CS_CLS_DATA---------");
    if (result == ReturnedResponse.done) result = await _getOfflineCsClsPrivileges();
    //
    appLog += "START -------- COMP_DATA--------\n";
    debugPrint("START -------- COMP_DATA---------");
    if (result == ReturnedResponse.done) result = await _getOfflineCompData();
    appLog += "START -------- GET_CUSTOMERS_DATA--------\n";
    debugPrint("START -------- GET_CUSTOMERS_DATA--------");
    if (result == ReturnedResponse.done) result = await _getOfflineCusData();

    update();
  }
*/
//---------------------------END GET OFFLINE DATA----------------------------------
*/
*/
// }

// enum ReturnedResponse {
//   done,
//   error,
// }

*/