import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masaratapp/App/Widget/loding_dots.dart';
import '../../Controllers/cus_kshf_controller.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../Widget/pick_date.dart';
import '../../utils/utils.dart';
import '../../Widget/widget.dart';

class CustomerKshf extends StatelessWidget {
  const CustomerKshf({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CusKshfController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
            /*
          actions: [
            IconButton(
              onPressed: () {
                if (controller.selectedInvTypeId != null || controller.selecetdCustomer != null) {
                  Get.defaultDialog(
                    radius: 8,
                    title: "هل تريد حذف الفاتورة؟",
                    middleText: "لن تتمكن من استرجاعها لاحقًا",
                    confirm: ElevatedButton(
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
                      onPressed: () {
                        controller.clearInvoiceData();
                        Get.back();
                      },
                      child: Text("موافق"),
                    ),
                    cancel: ElevatedButton(
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("إلغاء"),
                    ),
                  );
                }
              },
              icon: Icon(
                Icons.delete_forever_rounded,
                color: secondaryColor,
              ),
            ),
          ],
          */
            ),
        body: Card(
          margin: EdgeInsets.all(10),

          elevation: 1,
          // surfaceTintColor: Colors.amberAccent,
          child: Column(
            children: [
              ///heder  inv type , customer
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
              //chose customer & Search ...
              Row(
                children: [
                  //chose customer
                  controller.selecetdCustomer != null
                      ? Expanded(
                          // flex: 1,
                          child: GestureDetector(
                            child: Container(
                              height: 40,
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
                              height: 40,
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

                  SizedBox(width: 5),
                  //Search ...
                  controller.isPostingToApi
                      ? Expanded(
                          child: Container(
                            height: 40,
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
                              height: 40,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                border: Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(5),
                                shape: BoxShape.rectangle,
                              ),
                              child: const Icon(Icons.search_rounded, color: Colors.white),
                            ),
                            onTap: () async {
                              await controller.getKshfData();
                            },
                          ),
                        ),
                ],
              ),

              controller.selecetdCustomer != null
                  ? Column(
                      children: [
                        Divider(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              controller.selecetdCustomer!.cusName,
                              style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            if (controller.selecetdCustomer!.previousBalance != null)
                              Text(
                                "الرصيد السابق  :  ${controller.selecetdCustomer!.previousBalance!.toStringAsFixed(2)}",
                                style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                          ],
                        )
                      ],
                    )
                  : SizedBox(),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
          child: IconButton(
            onPressed: () {
              controller.printKshf();
            },
            icon: Icon(
              controller.rows.isEmpty ? Icons.print_disabled : Icons.print,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

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
