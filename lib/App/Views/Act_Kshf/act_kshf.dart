import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masaratapp/App/Widget/loding_dots.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../Controllers/act_kshf_controller.dart';
import '../../Widget/pick_date.dart';
import '../../utils/utils.dart';
import '../../Widget/widget.dart';

class ActKshf extends StatelessWidget {
  const ActKshf({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ActKshfController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text("مراجعة الحراكات"),
          centerTitle: true,
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

              if (controller.selecetdCustomer != null) ...[
                Divider(height: 8),
                Text(
                  controller.selecetdCustomer!.cusName,
                  style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
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
                            configuration: configuration,
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