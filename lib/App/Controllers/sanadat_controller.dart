import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import '../../../App/Services/sqflite_services.dart';
import '../../../App/samples/slmaples.dart';
import 'package:sqflite/sqflite.dart';
import '../Models/user_model.dart';
import '../Print/direct_print.dart';
import '../Print/pdf_viewer.dart';
import '../Services/api_db_services.dart';
import '../Widget/widget.dart';
import '../utils/utils.dart';
import 'login_controller.dart';
import 'user_controller.dart';

class SanadatController extends GetxController {
  final Services dbServices = Services();
  SqlDb sqldb = SqlDb();
  late UserController userController;
  late LoginController loginController;

  String? userId;
  String? userName;
  bool isOfflineMode = false;
  late CompData compData;

  String? selectedSanadType;
  String? selectedSanadTypeId;
  List<ActPrivModel> sanadatAct = [];
  CusDataModel? selecetdCustomer;
  List<CusDataModel> cusData = [];

  bool isPostingToApi = false;
  bool isPostedBefor = false;
  String? savedSanadId;

  final formKey = GlobalKey<FormState>();
  TextEditingController date = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  void onInit() {
    userController = Get.find<UserController>();
    loginController = Get.find<LoginController>();
    userId = loginController.logedInuserId;
    userName = loginController.logedInuserName;
    isOfflineMode = loginController.isOfflineMode;
    sanadatAct = userController.actPrivList.where((e) => e.actId.toString().contains("53") || e.actId.toString().contains("57")).toList();
    // sanadatAct = userController.actPrivList.where((e) => [int.parse("53${userController.uId}"), int.parse("57${userController.uId}")].contains(e.actId)).toList();
    cusData = userController.cusDataList;
    compData = userController.compData;
    super.onInit();
  }

  clearSanadData() {
    isPostingToApi = false;
    isPostedBefor = false;
    savedSanadId = null;
    selecetdCustomer = null;
    selectedSanadTypeId = null;
    selectedSanadType = null;
    userName = loginController.logedInuserName;

    amount.clear();
    description.clear();
    date.clear();

    update();
  }

  Map<String, dynamic> getVariablesData() {
    return {
      // "a_comp_name": userController.compData.aCompName,
      // "a_activity": userController.compData.aActivity,
      // "commercial_reg": userController.compData.commercialReg,
      // "tax_no": userController.compData.taxNo,
      // "mobile_no": userController.compData.tel,
      // "e_comp_name": userController.compData.eCompName,
      // "e_activity": userController.compData.eActivity,
      "a_comp_name": userController.compData.aCompName,
      "a_activity": userController.compData.aActivity,
      "t_commercial_reg": "رقم السجل التجاري",
      "commercial_reg": userController.compData.commercialReg,
      "t_tax_no": "الرقم الضريبي",
      "tax_no": userController.compData.taxNo,
      "t_mobile_no": "رقم الهاتف",
      "mobile_no": userController.compData.tel,
      "e_comp_name": userController.compData.eCompName,
      "e_activity": userController.compData.eActivity,
      "t_amount": "المبلغ",
      "amount": amount.text,
      "t_sanad_type": savedSanadId,
      "t_date": "التاريخ",
      "date": date.text,
      "a_t_recive_from": "استلما من المكرم",
      "e_t_recive_from": "Recevied from Mr",
      "cus_name": selecetdCustomer!.cusName,
      "a_t_amount_words": "مبلغ وقدره",
      "e_t_amount_words": "The Amount",
      "amount_words": amount.text,
      "a_t_payment_for": "وذلك مقابل",
      "e_t_payment_for": "As Payment for",
      "payment_for": description.text,
      "t_user_ins": "مدخل السند",
      "user_ins": userName,
    };
  }

//*******************PRINTING ------------------
  Future<void> printSanad() async {
    isPostingToApi = false;
    update();
    // debugPrint("Waite while printing ..............");
    if (isPostedBefor) {
      PrintSamples ps = PrintSamples(compData: compData);
      await printJsondirectly(
        jsonLayout: ps.getSanadSample,
        variables: getVariablesData(),
      );
    } else {
      showMessage(color: secondaryColor, titleMsg: "يرجى حفظ الفاتورة", titleFontSize: 18, durationMilliseconds: 1000);
    }
  }

