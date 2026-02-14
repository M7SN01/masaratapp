import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../Widget/loding_dots.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../Controllers/cus_balance_controller.dart';
import '../../../../Widget/pick_date.dart';
import '../../../../utils/utils.dart';
import '../../../../Widget/widget.dart';

class CustomerBalance extends StatelessWidget {
  const CustomerBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CusBalanceController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text("ارصــدة العملاء"),
          centerTitle: true,
        ),
        body: Card(
          margin: EdgeInsets.all(10),

          elevation: 1,
          // surfaceTintColor: Colors.amberAccent,
          child: Column(
            children: [
              ////---------------------------------------------------------
              controller.dateSwitcher
                  ? Row(
                      children: [
                        // SizedBox(height: 45),
                        Expanded(
                          flex: 1,
                          child: switchW(
                            value: controller.dateSwitcher,
                            state: (val) {
                              controller.dateSwitcher = val;
                              controller.update();
                            },
                          ),
                        ),
                        PickDateW(
                          expandedFlix: 2,
                          labelText: "من تاريخ",
                          dateDontroller: controller.fromDateController,
                          onSelectionChanged: () {
                            controller.mnthDateController.text = "";
                            controller.update();
                          },
                        ),
                        const SizedBox(width: 10),
                        PickDateW(
                          expandedFlix: 2,
                          labelText: "الى تاريخ",
                          dateDontroller: controller.toDateController,
                          onSelectionChanged: () {
                            controller.mnthDateController.text = "";
                            controller.update();
                          },
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: switchW(
                            value: controller.dateSwitcher,
                            state: (val) {
                              controller.dateSwitcher = val;
                              controller.update();
                            },
                          ),
                        ),
                        PickMonthW(
                          expandedFlix: 4,
                          labelText: "شهر",
                          dateDontroller: controller.mnthDateController,
                          onSelectionChanged: () {
                            controller.fromDateController.text = "";
                            controller.toDateController.text = "";
                            controller.update();
                          },
                        ),
                      ],
                    ),

              SizedBox(height: 5),
              //---------------------------------------------------------
              Row(
                children: [
                  //chose customer
                  controller.selecetdCustomer != null
                      ? Expanded(
                          // flex: 1,
                          child: GestureDetector(
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                border: Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(5),
                                shape: BoxShape.rectangle,
                              ),
                              child: const Icon(Icons.clear, color: Colors.white),
                            ),
                            onTap: () {
                              controller.clearData();
                            },
                          ),
                        )
                      : Expanded(
                          // flex: 1,
                          child: GestureDetector(
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: controller.selecetdCustomer == null ? primaryColor : secondaryColor,
                                border: Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(5),
                                shape: BoxShape.rectangle,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.checklist_rounded, color: Colors.white),
                                  const SizedBox(width: 10),
                                  Text(
                                    "إختر عميل",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                useSafeArea: true,
                                context: context,
                                builder: (context) {
                                  return SearchListDialog(
                                    title: "اختر عميل",
                                    originalData: controller.cusData.map((e) => SearchList(id: e.cusId, name: e.cusName)).toList(),
                                    onSelected: (selectedItem) {
                                      controller.selecetdCustomer = controller.cusData.firstWhere((e) => e.cusId == selectedItem.id);
                                      controller.selecetdCustomer!.previousBalance = null;
                                      // controller.selectedCustomer = selectedItem.name;
                                      // controller.selectedInvCustomerId = selectedItem.name;
                                      controller.update();
                                      Get.back();
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        border: Border.all(
                          width: 1,
                          color: Colors.deepPurpleAccent,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                      ),
                      height: 45,
                      child: dropDownList(
                        enable: !controller.isPostedBefor,
                        initialText: "جميع التصنيفات",
                        iconColor: primaryColor,
                        chosedItem: controller.selectedCsClsName,
                        showedList: controller.csClsList.map((e) => e.cSClsName).toList(),
                        // disabledValues: controller.csClsList .where((e) => e.actId == 53 || e.actId == 57).map((e) => e.cSClsName).toList(),
                        callback: (val) {
                          final selected = controller.csClsList.firstWhere((e) => e.cSClsName == val);
                          if (selected.cSClsId == 0) {
                            controller.selectedCsClsName = null;
                            controller.selectedCsClsId = null;
                            controller.update();
                            return;
                          }
                          controller.selectedCsClsName = val;
                          controller.selectedCsClsId = selected.cSClsId.toString();
                          controller.update();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              controller.selecetdCustomer != null
                  ? Column(
                      children: [
                        Divider(height: 8),
                        Text(
                          controller.selecetdCustomer!.cusName,
                          style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        Divider(height: 8),
                      ],
                    )
                  : SizedBox(),
              //---------------------------------------------------------
              const SizedBox(height: 5),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      border: Border.all(
                        width: 1,
                        color: Colors.deepPurpleAccent,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                    height: 45,
                    width: 130,
                    child: dropDownList(
                      enable: !controller.isPostedBefor,
                      initialText: "حسب الرصيد",
                      iconColor: primaryColor,
                      chosedItem: controller.selectedCompareName,
                      showedList: controller.amountCompareList.map((e) => e.name).toList(),
                      callback: (val) {
                        final selected = controller.amountCompareList.firstWhere((e) => e.name == val);
                        // if (selected.id == 0) {
                        //   controller.selectedCompareName = null;
                        //   controller.selectedCompareId = null;
                        //   controller.update();
                        //   return;
                        // }
                        controller.selectedCompareName = val!;
                        controller.selectedCompareId = selected.id;
                        controller.update();
                      },
                    ),
                  ),

                  SizedBox(width: 5),

                  SizedBox(
                    height: 45,
                    width: 100,
                    child: TextFormField(
                      controller: controller.amount,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      textAlign: TextAlign.center,
                      cursorColor: primaryColor,
                      decoration: const InputDecoration(
                        labelText: "المبلغ",
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                        border: OutlineInputBorder(
                          gapPadding: 5,
                          borderSide: BorderSide(color: primaryColor, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 5),
                  //Search ...
                  controller.isPostingToApi
                      ? Expanded(
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(5),
                              shape: BoxShape.rectangle,
                            ),
                            child: Center(child: TextLodingDots(dot: "•")),
                          ),
                        )
                      : Expanded(
                          child: GestureDetector(
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                border: Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(5),
                                shape: BoxShape.rectangle,
                              ),
                              child: const Icon(Icons.search_rounded, color: Colors.white),
                            ),
                            onTap: () async {
                              await controller.getBalanceData();
                            },
                          ),
                        ),
                ],
              ),

              Divider(height: 8),
              Expanded(
                flex: 5,
                child: controller.isPostingToApi
                    ? Center(child: const CircularProgressIndicator())
                    : controller.rows.isNotEmpty
                        ? PlutoGrid(
                            mode: PlutoGridMode.selectWithOneTap,
                            columns: controller.columns,
                            rows: controller.rows,
                            onLoaded: (PlutoGridOnLoadedEvent event) {
                              controller.stateManager = event.stateManager;
                            },
                            onChanged: (event) {
                              // controller.update();
                            },
                            onRowSecondaryTap: (event) {
                              debugPrint("sssssssssssssssssssssssssssssssss");
                            },
                            // onRowDoubleTap: (event) {
                            //   // debugPrint("fffffffffffff00ffffff : ${event.cell.column.field}");
                            //   if (event.cell.column.field == 'QTY') {
                            //     int? rowIndex = event.rowIdx;
                            //     controller.editqty(rowIndex);
                            //     // event.row.
                            //   }
                            // },
                            // onSelected: (event) {
                            //   debugPrint("select .........................");
                            //   if (event.cell!.column.field == 'QTY') {
                            //     int? rowIndex = event.rowIdx;
                            //     if (rowIndex != null) {
                            //       controller.editqty(rowIndex);
                            //       // controller.stateManager!.clearCurrentCell();
                            //       // controller.stateManager!.setCurrentSelectingPosition(notify: false);
                            //       // event.selectedRows!.;
                            //     }
                            //   }
                            // },
                            configuration: configuration,
                            // createFooter: (stateManager) {
                            //   stateManager.createFooter;
                            //   return controller.customFooter();
                            // },
                          )
                        : Center(
                            child: const SizedBox(
                              child: Text("لا يوجد بيانات"),
                            ),
                          ),
              ),
            ],
          ),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        // floatingActionButton: Container(
        //   padding: const EdgeInsets.all(4),
        //   decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
        //   child: IconButton(
        //     onPressed: () {
        //       controller.printKshf();
        //     },
        //     icon: Icon(
        //       controller.rows.isEmpty ? Icons.print_disabled : Icons.print,
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
      ),
    );
  }
}


/*
class LoadingDotsText extends StatefulWidget {
  const LoadingDotsText({super.key});

  @override
  LoadingDotsTextState createState() => LoadingDotsTextState();
}

class LoadingDotsTextState extends State<LoadingDotsText> {
  int dotCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        dotCount = (dotCount + 1) % 4; // cycles from 0 to 3
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String dots = '.' * dotCount;
    return Text(
      "جاري احضار البيانات$dots",
      style: TextStyle(color: Colors.white),
    );
  }
}
*/