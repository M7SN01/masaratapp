import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:masaratapp/App/Controllers/user_controller.dart';
// import 'package:masaratapp/App/Services/api_db_services.dart';
// import 'package:masaratapp/App/Services/sqflite_services.dart';
import 'package:sqflite/sqflite.dart';
import '../Models/user_model.dart';
import '../Widget/widget.dart';
import '../utils/utils.dart';
// import 'login_controller.dart';

class OfflineUserController extends UserController {
  // SqlDb sqldb = SqlDb();
  // late UserController userController;
  // bool isOfflineMode = false;

  double loadingProgress = 0.0;
  bool isLoading = false;

  @override
  void onInit() {
    // LoginController loginController = Get.find<LoginController>();
    // isOfflineMode = loginController.isOfflineMode;
    super.onInit();
  }

//---------------------------SET OFFLINE DATA----------------------------------
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

  Future<ReturnedResponse> _setOfflineUserData() async {
    //delete all the old date
    ReturnedResponse result = await deleteOldOfflineDataTable(tableName: "USER");
    if (result == ReturnedResponse.error) {
      return ReturnedResponse.error; //stop the process if error
    }
    //insert all new data
    try {
      await sqldb.insertData("INSERT INTO USER(U_ID,U_NAME,U_P) VALUES('${uId}','${uName}','${uPass}')");

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

  Future<ReturnedResponse> _setOfflineActPrivileges() async {
    //delete all the old date
    ReturnedResponse result = await deleteOldOfflineDataTable(tableName: "ACT_TYPE");
    if (result == ReturnedResponse.error) {
      return ReturnedResponse.error; //stop the process if error
    }
    //insert all new data
    try {
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

  Future<ReturnedResponse> _getActPrivileges() async {
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

  Future<ReturnedResponse> _getCusData() async {
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

  Future<ReturnedResponse> _getSlsCntrPrivileges() async {
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

  Future<ReturnedResponse> _getCstPrivileges() async {
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

  Future<ReturnedResponse> _getstwhousePrivileges() async {
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

  Future<ReturnedResponse> _getBranchPrivileges() async {
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

  Future<ReturnedResponse> _getBankPrivileges() async {
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

  Future<ReturnedResponse> _getItemsData() async {
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

  Future<ReturnedResponse> _getCsClsPrivileges() async {
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

  Future<ReturnedResponse> _getCompData() async {
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

  Future<void> getAllOfflineData() async {
    ReturnedResponse result;
    //get all the data from sqflite
    result = await _getActPrivileges();
    if (result == ReturnedResponse.done) result = await _getCusData();
    if (result == ReturnedResponse.done) result = await _getSlsCntrPrivileges();
    if (result == ReturnedResponse.done) result = await _getCstPrivileges();
    if (result == ReturnedResponse.done) result = await _getstwhousePrivileges();
    if (result == ReturnedResponse.done) result = await _getBranchPrivileges();
    if (result == ReturnedResponse.done) result = await _getBankPrivileges();
    if (result == ReturnedResponse.done) result = await _getItemsData();
    if (result == ReturnedResponse.done) result = await _getCsClsPrivileges();
    if (result == ReturnedResponse.done) result = await _getCompData();

    //update the controller
    update();
  }

  Future<void> printAllSqfliteTableNames() async {
    try {
      final List<Map<String, dynamic>> tables = await sqldb.readData(" SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';");
      for (var table in tables) {
        print('Table: ${table['name']}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
//---------------------------END GET OFFLINE DATA----------------------------------

//---------------------------START SANADAT SYNC  ----------------------------------

  Future<void> serverToLocalSanadatData() async {
    // Services dbServices = Services();
    var sanadatActs = actPrivList.where((e) => [int.parse("53$uId"), int.parse("57$uId")].contains(e.actId)).toList();
    String stmt = """
        SELECT ACC_TYPE,ACC_HD_ID,TO_CHAR(DATE1,'yyyy-mm-dd') DATE1 ,BR_ID,CUR_ID,ROUND(TTL,2) TTL,DSCR,TRHEL,RDY,SYS_TYPE,BRNCH_ACT,EXCHNG_PR,USR_INS,USR_INS_DATE,SCRN_SRC
        FROM ACC_HD 
        WHERE 
        ACC_TYPE IN (${sanadatActs.map((act) => act.actId).join(',')})
      """;
    var sanadHDResponse = await dbServices.createRep(sqlStatment: stmt);
    // print(stmt);
    debugPrint(sanadHDResponse.toString());

    //delete all the old date
    ReturnedResponse result = await deleteOldOfflineDataTable(tableName: "ACC_DT");
    if (result == ReturnedResponse.done) {
      debugPrint("DELETE ACC_DT COMPLETED ......................");
      // return ReturnedResponse.error; //stop the process if error
    } else {
      debugPrint("DELETE ACC_DT NOT COMPLETED ......................");
    }
    result = await deleteOldOfflineDataTable(tableName: "ACC_HD");
    if (result == ReturnedResponse.done) {
      debugPrint("DELETE ACC_HD COMPLETED ......................");
      // return ReturnedResponse.error; //stop the process if error
    } else {
      debugPrint("DELETE ACC_HD NOT COMPLETED ......................");
    }

    try {
      Database? mydb = await sqldb.db;

      // 2. one shot execuet
      var response = await mydb!.transaction((txn) async {
        for (var rowDataHD in sanadHDResponse) {
          //Header
          await txn.rawInsert('''
            INSERT INTO ACC_HD(ACC_TYPE, ACC_HD_ID, DATE1, CUR_ID, TTL, DSCR, TRHEL, RDY, SYS_TYPE, BRNCH_ACT,
            EXCHNG_PR, USR_INS, USR_INS_DATE, SCRN_SRC,SYNC , BR_ID)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,? , ?)
            ''', [
            rowDataHD['ACC_TYPE'],
            rowDataHD['ACC_HD_ID'],
            rowDataHD['DATE1'], //
            rowDataHD['CUR_ID'], //  csClsPrivList[0].curId,
            rowDataHD['TTL'], //amount.text,
            rowDataHD['DSCR'], //description.text,
            rowDataHD['TRHEL'], //0,
            rowDataHD['RDY'], //1,
            rowDataHD['SYS_TYPE'], //'نظام العملاء',
            rowDataHD['BRNCH_ACT'], //0,
            rowDataHD['EXCHNG_PR'], //1,
            rowDataHD['USR_INS'], //userId,
            rowDataHD['USR_INS_DATE'], //DateFormat('MM/dd/yyyy HH:mm:ss').format(DateTime.now()),
            rowDataHD['SCRN_SRC'], //'CUS_HD_DT',
            1, //SYNC
            rowDataHD['BR_ID'], //if (csClsPrivList[0].brId != "") csClsPrivList[0].brId,
          ]);

          debugPrint("INSERT HEADER  ${rowDataHD['ACC_TYPE']} ===  ${rowDataHD['ACC_HD_ID']} +++++++++++++++++++++++");

          //Detaile----------------------------------------------------------------------------------------------------
          stmt = """
                SELECT CUS_ID,BANK_ID, ACC_TYPE, ACC_HD_ID, ACC_ID, CUR_ID, STATE, AMNT, DSCR, CST_ID, SRL
                FROM ACC_DT 
                WHERE 
                ACC_TYPE = ${rowDataHD['ACC_TYPE']} AND ACC_HD_ID=${rowDataHD['ACC_HD_ID']}
              """;
          final sanadDTResponse = await dbServices.createRep(sqlStatment: stmt);

          for (var rowDataDT in sanadDTResponse) {
            await txn.rawInsert('''
            INSERT INTO ACC_DT(CUS_ID,BANK_ID, ACC_TYPE, ACC_HD_ID, ACC_ID, CUR_ID, STATE, AMNT, DSCR, CST_ID, SRL,BR_ID)
            VALUES (?,?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)
            ''', [
              rowDataDT['CUS_ID'], //      selecetdCustomer!.cusId,
              rowDataDT['BANK_ID'], //BANK_ID
              rowDataDT['ACC_TYPE'], //selectedSanadTypeId,
              rowDataDT['ACC_HD_ID'], //lastSerial,
              rowDataDT['ACC_ID'], //csClsPrivList[0].accId,
              rowDataDT['CUR_ID'], //csClsPrivList[0].curId,
              rowDataDT['STATE'], //1,
              rowDataDT['AMNT'], //amount.text,
              rowDataDT['DSCR'], //description.text,
              rowDataDT['CST_ID'], //              cstCntrPrivList[0].cstCntrID,
              rowDataDT['SRL'], //1,
              rowDataDT['BR_ID'], //BR_ID
            ]);
            debugPrint("INSERT DETAIL  ${rowDataDT['ACC_TYPE']} ===  ${rowDataDT['ACC_HD_ID']}  ${rowDataDT['SRL']}------------------");
          }
        }
        return [];
      });
      // isPostingToApi = false;
      if (response.isEmpty) {
        showMessage(color: saveColor, titleMsg: "تم مزامنة السندات", titleFontSize: 18, durationMilliseconds: 2000);
      }
    } catch (e) {
      appLog += "${e.toString()} \n------------------------------------------\n";
      showMessage(color: secondaryColor, titleMsg: "posting error !", titleFontSize: 18, msg: e.toString(), durationMilliseconds: 5000);
    }
  }

//---------------------------END   SANADAT SYNC  ----------------------------------
}

enum ReturnedResponse {
  done,
  error,
}