  void previewSanad() {
    if (isPostedBefor) {
      PrintSamples ps = PrintSamples(compData: compData);
      Get.to(
        () => PdfPreviewScreen(
          // tableHeader: hesders,
          // tableData: data,
          jsonLayout: ps.getSanadSample,
          variables: getVariablesData(),
        ),
      );
    } else {
      showMessage(color: secondaryColor, titleMsg: "يرجى حفظ السند", titleFontSize: 18, durationMilliseconds: 1000);
    }
  }

//-------------------------------------------

  saveSanad() async {
    if (isPostedBefor) {
      //محفوظة مسبقا
      showMessage(color: secondaryColor, titleMsg: "السند محفوظ مسبقا", titleFontSize: 18, durationMilliseconds: 1000);
    } else if (formKey.currentState!.validate()) {
      if (selecetdCustomer == null) {
        showMessage(color: secondaryColor, titleMsg: "يجب اختيار عميل", titleFontSize: 18, durationMilliseconds: 1000);
      } else if (selectedSanadTypeId == null) {
        showMessage(color: secondaryColor, titleMsg: "يجب اختيار نوع السند", titleFontSize: 18, durationMilliseconds: 1000);
      } else {
        if (isOfflineMode) {
          debugPrint("-----------------------------------------------Is Offline Insert--------------------------------");
          await insertSanadToLocalData();
        } else {
          await postSanadToServer();
        }
      }
    } else {
      showMessage(color: secondaryColor, titleMsg: "جميع الحقول اجبارية", titleFontSize: 18, durationMilliseconds: 1000);
    }
  }

  Future<void> postSanadToServer() async {
    isPostingToApi = true;
    update();
    String errorMsg = "";
    if (userController.csClsPrivList.isEmpty) {
      errorMsg = "ليس لديك صلاحيات على مجموعة عملاء";
    } else if (userController.cstCntrPrivList.isEmpty) {
      errorMsg = "ليس لديك صلاحيات على مركز تكلفة ";
    } else if (userController.bankPrivList.isEmpty) {
      errorMsg = "ليس لديك صلاحيات على بنك او حساب ";
    }

    if (errorMsg != "") {
      showMessage(color: secondaryColor, titleMsg: "No prmission !", titleFontSize: 18, msg: errorMsg, durationMilliseconds: 5000);
      isPostingToApi = false;
      update();
      return;
    }

    // await Future.delayed(Duration(seconds: 4));
    try {
      // debugPrint("start posting-------------------------");
      String stmt = """
        DECLARE
          last_serial NUMBER;
        BEGIN

          --get last recorde R_ID and incress for the new insert
          
           SELECT NVL(MAX(ACC_HD_ID),0) + 1  INTO last_serial   FROM ACC_HD  WHERE ACC_TYPE = '$selectedSanadTypeId' ;

          -- Inserting The Header                 
          INSERT INTO ACC_HD(ACC_TYPE,ACC_HD_ID,DATE1 ${userController.csClsPrivList[0].brId != "" ? ",BR_ID" : ""},CUR_ID
          ,TTL,DSCR,TRHEL,RDY,SYS_TYPE,BRNCH_ACT,EXCHNG_PR
          ,USR_INS,USR_INS_DATE,SCRN_SRC) 
          VALUES ($selectedSanadTypeId,last_serial,TO_DATE('${date.text}', 'YYYY-MM-DD') ${userController.csClsPrivList[0].brId != "" ? ",${userController.csClsPrivList[0].brId}" : ""},'${userController.csClsPrivList[0].curId}'
          ,${amount.text},'${description.text}',0,1,'نظام العملاء'
          ,0,1
          ,$userId,TO_DATE('${DateFormat('MM/dd/yyyy HH:mm:ss').format(DateTime.now())}', 'MM/DD/YYYY HH24:MI:SS')
          ,'CUS_HD_DT')   ;

          --BRNCH_ACT_NO,

          --Inserting the detail
          INSERT INTO ACC_DT(CUS_ID,ACC_TYPE,ACC_HD_ID,ACC_ID,CUR_ID
          ,STATE,AMNT,DSCR,CST_ID,SRL) 
          VALUES (${selecetdCustomer!.cusId},$selectedSanadTypeId,last_serial, '${userController.csClsPrivList[0].accId}','${userController.csClsPrivList[0].curId}'
          ,1,${amount.text},'${description.text}',${userController.cstCntrPrivList[0].cstCntrID},1);  

          INSERT INTO ACC_DT(BANK_ID,ACC_TYPE,ACC_HD_ID,ACC_ID,CUR_ID
          ,STATE,AMNT,DSCR ${userController.csClsPrivList[0].brId != "" ? ",BR_ID" : ""},CST_ID) 
          VALUES ('${userController.bankPrivList[0].bankID}',$selectedSanadTypeId,last_serial,'${userController.bankPrivList[0].accID}','${userController.bankPrivList[0].curId}'
          ,2,${amount.text},'${description.text}' ${userController.csClsPrivList[0].brId != "" ? ",${userController.csClsPrivList[0].brId}" : ""}
          ,${userController.cstCntrPrivList[0].cstCntrID});   

          COMMIT;
        END;
        """;
      // debugPrint(vatDetails);
      // debugPrint(vatDetails.toString(), wrapWidth: 1024);
      debugPrint(stmt);
      var response = await dbServices.createRep(sqlStatment: stmt);
      // debugPrint("****************** $response   *************");
      //
      isPostingToApi = false;
      if (response.isEmpty) {
        isPostedBefor = true;

        response = await dbServices.createRep(
          sqlStatment: """
          SELECT MAX(ACC_HD_ID) ACC_HD_ID    FROM ACC_HD  WHERE ACC_TYPE = '$selectedSanadTypeId' AND USR_INS=$userId """,
        );

        // debugPrint("****************** ${response[0]['ACC_HD_ID']}   *************");
        savedSanadId = " $selectedSanadType ( ${response[0]['ACC_HD_ID'].toStringAsFixed(0)} )";

        var result = await SqlDb().readData("SELECT LAST_OFFLINE_SYNC FROM COMP WHERE HAS_OFFLINE_DATA = 1");
        if (result.isNotEmpty) {
          await insertSanadToLocalData(sync: 1);
        }

        showMessage(color: saveColor, titleMsg: "تم الحفظ", titleFontSize: 18, durationMilliseconds: 1000);
      }
    } catch (e) {
      isPostingToApi = false;
      isPostedBefor = false;
      userController.appLog += "${e.toString()} \n------------------------------------------\n";
      showMessage(color: secondaryColor, titleMsg: "posting error !", titleFontSize: 18, msg: e.toString(), durationMilliseconds: 5000);
    }

    update();
  }

