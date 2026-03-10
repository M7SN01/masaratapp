import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../table_view/table.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widget/pick_date.dart';
import '../../../../../widget/widget.dart';
import '../../controller/cus_aging_controller.dart';
import 'grid_columns.dart';

class CustomersAging extends StatelessWidget {
  const CustomersAging({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomersAgingController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text("اعمار الديون"),
          centerTitle: true,
        ),
        body: _body(),
      ),
    );
  }
}

Widget _body() {
  return GetBuilder<CustomersAgingController>(
    builder: (controller) => Container(
      // width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(right: 20, left: 20, bottom: 5, top: 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        children: [
          optionSwitcher(
            duration: const Duration(microseconds: 500),
            searchOptions: const SearchOptions(),
            isShowed: controller.optionShow,
            state: (val) {
              controller.optionShow = !controller.optionShow;
              controller.update();
            },
          ),
          Expanded(child: tableView(tableOPtions: controller.fullViewTableOptions(columns: CustomersAgingColumns().getColumns))),
        ],
      ),
    ),
  );
}

class SearchOptions extends StatelessWidget {
  const SearchOptions({super.key});

  @override
  Widget build(BuildContext context) {
    double filedHeight = 50;
    return GetBuilder<CustomersAgingController>(
      builder: (controller) => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text("من سنة "),
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
                          initialText: "",
                          iconColor: primaryColor,
                          chosedItem: controller.selectedAccountYear,
                          showedList: controller.accountYearList.map((e) => e.name).toList(),
                          // disabledValues: controller.csClsList .where((e) => e.actId == 53 || e.actId == 57).map((e) => e.cSClsName).toList(),
                          callback: (val) {
                            // final selectedId = controller.accountYearList.firstWhere((e) => e.name == val).id;

                            controller.selectedAccountYear = controller.accountYearList.firstWhere((e) => e.name == val).name;
                            controller.selectedAccountYearId = controller.accountYearList.firstWhere((e) => e.name == val).id;
                            controller.update();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              PickDateW(
                filedHeight: filedHeight,
                showClearIcon: false,
                expandedFlix: 1,
                labelText: "الى تاريخ",
                dateDontroller: controller.toDateController,
                onSelectionChanged: () {
                  // controller.toDateController.text = "";
                  controller.update();
                },
              ),
            ],
          ),

          const SizedBox(
            height: 5,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              controller.selectedslsMan != null
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.clear, color: Colors.white),
                              const SizedBox(width: 10),
                              Text(
                                "إلغاء إختيار المندوب",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          controller.selectedslsMan = null;
                          controller.update();
                        },
                      ),
                    )
                  : Expanded(
                      flex: 1,
                      child: GestureDetector(
                        child: Container(
                          // margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          // width: (MediaQuery.of(context).size.width / 2) - 25,
                          height: filedHeight,
                          decoration: BoxDecoration(
                            color: controller.selectedslsMan == null ? primaryColor : secondaryColor,
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(5),
                            shape: BoxShape.rectangle,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.checklist_rounded,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "مناديب",
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                                title: "إختر مندوب",
                                originalData: controller.slsManOrignalData,
                                onSelected: (selectedItem) {
                                  controller.selectedslsMan = controller.slsManOrignalData.firstWhere((e) => e.id == selectedItem.id);

                                  controller.update();
                                  Get.back();
                                },
                              );
                              // return CheckboxListWithSearch(
                              //   title: "إختر مندوب",
                              //   originalData: controller.slsManOrignalData,
                              //   OnSave: (filteredOptions) {
                              //     controller.selectedslsMan = filteredOptions
                              //         .where((element) => element.state) // Filter elements where state is true
                              //         .map((element) => "${element.id}")
                              //         .join(',');
                              //     // print(_selectedslsMan);
                              //     controller.slsManOrignalData = filteredOptions;

                              //     controller.selectedslsMan;
                              //     controller.update();
                              //   },
                              // );
                            },
                          );
                        },
                      ),
                    ),
              const SizedBox(width: 5),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.clear, color: Colors.white),
                              const SizedBox(width: 10),
                              Text(
                                "إلغاء إختيار العميل",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
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

              /*
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    // margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    // width: (MediaQuery.of(context).size.width / 2) - 25,
                    height: filedHeight,
                    decoration: BoxDecoration(
                      color: selectedslsManGroupId == "" ? Colors.redAccent : const Color.fromARGB(255, 3, 192, 101),
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(5),
                      shape: BoxShape.rectangle,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.checklist_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          currentLang["SLS_CNTR_GRP"] ?? "",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      useSafeArea: true,
                      context: context,
                      builder: (context) {
                        return CheckboxListWithSearch(
                          title: currentLang["CHS_SLS_CNTR_GRP"] ?? "",
                          originalData: _slsCntrGrpOrignalData,
                          OnSave: (filteredOptions) {
                            selectedslsManGroupId = filteredOptions
                                .where((item) => item.state) // Filter items where state is true
                                .map((item) => "'${item.id}'")
                                .join(',');
                            // print(_selectedslsMan);
                            _slsCntrGrpOrignalData = filteredOptions;
                            setState(() {
                              selectedslsManGroupId;
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              */
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: controller.loadingData
                    ? Container(
                        height: filedHeight,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(5),
                          shape: BoxShape.rectangle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            controller.loadingData = false;
                            controller.update();
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Container(
                        height: filedHeight,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(5),
                          shape: BoxShape.rectangle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            controller.getdata();
                          },
                          icon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
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
                    // Divider(height: 8),
                  ],
                )
              : SizedBox(),
          const SizedBox(height: 10),
          const Divider(
            color: Colors.blueGrey,
            height: 1,
            thickness: 0.5,
          ),
          const SizedBox(height: 5),
          //  const Divider(color: Colors.grey,height: 1,thickness: 10,)
        ],
      ),
    );
  }
}
