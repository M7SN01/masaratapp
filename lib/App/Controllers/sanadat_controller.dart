import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../Print/helpers/widgets_to_json.dart';

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

  Future<void> printSanad() async {
    isPostingToApi = false;
    update();
    // print("Waite while printing ..............");
    if (isPostedBefor) {
      await printJsondirectly(jsonLayout: getTestMap(), isfromJson: true);
    } else {
      showMessage(color: secondaryColor, titleMsg: "يرجى حفظ الفاتورة", titleFontSize: 18, durationMilliseconds: 1000);
    }
  }

  void previewSanad() {
    if (isPostedBefor) {
      Get.to(
        () => PdfPreviewScreen(
          // tableHeader: hesders,
          // tableData: data,
          jsonLayout: getTestMap(),

          variables: {},
        ),
      );
    } else {
      showMessage(color: secondaryColor, titleMsg: "يرجى حفظ الفاتورة", titleFontSize: 18, durationMilliseconds: 1000);
    }
  }

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
}

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
        //Comp Header
        sizedBoxW(
          height: 110,
          child: rowW(
            children: [
              //Comp Arabic
              expandedW(
                flex: 1,
                child: columnW(
                  crossAxisAlignment: "center",
                  children: [
                    textW(
                      controller.compData.aCompName,
                      // "شركة مسارات الجمال",
                      fontSize: 18,
                      // textAlign: "center",
                      fontWeight: "bold",
                    ),
                    textW(
                      controller.compData.aActivity,
                      // "لبيع العطور ومستحضرات التجميل",
                      fontSize: 14,
                      // textAlign: "center",
                      fontWeight: "bold",
                    ),
                    // sizedBoxW(height: 2),
                    if (controller.compData.commercialReg.isNotEmpty) rowW(mainAxisAlignment: "center", children: [textW("رقم السجل التجاري"), textW("  :  "), textW(controller.compData.commercialReg)]),
                    // sizedBoxW(height: 2),
                    if (controller.compData.taxNo.isNotEmpty)
                      rowW(
                        mainAxisAlignment: "center",
                        children: [
                          textW(
                            "الرقم الضريبي",
                            fontSize: 14,
                            // fontFamily: "arial",
                          ),
                          textW(
                            "  :  ",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                          textW(
                            controller.compData.taxNo,
                            // "310310589800003",
                            fontSize: 14,
                            // fontFamily: "arial",
                          ),
                        ],
                      ),
                    if (controller.compData.tel.isNotEmpty)
                      rowW(
                        mainAxisAlignment: "center",
                        children: [
                          textW(
                            "رقم الهاتف",
                            fontSize: 14,
                            // fontFamily: "arial",
                          ),
                          textW(
                            "  :  ",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                          textW(
                            controller.compData.tel,
                            // "310310589800003",
                            fontSize: 14,
                            // fontFamily: "arial",
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              //logo
              expandedW(flex: 1, child: containerW(padding: [0, 0, 0, 10], child: centerW(child: imageW(assetName: "assets/images/mlogo.png")))),
              //Comp english
              expandedW(
                flex: 1,
                child: columnW(
                  crossAxisAlignment: "center",
                  children: [
                    textW(
                      controller.compData.eCompName,
                      // "MASARAT AL-JAMAL",
                      fontSize: 18,
                      textAlign: "center",
                      fontWeight: "bold",
                    ),
                    textW(
                      controller.compData.eActivity,
                      // "For selling perfumes and cosmetics",
                      fontSize: 12,
                      textAlign: "center",
                      fontWeight: "bold",
                    ),
                    // sizedBoxW(height: 2),
                    if (controller.compData.commercialReg.isNotEmpty)
                      rowW(
                        mainAxisAlignment: "center",
                        children: [
                          textW(
                            controller.compData.commercialReg,
                            // "4030323869",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                          textW(
                            "  :  ",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                          textW(
                            "REG. NO.",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                        ],
                      ),
                    // sizedBoxW(height: 2),
                    if (controller.compData.taxNo.isNotEmpty)
                      rowW(
                        mainAxisAlignment: "center",
                        children: [
                          textW(
                            controller.compData.taxNo,
                            // "310310589800003",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                          textW(
                            "  :  ",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                          textW(
                            "TAX. NO. ",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                        ],
                      ),
                    if (controller.compData.tel.isNotEmpty)
                      rowW(
                        mainAxisAlignment: "center",
                        children: [
                          textW(
                            controller.compData.tel,
                            // "310310589800003",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                          textW(
                            "  :  ",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                          textW(
                            "Mobile No.",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        //header line
        rowW(children: [expandedW(child: containerW(containerDecorationW: containerDecorationW(containerDecorationBorderW: containerDecorationBorderW(width: 1))))]),
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

        //line Top
        /* rowW(
          children: [
            expandedW(
              child: containerW(
                margin: [0, 8, 0, 0],
                containerDecorationW: containerDecorationW(
                  radius: 8,
                  containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                ),
              ),
            ),
          ],
        ),
        */
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
                  expandedW(flex: 1, child: containerW(height: 32, margin: [1, 1, 1, 1], padding: [5, 5, 5, 5], containerDecorationW: containerDecorationW(radius: 4, containerDecorationBorderW: containerDecorationBorderW(width: 1)), child: textW("The Amount"))),
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


// {{x}}
/*

Map<String, dynamic> getTestMap() {
  final controller = Get.find<SanadatController>();
  return containerW(
    // w: 600,
    // h: 400,
    // width: mmToPixel(210),
    height: 328, //mmToPixel(297 / 3),

    padding: [10, 10, 10, 10],
    containerDecorationW: containerDecorationW(
      containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
      radius: 4,
    ),
    child: columnW(
      children: [
        //Comp Header
        sizedBoxW(
          height: 110,
          child: rowW(
            children: [
              //Comp Arabic
              expandedW(
                flex: 1,
                child: columnW(
                  crossAxisAlignment: "center",
                  children: [
                    textW(
                     "{{comp_name_a}}" ,
                      // "شركة مسارات الجمال",
                      fontSize: 18,
                      // textAlign: "center",
                      fontWeight: "bold",
                    ),
                    textW(
                      "{{a_activity}}",
                      // "لبيع العطور ومستحضرات التجميل",
                      fontSize: 14,
                      // textAlign: "center",
                      fontWeight: "bold",
                    ),
                    // sizedBoxW(height: 2),
                    if (controller.compData.commercialReg.isNotEmpty)
                      rowW(
                        mainAxisAlignment: "center",
                        children: [
                          textW(
                            "رقم السجل التجاري",
                          ),
                          textW(
                            "  :  ",
                          ),
                          textW(
                            "{{commercial_reg}}",
                          ),
                        ],
                      ),
                    // sizedBoxW(height: 2),
                    if (controller.compData.taxNo.isNotEmpty)
                      rowW(
                        mainAxisAlignment: "center",
                        children: [
                          textW(
                            "الرقم الضريبي",
                            fontSize: 14,
                            // fontFamily: "arial",
                          ),
                          textW(
                            "  :  ",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                          textW(
                            controller.compData.taxNo,
                            // "310310589800003",
                            fontSize: 14,
                            // fontFamily: "arial",
                          ),
                        ],
                      ),
                    if (controller.compData.tel.isNotEmpty)
                      rowW(
                        mainAxisAlignment: "center",
                        children: [
                          textW(
                            "رقم الهاتف",
                            fontSize: 14,
                            // fontFamily: "arial",
                          ),
                          textW(
                            "  :  ",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                          textW(
                            controller.compData.tel,
                            // "310310589800003",
                            fontSize: 14,
                            // fontFamily: "arial",
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              //logo
              expandedW(
                flex: 1,
                child: containerW(padding: [0, 0, 0, 10], child: centerW(child: imageW(assetName: "assets/images/mlogo.png"))),
              ),
              //Comp english
              expandedW(
                flex: 1,
                child: columnW(
                  crossAxisAlignment: "center",
                  children: [
                    textW(
                      controller.compData.eCompName,
                      // "MASARAT AL-JAMAL",
                      fontSize: 18,
                      textAlign: "center",
                      fontWeight: "bold",
                    ),
                    textW(
                      controller.compData.eActivity,
                      // "For selling perfumes and cosmetics",
                      fontSize: 12,
                      textAlign: "center",
                      fontWeight: "bold",
                    ),
                    // sizedBoxW(height: 2),
                    if (controller.compData.commercialReg.isNotEmpty)
                      rowW(
                        mainAxisAlignment: "center",
                        children: [
                          textW(
                            controller.compData.commercialReg,
                            // "4030323869",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                          textW(
                            "  :  ",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                          textW(
                            "REG. NO.",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                        ],
                      ),
                    // sizedBoxW(height: 2),
                    if (controller.compData.taxNo.isNotEmpty)
                      rowW(
                        mainAxisAlignment: "center",
                        children: [
                          textW(
                            controller.compData.taxNo,
                            // "310310589800003",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                          textW(
                            "  :  ",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                          textW(
                            "TAX. NO. ",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                        ],
                      ),
                    if (controller.compData.tel.isNotEmpty)
                      rowW(
                        mainAxisAlignment: "center",
                        children: [
                          textW(
                            controller.compData.tel,
                            // "310310589800003",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                          textW(
                            "  :  ",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                          textW(
                            "Mobile No.",
                            // fontSize: 12,
                            // fontFamily: "arial",
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        //header line
        rowW(
          children: [
            expandedW(
              child: containerW(
                containerDecorationW: containerDecorationW(
                  containerDecorationBorderW: containerDecorationBorderW(width: 1),
                ),
              ),
            ),
          ],
        ),
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
                containerDecorationW: containerDecorationW(
                  radius: 4,
                  containerDecorationBorderW: containerDecorationBorderW(width: 1),
                ),
                child: rowW(
                  mainAxisAlignment: "center",
                  children: [
                    textW("المبلغ", fontSize: 14),
                    textW("   :   ", fontSize: 14),
                    textW(controller.amount.text, fontSize: 14),
                    sizedBoxW(width: 10),
                    imageSvgW(
                      assetName: "assets/images/rs.svg",
                      height: 18,
                      width: 18,
                    ),
                  ],
                ),
              ),
            ),

            //sanad No
            expandedW(
              flex: 2,
              child: containerW(
                padding: [5, 5, 5, 5],
                margin: [10, 0, 10, 0],
                containerDecorationW: containerDecorationW(
                  radius: 4,
                  containerDecorationBorderW: containerDecorationBorderW(width: 1),
                ),
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
                containerDecorationW: containerDecorationW(
                  radius: 4,
                  containerDecorationBorderW: containerDecorationBorderW(width: 1),
                ),
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

        //line Top
        /* rowW(
          children: [
            expandedW(
              child: containerW(
                margin: [0, 8, 0, 0],
                containerDecorationW: containerDecorationW(
                  radius: 8,
                  containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                ),
              ),
            ),
          ],
        ),
        */
        //content
        containerW(
          // height: 300,
          margin: [0, 5, 0, 0],
          padding: [5, 5, 5, 5],
          containerDecorationW: containerDecorationW(
            radius: 8,
            containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
          ),
          child: columnW(
            children: [
              // 1st  row
              rowW(
                children: [
                  expandedW(
                    flex: 1,
                    child: containerW(
                      height: 32,
                      margin: [1, 1, 1, 1],
                      padding: [5, 5, 5, 5],
                      containerDecorationW: containerDecorationW(
                        radius: 4,
                        containerDecorationBorderW: containerDecorationBorderW(width: 1),
                      ),
                      child: textW("إستلمنا من المكرم"),
                    ),
                  ),
                  expandedW(
                    flex: 3,
                    child: containerW(
                      height: 32,
                      margin: [1, 1, 1, 1],
                      padding: [5, 5, 5, 5],
                      containerDecorationW: containerDecorationW(
                        radius: 4,
                        containerDecorationBorderW: containerDecorationBorderW(width: 1),
                      ),
                      child: textW(controller.selecetdCustomer!.cusName),
                    ),
                  ),
                  expandedW(
                    flex: 1,
                    child: containerW(
                      height: 32,
                      margin: [1, 1, 1, 1],
                      padding: [5, 5, 5, 5],
                      containerDecorationW: containerDecorationW(
                        radius: 4,
                        containerDecorationBorderW: containerDecorationBorderW(width: 1),
                      ),
                      child: textW("Recevied from Mr"),
                    ),
                  ),
                ],
              ),

              //2nd row
              rowW(
                children: [
                  expandedW(
                    flex: 1,
                    child: containerW(
                      height: 32,
                      margin: [1, 1, 1, 1],
                      padding: [5, 5, 5, 5],
                      containerDecorationW: containerDecorationW(
                        radius: 4,
                        containerDecorationBorderW: containerDecorationBorderW(width: 1),
                      ),
                      child: textW("مبلغ وقدره"),
                    ),
                  ),
                  expandedW(
                    flex: 3,
                    child: containerW(
                      height: 32,
                      margin: [1, 1, 1, 1],
                      padding: [5, 5, 5, 5],
                      containerDecorationW: containerDecorationW(
                        radius: 4,
                        containerDecorationBorderW: containerDecorationBorderW(width: 1),
                      ),
                      child: textW(convertToArabicWords(double.parse(controller.amount.text))),
                    ),
                  ),
                  expandedW(
                    flex: 1,
                    child: containerW(
                      height: 32,
                      margin: [1, 1, 1, 1],
                      padding: [5, 5, 5, 5],
                      containerDecorationW: containerDecorationW(
                        radius: 4,
                        containerDecorationBorderW: containerDecorationBorderW(width: 1),
                      ),
                      child: textW("The Amount"),
                    ),
                  ),
                ],
              ),

              //3rd row
              rowW(
                children: [
                  expandedW(
                    flex: 1,
                    child: containerW(
                      height: 32,
                      margin: [1, 1, 1, 1],
                      padding: [5, 5, 5, 5],
                      containerDecorationW: containerDecorationW(
                        radius: 4,
                        containerDecorationBorderW: containerDecorationBorderW(width: 1),
                      ),
                      child: textW("وذلك مقابل"),
                    ),
                  ),
                  expandedW(
                    flex: 3,
                    child: containerW(
                      height: 32,
                      margin: [1, 1, 1, 1],
                      padding: [5, 5, 5, 5],
                      containerDecorationW: containerDecorationW(
                        radius: 4,
                        containerDecorationBorderW: containerDecorationBorderW(width: 1),
                      ),
                      child: textW(controller.description.text),
                    ),
                  ),
                  expandedW(
                    flex: 1,
                    child: containerW(
                      height: 32,
                      margin: [1, 1, 1, 1],
                      padding: [5, 5, 5, 5],
                      containerDecorationW: containerDecorationW(
                        radius: 4,
                        containerDecorationBorderW: containerDecorationBorderW(width: 1),
                      ),
                      child: textW("The Amount"),
                    ),
                  ),
                ],
              ),

              //3rd row
              rowW(
                children: [
                  expandedW(
                    child: containerW(
                        height: 32,
                        margin: [1, 1, 1, 1],
                        padding: [5, 5, 5, 5],
                        containerDecorationW: containerDecorationW(
                          color: "#F5F5F5",
                          radius: 4,
                          containerDecorationBorderW: containerDecorationBorderW(width: 1),
                        ),
                        child: rowW(mainAxisAlignment: "center", children: [
                          textW("مدخل السند"),
                          textW("  <=>  "),
                          textW(controller.userName),
                        ])),
                  ),
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