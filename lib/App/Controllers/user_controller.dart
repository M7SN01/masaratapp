// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/login_controller.dart';
import '../Models/user_model.dart';
import '../Services/api_db_services.dart';
import '../Services/sqflite_services.dart';
import '../Widget/loding_dots.dart';
import '../Widget/widget.dart';
import '../utils/utils.dart';
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
  String errorLog = "";

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

  String statment = "";
  Future<void> _getActPrivileges() async {
    statment = """
      SELECT a.* , (SELECT ACT_NAME FROM ACT_TYPE WHERE ACT_ID = a.ACT_ID) AS ACT_NAME FROM
      (SELECT ACT_ID , CHK FROM USER_JOURNAL 
      WHERE U_ID='$uId' 
      
      AND CHK=1
      ) a
      """;
    try {
      var response = await dbServices.createRep(
        sqlStatment: statment,

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
      List<dynamic> userActIds = [int.parse('53$uId'), int.parse('57$uId'), /*58, 59, 60, 61, 77,*/ 99];
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
      errorLog += "$statment \n ERROR: => get Act Privileges {{=($e)=}}  \n";
    }
  }

  Future<void> _getCusData() async {
    statment = """
      SELECT *  FROM CUSTOMERS WHERE CS_CLS_ID IN
      (SELECT CS_CLS_ID FROM USER_CUS_GRP WHERE U_ID='$uId' AND CHK = 1 
      )
      """;
    // where  1  = CHK_CUS_USR_PRV (CUS_ID ,${uId} )
    try {
      var response = await dbServices.createRep(
        sqlStatment: statment,
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
      errorLog += "$statment \n ERROR: => get Cus Data {{=($e)=}}  \n";
    }
  }

  Future<void> _getSlsCntrPrivileges() async {
    statment = """
      SELECT a.*,(SELECT SLS_CNTR_NAME FROM SLS_CENTER WHERE SLS_CNTR_ID=a.SLS_CNTR_ID) AS SLS_CNTR_NAME 
      FROM 
      (
      SELECT SLS_CNTR_ID FROM USER_SLS_CENTER  WHERE U_ID='$uId' AND CHK = 1 
      ) a
      """;
    try {
      var response = await dbServices.createRep(
        sqlStatment: statment,
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
      errorLog += "$statment \n ERROR: => get Sls Cntr Privileges {{=($e)=}}  \n";
    }
  }

  Future<void> _getCstCntrPrivileges() async {
    statment = """
      SELECT a.*,(SELECT CST_A_NAME FROM COST_CENTERS WHERE CST_ID=a.CST_ID) AS CST_A_NAME 
      FROM 
      (
      SELECT CST_ID FROM USER_CC  WHERE U_ID='$uId' AND CHK = 1 
      ) a
      """;
    try {
      var response = await dbServices.createRep(
        sqlStatment: statment,
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
      errorLog += "$statment \n ERROR: => get cost Cntr Privileges {{=($e)=}}  \n";
    }
  }

  Future<void> _getStWhPrivileges() async {
    statment = """
      SELECT a.*,(SELECT WH_NAME FROM STWHOUSE WHERE WH_ID=a.WH_ID) AS WH_NAME 
      FROM 
      (
      SELECT WH_ID FROM USER_STWHOUSE  WHERE U_ID='$uId' AND CHK = 1 
      ) a
      """;
    try {
      var response = await dbServices.createRep(
        sqlStatment: statment,
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
      errorLog += "$statment \n ERROR: => get StWhouse Privileges {{=($e)=}}  \n";
    }
  }

  Future<void> _getBranchPrivileges() async {
    statment = """
      SELECT a.*,(SELECT BR_NAME FROM BRANCH WHERE BR_ID=a.BR_ID) AS BR_NAME 
      FROM 
      (
      SELECT BR_ID FROM USER_BRANCH WHERE U_ID='$uId'  
      ) a
      WHERE (SELECT MULTI_BR FROM COMP) =1
      """;
    try {
      var response = await dbServices.createRep(
        sqlStatment: statment,
      );

      branchPrivList.clear();
      for (var element in response) {
        branchPrivList.add(BranchPrivModel(brID: element["BR_ID"], brName: element["BR_NAME"]));
      }

      checkPrivileges(lst: slsCntrPrivList, tabel: "BRANCHES", needOnlyOneRow: true);
    } catch (e) {
      errorLog += "$statment \n ERROR: => get Branch Privileges {{=($e)=}}  \n";
    }
  }

  Future<void> _getBankPrivileges() async {
    statment = """
      SELECT * FROM (
      SELECT BANK_ID , ACC_NAME,ACC_ID,BANK_OR_CASH,STOPED,CUR_ID FROM SH_BANKS_DTL 
      WHERE BANK_ID IN (SELECT BANK_ID FROM USER_BANKS WHERE U_ID='$uId' AND CHK=1 )      
      ) a
       WHERE a.ACC_ID IN(SELECT ACC_ID FROM USER_ACCOUNT b WHERE b.U_ID='$uId' AND b.CHK=1 )
      """;
    try {
      var response = await dbServices.createRep(
        sqlStatment: statment,
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
            curId: element['CUR_ID'] ?? "CUR_ID is Null <=> ${element["ACC_NAME"]}",
          ),
        );
      }

      checkPrivileges(lst: bankPrivList, tabel: "Bank / Account", needOnlyOneRow: true);
    } catch (e) {
      errorLog += "$statment \n ERROR: => get Bank Privileges {{=($e)=}}  \n";
    }
  }

  Future<void> _getItemsData() async {
    statment = """
      SELECT ITEM_ID,BARCODE,ITEM_NAME,ROUND(PRICE1, 4) PRICE1 ,  ROUND(PRICE_AFTR_VAT,4) PRICE_AFTR_VAT, MAIN_UNIT FROM ITEMS aa  
     
      """;
    // WHERE ROWNUM <1000
    //Curnt_bal
    //,(SELECT CURNT_BAL FROM ITEMS_WHOUSE bb WHERE bb.WH_ID ='${stWhPrivList[0].whID}' AND bb.ITEM_ID=aa.ITEM_ID) CURNT_BAL
    //multi wh
    // SELECT ITEM_ID,BARCODE,ITEM_NAME,PRICE_AFTR_VAT,CURNT_BAL, MAIN_UNIT FROM ITEMS_WHOUSE WHERE WH_ID IN (${stWhPrivList.map((e) => "'${e.whID}'").toList().join(',')})

    try {
      var response = await dbServices.createRep(
        sqlStatment: statment,
      );

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
    statment = """
      SELECT *  FROM  CS_CLS WHERE CS_CLS_ID IN
      (SELECT CS_CLS_ID FROM USER_CUS_GRP WHERE U_ID='$uId' AND CHK = 1 
      )
      """;
    try {
      var response = await dbServices.createRep(
        sqlStatment: statment,
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
      errorLog += "$statment \n ERROR: => get Customer Class Privileges {{=($e)=}}  \n";
    }
  }

  //select  REP_A_COMP_NAME ,REP_E_COMP_NAME,REP_A_NTUR_WORK , REP_E_NTUR_WORK ,REP_A_ADRS ,REP_E_ADRS,REP_A_TEL,REP_A_FAX  ,TAX_NO ,COMMERCIAL_REG  from comp ;

  Future<void> _getCompData() async {
    statment = """
      select  REP_A_COMP_NAME ,REP_E_COMP_NAME,REP_A_NTUR_WORK , REP_E_NTUR_WORK ,REP_A_ADRS ,REP_E_ADRS,REP_A_TEL,REP_A_FAX  
      ,TAX_NO ,COMMERCIAL_REG  from comp
      """;
    try {
      var response = await dbServices.createRep(
        sqlStatment: statment,
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
      errorLog += "$statment \n ERROR: => get Comp  Data {{=($e)=}}  \n";
    }
  }

  Future<void> getAllPrivileges() async {
    //initializing
    LoginController loginController = Get.find<LoginController>();
    uId = loginController.logedInuserId ?? "";
    uName = loginController.logedInuserName ?? "";
    uPass = loginController.logedInPassword ?? "";
    isOfflineMode = loginController.isOfflineMode;
    debugPrint("XXXXXXXXXXXX   $uId   XXXXXXXXXXXX");
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
    // debugPrint("END ************************************ \n $errorLog");
    // debugPrint("************************************\n************************************\n************************************\n $appLog");
  }

  @override
  void onInit() {
    super.onInit();
  }

  //post any offline data that SYNC=0
  Future<int> cheakSanadNeedSync() async {
    var result = await sqldb.readData("SELECT ACC_HD_ID CNT from ACC_HD WHERE SYNC = 0 ");
    return result.length;
  }

  Future<void> syncLocalDataToserver() async {
    int countNeedSync = await cheakSanadNeedSync();

    if (countNeedSync > 0) {
      await syncSanadatToServer();
    }
    // else {
    //   //
    //   // print("no data continue ..... ");
    // }
  }

  // String currentSyncDesc=""; // sync  1 of 20  2 of 20 .... to end
  Future<void> syncSanadatToServer() async {
    //
    showWaittingToSyncDialog();

    ErrorState error = ErrorState(ErrorHappened.noError);
    List hdResult = await sqldb.readData("SELECT * FROM ACC_HD WHERE SYNC = 0");

    /*
          --rowDataHD['TRHEL']  always  0
          --rowDataHD['RDY']    always  1
          --rowDataHD['BRNCH_ACT']  always  0
          --rowDataHD['EXCHNG_PR']  always  1
    */
    String stmtHd = "";
    String stmtDt = "";
    for (var rowDataHD in hdResult) {
      try {
        String hdbrIdArg = rowDataHD['BR_ID'] != null ? ",BR_ID" : "";
        String hdbrIdValue = rowDataHD['BR_ID'] != null ? ",${rowDataHD['BR_ID']}" : "";
        stmtHd = """
        DECLARE
          last_serial NUMBER;
        BEGIN

          -- Inserting The Header                 
          INSERT INTO ACC_HD(ACC_TYPE,ACC_HD_ID,DATE1 $hdbrIdArg,CUR_ID
          ,TTL,DSCR,TRHEL,RDY,SYS_TYPE,BRNCH_ACT,EXCHNG_PR
          ,USR_INS,USR_INS_DATE,SCRN_SRC) 
          VALUES (${rowDataHD['ACC_TYPE']},${rowDataHD['ACC_HD_ID']},TO_DATE('${rowDataHD['DATE1']}', 'YYYY-MM-DD') $hdbrIdValue,'${rowDataHD['CUR_ID']}'
          ,${rowDataHD['TTL']},'${rowDataHD['DSCR']}',0,1,'${rowDataHD['SYS_TYPE']}'
          ,0,1
          ,${rowDataHD['USR_INS']},TO_DATE('${rowDataHD['USR_INS_DATE']}', 'MM/DD/YYYY HH24:MI:SS')
          ,'${rowDataHD['SCRN_SRC']}')   ;
          
          """;

        stmtDt = "SELECT * FROM ACC_DT WHERE  ACC_TYPE = ${rowDataHD['ACC_TYPE']} AND ACC_HD_ID=${rowDataHD['ACC_HD_ID']}";
        List dtResult = await sqldb.readData(stmtDt);

        for (var rowDataDT in dtResult) {
          String bnkCusArg = rowDataDT['BANK_ID'] != null ? "BANK_ID" : "CUS_ID";
          String bnkCusValue = rowDataDT['BANK_ID'] != null ? "'${rowDataDT['BANK_ID']}'" : "${rowDataDT['CUS_ID']}";
          String brIdArg = rowDataDT['BR_ID'] != null ? ",BR_ID" : "";
          String brIdValue = rowDataDT['BR_ID'] != null ? ",${rowDataDT['BR_ID']}" : "";

          stmtHd += """
                    INSERT INTO ACC_DT($bnkCusArg, ACC_TYPE, ACC_HD_ID, ACC_ID,
                     CUR_ID, STATE, AMNT, DSCR, CST_ID, SRL $brIdArg)
                    VALUES ($bnkCusValue,${rowDataDT['ACC_TYPE']},${rowDataDT['ACC_HD_ID']},'${rowDataDT['ACC_ID']}',
                    '${rowDataDT['CUR_ID']}',${rowDataDT['STATE']},${rowDataDT['AMNT']},'${rowDataDT['DSCR']}',${rowDataDT['CST_ID']},${rowDataDT['SRL']} $brIdValue
                    );
                    
                    """;
        }

        stmtHd += """
                COMMIT;
                END;
                """;

        debugPrint(stmtHd);

        var response = await dbServices.createRep(sqlStatment: stmtHd);
        debugPrint(response.toString());
        if (response.isEmpty) {
          await sqldb.readData("UPDATE ACC_HD SET SYNC=1 WHERE  ACC_TYPE = ${rowDataHD['ACC_TYPE']} AND ACC_HD_ID=${rowDataHD['ACC_HD_ID']}");

          continue;
        } else {
          error = ErrorState(ErrorHappened.whileInserting, message: "Try Inserting ACC_TYPE =>${rowDataHD['ACC_TYPE']},ACC_HD_ID=> ${rowDataHD['ACC_HD_ID']}\n ${response.toString()}");
          errorLog += "\nERROR: => Try Inserting ACC_TYPE =>${rowDataHD['ACC_TYPE']},ACC_HD_ID=> ${rowDataHD['ACC_HD_ID']}\n ${response.toString()} \n";
          break;
        }
      } catch (e) {
        error = ErrorState(ErrorHappened.catchedError, message: e.toString());
        errorLog += "\n Sync. error  => catching  \n ${e.toString()} \n";
      }
    }

    Get.back();
    Get.delete<TextLodingDotController>();

    if (error.isWhileInserting) {
      await showMessage(color: secondaryColor, titleMsg: "Inserting sanadat error !", titleFontSize: 18, msg: error.message, durationMilliseconds: 5000);
      debugPrint(error.message);
    } else if (error.isCatchedError) {
      showMessage(color: secondaryColor, titleMsg: "Sync. error !", titleFontSize: 18, msg: error.message, durationMilliseconds: 5000);
      debugPrint(error.message);
    }
  }

  showWaittingToSyncDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "يرجى الانتظار",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "جاري مزامنة السندات المحفوظة (بدون اتصال)",
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 20,
                width: 100, //fixed width the dots is move only without the text
                child: TextLodingDot(
                  text: "إلى السيرفر",
                  dot: '.',
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}

enum ErrorHappened {
  whileInserting,
  catchedError,
  noError,
}

class ErrorState {
  final ErrorHappened type;
  String message;

  ErrorState(this.type, {this.message = ""});

  bool get isWhileInserting => type == ErrorHappened.whileInserting;
  bool get isCatchedError => type == ErrorHappened.catchedError;
}