  Future<void> insertSanadToLocalData({int sync = 0}) async {
    isPostingToApi = true;
    update();

    try {
      Database? mydb = await sqldb.db;

      // 1. الحصول على last_serial
      final result = await mydb!.rawQuery('SELECT MAX(ACC_HD_ID) + 1 as new_srl FROM ACC_HD WHERE ACC_TYPE = ?', [selectedSanadTypeId]);
      final lastSerial = result.first['new_srl'] ?? 1;

      // 2. one shot execuet
      var response = await mydb.transaction((txn) async {
        await txn.rawInsert('''
        INSERT INTO ACC_HD(ACC_TYPE, ACC_HD_ID, DATE1, CUR_ID, TTL, DSCR, TRHEL, RDY, SYS_TYPE, BRNCH_ACT, EXCHNG_PR, USR_INS, USR_INS_DATE, SCRN_SRC,SYNC ${userController.csClsPrivList[0].brId != "" ? ", BR_ID" : ""})
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,? ${userController.csClsPrivList[0].brId != "" ? ", ?" : ""})
        ''', [
          selectedSanadTypeId,
          lastSerial,
          date.text,
          userController.csClsPrivList[0].curId,
          amount.text,
          description.text,
          0,
          1,
          'نظام العملاء',
          0,
          1,
          userId,
          DateFormat('MM/dd/yyyy HH:mm:ss').format(DateTime.now()),
          'CUS_HD_DT',
          sync, //SYNC
          if (userController.csClsPrivList[0].brId != "") userController.csClsPrivList[0].brId,
        ]);

        await txn.rawInsert('''
        INSERT INTO ACC_DT(CUS_ID, ACC_TYPE, ACC_HD_ID, ACC_ID, CUR_ID, STATE, AMNT, DSCR, CST_ID, SRL)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', [
          selecetdCustomer!.cusId,
          selectedSanadTypeId,
          lastSerial,
          userController.csClsPrivList[0].accId,
          userController.csClsPrivList[0].curId,
          1,
          amount.text,
          description.text,
          userController.cstCntrPrivList[0].cstCntrID,
          1, //DN
        ]);

        await txn.rawInsert('''
        INSERT INTO ACC_DT(BANK_ID, ACC_TYPE, ACC_HD_ID, ACC_ID, CUR_ID, STATE, AMNT, DSCR ${userController.csClsPrivList[0].brId != "" ? ", BR_ID" : ""}, CST_ID,SRL)
        VALUES (?, ?, ?, ?, ?, ?, ?, ? ${userController.csClsPrivList[0].brId != "" ? ", ?" : ""}, ?,?)
        ''', [
          userController.bankPrivList[0].bankID,
          selectedSanadTypeId,
          lastSerial,
          userController.bankPrivList[0].accID,
          userController.bankPrivList[0].curId,
          2,
          amount.text,
          description.text,
          if (userController.csClsPrivList[0].brId != "") userController.csClsPrivList[0].brId,
          userController.cstCntrPrivList[0].cstCntrID,
          2, //MD
        ]);

        return [];
      });
      isPostingToApi = false;
      if (response.isEmpty) {
        isPostedBefor = true;

        // debugPrint("****************** ${response[0]['ACC_HD_ID']}   *************");
        savedSanadId = " $selectedSanadType ( $lastSerial )";

        showMessage(color: saveColor, titleMsg: "تم الحفظ", titleFontSize: 18, durationMilliseconds: 1000);
      }
    } catch (e) {
      isPostingToApi = false;
      isPostedBefor = false;
      userController.appLog += "${e.toString()} \n------------------------------------------\n";
      showMessage(color: secondaryColor, titleMsg: "posting error !", titleFontSize: 18, msg: e.toString(), durationMilliseconds: 5000);
    }
    update();
  }

//******************Get Sanad***************************
  final searchOfSanad = TextEditingController();
  var searchResults = [].obs;
  var isSearchingOfSanad = false.obs;

  Future<void> fetchSearchResults(String query) async {
    if (query.isEmpty) {
      isSearchingOfSanad.value = false;
      searchResults.value = [];
      return;
    }
    isSearchingOfSanad.value = true;

    try {
      List response;

      if (isOfflineMode) {
        String actIds = sanadatAct.map((act) => "'${act.actId}'").join(',');
        response = await sqldb.readData(
          """
          SELECT  a.CUS_ID,  c.CUS_NAME,a.ACC_TYPE,t.ACT_NAME,a.ACC_HD_ID,ROUND(a.AMNT, 2) AS AMNT,a.DSCR,h.DATE1 FROM ACC_DT a
          JOIN CUSTOMERS c ON a.CUS_ID = c.CUS_ID
          JOIN ACT_TYPE t ON a.ACC_TYPE = t.ACT_ID
          JOIN ACC_HD h ON a.ACC_TYPE = h.ACC_TYPE AND a.ACC_HD_ID = h.ACC_HD_ID
          WHERE a.CUS_ID IS NOT NULL
          AND a.ACC_TYPE IN ($actIds)
          AND (
          LOWER(c.CUS_NAME) LIKE ? OR
          CAST(a.ACC_HD_ID AS TEXT) LIKE ? OR
          LOWER(t.ACT_NAME) LIKE ?
          )
          ORDER BY a.SRL            
          """,
          ['%$query%', '%$query%', '%$query%'],
        );
      } else {
        String stmt =
            // """
            //   SELECT a.CUS_ID,get_cus_name_DB(a.CUS_ID) CUS_NAME,a.ACC_TYPE,get_act_name(a.ACC_TYPE) ACT_NAME,a.ACC_HD_ID,round(a.AMNT,2) AMNT , DSCR ,
            //   (SELECT TO_CHAR(DATE1,'yyyy-mm-dd') FROM ACC_HD b WHERE b.ACC_TYPE=a.ACC_TYPE AND b.ACC_HD_ID=a.ACC_HD_ID) DATE1

            //   FROM ACC_DT a WHERE a.CUS_ID IS NOT NULL and a.ACC_TYPE IN(${sanadatAct.map((act) => "'${act.actId}'").join(',')})
            //   AND (
            //   LOWER(get_cus_name_DB(a.CUS_ID)) LIKE LOWER('%$query%') OR
            //   TO_CHAR(a.ACC_HD_ID) LIKE '%$query%' OR
            //   LOWER(get_act_name(a.ACC_TYPE)) LIKE LOWER('%$query%')
            //   )
            //   order by SRL
            //   """;
            """
          SELECT a.CUS_ID,a.CUS_NAME,a.ACC_TYPE,a.ACT_NAME ,a.ACC_HD_ID,round(a.AMNT,2) AMNT , DSCR ,TO_CHAR(a.DATE1, 'yyyy-MM-dd') DATE1,
           GET_USER_NAME_DB(NVL(USR_UPD,USR_INS) ) USER_UP_INS_NAME
          FROM ACC_MULTI.ACC_TRANS_ALL a WHERE a.CUS_ID IS NOT NULL and a.ACC_TYPE IN(${sanadatAct.map((act) => "'${act.actId}'").join(',')})
          AND (
          LOWER(a.CUS_NAME) LIKE LOWER('%$query%') OR 
           TO_CHAR(a.ACC_HD_ID) LIKE '%$query%' OR
           LOWER(a.ACT_NAME) LIKE LOWER('%$query%')
          ) 
          AND   (select CS_CLS_ID from CUSTOMERS WHERE CUS_ID=a.CUS_ID ) IN ( SELECT CS_CLS_ID FROM USER_CUS_GRP u WHERE u.U_ID=$userId AND u.CHK = 1)
          order by SRL 
          """;
        response = await dbServices.createRep(
          sqlStatment: stmt,
        );
      }
      //
      if (response.isNotEmpty && response[0]['CUS_ID'] != null) {
        searchResults.value = response;
      } else {
        searchResults.value = [];
      }
      isSearchingOfSanad.value = false;
    } catch (e) {
      showMessage(color: secondaryColor, titleMsg: "Catch Post error !", titleFontSize: 18, msg: e.toString(), durationMilliseconds: 5000);

      searchResults.value = [];
      isSearchingOfSanad.value = false;
    }
  }

  void sanadSearchDialoag() {
    searchOfSanad.clear();
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        insetPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.zero,
        backgroundColor: Colors.grey.shade100,
        // surfaceTintColor: Colors.grey.shade100,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Obx(
            () {
              final controller = Get.find<SanadatController>();
              return Column(
                children: [
                  const Text("بحث عن سند"),
                  controller.isSearchingOfSanad.value
                      ? LinearProgressIndicator(
                          color: secondaryColor,
                          minHeight: 2,
                        )
                      : const Divider(),
                  SizedBox(
                    height: 45,
                    child: GetBuilder<SanadatController>(
                      builder: (controller) => TextFormField(
                        // focusNode: controller.fn,
                        controller: controller.searchOfSanad,
                        keyboardType: TextInputType.text,
                        textAlignVertical: const TextAlignVertical(y: -0.4),
                        decoration: InputDecoration(
                          labelText: "search".tr,
                          hintText: "اسم عميل/(رقم-نوع) سند",
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                          suffixIcon: const Icon(Icons.search, color: primaryColor),
                          border: const OutlineInputBorder(
                            gapPadding: 4,
                            // borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          controller.fetchSearchResults(value);
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        content: Container(
          height: Get.height / 2,
          width: Get.width / 2,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Obx(
            () {
              final results = Get.find<SanadatController>().searchResults;
              if (results.isEmpty) return Center(child: Text("لا يوجد بيانات"));
              return ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> item = results[index];
                  final controller = Get.find<SanadatController>();
                  return ListTile(
                    title: Text(item['CUS_NAME']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${item['ACT_NAME']} ( ${item['ACC_HD_ID']} ) "),
                        Text("${item['DATE1']}"),
                        Row(
                          children: [
                            Text("المبلغ :  ${item['AMNT']}"),
                            SizedBox(width: 10),
                            SvgPicture.asset(
                              'assets/images/rs.svg',
                              width: 15,
                              height: 15,
                              // fit: BoxFit.contain,
                            ),
                          ],
                        ),
                        Divider(),
                      ],
                    ),
                    onTap: () {
                      // final String actId = item['ACC_TYPE'].toString();
                      // final String actTypeName = item['ACT_NAME'].toString();
                      // final String accHdId = item['ACC_HD_ID'].toString();
                      // final int cusId = item['CUS_ID'];
                      // final String parsedDate = item['DATE1'].toString();
                      // final String amount = item['AMNT'].toStringAsFixed(2);
                      // final String dscr = item['DSCR'].toString();

                      // final customer = controller.cusData.firstWhereOrNull((c) => c.cusId == cusId);
                      // if (customer == null) return;

                      selectedSanadTypeId = item['ACC_TYPE'].toString();
                      selectedSanadType = item['ACT_NAME'].toString();
                      savedSanadId = item['ACC_HD_ID'].toString();
                      selecetdCustomer = controller.cusData.firstWhereOrNull((c) => c.cusId == item['CUS_ID']);
                      date.text = item['DATE1'].toString();
                      amount.text = item['AMNT'].toStringAsFixed(2);
                      description.text = item['DSCR'].toString();
                      userName = item['USER_UP_INS_NAME'].toString();

                      isPostedBefor = true;
                      update();

                      Get.back();
                    },
                  );
                },
              );
            },
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), backgroundColor: secondaryColor),
                  child: const Text("خروج", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
