import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:masaratapp/App/samples/slmaples.dart';
import '../Models/user_model.dart';
import '../Print/direct_print.dart';
import '../Print/pdf_viewer.dart';
import '../Services/api_db_services.dart';
import '../Widget/widget.dart';
import '../utils/utils.dart';
import 'user_controller.dart';

class SanadatController extends GetxController {
  final Services dbServices = Services();
  late UserController userController;

  String? userId;
  String userName = "";
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
    userId = userController.uId;
    userName = userController.uName;
    sanadatAct = userController.actPrivList.where((e) => [int.parse("53${userController.uId}"), int.parse("57${userController.uId}")].contains(e.actId)).toList();
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
    amount.clear();
    description.clear();
    date.clear();

    update();
  }

  Map<String, dynamic> getVariablesData() {
    return {
      "a_comp_name": userController.compData.aCompName,
      "a_activity": userController.compData.aActivity,
      "commercial_reg": userController.compData.commercialReg,
      "tax_no": userController.compData.taxNo,
      "mobile_no": userController.compData.tel,
      "e_comp_name": userController.compData.eCompName,
      "e_activity": userController.compData.eActivity,
      "t_amount": "المبلغ",
      "amount": amount.text,
      "t_sanad_type": savedSanadId,
      "t_date": "التاريخ",
      "date": date.text,
      "a_t_recive_from": "استلنا من المكرم",
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
    // print("Waite while printing ..............");
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
    // isPostedBefor = false;
    // update();
    if (isPostedBefor) {
      //محفوظة مسبقا
      showMessage(color: secondaryColor, titleMsg: "السند محفوظ مسبقا", titleFontSize: 18, durationMilliseconds: 1000);
    } else if (formKey.currentState!.validate()) {
      if (selecetdCustomer == null) {
        showMessage(color: secondaryColor, titleMsg: "يجب اختيار عميل", titleFontSize: 18, durationMilliseconds: 1000);
      } else if (selectedSanadTypeId == null) {
        showMessage(color: secondaryColor, titleMsg: "يجب اختيار نوع السند", titleFontSize: 18, durationMilliseconds: 1000);
      } else {
        await postSanadToServer();
      }
    } else {
      showMessage(color: secondaryColor, titleMsg: "جميع الحقول اجبارية", titleFontSize: 18, durationMilliseconds: 1000);
    }
  }

  Future<void> postSanadToServer() async {
    isPostingToApi = true;
    update();
    // await Future.delayed(Duration(seconds: 4));
    try {
      print("start posting-------------------------");
      String stmt = """
        DECLARE
          last_serial NUMBER;
        BEGIN

          --get last recorde R_ID and incress for the new insert
          
           SELECT NVL(MAX(ACC_HD_ID),0) + 1  INTO last_serial   FROM ACC_HD  WHERE ACC_TYPE = '$selectedSanadTypeId' ;
         -- SELECT MAX(SS) INTO last_serial  
         -- FROM (SELECT NVL(SRL,0) + 1  SS   FROM ACT_TYPE  WHERE ACT_ID = '$selectedSanadTypeId'  
         -- UNION ALL
         -- SELECT NVL(MAX(ACC_HD_ID),0) + 1  SS  FROM ACC_HD  WHERE ACC_TYPE = '$selectedSanadTypeId' 
          --)

          --last_serial := last_serial + 1;

          -- Inserting The Header                 
          INSERT INTO ACC_HD(ACC_TYPE,ACC_HD_ID,DATE1,BR_ID,CUR_ID
          ,TTL,DSCR,TRHEL,RDY,SYS_TYPE,BRNCH_ACT,EXCHNG_PR
          ,USR_INS,USR_INS_DATE,SCRN_SRC) 
          VALUES ($selectedSanadTypeId,last_serial,TO_DATE('${date.text}', 'YYYY-MM-DD'),${userController.csClsPrivList[0].brId},'${userController.csClsPrivList[0].curId}'
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
          ,STATE,AMNT,DSCR,BR_ID,CST_ID) 
          VALUES (${userController.bankPrivList[0].bankID},$selectedSanadTypeId,last_serial,'${userController.bankPrivList[0].accID}','${userController.bankPrivList[0].curId}'
          ,2,${amount.text},'${description.text}',${userController.csClsPrivList[0].brId}
          ,${userController.cstCntrPrivList[0].cstCntrID});   

          COMMIT;
        END;
        """;

      // print(vatDetails);
      // debugPrint(vatDetails.toString(), wrapWidth: 1024);
      debugPrint(stmt);
      var response = await dbServices.createRep(sqlStatment: stmt);
      // print("****************** $response   *************");
      //
      isPostingToApi = false;
      if (response.isEmpty) {
        isPostedBefor = true;

        response = await dbServices.createRep(
          sqlStatment: """
          SELECT MAX(ACC_HD_ID) ACC_HD_ID    FROM ACC_HD  WHERE ACC_TYPE = '$selectedSanadTypeId' AND USR_INS=$userId """,
        );

        // print("****************** ${response[0]['ACC_HD_ID']}   *************");
        savedSanadId = " $selectedSanadType ( ${response[0]['ACC_HD_ID'].toStringAsFixed(0)} )";

        showMessage(color: saveColor, titleMsg: "تم الحفظ", titleFontSize: 18, durationMilliseconds: 1000);
      }
    } catch (e) {
      isPostingToApi = false;
      isPostedBefor = false;
      userController.appLog += "${e.toString()} \n------------------------------------------\n";
      showMessage(color: secondaryColor, titleMsg: "posting error !", titleFontSize: 18, msg: e.toString(), durationMilliseconds: 1000);
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
      searchResults.clear();
      return;
    }
    isSearchingOfSanad.value = true;

    try {
      var response = await dbServices.createRep(
        sqlStatment: """
      SELECT a.CUS_ID,get_cus_name_DB(a.CUS_ID) CUS_NAME,a.ACC_TYPE,get_act_name(a.ACC_TYPE) ACT_NAME,a.ACC_HD_ID,a.AMNT , DSCR ,
      (SELECT TO_CHAR(DATE1,'yyyy-mm-dd') FROM ACC_HD b WHERE b.ACC_TYPE=a.ACC_TYPE AND b.ACC_HD_ID=a.ACC_HD_ID) DATE1

      FROM ACC_DT a WHERE a.CUS_ID IS NOT NULL and a.ACC_TYPE IN(${sanadatAct.map((act) => "'${act.actId}'").join(',')})
      AND (
      LOWER(get_cus_name_DB(a.CUS_ID)) LIKE LOWER('%$query%') OR 
      TO_CHAR(a.ACC_HD_ID) LIKE '%$query%' OR
       LOWER(get_act_name(a.ACC_TYPE)) LIKE LOWER('%$query%')
      )
      order by SRL
      
      """,
      );
      searchResults.value = response;
      isSearchingOfSanad.value = false;
    } catch (e) {
      searchResults.value = [];
      isSearchingOfSanad.value = false;
    }
  }

  void setSelectedSanad({
    required String sanadTypeId,
    required String sanadTypeName,
    required String sanadId,
    required CusDataModel customer,
    required String selectedDate,
    required String amnt,
    required String dscr,
  }) {
    selectedSanadTypeId = sanadTypeId;
    selectedSanadType = sanadTypeName;
    savedSanadId = " $sanadTypeName ( $sanadId )";
    selecetdCustomer = customer;
    date.text = selectedDate;
    amount.text = amnt;
    description.text = dscr;

    isPostedBefor = true;

    update(); // optional: to trigger GetBuilder if needed
  }

  void sanadSearchDialoag() {
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
              if (results.isEmpty) return const SizedBox.shrink();
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
                      final String actId = item['ACC_TYPE'].toString();
                      final String actTypeName = item['ACT_NAME'].toString();
                      final String accHdId = item['ACC_HD_ID'].toString();
                      final int cusId = item['CUS_ID'];
                      final String parsedDate = item['DATE1'].toString();
                      final String amount = item['AMNT'].toStringAsFixed(2);
                      final String dscr = item['DSCR'].toString();

                      final customer = controller.cusData.firstWhereOrNull((c) => c.cusId == cusId);
                      if (customer == null) return;

                      controller.setSelectedSanad(
                        sanadTypeId: actId,
                        sanadTypeName: actTypeName,
                        sanadId: accHdId,
                        customer: customer,
                        selectedDate: parsedDate,
                        amnt: amount,
                        dscr: dscr,
                      );
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

/*
Map<String, dynamic> getTestMap() {
  final controller = Get.find<SanadatController>();
  return containerW(
    // w: 600,
    // h: 400,
    // width: mmToPixel(210),
    height: 328, //mmToPixel(297 / 3),

    padding: [10, 10, 10, 10],
    containerDecorationW: containerDecorationW(containerDecorationBorderW: containerDecorationBorderW(width: 0.5), radius: 4),
    child: columnW(
      children: [
        
       
        // rowW(children: [expandedW(child: dashedLineW(dashSpace: 1, dashWidth: 2, height: 1))]),
        // expandedW(child: dashedLineW(dashSpace: 1, dashWidth: 2, height: 1)),
        sizedBoxW(height: 10),
        //type & date  & amount
        rowW(
          children: [
            //amount
            expandedW(
              // flex: 1,
              child: containerW(
                padding: [5, 5, 5, 5],
                // margin: [10, 0, 0, 0],
                containerDecorationW: containerDecorationW(radius: 4, containerDecorationBorderW: containerDecorationBorderW(width: 1)),
                child: rowW(mainAxisAlignment: "center", children: [textW("المبلغ", fontSize: 14), textW("   :   ", fontSize: 14), textW(controller.amount.text, fontSize: 14), sizedBoxW(width: 10), imageSvgW(assetName: "assets/images/rs.svg", height: 18, width: 18)]),
              ),
            ),

            //sanad No
            expandedW(
              flex: 2,
              child: containerW(
                padding: [5, 5, 5, 5],
                margin: [10, 0, 10, 0],
                containerDecorationW: containerDecorationW(radius: 4, containerDecorationBorderW: containerDecorationBorderW(width: 1)),
                child: rowW(
                  mainAxisAlignment: "center",
                  children: [
                    // textW(
                    //   controller.selectedSanadType ?? "",
                    //   fontSize: 14,
                    //   textAlign: "center",
                    //   // fontWeight: "bold",
                    // ),
                    // textW(
                    //   "  رقم  ",
                    //   fontSize: 14,
                    //   textAlign: "center",
                    //   // fontWeight: "bold",
                    // ),
                    textW(
                      controller.savedSanadId.toString(),
                      fontSize: 14,
                      textAlign: "center",
                      // fontWeight: "bold",
                    ),
                  ],
                ),
              ),
            ),

            //Date
            expandedW(
              // flex: 1,
              child: containerW(
                padding: [5, 5, 5, 5],
                // margin: [0, 0, 10, 0],
                containerDecorationW: containerDecorationW(radius: 4, containerDecorationBorderW: containerDecorationBorderW(width: 1)),
                child: rowW(
                  mainAxisAlignment: "center",
                  children: [
                    textW("التاريخ", fontSize: 14),
                    textW("   :   ", fontSize: 14),
                    textW(controller.date.text, fontSize: 14),
                    // sizedBoxW(width: 10),
                  ],
                ),
              ),
            ),
          ],
        ),

        //content
        containerW(
          // height: 300,
          margin: [0, 5, 0, 0],
          padding: [5, 5, 5, 5],
          containerDecorationW: containerDecorationW(radius: 8, containerDecorationBorderW: containerDecorationBorderW(width: 0.5)),
          child: columnW(
            children: [
              // 1st  row
              rowW(
                children: [
                  expandedW(flex: 1, child: containerW(height: 32, margin: [1, 1, 1, 1], padding: [5, 5, 5, 5], containerDecorationW: containerDecorationW(radius: 4, containerDecorationBorderW: containerDecorationBorderW(width: 1)), child: textW("إستلمنا من المكرم"))),
                  expandedW(flex: 3, child: containerW(height: 32, margin: [1, 1, 1, 1], padding: [5, 5, 5, 5], containerDecorationW: containerDecorationW(radius: 4, containerDecorationBorderW: containerDecorationBorderW(width: 1)), child: textW(controller.selecetdCustomer!.cusName))),
                  expandedW(flex: 1, child: containerW(height: 32, margin: [1, 1, 1, 1], padding: [5, 5, 5, 5], containerDecorationW: containerDecorationW(radius: 4, containerDecorationBorderW: containerDecorationBorderW(width: 1)), child: textW("Recevied from Mr"))),
                ],
              ),

              //2nd row
              rowW(
                children: [
                  expandedW(flex: 1, child: containerW(height: 32, margin: [1, 1, 1, 1], padding: [5, 5, 5, 5], containerDecorationW: containerDecorationW(radius: 4, containerDecorationBorderW: containerDecorationBorderW(width: 1)), child: textW("مبلغ وقدره"))),
                  expandedW(flex: 3, child: containerW(height: 32, margin: [1, 1, 1, 1], padding: [5, 5, 5, 5], containerDecorationW: containerDecorationW(radius: 4, containerDecorationBorderW: containerDecorationBorderW(width: 1)), child: textW(convertToArabicWords(double.parse(controller.amount.text))))),
                  expandedW(flex: 1, child: containerW(height: 32, margin: [1, 1, 1, 1], padding: [5, 5, 5, 5], containerDecorationW: containerDecorationW(radius: 4, containerDecorationBorderW: containerDecorationBorderW(width: 1)), child: textW("The Amount"))),
                ],
              ),

              //3rd row
              rowW(
                children: [
                  expandedW(flex: 1, child: containerW(height: 32, margin: [1, 1, 1, 1], padding: [5, 5, 5, 5], containerDecorationW: containerDecorationW(radius: 4, containerDecorationBorderW: containerDecorationBorderW(width: 1)), child: textW("وذلك مقابل"))),
                  expandedW(flex: 3, child: containerW(height: 32, margin: [1, 1, 1, 1], padding: [5, 5, 5, 5], containerDecorationW: containerDecorationW(radius: 4, containerDecorationBorderW: containerDecorationBorderW(width: 1)), child: textW(controller.description.text))),
                  expandedW(flex: 1, child: containerW(height: 32, margin: [1, 1, 1, 1], padding: [5, 5, 5, 5], containerDecorationW: containerDecorationW(radius: 4, containerDecorationBorderW: containerDecorationBorderW(width: 1)), child: textW("As payment for"))),
                ],
              ),

              //3rd row
              rowW(
                children: [
                  expandedW(child: containerW(height: 32, margin: [1, 1, 1, 1], padding: [5, 5, 5, 5], containerDecorationW: containerDecorationW(color: "#F5F5F5", radius: 4, containerDecorationBorderW: containerDecorationBorderW(width: 1)), child: rowW(mainAxisAlignment: "center", children: [textW("مدخل السند"), textW("  <=>  "), textW(controller.userName)]))),
                ],
              ),
            ],
          ),
        ),
        //line bootom
        /*   rowW(
          children: [
            expandedW(
              child: containerW(
                containerDecorationW: containerDecorationW(
                  radius: 8,
                  containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                ),
              ),
            ),
          ],
        ),
   */
      ],
    ),
  );
}


*/
